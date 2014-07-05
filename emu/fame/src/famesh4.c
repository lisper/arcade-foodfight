/****************************************************************************/
/* Emulador de 68000 para SuperH4 RISC Engine (Dreamcast)                   */
/* Emisor de ensamblador (fame.s - GAS)                                     */
/* Autor: Oscar Orallo Pelaez                                               */
/* Fecha de comienzo: 08-06-2004                                            */
/* Ultima revision: 14-02-2006                                              */
/****************************************************************************/
/****************************************************************************/
/* USO DE REGISTROS SH4                                                     */
/*                                                                          */
/* R0 = uso temporal                                                        */
/* R1 = uso temporal                                                        */
/* R2 = instruccion actual                                                  */
/* R3 = dato principal                                                      */
/* R4 = direccion principal                                                 */
/* R5 = desplazamiento base del PC                                          */
/* R6 = PC incluyendo la base                                               */
/* R7 = contador de ciclos de reloj                                         */
/* R8 = cached CCR (VCN)                                                    */
/* R9 = bandera X                                                           */
/* R10 = cached BS                                                          */
/* R11 = fetch index address                                                */
/* R12 = jump table address (para saltos en execloop)                       */
/* R13 = data register set address                                          */
/* R14 = address register set address                                       */
/****************************************************************************/
/****************************************************************************/
/* execinfo (informacion acerca de la ejecucion de la CPU)                  */
/* bit 0 -> 1=CPU running; 0=cpu stopped                                    */
/* bit 1 -> si se emulan excepciones GRUPO 0 -> 1=procesando excep. grupo 0 */
/*          si no se emulan -> 1=PC fuera de limites                        */
/* bit 2 -> si se emulan excepciones grupo 0 -> 1=doble error de bus        */
/* bit 3 -> modo traza pendiente de atencion                                */
/* bit 4 -> atendiendo excepcion de modo traza                              */
/* bit 5 -> atendiendo error de bus                                         */
/* bit 6 -> atendiendo error de direccion                                   */
/* bit 7 -> 0 = CPU not stopped; 1 = CPU stopped (STOP instruction)         */
/* bits [8-15] -> sin usar                                                  */
/****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

/* Version del emisor */
#define VERSION "2.0a (14-03-2006)"

/* Tamano de datos */
#define BYTE 1
#define WORD 2
#define LONG 4

/* Tipos de acceso a memoria (programa y datos) */
#define PROGRAM_TYPE 0
#define READ_DATA_TYPE 1
#define WRITE_DATA_TYPE 2

/* Tamaños de las estructuras de definicion de mapas de memoria */
#define FETCH_STRUCT_SIZE 12
#define DATA_STRUCT_SIZE 16

/* Errores de bus y de direccion */
#define ADDRESS_ERROR 0
#define BUS_ERROR 1

/* Codigos de condicion */
#define T_CC 0x0
#define F_CC 0x1
#define HI_CC 0x2
#define LS_CC 0x3
#define CC_CC 0x4
#define CS_CC 0x5
#define NE_CC 0x6
#define EQ_CC 0x7
#define VC_CC 0x8
#define VS_CC 0x9
#define PL_CC 0xa
#define MI_CC 0xb
#define GE_CC 0xc
#define LT_CC 0xd
#define GT_CC 0xe
#define LE_CC 0xf

/* Posiciones de registros en el tipo enum m68k_register */
/* para uso en las funciones Xet_register */
#define M68K_REG_ASP 16
#define M68K_REG_PC 17
#define M68K_REG_SR 18

/* Tipo de registro (datos o direccion) */
/* para cargas a registros SH           */
#define DATA_REG 0
#define ADDR_REG 1

/* Tipo de acceso a memoria */
/* para carga de palabra larga SH */
#define DW_AIND 0
#define DW_AINC 1

/* Definicion de tipos basicos */
typedef unsigned char  byte;
typedef unsigned short word;
typedef unsigned int   dword;

/* Constantes auxiliares */
static char *sizename[5] = {"-", "byte", "word", "-", "dword"};
static char sizeid[5] = {'-','b','w','-','l'};
static int quickvalue[8] = {8, 1, 2, 3, 4, 5, 6, 7};
static char direction[2] = {'r','l'};
static int use_idxr = 0;    /* Uso de registro indice (pci) */

/* Fichero de salida */
static FILE *fp;

/* Numero de linea para la generacion de etiquetas */
static int lntag=0;

/* Etiquetas de codigo de condicion */
static char cctag;
static char rctag;


/**********************************************/
/* Variables modificadoras del codigo emitido */
/**********************************************/

/* Ancho en bits del bus de direcciones */
static int addr_bits=24;

/* Lecturas dummy */
static int dummyreads=1;

/* Emular comportamiento no documentado (banderas) */
/* ABCD (N y V), SBCD (N y V), NBCD (N y V) y CHK (Z, V y C) */
static int emulate_undoc=1;

/* Emular las excepciones de nivel 0 */
/* Error de bus, error de direccion y doble error de bus/direccion */
static int emulate_group_0=1;

/* Espacio de memoria multiple: usuario y supervisor */
static int multiaddr=1;

/* Realizar calculo preciso de ciclos de reloj */
static int exact_timing=1;

/* Cacheo de mapas de memoria (aumenta la velocidad y el tamaño del codigo) */
static int direct_mapping=0;

/* Contador interno de ciclos de reloj */
static int cycles_counting=1;

/* Estado bit0 de execinfo (estado de ejecucion de la CPU) */
static int bit0_execinfo=1;

/* Emular excepciones de traza */
static int emulate_trace=1;

/* Emular acceso a dos bancos de memoria en una sola operacion */
static int multi_bank=1;

/* Prefijo de los nombres de funcion */
static char *fprefix=NULL;

/* Contar ciclos empleados en generacion IRQ */
static int irq_cycles=1;

/* Comprobar saltos (errores de direccion) */
static int check_branches=0;


/******************************************************************************/

/******************************************************************************/
/* MODOS DE DIRECCIONAMIENTO                                                  */
/* La nomenclatura utilizada es la siguiente                                  */
/* DREG: Data REGister Direct Mode                                            */
/* AREG: Address REGister Direct Mode                                         */
/* AIND: Address Register INDirect Mode                                       */
/* AINC: Address Register Indirect with PostINCrement Mode                    */
/* ADEC: Address Register Indirect with PreDECrement Mode                     */
/* ADSP: Address Register Indirect with DiSPlacement Mode                     */
/* AXDP: Address Register Indirect with Index (8-bit displacement) Mode       */
/* ABSW: Address Register Indirect with Index (16-bit BaSe displacement) Mode */
/* ABSL: Address Register Indirect with Index (32-bit BaSe displacement) Mode */
/* PCDP: Program Counter Indirect with DisPlacement Mode                      */
/* PCXD: Program Counter Indirect with Index (8-bit Displacement) Mode        */
/* IMMD: IMMediate Data                                                       */
/******************************************************************************/

enum eamode
{
	dreg, areg, aind, ainc, adec, adsp,
	axdp, absw, absl, pcdp, pcxd, immd
};

/**************************************************************************/
/* Tablas de precalculo para los ciclos de reloj para la instruccion MOVE */
/**************************************************************************/

/* Tamano BYTE y WORD */
static byte move_bw_cycles[12][9]={4,4,8,8,8,12,14,12,16, \
				   4,4,8,8,8,12,14,12,16, \
				   8,8,12,12,12,16,18,16,20, \
				   8,8,12,12,12,16,18,16,20, \
				   10,10,14,14,14,18,20,18,22, \
				   12,12,16,16,16,20,22,20,24, \
				   14,14,18,18,18,22,24,22,26, \
				   12,12,16,16,16,20,22,20,24, \
				   16,16,20,20,20,24,26,24,28, \
				   12,12,16,16,16,20,22,20,24, \
				   14,14,18,18,18,22,24,22,26, \
				   8,8,12,12,12,16,18,16,20};

/* Tamano LONG */
static byte move_l_cycles[12][9]={4,4,12,12,12,16,18,16,20, \
				 4,4,12,12,12,16,18,16,20, \
				 12,12,20,20,20,24,26,24,28, \
				 12,12,20,20,20,24,26,24,28, \
				 14,14,22,22,22,26,28,26,30, \
				 16,16,24,24,24,28,30,28,32, \
				 18,18,26,26,26,30,32,30,34, \
				 16,16,24,24,24,28,30,28,32, \
				 20,20,28,28,28,32,34,32,36, \
				 16,16,24,24,24,28,30,28,32, \
				 18,18,26,26,26,30,32,30,34, \
				 12,12,20,20,20,24,26,24,28};


/* Variables auxiliares */
static enum eamode main_ea;       /* Modo fuente de direccionamiento efectivo */
static enum eamode main_dest_ea;  /* Modo destino de direccionamiento efectivo */
static int main_size;             /* Tamano del operando (BYTE(1), WORD(2) o LONG(4)) */
static int sizedef;               /* Tamano de campo en la instruccion */
static int main_reg;              /* Numero de registro */
static int main_cc;               /* Codigo de condicion (0-F) */
static int main_dr;               /* Direccion (derecha o izquierda) */
static int main_ir;               /* Inmediato o registro (para desplazamientos) */
static int main_qv;               /* Usado para la carga de valores inmediatos de direccionamiento */
static char bf_tag[20];           /* Direccion de memoria de la funcion basefunction */

/************************************************************************/
/* Prototipos de funcion						                        */
/************************************************************************/

/* Realiza un calculo de la base con cache de region */
void get_new_pc(char *bf_addr);

/* Salva el contenido del registro del SH4 en la pila */
static void save_reg(char *name);

/* Restaura el contenido del registro del SH4 en la pila */
static void restore_reg(char *name);

static void flush_irqs(int ln);

/************************************************************************/

/* Emisor de lineas formateadas */
static void emit(const char *fmt, ...)
{
	va_list a;

	va_start(a, fmt);
	if(fp)
	{
		vfprintf(fp, fmt, a);
		fprintf(fp, "\n");
	}
	else
	{
		fprintf(stderr, "ERROR: Error al escribir en fichero de salida\n");
		exit(1);
	}
}

/* Emisor de lineas formateadas sin salto de linea al final */
static void emit_il(const char *fmt, ...)
{
	va_list a;

	va_start(a, fmt);
	if(fp)
	{
		vfprintf(fp, fmt, a);
	}
	else
	{
		fprintf(stderr, "ERROR: Error al escribir en fichero de salida\n");
		exit(1);
	}
}

/* Imprime el estado de la opcion (ON/OFF) al stream especificado */
void write_opt(int var, FILE *stream)
{
	fprintf(stream,"%s\n",var?"(ON)":"(OFF)");
}

/* Imprime la información relacionada con el código generado */
void code_generation_info(FILE *stream)
{
	char cs[2];

	strcpy(cs,(stream == stderr)?"":"!");

	fprintf(stream,"%s Opciones de generacion empleadas:\n",cs);

	/* Formato de generación */
	fprintf(stream,"%s - Formato de generacion SH4 (compilador GNU)\n",cs);

	/* Ancho en bits del bus de direcciones */
	fprintf(stream,"%s - Bus de direcciones de %d bits\n",cs,addr_bits);

	/* Emulacion de lecturas tontas */
	fprintf(stream,"%s - Emulacion de lecturas tontas ",cs);
	write_opt(dummyreads,stream);

	/* Emular comportamiento no documentado */
	fprintf(stream,"%s - Emulacion de comportamiento no documentado ",cs);
	write_opt(emulate_undoc,stream);

	/* Espacio de memoria */
	fprintf(stream,"%s - Espacio de memoria ",cs);
	if (multiaddr)
		fprintf(stream,"multiple (usuario y supervisor)\n");
	else
		fprintf(stream,"unico (supervisor)\n");

	/* Emulación de excepciones de nivel 0 */
	fprintf(stream,"%s - Emulacion de excepciones del grupo 0 ",cs);
	write_opt(emulate_group_0,stream);

	/* Prefijo del nombre de las funciones de la API */
	fprintf(stream,"%s - Prefijo del nombre de las funciones: %s\n",cs, fprefix);

	/* Realizar calculo de ciclos no preciso */
	fprintf(stream,"%s - Realizar calculo preciso de ciclos de reloj ",cs);
	write_opt(exact_timing,stream);

	/* Uso de mapas de memoria cacheados (directos) */
	fprintf(stream,"%s - Cachear descriptores de mapas de memoria ",cs);
	write_opt(direct_mapping,stream);

	/* Realizar cuenta interna de ciclos de reloj */
	fprintf(stream,"%s - Realizar cuenta interna de ciclos de reloj ",cs);
	write_opt(cycles_counting,stream);

	/* Realizar cuenta interna de ciclos de reloj */
	fprintf(stream,"%s - Emular bit 0 de execinfo ",cs);
	write_opt(bit0_execinfo,stream);

	/* Emular excepcion de traza */
	fprintf(stream,"%s - Emular excepcion de traza ",cs);
	write_opt(emulate_trace,stream);

	/* Emular acceso a dos bancos de memoria en una sola operacion */
	fprintf(stream,"%s - Emular accesos en dos regiones de memoria ",cs);
	write_opt(multi_bank,stream);

	/* No contar ciclos de generacion de las IRQs */
	fprintf(stream,"%s - Contar ciclos de generacion de las IRQs ",cs);
	write_opt(irq_cycles,stream);

	/* Comprobar saltos (errores de direccion) */
	fprintf(stream,"%s - Chequear errores de direccion en saltos ",cs);
	write_opt(check_branches,stream);

	fprintf(stream,"%s ---------------------------------------------------\n",cs);
}

/* Imprime cabecera del fichero ensamblador */
static void gen_header(void)
{
	emit("! --------------------------------------------------");
	emit("! Fast and Accurate Motorola 68000 Emulation Library");
	emit("! FAME SH4 version %s",VERSION);
	emit("! Oscar Orallo Pelaez");
	emit("! Assembly file generated on "__DATE__" "__TIME__"");
	emit("! --------------------------------------------------");
	code_generation_info(fp);
}

/* Alineamiento de memoria */
/* Reserva los bytes necesarios para alinear a orden n */
static void align(int n)
{
	emit(".align %d",n);
}

/* Enmascara direccion a 24 bits */
static void maskaddress(char *reg)
{
	if (addr_bits < 32)    /* Si es menor, enmascara a 24 bits (68k addr. space) */
	{
		emit("shll8 %s",reg);
		emit("shlr8 %s",reg);
	}
}

/* Incrementar puntero a opcodes */
/* El tamano del opcode es de 16 bits (2 bytes) */
static void inc_ptr_opcodes(void)
{
	emit("add #2,r6");     /* incrementar opcode ptr */
}

/* Carga el opcode de la memoria */
/* incrementando el ptr de los opcodes */
static void load_opcode(void)
{
	emit("mov.w @r6+,r0");	    /* Cargar opcode en r2 (extiende la palabra!) */
	emit("shll2 r0");           /* por 4 */
	emit("mov.l @(r0,r12),r4");
}

/* Ejecuta la instruccion actual */
static void exec_opcode(void)
{
	emit("jmp @r4");	        /* A ejecutar! (ojo q es retardada) */
	emit("mov #0x1C,r2");       /* mascara de registro en opcode */
}

/* Generar cabeceras de funciones exportables */
static void gen_proc_header(char* name)
{
	align(5);
	emit(".global _%s_%s", fprefix, name);
	emit("_%s_%s:", fprefix, name);
}

/* Generar variables: Contexto del procesador y variables de estado y condicion */
static void gen_vars(void)
{
	emit(".data");

	align(5);
	emit(".global _m68kcontext");
	emit("_m68kcontext:");
	emit("contextbegin:");              /* Comienzo de contexto 68k */

	/* Mapa de memoria en uso */
	emit("fetch:     .long 0");         /* Puntero a zona de programa */
	emit("readbyte:  .long 0");         /* Puntero a lectura de byte */
	emit("readword:  .long 0");         /* Puntero a lectura de word */
	emit("writebyte: .long 0");         /* Puntero a escritura de byte */
	emit("writeword: .long 0");         /* Puntero a escritura de word */
	/* Mapa de supervisor */
	emit("s_fetch:     .long 0");       /* Puntero a zona de programa supervisor */
	emit("s_readbyte:  .long 0");       /* Puntero a lectura de byte supervisor */
	emit("s_readword:  .long 0");       /* Puntero a lectura de word supervisor */
	emit("s_writebyte: .long 0");       /* Puntero a escritura de byte supervisor */
	emit("s_writeword: .long 0");       /* Puntero a escritura de word supervisor */
	/* Mapa de usuario */
	emit("u_fetch:     .long 0");       /* Puntero a zona de programa usuario */
	emit("u_readbyte:  .long 0");       /* Puntero a lectura de byte usuario */
	emit("u_readword:  .long 0");       /* Puntero a lectura de word usuario */
	emit("u_writebyte: .long 0");       /* Puntero a escritura de byte usuario */
	emit("u_writeword: .long 0");       /* Puntero a escritura de word usuario */
	
	emit("resethandler: .long 0");      /* Manejador del reset */
	emit("iackhandler:  .long 0");      /* Manejador del interrupt acknowledge */
	emit("icusthandler: .long 0");      /* Puntero a tabla de manejadores de interrupciones/excepciones */

	emit("reg:");                       /* Zona de registros 68k */
	emit("dreg: .long 0,0,0,0,0,0,0,0");/* Registros de datos */
	emit("areg: .long 0,0,0,0,0,0,0");  /* Registros de direcciones */
	emit("a7:   .long 0");              /* Puntero de pila SSP-USP */
	emit("asp:  .long 0");              /* Puntero de pila auxiliar */
	emit("pc:   .long 0");              /* Contador de programa */
	emit("cycles_counter: .long 0");    /* Contador de ciclos ejecutados */
	/* Bit 0 de interrupts = 0 -> manual down irqs */
	emit("interrupts: .byte 0,0,0,0,0,0,0,0");/* Tabla de control de interrupciones */
	emit("sreg: .word 0");              /* Registro de estado BS+CCR */
	emit("execinfo: .word 0");          /* Variable que contiene el estado de ejecucion */
	emit("contextend:");                /* Fin de contexto */

	emit("execexit_addr: .long execexit"); /* Direccion codigo de salida */
	if (cycles_counting || emulate_trace)
		emit("cycles_needed:    .long 0");  /* Contador de ciclos ejecutados */
	emit("io_cycle_counter: .long -1"); /* Contador de ciclos (temporal) */
	emit("io_fetchbase:     .long 0");  /* Base del mapa de memoria (temporal) */
	emit("io_fetchbased_pc: .long 0");  /* PC con la base (temporal) */
	
	/* Vector de punteros para acceso directo a datos para uso funcion fetch */
	if (direct_mapping)
		if (multiaddr)
			emit("fetch_vector:	    .long sfmhtbl, srwmhtbl, ufmhtbl, urwmhtbl");
		else
			emit("fetch_vector:	    .long sfmhtbl, srwmhtbl");
	else
		emit("fetch_vector:     .long s_fetch, s_readword, u_fetch, u_readword");

	emit("fetch_idx:        .long 0");      /* Indice para accesos a programa */

	if (direct_mapping)
	{
		emit("readbyte_idx:     .long 0");  /* Indice para lectura de byte */
		emit("readword_idx:     .long 0");  /* Indice para lectura de word */
		emit("writebyte_idx:    .long 0");  /* Indice para escritura de byte */
		emit("writeword_idx:    .long 0");  /* Indice para escritura de word */
	}

	/* Direccion de rutina de decodificacion de palabra extendida */
	emit("decode_extw_addr: .long decode_extw");

	if (emulate_group_0 || check_branches)
	{
		emit("g0_spec_info: .byte 0");      /* Informacion relativa a las excep. grupo 0 */
		emit("filler:       .byte 0,0,0");  /* Relleno alineamiento */
	}

	/* Punteros a los manejadores de memoria */
	emit("rb_addr: .long readmemorybyte");
	emit("rw_addr: .long readmemoryword");
	emit("rl_addr: .long readmemorydword");
	emit("wb_addr: .long writememorybyte");
	emit("ww_addr: .long writememoryword");
	emit("wl_addr: .long writememorydword");

	if (direct_mapping)
	{
		/* Tablas de indices para acceso a lista de regiones */
		emit("sfmhtbl:");
		emit(".rept 4096\n .long 0\n .endr");
		emit("srbmhtbl:");
		emit(".rept 4096\n .long 0\n .endr");
		emit("srwmhtbl:");
		emit(".rept 4096\n .long 0\n .endr");
		emit("swbmhtbl:");
		emit(".rept 4096\n .long 0\n .endr");
		emit("swwmhtbl:");
		emit(".rept 4096\n .long 0\n .endr");
		
		/* Si es espacio multiple de memoria, incluir usuario */
		if (multiaddr)
		{
			emit("ufmhtbl:");
			emit(".rept 4096\n .long 0\n .endr");
			emit("urbmhtbl:");
			emit(".rept 4096\n .long 0\n .endr");
			emit("urwmhtbl:");
			emit(".rept 4096\n .long 0\n .endr");
			emit("uwbmhtbl:");
			emit(".rept 4096\n .long 0\n .endr");
			emit("uwwmhtbl:");
			emit(".rept 4096\n .long 0\n .endr");
		}
	}

	if (emulate_group_0 || check_branches)
	{
		/* Puntero utilizado en la gestión de excepciones grupo 0 */
		emit("excep_ptr:  .long 0");
		/* Datos utilizados en la gestión de excepciones grupo 0 */
		emit("inst_reg:   .word 0");      /* Codigo de operacion que causo la excepcion */
		emit("filler2:    .word 0");
	}
}

/*************************************************************/
/* Carga un reg. del SH4 con el contenido de un reg. 68k     */
/* reg = indice del registro (= -1 idx. en r2)               */
/* shreg = registro destino                                  */
/* reg_type = de datos o de direccion                        */
/* size = tamano de la carga                                 */
/*************************************************************/
static void reg2sh(int reg, char *shreg, int reg_type, int size)
{
	if (reg == -1)
	{
		emit("mov r2,r0");
		emit("mov.%c @(r0,%s),%s",sizeid[size],(reg_type == DATA_REG)?"r13":"r14",shreg);
	}
	else
	{
		if (size != LONG)
		{
			if ((reg == 0) && (reg_type == DATA_REG))
				emit("mov.%c @r13,%s",sizeid[size],shreg);
			else
			{
				emit("mov #%d,r0",(reg*4)+(reg_type*32));
				emit("mov.%c @(r0,r13),%s",sizeid[size],shreg);
			}
		}
		else
		{
			if ((reg == 0) && (reg_type == DATA_REG))
				emit("mov.l @r13,%s",shreg);
			else
				emit("mov.l @(%d,r13),%s",(reg*4)+(reg_type*32),shreg);
		}
	}
}

/* Con precalculo de registro indice (r2) */
static void reg2shpci(int reg, char *shreg, int reg_type, int size)
{
	if (reg == -1)
	{
		emit("add %s,r2",(reg_type == DATA_REG)?"r13":"r14");
		emit("mov.%c @r2,%s",sizeid[size], shreg);
	}
	else
	{
		reg2sh(reg,shreg,reg_type,size);
	}
}

/*************************************************************/
/* Carga un reg. del SH4 con el contenido de un reg. 68k     */
/* reg = indice del registro (= -1 idx. en r2)               */
/* shreg = registro destino                                  */
/* reg_type = de datos o de direccion                        */
/* size = tamano de la carga                                 */
/*************************************************************/
static void sh2reg(char *shreg, int reg, int reg_type, int size)
{
	if (reg == -1)
	{
		emit("mov r2,r0");
		emit("mov.%c %s,@(r0,%s)",sizeid[size],shreg,(reg_type == DATA_REG)?"r13":"r14");
	}
	else
	{
		if (size != LONG)
		{
			if ((reg == 0) && (reg_type == DATA_REG))
				emit("mov.%c %s,@r13",sizeid[size],shreg);
			else
			{
				emit("mov #%d,r0",(reg*4)+(reg_type*32));
				emit("mov.%c %s,@(r0,r13)",sizeid[size],shreg);
			}
		}
		else
		{
			if ((reg == 0) && (reg_type == DATA_REG))
				emit("mov.l %s,@r13",shreg);
			else
				emit("mov.l %s,@(%d,r13)",shreg,(reg*4)+(reg_type*32));
		}
	}
}

/* Con precalculo de registro indice (r2) */
static void sh2regpci(char *shreg, int reg, int reg_type, int size)
{
	if (reg == -1)
		emit("mov.%c %s,@r2",sizeid[size], shreg);
	else
		sh2reg(shreg,reg,reg_type,size);
}

/* Extension sin signo del registro del SH (org a dest) */
/* size indica el tamano a extender                     */
static void extu(char *org, char *dest, int size)
{
	if (size < LONG)
		emit("extu.%c %s,%s",sizeid[size],org,dest);
	else
	{
		if (strcmp(org,dest)) /* si org != dest -> copiar */
			emit("mov %s,%s",org,dest);
	}
}

/* Extension con signo del registro del SH (org a dest) */
/* size indica el tamano a extender                     */
static void exts(char *org, char *dest, int size)
{
	if (size < LONG)
		emit("exts.%c %s,%s",sizeid[size],org,dest);
	else
	{
		if (strcmp(org,dest)) /* si org != dest -> copiar */
			emit("mov %s,%s",org,dest);
	}
}

/* Llamada al manejador de memoria */
static void ma_calling(void)
{
	emit("jsr @r0");
}

/* Realiza una llamada al manejador de memoria segun el tipo de acceso */
/* Es retardada */
static void mem_access(int type, int size)
{
	char t = (type == READ_DATA_TYPE)?'r':'w';

	switch(size)
	{
		case BYTE:
				emit("mov.l @(%cb_addr-fetch_idx,r11),r0",t);
				break;

		case WORD:
				emit("mov.l @(%cw_addr-fetch_idx,r11),r0",t);
				break;

		case LONG:
				emit("mov.l @(%cl_addr-fetch_idx,r11),r0",t);
				break;

		default: emit("# mem_access wrong parameter value (type)");
	}
	ma_calling();
}

/* Carga un DWORD de la direccion de memoria apuntada por ptr_reg */
/* dest_reg -> registro destino */
/* dirt_reg -> registro temporal */
/* at -> tipo de acceso (DW_AIND -indirect- o DW_AINC -post incremented-) */
/* Atencion: en modo DW_AIND el ptr_reg se incr. en 2 tras la operacion */
static void load_dword(char *ptr_reg, char *dest_reg, char *dirt_reg, int at)
{
	emit("mov.w @%s+,%s",ptr_reg, dirt_reg);
	emit("mov.w @%s%s,%s",ptr_reg, (at == DW_AINC)?"+":"", dest_reg);
	emit("shll16 %s",dest_reg);
	emit("xtrct %s,%s",dirt_reg, dest_reg);
}

/* Ajustar datos byte y word para operar como long */
static void adj_bwdata(char *reg, int size)
{
	switch(main_size)
	{
		case BYTE:
			emit("shll16 %s",reg);
			emit("shll8 %s",reg);
			break;

		case WORD:
			emit("shll16 %s",reg);
			break;
	}
}

/* Revertir la operacion de ajuste para datos byte y word */
static void readj_bwdata(char *reg, int size)
{
	if (size != LONG)
	{
		emit("mov #-%d,r0",32-main_size*8);
		emit("shad r0,%s",reg);
	}
}

/* Esta rutina permite cambiar el ambito de ejecucion de ASM -> C */
/* Guarda datos alojados durante la ejecucion en variables destinadas a tal efecto */
static void core_exit(int ln)
{
	/* Guardar datos en registros en variables y en la pila */
	/* io_fetchbase e io_fetchbased_pc deben estar a continuacion de io_cycle_counter */
	emit("mov.l io_cycle_counter_addr%d,r0",ln);
	emit("mov.l r7,@r0");
	emit("mov.l r5,@(io_fetchbase-io_cycle_counter,r0)");      /* io_fetchbase */
	emit("mov.l r6,@(io_fetchbased_pc-io_cycle_counter,r0)");  /* io_fetchbased_pc */
}

/* Esta rutina permite cambiar el ambito de ejecucion de C -> ASM */
static void core_enter(int ln)
{
	/* Recuperar datos en registros en variables y en la pila */
	emit("mov.l io_cycle_counter_addr%d,r0",ln);
	emit("mov.l @r0,r7");
	emit("mov.l @(io_fetchbase-io_cycle_counter,r0),r5");      /* io_fetchbase */
	emit("mov.l @(io_fetchbased_pc-io_cycle_counter,r0),r6");  /* io_fetchbased_pc */
}

/* Cargar falso CCR (r8) desde org y fija la bandera X */
static void load_ccr_from(char *reg)
{
	emit("mov #3,r8");
	emit("and %s,r8",reg);   /* r8 = 000VC */
	emit("mov %s,r9",reg);   /* r9 = XNZVC */
	emit("shlr2 r9");        /* r9 = ??XNZ */
	emit("not r9,r3");       /* r3 = ??xnz */
	emit("shlr r9");         /* r9 = ???XN */
	emit("mov #1,r0");
	emit("shlr r9");         /* r9 = ????X */
	emit("addc r8,r8");      /* r8 = VCN */
	emit("and r0,r9");       /* r9 = X */
	emit("and r0,r3");       /* r3 = rep. Z */
}

/* Cargar falso CCR (r8) desde r0 y fija la bandera X */
static void load_ccr_from_r0(void)
{
	load_ccr_from("r0");
}

/* Realiza un cache del SR desde el registro SH especificado */
/* No se puede utilizar r0 ni r1 como registro fuente */
/* r8 = VCN */
static void cache_sr_from(char *reg)
{
	/* cachear el BS en r10 */
	emit("mov %s,r10",reg);
	load_ccr_from(reg);
	emit("shlr8 r10");          /* r10 = BS */
}

/* Cachear SR */
static void cache_sr(int ln)
{
	emit("mov.l sreg_addr%d,r1",ln);
	emit("mov.w @r1,r0");       /* r1 = SR */
	emit("mov r0,r10");
	emit("shlr8 r10");
	load_ccr_from_r0();
}

/* Restaurar SR */
static void writeback_sr(int ln)
{
	emit("mov r8,r0");          /* r0 = VCN */
	emit("shlr r0");            /* r0 = VC */
	emit("addc r9,r9");         /* r9 = XN */
	emit("tst r3,r3");
	emit("addc r9,r9");         /* r9 = XNZ */
	emit("and #3,r0");          /* r0 = VC */
	emit("shll2 r9");           /* r9 = XNZ00 */
	emit("or r0,r9");           /* r9 = XNZVC (CCR) */
	emit("shll8 r10");
	emit("mov.l sreg_addr%d,r0",ln);
	emit("or r10,r9");          /* r9 = BS + CCR */
	emit("mov.w r9,@r0");       /* CCR = r9 */
}

/* Genera la etiqueta de puntero a direccion */
/* referente al parametro especificado */
static void gen_mt(char *addr, int ln)
{
	emit("%s_addr%d: .long %s",addr,ln,addr);
}

/* Salvar registro del SH4 en la pila */
/* name es el nombre del registro */
static void save_reg(char *reg)
{
	emit("mov.l %s,@-r15",reg);
}

/* Restaurar registro del SH4 de la pila */
/* name es el nombre del registro */
static void restore_reg(char *reg)
{
	emit("mov.l @r15+,%s",reg);
}

/* Intercambiar los ptrs de pila */
static void swap_sps(void)
{
	emit("mov.l @(32,r14),r0");        /* r3 = ASP (tras A7) */
	reg2sh(7,"r1",ADDR_REG,LONG);      /* r1 = A7 */
	sh2reg("r0",7,ADDR_REG,LONG);      /* A7 = ASP */
	emit("mov.l r1,@(32,r14)");        /* ASP = A7 */
}

/* Copiar mapa de memoria supervisor o usuario a mapa en uso */
static void set_memory_map(char map, int ln)
{
	if (!multiaddr) return;		/* salir si es espacio unico de memoria */

	if(direct_mapping)
	{
		emit("mov.l %cfmhtbl_ptr%d,r0",map,ln);
		emit("mov.l r0,@r11");
		emit("mov.l %crbmhtbl_ptr%d,r0",map,ln);
		emit("mov.l r0,@(4,r11)");
		emit("mov.l %crwmhtbl_ptr%d,r0",map,ln);
		emit("mov.l r0,@(8,r11)");
		emit("mov.l %cwbmhtbl_ptr%d,r0",map,ln);
		emit("mov.l r0,@(12,r11)");
		emit("mov.l %cwwmhtbl_ptr%d,r0",map,ln);
		emit("bra .endcmp%d",ln);
		emit("mov.l r0,@(16,r11)");
	
		align(2);
		emit("%cfmhtbl_ptr%d: .long %cfmhtbl",map,ln,map);
		emit("%crbmhtbl_ptr%d: .long %crbmhtbl",map,ln,map);
		emit("%crwmhtbl_ptr%d: .long %crwmhtbl",map,ln,map);
		emit("%cwbmhtbl_ptr%d: .long %cwbmhtbl",map,ln,map);
		emit("%cwwmhtbl_ptr%d: .long %cwwmhtbl",map,ln,map);
	}
	else
	{
		/* Fetch */
		emit("mov.l %c_fetch_addr%d,r0",map,ln);
		emit("mov.l fetch_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Read byte */
		emit("mov.l %c_readbyte_addr%d,r0",map,ln);
		emit("mov.l readbyte_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Read word */
		emit("mov.l %c_readword_addr%d,r0",map,ln);
		emit("mov.l readword_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Write byte */
		emit("mov.l %c_writebyte_addr%d,r0",map,ln);
		emit("mov.l writebyte_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Write word */
		emit("mov.l %c_writeword_addr%d,r0",map,ln);
		emit("mov.l writeword_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("bra .endcmp%d",ln);
		emit("mov.l r0,@r1");
		
		align(2);
		gen_mt("fetch",ln);
		gen_mt("readbyte",ln);
		gen_mt("readword",ln);
		gen_mt("writebyte",ln);
		gen_mt("writeword",ln);
		emit("%c_fetch_addr%d: .long %c_fetch",map,ln,map);
		emit("%c_readbyte_addr%d: .long %c_readbyte",map,ln,map);
		emit("%c_readword_addr%d: .long %c_readword",map,ln,map);
		emit("%c_writebyte_addr%d: .long %c_writebyte",map,ln,map);
		emit("%c_writeword_addr%d: .long %c_writeword",map,ln,map);
	}

	align(5);
	emit(".endcmp%d:",ln);
}

/* Fija el mapa de memoria supervisor */
static void set_supervisor_memory_map(int ln)
{
	if (direct_mapping)
	{
		emit("mov.l sfmhtbl_addr%d,r0",ln);
		emit("mov.l fetch_idx_addr%d,r1",ln);
		emit("mov.l r0,@r1");

		emit("mov.l srbmhtbl_addr%d,r0",ln);
		emit("mov.l r0,@(4,r1)");

		emit("mov.l srwmhtbl_addr%d,r0",ln);
		emit("mov.l r0,@(8,r1)");

		emit("mov.l swbmhtbl_addr%d,r0",ln);
		emit("mov.l r0,@(12,r1)");

		emit("mov.l swwmhtbl_addr%d,r0",ln);
		emit("mov.l r0,@(16,r1)");
	}
	else
	{
		/* Fetch */
		emit("mov.l s_fetch_addr%d,r0",ln);
		emit("mov.l fetch_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Read byte */
		emit("mov.l s_readbyte_addr%d,r0",ln);
		emit("mov.l readbyte_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Read word */
		emit("mov.l s_readword_addr%d,r0",ln);
		emit("mov.l readword_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Write byte */
		emit("mov.l s_writebyte_addr%d,r0",ln);
		emit("mov.l writebyte_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");

		/* Write word */
		emit("mov.l s_writeword_addr%d,r0",ln);
		emit("mov.l writeword_addr%d,r1",ln);
		emit("mov.l @r0,r0");
		emit("mov.l r0,@r1");
	}
}

/* Realiza el cache de acceso a los mapas de memoria */
/* tp = table pointer; mm = memory map; rs = region size */
static void cache_memory_map(char *tp, char *mm, int rs)
{
	static int ln=0;

	if (!direct_mapping) return;

	emit("mov.l %s,r4",tp);     /* r4 = ptr. inicio tabla de indices */
	emit("mov.l %s,r1",mm);     /* r1 = ptr. a mapa de memoria */
	emit("mov #-12,r3");        /* desplazamiento de bits (banco) */
	emit("mov #4,r6");          /* desplazamiento ptr. memoria */
	emit("mov.l @r1,r1");       /* ptr. a la lista de regiones */

	emit("begincmm%d:",ln);
	emit("mov.l @r1,r0");
	emit("cmp/eq #-1,r0");      /* fin de la lista */
	emit("bt endcmm%d",ln);

	emit("mov.l @r1,r0");       /* r0 = direccion baja de la region */
	emit("mov.l @(4,r1),r2");   /* r2 = direccion alta de la region */
	emit("shld r3,r0");
	emit("shld r3,r2");         /* coger 12 bits mas altos */
	emit("sub r0,r2");          /* r2 = banco dir. alta - banco dir. baja */
	emit("add #1,r2");          /* r2 = nº de bancos */
	emit("shll2 r0");           /* r0 = dir. baja region * 4 */
	emit("add r4,r0");          /* r0 = ptr. inicio tbl idx + dir baja region * 4 */

	emit("loop%d:",ln);
	emit("mov.l r1,@r0");
	emit("add r6,r0");
	emit("dt r2");
	emit("bf loop%d",ln);

	emit("bra begincmm%d",ln);
	emit("add #%d,r1",rs);      /* a la siguiente estructura */

	emit("endcmm%d:",ln++);
}

/***************************************************************************/

/***************************************************************************/
/* m68k_init()                                                             */
/* Debe ser llamado para inicializar la tabla de saltos de instruccion     */
/* No recibe parametros y no devuelve nada                                 */
/***************************************************************************/
static void gen_init(void)
{
	int ln = lntag++;

	gen_proc_header("init");
	/********************************************/
	/* Proceso de inicializacion de la libreria */
	/********************************************/

    emit("rts");
    emit("mov #0,r0");
}


/***************************************************************************/
/* m68k_emulate()                                                          */
/* Parametros: Numero de ciclos a ejecutar                                 */
/* Retorno: Exito de la operación                                          */
/*          0  La operacion se ha realizado satisfactoriamente             */
/*          -1 La CPU esta detenida debido a un ERROR DE BUS DOBLE (linea) */
/*             El PC ha salido de los limites (bucle no en linea)          */
/***************************************************************************/
static void gen_emulate(void)
{
	int ln = lntag++;

	gen_proc_header("emulate");

	emit("mov.l execinfo_addr,r1");
	emit("mov.w @r1,r0");            /* cachear execinfo (ojo, signo extendido) */

	if (emulate_group_0)
	{
        emit("tst #4,r0");           /* comprobar estado de la CPU (bit 2) */
        emit("bt cpuok");

    	/* La CPU esta detenida de forma irreversible -> DOBLE ERROR BUS/DIRECCION */
    	/* Solo se recuperara mediante RESET EXTERNO */
    	emit("rts");
    	emit("mov #-1,r0");	         /* codigo de retorno CPU detenida */

    	emit("cpuok:");
	}

	emit("tst #0x80,r0");            /* comprobar si estado parado */
	emit("bt notstopped");

	/* La CPU esta detenida mediante la instruccion STOP */
	/* Agregar ciclos de reloj requeridos (27/07/2005) */
	emit("mov.l cycles_counter_addr,r0");
	emit("mov.l @r0,r1");
	emit("add r4,r1");
	emit("mov.l r1,@r0");
	emit("rts");
	emit("mov #0,r0");               /* codigo de retorno exito (r0 = 0) */

    align(5);
	emit("notstopped:");

	/* Salvar registros */
	save_reg("r8");
	emit("mov r4,r7");		           /* guardar ciclos a ejecutar en r7 */
	save_reg("r9");
	save_reg("r10");
	save_reg("r11");
	save_reg("r12");
	emit("mov.l fetch_idx_addr,r11");  /* fetch index */
	save_reg("r13");
	emit("mov.l jmptbl_addr,r12");     /* jmptbl address */
	save_reg("r14");
	emit("mov.l reg_addr,r13");        /* data register address */
	emit("sts.l pr,@-r15");

	if (emulate_group_0 || check_branches)
	{
		emit("mov.l excep_ptr_addr,r2");  /* salvar ptr. de pila para salidas abruptas (GRUPO 0) */
		emit("mov.l r15,@r2");
	}

	emit("mov.l areg_addr,r14");       /* address register address */

	/* Poner en ejecucion el 68k */
	if (bit0_execinfo)
	{
		emit("or #1,r0");
		emit("mov.w r0,@r1");
	}
	/* 68k en ejecucion */

	emit("mov r0,r2");       /* salvar execinfo para chequeos posteriores */

	cache_sr(ln);

	emit("mov.l pc_addr,r1");              /* direccion del 68k PC */

	if (cycles_counting || emulate_trace)
		emit("mov.l r4,@(cycles_needed-pc,r1)");/* guardar ciclos de ejecucion solicitados */

	emit("mov.l @r1,r6");                  /* r6 = PC sin base */
    
	/* Chequeo de prioridad de excepciones */

	/* Excepciones de grupo 0 y excepcion de traza */
	if ((emulate_group_0 || check_branches) && emulate_trace)
	{
		emit("mov r2,r0");      /* recuperar execinfo para testeo */
		emit("tst #0xA,r0");    /* grupo 0 y modo traza */
		emit("bf execbase");
	}
	else if (emulate_trace)
	{
		emit("mov r2,r0");      /* recuperar execinfo para testeo */
		emit("tst #0x8,r0");    /* solo modo traza */
		emit("bf execbase");
	}
	else if (emulate_group_0 || check_branches)
	{
		emit("mov r2,r0");      /* recuperar execinfo para testeo */
		emit("tst #0x02,r0");   /* solo modo grupo 0 */
		emit("bf execbase");
	}

	/* CHEQUEO DE INTERRUPCIONES HARDWARE */
	emit("flush_irqs:");
	flush_irqs(ln);

	if (irq_cycles)
	{
		emit("cmp/pz r7");        /* activar bandera T si r7 >= 0 */
		emit("mov #0,r5");
		emit("bf/s execexit");
		emit("add #2,r6");        /* emular post-incremento del fdl */
	}

    if (emulate_trace)
    {
        emit("tst r0,r0");         /* si se van a atender interrupciones */
        emit("bf execbase");       /* continuar con la ejecucion */

	    /* CHEQUEO DE EXCEPCION DE MODO TRAZA */
	    /* Mirar a ver si esta activa la bandera de traza y generar proceso de excepcion */
        emit("test_trace:");
        emit("mov #0x80,r2");
        emit("tst r2,r10");                 /* Testear bit de traza */
        emit("bt execbase");

	    /* GENERACION DE LA EXCEPCION DE TRAZA */
	    emit("trace_excep:");

        /* Esto no se lanza ahora! se deja pendiente para el execexit */
        emit("mov.l execinfo_addr,r1");
        emit("mov.w @r1,r0");
        emit("or #0x8,r0");    /* Trace */

        /* Tengo que quitar los ciclos para provocar salida y esperar a que vuelva */
        /* para provocar el DO_TRACE */
        emit("mov.l cycle_needed_addr,r2");
        emit("mov.w r0,@r1");
        emit("mov.l r7,@r2");
        emit("mov #0,r7");
    }
    
    emit("execbase:");
    emit("bsr basefunction");    /* calculo de la base del PC */
	emit("pref @r13");           /* prefetching registros de datos */
	emit("add r5,r6");		     /* r6 = PC + base */

	/***************************************************************************************/
	/* Este codigo solo se emite si se emulan las excepciones de error de bus/direccion    */
	/* Si se emulan estas excepciones no se controla el PC tras un basefunction puesto que */
	/* en ese caso se produciria un error de bus y la ejecucion de la CPU continuaria      */
	/***************************************************************************************/

	/* Este codigo es necesario, aunque lo omito por razones de rendimiento */
//	if (!emulate_group_0)
//	{
//		emit("tst #2,r0");             /* chequea si el PC ha rebasado los limites */
//		emit("bf exec_bounderror");    /* en cuyo caso error de desbordamiento */
//	}

    /* EXECLOOP */
	emit("execloop:");
	load_opcode();
	exec_opcode();

	/* Salida de funcion emulate */
	align(5);
	emit("execexit:");
    emit("add #-2,r6");         /* compensar post-incremento en el fdl */

	if (emulate_trace)
	{
        /* Comprobar si estoy en TRACE, puesto que si es asi debo pasar a DO_TRACE */
        /* ejecutando la excepcion de traza */
        emit("mov.l execinfo_addr,r1");
        emit("mov.w @r1,r0");
        emit("tst #0x8,r0");
        emit("bt cont_execexit");

        emit("mov.l cycle_needed_addr,r4");
        emit("and #0xF7,r0");   /* Retiramos la espera de atencion (TRACE) */
        emit("mov.l @r4,r7");
        emit("or #16,r0");		/* Atendiendo a excepcion de modo traza */
        emit("mov.w r0,@r1");
        emit("mov.l g1_exception_addr,r0");
        emit("jsr @r0");
        emit("mov #0x24,r4");

	    /* Sustraer ciclos empleados en la atencion a la excepcion de traza */
        emit("add #-34,r7");
        emit("cmp/pl r7");
        emit("bt execbase");

        emit("mov #0,r5");
	    emit("cont_execexit:");
	}

    emit("mov.l pc_addr,r2");   /* r2 = PC address */
	emit("sub r5,r6");          /* sustraer la base al PC */
	writeback_sr(ln);           /* volcar falso CCR -> CCR */
	emit("mov.l r6,@r2");       /* guardar el PC (writeback) */

	if (cycles_counting)
	{
		emit("mov.l @(cycles_needed-pc,r2),r4");    /* r4 = cycles_needed */
		emit("sub r7,r4");                          /* r4 = ejecutados */
		emit("mov.l @(cycles_counter-pc,r2),r6");   /* r6 = cycles_counter */
		emit("add r4,r6");                          /* incr. contador con los ejecutados */
		emit("mov.l r6,@(cycles_counter-pc,r2)");   /* cycles_counter = r6 */
	}

	if (bit0_execinfo)
	{
		emit("mov.l execinfo_addr,r1");
		emit("mov.w @r1,r0");       /* cargar execinfo para detener CPU */
		emit("xor #1,r0");          /* CPU detenida */
		emit("mov.w r0,@r1");       /* volcar execinfo */
	}

	/* Restaurado de registros */
	emit("lds.l	@r15+,pr");
	restore_reg("r14");

	/* valor de retorno a r0 */
	/* omitido por rendimiento */
/*	if(!emulate_group_0)
		emit("mov r3,r0");
	else
		emit("mov #0,r0");
*/
	restore_reg("r13");
	restore_reg("r12");
	restore_reg("r11");
	restore_reg("r10");
	restore_reg("r9");
	emit("rts");
	restore_reg("r8");

	align(2);
	if (emulate_group_0 || check_branches)
		emit("excep_ptr_addr: .long excep_ptr");
	emit("interrupts_addr: .long interrupts");
	emit("pc_addr: .long pc");
	emit("reg_addr: .long reg");
	emit("areg_addr: .long areg");
	if (direct_mapping)
		emit("fetch_vector_addr: .long fetch_vector");
	gen_mt("sreg",ln);
	emit("jmptbl_addr: .long jmptbl");
	if (emulate_trace)
		emit("cycle_needed_addr: .long cycles_needed");
	emit("cycles_counter_addr: .long cycles_counter");
	emit("execinfo_addr: .long execinfo");
	emit("fetch_idx_addr: .long fetch_idx");
	emit("g1_exception_addr: .long group_1_exception");
	emit("basefunction_addr: .long basefunction");
	emit("iackhandler_addr: .long iackhandler");
	gen_mt("io_cycle_counter",ln);

	/* Este codigo es necesario, aunque lo omito por razones de rendimiento */
//	if (!emulate_group_0)
//	{
		/* Error: PC fuera de los limites de la memoria */
//		emit("exec_bounderror:");
//		emit("bra execexit");
//		emit("mov #-1,r3");           /* Codigo de retorno */
//	}
}


/****************************************************************************/
/* m68k_reset()																*/
/* Parametros: Ninguno														*/
/* Retorno: Exito de la operacion                                           */
/*          0  La funcion se ha ejecutado satisfactoriamente                */
/*          1  No se puede resetear porque la CPU esta en ejecucion         */
/*          2  No se puede resetear porque no hay mapa de memoria           */
/*             supervisor de extraccion de opcodes                          */
/****************************************************************************/
static void gen_reset(void)
{
	int ln = lntag++;

	gen_proc_header("reset");

	save_reg("r11");                  /* Necesario para la rutina basefunction */
	emit("mov.l fetchidx_addr,r11");  /* Fetch index */
	emit("mov #1,r0");                /* r0 = 1 */
	emit("mov.l execinfo_addr%d,r2",ln);/* r2 = dir. execinfo */
	emit("mov.w @r2,r1");             /* r7 = execinfo */
	emit("tst r1,r0");                /* #1 & execinfo */
	emit("bf return");

	emit("mov.l sup_fetch_addr,r0");
	emit("mov.l @r0,r1");		      /* r1 = s_fetch */
	emit("mov #2,r0");                /* retorno si no hay mapa de memoria sup. */
	emit("tst r1,r1");                /* si es 0, salir, no hay mapa */
	emit("bt return");

	/* Resetear registros de datos y direcciones, incluyendo A7 */
	emit("mov.l reg_addr%d,r0",ln);   /* r0 = reg */
	emit("mov #64,r1");               /* tamano registros en bytes */
	emit("add r1,r0");                /* r0 al final registros */
	emit("shlr2 r1");                 /* en dobles palabras */
	emit("xor r4,r4");                /* r4 = 0 (dato a cargar) */

	emit("gp:");
	emit("mov.l r4,@-r0");            /* cargar el 0 al registro */
	emit("dt r1");                    /* decrementa el contador */
	emit("bf gp");                    /* comprobamos si hay finalizado */

	emit("mov.l asp_addr%d,r2",ln);
	emit("mov.l r4,@r2");             /* ASP = 0 */
	emit("mov.l interrupts_addr%d,r2",ln);
	emit("mov.b @r2,r0");
	emit("and #1,r0");                /* aislar bit IRQ type */
	emit("mov.b r0,@r2");             /* interrupts = 0 (salvo bit 0 -irqset-) */
	emit("mov.l execinfo_addr%d,r2",ln);
	emit("mov.w r4,@r2");             /* execinfo = 0 */

	/* Traza desactivada, modo supervisor, PPL=7 */
	emit("mov.l sreg_addr%d,r2",ln);  /* cargar dir. SR en r2 */
	emit("mov #0x27,r4");
	emit("shll8 r4");                 /* r4 = 0x2700 */
	emit("mov.w r4,@r2");             /* SR = 0x2700 */

	set_supervisor_memory_map(ln);

	emit("sts pr,r4");                /* salvar PR en r4 */
	emit("bsr basefunction");         /* retardada! */
	emit("xor r6,r6");	              /* r6 = parametro de basefunction = 0 */
	emit("lds r4,pr");                /* restaurar PR de r4 */
	emit("add r5,r6");                /* r6 = PC + base */
	emit("mov.l @r6+,r0");            /* cargar ptr. de pila */
	emit("swap.w r0,r0");
	emit("mov.l a7_addr%d,r2",ln);
	emit("mov.l r0,@r2");             /* cargar ptr. de la pila del mapa de memoria */
	emit("mov.l @r6,r0");             /* cargar PC 68k inicial */
	emit("swap.w r0,r0");
	emit("mov.l pc_addr%d,r2",ln);
	emit("mov.l r0,@r2");
	emit("mov #0,r0");                /* codigo de exito */

	emit("return:");
	emit("rts");
	restore_reg("r11");

	align(2);
	gen_mt("reg",ln);
	gen_mt("execinfo",ln);
	gen_mt("interrupts",ln);
	gen_mt("pc",ln);
	gen_mt("sreg",ln);
	gen_mt("a7",ln);
	gen_mt("asp",ln);
	emit("sup_fetch_addr: .long s_fetch");
	emit("sup_readbyte: .long s_readbyte");
	emit("sup_readword: .long s_readword");
	emit("sup_writebyte: .long s_writebyte");
	emit("sup_writeword: .long s_writeword");
	emit("act_fetch: .long fetch");
	emit("act_readbyte: .long readbyte");
	emit("act_readword: .long readword");
	emit("act_writebyte: .long writebyte");
	emit("act_writeword: .long writeword");
	emit("fetchidx_addr: .long fetch_idx");

	if (direct_mapping)
	{
		emit("sfmhtbl_addr%d: .long sfmhtbl",ln);
		emit("srbmhtbl_addr%d: .long srbmhtbl",ln);
		emit("srwmhtbl_addr%d: .long srwmhtbl",ln);
		emit("swbmhtbl_addr%d: .long swbmhtbl",ln);
		emit("swwmhtbl_addr%d: .long swwmhtbl",ln);
		emit("fetch_idx_addr%d: .long fetch_idx",ln);
	}
	else
	{
		gen_mt("fetch",ln);
		gen_mt("readbyte",ln);
		gen_mt("readword",ln);
		gen_mt("writebyte",ln);
		gen_mt("writeword",ln);
		gen_mt("s_fetch",ln);
		gen_mt("s_readbyte",ln);
		gen_mt("s_readword",ln);
		gen_mt("s_writebyte",ln);
		gen_mt("s_writeword",ln);
	}
}

/******************************************************************************/
/* m68k_raise_irq(level,vector)			                                      */
/* Parametros: level = nivel de interrupcion (r4)                             */
/*             vector = puntero a la direccion de la rutina de atencion (r5)  */
/*                      -1 auto, -2 interrupcion espuria                      */
/* Retorno: Exito de la operacion                                             */
/*         0  La interrupcion se ha habilitado satisfactoriamente             */
/*        -1  No se ha podido habilitar porque ya existe otra interrupcion    */
/*            en ese nivel.                                                   */
/*        -2  No se ha podido habilitar porque el vector no es valido o       */
/*	                 el nivel es igual a 0.                                   */
/******************************************************************************/
static void gen_raise_irq(void)
{
	int ln = lntag++;

	gen_proc_header("raise_irq");

	emit("mov r4,r0");	    /* r0 = nivel de interrupcion */
	emit("and #7,r0");	    /* aislar 3 primeros bits */
	emit("tst r0,r0");	    /* si el nivel es 0, salir */
	emit("bt badinput");

	emit("mov #0xff,r4");
	emit("extu.b r4,r4");       /* r4 = 0xff (255) */
	emit("cmp/gt r4,r5");       /* si es > 255, salir */
	emit("bt badinput");

	emit("mov #-2,r4");
	emit("cmp/ge r4,r5");       /* si es < -2, error y salir */
	emit("bf badinput");

	emit("cmp/eq r5,r4");       /* si es -2, int. espuria */
	emit("bf notspurious");

	emit("bra notauto");        /* cargar vector y finalizar */
	emit("mov #0x18,r5");       /* ojo, bra retardada */

	emit("notspurious:");
	emit("mov #-1,r4");         /* r4 = -1 (int. automatica) */
	emit("cmp/eq r5,r4");       /* si es -1, automatica */
	emit("bf notauto");
	emit("mov #0x18,r5");
	emit("add r0,r5");          /* r5 = vector atencion + 0x18 (auto, LEA) */

	emit("notauto:");
	emit("mov #1,r4");	        /* cargar uno para desplazar */
	emit("shld r0,r4");	        /* desplazar segun nivel int. */
	emit("mov.l interrupts_addr%d,r1",ln);
	emit("mov.b @r1,r6");	    /* r6 = primer byte interrupts */
	emit("tst r6,r4");	        /* si ya estaba activada, fallo */
	emit("bf failure");

	emit("or r4,r6");	        /* dar de alta la interrupcion */
	emit("mov.b r5,@(r0,r1)");	/* cargar el vector dentro de ints */
	emit("mov.b r6,@r1");       /* cargo valor final en interrupts */

	/* En r0 esta el nivel de interrupcion. Tiene que ser mayor que el PPL */
	/* para quitar el estado parado de la CPU, en caso de que lo este      */
	emit("mov #0x80,r1");
	emit("mov.l execinfo_addr%d,r6",ln);
	emit("extu.b r1,r1");
	emit("mov.w @r6,r7");           /* cargar execinfo */
	emit("tst r1,r7");              /* testear si la CPU esta detenida mediante STOP */
	emit("bt .notstopped");

	/* CPU detenida mediante STOP */
	/* comprobar si hay que cambiar de estado */
	emit("mov.l sreg_addr%d,r1",ln);
	emit("mov.w @r1,r5");
	emit("shlr8 r5");           /* r5 = BS */
	emit("mov #7,r1");          /* r1 = mascara PPL */
	emit("cmp/eq r1,r0");       /* se ha activado la NMI? */
	emit("movt r4");            /* r4 = NMI activada en esta llamada */
	emit("and r1,r5");          /* aislar bits PPL (NI) */
	emit("add r4,r0");          /* incrementar r0 si es NMI para comprobacion */
	emit("cmp/hs r0,r5");       /* si el NI es <= el bit permanecera activo */
	emit("movt r2");
	emit("mov #0x7f,r0");       /* borrar bit de estado parado (STOP) */
	emit("shld r1,r2");         /* ajustar a posicion bit en execinfo */
	emit("and r0,r7");          /* bit a 0 para fijar */
	emit("or r2,r7");           /* fijacion de bit */
	emit("mov.w r7,@r6");       /* volcar valor final en execinfo */

	emit(".notstopped:");
	emit("rts");
	emit("mov #0,r0");

	emit("failure:");           /* Fallo: la interrupcion no esta habilitada */
	emit("rts");
	emit("mov #-1,r0");         /* codigo de retorno (r0 = -1) */

	emit("badinput:");          /* Valor de interrupcion no valido (cero) */
	emit("rts");
	emit("mov #-2,r0");

	align(2);
	gen_mt("interrupts",ln);
	gen_mt("execinfo",ln);
	gen_mt("sreg",ln);
}

/********************************************************************************/
/* m68k_lower_irq(level)                                                        */
/* Parametros: Nivel de la interrupcion a retirar                               */
/* Retorno: Exito de la operacion                                               */
/*         0  La interrupcion se ha retirado satisfactoriamente                 */
/*        -1  No se ha podido retirar porque esa interrupcion                   */
/*			  no esta habilitada.                                               */
/*        -2  No se ha podido retirar porque el nivel es 0 o mayor              */
/*				o igual que 7 (no se puede retirar la NMI)                      */
/********************************************************************************/
static void gen_lower_irq(void)
{
	int ln = lntag++;

	gen_proc_header("lower_irq");

	emit("mov #6,r1");
	emit("cmp/gt r1,r4");   /* si es > 6, error */
	emit("bt .badlevel");

	emit("tst r4,r4");      /* si es 0, error */
	emit("bt .badlevel");

	emit("mov #1,r1");      /* cargar 1 para desplazar */
	emit("shld r4,r1");     /* desplazar a la posicion adecuada */

	emit("mov.l interrupts_addr%d,r2",ln);
	emit("mov.b @r2,r3");   /* r3 = 1er byte interrupts */
	emit("tst r3,r1");
	emit("bt .failstat");

	emit("not r1,r1");       /* invertir bits */
	emit("and r1,r3");       /* desactivar bit interrupcion */
	emit("mov.b r3,@r2");    /* dar de baja la interrupcion */

	emit("rts");
	emit("mov #0,r0");       /* Codigo de exito */

	emit(".failstat:");
	emit("rts");
	emit("mov #-1,r0");      /* Error: La interrupcion no esta activada */

	emit(".badlevel:");
	emit("rts");
	emit("mov #-2,r0");      /* Error: Valor de interrupcion no valido */

	align(2);
	gen_mt("interrupts",ln);
}

/******************************************************************************/
/* m68k_burst_irq(mask,vector)                                                */
/* Parametros: mask = mascara de activacion de interrupciones (r4)            */
/* Retorno: Ninguno.                                                          */
/******************************************************************************/
static void gen_burst_irq(void)
{
	int ln = lntag++;

	gen_proc_header("burst_irq");

	emit("mov r4,r0");	            /* r0 = mascara de activacion */
	emit("mov.l interrupts_addr%d,r1",ln);
	emit("and #0xfe,r0");           /* preservar bit 0 interrupts */
	emit("mov.b r0,@r1");	        /* r6 = primer byte interrupts */


	emit("mov #0xff,r4");
	emit("extu.b r4,r4");       /* r4 = 0xff (255) */
	emit("cmp/gt r4,r5");       /* si es > 255, salir */
	emit("bt badinput_bi");

	emit("mov #-2,r4");
	emit("cmp/ge r4,r5");       /* si es < -2, error y salir */
	emit("bf badinput_bi");

	emit("cmp/eq r5,r4");       /* si es -2, int. espuria */
	emit("bf notspurious_bi");

	emit("bra notauto_bi");        /* cargar vector y finalizar */
	emit("mov #0x18,r5");       /* ojo, bra retardada */

	emit("notspurious_bi:");
	emit("mov #-1,r4");         /* r4 = -1 (int. automatica) */
	emit("cmp/eq r5,r4");       /* si es -1, automatica */
	emit("bf notauto");
	emit("mov #0x1F,r5");       /* r5 = vector atencion (7) + 0x18 (auto, LEA) */

	emit("notauto_bi:");
	emit("mov r0,r2");
	emit("mov #7,r0");
	emit("sv_loop:");
	emit("mov.b r5,@(r0,r1)");	/* cargar el vector dentro de ints */
	emit("dt r0");
	emit("bf/s sv_loop");
	emit("add #-1,r5");         /* decrementar vector atencion */

	emit("mov r2,r0");


	/* En r0 esta el nivel de interrupcion. Tiene que ser mayor que el PPL */
	/* para quitar el estado parado de la CPU, en caso de que lo este      */
	emit("mov #0x80,r1");
	emit("mov.l execinfo_addr%d,r6",ln);
	emit("extu.b r1,r1");
	emit("mov.w @r6,r7");           /* cargar execinfo */
	emit("tst r1,r7");              /* testear si la CPU esta detenida mediante STOP */
	emit("bt .notstopped_bi");

	/* CPU detenida mediante STOP */
	/* comprobar si hay que cambiar de estado */

	emit("shll16 r0");
	emit("mov #8,r1");          /* r1 = contador de nivel */
	emit("shll8 r0");           /* byte alto r0 = mascara activacion */

	emit("loop_bi:");
	emit("tst r0,r0");
	emit("bt .nullmask");
	emit("shll r0");            /* bit IRQ -> T */
	emit("bt/s loop_bi");
	emit("dt r1");
	emit("mov r1,r0");          /* r0 = mayor nivel de interrupcion */

	emit("mov.l sreg_addr%d,r1",ln);
	emit("mov.w @r1,r5");
	emit("shlr8 r5");           /* r5 = BS */
	emit("mov #7,r1");          /* r1 = mascara PPL */
	emit("cmp/eq r1,r0");       /* se ha activado la NMI? */
	emit("movt r4");            /* r4 = NMI activada en esta llamada */
	emit("and r1,r5");          /* aislar bits PPL (NI) */
	emit("add r4,r0");          /* incrementar r0 si es NMI para comprobacion */
	emit("cmp/hs r0,r5");       /* si el NI es <= el bit permanecera activo */
	emit("movt r2");
	emit("mov #0x7f,r0");       /* borrar bit de estado parado (STOP) */
	emit("shld r1,r2");         /* ajustar a posicion bit en execinfo */
	emit("and r0,r7");          /* bit a 0 para fijar */
	emit("or r2,r7");           /* fijacion de bit */
	emit("mov.w r7,@r6");       /* volcar valor final en execinfo */
	emit("rts");
	emit("mov #0,r0");

	emit(".notstopped_bi:");
	emit(".nullmask:");
	emit("rts");
	emit("mov #0,r0");

	emit("failure_bi:");           /* Fallo: la interrupcion no esta habilitada */
	emit("rts");
	emit("mov #-1,r0");         /* codigo de retorno (r0 = -1) */

	emit("badinput_bi:");          /* Valor de interrupcion no valido (cero) */
	emit("rts");
	emit("mov #-2,r0");

	align(2);
	gen_mt("interrupts",ln);
	gen_mt("execinfo",ln);
	gen_mt("sreg",ln);
}

/****************************************************************************/
/* m68k_set_irq_type(cpu_context, type)                                     */
/* Parametro: Tipo de irq (automatica=1 o manual=0)                         */
/* No retorna ningun valor                                                  */
/****************************************************************************/
static void gen_set_irq_type(void)
{
	int ln = lntag++;

	gen_proc_header("set_irq_type");

	emit("mov #1,r0");
	emit("and r0,r5");               /* enmascarar sistema de interrupcion */

	emit("tst r4,r4");               /* nos pasan contexto de CPU? */
	emit("bt .si_irq");              /* si no, asignacion al actual */

	emit("mov #interrupts-contextbegin,r0");
	emit("mov.b @(r0,r4),r1");
	emit("shlr r1");
	emit("shll r1");
	emit("or r5,r1");
	emit("mov.b r1,@(r0,r4)");
	emit("rts");
	emit("mov #0,r0");

	emit(".si_irq:");
	emit("mov.l interrupts_addr%d,r1",ln);
	emit("mov.b @r1,r0");
	emit("and #0xFE,r0");
	emit("or r5,r0");
	emit("mov.b r0,@r1");
	emit("rts");
	emit("mov #0,r0");

	align(2);
	gen_mt("interrupts",ln);
}

/****************************************************************************/
/* m68k_get_irq_vector(level)                                               */
/* Parametro: Nivel de interrupcion                                         */
/* Retorno: Exito de la operacion o vector de la interrupcion               */
/*         -1: La interrupcion no esta activada                             */
/*         -2: El nivel de interrupcion no es valido (nivel = 0)            */
/*         > -1: Vector de interrupcion solicitado                          */
/****************************************************************************/
static void gen_get_irq_vector(void)
{
	int ln = lntag++;

	gen_proc_header("get_irq_vector");

	emit("mov r4,r0");	/* r0 = nivel de interrupcion */
	emit("and #7,r0");	/* aislar 3 primeros bits de ints */
	emit("tst r0,r0");	/* si es cero, error */
	emit("bt badlev");

	emit("mov #1,r1");	/* cargar 1 para desplazar */
	emit("shld r0,r1");	/* desplazar a la posicion adecuada */
	emit("mov.l interrupts_addr%d,r2",ln);
	emit("mov.b @r2,r3");	/* r3 = 1er byte interrupts */
	emit("tst r3,r1");
	emit("bt notraised");

	emit("mov.b @(r0,r2),r0");/* cargar de matriz a r0 */
	emit("rts");
	emit("extu.b r0,r0");     /* quitar el signo (unsigned) */

	emit("notraised:");
	emit("rts");
	emit("mov #-1,r0");       /* Error: Interrupcion no activada */

	emit("badlev:");
	emit("rts");
	emit("mov #-2,r0");       /* Error: El nivel especificado es 0 */

	align(2);
	gen_mt("interrupts",ln);
}

/********************************************************************************/
/* m68k_change_irq_vector(level,vector)                                         */
/* Parametros:                                                                  */
/*		level: Nivel de interrupcion                                            */
/*		vector: Nuevo puntero a la direccion de la rutina de atencion           */
/*                      -1 auto, -2 interrupcion espuria                        */
/* Retorno: Exito de la operacion                                               */
/*         0  El vector de interrupcion se ha modificado satisfactoriamente     */
/*         1  No se ha podido modificar porque no existe interrupcion           */
/*			  en ese nivel.                                                     */
/*         2  No se ha podido habilitar porque el vector no es valido o el      */
/*			  nivel es igual a 0.                                               */
/********************************************************************************/
static void gen_change_irq_vector(void)
{
	int ln = lntag++;

	gen_proc_header("change_irq_vector");

	emit("mov r4,r0");            /* r0 = nivel de interrupcion */
	emit("and #7,r0");            /* aislar 3 primeros bits de ints */
	emit("tst r0,r0");            /* si es cero, error */
	emit("bt .badin");

	emit("mov #1,r1");            /* cargar 1 para desplazar */
	emit("shld r0,r1");           /* desplazar a la posicion adecuada */
	emit("mov.l interrupts_addr%d,r7",ln); /* r7 = interrupts addr */
	emit("mov.b @r7,r3");         /* r3 = 1er byte interrupts */
	emit("tst r3,r1");
	emit("bt .nraised");

	emit("mov #255,r4");          /* se carga con extension */
	emit("extu.b r4,r4");         /* r4 = 255 */
	emit("cmp/gt r4,r5");         /* si es > 255, salir */
	emit("bt .badin");

	emit("mov #-2,r4");
	emit("cmp/gt r5,r4");         /* si es < -2, error y salir */
	emit("bt .badin");

	emit("cmp/eq r5,r4");         /* si es -2, int. espuria */
	emit("bf .notspurious");

	emit("bra .notauto");         /* cargar vector y finalizar */
	emit("mov #0x18,r5");         /* ojo, bra retardada */

	emit(".notspurious:");
	emit("dt r4");                /* r4 = -1 */
	emit("cmp/eq r5,r4");         /* si es -1, automatica */
	emit("bf .notauto");
	emit("mov #0x18,r5");
	emit("add r0,r5");            /* r5 = vector atencion + 0x18 (auto) */

	emit(".notauto:");
	emit("mov.b r5,@(r0,r7)");    /* cargar el vector dentro de ints */
	emit("rts");
	emit("mov #0,r0");

	emit(".nraised:");            /* interrupcion no generada */
	emit("rts");
	emit("mov #-1,r0");

	emit(".badin:");              /* error en la entrada */
	emit("rts");
	emit("mov #-2,r0");

	align(2);
	gen_mt("interrupts",ln);
}

/***************************************************************************/
/* m68k_get_context_size                                                   */
/* No recibe parametros                                                    */
/* Retorno: Tamano del contexto en bytes                                   */
/***************************************************************************/
static void gen_get_context_size(void)
{
	int ln = lntag++;

	gen_proc_header("get_context_size");

	emit("mov.l contextend_addr%d,r0",ln);
	emit("mov.l contextbegin_addr%d,r1",ln);
	emit("rts");
	emit("sub r1,r0");

	align(2);
	emit("contextbegin_addr%d: .long contextbegin",ln);
	emit("contextend_addr%d: .long contextend",ln);
}

/***************************************************************************/
/* m68k_get_context(address)                                               */
/* Parametro: Direccion del contexto                                       */
/* No retorna ningun valor                                                 */
/***************************************************************************/
static void gen_get_context(void)
{
	int ln = lntag++;

	gen_proc_header("get_context");

	emit("mov.l contextbegin_addr%d,r2",ln);   /* Obtengo la direccion de contextend */
	emit("mov.l contextend_addr%d,r1",ln);

	/* Bucle de carga del contexto */
	emit("loopgc:");
	emit("mov.l @r2+,r0");      /* cargar dato en r0 */
	emit("mov.l r0,@r4");       /* volcar datos desde el principio */
	emit("add #4,r4");          /* r4 a siguiente dword */
	emit("cmp/eq r2,r1");       /* llegamos al final? */
	emit("bf loopgc");

	emit("rts");
	emit("mov #0,r0");

	align(2);
	gen_mt("contextbegin",ln);
	gen_mt("contextend",ln);
}

/***************************************************************************/
/* m68k_set_context(address)                                               */
/* Parametro: Direccion del contexto                                       */
/* No retorna ningun valor                                                 */
/***************************************************************************/
static void gen_set_context(void)
{
	int ln = lntag++;

	gen_proc_header("set_context");

	emit("mov.l contxtb,r2");   /* Obtengo la direccion de contextbegin */
	emit("mov.l contxte,r1");

	/* Bucle de carga del contexto */
	emit("lloop:");
	emit("mov.l @r4+,r0");      /* cargar dato en r0 */
	emit("mov.l r0,@r2");       /* volcar datos desde el principio */
	emit("add #4,r2");          /* r2 += 4 */
	emit("cmp/eq r2,r1");
	emit("bf lloop");

	if (direct_mapping)
	{
		/* Poner todos los indices a NULL (marcar outofrange) */
		emit("mov.l idxtbl_size,r1");
		emit("mov.l sfmhtbl_addr,r2");
		emit("mov #0,r0");            /* dato a cargar (marca) */

		/* Bucle de marcacion de tabla de indices */
		emit("mloop:");
		emit("mov.l r0,@r2");     /* volcar dato */
		emit("add #4,r2");
		emit("dt r1");
		emit("bf mloop");

		/* Realizar cache de lista de regiones (indices) */

		/* Mapa fetch supervisor */
		cache_memory_map("sfmhtbl_addr","s_fetch_addr",FETCH_STRUCT_SIZE);

		/* Mapa lectura byte supervisor */
		cache_memory_map("srbmhtbl_addr", "s_readbyte_addr", DATA_STRUCT_SIZE);

		/* Mapa lectura word supervisor */
		cache_memory_map("srwmhtbl_addr", "s_readword_addr", DATA_STRUCT_SIZE);

		/* Mapa escritura byte supervisor */
		cache_memory_map("swbmhtbl_addr", "s_writebyte_addr", DATA_STRUCT_SIZE);

		/* Mapa escritura word supervisor */
		cache_memory_map("swwmhtbl_addr", "s_writeword_addr", DATA_STRUCT_SIZE);

		/* Si es espacio multiple de memoria, incluir el usuario */
		if (multiaddr)
		{
			/* Mapa fetch usuario */
			cache_memory_map("ufmhtbl_addr", "u_fetch_addr", FETCH_STRUCT_SIZE);

			/* Mapa lectura byte usuario */
			cache_memory_map("urbmhtbl_addr", "u_readbyte_addr", DATA_STRUCT_SIZE);

			/* Mapa lectura word usuario */
			cache_memory_map("urwmhtbl_addr", "u_readword_addr", DATA_STRUCT_SIZE);

			/* Mapa escritura byte usuario */
			cache_memory_map("uwbmhtbl_addr", "u_writebyte_addr", DATA_STRUCT_SIZE);

			/* Mapa escritura word usuario */
			cache_memory_map("uwwmhtbl_addr", "u_writeword_addr", DATA_STRUCT_SIZE);
		}
	}

	emit("rts");
	emit("mov #0,r0");    /* retorno = 0 */

	align(2);
	gen_mt("interrupts",ln);
	emit("idxtbl_size: .long %d",(multiaddr?40960:20480));
	emit("contxte: .long contextend");
	emit("contxtb: .long contextbegin");

	if (direct_mapping)
	{
		emit("sfmhtbl_addr: .long sfmhtbl");
		emit("srbmhtbl_addr: .long srbmhtbl");
		emit("swbmhtbl_addr: .long swbmhtbl");
		emit("srwmhtbl_addr: .long srwmhtbl");
		emit("swwmhtbl_addr: .long swwmhtbl");
		emit("s_fetch_addr: .long s_fetch");
		emit("s_readbyte_addr: .long s_readbyte");
		emit("s_writebyte_addr: .long s_writebyte");
		emit("s_readword_addr: .long s_readword");
		emit("s_writeword_addr: .long s_writeword");
		
		/* Si es espacio multiple de memoria, incluir el usuario */
		if (multiaddr)
		{
			emit("ufmhtbl_addr: .long ufmhtbl");
			emit("urbmhtbl_addr: .long urbmhtbl");
			emit("uwbmhtbl_addr: .long uwbmhtbl");
			emit("urwmhtbl_addr: .long urwmhtbl");
			emit("uwwmhtbl_addr: .long uwwmhtbl");
			emit("u_fetch_addr: .long u_fetch");
			emit("u_readbyte_addr: .long u_readbyte");
			emit("u_writebyte_addr: .long u_writebyte");
			emit("u_readword_addr: .long u_readword");
			emit("u_writeword_addr: .long u_writeword");
		}
	}
}

/***************************************************************************/
/*  m68k_get_register(register)                                            */
/*  Parametro: Registro a obtener valor (indice)                           */
/*  Retorno: Valor del registro requerido                                  */
/*  Observacion: En caso de que el indice no sea correcto                  */
/*               la funcion devolvera -1                                   */
/***************************************************************************/
static void gen_get_register(void)
{
	int ln = lntag++;

	gen_proc_header("get_register");

	emit("mov #%d,r0",M68K_REG_PC);      /* para comparar en r0 */
	emit("cmp/gt r0,r4");
	emit("bt cont_get");

	emit("mov #%d,r0",M68K_REG_ASP);     /* para comparar en r0 */
	emit("cmp/gt r0,r4");
	emit("bf .set_dareg");
	emit("bra _%s_get_pc",fprefix);
	emit("nop");

	emit(".set_dareg:");
	emit("mov.l reg_addr%d,r0",ln);
	emit("shll2 r4");
	emit("rts");
	emit("mov.l @(r0,r4),r0");           /* devolver reg. datos/dir. */

	emit("cont_get:");
	emit("mov #%d,r0",M68K_REG_SR);      /* para comparar en r0 */
	emit("cmp/eq r0,r4");                /* es el registro SR? */
	emit("bf inv_idx");

	emit("mov.l sreg_addr%d,r0",ln);
	emit("mov.w @r0,r0");
	emit("rts");
	emit("extu.w r0,r0");

	emit("inv_idx:");
	emit("rts");
	emit("mov #-1,r0");                 /* Retorno = -1 (error) */

	align(2);
	gen_mt("sreg",ln);
	gen_mt("reg",ln);
}

/****************************************************************************/
/* m68k_get_pc()                                                            */
/* No recibe parametros                                                     */
/* Retorna 68k PC                                                           */
/****************************************************************************/
static void gen_get_pc(void)
{
	int ln = lntag++;

	gen_proc_header("get_pc");

	emit("mov.l execinfo_addr%d,r0",ln);
	emit("mov.w @r0,r0");
	emit("tst #1,r0");
	emit("bf running");
	emit("mov.l pc_addr%d,r0",ln);
	emit("rts");
	emit("mov.l @r0,r0");	/* devolver PC en r0 */

	emit("running:");		/* si 68k esta en ejecucion */
	emit("mov.l io_fetchbased_pc_addr%d,r0",ln);
	emit("mov.l @r0,r0");   /* r0 = fetchbased_pc */
	emit("mov.l io_fetchbase_addr%d,r1",ln);
	emit("mov.l @r1,r1");
	emit("rts");
	emit("sub r1,r0");      /* r0 = io_fetchbased_pc - io_fetchbase */

	align(2);
	gen_mt("pc",ln);
	gen_mt("execinfo",ln);
	gen_mt("io_fetchbase",ln);
	gen_mt("io_fetchbased_pc",ln);
}

/***********************************************************************/
/*  m68k_set_register(register,value)                                  */
/*  Parametros: Registro (indice) y valor a asignar                    */
/*  Retorno: Exito de la operacion                                     */
/*           0  La operacion se ha realizado satisfactoriamente        */
/*           1  El indice del registro no es valido (fuera de limites) */
/***********************************************************************/
static void gen_set_register(void)
{
	int ln = lntag++;

	gen_proc_header("set_register");

	emit("mov #%d,r0",M68K_REG_PC);
	emit("cmp/gt r0,r4");            /* Chequear si esta dentro de los limites [D0-PC] */
	emit("bt .cont_set");

	emit("mov #%d,r0",M68K_REG_ASP);
	emit("cmp/gt r0,r4");            /* Chequear si es el PC */
	emit("bt .set_pc");

	emit("mov.l reg_addr%d,r0",ln);
	emit("shll2 r4");
	emit("mov.l r5,@(r0,r4)");       /* fijar registro datos/direccion */
	emit("rts");
	emit("mov #0,r0");

	emit(".set_pc:");
	maskaddress("r5");
	emit("mov.l execinfo_addr%d,r0",ln);
	emit("mov #1,r2");
	emit("mov.b @r0,r1");
	emit("tst r2,r1");
	emit("bf .cpulive");

	emit("mov.l pc_addr%d,r0",ln);
	emit("mov.l r5,@r0");
	emit("rts");
	emit("mov #0,r0");

	emit(".cpulive:");
	emit("mov.l io_fetchbase_addr%d,r0",ln);
	emit("mov.l @r0,r1");
	emit("mov.l io_fetchbased_pc_addr%d,r2",ln);
	emit("add r5,r1");
	emit("mov.l r1,@r2");
	emit("rts");
	emit("mov #0,r0");

	emit(".cont_set:");
	emit("mov #%d,r0",M68K_REG_SR);
	emit("cmp/eq r0,r4");            /* es el registro SR? */
	emit("bf .inv_idx");

	emit("mov.l sreg_addr%d,r0",ln);
	emit("mov.w r5,@r0");            /* carga del valor del SR */
	emit("rts");
	emit("mov #0,r0");               /* r0 = 0 (exito) */

	emit(".inv_idx:");               /* Indice de registro no valido */
	emit("rts");
	emit("mov #-1,r0");              /* Codigo de retorno error */

	align(2);
	gen_mt("sreg",ln);
	gen_mt("reg",ln);
	gen_mt("execinfo",ln);
	gen_mt("pc",ln);
	gen_mt("io_fetchbase",ln);
	gen_mt("io_fetchbased_pc",ln);
}

/*********************************************************/
/*  m68k_fetch(address,access_type)                      */
/*  Lee una palabra del mapa de memoria supervisor       */
/*  Parametro: Direccion de la palabra y tipo de acceso  */
/*  Retorno: La palabra o -1 en caso de dir. no valida   */
/*********************************************************/
static void gen_fetch(void)
{
	int ln = lntag++;

	gen_proc_header("fetch");

	emit("mov #3,r0");
	emit("and r0,r5");      /* enmascarar bits de tipo de acceso */

	/* Cargo la direccion del vector de fetch con el tipo de acceso requerido */
	if (direct_mapping)
	{
		emit("mov r4,r2");      /* salvar r4 en r2 */
		emit("mov #-12,r0");
		emit("shld r0,r4");     /* r4 = 12 bits + altos direccion (banco) */
		emit("mov.l fetch_vector_addr%d,r0",ln);
		emit("shll2 r5");
		emit("mov.l @(r0,r5),r0");
		emit("shll2 r4");
		emit("mov.l @(r0,r4),r0");  /* r0 = ptr. a estructura read */
		emit("mov r2,r4");      /* recuperar r4 con valor originario */
		emit("tst r0,r0");
		emit("bt .outofrange");
	}
	else
	{
		emit("mov r5,r2");
		emit("mov #1,r0");
		emit("and r0,r2");
		emit("shll2 r2");
		emit("add #12,r2");   /* incremento */
		
		emit("mov.l fetch_vector_addr%d,r0",ln);
		emit("shll2 r5");
		emit("mov.l @(r0,r5),r1");
		emit("mov.l @r1,r1");

		emit("loop_fms:");
		emit("mov.l @r1,r0");
		emit("cmp/hs r0,r4");

		emit("bf nextfms");

		emit("mov.l @(4,r1),r0");
		emit("cmp/hi r4,r0");
		emit("bt getfetch");
		
		emit("nextfms:");
		emit("cmp/eq #-1,r0");
		emit("bt .outofrange");
		
		emit("bra loop_fms");
		emit("add r2,r1");          /* a la siguiente estructura */

		emit("getfetch:");
		emit("mov r1,r0");
	}

	emit("mov #4,r1");     /* testear bit 0 de tipo de acceso */
	emit("tst r1,r5");
	emit("bt .base_prg");  /* r5 bit[0] = 0 -> prg */
	emit("bra .base_dat");
	emit("nop");

	/* Fuera de limites, devolver -1 */
	emit(".outofrange:");
	emit("rts");
	emit("mov #-1,r0");		/* resultado = -1 */

	/* Calculo de la base para programa */
	emit(".base_prg:");
	emit("mov.l @(8,r0),r0");
	emit("mov.w @(r0,r4),r0");  /* cargar resultado final en r0 */
	emit("rts");
	emit("extu.w r0,r0");       /* resultado tamano palabra */

	/* Calculo de la base para datos */
	emit(".base_dat:");
	/* Comprobar si existe ptr de manejador */
	emit("mov.l @(8,r0),r1");
	emit("tst r1,r1");
	emit("bf .callio");

	/* Lectura mediante manejador propio */
	emit("mov.l @(12,r0),r0");
	emit("mov.w @(r0,r4),r0");  /* cargar resultado final en r0 */
	emit("rts");
	emit("extu.w r0,r0");       /* resultado tamano palabra */

	/* Lectura mediante manejador de entrada/salida */
	emit(".callio:");
	emit("sts.l	pr,@-r15");
	emit("jsr @r1");            /* llamada al manejador */
	emit("nop");
	emit("lds.l	@r15+,pr");
	emit("rts");                /* el resultado esta ya en r0 */
	emit("extu.w r0,r0");       /* resultado tamano palabra */

	align(2);
	gen_mt("fetch_vector",ln);
}

/******************************************************/
/*  m68k_get_cycles_counter()                         */
/*  Retorna el cycles_counter                         */
/*  Parametro: Ninguno                                */
/*  Retorno: cycles_counter                           */
/******************************************************/
static void gen_get_cycles_counter(void)
{
	int ln = lntag++;

	gen_proc_header("get_cycles_counter");

	if (cycles_counting)
	{
		emit("mov.l cycles_needed_addr%d,r2",ln);  /* r2 = cycles_needed address */
		emit("mov.l @r2,r1");                      /* r1 = cycles_needed */
		emit("mov.l execinfo_addr%d,r0",ln);
		emit("mov.w @r0,r0");                      /* r0 = execinfo */
		emit("tst #1,r0");
		emit("bt cpuidle");

		emit("mov.l io_cycle_counter_addr%d,r0",ln);
		emit("mov.l @r0,r0");
		emit("sub r0,r1");

		emit("cpuidle:");
		emit("mov.l cycles_counter_addr%d,r0",ln);
		emit("mov.l @r0,r0");
		emit("rts");
		emit("add r1,r0");

		align(2);
		gen_mt("execinfo",ln);
		gen_mt("cycles_counter",ln);
		gen_mt("cycles_needed",ln);
		gen_mt("io_cycle_counter",ln);
	}
	else
	{
		emit("rts");
		emit("mov #-1,r0");
	}
}

/******************************************************/
/*  m68k_trip_cycles_counter()                        */
/*  Retorna el cycles_counter y lo reinicializa       */
/*  Parametro: Ninguno                                */
/*  Retorno: cycles_counter                           */
/******************************************************/
static void gen_trip_cycles_counter(void)
{
	int ln = lntag++;

	gen_proc_header("trip_cycles_counter");

	if (cycles_counting)
	{
		/* Lectura */
		emit("mov.l cycles_needed_addr%d,r4",ln);  /* r4 = cycles_needed_ptr */
		emit("mov.l @r4,r3");                      /* r3 = cycles_needed */
		emit("mov.l execinfo_addr%d,r5",ln);       /* r5 = execinfo_ptr */
		emit("mov.b @r5,r0");                      /* r0 = execinfo */
		emit("tst #1,r0");                         /* testear estado de ejecucion */
		emit("bt .cpuidle");
		emit("mov.l io_cycle_counter_addr%d,r1",ln); /* r1 = io_cycle_counter address */
		emit("mov.l @r1,r7");                      /* r7 = io_cycle_counter */
		emit("sub r7,r3");                         /* r3 = cycles_needed - io_cycle_counter */

		emit(".cpuidle:");
		emit("mov.l cycles_counter_addr%d,r2",ln); /* r2 = cycles_counter address */
		emit("mov.l @r2,r6");                      /* r6 = cycles_counter */
		emit("add r3,r6");
		emit("mov.l r6,@r2");                      /* cycles_counter += r3 */
		/* Reinicializacion */
		emit("tst #1,r0");
		emit("bt .cpuidle2");
		emit("mov.l @r1,r3");
		emit(".cpuidle2:");
		emit("mov.l r3,@r4");                      /* cycles_needed = r3 */
		emit("mov.l @r2,r0");                      /* r0 = cycles_counter (retorno) */
		emit("xor r1,r1");
		emit("rts");
		emit("mov.l r1,@r2");                      /* cycles_counter = 0 */

		align(2);
		gen_mt("execinfo",ln);
		gen_mt("cycles_needed",ln);
		gen_mt("io_cycle_counter",ln);
		gen_mt("cycles_counter",ln);
	}
	else
	{
		emit("rts");
		emit("mov #-1,r0");
	}
}

/**********************************************************/
/*  m68k_control_cycles_counter(n)                        */
/*  Retorna el cycles_counter y lo reinicializa si        */
/*  cycles_counter = n                                    */
/*  Parametro: ciclos = n                                 */
/*  Retorno: cycles_counter                               */
/**********************************************************/
static void gen_control_cycles_counter(void)
{
	gen_proc_header("control_cycles_counter");

	if (cycles_counting)
	{
		emit("tst r4,r4");
		emit("bf _%s_trip_cycles_counter",fprefix);
		emit("bra _%s_get_cycles_counter",fprefix);
		emit("nop");
		emit("rts");
		emit("nop");
	}
	else
	{
		emit("rts");
		emit("mov #-1,r0");
	}
}

/******************************************************/
/*  m68k_release_timeslice()                          */
/*  Finaliza la ejecucion del micro                   */
/*   los ciclos sin ejecutar quedan en cycles_counter */
/*  Parametro: Ninguno                                */
/*  Retorno: Ninguno                                  */
/******************************************************/
static void gen_release_timeslice(void)
{
	int ln = lntag++;

	gen_proc_header("release_timeslice");
	if (cycles_counting)
	{
		emit("mov.l execinfo_addr%d,r0",ln);
		emit("mov.w @r0,r0");                /* r0 = execinfo */
		emit("tst #1,r0");
		emit("bt cpu_idle");

		emit("mov.l cycles_needed_addr%d,r1",ln);
		emit("mov.l @r1,r0");               /* r0 = cycles_needed */
		emit("mov.l io_cycle_counter_addr%d,r2",ln);
		emit("mov.l @r2,r3");               /* r3 = io_cycle_counter */
		emit("sub r0,r3");
		emit("mov.l r3,@r2");

		emit("cpu_idle:");
		emit("mov.l cycles_needed_addr%d,r1",ln);
		emit("mov #0,r0");
		emit("rts");
		emit("mov.l r0,@r1");

		align(2);
		gen_mt("execinfo",ln);
		gen_mt("cycles_needed",ln);
		gen_mt("io_cycle_counter",ln);
	}
	else
	{
		emit("rts");
		emit("mov #0,r0");
	}
}

/******************************************************/
/*  m68k_add_cycles()                                 */
/*  Incrementa los ciclos de reloj a ejecutar por la  */
/*  CPU en las llamadas a emulate                     */
/*  Parametro: Ninguno                                */
/*  Retorno: Ninguno                                  */
/******************************************************/
static void gen_add_cycles(void)
{
	int ln = lntag++;

	gen_proc_header("add_cycles");

	if (cycles_counting)
	{
		emit("mov.l cycles_counter_addr%d,r0",ln);
		emit("mov.l @r0,r1");
		emit("add r4,r1");
		emit("mov.l r1,@r0");
		emit("rts");
		emit("mov #0,r0");

		align(2);
		gen_mt("cycles_counter",ln);
	}
	else
	{
		emit("rts");
		emit("mov #-1,r0");
	}
}

/******************************************************/
/*  m68k_release_cycles()                             */
/*  Decrementa los ciclos de reloj a ejecutar por la  */
/*  CPU en las llamadas a emulate                     */
/*  Parametro: Ninguno                                */
/*  Retorno: Ninguno                                  */
/******************************************************/
static void gen_release_cycles(void)
{
	int ln = lntag++;

	gen_proc_header("release_cycles");

	if (cycles_counting)
	{
		emit("mov.l cycles_counter_addr%d,r0",ln);
		emit("mov.l @r0,r1");
		emit("sub r4,r1");
		emit("mov.l r1,@r0");
		emit("rts");
		emit("mov #0,r0");

		align(2);
		gen_mt("cycles_counter",ln);
	}
	else
	{
		emit("rts");
		emit("mov #-1,r0");
	}
}

/*****************************************************************************/
/* m68k_get_cpu_state()                                                      */
/* No recibe parametros                                                      */
/* Retorna el estado de la CPU                                               */
/*****************************************************************************/
static void gen_get_cpu_state(void)
{
	int ln = lntag++;

	gen_proc_header("get_cpu_state");

	emit("mov.l execinfo_addr%d,r0",ln);
	emit("mov.w @r0,r0");
	emit("rts");
	emit("extu.w r0,r0");

	align(2);
	gen_mt("execinfo",ln);
}

/***************************************************************************/
/* Generacion del codigo de la API                                         */
/***************************************************************************/
static void gen_api(void)
{
	emit(".text");
	emit("top:");

	gen_init();
	gen_emulate();
	gen_reset();
	gen_raise_irq();
	gen_lower_irq();
/*    gen_burst_irq(); */
	gen_set_irq_type();
	gen_get_irq_vector();
	gen_change_irq_vector();
	gen_get_context_size();
	gen_get_context();
	gen_set_context();
	gen_get_register();
	gen_get_pc();
	gen_set_register();
	gen_fetch();
	gen_get_cycles_counter();
	gen_control_cycles_counter();
	gen_trip_cycles_counter();
	gen_release_timeslice();
	gen_add_cycles();
	gen_release_cycles();
	gen_get_cpu_state();
}

/***************************************************************************/
/* Atiende las interrupciones pendientes                                   */
/***************************************************************************/

static void flush_irqs(int ln)
{
	int cycles = 44; /* ciclos empleados en la generacion de la IRQ */

	emit("mov.l interrupts_addr,r0"); /* r0 = interrupts addr */
	emit("mov #7,r5");              /* r5 = contador del bucle */
	emit("mov r5,r1");
	emit("mov.b @r0,r2");           /* r2 = interrupts */
	emit("and r10,r1");             /* r1 = PPL */
	emit("sub r1,r5");              /* r5 = 7 - PPL */
	emit("mov #7,r1");
	emit("shll16 r2");
	emit("shll8 r2");               /* colocar bits interrupciones en r2 */

	/* Bucle principal de testeo de interrupciones activas */
	emit(".loop:");
	emit("shll r2");                /* bit interrupcion -> T */
	emit("bt .int");                /* interrupcion en este nivel */
	emit("dt r5");
	emit("cmp/pl r5");
	emit("bt/s .loop");
	emit("dt r1");
	
	/* Si el bucle llega al final, no hay interrupciones */
	emit("bra .noint");
	emit("mov #0,r0");              /* r0 = 0 no se atienden interrupciones */

	align(5);
	emit(".int:");
	/* cargar de nuevo el valor de las ints. */	
	emit("mov.b @r0,r2");
	emit("mov r1,r5");
	emit("mov #1,r1");

//    emit("and r2,r1");               /* r1 = autodown IRQs (auto=0) */

	emit("shld r5,r1");
	emit("xor r1,r2");              /* Desactivar la interrupcion si es automatico */
	save_reg("r5");
	emit("mov.b r2,@r0");

	/* r5 a la entrada contiene el nivel de interrupcion q se va a atender */
	emit("mov.b @(r0,r5),r4");
	emit("mov #0,r5");

	emit("mov.l g1_exception_addr,r0");
	emit("jsr @r0");
	emit("shll2 r4");               /* por 4 para obtener la direccion en la tabla */
	
	emit("mov #0xf8,r0");           /* r0 = mascara del PPL */
	restore_reg("r5");

	emit("and r0,r10");             /* reinicia int. enmascarando PPL a 0 */

	emit("mov.l iackhandler_addr,r0"); /* comprobar si hay rutina de acknowledge */
	emit("mov.l @r0,r1");

	if (irq_cycles)
		emit("add #-%d,r7",cycles); /* decrementar ciclos de atencion int. */

	emit("or r5,r10");              /* cargar nuevo PPL */
	emit("tst r1,r1");
	emit("bt .intdone");                    /* si no la hay, continuar */

	/* generacion del callback */
	save_reg("r3");
	core_exit(ln);
	emit("jsr @r1");                /* llamada al manejador iack */
	emit("nop");
	core_enter(ln);
	restore_reg("r3");

	emit(".intdone:");
	emit("mov #1,r0");              /* r0 = 1 interrupciones en atencion */

	emit(".noint:");
}

/***************************************************************************/

/* Decrementa los ciclos de reloj y chequea el estado del contador */
static void dec_cycles(int cycles)
{
	if(cycles > 0)                       /* Hay que decrementar ciclos */
	{
		if (cycles > 128)                /* ninguna instruccion consume mas de 256 ciclos */
		{
			emit("add #-128,r7");
			emit("add #-%d,r7",cycles-128);
		}
		else
			emit("add #-%d,r7",cycles);  /* restar ciclos (parametro) */
	}
}

/* Testea si contador de ciclos <= 0 */
static void test_cycles(void)
{
	emit("cmp/pl r7");                   /* activar bandera T si r7 > 0 */
}

/* Carga el opcode de la memoria segun endianness */
/* e incrementa el ptr de los opcodes */
static void timing_load_opcode(int cycles)
{
	emit("mov.w @r6+,r0");	    /* Cargar opcode en r2 (extiende la palabra!) */
	dec_cycles(cycles);
	emit("shll2 r0");           /* por 4 */
	test_cycles();
}

/* Decrementa el contador de ciclos y continua la ejecucion si procede */
static void timing(int cycles)
{
	int ln = lntag++;

	use_idxr = 0;

	timing_load_opcode(cycles);
	emit("bt/s fdl%d",ln);
	emit("mov.l @(r0,r12),r4");
	
	emit("mov.l @(execexit_addr-areg,r14),r4");

	emit("fdl%d:",ln);
	exec_opcode();
}

/* Este ret_timing realiza ademas un chequeo de la bandera de traza */
/* Se utiliza tras las instrucciones que tienen capacidad de modificar */
/* el valor de la bandera */
static void timing_cp(int cycles)
{
	int ln = lntag++;

	use_idxr = 0;

	timing_load_opcode(cycles);
	emit("bt/s continue%d",ln);
	emit("mov.l @(r0,r12),r4");

	emit("bra fdl%d",ln);
	emit("mov.l @(execexit_addr-areg,r14),r4");

	/* La ejecucion continua */
	emit("continue%d:",ln);

	if (emulate_trace)
	{
		emit("lds r0,MACL");

		emit("mov r10,r0");
		emit("tst #0x80,r0");
		emit("bt fde%d",ln);

		emit("mov.l execinfo_ptr%d,r1",ln);
		emit("mov.w @r1,r0");
		emit("mov.l trace_excep_ptr%d,r2",ln);
		emit("sub r5,r6");
		emit("jmp @r2");
		emit("add #-2,r6");

		emit("fde%d:",ln);
		emit("sts MACL,r0");
	}

	emit("fdl%d:",ln);
	exec_opcode();

	if (emulate_trace)
	{
		align(2);
		emit("execinfo_ptr%d: .long execinfo",ln);
		emit("trace_excep_ptr%d: .long trace_excep",ln);
	}
}

/* Genera una excepcion de grupo 0 (ERROR DE BUS y ERROR DE DIRECCION) */
static void gen_g0_error_exception(int error_type, int access_type)
{
	int ln = lntag++;

	emit("mov.l excep_ptr_addr%d,r0",ln);
	emit("mov.l @r0,r15");                /* cargar ptr. de pila -> salir abruptamente */

	save_reg("r3");         /* salvar Z */

	/* Introducir valores necesarios para excepcion en la pila */
	/* INSTRUCTION REGISTER */
	if ((access_type == READ_DATA_TYPE) || (access_type == WRITE_DATA_TYPE))
	{
		emit("add #-2,r6");           /* Direccion instruccion ejecutada */
		emit("mov.l inst_reg_addr%d,r0",ln);
		emit("mov.w @r6+,r3");    /* Instruccion que causo la excepcion */
		emit("mov.w r3,@r0");     /* inst_reg = instruccion */
	}
	else
	{
		/* SPECIAL WORD */
		emit("xor r2,r2");        /* Limpiar r2 para cargar datos de la palabra */
		emit("mov.l inst_reg_addr%d,r0",ln);
		emit("mov.w r2,@r0");
	}

	/* r2 contendra la palabra especial */
	/* Cargar bits de funcion y de R/W */
	emit("mov #0x20,r0");
	emit("tst r0,r10");
	emit("movt r2");            /* Usuario -> r2 = 1; Supervisor -> r2 = 0 */
	emit("add #1,r2");          /* Usuario -> BL = 10; Supervisor -> BL = 1 */
	emit("shll2 r2");           /* Colocar bit en su lugar */

	/* Cargar tipo operacion (programa, lectura, escritura) */
	switch(access_type)
	{
		case PROGRAM_TYPE:
			emit("mov #0x10,r0");
			emit("or r0,r2");
			emit("add #2,r2");
			break;
		case READ_DATA_TYPE:
			emit("mov #0x10,r0");
			emit("or r0,r2");      /* No lleva break */
		case WRITE_DATA_TYPE:
			emit("add #1,r2");
			break;
	}

	/* Instruccion / No Instruccion */
	/* Actualmente este bit no se emula */
	emit("mov #0xF7,r0");
	emit("and r0,r2");       /* Bit desactivado */
	emit("mov.l g0_spec_info_addr%d,r0",ln);
	emit("mov.b r2,@r0");

	/* Cargar en r2 la direccion accedida */
	switch (access_type)
	{
		case PROGRAM_TYPE: emit("mov r6,r2"); break;
		case READ_DATA_TYPE:
		case WRITE_DATA_TYPE: emit("mov r4,r2");
	}

	emit("mov.l execinfo_addr%d,r1",ln);
	emit("mov.w @r1,r0");                 /* cargar execinfo para activar nuevo estado */

	switch(error_type)
	{
		case ADDRESS_ERROR:
			emit("or #0x40,r0");          /* bit de atencion error de bus activado */
			emit("mov #0x0C,r4");         /* direccion de la excepcion ERROR DE DIRECCION */
			break;
		case BUS_ERROR:
			emit("or #0x20,r0");          /* bit de atencion error de bus activado */
			emit("mov #0x8,r4");          /* direccion de la excepcion ERROR DE BUS */
			break;
	}

	emit("mov.w r0,@r1");                 /* volcado de execinfo */

	restore_reg("r3");

	/* Generar excepcion */
	emit("mov.l group_0_exception_addr%d,r1",ln);
	emit("jmp @r1");
	emit("nop");

	align(2);
	gen_mt("excep_ptr",ln);
	gen_mt("g0_spec_info",ln);
	gen_mt("group_0_exception",ln);
	gen_mt("inst_reg",ln);
	gen_mt("execinfo",ln);
}

/****************************************************************************/
/* Realiza un calculo de la base con cache de region						*/
/****************************************************************************/
void get_new_pc(char *bf_addr)
{
	emit("mov.l %s,r0",bf_addr);
	emit("jsr @r0");                /* rutina para calculo de la base */
	emit("nop");

	emit("add r5,r6");              /* agregar base al PC */
}

/***************************************************************************/
/* Esta funcion se encarga de generar la base para un PC del 68k           */
/* Parametros: 68K PC en ESI / r5                                          */
/* Retorno: Nueva base en EBP / r4                                         */
/***************************************************************************/
static void gen_basefunction(void)
{
	align(5);
	emit("basefunction:");

	maskaddress("r6");           /* Enmascarar a los 24 primeros bits de direccion */

	if (emulate_group_0 || direct_mapping)
		emit("mov r6,r0");

	if(emulate_group_0)
	{
		emit("tst #1,r0");
		emit("bt access_ok");

		/* Acceso a memoria impar: ERROR DE DIRECCION */
		gen_g0_error_exception(ADDRESS_ERROR,PROGRAM_TYPE);

		emit("access_ok:");
	}

	if (direct_mapping)
	{
		/* Obtencion de la region mediante la tabla de indices */
		emit("mov #-12,r1");         /* desplazar 12 bits direccion */
		emit("shld r1,r0");          /* r0 = banco de memoria del PC 68k */
		emit("mov.l @r11,r1");       /* banco de fetch_idx a r1 */
		emit("shll2 r0");
		emit("mov.l @(r0,r1),r0");
		emit("tst r0,r0");
		emit("bt outofrange");

		emit("rts");
		emit("mov.l @(8,r0),r5");    /* cargar base del PC en r5 */
	}
	else
	{
		emit("mov.l fetch_ptr,r1");
		emit("mov.l @r1,r1");

		emit("search_ms:");
		emit("mov.l @r1,r0");
		emit("cmp/hs r0,r6");

		emit("bf nextms");

		emit("mov.l @(4,r1),r0");
		emit("cmp/hi r6,r0");
		emit("bt getbase");
		
		emit("nextms:");
		emit("cmp/eq #-1,r0");
		emit("bt outofrange");
		
		emit("bra search_ms");
		emit("add #12,r1");          /* a la siguiente estructura */

		emit("getbase:");
		emit("rts");
		emit("mov.l @(8,r1),r5");
	}

	emit("outofrange:");
	if(emulate_group_0)
	{
		gen_g0_error_exception(BUS_ERROR,PROGRAM_TYPE);
	}
	else
	{
		emit("xor r5,r5");
		emit("mov.l execinfo_addr%d,r1",lntag);
		emit("mov.w @r1,r0");
		emit("or #2,r0");
		emit("rts");
		emit("mov.w r0,@r1");

		align(2);
		gen_mt("execinfo",lntag);
		lntag++;
	}
	if (!direct_mapping)
		emit("fetch_ptr: .long fetch");
}

/* Cargar banderas de r3 al falso CCR (r8) */
static void cl2ccr(void)
{
	load_ccr_from("r3");
}

/* Cargar las banderas de r3 en el SR cambiando de modo si es necesario */
/* r3 no se modifica */
static void setup_sr(void)
{
	int ln = lntag;

	lntag += 2;

	emit("mov r3,r0");
	emit("shlr8 r0");
	emit("xor r10,r0");    /* bit S antiguo ^ bit S nuevo */
	emit("tst #0x20,r0");
	emit("bt ln%d", ln);

	/* intercambiar ptr. de pila */
	swap_sps();

	/* y poner el mapa de memoria requerido */
	if (multiaddr)
	{
		emit("mov r10,r0");
		emit("tst #0x20,r0");   /* chequear S */
		emit("bf ln%d", ln+1);  /* y cambiar de estado */

		set_memory_map('s',ln);
		emit("bra ln%d",ln);
		emit("nop");

		emit("ln%d:", ln+1);
		set_memory_map('u',ln+1);

	}
	emit("ln%d:", ln);
	emit("mov r3,r0");
	emit("shlr8 r0");     /* r0 = nuevo BS */
	emit("and #0xA7,r0"); /* aislar TF, SF, PPL */
	emit("mov r0,r10");   /* nuevo BS */

	load_ccr_from("r3");
}

/* Cargar banderas del falso CCR a r3 (byte bajo) */
static void load_from_ccr(void)
{
	emit("mov r8,r0");   /* r0 = ?????VCN */
	emit("mov r9,r1");   /* r1 = 0000000X */
	emit("shlr r0");     /* T = N */
	emit("addc r1,r1");  /* r1 = ??????XN */
	emit("tst r3,r3");   /* T = Z */
	emit("addc r1,r1");  /* r1 = ?????XNZ */
	emit("and #3,r0");   /* r0 = 000000VC */
	emit("mov r1,r3");   /* r3 = ?????XNZ */
	emit("shll2 r3");    /* r3 = ???XNZ00 */
	emit("or r0,r3");    /* r3 = ???XNZVC */
}

/* Cargar banderas del falso CCR y del BS a r3 */
static void load_sr(void)
{
	load_from_ccr();
	emit("mov r10,r0");    /* r0 = BS */
	emit("shll8 r0");      /* colocar BS */
	emit("or r0,r3");      /* r3 = SR */
}

/* Cambia el modo de ejecucion a supervisor si no esta ya */
static void supervisor(void)
{
	int ln=lntag++;

	emit("mov #0x20,r0");
	emit("tst r0,r10");              /* Chequear bit de modo supervisor */
	emit("bf ln%d",ln);              /* Si esta activado, salir */

	emit("or r0,r10");               /* Fijar modo supervisor */

	/* Intercambiar los ptrs de pila */
	swap_sps();

	/* Fijar mapa de memoria a usar y estado supervisor */
	set_memory_map('s',ln);            /* Mapa de memoria a usar */

	emit("ln%d:",ln);
}

/***************************************************/
/* Carga el ptr de la estructura de acceso a datos */
/* da = data access type (r = read/w = write)      */
/* size = tamano del dato                          */
/* save = salvar direccion de acceso               */
/* retorno r0 ptr. a estructura                    */
/***************************************************/
static void load_da_struct(char da, int size, int save)
{
	int ln = lntag++;
	char *sname = sizename[size];
	char *dname = (da=='w')?"write":"read";

	if (save)
	{
		save_reg("r4");
		maskaddress("r4");
	}

	if (direct_mapping)
	{
		emit("mov #-12,r1"); /* desplazar 12 bits r0 (para calcular banco) */
		emit("mov r4,r0");
		emit("shld r1,r0");  /* r0 = banco de memoria 68k */

		switch(da)
		{
			case 'r':
				if (size == BYTE)
					emit("mov.l @(readbyte_idx-fetch_idx,r11),r1");
				else
					emit("mov.l @(readword_idx-fetch_idx,r11),r1");
				break;
			case 'w':
				if (size == BYTE)
					emit("mov.l @(writebyte_idx-fetch_idx,r11),r1");
				else
					emit("mov.l @(writeword_idx-fetch_idx,r11),r1");
		}

		emit("shll2 r0");
		emit("mov.l @(r0,r1),r0");    /* r0 ptr. a estructura */

		emit("tst r0,r0");
		emit("bt %s%c_outofrange",dname,sizeid[size]);  /* si r0 = 0 -> fuera de rango */

	}
	else
	{
		emit("mov.l %s%s_idx,r1",dname,sname);
		emit("mov.l @r1,r1");

		emit("search_dms%c%d%d:",da,size,ln);
		emit("mov.l @r1,r0");
		emit("cmp/hs r0,r4");
		emit("bf nextdms%c%d%d",da,size,ln);

		emit("mov.l @(4,r1),r0");
		emit("cmp/hs r4,r0");
		emit("bt getstruct%c%d%d",da,size,ln);
		
		emit("nextdms%c%d%d:",da,size,ln);
		emit("cmp/eq #-1,r0");
		emit("bt %s%c_outofrange",dname,sizeid[size]);  /* si r0 = 0 -> fuera de rango */
		
		emit("bra search_dms%c%d%d",da,size,ln);
		emit("add #16,r1");       /* a la siguiente estructura */
		
		emit("getstruct%c%d%d:",da,size,ln);
		emit("mov r1,r0");            /* se opera con r0 en las funciones */
	}
}

/* Recuperar direccion de acceso */
static void recover_reg_mem_handler(void)
{
	restore_reg("r4");

}

/**********************************************************/
/* Chequear direccion de acceso                           */
/* Parametros:                                            */
/* size = tamano del dato (BYTE, WORD, LONG)              */
/* at = tipo de acceso (READ_DATA_TYPE, WRITE_DATA_TYPE)  */
/**********************************************************/
static void check_address(int size, int at)
{
	int ln;

	if (emulate_group_0)
	{
		/* Testear accesos de memoria impar tamaño WORD (LONG es doble WORD) */
		if ((size == WORD) || (size == LONG))
		{
			ln = lntag++;
			emit("mov r4,r0");
			emit("tst #1,r0");       /* acceso a memoria impar? */
			emit("bt .addr_ok%d",ln);

			/* Acceso a memoria impar: ERROR DE DIRECCION */
			gen_g0_error_exception(ADDRESS_ERROR,at);

			align(5);
			emit(".addr_ok%d:",ln);
		}
	}
}

/***************************************************************************/
/* Chequea acceso de palabra larga a dos bancos de memoria simultaneamente */
/* Parametros:                                                             */
/* at = tipo de acceso ('r' - read ; 'w' - write                           */
/* matype = acceso a memoria ("" - nativo ; "io" - manejado                */
/***************************************************************************/
static void check_middle_access(char at, char *matype)
{
	if (multi_bank)
	{
		if (at == 'r')
		{
			emit("mov.l @(4,r0),r3"); /* cargar direccion alta en r3 */
			emit("add #-2,r3");       /* direccion limite */
			emit("cmp/hi r3,r4");     /* si es mayor que la dir. alta */
			emit("bt readl_%ssplit",matype);     /* lectura partida */
		}
		else
		{
			emit("mov.l @(4,r0),r1");    /* cargar direccion alta en r1 */
			emit("add #-2,r1");          /* direccion limite */
			emit("cmp/hi r1,r4");        /* si es mayor que la dir. alta */
			emit("bt writel_%ssplit",matype);     /* escritura partida */
		}
	}
}

/***************************************************/
/* Genera acceso a memoria fuera de rango          */
/* Parametros:                                     */
/* at = tipo de acceso ('r' - read ; 'w' - write)  */
/***************************************************/
static void gen_mem_outofrange(char at)
{
	if (emulate_group_0)
		gen_g0_error_exception(BUS_ERROR,(at == 'r')?READ_DATA_TYPE:WRITE_DATA_TYPE);
	else
	{
		if (at == 'r')
			emit("mov #-1,r3");          /* codigo de retorno */
		emit("rts");
		recover_reg_mem_handler();
	}
}

/************************************************/
/* Leer un byte/word de una posicion de memoria */
/* La direccion se pasa como parametro en r4    */
/************************************************/
static void gen_rbw_handlers(int size)
{
	int ln = lntag++;

	char z = sizeid[size];

	align(5);
	emit("readmemory%s:",sizename[size]);

	/* Chequear accesos a memoria a direccion impar en palabra */
	check_address(size,READ_DATA_TYPE);
	load_da_struct('r',size,1);

	emit("mov.l @(8,r0),r1");        /* r1 = manejador de memoria */
	emit("tst r1,r1");               /* comprobar si hay ptr. de funcion manejadora */
	emit("bf read%c_callio",z);      /* si la hay, realizar llamada */

	emit("mov.l @(12,r0),r0");       /* ptr. a zona de memoria */

	if(size == BYTE)
	{
		emit("add r4,r0");
		emit("xor #1,r0");           /* cambio de endianness */
		emit("mov.b @r0,r3");        /* carga dato en r3 (extendido) */
	}
	else
		emit("mov.w @(r0,r4),r3");   /* cargar dato */

	emit("rts");
	recover_reg_mem_handler();

	/* Lectura de BYTE/WORD mediante manejador */
	align(5);
	emit("read%c_callio:",z);
	save_reg("r2");                  /* salvar r2 (indice reg) */
	core_exit(ln);                   /* cambio de ambito de ejecución */
	emit("sts.l	pr,@-r15");
	emit("jsr @r1");                 /* llamada al manejador */
	emit("nop");
	emit("exts.%c r0,r3",z);         /* siempre carga extendida */
	emit("lds.l	@r15+,pr");
	core_enter(ln);                  /* volver al fantastico ensamblador */
	restore_reg("r2");               /* recuperar r2 (indice reg) */
	emit("rts");
	recover_reg_mem_handler();

	/* Direccion fuera de rango o no mapeada: ERROR DE BUS */
	emit("read%c_outofrange:",z);
	if (size == WORD)
		gen_mem_outofrange('r');
	else
	{
		emit("bra readw_outofrange");
		emit("nop");
	}

	align(2);
	gen_mt("io_cycle_counter",ln);
	if (!direct_mapping)
		emit("read%s_idx: .long read%s",sizename[size],sizename[size]);
}

/************************************************/
/* Leer un dword de una posicion de memoria     */
/* La direccion se pasa como parametro en r4    */
/************************************************/
static void gen_rl_handler(void)
{
	int ln = lntag++;

	align(5);
	emit("readmemory%s:",sizename[LONG]);

	/* Chequear accesos a memoria a direccion impar en palabra */
	check_address(LONG,READ_DATA_TYPE);
	load_da_struct('r',LONG,1);

	emit("mov.l @(8,r0),r1");    /* cargar manejador en r1 */
	emit("tst r1,r1");           /* comprobar si hay ptr. de funcion manejadora */
	emit("bf readl_callio");     /* si la hay, realizar llamada */

	/* Chequear posible acceso a doble banco simultaneamente */
	check_middle_access('r',"");

	/* Lectura no particionada */
	emit("mov.l @(12,r0),r1");   /* r1 = ptr. zona de memoria */
	emit("add r1,r4");           /* r4 = dir. palabra baja + ptr */

	/* carga de la palabra larga */
	load_dword("r4","r3","r0", DW_AIND);
	emit("rts");
	recover_reg_mem_handler();

	/* ERROR DE BUS */
	emit("readl_outofrange:");
	emit("bra readw_outofrange");
	emit("nop");

	/* Lectura de LONG mediante manejador */
	align(5);
	emit("readl_callio:");
	/* Chequear posible acceso a doble banco simultaneamente */
	check_middle_access('r',"io");

	/* Lectura de E/S no particionada */
	save_reg("r2");              /* salvar reg. indice */
	emit("sts.l	pr,@-r15");
	save_reg("r4");
	save_reg("r1");              /* salvar ptr. al manejador */
	core_exit(ln);               /* cambio de ambito */
	emit("jsr @r1");             /* llamada al manejador */
	emit("nop");

	restore_reg("r1");           /* recuperar ptr. manejador */
	restore_reg("r4");           /* recuperar direccion */
	save_reg("r0");              /* salvar palabra leida (alta) */
	emit("jsr @r1");             /* llamada al manejador */
	emit("add #2,r4");           /* r4 = direccion palabra baja */

	restore_reg("r3");           /* recuperar palabra alta */
	emit("lds.l	@r15+,pr");

	emit("shll16 r3");           /* colocar palabra alta */
	emit("extu.w r0,r0");        /* enmascarar palabra baja */
	restore_reg("r2");
	emit("or r0,r3");            /* cargar resultado en r3 */

	core_enter(ln);              /* volver a nuestro querido ensamblador */
	emit("rts");
	recover_reg_mem_handler();

	/* Lectura de palabra larga particionada */
	if (multi_bank)
	{
		align(5);
		emit("readl_split:");
		emit("mov.l @(12,r0),r0");    /* r0 = ptr. zona de memoria */
		emit("mov.w @(r0,r4),r3");    /* r3 = palabra baja extendida */
		emit("add #2,r4");            /* avanzar a la siguiente palabra */

		load_da_struct('r',LONG,0);

		emit("mov.l @(8,r0),r1");    /* cargar manejador en r1 */
		emit("tst r1,r1");           /* comprobar si hay ptr. de funcion manejadora */
		emit("bf readlower_callio"); /* si la hay, realizar llamada */

		emit("mov.l @(12,r0),r0");

		emit("readlower_direct:");
		emit("shll16 r3");
		emit("mov.w @(r0,r4),r1");
		emit("extu.w r1,r1");

		emit("or r1,r3");
		emit("rts");
		recover_reg_mem_handler();

		/* Lectura de palabra larga particionada mediante manejador */
		align(5);
		emit("readl_iosplit:");
		save_reg("r2");              /* salvar reg. indice */
		core_exit(ln);               /* cambio de ambito */
		emit("sts.l	pr,@-r15");
		emit("jsr @r1");             /* llamada al manejador */
		emit("nop");
		emit("lds.l	@r15+,pr");
		core_exit(ln);
		emit("mov r0,r3");           /* retorno de valor en r0 -> resultado en r3 */
		restore_reg("r2");           /* recuperar reg. indice */

		load_da_struct('r',LONG,0);

		emit("mov.l @(8,r0),r1");    /* cargar manejador en r1 */
		emit("tst r1,r1");           /* comprobar si hay ptr. de funcion manejadora */
		emit("bf readlower_callio");     /* si la hay, realizar llamada */

		emit("bra readlower_direct");
		emit("mov.l @(12,r0),r0");

		/* Lectura de palabra baja particionada mediante manejador */
		align(5);
		emit("readlower_callio:");
		save_reg("r2");              /* salvar reg. indice */
		save_reg("r3");              /* salvar palabra baja extendida */
		core_exit(ln);               /* cambio de ambito */
		emit("sts.l	pr,@-r15");
		emit("jsr @r1");             /* llamada al manejador */
		emit("nop");
		emit("lds.l	@r15+,pr");
		core_exit(ln);
		restore_reg("r2");           /* recuperar reg. indice */
		emit("extu.w r0,r3");        /* cargar parte baja a r3 */
		restore_reg("r1");           /* recuperar palabra baja */
		emit("shll16 r1");
		emit("or r1,r3");
		emit("rts");
		recover_reg_mem_handler();
	}

	align(2);
	gen_mt("io_cycle_counter",ln);
	if (!direct_mapping)
		emit("readdword_idx: .long readword");
}

/* Escritura en memoria de BYTE/WORD */
static void gen_wbw_handlers(int size)
{
	int ln = lntag++;
	char z = sizeid[size];

	align(5);
	emit("writememory%s:",sizename[size]);
	check_address(size,WRITE_DATA_TYPE);
	load_da_struct('w',size,1);

	emit("mov.l @(8,r0),r1");       /* cargar manejador en r1 */
	emit("tst r1,r1");              /* comprobar si hay ptr. de funcion manejadora */
	emit("bf write%c_callio",z);

	emit("mov.l @(12,r0),r0");      /* r0 = ptr. a zona de memoria */

	if (size == BYTE)
	{
		emit("add r4,r0");
		emit("xor #1,r0");          /* cambio de endianness */
		emit("mov.b r3,@r0");       /* cargar dato en memoria */
	}
	else
		emit("mov.w r3,@(r0,r4)");  /* cargar dato en memoria */

	emit("rts");
	recover_reg_mem_handler();

	/* Direccion fuera de rango o no mapeada: ERROR DE BUS */
	emit("write%c_outofrange:",z);
	if (size == WORD)
		gen_mem_outofrange('w');
	else
	{
		emit("bra writew_outofrange");
		emit("nop");
	}

	/* Escritura de BYTE/WORD mediante manejador */
	align(5);
	emit("write%c_callio:",z);
	save_reg("r2");                  /* salvar r2 (indice reg) */
	save_reg("r3");                  /* salvar r3 (dato a escribir) para testear signo */
	core_exit(ln);
	emit("sts.l	pr,@-r15");
	emit("jsr @r1");
	emit("extu.%c r3,r5",z);         /* sin extension de signo (como FAME x86) */

	emit("lds.l	@r15+,pr");
	core_enter(ln);
	restore_reg("r3");               /* recuperar dato para testear signo */
	restore_reg("r2");               /* recuperar r2 (indice reg) */
	emit("rts");
	recover_reg_mem_handler();

	align(2);
	gen_mt("io_cycle_counter",ln);
	if (!direct_mapping)
		emit("write%s_idx: .long write%s",sizename[size],sizename[size]);
}

/* Escritura en memoria de doble palabra */
static void gen_wl_handler(void)
{
	int ln = lntag++;

	align(5);
	emit("writememory%s:",sizename[LONG]);

	check_address(LONG,WRITE_DATA_TYPE);
	load_da_struct('w',LONG,1);

	emit("mov.l @(8,r0),r1");    /* r1 = manejador de memoria */
	emit("tst r1,r1");           /* comprobar si hay ptr. de funcion manejadora */
	emit("bf writel_callio");    /* si la hay, realizar llamada */

	/* Chequear posible acceso a doble banco simultaneamente */
	check_middle_access('w',"");

	/* Escritura no particionada */
	emit("mov.l @(12,r0),r0");   /* r0 = ptr. zona de memoria */
	emit("mov r3,r1");           /* r3 (dato) no se puede modicar, se testea tras write! */
	emit("shlr16 r1");
	emit("mov.w r1,@(r0,r4)");
	emit("add #2,r4");
	emit("mov.w r3,@(r0,r4)");   /* cargar doble palabra a memoria */

	emit("rts");
	recover_reg_mem_handler();

	/* ERROR DE BUS */
	emit("writel_outofrange:");
	emit("bra readw_outofrange");
	emit("nop");

	/* Escritura de LONG mediante manejador */
	align(5);
	emit("writel_callio:");
	
	/* Chequear posible acceso a doble banco simultaneamente */
	check_middle_access('w',"io");

	/* Escritura de E/S no particionada */
	emit("mov.l @(8,r0),r1");    /* r1 = manejador de memoria */
	core_exit(ln);               /* cambio de ambito */
	save_reg("r2");              /* salvar reg. indice */
	save_reg("r3");              /* salvar dato a escribir */
	emit("sts.l	pr,@-r15");
	save_reg("r4");              /* salvar r4 = direccion de acceso */
	save_reg("r1");              /* salvar ptr. al manejador */
	emit("mov r3,r5");
	emit("jsr @r1");             /* llamada al manejador de escritura */
	emit("shlr16 r5");           /* escribir palabra alta de r5 */

	restore_reg("r1");           /* recuperar ptr. al manejador */
	restore_reg("r4");
	emit("mov.l @(4,r15),r5");   /* recuperar dato */
	emit("add #2,r4");

	emit("jsr @r1");             /* llamada al manejador de escritura */
	emit("extu.w r5,r5");        /* escribir palabra baja de r5 */
	emit("lds.l	@r15+,pr");
	restore_reg("r3");
	restore_reg("r2");
	core_enter(ln);
	emit("rts");
	recover_reg_mem_handler();

	/* Escritura de palabra larga particionada */
	if (multi_bank)
	{
		align(5);
		emit("writel_split:");
		emit("mov.l @(12,r0),r0");   /* cargar ptr. zona de memoria */
		emit("mov r3,r1");           /* cargar en r1 para preparar dato a escribir */
		emit("shlr16 r1");
		emit("mov.w r1,@(r0,r4)");   /* volcado de palabra alta */
		emit("add #2,r4");

		load_da_struct('w',LONG,0);

		emit("mov.l @(8,r0),r1");    /* cargar manejador en r1 */
		emit("tst r1,r1");           /* comprobar si hay ptr. de funcion manejadora */
		emit("bf writelower_callio");/* si la hay, realizar llamada */

		emit("mov.l @(12,r0),r0");

		emit("writelower_direct:");
		emit("mov.w r3,@(r0,r4)");
		emit("rts");
		recover_reg_mem_handler();

		/* Escritura de palabra larga particionada mediante manejador */
		align(5);
		emit("writel_iosplit:");
		emit("mov.l @(8,r0),r1");    /* r1 = manejador de memoria */
		core_exit(ln);               /* cambio de ambito */
		emit("mov.l @r15,r5");       /* cargar dato a escribir */
		save_reg("r2");              /* salvar reg. indice */
		save_reg("r3");              /* salvar dato a escribir */
		save_reg("r4");              /* salvar r4 = direccion de acceso */
		emit("sts.l	pr,@-r15");
		emit("mov r3,r5");           /* cargar dato a escribir en r5 (2nd par) */
		emit("jsr @r1");             /* llamada al manejador de escritura */
		emit("shlr16 r5");           /* escribir palabra alta de r5 */

		emit("lds.l	@r15+,pr");
		restore_reg("r4");           /* restaurar direccion acceso */
		restore_reg("r3");           /* recuperar dato a escribir */
		emit("add #2,r4");           /* siguiente palabra */
		restore_reg("r2");           /* recuperar reg. indice */
		core_enter(ln);

		load_da_struct('w',LONG,0);

		emit("mov.l @(8,r0),r1");    /* cargar manejador en r1 */
		emit("tst r1,r1");           /* comprobar si hay ptr. de funcion manejadora */
		emit("bf writelower_callio");/* si la hay, realizar llamada */

		emit("bra writelower_direct");
		emit("mov.l @(12,r0),r0");   /* cargar ptr zona de memoria */
		/* Fin de escritura de palabra larga particionada mediante manejador */

		/* Escritura de palabra baja particionada mediante manejador */
		align(5);
		emit("writelower_callio:");
		core_exit(ln);               /* cambio de ambito */
		save_reg("r2");              /* salvar reg. indice */
		save_reg("r3");              /* salvar dato a escribir */
		emit("sts.l	pr,@-r15");
		emit("jsr @r1");             /* llamada al manejador de escritura */
		emit("extu.w r3,r5");        /* r5 = palabra a escribir sin extension */
		emit("lds.l	@r15+,pr");
		restore_reg("r3");
		restore_reg("r2");
		core_enter(ln);
		emit("rts");
		recover_reg_mem_handler();
	}

	align(2);
	gen_mt("io_cycle_counter",ln);
	if (!direct_mapping)
		emit("writedword_idx: .long writeword");
}

/****************************************/
/* EXCEPCIONES del GRUPO 0              */
/* ERROR DE BUS Y DE DIRECCION          */
/* RESET se trata por separado          */
/****************************************/
static void gen_g0_exception(void)
{
	int ln = lntag++;

	align(5);
	emit("group_0_exception:");
	emit("mov.l execinfo_addr%d,r2",ln);
	emit("mov.w @r2,r0");
	emit("tst #2,r0");     /* testeo para ver si existe DOBLE ERROR DE BUS */
	emit("bt/s .excflow");
	/* hay q restar aqui por si se produce otra excepcion en el read que hay despues */
	emit("add #-50,r7");   /* ciclos de reloj de la excepcion */

	emit("mov.l @(execexit_addr-areg,r14),r1");
	emit("or #4,r0");      /* 68k detenido y muerto */
	emit("mov.w r0,@r2");
	/* Doble error de bus/direccion! -> solamente se recupera con RESET externo */
	emit("jmp @r1");
	emit("add #2,r6");     /* instruccion ejecutada (simular) */

	align(5);
	emit(".excflow:");
	emit("or #2,r0");      /* atendiendo ERROR DE BUS/DIRECCION (GRUPO 0) */
	emit("and #0x7F,r0");  /* bit 7 de execinfo desactivado */
	emit("mov.w r0,@r2");

	save_reg("r3");        /* salvar Z */

	/* Leer PC destino */
	emit("mov.l readmemorydword_addr%d,r1",ln);
	emit("jsr @r1");
	emit("nop");

	emit("mov r3,r2");      /* r2 = PC destino */
	restore_reg("r3");      /* recuperar Z */
	save_reg("r3");         /* y guardar de nuevo */
	save_reg("r2");         /* PC destino a la pila */
	load_sr();
	save_reg("r3");         /* guardar SR en la pila */
	supervisor();
 	emit("mov #0x27,r0");
	emit("mov.l execinfo_addr%d,r1",ln);
	emit("and r0,r10");		                /* modo supervisor, traza desactivada */
	emit("mov.w @r1,r0");                   /* cargar execinfo para testeo */
	emit("tst #0x20,r0");
	emit("bt .bus_error");

	emit("mov r6,r3");				        /* cargar en r3 el PC con la base */
	emit("sub r5,r3");                      /* sustraer la base del PC */

	emit(".bus_error:");					/* en caso de error de bus, cargar PC */
/*	emit("mov.l io_fetchbased_pc_addr%d,r0",ln);
	emit("mov.l @r0,r3");
	emit("mov.l io_fetchbase_addr%d,r0",ln);
	emit("mov.l @r0,r0");
	emit("sub r0,r3");                   */ /* cargar el PC (sin base) en r3 */
	reg2sh(7,"r4",ADDR_REG,LONG);           /* ptr de la pila a r4 */

	/* guardar en la pila del 68k el SR y el PC sin la base */
	emit("mov.l writememorydword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-4,r4");

	restore_reg("r3");               /* r3 = SR */
	emit("mov.l writememoryword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-2,r4");

	/**************************************************************/
	/* Informacion adicional de los errores de bus y de direccion */
	/**************************************************************/
	emit("mov.l inst_reg_addr%d,r0",ln);
	emit("mov.w @r0,r3");               /* cargar registro de instruccion en r3 */
	emit("mov.l writememoryword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-2,r4");

	/* Corregir esta carga (debe cargar segun tipo de error!) */
	emit("mov r6,r3");			        /* direccion accedida (almacenada en r2) */
	emit("mov.l writememorydword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-4,r4");

	emit("mov.l g0_spec_info_addr%d,r0",ln);
	emit("mov.b @r0,r3");
	emit("mov.l writememoryword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-2,r4");
	sh2reg("r4",7,ADDR_REG,LONG);
	restore_reg("r6");	                /* devolver en r6 el PC que lleva a la rutina de trazado */
	restore_reg("r3");
	sprintf(bf_tag,"basefunction_addr%d",ln);
	get_new_pc(bf_tag);
	timing(0);				/* Los ciclos ya se decrementaron previamente */

	align(2);
	gen_mt("execinfo",ln);
	gen_mt("readmemoryword",ln);
	gen_mt("readmemorydword",ln);
	gen_mt("writememoryword",ln);
	gen_mt("writememorydword",ln);
	gen_mt("io_fetchbase",ln);
	gen_mt("io_fetchbased_pc",ln);
	gen_mt("inst_reg",ln);
	gen_mt("g0_spec_info",ln);
	gen_mt("basefunction",ln);
}

/****************************************/
/* Tipos de EXCEPCIONES del GRUPO 1 y 2 */
/* Direccion de la excepcion en r4      */
/****************************************/
static void gen_g12_exception(void)
{
	int ln = lntag++;

	align(5);
	emit("group_1_exception:");
	emit("group_2_exception:");

	emit("mov.l execinfo_addr%d,r1",ln);
	emit("mov.w @r1,r0");            /* r0 = execinfo */
	emit("and #0x7F,r0");            /* bit 7 de execinfo desactivado (stop bit) */
	emit("mov.w r0,@r1");

	/* comprobar si existe manejador de excepcion */
	emit("mov.l icusthandler_addr%d,r0",ln);
	emit("mov.l @r0,r0");
	emit("tst r0,r0");
	emit("bt .vect_except");       /* si no existe manejador, excepcion vectorizada */

	emit("mov r4,r1");             /* r4 no se puede modificar */
	emit("shll2 r1");              /* acceso a vector de palabras largas */
	emit("mov.l @(r0,r1),r1");     /* obtencion de direccion de atencion */
	emit("tst r1,r1");
	emit("bt .vect_except");       /* si no existe, excepcion built-in */

	/* generacion de exception personalizada (manejador) */
	/* r4 = parametro (vector excepcion) */
	save_reg("r3");
	writeback_sr(ln);
	core_exit(ln);
	emit("sts.l	pr,@-r15");
	emit("jsr @r1");
	emit("nop");
	emit("lds.l	@r15+,pr");
	core_enter(ln);
	restore_reg("r3");
	cache_sr(ln);
	emit("rts");
	emit("sub r5,r6");     /* r6 sin base. rebasamiento posterior */

	/* generacion de excepcion por tabla de vectores (nativo 68k) */
	align(5);
	emit(".vect_except:");

	emit("sts.l	pr,@-r15");

	save_reg("r3");
	emit("mov.l readmemorydword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("sub r5,r6");             /* r6 = PC sin base */

	emit("mov r3,r2");             /* r2 = PC destino */
	emit("mov.l @r15,r3");         /* recupero Z dejando copia en la pila */
	load_sr();                     /* recoge SR en r3 y */
	emit("mov r3,r5");             /* r5 = SR */
	supervisor();                  /* a modo supervisor */
	emit("mov #0x27,r0");
	emit("mov r6,r3");             /* r3 = PC sin la base */
	emit("and r0,r10");            /* modo supervisor, traza desact. */

	/* ptr de la pila a r4 */
	reg2sh(7,"r4",ADDR_REG,LONG);

	/* guardar en la pila del 68k el SR y el PC sin la base */
	emit("mov.l writememorydword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-4,r4");

	emit("mov r5,r3");               /* SR */

	emit("mov.l writememoryword_addr%d,r0",ln);
	emit("jsr @r0");
	emit("add #-2,r4");

	restore_reg("r3");
	sh2reg("r4",7,ADDR_REG,LONG);    /* actualizar ptr. de pila */

	emit("lds.l	@r15+,pr");

	emit("rts");
	emit("mov r2,r6");               /* r6 = PC a la rutina */

	align(2);
	gen_mt("readmemoryword",ln);
	gen_mt("readmemorydword",ln);
	gen_mt("writememoryword",ln);
	gen_mt("writememorydword",ln);
	gen_mt("icusthandler",ln);
	gen_mt("io_cycle_counter",ln);
	gen_mt("execinfo",ln);
	gen_mt("sreg",ln);
}

/***************************************************************************/
/* Violacion de privilegio                                                 */
/***************************************************************************/
static void gen_privilege_violation(void)
{
	int ln = lntag++;

	align(5);
	emit("privilege_violation:");
	emit("add #-2,r6");             /* guardar la ultima instruccion */
	emit("bsr group_1_exception");
	emit("mov #0x20,r4");			/* direccion de la excepcion de v.p. */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	timing(34);

	align(2);
	emit("bf_addr%d: .long basefunction",ln);
}

/* Obtencion de registro */
static void mask_idxr(void)
{
	emit("and r0,r2");	/* aislar bits de indice de registro */
}

/* Usar mask_idxr siempre que exista modo de direccionamiento origen */
static void sel_mask_idxr(void)
{
	switch(main_ea)
	{
		case dreg:
		case areg:
		case aind:
		case ainc:
		case adec:
		case adsp:
		case axdp: mask_idxr();
	}
}

/***************************************************************************/

/* Obtener condicion: Menor que (N^V) */
/* Se activa la bandera T del SH si condicion = false */
static void getcond_less(void)
{
	emit("mov r8,r0");   /* r0 = CCR */
	emit("shlr2 r0");    /* desplazar bandera V (solapar sobre N) */
	emit("xor r8,r0");   /* xor(V,N) */
	emit("shlr r0");     /* bit xor -> T */
}

/* Obtener condicion: Menor o igual que ((N^V)|Z) */
/* Se activa la bandera T del SH si condicion = false */
static void getcond_le(void)
{
	emit("mov r8,r0");   /* r0 = ?????VCN */
	emit("shlr2 r0");    /* r0 = 00?????V */
	emit("tst r3,r3");
	emit("xor r8,r0");   /* r0 = ???????V^N */
	emit("addc r0,r0");  /* r0 = ??????V^NZ */
	emit("tst #3,r0");   /* testear condicion */
}

/* Testea el falso CCR con tmask */
static void testcond(int tmask)
{
	emit("mov r8,r0");        /* cargar en r0 para testear */
	emit("tst #%d,r0",tmask);
}

/* Testear Z | C */
static void testcond_zorc(void)
{
	emit("tst r3,r3");   /* Z -> T */
	emit("mov r8,r0");   /* cargar para testear */
	emit("addc r0,r0");  /* r0 = ????VCNZ */
	emit("tst #5,r0");   /* testear C | Z */
}

static void set_cc(int cc)
{
	cctag = (cc == T_CC)?'t':'f';
	rctag = (cc == T_CC)?'f':'t';
}

/* Obtiene las condiciones y activa las banderas */
static void getcondition(int cc)
{
	switch(cc)
	{
		case T_CC:
		case F_CC:
			break;

		case HI_CC: /* a (Z flag or C flag clear) */
			testcond_zorc();
			set_cc(T_CC);
			break;

		case LS_CC:  /* be (Z flag or C flag set) */
			testcond_zorc();
			set_cc(F_CC);
			break;
		case CC_CC: /* nc (C flag clear) */
			testcond(0x2);
			set_cc(T_CC);
			break;

		case CS_CC: /* c (C flag set) */
			testcond(0x2);
			set_cc(F_CC);
			break;

		case NE_CC: /* ne (Z flag clear) */
			emit("tst r3,r3");
			set_cc(F_CC);
			break;

		case EQ_CC: /* e ( Z flag set) */
			emit("tst r3,r3");
			set_cc(T_CC);
			break;
		case VC_CC: /* no (V flag clear) */
			testcond(0x4);
			set_cc(T_CC);
			break;

		case VS_CC: /* o (V flag set) */
			testcond(0x4);
			set_cc(F_CC);
			break;

		case PL_CC: /* ns (N flag clear) */
			testcond(0x1);
			set_cc(T_CC);
			break;

		case MI_CC: /* s (N flag set) */
			testcond(0x1);
			set_cc(F_CC);
			break;

		case GE_CC: /* ge */
			getcond_less();
			set_cc(F_CC);
			break;

		case LT_CC: /* l */
			getcond_less();
			set_cc(T_CC);
			break;

		case GT_CC: /* g */
			getcond_le();
			set_cc(T_CC);
			break;
		case LE_CC: /* le */
			getcond_le();
			set_cc(F_CC);
			break;
	}
}

/* Actualizar banderas (NZ) del falso CCR, V = C = 0 */
/* r3 debe estar sign-extended */
static void setf_vc0(void)
{
	emit("rotl r3");     /* signo r3 -> T */
	emit("movt r8");     /* r8 = flag N */
}

/* Calcula y fija las banderas N y Z preservando el resto */
static void set_nz_from(char *reg)
{
	emit("rotl %s",reg);
	emit("addc r8,r8");
	if (reg[1] != '3') emit("mov %s,r3",reg);
}

/* Calcula las banderas N y Z preservando el resto */
static void set_nz(void)
{
	set_nz_from("r3");
}

/* Chequear violacion de privilegio */
static void priv_check(void)
{
	int ln = lntag++;

	emit("mov r10,r0");
	emit("tst #0x20,r0");      /* testear bit de supervisor */
	emit("bf pcheck_ok%d",ln);

	emit("mov.l priviolation_addr%d,r0",ln);
	emit("jmp @r0");
	emit("nop");

	align(2);
	emit("priviolation_addr%d: .long privilege_violation",ln);

	emit("pcheck_ok%d:",ln); /* continua OK (no excepcion) */
}

/*****************************************************************************/
/* GENERACION DE DIRECCION EFECTIVA                                          
*/
/*****************************************************************************/
/*
** Tipos de direccionamiento
**
** 1. Lectura:       precalc -> lectura -> postcalc
** 2. Escritura:      precalc -> escritura -> postcalc
** 3. L-M-E:      precalc -> lectura -> (modificar) -> escritura -> postcalc
** 4. Mover:       Lectura seguida de escritura
** 5. Control:    precalc
******************************************************************************/

/* Descodifica una palabra extendida en r4 */
/* No se debe utilizar r1 puesto que se usa durante los calculos de direccion */
static void gen_decode_extw(void)
{
	align(5);
	emit("decode_extw:");
	emit("mov.w @r6+,r0");        /* cargar palabra extendida */
	emit("exts.b r0,r4");         /* desp. con ext. de signo */
	emit("shlr8 r0");
	emit("shlr2 r0");
	emit("tst #0x02,r0");
	emit("and #0x3c,r0");         /* r0 = banco * 4 */
	emit("bf/s longwd");          /* salto si no T (bit 11 = 1) */
	emit("mov.l @(r0,r13),r0");
	emit("exts.w r0,r0");
	emit("longwd:");
	emit("rts");
	emit("add r0,r4");
}

/* Ajusta el registro indice de direccion en modo predecremento */
static void adec_idx_adj(int size, int reg)
{
	if(size == BYTE)
	{
		switch(reg)
		{
			case -1:
				emit("mov #28,r0");    /* idx_reg = 7 << 2 */
				emit("cmp/eq r0,r2");
				emit("mov #1,r0");
				emit("subc r0,r4");
				break;

			case 7:
				emit("add #-2,r4");
				break;

			default: emit("dt r4");
		}
	}
	else
	{
		emit("add #-%d,r4", size);
	}
}

/* Precalculo de direccion efectiva */
/* La direccion se devuelve en r4 si la hay */
static void ea_step_precalc(int size, enum eamode mode, int reg)
{
	switch(mode)
	{
		case dreg:
		case areg: break;    /* No hay direccion, es el registro */

		case aind:
		case ainc:
		case adec:           /* Direccionamiento indirecto a registro */
			reg2sh(reg,"r4",ADDR_REG,LONG);
			if (mode == adec)
				adec_idx_adj(size,reg);
			break;

		case adsp:
			emit("mov.w @r6+,r4");    /* cargar desplazamiento */
			reg2sh(reg,"r1",ADDR_REG,LONG);
			emit("add r1,r4");       /* añadir direccion indirecta registro */
			break;

		case axdp:
			emit("mov.l @(decode_extw_addr-fetch_idx,r11),r4");
			emit("jsr @r4");
			if (reg == -1)      /* Si la carga de registro no es uni-instruccion, */
				emit("nop");    /* insertar nop en la ranura retardada (PRECAUCION) */

			reg2sh(reg,"r1",ADDR_REG,LONG);
			emit("add r1,r4");
			break;

		case absw:
			emit("mov.w @r6+,r4");          /* cargar direccion */
			break;

		case absl:
			load_dword("r6","r4","r0",DW_AINC);
			break;

		case pcdp:
			emit("mov r6,r0");              /* r0 = PC + base */
			emit("mov.w @r6+,r4");          /* cargar desplazamiento */
			emit("sub r5,r0");              /* r0 = PC */
			emit("add r0,r4");              /* agregar desplazamiento */
			break;

		case pcxd:
			emit("mov.l @(decode_extw_addr-fetch_idx,r11),r4");
			emit("mov r6,r1");              /* r1 = PC + base */
			emit("jsr @r4");
			emit("sub r5,r1");              /* sustraer base (guardar PC) */
			emit("add r1,r4");              /* agregar PC */
			break;

		case immd:		/* Operando inmediato */
				break;

		default:		/* Modo de direccionamiento no reconocido */
			emit("#error ea_step_precalc");
			break;
	}
}

/* Operacion de lectura */
static void ea_step_read(int size, enum eamode mode, int reg)
{
	switch(mode)
	{
		case dreg:	/* Carga directa registro de datos */
				if (use_idxr)
					reg2shpci(reg,"r3",DATA_REG,size);
				else
					reg2sh(reg,"r3",DATA_REG,size);
				break;

		case areg: /* Carga directa registro de direcciones */
				reg2shpci(reg,"r3",ADDR_REG,size);
				break;

		case aind: case ainc: case adec:
		case adsp: case axdp:
		case absw: case absl:
		case pcdp: case pcxd:
			mem_access(READ_DATA_TYPE, size);
			emit("nop");
			break;

		case immd:
			switch(size)
			{
				case BYTE:
					emit("mov.b @r6,r3");  /* hay que cargar byte para ext. signo */
					emit("add #2,r6");
					break;

				case WORD:
					emit("mov.w @r6+,r3");	/* cargar palabra e incr. */
					break;

				case LONG:
					load_dword("r6","r3","r0",DW_AINC);
					break;

				default:
					emit("#error ea_step_read");
					break;
			}
			break;

		default:
			emit("#error ea_step_read"); break;
	}
}

/* Operacion de lectura de palabra con EXTENSION DE SIGNO */
static void ea_step_read_signword(enum eamode mode, int reg)
{
	static int rm=0;

	switch(mode)
	{
		case dreg:   	/* Carga directa de registro de datos */
			if (use_idxr)
				reg2shpci(reg,"r3",DATA_REG,WORD);
			else
				reg2sh(reg,"r3",DATA_REG,WORD);
			break;

		case areg:    	/* Carga directa de registro de direccion */
			reg2shpci(reg,"r3",ADDR_REG,WORD);
			break;

		case aind: case ainc: case adec:
		case adsp: case axdp:
		case absw: case absl:
		case pcdp: case pcxd:
				mem_access(READ_DATA_TYPE, WORD);
				emit("nop");
				break;

		case immd:
			emit("mov.w @r6+,r3");
			break;

		default:
			emit("#error ea_step_read_signword");
			break;
	}
}

/* Operacion de escritura */
static void ea_step_write(int size, enum eamode mode, int reg)
{
	switch(mode)
	{
		case dreg: /* Directa a registro */
			if (use_idxr)
				sh2regpci("r3",reg,DATA_REG,size);
			else
				sh2reg("r3",reg,DATA_REG,size);
			break;

		case aind: case ainc: case adec:
		case adsp: case axdp:
		case absw: case absl:
			mem_access(WRITE_DATA_TYPE, size);
			emit("nop");
			break;

		default:
			emit("#error ea_step_write"); break;
	}
}

/* Postcalculo de direccion efectiva */
static void ea_step_postcalc(int size, enum eamode mode, int reg)
{
	switch(mode)
	{
		case dreg: case areg:
		case aind: case adsp: case axdp:
		case absw: case absl:
		case pcdp: case pcxd:
		case immd:			/* Operando inmediato */
			break;

		case ainc:
			if(size == BYTE)
			{
				if(reg == -1)
				{
					emit("mov #28,r0");       /* r0 = reg. idx = 7 << 2 */
					emit("cmp/eq r0,r2");
					emit("mov #1,r0");
					emit("addc r0,r4");
				}
				else if(reg == 7)
					emit("add #2,r4");
				else
					emit("add #1,r4");

			} else
				emit("add #%d,r4",size);

			/* continua, OJO no lleva break!! */
		case adec:
			/* Almacenar direccion ya predecrementada */
			sh2reg("r4",reg,ADDR_REG,LONG);
			break;

		default:
			emit("#error ea_step_postcalc");
			break;
	}
}

/*******************************************/
/* Funciones de direccionamiento completas */
/*******************************************/

static void ea_load(int size, enum eamode mode, int reg)
{
	ea_step_precalc(size, mode, reg);
	ea_step_read(size, mode, reg);
	ea_step_postcalc(size, mode, reg);
}

static void ea_load_signword(enum eamode mode, int reg)
{
	ea_step_precalc(WORD, mode, reg);
	ea_step_read_signword(mode, reg);
	ea_step_postcalc(WORD, mode, reg);
}

static void ea_store(int size, enum eamode mode, int reg)
{
	ea_step_precalc(size, mode, reg);
	ea_step_write(size, mode, reg);
	ea_step_postcalc(size, mode, reg);
}

static void ea_rmw_load(int size, enum eamode mode, int reg)
{
	ea_step_precalc(size, mode, reg);
	ea_step_read(size, mode, reg);
}

static void ea_rmw_store(int size, enum eamode mode, int reg)
{
	ea_step_write(size, mode, reg);
	ea_step_postcalc(size, mode, reg);
}

static void ea_control(enum eamode mode, int reg)
{
	ea_step_precalc(0, mode, reg);
}

static void main_ea_load(void)
{
	ea_load(main_size, main_ea, -1);
}

static void main_ea_load_signed(void)
{
	if(main_size < LONG)
		ea_load_signword(main_ea, -1);
	else
		ea_load(main_size, main_ea, -1);
}

static void main_ea_store(void)
{
	ea_store(main_size, main_ea, -1);
}

static void main_ea_rmw_load(void)
{
	ea_rmw_load(main_size, main_ea, -1);
}

static void main_ea_rmw_store(void)
{
	ea_rmw_store(main_size, main_ea, -1);
}

static void main_ea_control(void)
{
	ea_control(main_ea, -1);
}

/* Calculo de ciclos para el modo de direccionamiento fuente (principal) */
static int main_ea_cycles(void)
{
	int l;

	l = (main_size == LONG)?4:0;

	switch(main_ea)
	{
		case aind: return(l + 4);
		case ainc: return(l + 4);
		case adec: return(l + 6);
		case adsp: return(l + 8);
		case axdp: return(l + 10);
		case absw: return(l + 8);
		case absl: return(l + 12);
		case pcdp: return(l + 8);
		case pcxd: return(l + 10);
		case immd: return(l + 4);
	}
	return 0;
}

/* Generacion de codigo de gestion (API, manejadores, excepciones) */
/* Codigo anterior a las rutinas de manejo de instrucciones */
static void gen_man_code(void)
{
	gen_header();
	gen_vars();
	gen_api();
	gen_basefunction();
	gen_rbw_handlers(BYTE);
	gen_rbw_handlers(WORD);
	gen_rl_handler();
	gen_wbw_handlers(BYTE);
	gen_wbw_handlers(WORD);
	gen_wl_handler();
	gen_decode_extw();
	if (emulate_group_0 || check_branches)
		gen_g0_exception();

	gen_g12_exception();
	gen_privilege_violation();
}


/****************************************************************************/
/* RUTINAS DE MANEJO DE INSTRUCCIONES                                       */
/****************************************************************************/

/* MOVE */
static void i_move(void)
{
	int cycles;

	use_idxr = 1;     /* Uso de registro indice en procesos lectura-escritura */

	sel_mask_idxr();
	main_ea_load();
	ea_store(main_size, main_dest_ea, main_reg);
	setf_vc0();

	cycles = (main_size == LONG)?move_l_cycles[main_ea][main_dest_ea]:\
							move_bw_cycles[main_ea][main_dest_ea];

	timing(cycles);
}

/* QUICK MOVE */
static void i_moveq(void)
{
	emit("shlr2 r0");
	emit("exts.b r0,r3");
	sh2reg("r3",main_reg,DATA_REG,LONG);   /* llevarlo a reg. de datos */
	setf_vc0();
	timing(4);
}

/* Operacion a registro de direccion              */
/* s (operacion a realizar)                       */
/* 'm' - move | 'a' - add | 's' - sub | 'c' - cmp */
static void op2areg(char op)
{
	char opl=tolower(op);

	sel_mask_idxr();          /* registro a usar */

	/* Salvar bandera Z (r3) si la instruccion no la modifica */
	if (opl != 'c')
		save_reg("r3");

	main_ea_load_signed();    /* cargar dato */

	/* operacion a registro de direcciones */
	switch(opl)
	{
		/* El MOVA se realiza con extension de signo (size = WORD, LONG) */
		case 'm': sh2reg("r3",main_reg,ADDR_REG,LONG); break;
		/* ADDA y SUBA se realiza extendiendo signo y aplicando sobre todo el areg (size = WORD, LONG) */
		case 'a':
		case 's': reg2sh(main_reg,"r1",ADDR_REG,LONG);
					emit("%s r3,r1",(opl=='a')?"add":"sub");
					sh2reg("r1",main_reg,ADDR_REG,LONG);
					break;

		case 'c': reg2sh(main_reg,"r1",ADDR_REG,LONG);
					emit("mov r1,r0");     /* salvaguardar r1 (dst) */
					emit("subv r3,r1");    /* resta para comparar (chequeo V) */
					emit("movt r8");       /* r8 = V */
					emit("clrt");
					emit("subc r3,r0");    /* calculo de C */
					emit("addc r8,r8");    /* r8 = VC */
					set_nz_from("r0");
					break;
	}

	if (opl != 'c')
		restore_reg("r3");    /* restaurar Z */
}

/* MOVE ADDRESS */
static void i_movea(void)
{
	op2areg('m');
	timing(4+main_ea_cycles());
}

/* ADDA o SUBA */
static void addsuba(char op)
{
	int base_cycles = (main_size == LONG)?6:8;

	op2areg(op);

	if (main_size == LONG)
	{
		/* Incrementar en 2 si la ea es directa a registro o imm. */
		switch(main_ea)
		{
			case areg:
			case dreg:
			case immd:
				base_cycles+=2;	break;
		}
	}

	timing(base_cycles+main_ea_cycles());
}

/* ADD ADDRESS */
static void i_adda(void) {addsuba('a');}

/* SUB ADDRESS */
static void i_suba(void) {addsuba('s');}

/* COMPARE ADDRESS */
static void i_cmpa(void)
{
	op2areg('c');
	timing(6+main_ea_cycles());
}

/* CLEAR */
static void i_clr(void)
{
	int cycles;

	sel_mask_idxr();
	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (load) */
		main_ea_rmw_load();

	emit("mov #0,r3");    /* r3 = 0, dato a cargar en memoria */

	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (store) */
		main_ea_rmw_store();
	else
		main_ea_store();

	emit("mov r3,r8");       /* bandera Z = 1, resto = 0 (excepto X) */

	/* Calculo de ciclos de reloj */
	if(main_ea == dreg)
		cycles = (main_size == LONG)?6:4;
	else
		cycles = (main_size == LONG)?12:8 + main_ea_cycles();

	timing(cycles);
}

/* TEST */
static void i_tst(void)
{
	sel_mask_idxr();     /* uso de registro */
	main_ea_load();      /* carga de memoria */
	setf_vc0();
	timing(4+main_ea_cycles());
}

/* MOVE TO STATUS REGISTER */
static void i_move_to_sr(void)
{
	main_size=WORD;

	sel_mask_idxr();
	priv_check();        /* La operacion requiere modo supervisor */
	main_ea_load();
	setup_sr();
	timing_cp(12+main_ea_cycles());
}

/* MOVE TO CCR */
static void i_move_to_ccr(void)
{
	main_size=WORD;

	sel_mask_idxr();
	main_ea_load();
	load_ccr_from("r3");
	timing(12+main_ea_cycles());
}

/* MOVE FROM STATUS REGISTER */
static void i_move_from_sr(void)
{
	int cycles;

	main_size=WORD;
	sel_mask_idxr();

	save_reg("r3");

	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (load) */
		main_ea_rmw_load();

	load_sr();

	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (store) */
		main_ea_rmw_store();
	else
		main_ea_store();

	restore_reg("r3");

	cycles = (main_ea == dreg)?6:8+main_ea_cycles();
	timing(cycles);
}

/* Operacion a CCR */
static void op2ccr(char* op)
{
	emit("mov.w @r6+,r2");   /* cargo word, se aplica a byte */
	load_from_ccr();
	emit("%s r2,r3",op);     /* operacion */
	load_ccr_from("r3");
	timing(20);
}

/* Operacion contra el STATUS REGISTER */
static void op2sr(char* op)
{
	priv_check();            /* La operacion requiere privilegios. acceso al SR */
	emit("mov.w @r6+,r2");
	load_sr();
	emit("%s r2,r3",op);     /* Operacion -> r3 */
	setup_sr();
	timing_cp(20);
}

/* Operaciones inmediatas OR, AND, EOR al CCR y SR */
static void i_ori_ccr(void) {op2ccr("or");}
static void i_andi_ccr(void) {op2ccr("and");}
static void i_eori_ccr(void) {op2ccr("xor");}
static void i_ori_sr(void) {op2sr("or");}
static void i_andi_sr(void) {op2sr("and");}
static void i_eori_sr(void) {op2sr("xor");}

/* Realiza la operacion aritmetica (add, sub o cmp)   */
/* entre el operando destino y el origen especificado */
/* flag_x - afecta a la bandera X                     */
/* Nunca afecta a las banderas N y Z                  */
static void arith_op(char *op, char *src_reg, char *dest_reg, char *dirt_reg, int size, int flag_x)
{
	char meta_op[5];

	/* Ajustar operacion cmp a sub */
	if (!strcmp(op,"cmp"))
		strcpy(meta_op,"sub");
	else
		strcpy(meta_op,op);

	/* Desplazamiento a tamano LONG para operar */
	if (size == BYTE)
	{
		emit("mov #24,%s",dirt_reg);
		emit("shld %s,%s",dirt_reg,src_reg);
		emit("shld %s,%s",dirt_reg,dest_reg);
	}
	else if (size == WORD)
	{
		emit("shll16 %s",src_reg);
		emit("shll16 %s",dest_reg);
	}

	/* Operacion y calculo de banderas */
	emit("mov %s,%s",dest_reg, dirt_reg);           /* guardar operando destino */
	emit("%sv %s,%s",meta_op, src_reg, dirt_reg);
	emit("movt r8");                 /* r8 = V */
	emit("clrt");
	emit("%sc %s,%s",meta_op, src_reg, dest_reg);   /* dest_reg = res, T = C */
	if (flag_x) emit("movt r9");     /* r9 = X = C */
	emit("addc r8,r8");              /* r8 = VC */

	/* Ajustar resultado */
	if (size != LONG)
	{
		emit("mov #-%d,%s",32-main_size*8,dirt_reg);
		emit("shad %s,%s",dirt_reg,dest_reg);
	}
}

/* Siempre afecta a la bandera X (excepto para #,An que no afecta a ninguna) */
static void op_quick(char* op)
{
	int cycles;

	sel_mask_idxr();

	if (main_ea == areg)
		emit("mov r3,r4");    /* guardar bandera Z */

	if ((main_ea == dreg) || (main_ea == areg))
	{
		/* Realizar operacion directa a registro de datos */
		reg2shpci(-1,"r3",(main_ea == dreg)?DATA_REG:ADDR_REG,(main_ea == dreg)?main_size:LONG);
	}
	else
		main_ea_rmw_load();		/* Carga de operando */

	/* operacion y calculo de banderas */
	if (main_ea == areg)
	{
		emit("add #%c%d,r3",(op[0]=='a')?' ':'-',quickvalue[main_qv]);
	}
	else
	{
		/* Desplazamiento a tamano LONG para operar */
		switch(main_size)
		{
			case BYTE:
				emit("mov #24,r1");
				emit("mov #%d,r0",quickvalue[main_qv]);
				emit("shld r1,r3");
				emit("shld r1,r0");
				break;

			case WORD:
				emit("shll16 r3");
				emit("mov #%d,r0",quickvalue[main_qv]);
				emit("shll16 r0");
				break;

			case LONG:
				emit("mov #%d,r0",quickvalue[main_qv]);
		}

		/* Operacion y calculo de banderas */
		emit("mov r3,r1");
		emit("%sv r0,r1",op);
		emit("movt r8");       /* r8 = V */
		emit("clrt");
		emit("%sc r0,r3",op);  /* T = C */
		emit("movt r9");       /* X = C */
		emit("addc r8,r8");    /* T = VC */

		/* Ajustar resultado */
		readj_bwdata("r3",main_size);
	}

	/* Volcar resultado */
	if ((main_ea == dreg) || (main_ea == areg))
	{
		sh2regpci("r3",-1,(main_ea == dreg)?DATA_REG:ADDR_REG,(main_ea == dreg)?main_size:LONG);
		if((main_size==WORD) && (op[0]=='s') && (main_ea == areg))
			cycles=4+4;	/* penalización en subq.w #,An */
		else
			cycles=4;
	}
	else
	{
		main_ea_rmw_store();
		cycles=8+main_ea_cycles();
	}

	if(main_size == LONG) cycles+=4;

	/* Calculo de banderas NZ si necesario */
	if (main_ea != areg)
		set_nz();
	else
		emit("mov r4,r3");    /* restaurar bandera Z */

	timing(cycles);
}

/* ADD QUICK */
static void i_addq(void) {op_quick("add");}

/* SUB QUICK */
static void i_subq(void) {op_quick("sub");}

/* Operacion a registro de datos */
/* flagx   -> afecta a bandera X */
/* logical -> instruccion logica */
static void op2dreg(char* op, int flag_x, int logical)
{
	int cycles;

	use_idxr = 1;

	sel_mask_idxr();    /* Registro a usar */
	main_ea_load();     /* Carga de memoria */

	/* Cargar operando destino */
	reg2sh(main_reg,"r1",DATA_REG,main_size);

	if (logical)
	{
		emit("%s r1,r3",op);
		/* Volcar resultado */
		sh2reg("r3",main_reg,DATA_REG,main_size);
	}
	else
	{
		arith_op(op,"r3","r1","r0",main_size,flag_x);
		/* Volcar operando destino si no es comparacion */
		if (op[0] != 'c')
			sh2reg("r1",main_reg,DATA_REG,main_size);
	}

	/* Calculo de banderas */
	if (logical)
	{
		exts("r3","r3",main_size);
		setf_vc0();
	}
	else
		set_nz_from("r1");

	cycles=4+main_ea_cycles();
	if(main_size == LONG)
	{
		cycles+=2;
		if(op[0]!='c')    /* Penalizacion de acceso */
		{
			switch(main_ea)
			{
				case areg:
				case dreg:
				case immd:
				    cycles+=2; break;
			}
		}
	}
	timing(cycles);
}

/* Operaciones directa a registro de datos: CMP, ADD, SUB, AND y OR */
static void i_cmp_dn(void) {op2dreg("cmp",0,0);}
static void i_add_dn(void) {op2dreg("add",1,0);}
static void i_sub_dn(void) {op2dreg("sub",1,0);}
static void i_and_dn(void) {op2dreg("and",0,1);}
static void i_or_dn (void) {op2dreg("or",0,1);}

/* Operacion a direccion efectiva */
static void op2ea(char* op, int logical)
{
	int cycles;

	sel_mask_idxr();
	main_ea_rmw_load();

	/* cargar operando destino */
	reg2sh(main_reg,"r1",DATA_REG,main_size);

	if (logical)
		emit("%s r1,r3",op);  /* r3 = resultado */
	else
		arith_op(op,"r1","r3","r0",main_size,1);

	main_ea_rmw_store();

	/* Calculo de banderas */
	if (logical)
		setf_vc0();
	else
		set_nz();

	cycles=8+main_ea_cycles();
	if(main_size == LONG) cycles+=4;
	if((op[0]=='x') && (main_ea == dreg))	 /* EOR Dn,Dn requiere 4 ciclos menos de lo esperado */
		cycles-=4;

	timing(cycles);
}

/* Operaciones a direccion efectiva: EOR, ADD, SUB, AND y OR */
static void i_eor_ea(void) {op2ea("xor",1);}
static void i_add_ea(void) {op2ea("add",0);}
static void i_sub_ea(void) {op2ea("sub",0);}
static void i_and_ea(void) {op2ea("and",1);}
static void i_or_ea (void) {op2ea("or" ,1);}

/*
** c1: Ciclos totales para #,Dn (byte/word)
** c2: Ciclos totales para #,Dn (long)
** c3: Ciclos basicos para #,M  (byte/word)
** c4: Ciclos basicos para #,M  (long)
*/
/* wback = devolver resultado a memoria */
static void imm2ea(char* op,int wback,int flag_x,int logical, int c1,int c2,int c3,int c4)
{
	int cycles;

	sel_mask_idxr();

	/* carga de operando inmediato */
	switch(main_size)
	{
		case BYTE:
			emit("mov.w @r6+,r1");   /* cargar palabra inmediata */
			exts("r1","r1",main_size);
			break;

		case WORD:
			emit("mov.w @r6+,r1");   /* cargar palabra inmediata */
			break;

		case LONG:
			load_dword("r6","r1","r0",DW_AINC);
	}

	/* carga de direccion efectiva */
	if(main_ea == dreg)
		reg2shpci(-1,"r3",DATA_REG,main_size);
	else
	{
		emit("mov r1,r8");           /* r1 se usa en la carga de memoria */

		/* dependiendo del modo, carga con modificacion o solo carga */
		if(wback)
			main_ea_rmw_load();
		else
			main_ea_load();

		emit("mov r8,r1");           /* recuperar r1 para operacion */
	}

	/* realizar operacion */
	if (logical)
		emit("%s r1,r3",op);
	else
		arith_op(op,"r1","r3","r0",main_size,flag_x);

	/* cargar resultado y ajustar ciclos */
	if(main_ea == dreg)
	{
		if (op[0] != 'c')         /* si es comparacion, no cargar */
			sh2regpci("r3",-1,DATA_REG,main_size);
		cycles = (main_size < LONG)?c1:c2;
	}
	else
	{
		if(wback)
			main_ea_rmw_store();

		cycles = (main_size < LONG)?c3:c4;
		cycles+=main_ea_cycles();
	}

	/* Calculo de banderas */
	if (logical)
		setf_vc0();
	else
		set_nz();

	timing(cycles);
}

/* Instrucciones inmediatas */
static void i_addi(void) {imm2ea("add",1,1,0,8,16,12,20);}
static void i_subi(void) {imm2ea("sub",1,1,0,8,16,12,20);}
static void i_cmpi(void) {imm2ea("cmp",0,0,0,8,14,8,12);}
static void i_andi(void) {imm2ea("and",1,0,1,8,14,12,20);}
static void i_ori (void) {imm2ea("or" ,1,0,1,8,16,12,20);}
static void i_eori(void) {imm2ea("xor",1,0,1,8,16,12,20);}


/* Shift-Rotate operation */
/* op = Operation / needxf = requiere bandera X / flag_x = afecta bandera X */
/* rotate = indica si la operacion es de rotacion o de desplazamiento */
static void srop_reg(char* op,int needxf,int flag_x,int asl,int rotate)
{
	int ln = lntag++;
	int cycles, i;
	char cs[5];
	int parche;   /* Esto hay q quitarlo */

	mask_idxr();
	cycles = (main_size == LONG)?8:6;

	/* Desplazamientos a la derecha no afectan a V */
	parche = asl;
	if(direction[main_dr]=='r') asl=0;

	if(main_ir == 1)    /* Contador de bit en registro */
	{
		reg2sh(main_reg,"r0",DATA_REG,LONG);
		emit("and #0x3F,r0");   	/* Bits a desplazar, modulo 64 */
		emit("tst r0,r0");
		emit("bf ln%d",ln);

		/* No hay que realizar desplazamiento o rotacion */
		ea_load(main_size,dreg,-1);

		if (needxf)  /* ROXL/ROXR: bandera C = bandera X */
		{
			emit("mov r9,r8");   /* r8 = 0C */
			set_nz();
		}
		else
			setf_vc0();

		timing(cycles);

		/* El numero de bits a desplazar/rotar != 0 */
		emit("ln%d:",ln);

		/* ciclos de reloj = bits a desplazar * 2 */
		emit("sub r0,r7");
		emit("sub r0,r7");
		sprintf(cs,"r0");      /* El nº de bits esta en r0 */
	}
	else                   /* contador inmediato */
	{
		sprintf(cs,"%d",quickvalue[main_reg]);	/* cs = contador bits */
		cycles+=(quickvalue[main_reg]<<1);
	}

	ln = lntag++;

	reg2shpci(-1,"r3",DATA_REG,main_size);  /* cargar operando */

	/* Ajuste para el tamano de datos */
	if ((!rotate) && (direction[main_dr]=='l')) /* desp. logico/aritmetico */
		adj_bwdata("r3",main_size);
	else if ((!rotate) && (!parche))
		extu("r3","r3",main_size);

	if (asl)    /* desplazamiento arith a la izq */
	{
		switch(cs[0])
		{
			case 'r': /* bits a desplazar en registro r0 */
				emit("mov r3,r1");   /* duplicar operando para calcular C */
				emit("mov #0,r8");   /* banderas = 0 (para calcular V) */

				emit("ln%d:",ln);
				emit("addv r3,r3");
				emit("movt r9");
				emit("or r9,r8");    /* r8 = V */
				emit("%sl r1",op);
				emit("movt r9");     /* r9 = C = X */
				emit("dt r0");
				emit("bf ln%d",ln);
				emit("cmp/pl r9");   /* C -> T */

				emit("rotcl r8");    /* r8 = VC */
				break;

			case '1':  /* numero de bits = 1 */
				emit("mov r3,r1");   /* duplicar operando para calcular C */
				emit("addv r3,r3");
				emit("movt r8");     /* r8 = V */
				emit("%sl r1",op);	 /* desplazar un solo bit */
				emit("movt r9");     /* fijar bandera X */
				emit("rotcl r8");    /* r8 = VC */
				break;

			default: /* numero de bits > 1 */
				emit("mov #0,r8");   /* banderas = 0 (para calcular V) */

				/* se realiza for para obtener valor de bandera O */
				/* con instruccion SHL solo se calcula la bandera O para SHL x,1 !!!! */
				for(i=1;i<=quickvalue[main_reg];i++)
				{
					if (i == quickvalue[main_reg])
						emit("mov r3,r0");
					emit("addv r3,r3");
					emit("movt r9");
					emit("or r9,r8");
				}
				emit("shll r0",op);  /* C -> T */
				if(flag_x)
					emit("movt r9"); /* X = C */
				emit("rotcl r8");  /* r8 = VC */
				break;
		}
	}
	else            /* rotacion o desplazamiento logico */
	{
		if(needxf)
			emit("cmp/pl r9");  /* X -> T */
		else
		{
			if (rotate)
				emit("clrt");   /* T = 0 */
		}

		if(rotate)    /* rotacion de bits */
		{
			if (cs[0] != 'r')    /* el numero de bits es inmediato */
				emit("mov #%s,r0",cs);  /* cargar contador (imm) en r0 */

			/* Extender para evitar bits sucios en el OR */
			if (direction[main_dr]=='r')
				extu("r3","r3",main_size);

			emit("ln%d:",ln);
			emit("%s%c r3",op,direction[main_dr]);
			emit("movt r8");     /* r8 = C */
			emit("dt r0");

			if (main_size != LONG)
			{
				if (direction[main_dr]=='l')
					exts("r3","r3",main_size);
				else
				{
					emit("mov r3,r1");
					switch(main_size)
					{
						case BYTE: emit("shlr16 r1"); emit("shlr8 r1"); break;
						case WORD: emit("shlr16 r1"); break;
					}
					emit("or r1,r3");
				}
			}

			if (needxf)
			{
				emit("bf/s ln%d",ln);
				emit("cmp/pl r8");
			}
			else
				emit("bf ln%d",ln);

			/* actualizar X */
			if(flag_x) emit("mov r8,r9");
		}
		else    /* desplazamiento a la izq/der */
		{
			if (cs[0] != 'r')
			{
				if (quickvalue[main_reg] == 1)
					emit("mov #0,r0");
				else
					emit("mov #%s%d,r0",((direction[main_dr]=='r')?"-":""),quickvalue[main_reg]-1);

                emit("%sd r0,r3",op);
    			emit("%s%c r3",op,direction[main_dr]);
    			emit("movt r8");    /* r8 = C */
			}
			else
			{
        		/* En los desplazamientos aritmetico/logicos    */
        		/* comprobar si el valor no es > 32, fijar a 32 */
        		/* pues el SH no es capaz de desplazar mas bits */
        		/* y enmascara a 32, perdiendo bits             */

    			emit("mov #32,r1");
    			emit("cmp/hi r1,r0");
    			emit("bf nobitover%d",ln);

                emit("add #-31,r0");
                emit("mov #%s31,r1",(direction[main_dr]=='r')?"-":"");
                emit("%sd r1,r3",op);

                emit("nobitover%d:",ln);
				emit("dt r0");       /* ultimo bit para calculo de C */
				if (direction[main_dr] == 'r')
					emit("neg r0,r0");

                emit("%sd r0,r3",op);
    			emit("%s%c r3",op,direction[main_dr]);
    			emit("movt r8");    /* r8 = C */
			}

			/* actualizar X */
			if(flag_x) emit("mov r8,r9");
		}
	}

	if ((!rotate) && (direction[main_dr]=='l')) /* desp. logico/aritmetico */
		readj_bwdata("r3",main_size);
	else
		exts("r3","r3",main_size);

	/* Carga de resultado y banderas NZ */
	sh2regpci("r3",-1,DATA_REG,main_size);
	set_nz();

	timing(cycles);
}

/* Logical, Asimetric Shifts (Register Operand) */
static void i_lsx_reg(void) {srop_reg("shl",0,1,0,0);}
static void i_asx_reg(void) {srop_reg("sha",0,1,1,0);}

/* Rotates (Memory Operand) */
static void i_rox_reg(void) {srop_reg("rot",0,0,0,1);}
static void i_rxx_reg(void) {srop_reg("rotc",1,1,0,1);}

/* Shift-Rotate operation                                                    */
/* op = Operation / needxf = requiere bandera X / affectx = afecta bandera X */
/* vf = calcular bandera V                                                   */
/* rotate = indica si la operacion es de rotacion o de desplazamiento        */
static void srop_mem(char* op,int needxf,int flag_x,int flag_v,int rotate)
{
	if(direction[main_dr]=='r') flag_v=0;	/* Desplazamientos a la derecha no afectan a V */
	main_size=WORD;                         /* Operación restringida a tamaño palabra */

	sel_mask_idxr();
	main_ea_rmw_load();

	if(needxf)
	{
		emit("shlr r9");			/* bandera X -> T */
	}

	if (direction[main_dr] == 'r')
		extu("r3","r3",WORD);

	emit("%s%c r3",op,direction[main_dr]);

	if (direction[main_dr] == 'r')
	{
		emit("mov r3,r0");
		emit("shlr16 r0");
		emit("or r0,r3");
	}

	emit("movt r8");      /* r8 = C */
	if(flag_x)
		emit("movt r9");  /* X = C */

	main_ea_rmw_store();

	/* Extender resultado para calculo de N */
	exts("r3","r3",WORD);

	/* calcular bandera V si necesario */
	if(flag_v)
	{
		emit("mov r3,r0");
		emit("shll r0");
		emit("movt r0");
		emit("xor r8,r0");     /* r0 = V */
		emit("shll r0");
		emit("or r0,r8");      /* r8 = VC */
	}

	set_nz();
	timing(8+main_ea_cycles());
}

/* Logical, Asimetric Shifts (Memory Operand) */
static void i_lsx_mem(void) {srop_mem("shl",0,1,0,0);}
static void i_asx_mem(void) {srop_mem("sha",0,1,1,0);}

/* Rotates (Memory Operand) */
static void i_rox_mem(void) {srop_mem("rot",0,0,0,1);}
static void i_rxx_mem(void) {srop_mem("rotc",1,1,0,1);}

/* BRANCH ALWAYS (BYTE OPERAND) */
static void i_bra_b(void)
{
	int ln = lntag++;

	emit("shlr2 r0");
	emit("exts.b r0,r0");

	if (check_branches)
	{
		/* Testear si el desplazamiento es impar */
		/* generaria error de direccion */
		/* Este codigo corrige el error de direccion que se produce en el */
		/* juego "Shadow of the Beast" del Commodore Amiga 500 */
		emit("tst #1,r0");
		emit("bt access_ok%d",ln);

		/* Acceso a memoria impar: ERROR DE DIRECCION */
		gen_g0_error_exception(ADDRESS_ERROR,PROGRAM_TYPE);

		emit("access_ok%d:",ln);
	}

	emit("add r0,r6");    /* anadir desplazamiento al PC */
	timing(10);
}

/* BRANCH ALWAYS (WORD OPERAND) */
static void i_bra_w(void)
{
	emit("mov.w @r6,r0"); /* Cargar operando (desp. PC) con extension de signo */
	emit("add r0,r6");    /* Añadir al PC */    
	timing(10);
}

/* BRANCH TO SUBROUTINE (BYTE OPERAND) */
static void i_bsr_b(void)
{
	emit("shlr2 r0");
	emit("mov r3,r2");      /* guardar bandera Z */
	emit("exts.b r0,r1");

	emit("mov r6,r3");      /* cargar PC + base en r3 */
	emit("add r1,r6");      /* r6 = nuevo PC */
	emit("sub r5,r3");      /* r3 = PC sin base */
	ea_store(LONG,adec,7);  /* Almacenar en la pila PC sin base */

	emit("mov r2,r3");      /* restaurar bandera Z */
	timing(18);
}

/* BRANCH TO SUBROUTINE (WORD OPERAND) */
static void i_bsr_w(void)
{
	emit("mov.w @r6,r1");   /* desplazamiento para el PC extendido a r1 */
	emit("mov r3,r2");      /* guardar bandera Z */

	emit("mov r6,r3");      /* cargar PC+base en r3 */
	emit("add #2,r3");      /* incrementar ptr. a opcodes en r3 */
	emit("add r1,r6");      /* r6 = PC desplazado */
	emit("sub r5,r3");      /* PC sin base */
	ea_store(LONG,adec,7);  /* Almacenar en la pila PC sin base (r3) */

	emit("mov r2,r3");      /* restaurar bandera Z */
	timing(18);
}

/* BRANCH CONDITIONALLY (BYTE OPERAND) */
static void i_bcc_b(void)
{
	int ln=lntag++;

    emit("mov r0,r2");             /* guardar desplazamiento */
	getcondition(main_cc);
	emit("b%c bcc_b%d",cctag,ln);
	timing(8);

	align(5);
	emit("bcc_b%d:",ln);
	emit("shlr2 r2");
	emit("exts.b r2,r0");

	if (check_branches)
	{
		/* Testear si el desplazamiento es impar */
		/* generaria error de direccion */
		/* Este codigo corrige el error de direccion que se produce en el */
		/* juego "Shadow of the Beast" del Commodore Amiga 500 */
		emit("tst #1,r0");
		emit("bt access_ok%d",ln);

		/* Acceso a memoria impar: ERROR DE DIRECCION */
		gen_g0_error_exception(ADDRESS_ERROR,PROGRAM_TYPE);

		emit("access_ok%d:",ln);
	}

	emit("add r0,r6");    /* anadir desplazamiento al PC */
	timing(10);
}

/* BRANCH CONDITIONALLY (WORD OPERAND) */
static void i_bcc_w(void)
{
	int ln=lntag++;

	getcondition(main_cc);
	emit("b%c bcc_w%d",cctag, ln);
	inc_ptr_opcodes();/* saltar desplazamiento */
	timing(12);

	align(5);
	emit("bcc_w%d:",ln);
	i_bra_w();
}

/* TEST FALSE, DECREMENT AND BRANCH */
static void i_dbra(void)
{
	int ln=lntag++;

	mask_idxr();
	emit("mov r2,r0");
	emit("mov.w @(r0,r13),r1");   /* cargar registro */
	emit("tst r1,r1");            /* testear falso */
	emit("add #-1,r1");           /* decrementar registro */
	emit("bf/s bcc_w%d",ln);      /* realizar salto? */
	emit("mov.w r1,@(r0,r13)");   /* cargar resultado */
	emit("add #2,r6");            /* saltar desplazamiento */
	timing(14);

	align(5);
	emit("bcc_w%d:",ln);
	i_bra_w();
}

/* TEST TRUE, DECREMENT AND BRANCH */
static void i_dbt(void)
{
	emit("add #2,r6"); /* saltar desplazamiento */
	timing(12);
}

/* TEST CONDITION, DECREMENT AND BRANCH */
static void i_dbcc(voqid)
{
	int ln=lntag++;

    mask_idxr();                     /* enmascarar por si el desp. es necesario */
	getcondition(main_cc);
	emit("b%c dbcc%d",rctag, ln);
	inc_ptr_opcodes();/* saltar desplazamiento, no se realiza salto */
	timing(12);

	align(5);
	emit("dbcc%d:",ln);
	emit("mov r2,r0");
	emit("mov.w @(r0,r13),r1");   /* cargar registro */
	emit("tst r1,r1");            /* testear falso */
	emit("add #-1,r1");           /* decrementar registro */
	emit("bf/s bcc_w%d",ln);      /* realizar salto? */
	emit("mov.w r1,@(r0,r13)");   /* cargar resultado */
	emit("add #2,r6");            /* saltar desplazamiento */
	timing(14);

	align(5);
	emit("bcc_w%d:",ln);
	i_bra_w();
}

/* SET ACORDING TO CONDITION */
static void i_scc(void)
{
	int cycles;

	main_size = BYTE;				/* Operacion de byte */
	cycles = (main_ea == dreg)?4:8;
	sel_mask_idxr();

	save_reg("r3");

	if ((main_ea != dreg) && dummyreads)    /* Lectura tonta */
		main_ea_rmw_load();

	if(main_cc > 1)    /* <=1 condicion true (todos 1s) o false (todos 0s) */
	{
		getcondition(main_cc);	/* obtener condicion de la instruccion */
		emit("movt r3");        /* fijar valor de r3 a condicion */
		if (cctag == 'f')
		{
			emit("tst r3,r3");  /* testear valor para invertir bit */
			emit("movt r3");
		}
		if (main_ea == dreg)
		{
		    /* decrementar ciclos si procede (*2) */
			emit("sub r3,r7");
			emit("sub r3,r7");
		}
		emit("neg r3,r3");      /* todos 1s o 0s */
	}
	else
	{
		emit("mov #%d,r3",(main_cc^1)*0xFF);
		if ((main_ea == dreg) && (main_cc == T_CC))
			cycles+=2;    /* decrementar ciclos si procede */
	}

	if ((main_ea != dreg) && dummyreads)    /* almacenar resultado */
		main_ea_rmw_store();
	else
		main_ea_store();

	restore_reg("r3");

	cycles+=main_ea_cycles();
	timing(cycles);
}

/* Operaciones sobre bits */
/* La operacion se aplica sobre r3 */
/* r0 parametro num de bit */
/* static_cycles son ciclos a contar */
static void bitop(char mode, int static_cycles)
{
	int cycles;

	sel_mask_idxr();

	if(main_ea == dreg)    /* Dato a testear especificado en registro de datos */
	{
		main_size=LONG;

		if (mode == 'i')
			emit("mov.w @r6+,r0");		/* Dato inmediato en opcodes */
		else
			reg2sh(main_reg,"r0",DATA_REG,BYTE);

		emit("mov #1,r4");    /* Bit 0 On */
		emit("and #31,r0");
		reg2shpci(-1,"r1",DATA_REG,main_size); /* cargar registro */
		emit("shld r0,r4");   /* Bit On posicionado */
		emit("tst r4,r1");    /* testeo ( Z -> T ) */
		emit("movt r3");      /* fijar bandera Z */
		emit("dt r3");        /* r3 = valor de Z */

		if(main_cc)           /* BTST: Test a Bit */
		{
			switch(main_cc)
			{
			    case F_CC:
			    	emit("xor r4,r1");
					break;		/* BCHG: Test a Bit and Change */

			    case HI_CC:
			    	emit("not r4,r4");
					emit("and r4,r1");
					break;		/* BCLR: Test a Bit and Clear */

			    case LS_CC:
			    	emit("or r4,r1");
					break;		/* BSET: Test a Bit and Set */
			}

			sh2regpci("r1",-1,DATA_REG,main_size); /* cargar resultado */
		}
		cycles=6+static_cycles;
		if(main_cc) cycles+=2;          /* si es BCHG, BCLR o BSET */
		if(main_cc == HI_CC) cycles+=2; /* si es BCLR */
	}
	else                            /* Dato a testear especificado en dir. efectiva */
	{
		main_size = BYTE;               /* siempre operacion de byte */

		if (mode == 'i')
		{
			emit("mov.w @r6+,r0");		/* Dato inmediato en opcodes */
			emit("and #%d,r0",(main_ea == dreg)?31:7);
		}

		if (mode == 'i')
			save_reg("r0");             /* salvaguardar r0 */

		if (main_cc)
			main_ea_rmw_load();         /* cargar en r3 el operando */
		else
			main_ea_load();             /* cargar direccion efectiva en r3 */

		if (mode == 'i')
			restore_reg("r0");

		if (mode =='r')
		{
			reg2sh(main_reg,"r0",DATA_REG,BYTE);
			emit("mov #1,r1");    /* Bit 0 On */
			emit("and #%d,r0",(main_ea == dreg)?31:7);
		}
		else
			emit("mov #1,r1");    /* Bit 0 On */

		emit("shld r0,r1");       /* Bit On posicionado en r1 */
		emit("tst r1,r3");        /* testeo */
		emit("rotcl r8");         /* fijar bandera Z   */

		if(main_cc)               /* BTST: Test a Bit */
		{
			switch(main_cc)
			{
			    case F_CC: emit("xor r1,r3"); break;    /* BCHG: Test a Bit and Change */
			    case HI_CC: emit("not r1,r1");
			    			emit("and r1,r3"); break;   /* BCLR: Test a Bit and Clear */
			    case LS_CC: emit("or r1,r3"); break;    /* BSET: Test a Bit and Set */
			}
			main_ea_rmw_store();                        /* almacenar resultado */
		}

		/* Obtener Z -> r3 */
		emit("shlr r8");
		emit("movt r3");
		emit("dt r3");

		cycles=4+static_cycles+main_ea_cycles();
		if(main_cc) cycles+=4;                          /* si no es BTST */
	}

	timing(cycles);
}

/* Operacion de bit a operando inmediato */
static void i_bitop_imm(void)
{
	bitop('i',4);
}

/* Operacion de bit a registro de datos */
static void i_bitop_reg(void)
{
	bitop('r',0);
}

/* JUMP */
static void i_jmp(void)
{
	int ln = lntag++;
	int cycles=0;

	sel_mask_idxr();
	main_ea_control();
	emit("mov r4,r6");    /* Cargar nuevo PC a r6 */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	switch(main_ea)
	{
		case aind: cycles= 8; break;
		case adsp: cycles=10; break;
		case axdp: cycles=14; break;
		case absw: cycles=10; break;
		case absl: cycles=12; break;
		case pcdp: cycles=10; break;
		case pcxd: cycles=14;
	}
	timing(cycles);

	align(2);
	emit("bf_addr%d: .long basefunction",ln);
}

/* JUMP TO SUBROUTINE */
static void i_jsr(void)
{
	int ln = lntag++;
	int cycles=0;

	sel_mask_idxr();
	main_ea_control();      /* no modifica r3 (Z) */
	emit("mov r3,r2");      /* guardar bandera Z */
	emit("mov r6,r3");		/* r3 = PC + base (r5) */
	emit("sub r5,r3");		/* r3 = PC */
	emit("mov r4,r6");		/* r6 = nuevo PC */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	ea_store(LONG,adec,7);  /* Almacenar en la pila el PC antiguo */
	switch(main_ea)
	{
		case aind: cycles=16; break;
		case adsp: cycles=18; break;
		case axdp: cycles=22; break;
		case absw: cycles=18; break;
		case absl: cycles=20; break;
		case pcdp: cycles=18; break;
		case pcxd: cycles=22; break;
	}
	emit("mov r2,r3");      /* restaurar bandera Z */
	timing(cycles);

	align(2);
	emit("bf_addr%d: .long basefunction",ln);
}

/* RETURN FROM SUBROUTINE */
static void i_rts(void)
{
	int ln = lntag++;

	emit("mov r3,r2");    /* guardar Z en r2 */

	ea_load(LONG,ainc,7); /* Carga direccion de la pila */
	emit("mov r3,r6");	  /* que es el nuevo PC */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);

	emit("mov r2,r3");    /* restaurar Z */

	timing(16);

	align(2);
	emit("bf_addr%d: .long basefunction",ln);
}

/* RETURN AND RESTORE CONDITION CODES */
static void i_rtr(void)
{
	int ln = lntag++;

	ea_load(WORD,ainc,7);	/* Cargar CCR de la pila */
	load_ccr_from("r3");    /* (SP) -> CCR */

	emit("mov r3,r2");      /* guardar Z en r2 */

	ea_load(LONG,ainc,7);	/* Cargar PC de la pila */
	emit("mov r3,r6");	    /* (SP) -> PC */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);

	emit("mov r2,r3");      /* restaurar Z */

	timing(20);

	align(2);
	emit("bf_addr%d: .long basefunction",ln);
}

/* RETURN FROM EXCEPTION */
static void i_rte(void)
{
	int ln = lntag++;

	priv_check();
	mem_access(READ_DATA_TYPE, WORD);   /* lectura del SR (llamada retardada) */
	reg2sh(7,"r4",ADDR_REG,LONG);       /* lectura del puntero de pila */
	emit("add #2,r4");
	setup_sr();                         /* genera el SR a partir de r3 */

	/* Esto hay que comentarlo */
	emit("mov r10,r0");
	emit("tst #0x20,r0");
	emit("movt r2");
	save_reg("r3");                     /* salvar Z */
	emit("shll2 r2");
	mem_access(READ_DATA_TYPE, LONG);
	emit("add #28,r2");
	emit("add r14,r2");
	emit("mov.l @r2,r4");
	emit("add #6,r4");
	emit("mov.l r4,@r2");

	/* Desactivacion de bits indicadores de excepciones de grupos de nivel 0 y 1 */
	/* Si no se emulan las excepciones de grupo 0, NO DESACTIVAR bit puesto que  */
	/* desempeña otra indicacion y puede producir conflictos de funcionamiento   */
	emit("mov.l execinfo_addr%d,r1",ln);
	emit("mov.w @r1,r0");
	if (emulate_group_0 || check_branches)
	{
		/* borrar indicadores de excepciones de grupo 0 y 1 */
		emit("and #0xE5,r0");   /* se extiende el signo, pero no importa */
	}
	else
	{
		/* borrar indicadores de excepciones de grupo 1 */
		emit("and #0xE7,r0");   /* se extiende el signo, pero no importa */
	}
	emit("mov.w r0,@r1");

	emit("mov r3,r6");
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);

	restore_reg("r3");         /* restaurar Z */

	timing_cp(20);

	align(2);
	emit("bf_addr%d: .long basefunction",ln);
	gen_mt("execinfo",ln);
}

/* LOAD EFFECTIVE ADDRESS */
static void i_lea(void)
{
	int cycles=0;

	sel_mask_idxr();
	main_ea_control();                      /* Cargar direccion efectiva */
	sh2reg("r4",main_reg,ADDR_REG,LONG);    /* Llevar a registro de direcciones */

	switch(main_ea)
	{
		case aind: cycles=4; break;
		case adsp: cycles=8; break;
		case axdp: cycles=12; break;
		case absw: cycles=8; break;
		case absl: cycles=12; break;
		case pcdp: cycles=8; break;
		case pcxd: cycles=12;
	}
	timing(cycles);
}

/* PUSH EFFECTIVE ADDRESS */
static void i_pea(void)
{
	int cycles=0;

	sel_mask_idxr();
	main_ea_control();	/* Carga de direccion efectiva (no modifica Z) */
	emit("mov r3,r2");  /* guardar bandera Z */
	emit("mov r4,r3");	/* Cargar a r3 para almacenar en la pila */
	ea_store(LONG,adec,7);
	switch(main_ea)
	{
		case aind: cycles=12; break;
		case adsp: cycles=16; break;
		case axdp: cycles=20; break;
		case absw: cycles=16; break;
		case absl: cycles=20; break;
		case pcdp: cycles=16; break;
		case pcxd: cycles=20;
	}

	emit("mov r2,r3");  /* restaurar bandera Z */

	timing(cycles);
}

/* NO OPERATION */
static void i_nop(void)
{
	timing(4);
}

/* MOVE MULTIPLE REGISTERS WITH CONTROL ADDRESSING MODE */
static void i_movem_control(void)
{
	int ln=lntag;
	int cycles=0;

	lntag+=2;
	save_reg("r3");
	sel_mask_idxr();
	save_reg("r10");          /* r10 = lista de mascaras temporal */
	emit("mov.w @r6+,r10");   /* cargar lista de mascaras de registros */
	main_ea_control();        /* Carga direccion efectiva */
	emit("mov #0,r2");        /* r2 = indice = 0 */

	emit("ln%d:",ln);
	emit("shlr r10");         /* mascara -> T */
	emit("bf ln%d",ln+1);

	if(main_dr==0)            /* registro -> memoria */
	{
		switch(main_ea)
		{
		    case aind: cycles= 8; break;
		    case adsp: cycles=12; break;
		    case axdp: cycles=14; break;
		    case absw: cycles=12; break;
		    case absl: cycles=16;
		}
		emit("mov r13,r0");
		emit("mov.l @(r0,r2),r3");   /* carga reg. a r3 para escritura en memoria */
		mem_access(WRITE_DATA_TYPE, main_size);
		emit("add #-%d,r7",main_size*2); /* decrementar ciclos de ejecucion necesarios */
	}
	else                      /* memoria -> registro */
	{
		switch(main_ea)
		{
			case aind: cycles=12; break;
			case adsp: cycles=16; break;
			case axdp: cycles=18; break;
			case absw: cycles=16; break;
			case absl: cycles=20; break;
			case pcdp: cycles=16; break;
			case pcxd: cycles=18;
		}
		mem_access(READ_DATA_TYPE, main_size);
		emit("add #-%d,r7",main_size*2); /* decrementar ciclos de ejecucion necesarios */
		emit("mov r13,r0");
		emit("mov.l r3,@(r0,r2)");       /* carga lectura a registro */
	}

	emit("add #%d,r4",main_size);        /* incrementar direccion */

	emit("ln%d:",ln+1);
	emit("add #4,r2");
	emit("mov #64,r0");
	emit("tst r0,r2");
	emit("bt ln%d",ln);                  /* hay mas registros? */

	restore_reg("r10");                  /* restaurar r10 */
	restore_reg("r3");
	timing(cycles);
}

/* MOVE MULTIPLE REGISTERS WITH POSTINCREMENT ADDRESSING MODE */
static void i_movem_postinc(void)
{
	int ln=lntag;

	lntag+=2;
	save_reg("r3");
	mask_idxr();
	save_reg("r10");               /* r10 = lista de mascaras temporal */
	emit("mov.w @r6+,r10");        /* cargar lista de mascaras de registros */
	reg2sh(-1,"r4",ADDR_REG,LONG); /* direccion inicial a r4 */
	save_reg("r2");
	emit("mov #0,r2");             /* r2 = Indice = 0 */

	emit("ln%d:",ln);
	emit("shlr r10");              /* mascara -> T */
	emit("bf ln%d",ln+1);

	mem_access(READ_DATA_TYPE, main_size);
	emit("add #-%d,r7",main_size*2);  /* decrementar ciclos de ejecución necesarios */
	emit("mov r13,r0");               /* cargar r13 en r0 para direccionar */
	emit("add #%d,r4",main_size);     /* incrementar ptr */
	emit("mov.l r3,@(r0,r2)");	      /* cargar dato en registro */

	emit("ln%d:",ln+1);
	emit("add #4,r2");     			  /* incrementar indice */
	emit("mov #64,r0");
	emit("tst r0,r2");
	emit("bt ln%d",ln);

	restore_reg("r2");
	restore_reg("r10");               /* restaurar r10 */
	sh2reg("r4",-1,ADDR_REG,LONG);    /* guardar dir. final en reg. de direcciones */
	restore_reg("r3");
	timing(12);
}

/* MOVE MULTIPLE REGISTERS WITH PREDECREMENT ADDRESSING MODE */
static void i_movem_predec(void)
{
	int ln=lntag;

	lntag+=2;
	save_reg("r3");
	mask_idxr();
	save_reg("r10");                  /* r10 = lista de mascaras temporal */
	emit("mov.w @r6+,r10");           /* cargar lista de mascaras de registros */
	reg2sh(-1,"r4",ADDR_REG,LONG);    /* direccion inicial a r4 */
	save_reg("r2");
	emit("mov #60,r2");               /* r2 = Indice = 60 */

	emit("ln%d:",ln);
	emit("shlr r10");                 /* mascara -> T */
	emit("bf ln%d",ln+1);

	emit("mov r13,r0");               /* cargar r13 en r0 para direccionar */
	emit("add #-%d,r4",main_size);    /* decrementar direccion */
	emit("mov.l @(r0,r2),r3");	      /* cargar dato en registro */

	mem_access(WRITE_DATA_TYPE, main_size);
	emit("add #-%d,r7",main_size<<1); /* decrementar ciclos de ejecución necesarios */

	emit("ln%d:",ln+1);
	emit("add #-4,r2");               /* decrementar indice */
	emit("cmp/pz r2");	              /* y continuar si quedan mas registros posibles */
	emit("bt ln%d",ln);

	restore_reg("r2");
	restore_reg("r10");               /* restaurar r10 */
	sh2reg("r4",-1,ADDR_REG,LONG);    /* guardar dir. final en reg. de direcciones */
	restore_reg("r3");
	timing(8);
}

/* LINK AND ALLOCATE */
static void i_link(void)
{
	save_reg("r3");                 /* guardar bandera Z */
	mask_idxr();
	reg2sh(-1,"r3",ADDR_REG,LONG);  /* cargar en la pila */
	ea_store(LONG,adec,7);          /* el dato especificado por el reg. de direcciones */
	reg2sh(7,"r3",ADDR_REG,LONG);   /* cargar nuevo dato apuntado por la pila */
	sh2reg("r3",-1,ADDR_REG,LONG);  /* y volcar a reg. de direcciones */
	emit("mov.w @r6+,r4");          /* cargar desplazamiento */
	emit("add r4,r3");              /* y sumar al ptr de pila */
	sh2reg("r3",7,ADDR_REG,LONG);   /* resultado al ptr de la pila */
	restore_reg("r3");              /* restaurar bandera Z */
	timing(16);
}

/* UNLINK */
static void i_unlk(void)
{
	save_reg("r3");                 /* guardar bandera Z */
	mask_idxr();
	reg2sh(-1,"r3",ADDR_REG,LONG);  /* cargar ptr de la pila con reg. direcciones */
	sh2reg("r3",7,ADDR_REG,LONG);
	ea_load(LONG,ainc,7);			/* cargar registro direcciones con tope de la pila */
	sh2reg("r3",-1,ADDR_REG,LONG);
	restore_reg("r3");
	timing(12);
}

/* Mover USP a direccion efectiva */
static void i_move_from_usp(void)
{
	mask_idxr();
	priv_check();					/* chequear privilegios */
	emit("mov.l @(32,r14),r1");     /* cargar ptr. pila */
	sh2reg("r1",-1,ADDR_REG,LONG);
	timing(4);
}

/* Mover al USP */
static void i_move_to_usp(void)
{
	mask_idxr();
	priv_check();				   /* chequear privilegios */
	reg2sh(-1,"r1",ADDR_REG,LONG); /* cargar operando */
	emit("mov.l r1,@(32,r14)");    /* cargar ptr. pila al USP */
	timing(4);
}

/* TRAP */
static void i_trap(void)
{
	int ln = lntag++;

	emit("mov #0x80,r4");
    emit("and #0x3C,r0");          /* aislar vector excepción */
	emit("extu.b r4,r4");
	emit("mov.l g2_exception_addr,r1");
	emit("jsr @r1");
	emit("add r0,r4");             /* obtener direccion excepcion */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	timing(34);

	align(2);
	emit("g2_exception_addr: .long group_2_exception");
	emit("bf_addr%d: .long basefunction",ln);
}

/* TRAP ON OVERFLOW */
static void i_trapv(void)
{
	int ln=lntag++;

	emit("mov r8,r0");
	emit("tst #0x4,r0");      /* testear bandera V */

	emit("bf ln%d",ln);
	timing(4);                /* tiempo de instruccion */

	align(5);
	emit("ln%d:",ln);         /* activar excepcion */
	emit("mov.l g2_exception_ptr,r0");
	emit("jsr @r0");
	emit("mov #0x1C,r4");     /* vector excepcion */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	timing(34+4);             /* tiempo de instruccion + tiempo de exception */

	align(2);
	emit("g2_exception_ptr: .long group_2_exception");
	emit("bf_addr%d: .long basefunction",ln);
}

/* STOP */
static void i_stop(void)
{
	int ln=lntag;

	priv_check();
	emit("mov.w @r6+,r3");      /* carga palabra a continuacion de instruccion */
	emit("mov.l execinfo_addr%d,r2",ln);
	setup_sr();                 /* palabra al SR */
	emit("mov.w @r2,r0");
	emit("mov #0x80,r1");
	emit("extu.b r1,r1");
	emit("or r1,r0");           /* Activar bit CPU stopped */
	emit("mov.w r0,@r2");

	/* Ahora la CPU debe salir del fetch/decode/loop */
	/* Para ello, descontar ciclos de reloj de la instruccion manualmente, */
	/* y salir de emulate */
	emit("mov.l @(execexit_addr-areg,r14),r0");
	emit("add #2,r6");          /* simular fetch (para execexit) */
	emit("jmp @r0");            /* salir de emulate incondicionalmente */
	emit("add #-4,r7");         /* ciclos de STOP = 4 */

	align(2);
	gen_mt("execinfo",ln);
}

/* SIGN-EXTEND BYTE TO WORD */
static void i_extbw(void)
{
	mask_idxr();
	reg2shpci(-1,"r3",DATA_REG,BYTE);
	sh2regpci("r3",-1,DATA_REG,WORD);
	setf_vc0();
	timing(4);
}

/* SIGN-EXTEND WORD TO LONG WORD */
static void i_extwl(void)
{
	mask_idxr();
	reg2shpci(-1,"r3",DATA_REG,WORD);
	sh2regpci("r3",-1,DATA_REG,LONG);
	setf_vc0();
	timing(4);
}

/* SWAP */
static void i_swap(void)
{
	mask_idxr();
	reg2shpci(-1,"r3",DATA_REG,LONG);
	emit("swap.w r3,r3");           /* rotar operando */
	sh2regpci("r3",-1,DATA_REG,LONG);
	setf_vc0();
	timing(4);
}

/* MULTIPLICATION */
static void i_mul(void)
{
	int ln=lntag++;

	sel_mask_idxr();
	main_size=WORD;      /* es una operación de tamaño WORD solamente */
	main_ea_load();      /* primer factor en r3 */

	/*********************/
	/* Calculo de ciclos */
	/*********************/

	if (exact_timing)
	{
		emit("mov #0,r0");     /* contador de 1s (MULU) o 10s o 01s (MULS) */
		emit("mov r3,r1");     /* r3 no se modifica */
		emit("mov r0,r4");     /* auxiliar para sumas con C */
		if (main_cc)
			emit("mov r0,r2");

		if (main_cc)
			emit("mov #16,r8");    /* contador de iteraciones */
		else
			emit("extu.w r1,r1");  /* el propio registro limita el bucle */

		emit("shlr r1");        /* bit r1 -> T */
		emit("ln%d:",ln);
		if (main_cc)            /* MULS: multiplicacion con signo */
		{
			emit("movt r2");
			emit("xor r2,r4");  /* 10 o 01 -> incrementar 1 */
			emit("add r4,r0");  /* incrementar contador */
			emit("mov r2,r4");  /* ultimo bit en r4 */
		}
		else
			emit("addc r4,r0"); /* incrementar con T */

		/* Contador para MULS, bits a 1 restantes para MULU */
		if (main_cc)
			emit("dt r8");
		else
			emit("cmp/pl r1");

		emit("b%c/s ln%d",(main_cc)?'f':'t',ln);
		emit("shlr r1");        /* bit r1 -> T */

		emit("sub r0,r7");
		emit("sub r0,r7");
	}
	else
	{
		if (main_cc)
			emit("add #-8,r7");         /* valor medio (0-8 bits -> 0-16 ciclos) */
		else
			emit("add #-16,r7");        /* valor medio (0-16 bits -> 0-32 ciclos) */
	}

	/****************************/
	/* Fin de calculo de ciclos */
	/****************************/

	reg2sh(main_reg,"r1",DATA_REG,main_size);
	emit("mul%c.w r1,r3",main_cc?'s':'u');
	emit("sts macl,r3");
	sh2reg("r3",main_reg,DATA_REG,LONG);
	setf_vc0();
	timing(38+main_ea_cycles());    /* 2n se contabiliza antes en el codigo */
}

/* DIVISION */
static void i_div(void)
{
	int base_cycles;
	int ln=lntag;

	lntag+=2;
	use_idxr = 1;
	sel_mask_idxr();
	main_size=WORD;             /* es una operación solo de tamaño WORD */

	/* cargar divisor en r3 */
	main_ea_load();

	/* cargar dividendo en r1 */
	reg2sh(main_reg,"r1",DATA_REG,LONG);

	emit("mov r3,r8");    /* r8 = divisor (para calcular resto) */
	emit("tst r8,r8");
	emit("bt/s ln%d",ln); /* r3 = 0 -> division por cero (excepcion) */
	emit("shll16 r3");    /* divisor en r3 -> palabra alta r3 */

	if (main_cc && exact_timing)
	{
        emit("mov r1,r0");
        emit("rotl r0");
        emit("movt r0");
		emit("sub r0,r7");    /* compensar ciclo (*2) */
		emit("sub r0,r7");
	}

	/* testear desbordamiento de division */
	if (main_cc)
	{
		/* el desbordamiento se produce si el dividendo no esta comprendido   */
		/* en sentido estricto (no =) en el rango entre +hdivisor y -hdivisor */
		emit("cmp/gt r1,r3");
		emit("movt r2");
		emit("neg r3,r0");
		emit("cmp/gt r1,r0");
		emit("movt r0");
		emit("cmp/eq r0,r2");
	}
	else
    {
		emit("cmp/hs r3,r1");
    }

	emit("bt ov%d",ln+1);       /* desbordamiento de division */


	if (exact_timing)      /* calculo preciso de ciclos de reloj */
	{
		if (main_cc)       /* division con signo (DIVS) */
		{
			emit("cmp/pz r8");    /* divisor >= 0? */
			emit("movt r2");      /* r2 = mascara incr./decr. */
			emit("cmp/pz r1");    /* dividendo >= 0? */
			emit("movt r4");
			emit("and r2,r4");    /* enmascarar valor */
			emit("movt r0");
			emit("dt r0");        /* bit dividendo >= 0 invertido */
			emit("and r2,r0");
			emit("sub r0,r4");    /* r4 = ciclos incr. - ciclos decr. */
			emit("shll r4");      /* ciclos *= 2 */
			emit("add r4,r7");    /* incrementar ciclos */

			base_cycles = (55+6)*2;
		}
		else               /* division sin signo (DIVU) */
		{
			emit("mov #15,r4");      /* r4 = contador del bucle */
			emit("mov r1,r0");       /* guardar dividendo para calcular resto division */

			emit("shll r0");
			emit("detloop%d:",ln);
			emit("cmp/hs r3,r0");    /* dividendo >= hdivisor? */
			emit("bf/s nsbhd%d",ln);
			emit("add #-4,r7");      /* ciclos += 2*2 */
			emit("sub r3,r0");       /* dividendo -= hdivisor */
			emit("add #2,r7");       /* ciclos -= 1*2 (ajuste) */
			emit("nsbhd%d:",ln);
			emit("dt r4");           /* decrementar contador iteraciones */
			emit("bf/s detloop%d",ln);
			emit("shll r0");        /* dividendo <<= 1 */

			base_cycles = 38*2;
		}
	}
	else
	{
		/* calculo de ciclos no preciso */
		if(main_cc)             /* division con signo */
		{
			/* segun motorola: mejor caso:142, peor caso: 158 (150) */
			/* segun jorge cwik: mejor caso: 122, peor caso: 156 (139) */
			base_cycles = 139;
		}
		else
		{
			/* segun motorola: mejor caso: 126, peor caso: 140 (133) */
			/* segun jorge cwik: mejor caso: 76, peor caso: 136 (106) */
			base_cycles = 106;
		}
	}

	emit("mov r1,r0");    /* r0 = dividendo (para calcular el resto) */

	if (main_cc)          /* division con signo */
	{
		/* si el dividendo es negativo, restar 1 */
		emit("mov #0,r2");
		emit("rotl r0");
		emit("subc r2,r1");
		emit("rotr r0");
	}

	emit("div0%s",main_cc?"s r3,r1":"u");   /* realizar operacion con o sin signo */

	/* calculo del cociente */
	emit(".rept 16");
	emit("div1 r3,r1");
	emit(".endr");

    if (main_cc && exact_timing)
    {
        emit("mov r3,r4");         /* r4 = divisor para ajustar cociente (absoluto) */
    }

	/* SH requiere el ajuste del cociente */
	if (main_cc)     /* division con signo */
	{
		exts("r1","r3",WORD);
		emit("rotcl r3");
		emit("addc r2,r3");

        if (main_cc && exact_timing)
            emit("mov r3,r1");

		extu("r3","r3",WORD); /* r3 = cociente */
	}
	else
	{
		emit("rotcl r1");
		extu("r1","r3",WORD);       /* r3 = cociente */
	}

	if (main_cc && exact_timing)
	{
		/* calculo del cociente absoluto */
		emit("cmp/pz r0");
		emit("bt/s nondivd%d",ln);
		emit("mov r3,r1");
		emit("neg r1,r1");

		/* bucle de desplazamientos */
		emit("nondivd%d:",ln);
        emit("cmp/pz r4");
        emit("bt/s aquot%d",ln);
		emit("mov #15,r4");
        emit("neg r1,r1");

        emit("aquot%d:",ln);
        emit("shll16 r1");

		emit("dstloop%d:",ln);
		emit("cmp/pz r1");    /* >= 0 -> restar ciclos */
		emit("movt r2");
        emit("shll r2");
		emit("shll r1");
		emit("dt r4");
		emit("bf/s dstloop%d",ln);
        emit("sub r2,r7");    /* decrementar ciclos * 2 */
	}

	/* calculo del resto */
	emit("mul%c.w r3,r8",main_cc?'s':'u');
	emit("sts macl,r8");  /* r8 = divisor * cociente */
	emit("sub r8,r0");    /* r0 = resto */
	emit("shll16 r0");
	emit("or r0,r3");     /* r3 = resultado (palabra alta = resto, palabra baja = cociente) */

	sh2reg("r3",main_reg,DATA_REG,LONG); /* almacenar resultado */
	exts("r3","r3",WORD);  /* testear cociente */
	setf_vc0();            /* bandera V siempre a 0 si la operacion ha sido completada con exito */

	timing(base_cycles+main_ea_cycles());

	/* desbordamiento */
	align(5);
	emit("ov%d:",ln+1);
	emit("mov #0x4,r8");   /* bandera V = 1 (desbordamiento) */

	/* calculo de ciclos (overflow) */
	/* segun jorge cwik */

	if (main_cc)            /* division con signo */
		/* Segun el signo del dividendo son 16 o 18 ciclos    */
		/* Se toman 18 ciclos de forma fija, que se compensan */
		/* antes de determinar el desbordamiento              */
		base_cycles = (6+2)*2;
	else
		base_cycles = 10;

	timing(base_cycles+main_ea_cycles());

	/* Excepcion por division por cero */
	align(5);
	emit("ln%d:",ln);

	/* Si el divisor es 0 -> TRAP (excepcion de division por cero) */
	emit("mov.l g2_except_addr%d,r0",ln);
	emit("jsr @r0");
	emit("mov #0x14,r4");
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	base_cycles=38;
	timing(base_cycles+main_ea_cycles());

	align(2);
	emit("g2_except_addr%d: .long group_2_exception",ln);
	emit("bf_addr%d: .long basefunction",ln);
}

/* NEGATE */
static void i_neg(void)
{
	int cycles;

	sel_mask_idxr();           /* obtener registro */
	cycles = (main_size == LONG)?6:4;

	if(main_ea == dreg)
	{
		reg2shpci(-1,"r3",DATA_REG,main_size);
	}
	else
	{
		cycles<<=1;
		main_ea_rmw_load();    /* r3 = operando */
	}

	switch(main_size)
	{
		case BYTE: emit("shll16 r3"); emit("shll8 r3"); break;
		case WORD: emit("shll16 r3"); break;
	}

	emit("mov #0,r0");
	emit("subv r3,r0");    /* restar de 0 (calculando V) */
	emit("movt r8");       /* r8 = 000V */
	emit("mov #0,r0");
	emit("clrt");
	emit("subc r3,r0");
	emit("movt r9");
	emit("addc r8,r8");
	emit("mov r0,r3");     /* resultado final en r3 */

	/* Ajusta resultado */
	readj_bwdata("r3",main_size);

	if (main_ea == dreg)
		sh2regpci("r3",-1,DATA_REG,main_size);
	else
	{
		main_ea_rmw_store();
		cycles+=main_ea_cycles();
	}

	set_nz();
	timing(cycles);
}

/* calcula las banderas NZ en operaciones xBCD y xDDX */
static void set_opx_nz_from(char *reg)
{
	/* Calculo de bandera N */
	emit("rotl r3");
	emit("addc r8,r8");

	/* Calculo de bandera Z */
	/* Z = 0 si el resultado no es 0, sin modificar en caso contrario */
	/* reg = antigua Z - r3 = nueva Z */
	emit("or %s,r3",reg);
}

/* calcula las banderas NZ en operaciones xBCD y xDDX */
/* r2 = antigua bandera Z */
static void set_opx_nz(void)
{
	set_opx_nz_from("r2");
}

/* NEGATE WITH EXTEND */
static void i_negx(void)
{
	int cycles;

	sel_mask_idxr();		/* obtener registro */
	save_reg("r3");

	cycles = (main_size == LONG)?6:4;

	if(main_ea == dreg)
	{
		reg2shpci(-1,"r3",DATA_REG,main_size);
	}
	else
	{
		cycles<<=1;
		main_ea_rmw_load();  /* r3 = operando */
	}

	/* Desplazamiento a tamano LONG para operar */
	if (main_size == BYTE)
	{
		emit("mov #24,r0");
		emit("shld r0,r3");
	}
	else if (main_size == WORD)
	{
		emit("shll16 r3");
	}

	emit("mov r3,r1");     /* guardar operando en r1 */
	emit("shlr r9");       /* T = X */
	emit("movt r8");       /* r8 = X */
	emit("negc r3,r3");    /* r3 = resultado, T = C */
	emit("movt r9");       /* r9 = C = X */
	emit("mov #0,r0");     /* r0 = 0 */
	emit("subv r8,r0");    /* r0 = 0 - X */
	emit("movt r3");       /* r3 = V parcial */
	emit("subv r1,r0");    /* r0 = resultado, T = V */
	emit("movt r8");       /* r8 = V parcial */
	emit("or r3,r8");      /* r8 = V */
	emit("cmp/pl r9");
	emit("addc r8,r8");    /* r8 = CV */
	emit("mov r0,r3");     /* r3 = resultado */

	/* Ajustar resultado */
	if (main_size != LONG)
	{
		emit("mov #-%d,r0",32-main_size*8);
		emit("shad r0,r3");
	}

	if (main_ea == dreg)
		sh2regpci("r3",-1,DATA_REG,main_size);
	else
	{
		main_ea_rmw_store();
		cycles+=main_ea_cycles();
	}

	restore_reg("r2");
	set_opx_nz();
	timing(cycles);
}

/* Prototipos para NBCD */
static void asbcd_op(char *op);

/* NEGATE BCD */
static void i_nbcd(void)
{
	int ln = lntag++;

	main_size = BYTE;		 /* operacion solo de byte */
	use_idxr = 1;

	sel_mask_idxr();
	save_reg("r3");       /* r3 a la pila */
	main_ea_rmw_load();

	emit("mov r3,r1");    /* r1 = B = lectura operando */
	emit("mov #0,r3");    /* r3 = A */

	/* Operacion BCD y carga de resultado */
	asbcd_op("sub");
	main_ea_rmw_store();

	/* calculo de banderas N y Z */
	restore_reg("r2");
	set_opx_nz();

	timing((main_ea == dreg)?6:8+main_ea_cycles());
}

/* TEST AND SET */
static void i_tas(void)
{
	main_size=BYTE;
	sel_mask_idxr();
	main_ea_rmw_load();
	emit("mov r3,r1");      /* r3 se modifica tras el set flags */
	save_reg("r3");
	setf_vc0();

	emit("mov r1,r0");      /* cargar a r0 para activar */
	emit("or #0x80,r0");    /* pq quiero preservar la parte alta de r3 */
	emit("mov r0,r3");		/* activa el bit mas alto del operando */

	main_ea_rmw_store();
	restore_reg("r3");
	timing((main_ea == dreg)?4:14+main_ea_cycles());
}

/* NOT */
static void i_not(void)
{
	int cycles;

	sel_mask_idxr();
	cycles = (main_size == LONG)?6:4;

	if(main_ea == dreg)
	{
		reg2shpci(-1,"r3",DATA_REG,main_size);
	}
	else
	{
		cycles<<=1;
		main_ea_rmw_load();    /* r3 = operando */
	}

	emit("not r3,r3");         /* operacion */

	if (main_ea == dreg)
		sh2regpci("r3",-1,DATA_REG,main_size);
	else
	{
		main_ea_rmw_store();
		cycles+=main_ea_cycles();
	}

	exts("r3","r3",main_size);
	setf_vc0();
	timing(cycles);
}

/* EXCHANGE */
/* main_dr y main_ir valen 0 (registro de datos) o 32 (registro de direcciones) */
static void i_exg(void)
{
	mask_idxr();

	emit("mov r3,r4");   /* guardar Z (no se modifica) */

	/* Cargar fuentes */
	reg2shpci(-1,"r1",main_ir?ADDR_REG:DATA_REG,LONG);
	reg2sh(main_reg,"r3",main_dr?ADDR_REG:DATA_REG,LONG);

	/* Cargar destinos */
	sh2regpci("r3",-1,main_ir?ADDR_REG:DATA_REG,LONG);
	sh2reg("r1",main_reg,main_dr?ADDR_REG:DATA_REG,LONG);

	emit("mov r4,r3");   /* recuperar antigua Z */

	timing(6);
}

/* COMPARE MEMORY */
static void i_cmpm(void)
{
	mask_idxr();
	ea_load(main_size,ainc,-1);		  /* primer operando */
	emit("mov r3,r2");                /* r2 = primer operando */
	ea_load(main_size,ainc,main_reg); /* segundo operando */

	/* r2 = 1er operando (src) */
	/* r3 = 2o operando (dest) */
	arith_op("cmp","r2","r3","r0",main_size,0);

	set_nz();
	timing((main_size == LONG)?20:12);
}

/* Realiza una operacion aritmetica con bandera X */
/* r1 = operando fuente / r3 = operando destino   */
/* r0 = registro temporal                         */
static void arith_opx(char *op)
{
    emit("shlr r9");    /* T = X */
    emit("movt r8");    /* r8 = T = X */

    /* Desplazamiento a tamano LONG para operar */
	if (main_size == BYTE)
	{
		emit("mov #24,r0");
		emit("shld r0,r1");
		emit("shld r0,r3");
        emit("shld r0,r8");
	}
	else if (main_size == WORD)
	{
		emit("shll16 r1");
		emit("shll16 r3");
        emit("shll16 r8");
	}

	emit("clrt");          /* limpiar para calculo de C */
    emit("mov r3,r0");     /* r0 = operando destino */

	/* Calculo de banderas C y X */
    emit("%sc r1,r3",op);  /* fuente - destino */
    emit("movt r9");       /* r9 = C */
    emit("clrt");
    emit("%sc r8,r3",op);
    emit("movt r3");
    emit("or r3,r9");

	/* Calculo de bandera V */
    emit("%sv r1,r0",op);  /* fuente - destino */
    emit("movt r3");       /* r3 = V parcial */
    emit("%sv r8,r0",op);  /* insertar bandera */
    emit("movt r8");       /* r8 = V parcial */
    emit("or r3,r8");      /* r8 = V */
    emit("cmp/pl r9");     /* T = C */
    emit("addc r8,r8");    /* r8 = VC */
    emit("mov r0,r3");     /* cargar resultado a r3 */

	/* Ajustar resultado */
	if (main_size != LONG)
	{
		emit("mov #-%d,r0",32-main_size*8);
		emit("shad r0,r3");
	}
}


/* Operacion de suma-resta con direccionamiento registro de datos */
static void opx_dreg(char* op)
{
	int ln = lntag++;

	use_idxr = 1;

	mask_idxr();
	emit("mov r3,r4");   /* guardar Z (necesario para calculo Z) */

	reg2sh(main_reg,"r3",DATA_REG,main_size);
	reg2sh(-1,"r1",DATA_REG,main_size);

	/* operacion y carga de resultado */
	arith_opx(op);
	sh2reg("r3",main_reg,DATA_REG,main_size);

	/* calculo de banderas N y Z */
	set_opx_nz_from("r4");

	timing((main_size <= WORD)?4:8);
}

/* Operacion de suma-resta con direccionamiento registro de direcciones */
static void opx_adec(char* op)
{
	int ln = lntag++;

	mask_idxr();
	save_reg("r3");
	ea_load(main_size,adec,-1);

	emit("mov r3,r2");    /* guardar dato leido */
	ea_rmw_load(main_size,adec,main_reg);
	emit("mov r2,r1");    /* recuperar dato para operar */

	/* operacion y carga de resultado */
	arith_opx(op);
	ea_rmw_store(main_size,adec,main_reg);

	/* calculo de banderas N y Z */
	restore_reg("r2");
	set_opx_nz();

	timing((main_size <= WORD)?18:30);
}

/* ADDXs y SUBXs */
static void i_addx_dreg(void) {opx_dreg("add");}
static void i_addx_adec(void) {opx_adec("add");}
static void i_subx_dreg(void) {opx_dreg("sub");}
static void i_subx_adec(void) {opx_adec("sub");}

/* Realiza la operacion ABCD o SBCD */
/* r1, r3 operandos */
/* resultado en r3 */
static void asbcd_op(char *op)
{
	int ln = lntag++;

	emit("mov #0x0F,r0");
	emit("and r1,r0");          /* r0 = nibble bajo fuente */
	emit("mov #0x0F,r8");
	emit("and r3,r8");          /* r8 = nibble bajo destino */

	/* suma del primer nibble */
	emit("cmp/pl r9");          /* X -> T */
	emit("%sc r0,r8",op);
	emit("mov #9,r0");
	if (emulate_undoc)
		emit("mov r8,r9");      /* nibble sin ajustar a r9 */

	emit("cmp/hi r0,r8");
	emit("bf .nonibadd%d",ln);
	emit("add #%s6,r8",(op[0] == 'a')?"":"-");
	emit(".nonibadd%d:",ln);

	/* enmascarar nibble alto de fuente y destino */
	emit("mov r3,r0");
	emit("and #0xF0,r0");
	emit("mov r0,r3");
	emit("mov r1,r0");
	emit("and #0xF0,r0");
	emit("%s r0,r3",op);

	/* calculo del resultado sin ajustar para calcular V */
	if (emulate_undoc)
	{
		emit("mov r3,r1");
		emit("add r9,r1");      /* resultado sin ajustar en r1 */
	}
	emit("add r8,r3");          /* resultado parcial */

	emit("mov #0x99,r0");
	emit("extu.b r0,r0");       /* sin signo en la carga imm. */
	emit("cmp/hi r0,r3");
	emit("movt r9");            /* r9 = X = C */
	emit("bf .endop%d",ln);

	/* r3 = resultado ajustado */
	emit("mov #0xA0,r0");
	emit("extu.b r0,r0");
	emit("%s r0,r3",(op[0]=='a')?"sub":"add");

	emit(".endop%d:",ln);
	emit("exts.b r3,r3");       /* extension en resultado */

	/* Calculo de bandera V */
	if (emulate_undoc)
	{
		emit("exts.b r1,r1");
		emit("shll r1");
		emit("b%c .setv0%d",(op[0]=='a')?'t':'f',ln);
		if (op[0] == 'a')
		{         /* ABCD */
			emit("mov r3,r8");
			emit("shll r8");
			emit("movt r8");        /* r8 = V */
		}
		else
		{                    /* SBCD */
			emit("mov #0x80,r0");
			emit("tst r0,r3");
			emit("movt r8");        /* r8 = V */
		}
		emit("shll r8");
		emit("bra .endnbcdfvc%d",ln);
		emit("or r9,r8");           /* r8 = VC */
		
		align(5);
		emit(".setv0%d:",ln);
	}

	emit("mov r9,r8");          /* r8 = VC (V = 0) */

	if (emulate_undoc)
		emit(".endnbcdfvc%d:",ln);
}

/* ABCD Dy,Dx */
static void i_abcd_dreg(void)
{
	main_size=BYTE;
	use_idxr = 1;

	mask_idxr();
	emit("mov r3,r4");   /* guardar Z (necesario para calculo Z) */

	reg2sh(main_reg,"r3",DATA_REG,main_size);
	reg2sh(-1,"r1",DATA_REG,main_size);

	/* Operacion BCD y carga de resultado */
	asbcd_op("add");
	sh2reg("r3",main_reg,DATA_REG,main_size);

	/* calculo de banderas N y Z */
	set_opx_nz_from("r4");

	timing((main_size <= WORD)?4:8);
}

/* ABCD -(Ay),-(Ax) */
static void i_abcd_adec(void)
{
	main_size=BYTE;
	use_idxr = 1;

	mask_idxr();
	save_reg("r3");
	ea_load(main_size,adec,-1);

	emit("mov r3,r2");    /* guardar dato leido */
	ea_rmw_load(main_size,adec,main_reg);
	emit("mov r2,r1");    /* recuperar dato para operar */

	/* Operacion BCD y carga de resultado */
	asbcd_op("add");
	ea_rmw_store(main_size,adec,main_reg);

	/* banderas N y Z */
	restore_reg("r2");
	set_opx_nz();

	timing((main_size <= WORD)?18:30);
}

/* SBCD Dy,Dx */
static void i_sbcd_dreg(void)
{
	main_size=BYTE;
	use_idxr = 1;

	mask_idxr();
	emit("mov r3,r4");    /* guardar bandera Z */
	reg2sh(main_reg,"r3",DATA_REG,main_size);
	reg2sh(-1,"r1",DATA_REG,main_size);

	/* Operacion BCD y carga de resultado */
	asbcd_op("sub");
	sh2reg("r3",main_reg,DATA_REG,main_size);

	/* calculo de banderas N y Z */
	set_opx_nz_from("r4");

	timing((main_size <= WORD)?4:8);
}

/* SBCD -(Ay),-(Ax) */
static void i_sbcd_adec(void)
{
	main_size=BYTE;
	use_idxr = 1;

	mask_idxr();
	save_reg("r3");
	ea_load(main_size,adec,-1);

	emit("mov r3,r2");    /* guardar dato leido */
	ea_rmw_load(main_size,adec,main_reg);
	emit("mov r2,r1");    /* recuperar dato leido */

	/* Operacion BCD y carga de resultado */
	asbcd_op("sub");
	ea_rmw_store(main_size,adec,main_reg);

	/* banderas N y Z */
	restore_reg("r2");
	set_opx_nz();

	timing((main_size <= WORD)?18:30);
}

/* MOVE PERIPHERAL DATA FROM MEMORY TO REGISTER */
static void i_movep_mem2reg(void)
{
	save_reg("r3");
	mask_idxr();
	emit("mov.w @r6+,r4");             /* obtener desplazamiento 16-bits */
	reg2sh(-1,"r1",ADDR_REG,LONG);
	mem_access(READ_DATA_TYPE, BYTE);  /* lectura primer byte */
	emit("add r1,r4");                 /* anadir direccion al desplazamiento */
	emit("mov r3,r2");                 /* almacenar byte */
	extu("r2","r2",BYTE);
	emit("shll8 r2");                  /* colocar byte */
	mem_access(READ_DATA_TYPE, BYTE);  /* lectura segundo byte */
	emit("add #2,r4");                 /* incrementar direccion */
	extu("r3","r3",BYTE);
	emit("or r3,r2");

	if(main_size == WORD)
	{
		sh2reg("r2",main_reg,DATA_REG,WORD); /* cargar resultado */
	}
	else
	{
		emit("shll8 r2");
		mem_access(READ_DATA_TYPE, BYTE);    /* lectura tercer byte */
		emit("add #2,r4");
		extu("r3","r3",BYTE);
		emit("or r3,r2");                    /* almacenar byte */
		mem_access(READ_DATA_TYPE, BYTE);    /* lectura cuarto byte */
		emit("add #2,r4");                   /* incrementar direccion */
		emit("shll8 r2");
		extu("r3","r3",BYTE);
		emit("or r3,r2");
		sh2reg("r2",main_reg,DATA_REG,LONG); /* cargar resultado */
	}
	restore_reg("r3");
	timing((main_size == LONG)?24:16);
}

/* MOVE PERIPHERAL DATA FROM REGISTER TO MEMORY */
static void i_movep_reg2mem(void)
{
	save_reg("r3");
	mask_idxr();
	emit("mov.w @r6+,r4");               /* obtener desplazamiento 16-bits */
	reg2sh(-1,"r1",ADDR_REG,LONG);
	emit("add r1,r4");                   /* anadir direccion al desplazamiento */
	reg2sh(main_reg,"r2",DATA_REG,LONG); /* cargar dato a almacenar en memoria */

	if(main_size == LONG)
		emit("swap.w r2,r2");            /* Intercambiar palabra para almacenar */

	emit("mov r2,r3");
	mem_access(WRITE_DATA_TYPE, BYTE);
	emit("shlr8 r3");

	emit("add #2,r4");
	mem_access(WRITE_DATA_TYPE, BYTE);
	emit("mov r2,r3");
	if(main_size == LONG)
	{
		emit("add #2,r4");               /* incrementar ptr. */
		emit("swap.w r2,r2");            /* intercambiar para siguiente palabra */
		emit("mov r2,r3");
		mem_access(WRITE_DATA_TYPE, BYTE);
		emit("shlr8 r3");

		emit("add #2,r4");               /* incrementar ptr. a memoria */
		mem_access(WRITE_DATA_TYPE, BYTE);
		emit("mov r2,r3");               /* cuarto byte */
	}
	restore_reg("r3");
	timing((main_size == LONG)?24:16);
}

/* CHECK REGISTER AGAINST BOUNDS */
static void i_chk(void)
{
	int ln=lntag++;

	/* Operacion de tamaño WORD solamente! */
	sel_mask_idxr();
	main_ea_load();
	reg2sh(main_reg,"r1",DATA_REG,WORD);  /* Cargar en r1 el operando registro */
	emit("extu.w r1,r1");
	emit("cmp/pz r1");
	emit("bf setn%d",ln);

	emit("mov #0,r8");   /* N = 0 */
	emit("cmp/hi r3,r1");
	emit("bt ln%d",ln);

	timing(10+main_ea_cycles());	/* tiempo de instruccion (no trap) */

	align(5);
	emit("setn%d:",ln);
	emit("mov #1,r8");              /* bandera N=1 (Dn < 0) */

	/* Fuera del rango, generar excepcion CHK */
	emit("ln%d:",ln);
	save_reg("r1"); /* guardar Z */
	emit("mov.l g2_except_ptr%d,r0",ln);
	emit("jsr @r0");
	emit("mov #0x18,r4");
	restore_reg("r3");  /* fijar Z */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	timing(10+40+main_ea_cycles());	/* tiempo instruccion + tiempo excepcion */

	align(2);
	emit("g2_except_ptr%d: .long group_2_exception",ln);
	emit("bf_addr%d: .long basefunction",ln);
}

/* Variable que indica la emision de la etiqueta para excepciones 'ILLEGAL' */
static int created_illegal=0;

/* TAKE ILLEGAL INSTRUCTION TRAP */
static void i_illegal(void)
{
	int ln = lntag++;

	if(!created_illegal)
	{
		emit("r_illegal:");
		created_illegal=1;
	}

	save_reg("r3");
	emit("mov.l g1_except_addr%d,r0",ln);
	emit("add #-2,r6");
	emit("jsr @r0");
	emit("mov #0x10,r4");                /* vector de interrupcion */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	restore_reg("r3");
	timing(34);

	align(2);
	emit("g1_except_addr%d: .long group_1_exception",ln);
	emit("bf_addr%d: .long basefunction",ln);
}

/* EMULACION 1010 */
static void i_aline(void)
{
	int ln = lntag++;

	save_reg("r3");
	emit("mov.l g1_except_addr%d,r0",ln);
	emit("add #-2,r6");          /* guardar ultima instruccion */
	emit("jsr @r0");
	emit("mov #0x28,r4");        /* vector de interrupcion */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	restore_reg("r3");
	timing(34);

	align(2);
	emit("g1_except_addr%d: .long group_1_exception",ln);
	emit("bf_addr%d: .long basefunction",ln);
}

/* EMULACION 1111 */
static void i_fline(void)
{
	int ln = lntag++;

	save_reg("r3");
	emit("mov.l g1_except_addr%d,r0",ln);
	emit("add #-2,r6");         /* guardar ultima instrucción */
	emit("jsr @r0");
	emit("mov #0x2C,r4");       /* vector de interrupcion */
	sprintf(bf_tag,"bf_addr%d",ln);
	get_new_pc(bf_tag);
	restore_reg("r3");
	timing(34);

	align(2);
	emit("g1_except_addr%d: .long group_1_exception",ln);
	emit("bf_addr%d: .long basefunction",ln);
}

/* RESET */
static void i_reset(void)
{
	int ln = lntag++;

	priv_check();              /* chequear privilegios */
	emit("mov.l resethandler_addr%d,r0",ln);
	emit("mov.l @r0,r1");      /* cargar direccion de manejador */
	emit("tst r1,r1");
	emit("bt r_done");         /* Si no hay manejador, no hay mas que hacer */

	save_reg("r3");
	core_exit(ln);             /* salir del ensamblador */
	emit("sts.l	pr,@-r15");
	emit("jsr @r1");           /* llamar al manejador */
	emit("nop");
	emit("lds.l	@r15+,pr");
	core_enter(ln);            /* volver al ensamblador */
	restore_reg("r3");

	emit("r_done:");
	timing(132);

	align(2);
	gen_mt("io_cycle_counter",ln);
	gen_mt("resethandler",ln);
}

/****************************************************************************/
/* FUNCIONES DE DESCODIFICACION                                             */
/****************************************************************************/

static int rproc [0x10000];
static byte unique[0x10000];
static int stop_decode;		/* Variable que indica el final de la descodificacion */

static int test(int n, int m, int op)
{
	int t;

	if((n & m) != op) return 0;
	for(t = op & 0xF000; t < n; t++)
	{
		if((!unique[t]) && ((t & m) == (n & m)))
		{
			rproc[n] = t;
			return 2;
		}
	}
	unique[n] = (m >> 16) & 1;
	rproc[n] = n;
	t = (m ^ 0xFFFF) & 0xFFF;

	/* Imprimir informacion acerca de los codigos de operacion */
	if(!t)
		emit("! Opcode %04X",n);
	else
		emit("! Opcodes %04X - %04X",n, op + t);

	emit("%c%03X:", ((n >> 12) & 0xF) + 'K', n & 0xFFF);
	return 1;
}

/* Funcion de definicion de instrucciones */
static void idef(int n, int mask, int op, void(*proc)(void))
{
	if(stop_decode) return;
	stop_decode = test(n, mask, op);
	if(stop_decode == 1) proc();
}

/* Generacion para todos los modos de direccionamiento */
static void eadef_all(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;
	main_ea = dreg; idef(n, m | 0x38, op | 0x00, proc);
	main_ea = areg; idef(n, m | 0x38, op | 0x08, proc);
	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = ainc; idef(n, m | 0x38, op | 0x18, proc);
	main_ea = adec; idef(n, m | 0x38, op | 0x20, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
	main_ea = pcdp; idef(n, m | 0x3F, op | 0x3A, proc);
	main_ea = pcxd; idef(n, m | 0x3F, op | 0x3B, proc);
	main_ea = immd; idef(n, m | 0x3F, op | 0x3C, proc);
}

/* Generacion para todos los modos de direccionamiento */
/* No incluye directo a registro de direcciones cuando el tamano de operando es BYTE */
static void eadef_all_nobyteaddress(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;

	main_ea = dreg;
	idef(n, m | 0x38, op | 0x00, proc);

	if(main_size != BYTE)
		main_ea = areg; idef(n, m | 0x38, op | 0x08, proc);

	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = ainc; idef(n, m | 0x38, op | 0x18, proc);
	main_ea = adec; idef(n, m | 0x38, op | 0x20, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
	main_ea = pcdp; idef(n, m | 0x3F, op | 0x3A, proc);
	main_ea = pcxd; idef(n, m | 0x3F, op | 0x3B, proc);
	main_ea = immd; idef(n, m | 0x3F, op | 0x3C, proc);
}

/* Generacion para modos de direccionamiento de datos */
static void eadef_data(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;

	main_ea = dreg; idef(n, m | 0x38, op | 0x00, proc);
	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = ainc; idef(n, m | 0x38, op | 0x18, proc);
	main_ea = adec; idef(n, m | 0x38, op | 0x20, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
	main_ea = pcdp; idef(n, m | 0x3F, op | 0x3A, proc);
	main_ea = pcxd; idef(n, m | 0x3F, op | 0x3B, proc);
	main_ea = immd; idef(n, m | 0x3F, op | 0x3C, proc);
}

/* Generacion para modos de direccionamiento alterables */
/* No incluye directo a registro de direcciones cuando el tamano de operando es BYTE */
static void eadef_alterable_nobyteaddress(int n, int m, int op, 
void(*proc)(void))
{
	if(stop_decode) return;

	main_ea = dreg; idef(n, m | 0x38, op | 0x00, proc);
	if(main_size != BYTE)
		main_ea = areg; idef(n, m | 0x38, op | 0x08, proc);

	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = ainc; idef(n, m | 0x38, op | 0x18, proc);
	main_ea = adec; idef(n, m | 0x38, op | 0x20, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
}

/* Generacion para modos de direccionamiento de dato alterable */
static void eadef_data_alterable(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;
	main_ea = dreg; idef(n, m | 0x38, op | 0x00, proc);
	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = ainc; idef(n, m | 0x38, op | 0x18, proc);
	main_ea = adec; idef(n, m | 0x38, op | 0x20, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
}

/* Generacion para modos de direccionamiento de memoria alterable */
static void eadef_memory_alterable(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;
	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = ainc; idef(n, m | 0x38, op | 0x18, proc);
	main_ea = adec; idef(n, m | 0x38, op | 0x20, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
}

/* Generacion para modos de direccionamiento de control */
static void eadef_control(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;
	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
	main_ea = pcdp; idef(n, m | 0x3F, op | 0x3A, proc);
	main_ea = pcxd; idef(n, m | 0x3F, op | 0x3B, proc);
}

/* Generacion para modos de direccionamiento de control alterable */
static void eadef_control_alterable(int n, int m, int op, void(*proc)(void))
{
	if(stop_decode) return;
	main_ea = aind; idef(n, m | 0x38, op | 0x10, proc);
	main_ea = adsp; idef(n, m | 0x38, op | 0x28, proc);
	main_ea = axdp; idef(n, m | 0x38, op | 0x30, proc);
	main_ea = absw; idef(n, m | 0x3F, op | 0x38, proc);
	main_ea = absl; idef(n, m | 0x3F, op | 0x39, proc);
}

/* Generacion para modos de direccionamiento para instrucciones MOVE */
static void defmove(int majorop, int n)
{
	if(stop_decode) return;
	for(main_reg = 0; main_reg < 8; main_reg++)
	{
		word w = majorop | (main_reg << 9);
		main_dest_ea = dreg; eadef_all(n, 0xFFC0, 0x000 | w, i_move);
		main_dest_ea = aind; eadef_all(n, 0xFFC0, 0x080 | w, i_move);
		main_dest_ea = ainc; eadef_all(n, 0xFFC0, 0x0C0 | w, i_move);
		main_dest_ea = adec; eadef_all(n, 0xFFC0, 0x100 | w, i_move);
		main_dest_ea = adsp; eadef_all(n, 0xFFC0, 0x140 | w, i_move);
		main_dest_ea = axdp; eadef_all(n, 0xFFC0, 0x180 | w, i_move);
	}
	main_dest_ea = absw; eadef_all(n, 0xFFC0, 0x1C0 | majorop, i_move);
	main_dest_ea = absl; eadef_all(n, 0xFFC0, 0x3C0 | majorop, i_move);
}

/****************************************************************************************/
/* Bloques de descodificacion de instrucciones por bloques agrupados por el nibble alto */
/****************************************************************************************/

/* Bloque de decodificacion de codigo de operacion 0 */
static void decB0(int n)
{
	stop_decode = 0;

	for(sizedef = 0; sizedef < 3; sizedef++)
	{
		main_size = 1 << sizedef;
		eadef_data_alterable(n, 0xFFC0, 0x0000 | (sizedef << 6), i_ori);
		eadef_data_alterable(n, 0xFFC0, 0x0200 | (sizedef << 6), i_andi);
		eadef_data_alterable(n, 0xFFC0, 0x0400 | (sizedef << 6), i_subi);
		eadef_data_alterable(n, 0xFFC0, 0x0600 | (sizedef << 6), i_addi);
		eadef_data_alterable(n, 0xFFC0, 0x0A00 | (sizedef << 6), i_eori);
		eadef_data_alterable(n, 0xFFC0, 0x0C00 | (sizedef << 6), i_cmpi);
	}

	/* Operaciones de bit */
	/* BTST (main_cc 0) funciona con todos los modos de direccionamiento; el resto */
	/* modos de direccionamiento de alteracion de dato */
	for(main_cc = 0; main_cc < 4; main_cc++)
	{
		void (*eadef)(int n, int m, int op, void(*proc)(void)) =
			main_cc ? eadef_data_alterable : eadef_data;
		eadef(n, 0xFFC0, 0x0800 | (main_cc << 6), i_bitop_imm);
		for(main_reg = 0; main_reg < 8; main_reg++)
		{
			eadef(n, 0xFFC0, 0x0100 | (main_cc << 6) | (main_reg << 9),	i_bitop_reg);
		}
	}

	idef(n, 0xFFFF, 0x003C, i_ori_ccr );
	idef(n, 0xFFFF, 0x023C, i_andi_ccr);
	idef(n, 0xFFFF, 0x0A3C, i_eori_ccr);
	idef(n, 0xFFFF, 0x007C, i_ori_sr  );
	idef(n, 0xFFFF, 0x027C, i_andi_sr );
	idef(n, 0xFFFF, 0x0A7C, i_eori_sr );

	for(main_reg=0;main_reg<8;main_reg++)
	{
		for(main_size=WORD;main_size<=LONG;main_size+=2)
		{
			idef(n,0xFFF8,0x0108|((main_size&4)<<4)|(main_reg<<9),i_movep_mem2reg);
			idef(n,0xFFF8,0x0188|((main_size&4)<<4)|(main_reg<<9),i_movep_reg2mem);
		}
	}
}

/* Bloque de decodificacion de codigo de operacion 1 */
static void decB1(int n)
{
	stop_decode = 0;
	main_size = BYTE;
	defmove(0x1000, n);
}

/* Bloque de decodificacion de codigo de operacion 2 */
static void decB2(int n)
{
	stop_decode = 0;
	main_size = LONG;
	defmove(0x2000, n);

	for(main_reg = 0; main_reg < 8; main_reg++)
		eadef_all(n, 0xFFC0, 0x2040 | (main_reg << 9), i_movea);
}

/* Bloque de decodificacion de codigo de operacion 3 */
static void decB3(int n)
{
	stop_decode = 0;
	main_size = WORD;
	defmove(0x3000, n);

	for(main_reg = 0; main_reg < 8; main_reg++)
		eadef_all(n, 0xFFC0, 0x3040 | (main_reg << 9), i_movea);
}

/* Bloque de decodificacion de codigo de operacion 4 */
static void decB4(int n)
{
	stop_decode = 0;

	eadef_data_alterable(n, 0xFFC0, 0x40C0, i_move_from_sr);
	eadef_data(n, 0xFFC0, 0x44C0, i_move_to_ccr);
	eadef_data(n, 0xFFC0, 0x46C0, i_move_to_sr );
	eadef_control(n, 0xFFC0, 0x4EC0, i_jmp);
	eadef_control(n, 0xFFC0, 0x4E80, i_jsr);

	for(main_reg=0;main_reg<8;main_reg++)
		eadef_control(n,0xFFC0,0x41C0|(main_reg<<9),i_lea);

	main_size=WORD;

	for(main_reg=0;main_reg<8;main_reg++)
		eadef_data(n,0xFFC0,0x4180|(main_reg<<9),i_chk);

	eadef_control(n,0xFFC0,0x4840,i_pea);

	for(sizedef = 0; sizedef < 3; sizedef++)
	{
		main_size = 1 << sizedef;
		eadef_data_alterable(n, 0xFFC0, 0x4200 | (sizedef << 6), i_clr);
		eadef_data_alterable(n, 0xFFC0, 0x4A00 | (sizedef << 6), i_tst);
	}

	idef(n, 0xFFFF, 0x4E70, i_reset);
	idef(n, 0xFFFF, 0x4E71, i_nop);
	idef(n, 0xFFFF, 0x4E72, i_stop);
	idef(n, 0xFFFF, 0x4E73, i_rte);
	idef(n, 0xFFFF, 0x4E75, i_rts);
	idef(n, 0xFFFF, 0x4E76, i_trapv);
	idef(n, 0xFFFF, 0x4E77, i_rtr);

	main_dr=0;
	for (sizedef=0;sizedef<2;sizedef++)
	{
		main_size=1<<(sizedef+1);
		eadef_control_alterable(n,0xFFC0,0x4880|(main_dr<<10)|(sizedef<<6),i_movem_control);
	}

	main_dr=1;
	for(sizedef=0;sizedef<2;sizedef++)
	{
		main_size=1<<(sizedef+1);
		eadef_control (n,0xFFC0,0x4880|(main_dr<<10)|(sizedef<<6),i_movem_control);
	}

	for(sizedef = 0; sizedef < 2; sizedef++)
	{
		main_size = 1 << (sizedef + 1);
		idef(n, 0xFFF8, 0x4C98 | (sizedef << 6), i_movem_postinc);
		idef(n, 0xFFF8, 0x48A0 | (sizedef << 6), i_movem_predec);
	}

	idef(n, 0xFFF8, 0x4E50, i_link);
	idef(n, 0xFFF8, 0x4E58, i_unlk);
	idef(n, 0xFFF0, 0x4E40, i_trap);
	idef(n, 0xFFF8, 0x4E60, i_move_to_usp);
	idef(n, 0xFFF8, 0x4E68, i_move_from_usp);
	idef(n, 0xFFF8, 0x4840, i_swap);
	idef(n, 0xFFF8, 0x4880, i_extbw);
	idef(n, 0xFFF8, 0x48C0, i_extwl);

	for(sizedef = 0; sizedef < 3; sizedef++)
	{
		main_size = 1 << sizedef;
		eadef_data_alterable(n, 0xFFC0, 0x4000 | (sizedef << 6), i_negx);
		eadef_data_alterable(n, 0xFFC0, 0x4400 | (sizedef << 6), i_neg);
		eadef_data_alterable(n, 0xFFC0, 0x4600 | (sizedef << 6), i_not);
	}

	eadef_data_alterable(n, 0xFFC0, 0x4800, i_nbcd);
	eadef_data_alterable(n, 0xFFC0, 0x4AC0, i_tas);
	idef(n, 0xFFFF, 0x4AFA, i_illegal);
	idef(n, 0xFFFF, 0x4AFB, i_illegal);
	idef(n, 0xFFFF, 0x4AFC, i_illegal);
}

/* Bloque de decodificacion de codigo de operacion 5 */
static void decB5(int n)
{
	stop_decode = 0;

	for(sizedef = 0; sizedef < 3; sizedef++)
	{
		main_size = 1 << sizedef;
		for(main_qv = 0; main_qv < 8; main_qv++) {
			word w = (sizedef << 6) | (main_qv << 9);
			eadef_alterable_nobyteaddress(n, 0xFFC0, 0x5000 | w, i_addq);
			eadef_alterable_nobyteaddress(n, 0xFFC0, 0x5100 | w, i_subq);
		}
	}

	idef(n, 0xFFF8, 0x50C8, i_dbt);
	idef(n, 0xFFF8, 0x51C8, i_dbra);        /* DBF = DBRA */

	for(main_cc = 0x2; main_cc <= 0xF; main_cc++)
		idef(n, 0xFFF8, 0x50C8 | (main_cc << 8), i_dbcc);

	main_size = BYTE;
	for(main_cc = 0x0; main_cc <= 0xF; main_cc++)
		eadef_data_alterable(n, 0xFFC0, 0x50C0 | (main_cc << 8), i_scc);
}

/* Bloque de decodificacion de codigo de operacion 6 */
static void decB6(int n)
{
	stop_decode=0;

	idef(n,0x1FFFF,0x6000,i_bra_w);
	idef(n,0x1FFFF,0x6100,i_bsr_w);

	for(main_cc=0x2;main_cc<=0xF;main_cc++)
		idef(n,0x1FFFF,0x6000|(main_cc<<8),i_bcc_w);

	idef(n,0x0FF00,0x6000,i_bra_b);
	idef(n,0x0FF00,0x6100,i_bsr_b);

	for(main_cc=0x2;main_cc<=0xF;main_cc++)
		idef(n,0x0FF00,0x6000|(main_cc<<8),i_bcc_b);
}

/* Bloque de decodificacion de codigo de operacion 7 */
static void decB7(int n)
{
	stop_decode=0;

	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFF00,0x7000|(main_reg<<9),i_moveq);
}

/* Bloque de decodificacion de codigo de operacion 8 */
static void decB8(int n)
{
	stop_decode=0;

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_data (n,0xFFC0,0x8000|(main_reg<<9)|(sizedef<<6),i_or_dn);
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_memory_alterable (n,0xFFC0,0x8100|(main_reg<<9)|(sizedef<<6),i_or_ea);
	}

	for(main_cc=0;main_cc<2;main_cc++)
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_data(n,0xFFC0,0x80C0|(main_reg<<9)|(main_cc<<8),i_div);

	main_size=BYTE;

	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0x8100|(main_reg<<9),i_sbcd_dreg);

	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0x8108|(main_reg<<9),i_sbcd_adec);
}

/* Bloque de decodificacion de codigo de operacion 9 */
static void decB9(int n)
{
	stop_decode=0;

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_all_nobyteaddress(n,0xFFC0,0x9000|(main_reg<<9)|(sizedef<<6),i_sub_dn);
		}
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_memory_alterable (n,0xFFC0,0x9100|(main_reg<<9)|(sizedef<<6),i_sub_ea);
	}

	main_size=WORD;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0x90C0|(main_reg<<9),i_suba);

	main_size=LONG;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0x91C0|(main_reg<<9),i_suba);

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			idef(n,0xFFF8,0x9100|(main_reg<<9)|(sizedef<<6),i_subx_dreg);
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			idef(n,0xFFF8,0x9108|(main_reg<<9)|(sizedef<<6),i_subx_adec);
	}
}

/* Bloque de decodificacion de codigo de operacion A */
static void decBA(int n)
{
	stop_decode=0;

	idef(n,0xF000,0xA000,i_aline);
}

/* Bloque de decodificacion de codigo de operacion B */
static void decBB(int n)
{
	stop_decode=0;

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_all_nobyteaddress(n,0xFFC0,0xB000|(main_reg<<9)|(sizedef<<6),i_cmp_dn);
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_data_alterable (n,0xFFC0,0xB100|(main_reg<<9)|(sizedef<<6),i_eor_ea);
	}

	main_size=WORD;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0xB0C0|(main_reg<<9),i_cmpa);

	main_size=LONG;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0xB1C0|(main_reg<<9),i_cmpa);

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			idef(n,0xFFF8,0xB108|(sizedef<<6)|(main_reg<<9),i_cmpm);
	}
}

/* Bloque de decodificacion de codigo de operacion C */
static void decBC(int n)
{
	stop_decode=0;

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_data(n,0xFFC0,0xC000|(main_reg<<9)|(sizedef<<6),i_and_dn);
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_memory_alterable (n,0xFFC0,0xC100|(main_reg<<9)|(sizedef<<6),i_and_ea);
	}

	for(main_cc=0;main_cc<2;main_cc++)
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_data(n,0xFFC0,0xC0C0|(main_reg<<9)|(main_cc<<8),i_mul);

	main_dr=0;main_ir=0;
	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0xC140|(main_reg<<9),i_exg);

	main_dr=32;main_ir=32;
	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0xC148|(main_reg<<9),i_exg);

	main_dr=0;main_ir=32;
	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0xC188|(main_reg<<9),i_exg);

	main_size=BYTE;
	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0xC100|(main_reg<<9),i_abcd_dreg);

	for(main_reg=0;main_reg<8;main_reg++)
		idef(n,0xFFF8,0xC108|(main_reg<<9),i_abcd_adec);
}

/* Bloque de decodificacion de codigo de operacion D */
static void decBD(int n)
{
	stop_decode=0;

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_all_nobyteaddress(n,0xFFC0,0xD000|(main_reg<<9)|(sizedef<<6),i_add_dn);
	}
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			eadef_memory_alterable (n,0xFFC0,0xD100|(main_reg<<9)|(sizedef<<6),i_add_ea);
	}

	main_size=WORD;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0xD0C0|(main_reg<<9),i_adda);

	main_size=LONG;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0xD1C0|(main_reg<<9),i_adda);
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			idef(n,0xFFF8,0xD100|(main_reg<<9)|(sizedef<<6),i_addx_dreg);
	}
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			idef(n,0xFFF8,0xD108|(main_reg<<9)|(sizedef<<6),i_addx_adec);
	}
}

/* Bloque de decodificacion de codigo de operacion E */
static void decBE(int n)
{
	stop_decode=0;

	for(main_reg=0;main_reg<8;main_reg++)
	for(main_dr=0;main_dr<2;main_dr++)
	for(main_ir=0;main_ir<2;main_ir++)
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		idef(n,0xFFF8,0xE000|(main_reg<<9)|(main_dr<<8)|(sizedef<<6)|(main_ir<<5),i_asx_reg);
		idef(n,0xFFF8,0xE008|(main_reg<<9)|(main_dr<<8)|(sizedef<<6)|(main_ir<<5),i_lsx_reg);
		idef(n,0xFFF8,0xE010|(main_reg<<9)|(main_dr<<8)|(sizedef<<6)|(main_ir<<5),i_rxx_reg);
		idef(n,0xFFF8,0xE018|(main_reg<<9)|(main_dr<<8)|(sizedef<<6)|(main_ir<<5),i_rox_reg);
	}
	for(main_dr=0;main_dr<2;main_dr++)
	{
		eadef_memory_alterable(n,0xFFC0,0xE0C0|(main_dr<<8),i_asx_mem);
		eadef_memory_alterable(n,0xFFC0,0xE2C0|(main_dr<<8),i_lsx_mem);
		eadef_memory_alterable(n,0xFFC0,0xE4C0|(main_dr<<8),i_rxx_mem);
		eadef_memory_alterable(n,0xFFC0,0xE6C0|(main_dr<<8),i_rox_mem);
	}
}

/* Bloque de decodificacion de codigo de operacion F */
static void decBF(int n)
{
	stop_decode = 0;
	idef(n, 0xF000, 0xF000, i_fline);
}

/* Tabla principal de descodificacion de instrucciones */
static void (*(decodetable[16]))(int n) =
{decB0, decB1, decB2, decB3, decB4, decB5, decB6, decB7,
decB8, decB9, decBA, decBB, decBC, decBD, decBE, decBF};

/***************************************************************************/


/* Construccion de entradas de la tabla de saltos */
static void tableentry(int last, int rl)
{
	int i;

	if(last == -1)
		emit(".long r_illegal");
	else
		emit(".long %c%03X",((last >> 12) & 0xF) + 'K', last & 0xFFF);

	if(rl > 1)
	{
		for(i=0;i<rl-1;i++)
		{
			if(last == -1)
				emit(".long r_illegal");
			else
				emit(".long %c%03X",((last >> 12) & 0xF) + 'K', last & 0xFFF);
		}
	}
}

/***************************************************************/
/* Muestra cabecera de información general acerca del programa */
/***************************************************************/

void show_console_header(void)
{
	fprintf(stderr," ---------------------------------------------------\n");
	fprintf(stderr," Fast and Accurate Motorola 68000 Emulation Library\n");
	fprintf(stderr," FAME SH4 version %s\n",VERSION);
	fprintf(stderr," Emisor de codigo ensamblador de FAME\n");
	fprintf(stderr," Oscar Orallo Pelaez\n");
	fprintf(stderr," ---------------------------------------------------\n");
}

/*********************************************************/
/* Mostrar informacion de ayuda							 */
/*********************************************************/
void show_help(char *exec_name)
{
	show_console_header();
	fprintf(stderr," Uso: %s [opciones]\n\n",exec_name);
	fprintf(stderr," Opciones:\n\n");
	fprintf(stderr,"  -h          Mostrar ayuda (lo que estas leyendo)\n");
	fprintf(stderr,"  -ab32       Bus de direcciones de 32 bits (por defecto, 24)\n");
	fprintf(stderr,"  -nlt        No emular lecturas tontas (por defecto, ON)\n");
	fprintf(stderr,"  -ncnd       No emular comportamiento no documentado (por defecto, ON)\n");
	fprintf(stderr,"  -eum        Utilizar espacio unico de memoria (por defecto, multiple)\n");
	fprintf(stderr,"  -ne0        No emular excepciones del grupo 0 (por defecto, ON)\n");
	fprintf(stderr,"  -n [pref]   Usar [pref] como prefijo del nombre de las funciones de la API\n");
	fprintf(stderr,"  -ec         Atender IRQs sin ciclos de reloj restantes (por defecto, OFF)\n");
	fprintf(stderr,"  -net        Realizar calculo no preciso de ciclos de reloj (por defecto, OFF)\n");
	fprintf(stderr,"  -dm         Cachear descriptores de mapas de memoria (por defecto, OFF)\n");
	fprintf(stderr,"  -ncc        No realizar cuenta interna de ciclos de reloj (por defecto, ON)\n");
	fprintf(stderr,"  -nb0        No emular bit 0 de execinfo (por defecto, ON)\n");
	fprintf(stderr,"  -nt         No emular excepcion de traza (por defecto, ON)\n");
	fprintf(stderr,"  -nmb        No emular accesos en dos regiones de memoria (por defecto, ON)\n");
	fprintf(stderr,"  -nic        No contar ciclos de generacion de las IRQs (por defecto, ON)\n");
	fprintf(stderr,"  -cb         Chequear errores de direccion en saltos (por defecto, OFF)\n");    
}


/*********************************************************/
/* Muestra mensaje argumento no reconocido y la ayuda    */
/* Rompe la ejecucion del programa                       */
/*********************************************************/
void arg_no_reconocido(char *exec_name)
{
	/* ERROR: Argumento no reconocido */
	fprintf(stderr,"Argumento no reconocido...\n");
	show_help(exec_name);
	exit(EXIT_FAILURE);
}

void fprefix_no_encontrado(char *exec_name)
{
	/* ERROR: No se encuentra el prefijo en la linea de comandos */
	fprintf(stderr,"No se encuentra el prefijo...\n\n");
	show_help(exec_name);
	exit(EXIT_FAILURE);
}


/***********************/
/*  FUNCION PRINCIPAL  */
/***********************/

int main(int argc, char *argv[])
{
	int i, j, last, rl, bank, getof=0, getname=0;
	char *codefilename="fame.s";
	char *default_fprefix = "m68k";

	/* Opciones de generacion de codigo */
	for (i=1; i<argc; i++)
	{
		/* Obtener nombre de prefijo de funciones */
		if (getname)
		{
			fprefix = argv[i];
			if (!fprefix)
				fprefix_no_encontrado(argv[0]);
			else
			{
				getname = 0;
				continue;
			}
		}

		/* Tamano del bus de direcciones */
		if (!strcmp(argv[i],"-ab32"))
		{
			addr_bits = 32;
			continue;
		}

		/* Mostrar ayuda */
		if (!strcmp(argv[i],"-h"))
		{
			show_help(argv[0]);
			return 0;
		}

		/* Lecturas tontas */
		if (!strcmp(argv[i],"-nlt"))
		{
			dummyreads = 0;
			continue;
		}

		/* Emular comportamiento no documentado */
		if (!strcmp(argv[i],"-ncnd"))
		{
			emulate_undoc = 0;
			continue;
		}

		/* Espacio unico de memoria */
		if (!strcmp(argv[i],"-eum"))
		{
			multiaddr = 0;
			continue;
		}

		/* Emular excepciones de nivel 0 */
		if (!strcmp(argv[i],"-ne0"))
		{
			emulate_group_0 = 0;
			continue;
		}

		/* Prefijo de funciones */
		if (!strcmp(argv[i],"-n"))
		{
			getname=1;
			continue;
		}

		/* Realizar calculo de ciclos no preciso */
		if (!strcmp(argv[i],"-net"))
		{
			exact_timing = 0;
			continue;
		}

		/* Usar mapas de memoria directos (caches) */
		if (!strcmp(argv[i],"-dm"))
		{
			direct_mapping = 1;
			continue;
		}

		/* No realizar cuenta interna de ciclos de reloj */
		if (!strcmp(argv[i],"-ncc"))
		{
			cycles_counting = 0;
			continue;
		}

		/* No emular bit 0 de execinfo */
		if (!strcmp(argv[i],"-nb0"))
		{
			bit0_execinfo = 0;
			continue;
		}

		/* No emular excepcion de traza */
		if (!strcmp(argv[i],"-nt"))
		{
			emulate_trace = 0;
			continue;
		}

		/* Emular acceso a dos bancos de memoria en una sola operacion */
		if (!strcmp(argv[i],"-nmb"))
		{
			multi_bank = 0;
			continue;
		}

		/* No emular ciclos de generacion de las IRQs */
		if (!strcmp(argv[i],"-nic"))
		{
			irq_cycles = 0;
			continue;
		}

		/* Comprobar saltos (errores de direccion) */
		if (!strcmp(argv[i],"-cb"))
		{
			check_branches = 1;
			continue;
		}

		arg_no_reconocido(argv[0]);
	}

	/* Prefijo de nombre de las funciones por defecto */
	if (fprefix == NULL) fprefix = default_fprefix;

	/* Mostrar informacion acerca de la generacion de codigo */
	show_console_header();
	code_generation_info(stderr);

	/* Abrir fichero ensamblador */
	fp = fopen(codefilename, "w");
	if(!fp)
	{
		perror(codefilename);
		return 1;
	}

	gen_man_code();
	for(i=0; i<0x10000; i++) rproc[i] = -1;

	/* Descodificacion de instrucciones */
	for(bank = 0; bank <= 0xF; bank++)
	{
		int bankend = (bank + 1) << 12;
		void (*decoderoutine)(int n) = decodetable[bank];
		for(i = bank << 12; i < bankend; i++) decoderoutine(i);
	}

	/* Generar espacio de memoria para tabla de instrucciones */
	emit(".data");
	align(5);

	last = -1;
	rl = 0x100;

	/* Generacion de tabla comprimida */
	for(i = 0x8000; i < 0x10000; i++)
	{
		j = rproc[i];
		if(j == last)
		{
			if(rl == 256)
			{
				tableentry(last, rl);
				rl = 1;
			}
			else
			{
				rl++;
			}
		}
		else
		{
			if(rl)
				tableentry(last, rl);
			rl = 1;
			last = j;
		}
	}
	tableentry(last, rl);

	emit("jmptbl:");
	last = -2;
	rl = 0;

	for(i = 0; i < 0x8000; i++)
	{
		j = rproc[i];
		if(j == last)
		{
			if(rl == 256)
			{
				tableentry(last, rl);
				rl = 1;
			}
			else
			{
				rl++;
			}
		}
		else
		{
			if(rl)
				tableentry(last, rl);
			rl = 1;
			last = j;
		}
	}
	fclose(fp);    /* Cerrar fichero de salida */
	return 0;
}
