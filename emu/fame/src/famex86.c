/****************************************************************************/
/* FAME (Fast and Accurate Motorola 68000 Emulation Library)                */
/* Emulador de 68000 para PC de 32 bits                                     */
/* Emisor de ensamblador (NASM)                                             */
/* Autor: Oscar Orallo Pelaez                                               */
/* Fecha de comienzo: 02-08-2002                                            */
/* Ultima actualizacion: 16-02-2006                                         */
/* Based on the excellent Starscream emulator by Neill Corlett              */
/****************************************************************************/
/****************************************************************************/
/* USO DE REGISTROS X86                                                     */
/*                                                                          */
/* A continuacion se detalla el uso de los registros en el emisor.          */
/* Los registros EAX y EDX pueden ser utilizados para datos temporales.     */
/*                                                                          */
/* EAX = registro de banderas (CCR con estructura banderas en 80x86)        */
/* EAX[0] = bandera V                                                       */
/* EAX[1-7] = deben estar todos los bits a 0                                */
/* EAX[8] = bandera C                                                       */
/* EAX[14] = bandera Z                                                      */
/* EAX[15] = bandera N                                                      */
/* EAX[16-31] = indefinidos                                                 */
/* EBX[0-15] = instruction actual o numero de registro                      */
/* ECX = dato primario                                                      */
/* EDX = direccion primaria                                                 */
/* EBP = desplazamiento base del PC                                         */
/* ESI = PC incluyendo la base                                              */
/* EDI = contador de ciclos de reloj                                        */
/****************************************************************************/
/****************************************************************************/
/* execinfo (informacion acerca de la ejecución de la CPU)                  */
/* bit 0 -> 1=CPU running; 0=cpu idle                                       */
/* bit 1 -> si se emulan excepciones GRUPO 0 -> 1=procesando excep. grupo 0 */
/*          si no se emulan -> 1=PC fuera de limites                        */
/* bit 2 -> si se emulan excepciones grupo 0 -> 1=doble error de bus        */
/* bit 3 -> modo traza pendiente de atencion                                */
/* bit 4 -> atendiendo excepcion de modo traza                              */
/* bit 5 -> atendiendo error de bus                                         */
/* bit 6 -> atendiendo error de direccion                                   */
/* bit 7 -> 0 = CPU not stopped; 1 = CPU stopped (STOP instruction)         */
/* bit 8 -> atendiendo IRQ                                                  */
/* bits [8-15] -> sin usar                                                  */
/****************************************************************************/
/****************************************************************************/
/* REVISION 26/10/2004                                                      */
/*                                                                          */
/* - Corregido error en el calculo de la base del PC en basefunction.       */
/* - Corregido error en la funcion upset_ccr, no se hacia bien la mascara   */
/*   en las banderas.                                                       */
/* - Corregida instruccion JSR: se ensucia ECX al realizar cambio de region */
/*   en basefunction.                                                       */
/* - En el HLE se resta la base del pc para luego hacer el get_new_pc.      */
/* - Interrupt ack corregido el nivel de interrupcion como parametro.       */
/* - Funcion set_context corregida en la fijacion del registro de estado.   */
/*                                                                          */
/* REVISION 21/09/2004                                                      */
/*                                                                          */
/* - Generacion de interrupt acknowledge corregida. Agregadas las funciones */
/*   core_exit y core_enter a la llamada.                                   */
/*                                                                          */
/* REVISION 18/08/2004                                                      */
/*                                                                          */
/* - Corregido un error en activacion de la bandera N en instruccion CHK.   */
/*                                                                          */
/* REVISION 28/05/2004                                                      */
/*                                                                          */
/* - Corregido un detalle en el bit de estado parado (instruccion STOP)     */
/*   que cuando se activa una interrupcion solo se resetea el bit en caso   */
/*   de que sea de mayor nivel que el PPL actual. En procesadores           */
/*   posteriores al 68000 tambien es necesario consultar los bits de traza  */
/* - Retocada la funcion STOP. Sale de emulate sin perder los ciclos que se */
/*   habian ejecutado.                                                      */
/* - Retocado ligeramente el codigo en instrucciones BRA para evitar tener  */
/*   que limpiar el registro EBX tras carga extendida.                      */
/*                                                                          */
/* REVISION 21/04/2004                                                      */
/*                                                                          */
/* - Agregadas las funciones add_cycles y release_cycles.                   */
/*                                                                          */
/* REVISION 19/03/2004                                                      */
/*                                                                          */
/* - Modificado el codigo de las instrucciones DIV y MUL. En la instruccion */
/*   MUL se ha adoptado una tabla de precalculo para los ciclos de reloj    */
/*   variables dependientes de la EA.                                       */
/*                                                                          */
/* REVISION 02/03/2004                                                      */
/*                                                                          */
/* - Mejorado el codigo de entrada/salida (emulate).                        */
/*                                                                          */
/* REVISION 13/02/2004                                                      */
/*                                                                          */
/* - Modificado el sistema de cache de regiones de programa.                */
/* - Modificado el codigo de gen_basefunction. ESI se enmascara a los bits  */
/*   de dirección, por lo que no tiene porque permanecer intacto.           */
/*                                                                          */
/* REVISION 17/12/2003                                                      */
/*                                                                          */
/* - Modificados los accesos a memoria: Implementación de ptr. a las listas */
/*   de regiones mediante banking. Esto supone una mejora de velocidad      */
/*   respecto a la búsqueda lineal de la región más notable a mayor número  */
/*   de regiones.                                                           */
/*                                                                          */
/* REVISION 12/11/2003                                                      */
/*                                                                          */
/* - Reescritura del CCR optimizada (en codigo de entrada/salida y en       */
/*   funcion ccr2cl). La mejora se estima en un 5% de rendimiento.          */
/*                                                                          */
/* REVISION 30/09/2003                                                      */
/*                                                                          */
/* - El cache del CCR ha sido optimizado. Se estima haber mejorado el       */
/* rendimiento de esta operación en un 20% aproximadamente.                 */
/*                                                                          */
/* Funcion fetch:                                                           */
/* - Modificada ligeramente en instrucciones "mov". Mínimo aumento de       */
/*   velocidad.                                                             */
/*                                                                          */
/* REVISION 23/05/2003                                                      */
/*                                                                          */
/* Modificado el formato de los argumentos en la linea de comandos          */
/* para los formatos de generacion. Ahora es: "-f x" donde x es uno de los  */
/* valores siguientes:                                                      */
/*                                                                          */
/*  - OBJ: Codigo objeto para compiladores de Borland                       */
/*  - ELF: Codigo objeto para compiladores de Linux                         */
/*  - WIN32: Codigo objeto para compiladores Microsoft                      */
/*                                                                          */
/* el argumento -so genera codigo para crear una Shared Library de Linux    */
/*                                                                          */
/* REVISION 16/05/2003:                                                     */
/*                                                                          */
/* Agregada la opcion para generar codigo ELF (para Linux)                  */
/* Se han modificado los argumentos de la linea de comandos (-fb, -fe)      */
/*                                                                          */
/* REVISION 23/02/2003:                                                     */
/*                                                                          */
/* Eliminado el salvado del contenido de los registros ECX y EDX en la      */
/* funcion emulate                                                          */
/*                                                                          */
/* REVISION 24/11/2002:                                                     */
/*                                                                          */
/*  Funcion fetch:                                                          */
/*  - Se incremento la velocidad de acceso añadiendo un vector para acceder */
/*  a las zonas de memoria mas rapidamente. Asi, el codigo mejoro           */
/*  notablemente, aunque todavia no esta del todo optimizado.               */
/*                                                                          */
/*  Accesos a memoria built-in:                                             */
/*  - Por fin solucionado el control de acceso a memoria en los limites     */
/*  para datos de tamaño byte.                                              */
/****************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>

/* Version del emisor */
#define VERSION "2.0a (14-03-2006)"

/* Tamaño de datos */
#define BYTE 1
#define WORD 2
#define LONG 4

/* Tipos de acceso a memoria (programa, datos y modo de CPU) */
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

/* Definición de tipos básicos */
typedef unsigned char  byte;
typedef unsigned short word;
typedef unsigned int   dword;

/* Constantes auxiliares */
static char *x86ax   [5] = {"?", "al"  , "ax"  , "?", "eax"  };
static char *x86bx   [5] = {"?", "bl"  , "bx"  , "?", "ebx"  };
static char *x86cx   [5] = {"?", "cl"  , "cx"  , "?", "ecx"  };
static char *x86dx   [5] = {"?", "dl"  , "dx"  , "?", "edx"  };
static char *sizename[5] = {"?", "byte", "word", "?", "dword"};
static int quickvalue[8] = {8, 1, 2, 3, 4, 5, 6, 7};
static char direction[2] = {'r','l'};

/* Fichero de salida */
static FILE *fp;

/* Numero de linea para la generación de etiquetas */
static int linetag;

/**********************************************/
/* Variables modificadoras del código emitido */
/**********************************************/

/* Ensamblado para entornos de desarrollo Borland */
static int borland=0;

/* Ensamblado en formato ELF (Linux) */
static int elf=0;

/* Generacion de ELF Shared Library (Linux) */
static int elfso=0;

/* Esta opcion genera el bucle de extracción y descodificación en línea */
static int inline_fd_loop=0;

/* Ancho en bits del bus de direcciones */
static int addr_bits=24;

/* Lecturas dummy */
static int dummyreads=1;

/* Emular comportamiento no documentado */
/* Banderas en instrucciones */
/* ABCD (N y V), SBCD (N y V), NBCD (N y V) y CHK (Z, V y C) */
static int emulate_undoc=1;

/* Emular las excepciones de nivel 0 */
/* error de bus, error de direccion y doble error de bus/direccion */
static int emulate_group_0=1;

/* Espacio de memoria multiple: usuario y supervisor */
static int multiaddr=1;

/* Convencion de llamada por la pila */
static int stack_calling=1;

/* Realizar calculo preciso de ciclos de reloj */
static int exact_timing=1;

/* Prefijo de los nombres de funcion */
static char *fprefix=NULL;

/* Emular excepcion de traza */
static int emulate_trace=1;

/* Contar ciclos empleados en generacion IRQ */
static int irq_cycles=1;

/* Estado bit0 de execinfo (estado de ejecucion de la CPU) */
static int bit0_execinfo=1;

/* Contador interno de ciclos de reloj */
static int cycles_counting=1;

/* Cacheo de mapas de memoria (aumenta la velocidad y el consumo de memoria) */
static int direct_mapping=0;


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

/***********************************************************/
/* Tablas con los ciclos de reloj para la instruccion MOVE */
/***********************************************************/

/* Tamaño BYTE y WORD */
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

/* Tamaño LONG */
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
static enum eamode main_ea;   /* Modo fuente de direccionamiento efectivo */
static enum eamode main_dest_ea; /* Modo destino de direccionamiento efectivo */
static int main_size;             /* Tamaño del operando (BYTE(1), WORD(2) o LONG(4)) */
static int sizedef;               /* Tamaño de campo en la instrucción */
static int main_reg;              /* Número de registro */
static int main_cc;               /* Código de condición (0-F) */
static int main_dr;               /* Direccion (derecha o izquierda) */
static int main_ir;               /* Inmediato o registro (para desplazamientos de bit) */
static int main_qv;               /* Usado para la carga de valores inmediatos de direccionamiento */

/************************************************************************/
/* Prototipos de funcion                                                */
/************************************************************************/

/* Calcula el nuevo PC con la base */
void get_new_pc(void);

/* Incrementar puntero a opcodes */
/* El tamaño del opcode es de 16 bits (2 bytes) */
static void inc_ptr_opcodes(void);

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

/* Imprime la informacion relacionada con el código generado */
void code_generation_info(FILE *stream)
{
	char cs[2];

	strcpy(cs,(stream == stderr)?"":";");

	fprintf(stream,"%s Opciones de generacion empleadas:\n",cs);
	fprintf(stream,"%s - Formato de generacion",cs);

	/* Formato de generacion */
	if (borland)
		fprintf(stream," OMF (compiladores Borland)\n");
	else if (elf)
		fprintf(stream," ELF %s(Linux)\n",(elfso)?"Shared Library ":"");
	else
		fprintf(stream," WIN32 (compiladores Microsoft)\n");

	/* Convencion de llamada */
	fprintf(stream,"%s - Convencion de llamada por ",cs);
	if (stack_calling)
		fprintf(stream,"la pila\n");
	else
		fprintf(stream,"registro\n");

	/* Bucle de extraccion-descodificación en línea */
	fprintf(stream,"%s - Optimizacion de ",cs);
	if (inline_fd_loop)
		fprintf(stream,"velocidad (codigo en linea)\n");
	else
		fprintf(stream,"tamano (codigo no alineado)\n");

	/* Ancho en bits del bus de direcciones */
	fprintf(stream,"%s - Bus de direcciones de %d bits\n",cs,addr_bits);

	/* Emulacion de lecturas tontas */
	fprintf(stream,"%s - Emulacion de lecturas tontas ",cs);
	if (dummyreads)
		fprintf(stream,"(ON)\n");
	else
		fprintf(stream,"(OFF)\n");

	/* Emular comportamiento no documentado */
	fprintf(stream,"%s - Emulacion de comportamiento no documentado ",cs);
	if (emulate_undoc)
		fprintf(stream,"(ON)\n");
	else
		fprintf(stream,"(OFF)\n");

	/* Espacio de memoria */
	fprintf(stream,"%s - Espacio de memoria ",cs);
	if (multiaddr)
		fprintf(stream,"multiple (usuario y supervisor)\n");
	else
		fprintf(stream,"unico (supervisor)\n");

	/* Emulacion de excepciones de nivel 0 */
	fprintf(stream,"%s - Emulacion de excepciones del grupo 0 ",cs);
	if (emulate_group_0)
		fprintf(stream,"(ON)\n");
	else
		fprintf(stream,"(OFF)\n");

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

	/* Emular bit 0 de execinfo (bit ejecucion) */
	fprintf(stream,"%s - Emular bit 0 de execinfo ",cs);
	write_opt(bit0_execinfo,stream);

	/* Emular excepcion de traza */
	fprintf(stream,"%s - Emular excepcion de traza ",cs);
	write_opt(emulate_trace,stream);

	/* No contar ciclos de generacion de las IRQs */
	fprintf(stream,"%s - Contar ciclos de generacion de las IRQs ",cs);
	write_opt(irq_cycles,stream);

	fprintf(stream,"%s --------------------------------------------------\n",cs);
}

/* Imprime cabecera del fichero ensamblador */
static void gen_header(void)
{
	emit("; --------------------------------------------------");
	emit("; Fast and Accurate Motorola 68000 Emulation Library");
	emit("; FAME x86 version %s",VERSION);
	emit("; Oscar Orallo Pelaez");
	emit("; Assembly file generated on "__DATE__" "__TIME__"");
	emit("; --------------------------------------------------");
	code_generation_info(fp);
}

/* Alinear memoria */
/* Reserva los bytes necesarios para alinear a n bytes */
static void align(int n)
{
	emit("times ($$-$)&%d db 0", n - 1);
}

/* Enmascara direccion a 24 bits */
static void maskaddress(char *reg)
{
	if (addr_bits < 32)
		emit("and %s,%d", reg, (1 << addr_bits) - 1);
}

/* Generar cabeceras de funciones exportables */
static void gen_proc_header(char* name)
{
	if (elf)
	{
		emit("global %s_%s%s", fprefix, name, (elfso)?":function":"");
		emit("%s_%s:", fprefix, name);
	}
	else
	{
		emit("global _%s_%s", fprefix, name);
		emit("global %s_%s_", fprefix, name);
		emit("_%s_%s:", fprefix, name);
		emit("%s_%s_:", fprefix, name);
	}
}

/* Generar variables: Contexto del procesador y variables de estado y condicion */
static void gen_vars(void)
{
	emit_il("section .data");
	if (borland)
		emit(" public align=4 class=DATA use32");
	else
		emit_il("\n");

	emit("global _m68kcontext");
	align(8);
	emit("_m68kcontext:");
	emit("contextbegin:");                    /* Comienzo de contexto 68k */

    /* Mapa de memoria en uso */
    emit("__fetch                dd 0");/* Puntero a zona de programa */
    emit("__readbyte             dd 0");/* Puntero a lectura de byte */
    emit("__readword             dd 0");/* Puntero a lectura de word */
    emit("__writebyte            dd 0");/* Puntero a escritura de byte */
    emit("__writeword            dd 0");/* Puntero a escritura de word */
    /* Mapa de supervisor */
    emit("__s_fetch              dd 0");/* Puntero a zona de programa supervisor */
    emit("__s_readbyte           dd 0");/* Puntero a lectura de byte supervisor */
    emit("__s_readword           dd 0");/* Puntero a lectura de word supervisor */
    emit("__s_writebyte          dd 0");/* Puntero a escritura de byte supervisor */
    emit("__s_writeword          dd 0");/* Puntero a escritura de word supervisor */
    /* Mapa de usuario */
    emit("__u_fetch              dd 0");/* Puntero a zona de programa usuario */
    emit("__u_readbyte           dd 0");/* Puntero a lectura de byte usuario */
    emit("__u_readword           dd 0");/* Puntero a lectura de word usuario */
    emit("__u_writebyte          dd 0");/* Puntero a escritura de byte usuario */
    emit("__u_writeword          dd 0");/* Puntero a escritura de word usuario */

    emit("__resethandler         dd 0");/* Manejador del reset */
    emit("__iackhandler          dd 0");/* Manejador del interrupt acknowledge */

    emit("__icusthandler         dd 0");/* Puntero a tabla de manejadores de interrupciones/excepciones */
    emit("__reg:");                     /* Zona de registros 68k */
    emit("__dreg                 dd 0,0,0,0,0,0,0,0");/* Registros de datos */
    emit("__areg                 dd 0,0,0,0,0,0,0");/* Registros de direcciones */
    emit("__a7                   dd 0");/* Puntero de pila SSP-USP */
    emit("__asp                  dd 0");/* Puntero de pila auxiliar */
    emit("__pc                   dd 0");/* Contador de programa */
    emit("__cycles_counter       dd 0");/* Contador de ciclos ejecutados */
    emit("__interrupts           db 0,0,0,0,0,0,0,0");/* Tabla de control de interrupciones */
    emit("__sr                   dw 0");/* Registro de estado BS+CCR */
	emit("__execinfo             dw 0");/* Variable que contiene el estado de ejecucion */

	emit("contextend:");                /* Fin de contexto */
	emit("__cycles_needed        dd 0");/* Ciclos de ejecucion requeridos */

	emit("__fetch_bank           dw 0");/* Fetch banking cache */
	emit("__xflag                db 0");/* Variable de Bandera X */
	if (emulate_group_0) {
		emit("__g0_spec_info     db 0");/* Informacion relativa a las excep. grupo 0 */
	} else
		emit("__filler           db 0");/* Relleno alineamiento */
	emit("__io_cycle_counter     dd -1");/* Contador de ciclos (temporal) */
	emit("__io_fetchbase         dd 0");/* Base del mapa de memoria (temporal) */
	emit("__io_fetchbased_pc     dd 0");/* PC con la base (temporal) */
	emit("__access_address       dd 0");/* Direccion de acceso a memoria (temporal) */
    emit("__tmp_int_level        dd 0");/* Variable temporal del nivel de interrupción */

	/* Vector de punteros para acceso directo a datos para uso funcion fetch */
	emit("__fetch_vector         dd __sfmhtbl, __srwmhtbl, __ufmhtbl, __urwmhtbl");
	emit("__fetch_idx            dd 0"); /* Indice para accesos a programa */
	emit("__readbyte_idx         dd 0"); /* Indice para lectura de byte */
	emit("__readword_idx         dd 0"); /* Indice para lectura de word */
	emit("__writebyte_idx        dd 0"); /* Indice para escritura de byte */
	emit("__writeword_idx        dd 0"); /* Indice para escritura de word */

	if (emulate_group_0) {
		/* Puntero utilizado en la gestión de excepciones grupo 0 */
		emit("__excep_ptr        dd 0");
		emit("__inst_reg         dw 0");
		emit("__filler2          dw 0");
	}
	/* Tabla contadora de bits para las instrucciones MULU y MULS */
	emit("__cb_table       db 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,4,5,5,6,5,6,6,7,5,6,6,7,6,7,7,8");
}

/* Esta rutina permite cambiar el ambito de ejecucion de ASM -> C */
/* Guarda datos alojados durante la ejecucion en variables destinadas a tal efecto */
static void core_exit(void)
{
    /* Guardar datos en registros en variables y en la pila */
	emit("mov [__io_cycle_counter],edi");
	emit("mov [__io_fetchbase],ebp");
	emit("mov [__io_fetchbased_pc],esi");
	emit("push ebx");
	emit("push eax");
}

/* Esta rutina permite cambiar el ambito de ejecucion de C -> ASM */
static void core_enter(void)
{
	emit("pop eax");
	emit("pop ebx");
    /* Recuperar datos en variables a los registros adecuados */
	emit("mov edi,[__io_cycle_counter]");
	emit("mov ebp,[__io_fetchbase]");
	emit("mov esi,[__io_fetchbased_pc]");
}

/* Espacio de variables en la pila durante el cambio de ambito */
enum { airlock_stacksize = 8 };

/* Carga el opcode de la memoria segun endianness */
/* e incrementa el ptr de los opcodes */
static void load_opcode(void)
{
	emit("mov bx,[esi]");
	inc_ptr_opcodes();
}

/* Cargar falso CCR (AX) desde org y fija la bandera X */
/* org no se modifica */
static void load_ccr_from(char *org)
{
    emit("mov al,%s",org);  /* leer CCR -> AL */                   /* ???????????XNZVC */
    emit("shl ax,6");       /* desplazar AX */                     /* ?????XNZVC000000 */
    emit("shl ah,5");       /* desplazar AH */                     /* XNZ00000VC000000 */
    emit("sets [__xflag]"); /* almacenar bandera X (signo AH) */
    emit("shr al,7");       /* desplazar AL */                     /* XNZ000000000000V acarreo */
    emit("adc ah,ah");      /* añadir C, X -> bandera O x86 */     /* NZ00000C0000000V */
}

/* Rebuild CCR from a false CCR register */
/* Register oriented only! */
/* rgi = x86 register initial character; i.e. AX=a, BX=b and so on */
/* Genera el CCR en la parte baja del registro */
static void upset_ccr_from(char rgi)
{
	emit("btr %cx,8",rgi);        /* bandera C -> acarreo x86 */       /* NZ?????00000000V acarreo */
	emit("adc %cl,%cl",rgi,rgi);  /* añadir C despues de V  */         /* NZ?????0000000VC */
	emit("or %ch,[__xflag]",rgi); /* cargar bandera X */               /* NZ00000X000000VC */
	emit("rol %ch,4",rgi);        /* colocar XNZ */                    /* 000XNZ00000000VC */
	emit("and %ch,1Ch",rgi);      /* aislar banderas XNZ */
	emit("or %cl,%ch",rgi,rgi);   /* todas las banderas juntas */      /* 000XNZ00000XNZVC */
}

/* Cargar CCR en AX */
static void cache_ccr(void)
{
    load_ccr_from("[__sr]");      /* Carga falso CCR desde CCR */
}

/* Restaurar CCR con valor de AX */
/* AX se modifica */
static void writeback_ccr(void)
{
	upset_ccr_from('a');
	emit("mov [__sr],al");        /* almacenar el resultado */
}

/* Forzar cambio de contexto */
static void force_context_switch(void)
{
	emit("sub edi,[__cycles_needed]");
	emit("mov dword[__cycles_needed],0");
}

/* Incrementar puntero a opcodes */
/* El tamaño del opcode es de 16 bits (2 bytes) */
static void inc_ptr_opcodes(void)
{
	emit("add esi,byte 2");
}

/* Intercambiar los ptrs de pila */
static void swap_sps(void)
{
	emit("mov ecx,[__a7]");
	emit("xchg ecx,[__asp]");
	emit("mov [__a7],ecx");
}

/* Copiar mapa de memoria supervisor o usuario a mapa en uso */
static void set_memory_map(char *map)
{
	if (!multiaddr) return;		/* salir si es espacio unico de memoria */
	
	emit("mov [__fetch_idx],dword __%sfmhtbl",map);
	emit("mov [__readbyte_idx],dword __%srbmhtbl",map);
	emit("mov [__readword_idx],dword __%srwmhtbl",map);
	emit("mov [__writebyte_idx],dword __%swbmhtbl",map);
	emit("mov [__writeword_idx],dword __%swwmhtbl",map);	
}

/* Fija el mapa de memoria supervisor */
static void set_supervisor_memory_map(void)
{
	emit("mov [__fetch_idx],dword __sfmhtbl");
	emit("mov [__readbyte_idx],dword __srbmhtbl");
	emit("mov [__readword_idx],dword __srwmhtbl");
	emit("mov [__writebyte_idx],dword __swbmhtbl");
	emit("mov [__writeword_idx],dword __swwmhtbl");
}

/* Cache de interrupts */
static void pending_int_cache(void)
{
	emit("movsx cx,byte [__interrupts]"); /* Con extension, bit7=1 -> bit15=1 -> NMI > PPL siempre */
	emit("or cl,1");                      /* Poner bit 0 a 1 para asegurarse de que exista un bit a 1 en CX */
	emit("bsr cx,cx");                    /* Posicion del 1er bit comenzando izq. de CX en CX */
	emit("mov byte[__pending_int_level],cl");
}

/* Chequea el estado de las interrupciones y las manda atender si necesario */
static void interrupt_chk(void)
{
	/* Chequear PPL */
	emit("movsx cx,byte [__interrupts]"); /* Con extension, bit7=1 -> bit15=1 -> NMI > PPL siempre */
	emit("or cl,1");                      /* Poner bit 0 a 1 para asegurarse de que exista un bit a 1 en CX */
	emit("bsr cx,cx");                    /* Posicion del 1er bit comenzando izq. de CX en CX */
	emit("mov ch,cl");                    /* Cargar posicion en ch */
	emit("mov cl,[__sr+1]");              /* Cargar Byte del Sistema en CH */
	emit("and cl,7");                     /* Enmascarar nivel de interrupcion CPU (PPL) */
	emit("cmp ch,cl");
	emit("ja flush_int");
}


/* Realiza el cache de acceso a los mapas de memoria */
/* tp = table pointer; mm = memory map; rs = region size */
static void cache_memory_map(char *tp, char *mm, int rs)
{
	static int ln=0;
	
	emit("mov edx,%s",tp);     /* Inicio de la tabla de indices */
	emit("mov eax,[%s]",mm);   /* Ptr. a la lista de regiones */
	
	emit(".begincmm%d:",ln);
	emit("cmp dword [eax],byte -1");   /* fin de la lista */
	emit("je short .endcmm%d",ln);
	
	emit("mov esi,[eax]");        /* ESI = direccion baja de la region */
	emit("mov ecx,[eax+4]");      /* ECX = direccion alta de la region */
	emit("shr esi,12");
	emit("shr ecx,12");           /* coger 12 bits mas altos */
	emit("sub ecx,esi");          
	emit("inc ecx");              /* ECX = nº de bancos */
	emit("shl esi,2");
	emit("mov edi,edx");          /* direccion inicial de la tabla */
	emit("add edi,esi");          /* sumar primer banco a cachear */
	emit("rep stosd");            /* Copiar indice en la tabla */
	emit("add eax,byte %d",rs);   /* a la siguiente estructura */
	emit("jmp short .begincmm%d",ln);

	emit(".endcmm%d:",ln++);
}

/***************************************************************************/
/***************************************************************************/
/* m68k_init()                                                             */
/* Debe ser llamado para inicializar la tabla de saltos de instruccion     */
/* No recibe parametros y no devuelve nada                                 */
/***************************************************************************/
static void gen_init(void)
{
	gen_proc_header("init");
	/********************************************/
	/* Proceso de inicializacion de la libreria */
	/********************************************/
	emit("push esi");
	emit("push edi");
	emit("mov edi,__jmptbl");         /* Cargar en EDI el comienzo de la tabla */
	emit("mov esi,__jmptblcomp");     /* Cargar en ESI el comienzo de la tabla comprimida */
	emit(".decomp:");                 /* Comienzo de la descompresion */
	emit("lodsd");                    /* Cargar doble palabra */
   	emit("mov ecx,eax");              /* Guardar direccion en ECX */
	emit("and eax,0FFFFFFh");         /* Enmascarar dato a 24 bits */
	emit("shr ecx,24");               /* Calcular byte alto de la direccion en ECX: numero de bancos */
	emit("add eax,top");              /* Añade a la direccion el top */
	emit("inc ecx");
	emit(".jloop:");
	emit("mov [edi],eax");            /* Guardar direccion en la tabla */
	emit("add edi,byte 4");           /* Apuntar al siguiente dword */
	emit("dec ecx");                  /* Decrementa el valor de banco de memoria */
	emit("jnz short .jloop");         /* Si hay mas, seguir */
	emit("cmp edi,__jmptbl+262144");  /* Si no es el final, */
	emit("jne short .decomp");        /* continuar la descompresion */
	emit("pop edi");
	emit("pop esi");
	emit("xor eax,eax");              /* EAX = 0 */
	emit("ret");
}

/***************************************************************************/
/* m68k_emulate()                                                          */
/* Parametros: Numero de ciclos a ejecutar                                 */
/* Retorno: Exito de la operación                                          */
/*          0  La operacion se ha realizado satisfactoriamente             */
/*          -1 La CPU esta detenida debido a un ERROR DE BUS DOBLE (linea) *
/*             El PC ha salido de los limites (bucle no en linea)          */
/***************************************************************************/
static void gen_emulate(void)
{
	gen_proc_header("emulate");

	if (emulate_group_0)
	{
		emit("test byte[__execinfo],4");  /* Comprobar estado CPU */
		emit("jz short .cpuok");

	    /* La CPU esta detenida de forma irreversible -> DOBLE ERROR BUS/DIRECCION */
		/* Solo se recuperara mediante RESET EXTERNO */
		emit("or eax,-1");				  /* Codigo de retorno CPU detenida */
		emit("ret");

		emit(".cpuok:");
	}

	if (stack_calling)
		emit("mov eax,[esp+4]");          /* Parametro: ciclos a ejecutar */

	emit("test byte[__execinfo],80h");    /* Comprobar si estado parado */
	emit("jz short .notstopped");

	emit("add [__cycles_counter],eax");   /* Añadir a cycles_counter ciclos requeridos por el usuario */
	emit("xor eax,eax");				  /* Codigo de retorno exitoso (EAX = 0) */
	emit("ret");                          /* devolver puesto que la CPU esta parada */

	emit(".notstopped:");                 /* CPU no esta detenida, comenzar ejecucion */

	/* Salvado de registros */
	/* El compilador requiere que se conserven sus valores */
	emit("push ebp");
	emit("push ebx");
	emit("push esi");
	emit("push edi");

	/* Guardar el ptr de la pila para realizar salida abrupta si se produce una excepcion */
	/* de nivel 0 (solo error de bus y de direccion, la de reset no esta emulada) */
	if (emulate_group_0)
		emit("mov [__excep_ptr],esp");	  /* Puntero para excepciones de grupo 0 */

	emit("mov [__cycles_needed],eax");    /* guardar ciclos de ejecucion solicitados */
	emit("lea edi,[eax-1]");              /* EDI = ciclos ejecucion - 1 (para comprobar signo) */
	emit("xor ebx,ebx");				  /* EBX = 0 */
	emit("mov esi,[__pc]");               /* Cargar contador de programa en ESI */
	cache_ccr();                          /* CCR -> AX */
	emit("or byte[__execinfo],1");        /* Poner estado de ejecucion en la CPU */
	emit("call basefunction");            /* Calcular la base para el PC */
	emit("add esi,ebp");                  /* Añadir base al PC para obtener direccion final */

	/***************************************************************************************/
	/* Este código solo se emite si no se emulan las excepciones de error de bus/direccion */
	/* Si se emulan estas excepciones no se controla el PC tras un basefunction puesto que */
	/* en ese caso se produciría un error de bus y la ejecución de la CPU continuaría      */
	/***************************************************************************************/
	if (!emulate_group_0)
	{
		emit("test byte[__execinfo],2");      /* Chequea si el PC ha rebasado los limites */
		emit("jnz near exec_bounderror");     /* en cuyo caso error de desbordamiento */
	}

	/***************************************/
	/* Chequeo de prioridad de excepciones */
	/***************************************/

	/* Excepciones de grupo 0 y excepcion de traza */
	if (emulate_group_0)
		emit("test byte[__execinfo],0xA");	/* grupo 0 y modo traza */
	else if (emulate_trace)
		emit("test byte[__execinfo],0x8");  /* solo modo traza */

	emit("jnz short execloop");

	
	/* CHEQUEO DE INTERRUPCIONES HARDWARE */
	emit("int_check:");
	interrupt_chk();

    if (emulate_trace)
    {
        /* Chequear el modo de traza en espera de ser atendida */
        emit("test byte[__execinfo],0x8");
        emit("jnz short trace_excep");
    
        emit("test_trace:");    
    
	    /* CHEQUEO DE EXCEPCION DE MODO TRAZA */
	    /* Mirar a ver si esta activa la bandera de traza y generar proceso de excepcion */
	    emit("test byte[__sr+1],80h");	    /* Testear bit de traza */
        emit("jz short execloop");

	    /* GENERACION DE LA EXCEPCION DE TRAZA */
	    emit("trace_excep:");

        /* Esto no se lanza ahora! se deja pendiente para el execexit */
        emit("or byte[__execinfo],8"); /* trace */

        /* Tengo que quitar los ciclos para provocar salida y esperar a que vuelva */
        /* para provocar el do_trace */
        emit("mov [__cycles_needed],edi");
        emit("xor edi,edi");
        emit("add [__cycles_needed],byte 1");
    }
	
	/* EXECLOOP */
	emit("execloop:");
	load_opcode();                        /* Cargar opcode en BX */
	emit("jmp dword[__jmptbl+ebx*4]");    /* A ejecutar! */

	/* hay interrupcion(es) activada(s) en espera de ser atendidas! */
	emit("flush_int:");
	emit("call flush_interrupts");	      /* atender interrupciones */
	emit("call basefunction");
	emit("add esi,ebp");                  /* agregar la base al PC */
	if (irq_cycles)
	{
		emit("sub edi,byte 44");              /* ciclos empleados en la atencion */
		emit("jns short execloop");
	}
	else
	{
		emit("jmp short execloop");
	}

	/* Usar bucle si la extracción y descodificación no están en línea */
	if(!inline_fd_loop) {
		emit("execend:");
		emit("jns short execloop");
	}

	if(!emulate_group_0)
		emit("xor ecx,ecx");      /* codigo de retorno (exito) */
	
    /* Salida de funcion emulate */
	emit("execexit:");

    if (emulate_trace)
    {
        /* Comprobar si estoy en TRACE, puesto que si es asi debo pasar a DO_TRACE */
        /* ejecutando la excepcion de traza */
        emit("test byte[__execinfo],0x8");
        emit("jz short cont_execexit");

        emit("mov edi,[__cycles_needed]");
        emit("dec edi");
        emit("and byte[__execinfo],0xF7");  /* Retiramos la espera de atencion (TRACE) */
        emit("or byte[__execinfo],16");		/* Atendiendo a excepcion de modo traza */
	    emit("mov edx,24h");
	    emit("call group_1_exception");
	    get_new_pc();

	    /* Sustraer ciclos empleados en la atencion a la excepcion */
	    emit("sub edi,byte 34");
        emit("jns short execloop");
    }
    
    /* Esta sentencia es necesaria por si se produce la salida (execexit) y no se */
    /* emulan excepciones de grupo 0                                              */
    if(!emulate_group_0)
    	emit("xor ecx,ecx");      /* codigo de retorno (exito) */

    emit("cont_execexit:");
    
	emit("sub esi,ebp");          /* sustraer la base al PC */
	writeback_ccr();              /* volcar falso CCR -> CCR */
	emit("mov [__pc],esi");       /* guardar el PC */
	emit("inc edi");              /* EDI = ciclos requeridos ejecutar - ejecutados */
	emit("mov edx,[__cycles_needed]");/* EDX = ciclos requeridos */
	emit("sub edx,edi");          /* EDX = ejecutados */
	if (emulate_group_0)
		emit("xor eax,eax");
	else
		emit("mov eax,ecx");
	emit("add [__cycles_counter],edx"); /* incrementar contador con los ejecutados */
	emit("and byte[__execinfo],0FEh");	       /* Detener CPU */
   /* cycles_needed = 0 */
   emit("mov dword[__cycles_needed],%s",(emulate_group_0)?"eax":"0");

    /* Restaurado de registros */
	emit("pop edi");
	emit("pop esi");
	emit("pop ebx");
	emit("pop ebp");
	emit("ret");

	if (!emulate_group_0) {
		/* Error: PC fuera de los limites de la memoria */
		emit("exec_bounderror:");
		emit("or ecx,-1");           /* Codigo de retorno */
		/* emit("jmp short execexit"); */
        emit("jmp execexit");
	}
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
	gen_proc_header("reset");

	emit("xor eax,eax");
	emit("test byte[__execinfo],1"); /* Asegurarse de que no se esta en ejecucion */
	emit("jz short .checksfmm");     /* si 68k no esta activo, continuar */

	/* si esta activo, salir con codigo de retorno EAX = 1 */
	emit("mov al,1");
	emit("ret");

	emit(".checksfmm:");
	emit("cmp dword[__s_fetch],eax");
	emit("jne short .setup");

	/* si no hay programa supervisor, salir EAX=2 */
	emit("mov al,2");
	emit("ret");

	emit(".setup:");
	emit("mov [__execinfo],ax");  /* execinfo = 0 */
	emit("and [__interrupts],byte 1");/* interrupts = 0 (excepto bit 0 -irqset-) */

	/* Salvar registros necesarios */
	emit("push esi");
	emit("push ebp");

	/* Resetear registros de datos y direcciones, incluyendo A7 */
	emit("xor ebp,ebp");
	emit("mov cl,16");          /* numero de registros (de datos + de direccion) */
	emit("mov esi,4");          /* incremento al ptr. en cada iteracion */
	emit("mov eax,__reg");      /* direccion base de los registros */
	emit(".cl_reg:");
	emit("mov [eax],ebp");      /* volcar 0 en registro */
	emit("add eax,esi");        /* al siguiente registro */
	emit("dec cl");             /* decrementar indice */
	emit("jnz short .cl_reg");
	
	emit("mov [__asp],ebp");  /* ASP = 0 */
	/* Traza desactivada, modo supervisor, PPL=7 */
	emit("mov word[__sr],2700h");     /* SR = modo S, traza off, PPL = 7 */
	set_supervisor_memory_map();
	emit("xor esi,esi");              /* ESI = 0 */
	emit("call basefunction");
	emit("add esi,ebp");              /* añade la base al PC cache */
	emit("mov eax,[esi]");            /* ptr. de pila inicial */
	emit("rol eax,16");
	emit("mov [__a7],eax");           /* cargar ptr. de la pila del mapa de memoria */
	emit("mov eax,[esi+4]");
	emit("rol eax,16");
	emit("mov [__pc],eax");           /* cargar PC */
	emit("xor eax,eax");              /* codigo de exito */

	/* Recuperar registros */
	emit("pop ebp");
	emit("pop esi");
	emit("ret");
}

/******************************************************************************/
/* m68k_raise_irq(level,vector)			                                      */
/* Parametros: level = nivel de interrupcion (r4)                             */
/*             vector = puntero a la direccion de la rutina de atencion (r5)  */
/*                      -1 auto, -2 interrupcion espuria                      */
/* Retorno: Exito de la operacion                                             */
/*         0  La interrupcion se ha habilitado satisfactoriamente             */
/*         1  No se ha podido habilitar porque ya existe otra interrupcion    */
/*			  en ese nivel.                                                   */
/*         2  No se ha podido habilitar porque el vector no es valido o       */
/*	                 el nivel es igual a 0.                                   */
/******************************************************************************/
static void gen_raise_irq(void)
{
	gen_proc_header("raise_irq");

	emit("push edx");
	if (stack_calling) {
		emit("mov eax,[esp+8]");      /* EAX = nivel de interrupcion  */
		emit("mov edx,[esp+12]");     /* EDX = vector de atencion a la interrupcion */
	}


    emit("and eax, byte 7");          /* Enmascarar nivel de interrupcion */
	emit("jz short .badinput");       /* Si es cero, error de entrada */
	emit("cmp edx,255");              /* El vector de interrupcion no puede ser > 255 */
	emit("jg short .badinput");
	emit("cmp edx,byte -2");          /* ni menor que -2 */
	emit("jl short .badinput");

	emit("jne short .notspurious");	  /* si es = -2 -> int. espuria */
	emit("mov edx,18h");              /* Indice en la tabla de int. para int. espuria */
	emit(".notspurious:");
	emit("test edx,edx");             /* activar banderas */
	emit("jns short .notauto");       /* Si es negativo, tiene q ser int. automatica */
	emit("lea edx,[eax+18h]");
	emit(".notauto:");

	emit("mov cl,al");                /* Cargar nivel de interrupcion en CL */
	emit("mov ah,1");                 /* Llevar un 1 a AH para desplazarlo */
	emit("shl ah,cl");                /* Desplazarlo en AH */
	emit("test [__interrupts],ah");   /* Si ya existia, error */
	emit("jnz short .failure");

	emit("or [__interrupts],ah");     /* Dar la interrupción de alta en interrupts */
	emit("xor ah,ah");                /* AH = 0 */
	emit("mov [__interrupts+eax],dl");/* Cargar el vector dentro de interrupts */
	
	/* En AL esta el nivel de interrupcion. Tiene que ser mayor que el PPL */
	/* para quitar el estado parado de la CPU, en el caso de que lo este */
	emit("test byte[__execinfo],80h"); /* testear si la CPU esta detenida mediante STOP */
	emit("jz short .notstopped");

	emit("mov cl,[__sr+1]");          /* cargar PPL */
	emit("and cl,7");                 /* aislar bits PPL */
	emit("cmp al,7");                 /* se ha activado la NMI? */
	emit("sete ah");                  /* en ese caso AH = 1, si no AH = 0 */
	emit("add al,ah");                /* incrementar AL si es NMI para comprobacion */
	emit("cmp al,cl");                /* comparar con nivel de interrupcion */
	emit("setbe cl");                 /* si NI es <= el bit permanecera activo */
	emit("shl cl,7");                 /* ajustar a posicion bit en execinfo */
	emit("and byte[__execinfo],7Fh"); /* Bit a 0 para fijar */
	emit("or byte[__execinfo],cl");   /* Fijar bit */

	emit(".notstopped:");
	emit("pop edx");
	emit("xor eax,eax");        /* Codigo de exito */
	emit("ret");

	emit(".badinput:");         /* Error en los datos de entrada */
	emit("pop edx");
	emit("mov eax,-2");         /* codigo de retorno (EAX = -2) */
	emit("ret");

	emit(".failure:");          /* Fallo */
	emit("pop edx");
	emit("mov eax,-1");			/* codigo de retorno (EAX = -1) */
	emit("ret");
}

/******************************************************************************/
/* m68k_lower_irq(level)                                                      */
/* Parametros: Nivel de la interrupcion a retirar                             */
/* Retorno: Exito de la operacion                                             */
/*         0  La interrupcion se ha retirado satisfactoriamente               */
/*         1  No se ha podido retirar porque esa interrupcion                 */
/*			  no esta habilitada.                                             */
/*         2  No se ha podido retirar porque el nivel es 0 o mayor            */
/*				o igual que 7 (no se puede retirar la NMI)                    */
/******************************************************************************/
static void gen_lower_irq(void)
{
	gen_proc_header("lower_irq");

	if (stack_calling)
		emit("mov eax,[esp+4]");    /* EAX = parametro nivel de interrupcion  */

	emit("cmp eax,byte 6");         /* nivel de interrupcion <= 6 */
	emit("ja short .badlevel");     /* no se puede retirar la NMI porque se */
							        /* activa por flanco, no por nivel */
	emit("test eax,eax");           /* fijar banderas, si nivel es 0 -> error */
	emit("jz short .badlevel");

	emit("mov cl,al");              /* cargar nivel de interrupción en CL */
	emit("mov ah,1");               /* cargar 1 en AH para desplazar */
	emit("shl ah,cl");              /* desplazar a posicion de nivel */
	emit("test [__interrupts],ah"); /* Si no existia, error */
	emit("jz short .failstat");
	
	emit("not ah");

	emit("and [__interrupts],ah");   /* Dar la interrupción de baja */
	emit("xor eax,eax");    /* Codigo de exito */
	emit("ret");

	emit(".failstat:");     /* Fallo: la interrupcion no esta habilitada */
	emit("mov eax,-1");     /* codigo de retorno (EAX = -1) */
	emit("ret");

	emit(".badlevel:");
	emit("mov eax,-2");     /* Valor de interrupcion no valido (cero) */
	emit("ret");
}

/******************************************************************************/
/* m68k_set_irq_type(cpu_context,type)                                        */
/* Parametro: Tipo de irq (manual=1 o automatica=0)                           */
/* No retorna ningun valor                                                    */
/******************************************************************************/
static void gen_set_irq_type(void)
{
	gen_proc_header("set_irq_type");

	emit("push edx");
	if (stack_calling)
	{
		emit("mov eax,[esp+8]");      /* EAX = ptr. to CPU context  */
		emit("mov edx,[esp+12]");     /* EDX = IRQ system type */
	}

	emit("and dl,1");                 /* enmascarar sistema de interrupcion */
	emit("test eax,eax");             /* nos pasan contexto de CPU? */
	emit("jz short .si_irq");         /* si no, asignacion al actual */

	emit("or byte[eax+__interrupts-contextbegin],dl");
	emit("pop edx");
	emit("xor eax,eax");
	emit("ret");

	emit(".si_irq:");
	emit("or byte[__interrupts],dl");
	emit("pop edx");
	emit("xor eax,eax");
	emit("ret");
}

/******************************************************************************/
/* m68k_get_irq_vector(level)                                                 */
/* Parametro: Nivel de interrupcion                                           */
/* Retorno: Exito de la operacion o vector de la interrupcion                 */
/*         -1: La interrupcion no esta activada                               */
/*         -2: El nivel de interrupcion no es valido (nivel = 0)              */
/*         > -1: Vector de interrupcion solicitado                            */
/******************************************************************************/
static void gen_get_irq_vector(void)
{
	gen_proc_header("get_irq_vector");

	if (stack_calling)
		emit("mov eax,[esp+4]");    /* EAX = parametro nivel de interrupcion */

	emit("and eax, byte 7");        /* enmascarar nivel de interrupción */
	emit("jz short .badlev");

	emit("mov cl,al");              /* cargar nivel de interrupción en CL */
	emit("mov ah,1");               /* cargar 1 en AH para desplazar */
	emit("shl ah,cl");              /* desplazar a posicion de nivel */

	emit("test [__interrupts],ah"); /* Si no existia, error */
	emit("jz short .notraised");

	emit("xor ah,ah");              /* Eliminar bit de testeo para indexar */
	emit("mov cl,[__interrupts+eax]");/* Vector */
	emit("mov al,cl");				/* Llevar resultado a AL */
	emit("ret");

	emit(".notraised:");            /* Interrupcion no generada */
	emit("mov eax,-1");
	emit("ret");

	emit(".badlev:");               /* Nivel especificado = 0 */
	emit("mov eax,-2");
	emit("ret");
}


/******************************************************************************/
/* m68k_change_irq_vector(level,vector)                                       */
/* Parametros:                                                                */
/*		level: Nivel de interrupcion                                          */
/*		vector: Nuevo puntero a la direccion de la rutina de atencion         */
/*                      -1 auto, -2 interrupcion espuria                      */
/* Retorno: Exito de la operacion                                             */
/*         0  El vector de interrupcion se ha modificado satisfactoriamente   */
/*         1  No se ha podido modificar porque no existe interrupcion         */
/*			  en ese nivel.                                                   */
/*         2  No se ha podido habilitar porque el vector no es valido o el    */
/*			  nivel es igual a 0.                                             */
/******************************************************************************/
static void gen_change_irq_vector(void)
{
	gen_proc_header("change_irq_vector");

	emit("push edx");
	if (stack_calling) {
		emit("mov eax,[esp+8]");    /* EAX = parametro nivel de interrupcion  */
		emit("mov edx,[esp+12]");   /* EDX = vector de atencion a la interrupcion */
	}
	emit("and eax,byte 7");			/* enmascarar nivel de interrupción */
	emit("jz short .badin");

	emit("mov cl,al");              /* cargar nivel de interrupción en CL */
	emit("mov ah,1");               /* cargar 1 en AH para desplazar */
	emit("shl ah,cl");              /* desplazar a posicion de nivel */

	emit("test [__interrupts],ah"); /* Si no existia, error */
	emit("jz short .nraised");
	
	emit("cmp edx,255");            /* El vector de interrupcion no puede ser > 255 */
	emit("jg short .badin");
	emit("cmp edx,byte -2");        /* ni menor que -2 */
	emit("jl short .badin");

	emit("jne short .notspur");
	emit("mov edx,18h");            /* Indice en la tabla de int. para int. espuria */
	emit(".notspur:");
	emit("test edx,edx");
	emit("jns short .notaut");      /* Si es negativo, tiene q ser int. automatica */
	emit("lea edx,[eax+18h]");

	emit(".notaut:");
	emit("xor ah,ah");                /* AH = 0 */
	emit("mov [__interrupts+eax],dl");/* Cargar en vector dentro de interrupts */ 

	emit("pop edx");
	emit("xor al,al");              /* Codigo de exito (AL=0, resto ya esta a 0) */
	emit("ret");

	emit(".nraised:");              /* Interrupcion no generada */
	emit("pop edx");
	emit("mov eax,-1");             /* codigo de retorno (EAX = -1) */
	emit("ret");

	emit(".badin:");                /* Error en la entrada */
	emit("pop edx");
	emit("mov eax,-2");             /* codigo de retorno, (EAX = -2) */
	emit("ret");
}

/******************************************************************************/
/* m68k_get_context_size                                                      */
/* No recibe parametros                                                       */
/* Retorno: Tamano del contexto en bytes                                      */
/******************************************************************************/
static void gen_get_context_size(void)
{
	gen_proc_header("get_context_size");

	emit("mov eax,contextend-contextbegin");
	emit("ret");
}

/***************************************************************************/
/* m68k_get_context(address)                                               */
/* Parametro: Direccion del contexto                                       */
/* No retorna ningun valor                                                 */
/***************************************************************************/
static void gen_get_context(void)
{
	gen_proc_header("get_context");

	/* Salvar registros a usar */
	emit("push esi");
	emit("push edi");

	emit("cld");
	emit("mov ecx,contextend-contextbegin");  /* Tamaño del contexto en ECX */

	emit("shr ecx,2");	                      /* Copia en DW (tamaño / 4) */
	if (stack_calling)
		emit("mov edi,[esp+12]");             /* Cargar direccion de contexto */
	else
		emit("mov edi,eax");                  /* si llamada por pila, de EAX */
	emit("mov esi,contextbegin");             /* Direccion contexto destino */
	emit("rep movsd");                        /* Copia */

	/* Restaurar registros */
	emit("pop edi");
	emit("pop esi");
	emit("xor eax,eax");                      /* Retorno = 0 */

	emit("ret");
}

/******************************************************************************/
/* m68k_set_context(address)                                                  */
/* Parametro: Direccion del contexto                                          */
/* No retorna ningun valor                                                    */
/******************************************************************************/
static void gen_set_context(void)
{
	gen_proc_header("set_context");

	/* Salvar registros a usar */
	emit("push esi");
	emit("push edi");

	emit("cld");
	emit("mov ecx,contextend-contextbegin");  /* Tamaño del contexto en ECX */
	emit("shr ecx,2");	                      /* Copia en DW (tamaño / 4) */
	if (stack_calling)
		emit("mov esi,[esp+12]");             /* Cargar direccion de contexto */
	else
		emit("mov esi,eax");                  /* si llamada por pila, de EAX */
	emit("mov edi,contextbegin");             /* Direccion contexto destino */
	emit("rep movsd");
	/* movsd es bastante rapida tanto en procesadores antiguos (386 y 486) */
	/* como en los Pentium y superiores */
	
	/* Poner todas los indices a NULL (marcar outofrange) */
	emit("mov ecx,0A000h");    /* Tamaño de tablas de indices */
	emit("mov eax,__sfmhtbl"); /* Direccion de comienzo de tablas */
	emit("xor edi,edi");       /* Dato a cargar (marca) */
	emit("mov edx,4");

	emit(".dirty_idx:");
	emit("mov [eax],edi");     /* volcar 0 (marcar) */
	emit("add eax,edx");       /* incrementar ptr. con indice */
	emit("dec ecx");           /* decrementar contador */
	emit("jnz short .dirty_idx");


	/* Realizar cache de lista de regiones (indices) */

	/* Mapa fetch supervisor */
	cache_memory_map("__sfmhtbl","__s_fetch",FETCH_STRUCT_SIZE);

	/* Mapa fetch usuario */
	cache_memory_map("__ufmhtbl", "__u_fetch", FETCH_STRUCT_SIZE);

	/* Mapa lectura byte supervisor */
	cache_memory_map("__srbmhtbl", "__s_readbyte", DATA_STRUCT_SIZE);

	/* Mapa lectura word supervisor */
	cache_memory_map("__srwmhtbl", "__s_readword", DATA_STRUCT_SIZE);

	/* Mapa lectura byte usuario */
	cache_memory_map("__urbmhtbl", "__u_readbyte", DATA_STRUCT_SIZE);

	/* Mapa lectura word usuario */
	cache_memory_map("__urwmhtbl", "__u_readword", DATA_STRUCT_SIZE);

	/* Mapa escritura byte supervisor */
	cache_memory_map("__swbmhtbl", "__s_writebyte", DATA_STRUCT_SIZE);

	/* Mapa escritura byte usuario */
	cache_memory_map("__uwbmhtbl", "__u_writebyte", DATA_STRUCT_SIZE);

	/* Mapa escritura word supervisor */
	cache_memory_map("__swwmhtbl", "__s_writeword", DATA_STRUCT_SIZE);

	/* Mapa escritura word usuario */
	cache_memory_map("__uwwmhtbl", "__u_writeword", DATA_STRUCT_SIZE);

	/* Restaurar registros */
	emit("pop edi");
	emit("pop esi");
	emit("xor eax,eax");    /* Retorno = 0 */	
	emit("ret");
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
	gen_proc_header("get_register");

	if (stack_calling)
		emit("mov eax,[esp+4]");    /* EAX = parametro indice del registro  */

	emit("cmp eax,byte %d",M68K_REG_PC);
	emit("ja short .cont_get_funct");

	emit("cmp eax,byte %d",M68K_REG_ASP);
	emit("ja short %s%s_get_pc",(elf)?"":"_", fprefix);

	emit("mov eax,[__reg+eax*4]");          /* D(X) + A(X) + ASP */
	emit("ret");

	emit(".cont_get_funct:");
	emit("cmp eax,byte %d",M68K_REG_SR);    /* Es el SR? */
	emit("jne short .inv_idx");
	emit("xor eax,eax");
	emit("mov ax,word[__sr]");              /* Cargar SR en EAX (dato en AX) */
	emit("ret");

	emit(".inv_idx:");
	emit("or eax,-1");                      /* Retorno = -1 (error) */
	emit("ret");
}

/******************************************************************************/
/* m68k_get_pc()                                                              */
/* No recibe parametros                                                       */
/* Retorna 68k PC                                                             */
/******************************************************************************/
static void gen_get_pc(void)
{
	gen_proc_header("get_pc");

	emit("test byte[__execinfo],1");
	emit("jnz short .live");
	emit("mov eax,[__pc]");       /* devolver PC en EAX */
	emit("ret");

	emit(".live:");
	/* si 68k esta en ejecución */
	emit("mov eax,[__io_fetchbased_pc]");
	emit("sub eax,[__io_fetchbase]");
	emit("ret");
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
	gen_proc_header("set_register");

	emit("push edx");
	if (stack_calling) {
		emit("mov eax,[esp+8]");      /* EAX = indice de registro  */
		emit("mov edx,[esp+12]");     /* EDX = valor a asignar al registro */
	}
	
	emit("cmp eax,byte %d",M68K_REG_PC);/* Chequear si esta dentro de los limites [D0-PC] */
	emit("ja short .cont_set");

	emit("cmp eax,byte %d",M68K_REG_ASP);
	emit("ja short .set_pc");

	emit("mov [__reg+eax*4],edx");    /* Carga del valor al registro [D0-PC] */

	emit("pop edx");
	emit("xor eax,eax");              /* Retorno = 0 */
	emit("ret");

	emit(".set_pc:");
	maskaddress("edx");
	emit("test byte[__execinfo],1");
	emit("jnz short .cpulive");
	emit("mov [__pc],edx");           /* fijar PC */
	emit("pop edx");
	emit("xor eax,eax");              /* Retorno = 0 */
	emit("ret");

	emit(".cpulive:");
	/* si 68k esta en ejecución */
	emit("add edx,[__io_fetchbase]");     /* anadir la base actual al PC */
	emit("mov [__io_fetchbased_pc],edx"); /* fijar nuevo valor */
	emit("pop edx");
	emit("xor eax,eax");              /* Retorno = 0 */
	emit("ret");

	emit(".cont_set:");
	emit("cmp eax,byte %d",M68K_REG_SR);
	emit("jne short .inv_idx");

	emit("mov [__sr],dx");            /* Carga del valor del SR */
	emit("pop edx");
	emit("xor eax,eax");              /* EAX = 0 (exito) */
	emit("ret");

	emit(".inv_idx:");                /* Indice de registro no valido */
	emit("pop edx");
	emit("or eax,-1");                /* Codigo de retorno error */
	emit("ret");
}

/*********************************************************/
/*  m68k_fetch(address,access_type)                      */
/*  Lee una palabra del mapa de memoria supervisor       */
/*  Parametro: Direccion de la palabra y tipo de acceso  */
/*  Retorno: La palabra o -1 en caso de dir. no valida   */
/*********************************************************/
static void gen_fetch(void)
{
	gen_proc_header("fetch");

	emit("push edx");

	/* Obtención de parámetros si necesario */
	if (stack_calling) {
		emit("mov eax,[esp+8]");    /* EAX = direccion de acceso  */
		emit("mov edx,[esp+12]");   /* EDX = tipo de acceso */
	}

	emit("and edx,3");      /* Enmascarar bits de tipo de acceso */
	emit("push eax");
	emit("shr eax,12");     /* EAX = 12 bits + altos direccion (banco) */
	/* Cargo la direccion del vector de fetch con el tipo de acceso << 2 (ptr. palabras dobles) */
	emit("mov ecx,[__fetch_vector+edx*4]");
	emit("mov ecx,[ecx+eax*4]");  /* ECX = ptr. a estructura read */
	emit("pop eax");
	emit("test ecx,ecx");
	emit("jz short .outofrange");
	
	emit("test dl,1");
	emit("jz short .base_prg");
	emit("jmp short .base_dat");


	/* Fuera de limites, devolver -1 */
	emit(".outofrange:");
	emit("pop edx");        /* Recuperar EDX con valor original */
	emit("or eax,-1");      /* Resultado = -1 */
	emit("ret");

	/* Calculo de la base para programa */
	emit(".base_prg:");
	emit("add eax,[ecx+8]");     /* Añadir la base a la direccion requerida */
    emit("movzx eax,word[eax]"); /* Cargar resultado final en AX */
	emit("pop edx");             /* Restaurar EDX */
	emit("ret");

	/* Calculo de la base para datos */
	emit(".base_dat:");
	/* Comprobar si existe ptr de manejador */
	emit("test dword[ecx+8],0xFFFFFFFF");
	emit("jnz short .callio");

	/* Lectura mediante manejador propio */
	emit("add eax,[ecx+12]");   /* Añadir la base a la direccion requerida */
	emit("movzx eax,word[eax]");/* Cargar resultado final en AX */
	emit("pop edx");            /* Restaurar EDX */
	emit("ret");

	/* Lectura mediante manejador de entrada/salida */
	emit(".callio:");
	if(stack_calling) {
		emit("push edx");       /* "empujar" parametros */
		emit("push eax");
	}
	emit("call dword[ecx+8]");  /* llamada al manejador */
	if(stack_calling)

		emit("add esp,byte 8"); /* incrementar ptr de pila para dejar parametros */

	emit("pop edx");
	emit("ret");                /* el resultado esta ya en EAX */

}

/******************************************************/
/*  m68k_get_cycles_counter()                         */
/*  Retorna el cycles_counter                         */
/*  Parametro: Ninguno                                */
/*  Retorno: cycles_counter                           */
/******************************************************/
static void gen_get_cycles_counter(void)
{
	gen_proc_header("get_cycles_counter");

	emit("mov eax,[__cycles_needed]");
	emit("test byte[__execinfo],1");       /* esta 68k en ejec.? */
	emit("jz short .cpuidle");
	emit("sub eax,[__io_cycle_counter]"); 
	emit(".cpuidle:");
	emit("add eax,[__cycles_counter]");
	emit("ret");
}

/******************************************************/
/*  m68k_trip_cycles_counter()                        */
/*  Retorna el cycles_counter y lo reinicializa       */
/*  Parametro: Ninguno                                */
/*  Retorno: cycles_counter                           */
/******************************************************/
static void gen_trip_cycles_counter(void)
{
	gen_proc_header("trip_cycles_counter");

	/* Lectura */
	emit("mov eax,[__cycles_needed]");
	emit("test byte[__execinfo],1");
	emit("jz short .cpuidle");
	emit("sub eax,[__io_cycle_counter]");

	emit(".cpuidle:");
	emit("add [__cycles_counter],eax");
	/* Reinicialización */
	emit("test byte[__execinfo],1");
	emit("jz short .cpuidle2");
	emit("mov eax,[__io_cycle_counter]");
	emit(".cpuidle2:");
	emit("mov [__cycles_needed],eax");
    emit("mov eax,[__cycles_counter]");   /* retorno EAX = cycles_counter */
	emit("mov dword[__cycles_counter],0");/* cycles_counter = 0 */
	emit("ret");
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

	if (stack_calling)
		emit("mov eax,[esp+4]");
	emit("test eax,eax");
	emit("jnz short %s%s_trip_cycles_counter",(elf)?"":"_", fprefix);
	emit("jmp short %s%s_get_cycles_counter",(elf)?"":"_", fprefix);
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
	gen_proc_header("release_timeslice");

	emit("test byte[__execinfo],1");     /* chequear si la CPU esta detenida */
	emit("jz short .cpuidle");
	emit("mov eax,[__cycles_needed]");
	emit("sub [__io_cycle_counter],eax");
	emit(".cpuidle:");
	emit("xor eax,eax");
	emit("mov [__cycles_needed],eax");
	emit("ret");
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
	gen_proc_header("add_cycles");
	
	if(stack_calling)
		emit("mov eax,[esp+4]");
	emit("add [__cycles_counter],eax");
	emit("xor eax,eax");
	emit("ret");
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
	gen_proc_header("release_cycles");
	
	if(stack_calling)
		emit("mov eax,[esp+4]");
	emit("sub [__cycles_counter],eax");
	emit("xor eax,eax");
	emit("ret");
}

/*****************************************************************************/
/* m68k_get_cpu_state()                                                      */
/* No recibe parametros                                                      */
/* Retorna el estado de la CPU                                               */
/*****************************************************************************/
static void gen_get_cpu_state(void)
{
	gen_proc_header("get_cpu_state");

	emit("xor eax,eax");
	emit("mov ax,[__execinfo]"); /* cargar estado de la ejecucion */
	emit("ret");
}

/***************************************************************************/
/* Generacion del codigo de la API                                         */
/***************************************************************************/
static void gen_api(void)
{
	emit_il("section .text");
	if (borland)
		emit(" public align=1 class=CODE use32");
	else
		emit_il("\n");
	emit("bits 32");
	emit("cpu 386");
	emit("top:");
	
	gen_init();
	gen_emulate();
	gen_reset();
	gen_raise_irq();
	gen_lower_irq();
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
static void gen_flush_interrupts(void)
{    
	align(16);
	emit("flush_interrupts:");
	emit("sub esi,ebp");              /* PC sin base */
	emit("xor ebp,ebp");              /* EBP = 0 */
	emit("mov edx,7");                /* Contador del bucle y del nivel de int. */
	emit("mov cl,80h");               /* Mascara a la interrupcion */
	emit("mov ch,[__sr+1]");          /* Cargar nivel actual de interrupcion (PPL) */
	emit("and ch,7");                 /* Enmascarar nivel de interrupcion */
	emit(".loop:");
	emit("test [__interrupts],cl");   /* Testear para saber si hay q atender interrupcion */
	emit("jz short .noint");          /* No hay interrupcion en este nivel que atender */

	/* DL a la entrada contiene el nivel de interrupcion q se va a atender */
	emit("mov [__tmp_int_level], dl");/* Salvar de forma temporal el nivel de int. a atender */

	/* Testear si hay q "bajar" automaticamente la int. */
/*    emit("test [__interrupts],byte 1"); 
    emit("jz short .noadint");
*/
	emit("not cl");                   /* Invertir para enmascarar interrupcion */
	emit("and [__interrupts],cl");

	/* No auto down interrupts */
/*    emit(".noadint:");
*/
	emit("mov dl,[__interrupts+edx]");
	emit("shl edx,2");                /* Multiplicar por 4 para obtener la direccion en la tabla */
	emit("call group_1_exception");
	emit("and [__sr+1], byte 0F8h");  /* Reinicia int. enmascarando PPL a 0 */

	emit("mov dl, [__tmp_int_level]");
	emit("or [__sr+1], dl");

	emit("test dword[__iackhandler],0FFFFFFFFh"); /* comprobar si hay rutina de acknowledge */
	emit("jz short .intdone");                    /* si no la hay, continuar */

	core_exit();
	/* Paso de parametros al manejador */
	if(stack_calling)
		emit("push edx");
	else
		emit("movzx eax,dl");               /* EAX = DL */
	
	emit("call dword[__iackhandler]");      /* si la hay llamarla */

	/* Retirar parametro de la pila si necesario */
	if(stack_calling)
		emit("add esp,byte 4");             /* incrementar ptr de pila */

	core_enter();
	emit("jmp short .intdone");             /* y continuar */

	emit(".noint:");
	emit("dec dl");
	emit("jz short .intdone");
	emit("shr cl,1");                 /* desplazar mascara */
	emit("cmp dl,ch");                /* chequear si quedan mas interrupciones */
	emit("jg .loop");
	emit(".intdone:");
	/* La interrupcion no enmascarable es sensible al flanco */
	/* no al nivel como el resto */
/*	emit("and [__interrupts], byte 7Fh"); */ /* desactiva peticion de atencion de la NMI */
	emit("ret");
}

/***************************************************************************/

/* Decrementa el contador de ciclos y continua la ejecucion si procede */
static void timing(int n)
{
	/* Fijar banderas x86 con EDI (ciclos de reloj) y dec. ciclos */
	if(n > 0)
	{
		emit("sub edi,%s%d", (n < 128)?"byte ":"", n);  /* si n!= 0 -> restar */
	}
	else
	{
		emit("test edi,edi");              /* si no, solo actualizar banderas */
	}

	/* Si no esta activada la opcion inline_fd_loop, volver al bucle principal */
	if(!inline_fd_loop)
	{
		emit("jmp near execend");
	}
	else    /* Si esta activada, extraer y descodificar la siguiente instrucción */
	{
		emit("js near execexit");
		load_opcode();           /* cargar opcode en BX a ejecutar */
		emit("jmp dword[__jmptbl+ebx*4]");  /* salto siguiente instrucción */
	}
}

/* Este ret_timing realiza ademas un chequeo de la bandera de traza */
/* Se utiliza tras las instrucciones que tienen capacidad de fijar el valor de la bandera */
/* no aquellas que son capaces de borrarlo */
static void timing_cp(int n)
{
	/* Fijar banderas x86 con EDI (ciclos de reloj) y dec. ciclos */
	if(n > 0) 
		emit("sub edi,%s%d", (n < 128)?"byte ":"", n);

	emit("test edi,edi");  /* Testear estado ciclos */

	if(!inline_fd_loop)
    {
		emit("js near execend");
		emit("test byte[__sr+1],80h");     /* Testear bandera de traza */
		emit("jnz near trace_excep");
		emit("jmp near execend");
	}
    else
    {
		emit("js near execexit");

		if (emulate_trace)
		{
			emit("test byte[__sr+1],80h");     /* Testear bandera de traza */
			emit("jnz near trace_excep");
		}

		load_opcode();                     /* cargar opcode en BX a ejecutar */
		emit("jmp dword[__jmptbl+ebx*4]"); /* salto siguiente instrucción */
	}
}

/* Genera una excepcion de grupo 0 (ERROR DE BUS y ERROR DE DIRECCION) */
static void gen_g0_error_exception(int error_type, int access_type)
{
	/* Cargar ptr de pila para salir correctamente de "emulate" */
	emit("mov esp,[__excep_ptr]");

	/* Introducir valores necesarios para excepcion en la pila */
	/* INSTRUCTION REGISTER */
	if ((access_type == READ_DATA_TYPE) || (access_type == WRITE_DATA_TYPE))
	{
		emit("mov ecx,[esi-2]");    /* Instruccion que causo la excepcion */
		emit("mov [__inst_reg],ecx");
		/* SPECIAL WORD */
		emit("xor ebx,ebx");        /* Limpiar EBX para cargar datos de la palabra */
	}
	else
	{
		/* SPECIAL WORD */
		emit("xor ebx,ebx");        /* Limpiar EBX para cargar datos de la palabra */
		emit("mov word[__inst_reg],bx");
	}
	
	/* Cargar bits de funcion y de R/W */
	emit("test byte[__sr+1],20h");
	emit("setz bl");            /* Usuario -> BL = 1; Supervisor -> BL = 0 */
	emit("inc bl");             /* Usuario -> BL = 10; Supervisor -> BL = 1 */
	emit("shl bl,2");           /* Colocar bit en su lugar */

	/* Cargar tipo operacion (programa, lectura, escritura) */
	switch(access_type)
    {
		case PROGRAM_TYPE: emit("or bl,10h"); emit("add bl,2"); break;
		case READ_DATA_TYPE: emit("or bl,10h"); /* No lleva break */
		case WRITE_DATA_TYPE: emit("inc bl"); break;
	}
	
	/* Instruccion / No Instruccion */
	/* Actualmente este bit no se emula */
	emit("and bl,0F7h");       /* Bit desactivado */
	emit("mov byte[__g0_spec_info],bl");
	
	/* Cargar en EBX la direccion accedida */
	switch (access_type)
    {
		case PROGRAM_TYPE: emit("mov ebx,esi"); break;
		case READ_DATA_TYPE:
		case WRITE_DATA_TYPE: emit("mov ebx,edx");
	}

	switch(error_type)
    {
		case ADDRESS_ERROR: 
			emit("or byte[__execinfo],40h");    /* bit de atencion error de bus activado */
			emit("mov edx,0Ch");                /* direccion de la excepcion ERROR DE DIRECCION */
			break;
		case BUS_ERROR: 
			emit("or byte[__execinfo],20h");    /* bit de atencion error de bus activado */
			emit("mov edx,8h");                 /* direccion de la excepcion ERROR DE BUS */
			break;
	}
	emit("jmp group_0_exception");              /* Generar excepcion */
}

/* Descodifica una palabra extendida en EDX */
static void gen_decode_ext(void)
{
	align(16);
	emit("decode_ext:");
    emit("push eax");           /* guardar EAX */
    emit("xor edx,edx");
    emit("mov dx,[esi]");       /* cargar palabra en EDX */
    emit("movsx eax,dl");
	inc_ptr_opcodes();
    emit("shr edx,12");
    emit("mov edx,[__reg+edx*4]");
    emit("jc short .long");
    emit("movsx edx,dx");
    emit(".long:");
    emit("add edx,eax");
    emit("pop eax");            /* restaurar EAX */
    emit("ret");
}

/*************************************************/
/* Calcula el nuevo PC con la base               */
/* Atencion ECX se modifica!                     */
/*************************************************/
void get_new_pc(void)
{
	int ln = linetag++;

	maskaddress("esi");
	emit("mov ecx,esi");
	emit("shr ecx,12");                  /* banco en ECX */
	emit("cmp cx,word[__fetch_bank]");   /* si = no calcular de nuevo la base */
	emit("je short ln%d", ln);

	emit("call basefunction");           /* si calcular base si necesario */
	emit("ln%d:", ln);
	emit("add esi,ebp");                 /* añadir base al PC */
}

/*******************************************************************/
/* Calcula el nuevo PC con la base a partir del registro 32 bits   */
/* El registro debe ser distinto de ESI (para eso usar get_new_pc) */
/* Atencion reg32 se modifica!                                     */
/*******************************************************************/
void get_new_pc_from(char *reg32)
{
	int ln = linetag++;
	char *reg16;

	maskaddress(reg32);   /* Enmascarar a los 24 primeros bits de direccion */
	emit("mov esi,%s",reg32);
	emit("shr %s,12",reg32);             /* banco en ECX */

	reg16 = reg32+1;
	emit("cmp %s,word[__fetch_bank]",reg16);   /* si = no calcular de nuevo la base */
	emit("je short ln%d", ln);       /* la base es la misma, no calcular de nuevo */

	emit("call basefunction");           /* calcular base si necesario */
	emit("ln%d:", ln);
	emit("add esi,ebp");                 /* añadir base al PC */
}

/********************************************************************************/
/* Esta funcion se encarga de generar la base para un PC del 68k                */
/* Parametros: 68K PC en ESI                                                    */
/* Retorno: Nueva base en EBP                                                   */
/* Atencion: ECX se altera! (guardar su valor antes de la llamada si necesario) */
/* Dado que ECX guarda el dato primario no se requerira guardar antes de la     */
/* llamada para calcular la nueva base del PC                                   */
/********************************************************************************/
static void gen_basefunction(void)
{
	align(16);
	emit("basefunction:");

	if (emulate_group_0)
	{
		emit("test si,1");
		emit("jz short .access_ok");	/* Acceso a memoria correcto */
    	/* Acceso a memoria impar: ERROR DE DIRECCION */
		gen_g0_error_exception(ADDRESS_ERROR,PROGRAM_TYPE);
		emit(".access_ok:");
	}

	maskaddress("esi");               /* Enmascarar a los 24 primeros bits de dir. */
	emit("mov ecx,esi");              /* para calcular banco en ECX */

	/* Obtencion de la region mediante la tabla de indices */
	emit("shr ecx,12");               /* ECX = banco de memoria del PC 68k */
	emit("mov ebp,[__fetch_idx]");
	emit("mov [__fetch_bank],cx");    /* guardar el banco para realizar cache */
	emit("mov ecx,[ebp+ecx*4]");
    emit("test ecx,ecx");
	emit("jz short .outofrange");     /* si ECX=0, direccion fuera de rango */

	emit("mov ebp,[ecx+8]");          /* Nueva base en EBP */
	emit("ret");

	emit(".outofrange:");
	if (emulate_group_0)
	{
		gen_g0_error_exception(BUS_ERROR,PROGRAM_TYPE);
	}
	else
	{
		emit("xor ebp,ebp");          /* EBP = 0 */
		force_context_switch();
		emit("or byte[__execinfo],2");/* out of range flag */
		emit("ret");
	}
}

/* Cargar banderas de CL al falso CCR(AX) */
/* CX no se modifica */
static void cl2ccr(void)
{
	load_ccr_from("cl");
}

/* Cargar las banderas de CX en el SR cambiando de modo si es necesario */
/* ECX no se modifica */
static void cx2sr(void)
{
	int ln = linetag;

	linetag += 2;
	emit("push ecx");             /* ECX no se modificara */
	emit("mov cl,[__sr+1]");      /* cargar BS vigente */
	emit("and cx,2020h");         /* aislar ambos bits de supervisor */
	emit("xor ch,cl");            /* si el modo vigente es diferente al nuevo, cambiar estado */ 
	emit("jz short ln%d", ln);

	/* intercambiar ptr. de pila */
	swap_sps();

	/* Fijar mapa de memoria si es necesario */
	/* y poner el mapa de memoria requerido */
	if (multiaddr)
	{
		emit("test byte[esp+1],20h");
		emit("jz short ln%d", ln + 1);
		set_memory_map("s");
		emit("jmp short ln%d", ln);
		emit("ln%d:", ln + 1);
		set_memory_map("u");
	}

	emit("ln%d:", ln);
	emit("pop ecx");               /* recuperar ECX original */
	emit("mov [__sr+1],ch");       /* nuevo BS */
	emit("and byte[__sr+1],0A7h"); /* aislar TF, SF, PPL */
	cl2ccr();                      /* y por ultimo el CCR */
}

/* Cargar banderas del falso CCR a CL */
/* CH se modifica */
static void ccr2cl(void)
{
	emit("mov cx,ax");        /* cargar falso CCR en CX */
	upset_ccr_from('c');
}

/* Cargar banderas del falso CCR y del BS a CX */
static void sr2cx(void)
{
	ccr2cl();
	emit("mov ch,[__sr+1]");
}

/* Cambia el modo de ejecución a supervisor si no esta ya */
static void supervisor(void)
{
	int ln=linetag; 

	linetag++;
	emit("test byte[__sr+1],20h");    /* Chequear bit de modo supervisor */
	emit("jnz short ln%d",ln);        /* Si esta activado, salir */
    /* Intercambiar los ptrs de pila */
    swap_sps();
	set_memory_map("s");              /* Mapa de memoria a usar */
	emit("or byte[__sr+1],20h");      /* Activar bit de modo supervisor */
	emit("ln%d:",ln);
}

/***************************************************/
/* Carga el ptr de la estructura de acceso a datos */
/* da = data access type (r = read/w = write)      */
/* save = enmascarar y salvar direccion            */
/***************************************************/
static void load_da_struct(char da, char *size, int save)
{
    if (save)
    {
	    emit("mov [__access_address],edx");/* EDX no se debe modificar */
	    if(da == 'w')
		    emit("push ecx");

	    maskaddress("edx");
    }
    emit("shr edx,12");           /* EDX = 12 bits + altos direccion (banco) */
	emit("mov ecx,[__%s%s_idx]",(da=='r')?"read":"write",size);
	emit("mov ecx,[ecx+edx*4]");  /* ECX = ptr. a estructura */
    if (save)
    {
        emit("mov edx,[__access_address]");
        maskaddress("edx");
    }
}

/* Recuperar el valor original de los registros ECX(solo escritura) y EDX */
/* antes de entrar en el manejador de acceso a memoria */
/* da = data access type (r = read/w = write)      */
static void recover_reg_mem_handler(int da)
{
	emit("mov edx,[__access_address]");
	if (da == 'w')  /* Hay que recuperar ECX tambien */
		emit("pop ecx");
}

/************************************************/
/* Leer un byte/word de una posición de memoria */
/* La direccion se pasa como parámetro en EDX   */
/* El dato se devuelve en ECX (dato primario)   */
/************************************************/
static void gen_rbw_handlers(int size)
{
	char z;

	switch(size) {
		case BYTE: z='b'; break;
		case WORD: z='w'; break;
		case LONG: return;        /* Tamaño no valido */
	}

	align(16);
	emit("readmemory%s:",sizename[size]);

	if (emulate_group_0)
	{
		/* Testear accesos de memoria impar para tamaño WORD */
		if (size == WORD)
		{
			emit("test dl,1");
			emit("jz short .access_ok");/* Acceso a memoria correcto */
			/* Acceso a memoria impar: ERROR DE DIRECCION */

			gen_g0_error_exception(ADDRESS_ERROR,READ_DATA_TYPE);
			emit(".access_ok:");
		}	
	}

	load_da_struct('r',sizename[size],1);
    emit("test ecx,ecx");
	emit("jz read%c_outofrange",z);  /* si ECX = 0 -> fuera de rango (ERROR DE BUS) */

	emit("test dword[ecx+8],0FFFFFFFFh");/* comprobar si hay ptr de funcion manejadora */
	emit("jnz short read%c_callio",z);  /* si la hay, realizar llamada */

    /* Lectura nativa */
	emit("add edx,[ecx+12]");           /* añadir ptr a la zona de memoria */
	if(size == BYTE) {
		emit("xor edx,byte 1");         /* cambio de endianness */
		emit("mov cl,[edx]");           /* carga dato en CL */
	} else {
		emit("mov cx,[edx]");           /* cargar dato */
	}
	recover_reg_mem_handler('r');
	emit("ret");

	emit("read%c_callio:",z);
	core_exit();                        /* cambio de ambito de ejecución */
	if(stack_calling) {                 /* "empujar" parametros */
		emit("push edx");               /* EDX = direccion de acceso */
	} else {
		emit("mov eax,edx");            /* dirección solicitada */
    }
	emit("call dword[ecx+8]");          /* llamada al manejador */
	if(stack_calling)
		emit("add esp,byte 4");         /* incrementar ptr de pila */
	emit("mov ecx,eax");                /* retorno de valor en EAX -> resultado en ECX */
	core_enter();                       /* volver al fantastico ensamblador */
	recover_reg_mem_handler('r');
	emit("ret");

    /* Direccion fuera de rango o no mapeada: ERROR DE BUS */
	emit("read%c_outofrange:",z);
	if (emulate_group_0)
	{
		gen_g0_error_exception(BUS_ERROR,READ_DATA_TYPE);
	}
	else
	{
		emit("or ecx,byte -1");         /* codigo de retorno */
		recover_reg_mem_handler('r');
		emit("ret");
	}
}

/* Lectura de doble palabra */
static void gen_rl_handler(void)
{
	align(16);

	emit("readmemory%s:",sizename[LONG]);

	if (emulate_group_0)
    {
		emit("test dl,1");				/* Acceso a memoria impar? */
		emit("jz short .access_ok");	/* Acceso a memoria correcto */
		/* Acceso a memoria impar: ERROR DE DIRECCION */
		gen_g0_error_exception(ADDRESS_ERROR,READ_DATA_TYPE);
		emit(".access_ok:");
	}

	load_da_struct('r',"word",1);

    /* Testear si esta dentro de los limites */
    emit("test ecx,ecx");
    emit("jz readw_outofrange");     /* Si ECX = 0 -> fuera de rango (ERROR DE BUS) */

	emit("readl_call:");
	emit("test dword[ecx+8],0FFFFFFFFh");/* comprobar si hay ptr de funcion manejadora */
	emit("jnz short readl_callio");      /* si la hay, realizar llamada */

	emit("add edx,byte 2");         /* mirar palabra alta */
	emit("cmp edx,[ecx+4]");        /* si es mayor q la direccion alta, lectura partida */
	emit("ja short readl_split");

	/* Lectura de palabra larga no particionada */
	emit("add edx,[ecx+12]");       /* añadir ptr a zona de memoria */
	emit("mov ecx,[edx-2]");        /* cargar doble palabra */
	emit("rol ecx,16");             /* intercambiar palabra baja y alta */
	recover_reg_mem_handler('r');
	emit("ret");

	/* Lectura de palabra larga particionada */
	emit("readl_split:");
	emit("add edx,[ecx+12]");		/* añadir ptr a zona de memoria */
	emit("mov cx,[edx-2]");			/* cargar palabra alta */
	emit("shl ecx,16");             /* colocar palabra baja en ECX */
	emit("push ecx");               /* guardar palabra leida */
    emit("mov edx,[__access_address]");
    emit("add edx,byte 2");
    maskaddress("edx");
    emit("push edx");               /* salvar direccion alta de acceso */
    load_da_struct('r',"word",0);

    emit("test ecx,ecx");
    emit("jz readw_outofrange");    /* Si ECX = 0 -> fuera de rango (ERROR DE BUS) */

	emit("test dword[ecx+8],0FFFFFFFFh");/* comprobar si hay ptr de funcion manejadora */
	emit("jnz short readlower_callio");      /* si la hay, realizar llamada */

    emit("pop edx");                /* recuperar direccion */
	emit("add edx,[ecx+12]");		/* añadir ptr a zona de memoria */
    emit("xor ecx,ecx");
	emit("mov cx,[edx]");			/* cargar palabra alta */
    emit("pop edx");                /* recuperar palabra leida en EDX */
	emit("or ecx,edx");             /* cargar palabra alta en ECX */
	recover_reg_mem_handler('r');
	emit("ret");

    /* Lectura de palabra baja mediante manejador (E/S) */
    emit("readlower_callio:");
    recover_reg_mem_handler('r');
    emit("ret");

    /* Lectura palabra larga mediante manejador (E/S) */
	emit("readl_callio:");
	emit("add edx,byte 2");         /* comprobar posición palabra alta */
	emit("cmp edx,[ecx+4]");        /* si es mayor q la direccion alta, lectura partida */
	emit("ja short readl_iosplit");

	emit("sub edx,byte 2");         /* ptr a palabra baja */
	/* Lectura de E/S no particionada */
	core_exit();                    /* cambio de ambito -> C */
	emit("push edx");               /* salvar direccion de acceso */
	emit("push ecx");               /* salvar ptr. a la estructura */
	if(stack_calling) {             /* paso de parametros a la funcion */
		emit("push edx");
	} else {
		emit("mov eax,edx");        /* direccion de acceso */
	}
	emit("call dword[ecx+8]");		/* llamada a la función manejadora (primera palabra) */
	if(stack_calling)
		emit("add esp,byte 4");     /* incrementar ptr (parametros) */
	emit("pop ecx");				/* recuperar valor ptr a la estructura */
	emit("xchg eax,[esp]");			/* recoger EDX y dejar el resultado anterior en la pila */
	emit("add eax,byte 2");			/* para leer la siguiente palabra */
	if(stack_calling)
		emit("push eax");           /* parametro: direccion de acceso */

	emit("call dword[ecx+8]");		/* llamada a la función manejadora (segunda palabra) */
	if(stack_calling)
		emit("add esp,byte 4");     /* incrementar ptr (parametros) */
	emit("pop ecx");				/* resultado palabra alta */
	emit("shl ecx,16");				/* desplazar palabra alta a su sitio */
	emit("mov cx,ax");				/* cargar palabra baja */
	core_enter();				    /* volver a nuestro querido ensamblador */
	recover_reg_mem_handler('r');
	emit("ret");

    /* Lectura de palabra larga particionada mediante manejador (E/S) */
    emit("readl_iosplit:");
	emit("sub edx,byte 2");
	core_exit();
	if(stack_calling)
	{
		emit("push edx");           /* EDX = direccion de acceso */
	}
	else
	{
		emit("mov eax,edx");        /* direccion de acceso */
	}
	emit("call dword[ecx+8]");
	if(stack_calling)
		emit("add esp,byte 4");
	emit("mov ecx,eax");            /* resultado en EAX -> ECX */
	core_enter();                   /* volver al ensamblador */
    recover_reg_mem_handler('r');
    emit("ret");
}

/* Escritura en memoria de byte/palabra */
static void gen_wbw_handlers(int size)
{
	char z;

	switch(size)
	{
		case BYTE: z='b'; break;
		case WORD: z='w'; break;
		case LONG: return;        /* Tamaño no valido */
	}

	align(16);
	emit("writememory%s:",sizename[size]);

	if (emulate_group_0)
	{
		/* Testear accesos de memoria impar para tamaño WORD */
		if (size == WORD)
		{
			emit("test dl,1");
			emit("jz short .access_ok");	/* Acceso a memoria correcto */
			gen_g0_error_exception(ADDRESS_ERROR,READ_DATA_TYPE);
			emit(".access_ok:");
		}
	}

	load_da_struct('w',sizename[size],1);
	
	/* Testear si está fuera de rango */
    emit("test ecx,ecx");
	emit("jz write%c_outofrange",z);

	emit("test dword[ecx+8],0FFFFFFFFh"); /* comprobar si hay ptr. de funcion manejadora */
	emit("jnz short write%c_callio",z);   /* si lo hay, realizar llamada */

    /* Escritura nativa */
	emit("add edx,[ecx+12]");             /* añadir ptr. zona de memoria */
	if(z=='b') emit("xor edx,byte 1");    /* cambio de endianness si acceso byte */
	emit("pop ecx");                      /* recuperar dato a escribir */
	emit("mov [edx],%s",x86cx[size]);     /* cargar dato en memoria */
	emit("mov edx,[__access_address]");   /* recuperar direccion de acceso */
	emit("ret");

	emit("write%c_callio:",z);
	core_exit();
	emit("mov eax,edx");      /* direccion de acceso */
	emit("xor edx,edx");
	emit("mov %s,[esp+8]",x86dx[size]);/* dato para realizar escritura */
	if(stack_calling) {
		emit("push edx");     /* EDX = dato a escribir */
		emit("push eax");     /* EAX = direccion de acceso */
	}
	emit("call dword[ecx+8]");
	if(stack_calling)
		emit("add esp,byte 8");
	core_enter();
	recover_reg_mem_handler('w');
	emit("ret");

   /* Direccion fuera de rango o no mapeada: ERROR DE BUS */
	emit("write%c_outofrange:",z);
    if(emulate_group_0)
	    gen_g0_error_exception(BUS_ERROR,READ_DATA_TYPE);
    else
    {
        recover_reg_mem_handler('r');
		emit("or ecx,byte -1");            /* codigo de retorno fuera de limites */
		emit("ret");
    }
}

/* Escritura en memoria de doble palabra */ 
static void gen_wl_handler(void)
{
	align(16);
	emit("writememory%s:",sizename[LONG]);

	if (emulate_group_0)
    {
		/* Acceso a memoria impar? */
		emit("test dl,1");
		emit("jz short .access_ok");      /* Error de direccion */
		/* Acceso a memoria impar: ERROR DE DIRECCION */
		gen_g0_error_exception(ADDRESS_ERROR,WRITE_DATA_TYPE);
		emit(".access_ok:");
	}

	load_da_struct('w',sizename[WORD],1);
    emit("test ecx,ecx");
    emit("jz writew_outofrange");        /* Si ECX = 0 -> fuera de rango (ERROR DE BUS) */
    
	emit("writel_call:");
	emit("test dword[ecx+8],0FFFFFFFFh");
	emit("jnz short writel_callio");

    /* Escritura de palabra larga */
	emit("add edx,byte 2");
	emit("cmp edx,[ecx+4]");
	emit("ja near writel_split");

	/* Escritura no particionada */
	emit("add edx,[ecx+12]");
	emit("pop ecx");
	emit("rol ecx,16");
	emit("mov [edx-2],ecx");
	emit("rol ecx,16");
	emit("mov edx,[__access_address]");
	emit("ret");

	emit("writel_callio:");
	emit("add edx,byte 2");
	emit("cmp edx,[ecx+4]");
	emit("ja short writel_iosplit");
	
	emit("sub edx,byte 2");
	core_exit();
	emit("mov eax,edx");          /* direccion de acceso */
	emit("xor edx,edx");
	emit("mov dx,word[esp+10]");  /* dato */
	emit("push ecx");             /* salvar ptr. a la estructura para repetir llamada */
	emit("push eax");             /* salvar direccion para siguiente llamada */
	if(stack_calling)
	{
		emit("push edx");         /* EDX = dato a escribir */
		emit("push eax");         /* EAX = direccion de acceso */
	}
	emit("call dword[ecx+8]");
	if(stack_calling)
		emit("add esp,byte 8");

	emit("pop eax");              /* recuperar direccion de acceso */
	emit("pop ecx");              /* recuperar ptr. a la estructura */
	emit("add eax,byte 2");       /* incrementar direccion a 2a palabra */
	emit("xor edx,edx");
	emit("mov dx,word[esp+8]");   /* dato */
	if(stack_calling) {
		emit("push edx");         /* EDX = dato a escribir */
		emit("push eax");         /* EAX = direccion de acceso */
	}
	emit("call dword[ecx+8]");
	if(stack_calling)
		emit("add esp,byte 8");

	core_enter();

	recover_reg_mem_handler('w');
	emit("ret");

    emit("writel_iosplit:");
	core_exit();
	emit("mov eax,edx");                            /* direccion */
	emit("xor edx,edx");
	emit("mov dx,word[esp+%d]",airlock_stacksize+2);  /* dato */
	if(stack_calling)
	{
		emit("push edx");        /* EDX = dato a escribir */
		emit("push eax");        /* EAX = direccion de acceso */
	}
	emit("call dword[ebx+8]");
	if(stack_calling)
		emit("add esp,byte 8");

	core_enter();
	emit("mov edx,[esp+4]");
	emit("add edx,byte 2");
    recover_reg_mem_handler('r');
    emit("ret");

	emit("writel_split:");
	emit("add edx,[ecx+12]");
	emit("mov cx,[esp+2]");
	emit("mov [edx-2],cx");
    emit("mov edx,[__access_address]");
	emit("add edx,byte 2");
    maskaddress("edx");
    emit("push edx");
    
    load_da_struct('w',"word",0);

    emit("test ecx,ecx");
    emit("jz writew_outofrange");

	emit("test dword[ecx+8],0FFFFFFFFh");
	emit("jnz writelower_callio");

    emit("pop edx");              /* recuperar direccion de acceso */
	emit("add edx,[ecx+12]");
	emit("mov cx,[esp]");
	emit("mov [edx],cx");
    recover_reg_mem_handler('w');
    emit("ret");    

    emit("writelower_callio:");
    recover_reg_mem_handler('r');
    emit("ret");
}

/****************************************/
/* EXCEPCIONES del GRUPO 0				*/
/* ERROR DE BUS Y DE DIRECCION			*/
/* RESET se trata por separado			*/
/****************************************/
static void gen_group_0_exception(void)
{
	align(16);
	emit("group_0_exception:");

	emit("test byte[__execinfo],2");	/* testeo para ver si existe DOBLE ERROR DE BUS */
	emit("jz short .excflow");

	emit("or byte[__execinfo],4");		/* 68k detenido y muerto */
	emit("sub edi,50");					/* ciclos de reloj de la excepcion */
	/* Doble error de bus/direccion! -> solamente se recupera con RESET externo */
	emit("jmp execexit");

	emit(".excflow:");
	emit("or byte[__execinfo],2");      /* atendiendo ERROR DE BUS/DIRECCION (GRUPO 0) */
	emit("and byte[__execinfo],7Fh");   /* bit 7 de execinfo desactivado */
	/* hay q restar aqui por si se produce otra excepcion en el read que hay despues */
	emit("sub edi,50");
	emit("call readmemorydword");
	emit("push ecx");                       /* PC destino a la pila */
	sr2cx();                                /* recoge SR en CX y */
	emit("push ecx");                       /* lo guarda en la pila */
	supervisor();                           /* a modo supervisor */
	emit("and byte[__sr+1],27h");			/* modo supervisor, traza desact. */
	emit("test byte[__execinfo],20h");
	emit("jz short .bus_error");

	emit("mov ecx,esi");					/* cargar en ECX el PC con la base */
	emit("sub ecx,ebp");                    /* sustraer la base del PC */

	emit(".bus_error:");					/* en caso de error de bus, cargar PC */
	emit("mov ecx,[__io_fetchbased_pc]");
	emit("sub ecx,[__io_fetchbase]");		/* cargar el PC (sin base) en ECX */
	emit("mov edx,[__a7]");                 /* ptr de la pila a EDX */

    /* guardar en la pila del 68k el SR y el PC sin la base */
	emit("sub edx,byte 4");
	emit("call writememorydword");
	emit("pop ecx");						/* SR */
	emit("sub edx,byte 2");
	emit("call writememoryword");

	/**************************************************************/
	/* Informacion adicional de los errores de bus y de direccion */
	/**************************************************************/
	emit("mov cx,word [__inst_reg]");	/* cargar registro de instruccion en ECX */
	emit("sub edx,byte 2");				/* escritura de una palabra */
	emit("call writememoryword");		/* escribir en la pila el registro de instruccion */
	emit("mov ecx,ebx");				/* direccion accedida (almacenada en EBX) */
	emit("sub edx,byte 4");				/* escritura de una palabra doble */
	emit("call writememorydword");		/* escritura de direccion accedida */
	emit("xor ch,ch");					/* Limpiar byte alto de CX */
	emit("mov cl,byte[__g0_spec_info]");/* Cargar bits adicionales */
	emit("sub edx,byte 2");				/* escritura de una palabra */
	emit("call writememoryword");		/* escribir en la pila la palabra con info. adicc. */
	emit("mov [__a7],edx");
	emit("pop esi");                    /* devolver en ESI el PC que lleva a la rutina de trazado */

	get_new_pc();
	timing(0);				        /* Los ciclos ya se decrementaron previamente */
}

/****************************************/
/* Tipos de EXCEPCIONES del GRUPO 1 y 2 */
/* Dirección de la excepcion en EDX		*/
/****************************************/
static void gen_group_12_exception(void)
{
	align(16);
	emit("group_1_exception:");
	emit("group_2_exception:");

	emit("and byte[__execinfo],7Fh");       /* bit 7 de execinfo desactivado */
	emit("mov ecx,[__icusthandler]");
	
	/* comprobar si hay tabla funciones manejadoras */
	emit("test ecx,ecx");
	emit("jz short .vect_except");          /* si lo hay, ejecucion normal vectorizada */

	emit("test dword[ecx+edx*4],0FFFFFFFFh"); /* comprobar si hay ptr. funcion manejadora */
	emit("jz short .vect_except");          /* si lo hay, ejecucion normal vectorizada */
	
	/* generacion de exception personalizada (manejador) */
	core_exit();
	/* parametro (vector excepcion) */
	if (stack_calling)
		emit("push edx");
	else
		emit("mov eax,edx");
	emit("call dword[ecx+edx*4]");
	if (stack_calling)
		emit("add esp,byte 4");
	core_enter();

	emit("sub esi,ebp");                    /* retirar la base del PC */
	emit("ret");

	/* generacion de excepcion por tabla de vectores (nativo 68k) */
	emit(".vect_except:");
	emit("call readmemorydword");
	emit("push ecx");                       /* PC destino a la pila */
	sr2cx();                                /* recoge SR en CX y */
	emit("push ecx");                       /* lo guarda en la pila */
	supervisor();                           /* a modo supervisor */

	emit("and byte[__sr+1],27h");			/* modo supervisor, traza desact. */
	emit("mov ecx,esi");
	emit("sub ecx,ebp");                    /* sustraer la base del PC */
	emit("mov edx,[__a7]");                 /* ptr de la pila a EDX */

    /* guardar en la pila del 68k el SR y el PC sin la base */
	emit("sub edx,byte 4");
	emit("call writememorydword");	
	emit("pop ecx");                /* SR */

	emit("sub edx,byte 2");
	emit("call writememoryword");
	emit("mov [__a7],edx");
	emit("pop esi");/* devolver en ESI el PC que lleva a la rutina de trazado */
	emit("ret");
}

/***************************************************************************/

/* Violación de privilegio */
static void gen_privilege_violation(void)
{
	align(16);
	emit("privilege_violation:");
	emit("sub esi,byte 2");           /* guardar la ultima instruccion */
	emit("mov edx,20h");              /* direccion de la excepcion de v.p. */
	emit("call group_1_exception");
	get_new_pc();
	timing(34);
}

/* Obtencion de registro */
static void usereg(void)
{
	emit("and ebx,byte 7");	/* aislar bits de indice de registro */
}

/* Usar usereg siempre que exista modo de direccionamiento origen */
static void sel_usereg(void)
{
	switch(main_ea)
	{
		case dreg:
		case areg:
		case aind:
		case ainc:
		case adec:
		case adsp:
		case axdp: usereg();
	}
}

/* Testeo para obtencion de banderas */
static void selftest(int size)
{
	emit("test %s,%s", x86cx[size], x86cx[size]);
}

/***************************************************************************/

/* Obtener condicion: Menor que (N^V) */
/* Se activa la bandera S del x86 si condicion = true */
static void getcondition_l_s_ns(void)
{
	emit("push eax");
	emit("neg al");
	emit("xor al,ah");
	emit("pop eax");
}

/* Obtener condicion: Menor o igual que ((N^V)|Z) */
/* Se activa la bandera S del x86 si condicion = true */
static void getcondition_le_s_ns(void)
{
	emit("push eax");
	emit("neg al");
	emit("xor al,ah");
	emit("add ah,ah");
	emit("or al,ah");
	emit("pop eax");
}

static char optcc[5];
static char optrc[5];

/* Obtiene las condiciones y activa las banderas */
static void getcondition(int cc)
{
	switch(cc) {
		case T_CC:
		case F_CC:
				break;
		case HI_CC:/* a (Z flag or C flag clear) */
			emit("test ah,41h");
			sprintf(optcc, "z");
			sprintf(optrc, "nz");
			break;
		case LS_CC:/* be (Z flag or C flag set) */
			emit("test ah,41h");
			sprintf(optcc, "nz");
			sprintf(optrc, "z");
			break;
		case CC_CC:/* nc (C flag clear) */
			emit("test ah,1");
			sprintf(optcc, "z");
			sprintf(optrc, "nz");
			break;
		case CS_CC:/* c (C flag set) */
			emit("test ah,1");
			sprintf(optcc, "nz");
			sprintf(optrc, "z");
			break;
		case NE_CC:/* ne (Z flag clear) */
			emit("test ah,40h");
			sprintf(optcc, "z");
			sprintf(optrc, "nz");
			break;
		case EQ_CC:/* e ( Z flag set) */
			emit("test ah,40h");
			sprintf(optcc, "nz");
			sprintf(optrc, "z");
			break;
		case VC_CC:/* no (V flag clear) */
			emit("test al,1");
			sprintf(optcc, "z");
			sprintf(optrc, "nz");
			break;
		case VS_CC:/* o (V flag set) */
			emit("test al,1");
			sprintf(optcc, "nz");
			sprintf(optrc, "z");
			break;
		case PL_CC:/* ns (N flag clear) */
			emit("test ah,ah");
			sprintf(optcc, "ns");
			sprintf(optrc, "s");
			break;
		case MI_CC:/* s (N flag set) */
			emit("test ah,ah");
			sprintf(optcc, "s");
			sprintf(optrc, "ns");
			break;
		case GE_CC:/* ge */
			getcondition_l_s_ns();
			sprintf(optcc, "ns");
			sprintf(optrc, "s");
			break;
		case LT_CC:/* l */
			getcondition_l_s_ns();
			sprintf(optcc, "s");
			sprintf(optrc, "ns");
			break;
		case GT_CC:/* g */
			getcondition_le_s_ns();
			sprintf(optcc, "ns");
			sprintf(optrc, "s");
			break;
		case LE_CC:/* le */
			getcondition_le_s_ns();
			sprintf(optcc, "s");
			sprintf(optrc, "ns");
			break;
	}
}

/* Actualizar banderas */
static void flags(void)
{
	emit("lahf");
	emit("seto al");
}

/* Actualizar banderas del falso CCR, V = 0 */
static void flags_v0(void)
{
	emit("lahf");
	emit("xor al,al");    /* V = 0 */
}

/* Realiza el calculo de banderas segun el tipo de operacion (logica o binaria) */
static void flags_logical(int is_logical)
{
	if(is_logical)
		flags_v0();
	else
		flags();
}

/* Cargar una de las banderas del x86 en la bandera Z del 68k */
static void flag_to_z(char* f)
{
	int ln = linetag; 

	linetag += 2;
	emit("j%s short ln%d", f, ln);     /* si la bandera esta activa */
	emit("and ah,0BFh");               /* bandera Z 68k a 0 */
	emit("jmp short ln%d", ln + 1);    /* y salir */
	emit("ln%d:", ln);
	emit("or ah,40h");                 /* bandera Z 68k a 1 */
	emit("ln%d:", ln + 1);
}

/* Bandera de acarreo -> bandera X */
static void c2x(void)
{
	emit("setc [__xflag]");
}

/* Bandera en falso CCR (AH) -> bandera X */
static void fc2x(void)
{
	emit("test ah,1");
	emit("setnz [__xflag]");
}

/* Ajusta el valor de la bandera Z para no modificarse al CCR */
static void adjzero(char *reg)
{
	int ln = linetag++;

	emit("jnz short ln%d", ln);
	emit("or %s,0BFh", reg);
	emit("and ah,%s", reg);
	emit("ln%d:", ln);
}

/* ABCD: COMPORTAMIENTO BANDERA V NO DOCUMENTADO por Motorola!! */
static void undoc_abcd_v_flag(void)
{
   	int ln=linetag++;

    /* Resultado sin ajustar en CL, ajustado AL */
    emit("shr al,7");       /* bandera V al bit 0 */
    emit("test cl,cl");
    emit("jns short ln%d",ln);
	emit("xor al,al");       /* bandera V = 0 */
    emit("ln%d:",ln);
}

/* SBCD: COMPORTAMIENTO BANDERA V NO DOCUMENTADO por Motorola!! */
static void undoc_sbcd_v_flag(void)
{
   	int ln=linetag;

    linetag+=2;
    /* Resultado sin ajustar en CL, ajustado AL */
    emit("test al,al");             /* activa banderas */
    emit("jns short ln%d",ln);
    emit("xor al,al");              /* AL = 0 */
    emit("jmp short ln%d",ln+1);    /* bandera V = 0 y salir */
    emit("ln%d:",ln);               /* si no, signo de CL = bandera V */
    emit("test cl,cl");             /* activa banderas */
    emit("sets al");
    emit("ln%d:",ln+1);
}

/* NBCD: COMPORTAMIENTO BANDERA V NO DOCUMENTADO por Motorola!! */
static void undoc_nbcd_v_flag(void)
{
   	int ln=linetag;

    linetag+=2;

	emit("mov bh,al");               /* salvar resultado ajustado */

    /* Resultado sin ajustar en CL, ajustado AL */
    emit("test al,al");
    emit("jns short ln%d",ln);
    emit("xor al,al");
    emit("jmp short ln%d",ln+1);     /* bandera V = 0 y salir */
    emit("ln%d:",ln);                /* si no, signo de CL = bandera V */
    emit("test cl,cl");
    emit("sets al");

    emit("ln%d:",ln+1);
}

/* Chequear violación de privilegio */
static void priv_check(void)
{
	emit("test byte[__sr+1],20h");	     /* testear bit supervisor */
	emit("jz privilege_violation");
}

/*****************************************************************************/
/* GENERACION DE DIRECCION EFECTIVA                                          */
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

/* Calcula el registro empleado en los direccionamientos */
static void calc_ea_reg(int reg, char *regs)
{
	if(reg == -1)
        sprintf(regs,"ebx*4");
	else
        sprintf(regs,"%d",reg*4);
}

/* Ajusta el registro indice de direccion en modo predecremento */
static void adec_idx_adj(int size, int reg)
{
	if(size == BYTE)
	{
		switch(reg)
		{
			case -1: emit("cmp bl,7");
					 emit("adc edx,byte -2");
					 break;
			case 7:  emit("sub edx,byte 2");
					 break;
			default: emit("dec edx");
		}
	}
	else
	{
		emit("sub edx,byte %d", size);
	}
}

/* Precalculo de direccion efectiva */
/* La direccion se devuelve en EDX si la hay */
static void ea_step_precalc(int size, enum eamode mode, int reg)
{
	char regs[10];
    
	calc_ea_reg(reg, regs);
        
	switch(mode) {
	    case dreg:
        case areg: break;	/* No hay direccion, es el registro */
	    case aind:
        case ainc:
        case adec:			/* Direccionamiento indirecto a registro */
    		emit("mov edx,[__areg+%s]",regs);	
    		if(mode == adec)
				adec_idx_adj(size,reg);
		    break;
	    case adsp:
		    emit("movsx edx,word[esi]");      /* cargar desplazamiento */
			inc_ptr_opcodes();
		    emit("add edx,[__areg+%s]", regs);/* añadir direccion indirecta registro */
		    break;
	    case axdp:
		    emit("call decode_ext");
		    emit("add edx,[__areg+%s]", regs);
		    break;
    	case absw:
		    emit("movsx edx,word[esi]");    /* cargar direccion */
			inc_ptr_opcodes();
		    break;
    	case absl:
		    emit("mov edx,[esi]");          /* cargar direccion */
	    	emit("add esi,byte 4");         /* incrementar ptr. a opcodes */
	    	emit("rol edx,16");             /* intercambiar palabra baja y alta */
	    	break;
    	case pcdp:
	    	emit("movsx edx,word[esi]");    /* cargar desplazamiento */
	    	emit("add edx,esi");            /* añadir PC */
	    	emit("sub edx,ebp");            /* sustraer la base */
			inc_ptr_opcodes();
	    	break;
    	case pcxd:
    		emit("call decode_ext");
    		emit("add edx,esi");            /* añadir PC */
    		emit("sub edx,ebp");            /* sustraer la base */
    		emit("sub edx,byte 2");         /* decrementar ptr. (ESI incr. anteriormente) */
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
	char regs[10];

	calc_ea_reg(reg, regs);

	switch(mode)
	{
		case dreg: emit("mov ecx,[__dreg+%s]", regs); break;	/* Carga directa de registro */
		case areg: 
			emit("mov ecx,[__areg+%s]", regs); break;
		case aind: case ainc: case adec:
		case adsp: case axdp:
		case absw: case absl:
		case pcdp: case pcxd:
			emit("call readmemory%s", sizename[size]); break;	/* Lectura de memoria */
		case immd:
			switch(size)
			{
				case BYTE:
				case WORD:
					emit("mov cx,[esi]");	/* Cargar byte o palabra */
					inc_ptr_opcodes();
					break;
				case LONG:
					emit("mov ecx,[esi]");	/* Cargar palabra larga */
					emit("add esi,byte 4");	/* incrementar ptr. a opcodes en tamaño LONG */
					emit("rol ecx,16");		/* Intercambiar palabra baja y alta */
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
	char regs[10];

	calc_ea_reg(reg, regs);

	switch(mode)
	{
		case dreg: emit("movsx ecx,word[__dreg+%s]", regs); break;	/* Carga directa de registro */
		case areg: emit("movsx ecx,word[__areg+%s]", regs); break;
		case aind: case ainc: case adec:
		case adsp: case axdp:
		case absw: case absl:
		case pcdp: case pcxd:
			emit("call readmemory%s", sizename[WORD]);              /* Lectura de memoria */
			emit("movsx ecx,cx");
			break;
		case immd:
			emit("movsx ecx,word[esi]");                            /* Cargar palabra */
			inc_ptr_opcodes();
			break;
		default:
			emit("#error ea_step_read_signword");
			break;
	}
}

/* Operación de escritura */
static void ea_step_write(int size, enum eamode mode, int reg)
{
	char regs[10];

	calc_ea_reg(reg, regs);

	switch(mode)
	{
		case dreg:
			emit("mov [__dreg+%s],%s", regs, x86cx[size]); break;	/* Directa a registro */
		case aind: case ainc: case adec:
		case adsp: case axdp:
		case absw: case absl:
			emit("call writememory%s", sizename[size]); break;
		default:
			emit("#error ea_step_write"); break;
	}
}

/* Postcalculo de direccion efectiva */
static void ea_step_postcalc(int size, enum eamode mode, int reg)
{
	char regs[10];

	calc_ea_reg(reg, regs);

	switch(mode)
	{
		case ainc:
			if(size == BYTE) {
				switch(reg) {
					case -1: emit("cmp bl,7");
							 emit("sbb edx,byte -2");
							 break;
					case 7:  emit("add edx,byte 2");
							 break;
					default: emit("inc edx");
				}
			} else {
				emit("add edx,byte %d", size);
			}
			/* continua, OJO no lleva break!! */
		case adec:
			emit("mov [__areg+%s],edx", regs);		/* Almacenar direccion ya predecrementada */
			break;
		case dreg: case areg:
		case aind: case adsp: case axdp:
		case absw: case absl:
		case pcdp: case pcxd:
		case immd:			/* Operando inmediato */
	
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

/* Codigo anterior a las rutinas de manejo de instrucciones */
static void gen_man_code(void)
{
	gen_header();
	gen_vars();
	gen_api();
	gen_basefunction();
	gen_decode_ext();
	gen_rbw_handlers(BYTE);
	gen_rbw_handlers(WORD);
	gen_rl_handler();
	gen_wbw_handlers(BYTE);
	gen_wbw_handlers(WORD);
	gen_wl_handler();
	if (emulate_group_0)
		gen_group_0_exception();
	gen_group_12_exception();
	gen_privilege_violation();
	gen_flush_interrupts();
}


/******************************************************************************/
/* RUTINAS DE MANEJO DE INSTRUCCIONES                                         */
/******************************************************************************/

/* MOVE */
static void i_move(void)
{
	int cycles;
    
	sel_usereg();
	main_ea_load();
   	ea_store(main_size, main_dest_ea, main_reg);
	selftest(main_size);
	flags_v0();

	cycles = (main_size == LONG)?move_l_cycles[main_ea][main_dest_ea]:\
								move_bw_cycles[main_ea][main_dest_ea];
	timing(cycles);
}

/* QUICK MOVE */
static void i_moveq(void)
{
	emit("movsx ecx,bl");                       /* Cargar valor inmediato */
	emit("mov [__dreg+%d],ecx", main_reg<<2);	/* y llevarlo a registro datos */
	selftest(BYTE);
	flags_v0();

	timing(4);
}

/* Operación a registro de direccion */
static void op_to_areg(char *s)
{
	sel_usereg();             /* registro a usar */
	main_ea_load_signed();          /* cargar dato */
	emit("%s [__areg+%d],ecx", s, main_reg<<2);    /* operación a registro de direcciones */
}

/* MOVE ADDRESS */
static void i_movea(void)
{
	op_to_areg("mov");
	timing(4+main_ea_cycles());
}

/* ADDA or SUBA */
static void addsuba(char *op)
{
	int base_cycles;
    
	op_to_areg(op);
	if(main_size == LONG)
	{
		base_cycles=6;
        switch(main_ea)    /* Incrementar en 2 si la ea es directa a registro o imm. */
        {
			case areg:
            case dreg:
            case immd:
				base_cycles+=2;	break;
        }
	}
	else
		base_cycles=8;

	timing(base_cycles+main_ea_cycles());
}

/* ADD ADDRESS */
static void i_adda(void) {addsuba("add");}

/* SUB ADDRESS */
static void i_suba(void) {addsuba("sub");}

/* COMPARE ADDRESS */
static void i_cmpa(void)
{
	op_to_areg("cmp");
	flags();
	timing(6+main_ea_cycles());
}

/* MOVE TO STATUS REGISTER */

static void i_move_to_sr(void)
{
	main_size=WORD;

	priv_check();           /* La operación requiere modo supervisor */
	sel_usereg();
	main_ea_load();
	cx2sr();
	timing_cp(12+main_ea_cycles());
}

/* MOVE TO CCR */
static void i_move_to_ccr(void)
{
	main_size=WORD;

	sel_usereg();
	main_ea_load();
	cl2ccr();
	timing(12+main_ea_cycles());
}

/* MOVE FROM STATUS REGISTER */
static void i_move_from_sr(void)
{
	int cycles;

	main_size=WORD;
	sel_usereg();
	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (load) */
		main_ea_rmw_load();

	sr2cx();
	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (store) */
		main_ea_rmw_store();
	else
		main_ea_store();

	cycles = (main_ea == dreg)?6:8+main_ea_cycles();
	timing(cycles);
}

/* Operación a CCR */ 
static void op2ccr(char* op)
{
	ccr2cl();

	emit("%s cl,[esi]",op);     /* Operación -> CL */
	inc_ptr_opcodes();
	cl2ccr();
	timing(20);
}

/* Operación a STATUS REGISTER */
static void op2sr(char*op)
{
	priv_check();           /* La operación requiere privilegios. acceso al SR */
	sr2cx();
	emit("%s cx,[esi]",op);     /* Operación -> CX */
	inc_ptr_opcodes();
	cx2sr();
	timing_cp(20);
}

/* Operaciones inmediatas OR, AND, EOR al CCR y SR */
static void i_ori_ccr(void) {op2ccr("or" );}
static void i_andi_ccr(void) {op2ccr("and");}
static void i_eori_ccr(void) {op2ccr("xor");}
static void i_ori_sr(void) {op2sr("or" );}
static void i_andi_sr(void) {op2sr("and");}
static void i_eori_sr(void) {op2sr("xor");}

/* CLEAR */
static void i_clr(void)
{
	int cycles;

	sel_usereg();
	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (load) */
		main_ea_rmw_load();

	emit("xor ecx,ecx");    /* ECX = 0, dato a cargar en memoria */

	if ((main_ea != dreg) && dummyreads)	/* Lectura tonta (store) */
		main_ea_rmw_store();
	else
		main_ea_store();

	emit("mov ax,4000h");       /* bandera Z = 1, resto = 0 */

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
	sel_usereg();                    /* uso de registro */
	main_ea_load();                  /* carga de memoria */
    selftest(main_size);             /* testeo */
	flags_v0();                      /* bandera V = 0 */
	timing(4+main_ea_cycles());
}

/* Siempre afecta a la bandera X (excepto para #,An que no afecta a ninguna) */
static void op_quick(char* op)
{
	int cycles;

	sel_usereg();
	if(main_ea == dreg)
	{
		/* Realizar operación directa a registro de datos */
		emit("%s %s[__dreg+ebx*4],byte %d",op,sizename[main_size],quickvalue[main_qv]);
		flags();
		c2x();
		cycles=4;
	}
	else if(main_ea == areg)
	{
		/* Realizar operación directa a registro de direcciones */
		emit("%s dword[__areg+ebx*4],byte %d",op,quickvalue[main_qv]);
		cycles=4;
        if((main_size==WORD) && (op[0]=='s')) cycles+=4;	/* penalización en subq.w #,An */
	}
	else
	{
		main_ea_rmw_load();		/* Carga de operando */

		/* Operación */
		emit("%s %s,byte %d",op,x86cx[main_size],quickvalue[main_qv]);
		flags();
		c2x();
		main_ea_rmw_store();
		cycles=8+main_ea_cycles();
	}
	if(main_size == LONG) cycles+=4;
	timing(cycles);
}

/* ADD QUICK */
static void i_addq(void) {op_quick("add");}

/* SUB QUICK */
static void i_subq(void) {op_quick("sub");}

/* Operación a registro de datos */
/* affectx -> afecta a bandera X */
/* logical -> instrucción logica */
static void op_to_dn(char* op,int affectx,int logical)
{
	int cycles;

	sel_usereg();		/* Registro a usar */
	main_ea_load();			/* Carga de memoria */
	emit("%s [__dreg+%d],%s", op,main_reg<<2,x86cx[main_size]);	/* Operación a R.D. */
	/* si afecta a X -> X = C */
	if(affectx) c2x();
	/* Si es logica -> V = 0 */
	flags_logical(logical);

	cycles=4+main_ea_cycles();
	if(main_size == LONG)
	{
		cycles+=2;
		if(op[0]!='c')    /* Penalizacion de timing */
		{
			switch(main_ea)
			{
			    case areg:
                case dreg:
                case immd:
				    cycles+=2;
				    break;
			}
		}
	}
	timing(cycles);
}

/* Operaciones directa a registro de datos: CMP, ADD, SUB, AND y OR */
static void i_cmp_dn(void) {op_to_dn("cmp",0,0);}
static void i_add_dn(void) {op_to_dn("add",1,0);}
static void i_sub_dn(void) {op_to_dn("sub",1,0);}
static void i_and_dn(void) {op_to_dn("and",0,1);}
static void i_or_dn (void) {op_to_dn("or",0,1);}

/* Operación a dirección efectiva */
static void op_to_ea(char* op,int logical)
{
	int cycles;

	sel_usereg();
	main_ea_rmw_load();
	emit("%s %s,[__dreg+%d]", op, x86cx[main_size], main_reg<<2);
	/* Si es una instruccion logica, no afecta a la bandera X , si no X = C */
	if(!logical) c2x();
	/* Si es logica -> V = 0 */
	flags_logical(logical);

	main_ea_rmw_store();
	cycles=8+main_ea_cycles();

	if(main_size == LONG) cycles+=4;
	if((op[0]=='x') && (main_ea == dreg))	 /* EOR Dn,Dn requiere 4 ciclos menos de lo esperado */
		cycles-=4;

	timing(cycles);
}

/* Operaciones a dirección efectiva: EOR, ADD, SUB, AND y OR */
static void i_eor_ea(void) {op_to_ea("xor",1);}
static void i_add_ea(void) {op_to_ea("add",0);}
static void i_sub_ea(void) {op_to_ea("sub",0);}
static void i_and_ea(void) {op_to_ea("and",1);}
static void i_or_ea (void) {op_to_ea("or" ,1);}

/*
** c1: Ciclos totales para #,Dn (byte/word)
** c2: Ciclos totales para #,Dn (long)
** c3: Ciclos basicos para #,M  (byte/word)
** c4: Ciclos basicos para #,M  (long)
*/
/* wback = devolver resultado a memoria */
static void im_to_ea(char* op,int wback,int affectx,int logical, int c1,int c2,int c3,int c4)
{
	int cycles;

	sel_usereg();
	switch(main_size)
	{
	    case BYTE:
	    case WORD:
		    emit("mov cx,[esi]");		/* cargar palabra */
			inc_ptr_opcodes();
		    break;
	    case LONG:
		    emit("mov ecx,[esi]");		/* cargar doble palabra */
		    emit("add esi,byte 4");		/* incrementar ptr opcodes */
		    emit("rol ecx,16");
		    break;
	}

	if(main_ea == dreg)
	{
		emit("%s [__dreg+ebx*4],%s",op,x86cx[main_size]);	/* realizar operación */
		if(affectx) c2x();
		flags_logical(logical);
		cycles = (main_size < LONG)?c1:c2;
	}
	else
	{
		emit("push ecx");	/* primer operando a la pila */
		/* dependiendo del modo, carga con modificacion o solo carga */
		if(wback) 
			main_ea_rmw_load();
		else 
			main_ea_load();
			
		emit("%s %s,[esp]",op,x86cx[main_size]);			/* realizar operación */
		if(affectx) c2x();
		flags_logical(logical);
		emit("add esp,byte 4");	        /* no interesa el valor de ECX de la pila */
		if(wback) main_ea_rmw_store();
		cycles = (main_size < LONG)?c3:c4;
		cycles+=main_ea_cycles();
	}
	timing(cycles);
}

/* Instrucciones inmediatas */
static void i_addi(void) {im_to_ea("add",1,1,0,8,16,12,20);}
static void i_subi(void) {im_to_ea("sub",1,1,0,8,16,12,20);}
static void i_cmpi(void) {im_to_ea("cmp",0,0,0,8,14,8,12);}
static void i_andi(void) {im_to_ea("and",1,0,1,8,14,12,20);}
static void i_ori (void) {im_to_ea("or" ,1,0,1,8,16,12,20);}
static void i_eori(void) {im_to_ea("xor",1,0,1,8,16,12,20);}


/* op = Operation / needxf = requiere bandera X / affectx = afecta bandera X */
/* rotate = indica si la operación es de rotación o de desplazamiento */
static void srop_reg(char* op,int needxf,int affectx,int asl,int rotate)
{
	int cycles, i;
	char tmps[5];
    
	usereg();
	cycles = (main_size == LONG)?8:6;
	/* Desplazamientos a la derecha no afectan a V */
	if(direction[main_dr]=='r') asl=0;
	
	if(main_ir == 1)    /* Contador de bit en registro */
    {
		int myline=linetag++;
		emit("xor ecx,ecx");
		emit("mov cl,[__dreg+%d]",main_reg<<2);
		emit("and cl,byte 63");	/* Bits a desplazar, modulo 64 */
		emit("jnz short ln%d",myline);

		/* No hay que realizar desplazamiento o rotacion */
		ea_load(main_size,dreg,-1);
		selftest(main_size);
		flags_v0();
		if(needxf) {/* ROXL/ROXR: bandera C = bandera X */
			emit("and ah,0FEh");    /* desactiva el bit de acarreo C */
			emit("or ah,[__xflag]");/* C = X */
		}
		timing(cycles);


		/* El numero de bits a desplazar/rotar != 0 */
		emit("ln%d:",myline);
		emit("sub edi,ecx");     /* ciclos de reloj = bits a desplazar * 2 */
		emit("sub edi,ecx");
		sprintf(tmps,"cl");      /* El nº de bits esta en CL */
	}
    else                         /* contador inmediato */
    {
		sprintf(tmps,"%d",quickvalue[main_reg]);	/* tmps = contador bits */
		cycles+=(quickvalue[main_reg]<<1);
	}

	if(asl)          /* desplazamiento arith a la izq */
	{
		switch(tmps[0])
		{
			case 'c': /* bits a desplazar en registro CL */
				emit("mov edx,[__dreg+ebx*4]"); /* cargar operando */
				emit("xor al,al");	/* bandera V = 0 */
				emit("ln%d:",linetag);
				emit("add %s,%s", x86dx[main_size],x86dx[main_size]);
				emit("lahf");	/* parte alta del CCR */
				emit("seto ch");
				emit("or al,ch");/* parte baja CCR */
				emit("dec cl");
				emit("jnz short ln%d",linetag++);
				emit("mov [__dreg+ebx*4],%s",x86dx[main_size]);		/* cargar resultado */
				if(affectx)
					fc2x();   /* Falsa bandera C -> bandera X */
				break;
			case '1': /* numero de bits = 1 */
				emit("shl %s[__dreg+ebx*4],1",sizename[main_size]);	/* desplazar un solo bit */
				flags();
				if(affectx) c2x();
				break;
			default: /* numero de bits > 1 */
				emit("mov edx,[__dreg+ebx*4]");     /* cargar operando */
				emit("xor al,al");                  /* bandera O = 0 */

				/* se realiza for para obtener valor de bandera O */
				/* con instruccion SHL solo se calcula la bandera O para SHL x,1 !!!! */
				for(i='1';i<=tmps[0];i++) {
					emit("add %s,%s", x86dx[main_size],x86dx[main_size]);
					if(i == tmps[0]) {
						emit("lahf");
					}
					emit("seto ch");   /* CH = bandera de desbordamiento */
					emit("or al,ch");  /* llevar bandera de desbordamiento a CCR */
				}

				emit("mov [__dreg+ebx*4],%s",x86dx[main_size]);	/* cargar resultado */
				if(affectx)
					fc2x();   /* Falsa bandera C -> bandera X */
				break;
		}
	}
	else                /* rotacion o desplazamiento logico */
	{
		if(rotate)      /* rotacion de bits */
		{
			emit("mov edx,[__dreg+ebx*4]");    /* dato a rotar */
			if(needxf)
			{
				emit("mov al,[__xflag]");
			}
			else
			{
				emit("xor al,al");
			}

			switch(tmps[0])
			{
				case 'c': /* bits a rotar en registro CL */
					emit("cmp cl,32");
					emit("jb short ln%d",linetag);
					emit("sub cl,31");
					if(needxf)
					{
						emit("shr al,1");
					}
					emit("%s%c %s,31", op,direction[main_dr],x86dx[main_size]);
					emit("%s%c %s,%s", op,direction[main_dr],x86dx[main_size],tmps);
					emit("jmp short ln%d",linetag + 1);
					emit("ln%d:",linetag++);
					if(needxf)
					{
						emit("shr al,1");
					}
					emit("%s%c %s,%s", op,direction[main_dr],x86dx[main_size],tmps);
					emit("ln%d:",linetag++);
					break;

				default: /* numero de bits > 1 */
					if(needxf)
					{
						emit("shr al,1");
					}
					emit("%s%c %s,%s", op,direction[main_dr],x86dx[main_size],tmps);
					break;
			}

			emit("adc al,al");
			emit("test %s,%s", x86dx[main_size],x86dx[main_size]);
			emit("lahf");
			emit("or ah,al");
			if(affectx)
			{
				emit("mov [__xflag],al");
			}
			emit("xor al,al");
			emit("mov [__dreg+ebx*4],%s",x86dx[main_size]);
		}
		else          /* desplazamiento a la izq/der */
		{
			if(needxf)
			{
				emit("mov al,[__xflag]");
			}
			else
			{
				emit("xor al,al");
			}

			switch(tmps[0])
			{
				case 'c': /* bits a desplazar en registro CL */
					emit("cmp cl,32");
					emit("jb short ln%d",linetag);
					emit("sub cl,31");
					if(needxf)
                    {
						emit("shr al,1");    /* bandera C -> carry */
					}
					emit("%s%c %s[__dreg+ebx*4], 31", op,direction[main_dr],sizename[main_size]);
					emit("%s%c %s[__dreg+ebx*4], cl", op,direction[main_dr],sizename[main_size]);
                    
					emit("jmp short ln%d",linetag + 1);
					emit("ln%d:",linetag++);
					if(needxf)
                    {
						emit("shr al,1");    /* bandera C -> carry */
					}
					emit("%s%c %s[__dreg+ebx*4],%s", op,direction[main_dr],sizename[main_size],tmps);
					emit("ln%d:",linetag++);
					break;

				default:/* numero de bits > 1 */
					if(needxf)
					{
						emit("shr al,1");	/* bandera V -> C x86 */
					}
					emit("%s%c %s[__dreg+ebx*4],%s",op,direction[main_dr],sizename[main_size],tmps);
					break;
			}

			emit("lahf");
			if(affectx) c2x();
		}
	}
	timing(cycles);
}

/* Logical, Asimetric Shifts (Register Operand) */
static void i_lsx_reg(void) {srop_reg("sh",0,1,0,0);}
static void i_asx_reg(void) {srop_reg("sa",0,1,1,0);}

/* Rotates (Register Operand) */
static void i_rox_reg(void) {srop_reg("ro",0,0,0,1);}
static void i_rxx_reg(void) {srop_reg("rc",1,1,0,1);}


/* op = Operation / needxf = requiere bandera X / affectx = afecta bandera X / vf = calcular bandera V */
/* rotate = indica si la operación es de rotación o de desplazamiento */
static void srop_mem(char* op,int needxf,int affectx,int vf,int rotate)
{
	if(direction[main_dr]=='r') vf=0;	/* Desplazamientos a la derecha no afectan a V */
	main_size=WORD;			/* Operación restringida a tamaño palabra */
	sel_usereg();
	main_ea_rmw_load();
	if(needxf)
	{
		emit("xor al,al");
		emit("shr byte[__xflag],1");			/* bandera X -> C x86 */
	}
	else
	{
		if(rotate) emit("xor al,al");
	}
	emit("%s%c cx,1",op,direction[main_dr]);
	if(rotate)
	{
		emit("adc al,al");	/* AL = C x86 */
		emit("test cx,cx");	/* testear resultado para activacion de banderas */
		emit("lahf");		/* activación de banderas */
		emit("or ah,al");	/* cargar acarreo (bandera C) */
		if(affectx) 
			emit("mov [__xflag],al");
		emit("xor al,al");
	}
	else
	{
		if(affectx) c2x();
		if(vf)
			flags();
		else
			flags_v0();
	}
	main_ea_rmw_store();
	timing(8+main_ea_cycles());
}

/* Logical, Asimetric Shifts (Memory Operand) */
static void i_lsx_mem(void) {srop_mem("sh",0,1,0,0);}
static void i_asx_mem(void) {srop_mem("sa",0,1,1,0);}

/* Rotates (Memory Operand) */
static void i_rox_mem(void) {srop_mem("ro",0,0,0,1);}
static void i_rxx_mem(void) {srop_mem("rc",1,1,0,1);}

/* Variable que indica la emision de la etiqueta r_bra_b */
static int created_bra_b=0;

/* BRANCH ALWAYS (BYTE OPERAND) */
static void i_bra_b(void)
{
	if(!created_bra_b)
	{
		emit("r_bra_b:");
		created_bra_b=1;
	}
	emit("movsx ecx,bl");	/* Cargar operando (desplazamiento PC) con extension de signo */
	emit("add esi,ecx");	/* Añadir al PC */
	timing(10);
}

/* Variable que indica la emision de la etiqueta r_bra_w */
static int created_bra_w=0;

/* BRANCH ALWAYS (WORD OPERAND) */
static void i_bra_w(void)
{
	if(!created_bra_w)
	{
		emit("r_bra_w:");
		created_bra_w=1;
	}
	emit("movsx ecx,word[esi]");/* Cargar operando (desp. PC) con extension de signo */
	emit("add esi,ecx");        /* Añadir al PC */
	timing(10);
}

/* BRANCH TO SUBROUTINE (BYTE OPERAND) */
static void i_bsr_b(void)
{
	emit("movsx edx,bl");   /* desplazamiento para el PC extendido a EDX */
	emit("mov ecx,esi");    /* cargar PC + base en ECX */
	emit("sub ecx,ebp");    /* PC sin base */
	emit("add esi,edx");    /* ESI = nuevo PC */
	ea_store(LONG,adec,7);  /* Almacenar en la pila PC sin base */
	timing(18);
}

/* BRANCH TO SUBROUTINE (WORD OPERAND) */
static void i_bsr_w(void)
{
	emit("movsx edx,word[esi]");/* desplazamiento para el PC extendido a EDX */
	emit("lea ecx,[esi+2]");    /* cargar PC + 2 en ECX */
	emit("sub ecx,ebp");        /* PC sin base */
	emit("add esi,edx");        /* ESI = nuevo PC */
	ea_store(LONG,adec,7);      /* Almacenar en la pila PC sin base */
	timing(18);
}

/* BRANCH CONDITIONALLY (BYTE OPERAND) */
static void i_bcc_b(void)
{
	getcondition(main_cc);
	emit("j%s near r_bra_b",optcc);
	timing(8);
}

/* BRANCH CONDITIONALLY (WORD OPERAND) */
static void i_bcc_w(void)
{
	getcondition(main_cc);
	emit("j%s near r_bra_w",optcc);
	inc_ptr_opcodes();/* saltar desplazamiento */
	timing(12);
}

/* TEST FALSE, DECREMENT AND BRANCH */
static void i_dbra(void)
{
	emit("r_dbra:");
	usereg();
    emit("sub word[__dreg+ebx*4],1");	/* comparacion */
    emit("jnc near r_bra_w");
	inc_ptr_opcodes();/* saltar desplazamiento */
    timing(14);
}

/* TEST TRUE, DECREMENT AND BRANCH */
static void i_dbt(void)
{
	inc_ptr_opcodes();/* saltar desplazamiento */
    timing(12);
}

/* TEST CONDITION, DECREMENT AND BRANCH */
static void i_dbcc(void)
{
	getcondition(main_cc);
	emit("j%s near r_dbra",optrc);
	inc_ptr_opcodes();/* saltar desplazamiento, no se realiza salto */
    timing(12);
}

/* SET ACORDING TO CONDITION */
static void i_scc(void)
{
	int cycles;
    
	main_size = BYTE;				/* Operacion solo de byte */
	sel_usereg();
	cycles = (main_ea == dreg)?4:8;

	if ((main_ea != dreg) && dummyreads)    /* Lectura tonta */
	{
		main_ea_rmw_load();
	}
	
	if(main_cc > 1)      /* <=1 condicion true (todos 1s) o false (todos 0s) */
	{
		if (main_ea == dreg)
		{
            emit("xor ecx,ecx");	/* ECX = 0 */
			getcondition(main_cc);	/* obtener condicion de la instruccion */
			emit("set%s cl",optcc);	/* fijar valor de CL a condicion */
            emit("sub edi,ecx");	/* decrementar ciclos si procede */
            emit("sub edi,ecx");
			emit("neg cl");			/* todos 1s o 0s */
		}
		else
		{
			getcondition(main_cc);
			emit("set%s cl",optcc);
			emit("neg cl");			/* todos 1s o 0s */
		}
	}
	else
	{
		emit("mov cl,%d",(main_cc^1)*0xFF);
		if (main_ea == dreg)
		{
            if(main_cc == T_CC) cycles+=2;	/* decrementar ciclos si procede */
		}
	}

	if ((main_ea != dreg) && dummyreads)    /* almacenar resultado */
	{
		main_ea_rmw_store();
	}
	else
	{
		main_ea_store();
	}
		
    cycles+=main_ea_cycles();
	timing(cycles);
}

/* Operaciones de bits */
/* La operación se aplica sobre ECX */
/* 0=btst,1=bchg,2=bclr,3=bset */
/* static_cycles son ciclos a contar */
static void bitop(int static_cycles)
{
	int cycles;

	sel_usereg();
	emit("and ecx,byte %d",(main_ea == dreg)?31:7);

	if(main_ea == dreg)                 /* Dato a testear especificado en registro de datos */
	{
		main_size=LONG;
		if(main_cc == T_CC)             /* BTST: Test a Bit */
		{
			emit("mov edx,1");			/* Bit 0 On */
			emit("shl edx,cl");			/* Bit On posicionado */
			emit("test [__dreg+ebx*4],edx");	/* testeo */
			flag_to_z("z");				/* fijar bandera Z */
		}
		else
		{
			emit("mov edx,1");			/* Bit 0 On */
			emit("shl edx,cl");			/* Bit On posicionado */
			emit("mov ecx,[__dreg+ebx*4]");	/* cargar dato registro datos */
			emit("test ecx,edx");		/* testeo */
			flag_to_z("z");				/* fijar bandera Z */
			switch(main_cc)
			{
			    case F_CC: emit("xor ecx,edx"); 
							break;		/* BCHG: Test a Bit and Change */
			    case HI_CC: emit("not edx"); 
							emit("and ecx,edx"); 
							break;		/* BCLR: Test a Bit and Clear */
			    case LS_CC: emit("or ecx,edx"); 
							break;		/* BSET: Test a Bit and Set */
			}
			emit("mov [__dreg+ebx*4],ecx");	/* cargar resultado */
		}

		cycles=6+static_cycles;
		if(main_cc) cycles+=2;			/* si es BCHG, BCLR o BSET */
		if(main_cc == HI_CC) cycles+=2;	/* si es BCLR */
	}
	else                            /* Dato a testear especificado en direccion efectiva */
	{
		main_size = BYTE;			/* siempre operacion de byte */
		if(main_cc == T_CC)         /* BTST: Test a Bit */
		{
			emit("push ecx");		/* guardar ECX para cargar direccion efectiva */
			main_ea_load();			/* cargar direccion efectiva en ECX */
			emit("mov edx,ecx");	/* carga a EDX */
			emit("pop ecx");		/* recuperar operando en ECX */
			emit("inc cl");			/* incrementar CL para arrastrar bit deseado al acarreo */
			emit("shr dl,cl");		/* desplazar: bit DL -> C x86 */
			flag_to_z("nc");		/* respecto a Z = 1, bit = 0; Z = 0, C = 1, bit = 1 */
		}
		else
		{
			emit("mov dl,1");		/* Bit 0 On */
			emit("shl dl,cl");		/* Bit On posicionado */
			emit("push edx");		/* guardar EDX */
			main_ea_rmw_load();		/* cargar en ECX el operando */
			emit("xchg edx,[esp]");	
			emit("test cl,dl");		/* testeo */
			flag_to_z("z");
			switch(main_cc)
			{
			    case F_CC: emit("xor cl,dl"); break;    /* BCHG: Test a Bit and Change */
			    case HI_CC: emit("not dl");
			    			emit("and cl,dl"); break;   /* BCLR: Test a Bit and Clear */
			    case LS_CC: emit("or cl,dl"); break;    /* BSET: Test a Bit and Set */
			}
			emit("pop edx");        /* recuperar EDX */
			main_ea_rmw_store();    /* almacenar resultado */
		}
		cycles=4+static_cycles+main_ea_cycles();
		if(main_cc) cycles+=4;      /* si no es BTST */
	}
	timing(cycles);
}

/* Operación de bit a operando inmediato */
static void i_bitop_imm(void)
{
	emit("mov cl,[esi]");		/* Dato inmediato en opcodes */
	inc_ptr_opcodes();
	bitop(4);
}

/* Operacion de bit a registro de datos */
static void i_bitop_reg(void)
{
	emit("mov cl,byte[__dreg+%d]",main_reg<<2);	/* registro de datos */
	bitop(0);
}

/* JUMP */
static void i_jmp(void)
{
	int cycles=0;

	sel_usereg();
	main_ea_control();
	get_new_pc_from("edx");     /* el PC esta en EDX tras main_ea_control */
	switch(main_ea)
	{
	    case aind: cycles= 8; break;
	    case adsp: cycles=10; break;
	    case axdp: cycles=14; break;
	    case absw: cycles=10; break;
	    case absl: cycles=12; break;
	    case pcdp: cycles=10; break;
	    case pcxd: cycles=14; break;
	}
	timing(cycles);
}

/* JUMP TO SUBROUTINE */
static void i_jsr(void)
{
	int cycles=0;

	sel_usereg();
	main_ea_control();
	emit("mov ecx,esi");        /* ECX = PC + base */
	emit("sub ecx,ebp");        /* ECX = PC */
	emit("push ecx");           /* salvar PC en la pila */
	get_new_pc_from("edx");     /* en EDX esta el nuevo PC (tras main_ea_control) */
	emit("pop ecx");            /* recuperar PC antiguo */

	ea_store(LONG,adec,7);      /* Almacenar en la pila el PC antiguo */
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
	timing(cycles);
}

/* RETURN FROM SUBROUTINE */
static void i_rts(void)
{
	ea_load(LONG,ainc,7);   /* Carga direccion de la pila */
	get_new_pc_from("ecx"); /* en ECX esta el nuevo PC */
	timing(16);
}

/* RETURN AND RESTORE CONDITION CODES */
static void i_rtr(void)
{
	ea_load(WORD,ainc,7);    /* Cargar CCR de la pila */
	cl2ccr();                /* (SP) -> CCR */
	ea_load(LONG,ainc,7);    /* Cargar PC de la pila */
	get_new_pc_from("ecx");  /* (SP) -> PC (en ECX esta el nuevo PC) */
	timing(20);
}

/* RETURN FROM EXCEPTION */
static void i_rte(void)
{
	priv_check();
    emit("mov edx,[__a7]");
    emit("call readmemory%s",sizename[WORD]);
    emit("add edx,byte 2");
    cx2sr();

	/* Segun el modo (S o U) incrementar el ptr. de pila */
    emit("test ch,20h");
	emit("setz cl");                /* CL = bit S */
    emit("movzx ecx,cl");           /* limpiar resto de reg. */
    emit("lea ecx,[__a7+ecx*4]");   /* obtener ptr. de pila segun modo */
    emit("add dword[ecx],byte 6");

    emit("call readmemory%s",sizename[LONG]);

	/* Desactivacion de bits indicadores de excepciones de grupos de nivel 0 y 1 */
	/* Si no se emulan las excepciones de grupo 0, NO DESACTIVAR bit puesto que */
	/* desempeña otra indicacion y puede producir conflictos de funcionamiento */
	if (emulate_group_0)
		/* borrar indicadores de excepciones de grupo 0 y 1 */
		emit("and byte[__execinfo],0E5h");
	else
		/* borrar indicadores de excepciones de grupo 1 */
		emit("and byte[__execinfo],0E7h");

    get_new_pc_from("ecx");    /* tras lectura, el PC esta en ECX */
    timing_cp(20);
}

/* LOAD EFFECTIVE ADDRESS */
static void i_lea(void)
{
	int cycles=0;

	sel_usereg();
	main_ea_control();                       /* Cargar direccion efectiva */
	emit("mov [__areg+%d],edx",main_reg<<2); /* Llevar a registro de direcciones */

	switch(main_ea)
	{
	    case aind: cycles=4; break;
	    case adsp: cycles=8; break;
	    case axdp: cycles=12; break;
	    case absw: cycles=8; break;
	    case absl: cycles=12; break;
	    case pcdp: cycles=8; break;
	    case pcxd: cycles=12; break;
	}
	timing(cycles);
}

/* PUSH EFFECTIVE ADDRESS */
static void i_pea(void)
{
	int cycles=0;

	sel_usereg();
	main_ea_control();		/* Carga de direccion efectiva */
	emit("mov ecx,edx");	/* Cargar a ECX para almacenar en la pila */
	ea_store(4,adec,7);
	switch(main_ea)
	{
	    case aind: cycles=12; break;
	    case adsp: cycles=16; break;
	    case axdp: cycles=20; break;
	    case absw: cycles=16; break;
	    case absl: cycles=20; break;
	    case pcdp: cycles=16; break;
	    case pcxd: cycles=20; break;
	}
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
	int ln=linetag;
	int cycles=0;

	linetag+=2;
	emit("push eax");
	sel_usereg();
	emit("xor eax,eax");
	emit("mov ax,word[esi]");   /* Cargar lista de mascaras de registros */	
	inc_ptr_opcodes();
	main_ea_control();          /* Carga direccion efectiva */
	emit("xor ebx,ebx");        /* EBX = Indice = 0 */
	emit("ln%d:",ln);
	emit("shr ax,1");           /* Mascara -> C x86 */
	emit("jnc short ln%d",ln+1);
	if(main_dr==0)              /* registro -> memoria */
	{
		switch(main_ea)
		{
		    case aind: cycles= 8; break;
		    case adsp: cycles=12; break;
		    case axdp: cycles=14; break;
		    case absw: cycles=12; break;
		    case absl: cycles=16; break;
		}
		emit("mov ecx,[__reg+ebx]"); /* Carga a ECX para escritura en memoria */
		emit("call writememory%s",sizename[main_size]);
	}
	else                    /* memoria -> registro */
	{
		switch(main_ea)
		{
			case aind: cycles=12; break;
    		case adsp: cycles=16; break;
    		case axdp: cycles=18; break;
    		case absw: cycles=16; break;
    		case absl: cycles=20; break;
    		case pcdp: cycles=16; break;
    		case pcxd: cycles=18; break;
		}
		emit("call readmemory%s",sizename[main_size]);
		if(main_size == WORD)
			emit("movsx ecx,cx");	      /* si se trata de palabras, carga con extension de signo */
		emit("mov [__reg+ebx],ecx");      /* carga a registro */
	}
	emit("add edx,byte %d",main_size);	  /* Incrementar ptr */
	emit("sub edi,byte %d",main_size<<1); /* Decrementar ciclos de ejecución necesarios */
	emit("ln%d:",ln+1);
	emit("add bl,byte 4");				  /* Incrementar indice */
	emit("test bl,byte 64");			  /* hay mas registros? */
	emit("jz short ln%d",ln);
	emit("pop eax");					  /* Restaurar EAX */
	timing(cycles);
}

/* MOVE MULTIPLE REGISTERS WITH POSTINCREMENT ADDRESSING MODE */
static void i_movem_postinc(void)
{
	int myline=linetag;
	
	linetag+=2;
	usereg();
	emit("push eax");
	emit("xor eax,eax");
	emit("mov ax,word [esi]");	    /* Cargar lista de mascaras de registros */
	inc_ptr_opcodes();
	emit("mov edx,[__areg+ebx*4]");	/* Direccion inicial a EDX */
	emit("push ebx");
	emit("xor ebx,ebx");			/* EBX = Indice = 0 */
	emit("ln%d:",myline);
	emit("shr ax,1");				/* Mascara -> C x86 */
	emit("jnc short ln%d",myline+1);

	emit("call readmemory%s",sizename[main_size]);
	if(main_size == WORD)
		emit("movsx ecx,cx");		/* si se trata de palabras, carga con extension de signo */

	emit("mov [__reg+ebx],ecx");    /* cargar resultado en registro */
	emit("add edx,byte %d",main_size);/* incrementar ptr */

	emit("sub edi,byte %d",main_size<<1);/* y decrementar ciclos de ejecución necesarios */
	emit("ln%d:",myline+1);
	emit("add ebx,byte 4");			/* Incrementar indice */
	emit("test bl,byte 64");		/* y si no se ha llegado al ultimo registro */
	emit("jz short ln%d",myline);	/* continuar */
	emit("pop ebx");				/* Restaurar EBX */
	emit("pop eax");				/* y EAX */
	emit("mov [__areg+ebx*4],edx");	/* Guardar direccion final en regitro de direcciones */
	timing(12);
}

/* MOVE MULTIPLE REGISTERS WITH PREDECREMENT ADDRESSING MODE */
static void i_movem_predec(void)
{
	int myline=linetag;
	
	linetag+=2;
	usereg();
	emit("push eax");
	emit("xor eax,eax");
	emit("mov ax,word [esi]");	    /* Cargar lista de mascaras de registros */
	inc_ptr_opcodes();
	emit("mov edx,[__areg+ebx*4]");	/* Direccion inicial a EDX */
	emit("push ebx");
	emit("mov ebx,60");				/* EBX = indice */

	emit("ln%d:",myline);
	emit("shr ax,1");				/* Mascara -> C x86 */
	emit("jnc short ln%d",myline+1);
	emit("mov ecx,[__reg+ebx]");	/* Cargar dato en registro */
	emit("sub edx,byte %d",main_size);/* Decrementar ptr para realizar la carga en memoria */
	emit("sub edi,byte %d",main_size<<1);	/* Ciclos de ejecucion necesarios para la carga */
	emit("call writememory%s",sizename[main_size]);

	emit("ln%d:",myline+1);
	emit("sub ebx,byte 4");			/* Decrementar indice */
	emit("jns short ln%d",myline);	/* y continuar si quedan mas registros posibles */
	emit("pop ebx");				/* Restaurar EBX */
	emit("pop eax");				/* y EAX */
	emit("mov [__areg+ebx*4],edx");	/* Guardar direccion final en regitro de direcciones */
	timing(8);
}

/* LINK AND ALLOCATE */
static void i_link(void)
{
	usereg();
	emit("mov ecx,[__areg+ebx*4]");	/* cargar en la pila */
	ea_store(4,adec,7);				/* el dato especificado por el reg. de direcciones */
	emit("mov ecx,[__a7]");			/* cargar nuevo dato apuntado por la pila */
	emit("mov [__areg+ebx*4],ecx");
	emit("movsx edx,word[esi]");	/* cargar desplazamiento */
	emit("add ecx,edx");			/* y sumar al ptr de pila */
	emit("mov [__a7],ecx");			/* resultado al ptr de la pila */
	inc_ptr_opcodes();
	timing(16);
}

/* UNLINK */
static void i_unlk(void)
{
	usereg();
	emit("mov ecx,[__areg+ebx*4]");	/* cargar ptr de la pila con reg. direcciones */
	emit("mov [__a7],ecx");
	ea_load(4,ainc,7);				/* cargar registro direcciones con tope de la pila */
	emit("mov [__areg+ebx*4],ecx");
	timing(12);
}

/* Mover USP a direccion efectiva */
static void i_move_from_usp(void)
{
	priv_check();					/* Chequear privilegios */
	usereg();
	emit("mov ecx,[__asp]");			/* Cargar ptr. pila */
	emit("mov [__areg+ebx*4],ecx");
	timing(4);
}

/* Mover al USP */
static void i_move_to_usp(void)
{
	priv_check();				/* Chequear privilegios */
	usereg();
	emit("mov ecx,[__areg+ebx*4]");	/* cargar operando */
	emit("mov [__asp],ecx");
	timing(4);
}

/* TRAP */
static void i_trap(void)
{
	emit("and ebx,byte 0Fh");       /* aislar vector excepción */
	emit("lea edx,[80h+ebx*4]");    /* obtener direccion excepcion */
	emit("call group_2_exception");
	get_new_pc();
	timing(34);
}

/* TRAP ON OVERFLOW */
static void i_trapv(void)
{
	int ln=linetag;

    linetag++;
	emit("test al,1");              /* testear bandera V */
	emit("jnz short ln%d",ln);
	timing(4);                      /* tiempo de instruccion */

	emit("ln%d:",ln);               /* activar excepcion */
	emit("mov edx,1Ch");            /* vector excepcion */
	emit("call group_2_exception");
	get_new_pc();
	timing(34 + 4);	/* tiempo de instruccion + tiempo de exception */
}

/* STOP */
static void i_stop(void)
{
	priv_check();
	emit("mov cx,[esi]");   /* carga palabra a continuacion de instruccion */
	inc_ptr_opcodes();      /* incrementar opcodes */
	cx2sr();                /* palabra al SR */
	emit("or byte[__execinfo],80h"); /* Activar bit CPU stopped */

	/* Ahora la CPU debe salir del fetch/decode/loop */
	/* Para ello, descontar ciclos de reloj de la instruccion manualmente, */
	/* ajustar valores de retorno en ECX si no estamos en ejecucion en linea */
	/* y salir de emulate */
	emit("sub edi,byte 4");  /* ciclos de STOP = 4 */

	if (!inline_fd_loop)
		emit("xor ecx,ecx"); /* ejecucion exitosa */

	emit("jmp near execexit"); /* salir de emulate incondicionalmente */
}

/* SIGN-EXTEND BYTE TO WORD */
static void i_extbw(void)
{
	usereg();
	emit("movsx cx,byte[__dreg+ebx*4]");    /* extender byte */
	emit("mov [__dreg+ebx*4],cx");          /* cargar resultado */
	selftest(WORD);                         /* calculo de banderas respecto al resultado (word) */
	flags_v0();
	timing(4);
}

/* SIGN-EXTEND WORD TO LONG WORD */
static void i_extwl(void)
{
	usereg();
	emit("movsx ecx,word[__dreg+ebx*4]");   /* extender palabra */
	emit("mov [__dreg+ebx*4],ecx");         /* cargar resultado */
	selftest(LONG);                         /* calculo de banderas respecto al resultado (dword) */
	flags_v0();
	timing(4);
}

/* SWAP */
static void i_swap(void)
{
	usereg();
	emit("mov ecx,[__dreg+ebx*4]");		/* Cargar registro */
	emit("rol ecx,16");					/* Rotar operando */
	emit("mov [__dreg+ebx*4],ecx");		/* Cargar resultado */
	selftest(LONG);						/* El operando es de 32 bits (registro de datos) */
	flags_v0();
	timing(4);
}

/* MULTIPLICATION */
static void i_mul(void)
{
	sel_usereg();
	main_size=WORD;      /* es una operación solo de tamaño WORD */

	main_ea_load();
	emit("mov eax,ecx"); /* primer factor en EAX */

	/*********************/
	/* Calculo de ciclos */
	/*********************/
	if (exact_timing)
	{
		if (main_cc)         /* MULS: multiplicacion con signo */
		{
			/* calcular el numero de 01s o 10s, convirtiendolo a contar 1s en ECX */
			emit("mov edx,ecx");	
			emit("shl edx,1");
			emit("xor ecx,edx");
		}	

		/* Contar 1s de CX y resultado a CL */
		emit("mov dx,cx");
		emit("xor bx,bx");               /* limpiar BX para cargar partes (bytes) */
		emit("mov bl,cl");
		emit("lea ecx,[__cb_table+ebx]");
		emit("movzx ecx,byte[ecx]");
		emit("mov bl,dh");
		emit("lea edx,[__cb_table+ebx]");
		emit("add cl,[edx]");              /* CL = numero de bits activos en CX */
		/* Restar ciclos a EDI */
		emit("shl cl,1");                  /* ciclos a restar = num. bits * 2 */
		emit("sub edi,ecx");
	}
	else
	{
		if (main_cc)
			emit("sub edi,8");             /* valor medio (0-8 bits -> 0-16 ciclos) */
		else
			emit("sub edi,16");            /* valor medio (0-16 bits -> 0-32 ciclos) */
	}

	/****************************/
	/* Fin de calculo de ciclos */
	/****************************/

	emit("%smul word[__dreg+%d]",(main_cc)?"i":"",main_reg<<2);
	emit("shl edx,16");     /* colocar palabra alta */
	emit("and eax,0FFFFh"); /* aislar palabra baja */
	emit("or edx,eax");     /* resultado final en EDX */
	flags_v0();
	emit("mov [__dreg+%d],edx",main_reg<<2);/* resultado al registro */
	timing(38+main_ea_cycles());        /* 2n se contabiliza antes en el codigo */
}

/* DIVISION */
static void i_div(void)
{
	int base_cycles;
	int ln=linetag++;

	sel_usereg();
	main_size=WORD;              /* es una operación solo de tamaño WORD */
	main_ea_load();
	emit("test cx,cx");          /* testear division por cero */
	emit("jz near zex%d",ln);    /* CX=0 -> division por cero (excepcion) */

	emit("mov eax,[__dreg+%d]",main_reg<<2);/* cargar dividendo en EAX */

	/* Testear desbordamiento de division */
	emit("shl ecx,16");          /* divisor en parte alta */
	if (main_cc)
	{
		emit("mov edx,ecx");     /* guardar divisor en ECX */
		emit("cmp eax,edx");
		emit("setbe bl");
		emit("neg edx");
		emit("cmp eax,edx");
		emit("setbe bh");
		emit("xor bl,bh");
		emit("jnz short ov%d",ln);
	}
	else
	{
		emit("cmp eax,ecx");
		emit("jae short ov%d",ln);
	}

	/* Divisor en CX -> extender a ECX (con o sin signo) */
	emit("s%cr ecx,16",(main_cc)?'a':'h');

	/* EDX es la parte alta del dividendo, por lo que hay que extender signo */
	if (main_cc == T_CC)
		emit("xor edx,edx");
	else
		emit("cdq");

	/* Si exact_timing guardar el dividendo y el divisor pues son necesarios */
	/* para el calculo preciso de ciclos de reloj */
	if (exact_timing)
	{
		if (main_cc)
		{
			/* si el dividendo < 0, ciclos += 2 */
			emit("xor ebx,ebx");
			emit("test eax,eax");
			emit("sets bl");     /* BL = signo dividendo */
			emit("shl bl,1");    /* ciclos *= 2 */
			emit("sub edi,ebx");
		}
		emit("push ecx");    /* guardar divisor para calculo de ciclos */
		emit("mov ebx,eax"); /* EBX = dividendo */
	}

	/* main_cc = 1 -> division con signo */
	emit("%sdiv ecx",main_cc?"i":"");   /* Realizar operacion con o sin signo */
	emit("shl edx,16");		/* dejar espacio en EDX para el resultado, conservando resto division */
	emit("mov dx,ax");		/* cargar en DX el resultado de la operacion */
	emit("test dx,dx");		/* testeo para calculo de banderas */
	flags_v0();				/* bandera V siempre a 0 si la operacion ha sido completada con exito */
	emit("mov [__dreg+%d],edx",main_reg*4);	/* almacenar resultado */

	/* Calcular numero exacto de ciclos de reloj */
	if (exact_timing)
	{
		if (main_cc)                /* DIVS */
		{
			emit("pop ecx");        /* restaurar divisor */
			base_cycles = (6+55)*2; /* ciclos += (6 + 55) * 2 */

			/* ciclos por signo dividendo */
			emit("test cx,cx");     /* testear divisor */
			emit("js short .ndivs%d",ln);
			emit("test ebx,ebx");   /* testear dividendo */
			emit("js short .ndivd%d",ln);
			emit("add edi,byte 4"); /* ciclos (*2) por signo dividendo */
			
			emit(".ndivd%d:",ln);
			emit("sub edi,byte 2"); /* ciclos (*2) por signo dividendo */

			emit(".ndivs%d:",ln);
			emit("mov al,15");      /* contador de iteraciones */
			
			/* testear divd. y divs. para obtener el cociente absoluto */
			emit("test cx,cx");
			emit("sets cl");
			emit("test ebx,ebx");
			emit("sets ch");
			emit("xor ebx,ebx");
			emit("xor cl,ch");
			emit("jz short .dsetloop%d",ln);
			emit("neg dx");

			/* Testear bits cociente absoluto */
			emit(".dsetloop%d:",ln);
			emit("test dx,dx");     /* testear cociente */
			emit("setns bl");       /* EBX = bit de no signo */
			emit("shl bl,1");       /* ciclos *= 2 */
			emit("sub edi,ebx");    /* restar ciclos segun bit no signo */
			emit("shl edx,1");      /* cociente <<= 1 */
			
			emit("dec al");
			emit("jnz short .dsetloop%d",ln);
		}
		else
		{
			emit("mov al,15");      /* AL = contador de iteraciones */
			emit("pop ecx");        /* restaurar divisor */
			emit("shl ecx,16");     /* ECX = hdivisor */
			base_cycles = 38*2;     /* ciclos += 38*2 */
	
			emit(".detloop%d:",ln);
			emit("shl ebx,1");      /* dividendo <<=1 */
			emit("sub edi,byte 4"); /* ciclos += 2*2 */
			emit("cmp ebx,ecx");
			emit("jb short .nsbhd%d",ln);
			emit("sub ebx,ecx");    /* dividendo -= hdivisor */
			emit("add edi,byte 2"); /* ciclos -= 1*2 (ajuste) */
			emit(".nsbhd%d:",ln);
			emit("dec al");
			emit("jnz short .detloop%d",ln);
		}
		
		/* Limpiar registro de carga de opcode */
		emit("xor ebx,ebx");
	}
	else
	{
		/* calculo de ciclos no preciso! */
		/* + - 5% error de precision */
		if(main_cc)             /* division con signo */
		{
			/* segun motorola: mejor caso:142, peor caso: 158 */
			/* segun jorge cwik: mejor caso: 122, peor caso: 156 */
			base_cycles = 139;
		}
		else
		{
			/* segun motorola: mejor caso: 126, peor caso: 140 */
			/* segun jorge cwik: mejor caso: 76, peor caso: 136 */
			base_cycles = 106;
		}
	}

	timing(base_cycles+main_ea_cycles());

	/* desbordamiento */
	emit("ov%d:",ln);
	emit("mov ax,1");       /* bandera V = 1 (desbordamiento) */

	/* calculo de ciclos (overflow) */
	if (main_cc)            /* division con signo */
	{
		if (exact_timing)
		{
			/* Timing overflow DIVS */
			/* +2 si el dividendo < 0 (se calcula antes del chequeo de V) */
			base_cycles = 16;
		}
		else
			base_cycles = 17;   /* media entre 16-18  */
	}
	else
		base_cycles = 10;

    timing(base_cycles+main_ea_cycles());

	/* Excepcion por division por cero */
	emit("zex%d:",ln);

	/* Si el divisor es 0 -> TRAP (excepcion de division por cero) */
	emit("mov edx,14h");
	emit("call group_2_exception");
	get_new_pc();
	base_cycles=38;

	timing(base_cycles+main_ea_cycles());
}

/* NEGATE */
static void i_neg(void)
{
	int cycles;

	sel_usereg();		/* obtener registro */
	cycles = (main_size == LONG)?6:4;
	if(main_ea == dreg)
	{
		emit("neg %s[__dreg+ebx*4]", sizename[main_size]);	/* negate */
		flags();
		c2x();
	}
	else
	{
		cycles<<=1;
		main_ea_rmw_load();				/* Cargar memoria */
		emit("neg %s",x86cx[main_size]);/* negate */
		flags();
		c2x();
		main_ea_rmw_store();
		cycles+=main_ea_cycles();
	}
	timing(cycles);
}

/* NEGATE WITH EXTEND */
static void i_negx(void)
{
	int cycles;
    
	sel_usereg();
	cycles = (main_size == LONG)?6:4;
	if(main_ea == dreg)
	{
		emit("xor %s,%s",x86cx[main_size],x86cx[main_size]); /* poner a 0 registro x86cx */
		emit("shr byte[__xflag],1");        /* X -> C x86 */
		emit("sbb %s,[__dreg+ebx*4]",x86cx[main_size]);
		emit("mov dl,ah");					/* salvar flags para mantener bandera Z */
		flags();							/* banderas menos X y Z */
        c2x();								/* cargar bandera X */
		adjzero("dl");						/* calcular bandera Z */
		emit("mov [__dreg+ebx*4],%s",x86cx[main_size]);	/* resultado */
	}
	else
	{
		cycles<<=1;
		main_ea_rmw_load();
		emit("push ebx");
		emit("xor %s,%s",x86bx[main_size],x86bx[main_size]); /* poner a 0 registro x86bx */
		emit("shr byte[__xflag],1");		/* X -> C x86 */
		emit("sbb %s,%s",x86bx[main_size],x86cx[main_size]);
		emit("mov ecx,ebx");				/* Llevar resultado a ECX para almacenar en memoria */
		emit("mov bl,ah");					/* Salvar banderas para mantener valor de Z */
		flags();
		c2x();
		adjzero("bl");
		emit("pop ebx");					/* recuperar EBX */
		main_ea_rmw_store();
		cycles+=main_ea_cycles();
	}
	timing(cycles);
}

/* NEGATE BCD */
static void i_nbcd(void)
{
	main_size = BYTE;		 /* operacion solo de byte */
	sel_usereg();
	main_ea_rmw_load();

	emit("xor al,al");       /* AL = 0 (operando A) */
	/* El registro BH se puede utilizar pues no guarda datos de interes */
	/* solo parte de la instruccion (no se necesita para la EA) */
	emit("mov ch,ah");       /* guardar bandera Z anterior en CH */
    emit("shr byte[__xflag],1");/* Bandera X -> acarreo x86 */

	/* Sustracción BCD (AL = 0) */
	emit("sbb al,cl");
    emit("mov cl,al");      /* resultado sin ajuste en CL */
	emit("das");            /* ajuste en AL */

	emit("lahf");			/* fijar banderas */
	c2x();                  /* fijar bandera X con acarreo x86 */
	adjzero("ch");
	/* Calculo de bandera V */
	if (emulate_undoc)
	{
		undoc_nbcd_v_flag();    /* mismo comportamiento que SBCD para el flag V */
		emit("mov cl,bh");      /* resultado en CL para llevar a destino */
		emit("xor bh,bh");      /* limpiar registro BH */
	}
	else
	{
		emit("mov cl,al");      /* resultado a CL para llevar a destino */
		emit("xor al,al");		/* bandera V = 0 */
	}

	main_ea_rmw_store();
	timing((main_ea == dreg)?6:8+main_ea_cycles());
}

/* TEST AND SET */
static void i_tas(void)
{
	main_size=BYTE;
	sel_usereg();
	main_ea_rmw_load();
	selftest(BYTE);			/* autotesteo para activar banderas */
	flags_v0();
	emit("or cl,80h");		/* activa el bit mas alto del operando */
	main_ea_rmw_store();
	timing((main_ea == dreg)?4:14+main_ea_cycles());
}

/* NOT */
static void i_not(void)
{
	int cycles;

	sel_usereg();
	cycles = (main_size == LONG)?6:4;
	if(main_ea == dreg)
	{
		emit("xor %s[__dreg+ebx*4],byte -1", sizename[main_size]);	/* operación sobre registro datos */
		flags_v0();
	}
	else
	{
		cycles<<=1;									/* multiplicar ciclos por 2 */
		main_ea_rmw_load();							/* Cargar operando */
		emit("xor %s,byte -1",x86cx[main_size]);	/* operación */
		flags_v0();
		main_ea_rmw_store();						/* Almacenar resultado */
		cycles+=main_ea_cycles();
	}
	timing(cycles);
}

/* EXCHANGE */
/* main_dr y main_ir valen 0 (registro de datos) o 32 (registro de direcciones) */
static void i_exg(void)
{
	usereg();
	/* Cargar fuentes */
	emit("mov ecx,[__reg+%d]",(main_reg<<2)+main_dr);
	emit("mov edx,[__reg+%d+ebx*4]",main_ir);
	/* Cargar destinos */
	emit("mov [__reg+%d],edx",(main_reg<<2)+main_dr);
	emit("mov [__reg+%d+ebx*4],ecx",main_ir);
	timing(6);
}

/* COMPARE MEMORY */
static void i_cmpm(void)
{
	usereg();
	ea_load(main_size,ainc,-1);		/* primer operando */
	emit("mov eax,ecx");
	ea_load(main_size,ainc,main_reg);/* segundo operando */
	emit("cmp %s,%s",x86cx[main_size],x86ax[main_size]);	/* comparación */
	flags();
	timing((main_size == LONG)?20:12);
}


/* Calculo de la bandera V en operaciones de suma-resta */
/* optype = A -> ABCD; S -> SBCD; en otro caso, bandera V=0 */
static void calc_v_opx(int optype)
{
	int opt;

    /* Aplicar calculo segun operación */
	if (emulate_undoc)
	{
        opt = toupper(optype);           /* Si es A->ABCD, si S->SBCD */
		switch(opt)
		{
			case 'A': undoc_abcd_v_flag(); break;
			case 'S': undoc_sbcd_v_flag(); break;
			default: emit("xor al,al");     /* bandera V = 0 */
		}
	}
	else
		emit("xor al,al");	/* bandera V=0, no emular comportamiento no doc. */
}

/* Operacion de suma-resta con direccionamiento registro de datos */
static void opx_dreg(char* op,char* adjust)
{
	usereg();
	emit("mov ch,ah");                      /* Guardar bandera Z en CH */
	emit("shr byte[__xflag],1");            /* Arrastrar bandera X -> acarreo x86 */
	emit("mov eax,[__dreg+%d]",main_reg<<2);
	emit("%s %s,[__dreg+ebx*4]",op,x86ax[main_size]);


    if ((main_size == BYTE) && (adjust[0]))    /* o sea, operaciones BCD, llevo resultado sin ajustar para calcular V */
	{
        /* Ya se ha realizado la suma sin ajustar aqui. res en AL*/
        emit("mov cl,%s",x86ax[main_size]);      /* Llevar a CL el resultado sin ajustar */
    }

	if(adjust[0])       /* Emitir ajuste en la operación */
		emit("%s",adjust);

	emit("mov [__dreg+%d],%s",main_reg<<2,x86ax[main_size]);
	emit("lahf");
	c2x();
	adjzero("ch");
	if(adjust[0])
		calc_v_opx((int)op[0]);						/* Calculo de bandera V */
	else
		emit("seto al");        /* bandera V = bandera O x86 */

	timing((main_size <= WORD)?((adjust[0])?6:4):8);
}

/* Operacion de suma-resta con direccionamiento registro de direcciones */
static void opx_adec(char* op, char* adjust)
{
	usereg();
	ea_load(main_size,adec,-1);
	emit("mov ebx,ecx");        /* lectura en ECX a EBX (para leer de nuevo) */
	ea_rmw_load(main_size,adec,main_reg);
	emit("xchg ecx,eax");       /* flags -> ECX, dest -> EAX */
	emit("shr byte[__xflag],1");/* X -> x86 carry */
	emit("%s %s,%s",op,x86ax[main_size],x86bx[main_size]);

    if ((main_size == BYTE) && (adjust[0]))
	{   
		/* o sea, operaciones BCD, llevar resultado sin ajustar para calcular V */
        /* Ya se ha realizado la suma sin ajustar aqui. resultado en AL */
        emit("mov cl,%s",x86ax[main_size]);/* Llevar a CL el resultado sin ajustar */
    }

	if(adjust[0])
		emit("%s",adjust);

	emit("mov ebx,eax");
	emit("lahf");
	c2x();
	adjzero("ch");
	if(adjust[0])
		calc_v_opx((int)op[0]);     /* Calculo de bandera V */
	else
		emit("seto al");

	emit("mov ecx,ebx");            /* Resultado final a ECX */
	emit("xor ebx,ebx");            /* EBX = 0 */
	ea_rmw_store(main_size,adec,main_reg);
	timing((main_size <= WORD)?18:30);
}

/* ADDs y SUBs */
static void i_addx_dreg(void) {opx_dreg("adc","");}
static void i_addx_adec(void) {opx_adec("adc","");}
static void i_subx_dreg(void) {opx_dreg("sbb","");}
static void i_subx_adec(void) {opx_adec("sbb","");}
static void i_abcd_dreg(void) {main_size=BYTE; opx_dreg("adc","daa");}
static void i_abcd_adec(void) {main_size=BYTE; opx_adec("adc","daa");}
static void i_sbcd_dreg(void) {main_size=BYTE; opx_dreg("sbb","das");}
static void i_sbcd_adec(void) {main_size=BYTE; opx_adec("sbb","das");}

/* MOVE PERIPHERAL DATA FROM MEMORY TO REGISTER */
static void i_movep_mem2reg(void)
{
	usereg();
	emit("movsx edx,word[esi]");		/* obtener desplazamiento 16-bits */
	inc_ptr_opcodes();
	emit("add edx,[__areg+ebx*4]");		/* Añadir direccion al desplazamiento */
	emit("call readmemorybyte");		/* Lectura primer byte */
	emit("mov bh,cl");					/* Almacenar byte */
	emit("add edx,byte 2");				/* Incrementar ptr. */
	emit("call readmemorybyte");		/* Lectura 2º byte */
	emit("mov bl,cl");					/* Almacenar 2º byte */
	if(main_size == WORD)
	{
		emit("mov [__dreg+%d],bx",main_reg<<2);	/* Cargar resultado */
	}
	else
	{
		emit("add edx,byte 2");			/* Incrementar ptr. */
		emit("shl ebx,16");				/* Desplazar palabra */
		emit("call readmemorybyte");	/* Lectura 3º byte */
		emit("mov bh,cl");				/* Almacenar byte */
		emit("add edx,byte 2");			/* Incrementar ptr. */
		emit("call readmemorybyte");	/* Lectura 4º byte */
		emit("mov bl,cl");				/* Almacenar byte */
		emit("mov [__dreg+%d],ebx",main_reg<<2);/* resultado a registro */
		emit("xor ebx,ebx");            /* EBX = 0 */
	}
	timing((main_size == LONG)?24:16);
}

/* MOVE PERIPHERAL DATA FROM REGISTER TO MEMORY */
static void i_movep_reg2mem(void)
{
	usereg();
	emit("movsx edx,word[esi]");			/* obtener desplazamiento 16-bits */
	inc_ptr_opcodes();
	emit("add edx,[__areg+ebx*4]");			/* Añadir direccion al desplazamiento */
	emit("mov ebx,[__dreg+%d]",main_reg<<2);/* Cargar dato a almacenar en memoria */
	if(main_size == LONG)
		emit("rol ebx,16");					/* Rotar palabra para almacenar */
	emit("mov cl,bh");						/* Primer byte a memoria */
	emit("call writememorybyte");			
	emit("add edx,byte 2");					/* Incrementar ptr. a memoria */
	emit("mov cl,bl");						/* Segundo byte */
	emit("call writememorybyte");
	if(main_size == LONG) {
		emit("add edx,byte 2");				/* Incrementar ptr */
		emit("rol ebx,16");					/* Rotar para siguiente palabra */
		emit("mov cl,bh");					/* Tercer byte */
		emit("call writememorybyte");
		emit("add edx,byte 2");				/* Incrementar ptr a memoria */
		emit("mov cl,bl");					/* Cuarto byte */
		emit("call writememorybyte");
	}
	timing((main_size == LONG)?24:16);
}

/* CHECK REGISTER AGAINST BOUNDS */
static void i_chk(void)
{
	int ln=linetag++;

	/* Operacion de tamaño WORD solamente! */
    sel_usereg();
	main_ea_load();

	if (emulate_undoc) {
		/* COMPORTAMIENTO NO DOCUMENTADO POR MOTOROLA! (seran cabrones... ;) */
		/* Calculo de la bandera Z (si el operando registro=0 -> Z=1, en otro caso Z=0 */
		emit("xor al,al");			/* AL = 0, V = 0 */
		emit("mov bx,word[__dreg+%d]",main_reg<<2); /* Cargar en EBX el operando registro */
		emit("test bx,bx");        /* Calcular bandera Z */
		emit("setz ah");          /* Flag Z -> AH */
		emit("shr ah,6");        /* Bandera Z en su lugar */
		/* Fin de calculo */
	} else
		emit("xor ax,ax");		/* no emular comportamiento no documentado banderas */

	emit("cmp word[__dreg+%d],word 0",main_reg<<2);
	emit("jl short setn%d",ln);

	emit("cmp word[__dreg+%d],cx",main_reg<<2);
	emit("jg short ln%d",ln);
	
	timing(10+main_ea_cycles());	/* tiempo de instruccion (no trap) */

	emit("setn%d:",ln);
	emit("or ah,80h");	                /* Bandera N = 1 (Dn<0) */

	/* Fuera del rango, generar excepcion CHK */
	emit("ln%d:",ln);
    emit("mov edx,18h");
	emit("call group_2_exception");
	get_new_pc();
	timing(10+40+main_ea_cycles());	/* tiempo instruccion + tiempo excepcion */
}

/* Variable que indica la emision de la etiqueta para excepciones 'ILLEGAL' */
static int created_illegal=0;

/* TAKE ILLEGAL INSTRUCTION TRAP */
static void i_illegal(void)
{
	if(!created_illegal)
	{
		emit("r_illegal:");
		created_illegal=1;
	}
	emit("sub esi,byte 2");			/* Guardar ultima instrucción */
	emit("mov edx,10h");			/* vector de interrupcion */
	emit("call group_1_exception");
	get_new_pc();
	timing(34);
}

/* EMULACION 1010 */
static void i_aline(void)
{
	emit("sub esi,byte 2");			/* Guardar ultima instrucción */
	emit("mov edx,28h");			/* vector de interrupcion */
	emit("call group_1_exception");
	get_new_pc();
	timing(34);					/* Valor no comprobado */
}

/* EMULACION 1111 */
static void i_fline(void)
{
	emit("sub esi,byte 2");			/* Guardar ultima instrucción */
	emit("mov edx,2Ch");			/* vector de interrupcion */

	emit("call group_1_exception");
	get_new_pc();
	timing(34);					/* Valor no comprobado */
}

/* RESET */
static void i_reset(void)
{
	priv_check();                   /* Chequear privilegios */
	emit("mov ecx,[__resethandler]");   /* Cargar direccion de manejador */
	emit("test ecx,ecx");
	emit("jz short .r_done");           /* Si no hay manejador, no hay mas que hacer */
	core_exit();						/* salir del ensamblador */
	emit("call ecx");                   /* Llamar al manejador */
	core_enter();					/* volver al ensamblador */
	emit(".r_done:");
	timing(132);
}

/****************************************************************************/
/* FUNCIONES DE DESCODIFICACION                                             */
/****************************************************************************/

static int rproc [0x10000];
static byte unique[0x10000];
static int stop_decode;		/* Variable que indica el final de la descodificación */

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
	{
		emit("; Opcode %04X", n);
	}
	else
	{
		emit("; Opcodes %04X - %04X", n, op + t);
	}
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

	main_ea = dreg; idef(n, m | 0x38, op | 0x00, proc);
	if(main_size != BYTE)
	{
		main_ea = areg; idef(n, m | 0x38, op | 0x08, proc);
	}
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
static void eadef_alterable_nobyteaddress(int n, int m, int op, void(*proc)(void))
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

/***************************************************************************/

static void decode0(int n)
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
	/*
	* Operaciones de bit
	* BTST (main_cc 0) funciona con todos los modos de direccionamiento; el resto
	* modos de direccionamiento de alteracion de dato
	*/
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
	for(main_reg=0;main_reg<8;main_reg++) {
		for(main_size=WORD;main_size<=LONG;main_size+=2){
			idef(n,0xFFF8,0x0108|((main_size&4)<<4)|(main_reg<<9),i_movep_mem2reg);
			idef(n,0xFFF8,0x0188|((main_size&4)<<4)|(main_reg<<9),i_movep_reg2mem);
		}
	}
}

static void decode1(int n)
{
	stop_decode = 0;
	main_size = BYTE;
	defmove(0x1000, n);
}

static void decode2(int n)
{
	stop_decode = 0;
	main_size = LONG;
	defmove(0x2000, n);
	for(main_reg = 0; main_reg < 8; main_reg++)
	{
		eadef_all(n, 0xFFC0, 0x2040 | (main_reg << 9), i_movea);
	}
}

static void decode3(int n)
{
	stop_decode = 0;
	main_size = WORD;
	defmove(0x3000, n);
	for(main_reg = 0; main_reg < 8; main_reg++)
	{
		eadef_all(n, 0xFFC0, 0x3040 | (main_reg << 9), i_movea);
	}
}

static void decode4(int n)
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

static void decode5(int n)
{
	stop_decode = 0;
	for(sizedef = 0; sizedef < 3; sizedef++)
	{
		main_size = 1 << sizedef;
		for(main_qv = 0; main_qv < 8; main_qv++)
		{
			word w = (sizedef << 6) | (main_qv << 9);
			eadef_alterable_nobyteaddress(n, 0xFFC0, 0x5000 | w, i_addq);
			eadef_alterable_nobyteaddress(n, 0xFFC0, 0x5100 | w, i_subq);
		}
	}

	idef(n, 0xFFF8, 0x50C8, i_dbt);
	idef(n, 0xFFF8, 0x51C8, i_dbra);			/* DBF = DBRA */
	for(main_cc = 0x2; main_cc <= 0xF; main_cc++) {
		idef(n, 0xFFF8, 0x50C8 | (main_cc << 8), i_dbcc);
	}

	main_size = BYTE;
	for(main_cc = 0x0; main_cc <= 0xF; main_cc++)
	{
		eadef_data_alterable(n, 0xFFC0, 0x50C0 | (main_cc << 8), i_scc);
	}
}

static void decode6(int n)
{
	stop_decode=0;
	idef(n,0x1FFFF,0x6000,i_bra_w);
	idef(n,0x1FFFF,0x6100,i_bsr_w);
	for(main_cc=0x2;main_cc<=0xF;main_cc++)
	{
		idef(n,0x1FFFF,0x6000|(main_cc<<8),i_bcc_w);
	}
	idef(n,0x0FF00,0x6000,i_bra_b);
	idef(n,0x0FF00,0x6100,i_bsr_b);
	for(main_cc=0x2;main_cc<=0xF;main_cc++)
	{
		idef(n,0x0FF00,0x6000|(main_cc<<8),i_bcc_b);
	}
}

static void decode7(int n)
{
	stop_decode=0;
	for(main_reg=0;main_reg<8;main_reg++) 
		idef(n,0xFF00,0x7000|(main_reg<<9),i_moveq);
}

static void decode8(int n)
{
	stop_decode=0;
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_data (n,0xFFC0,0x8000|(main_reg<<9)|(sizedef<<6),i_or_dn);
		}
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_memory_alterable (n,0xFFC0,0x8100|(main_reg<<9)|(sizedef<<6),i_or_ea);
		}
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

static void decode9(int n)
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
		{
			eadef_memory_alterable (n,0xFFC0,0x9100|(main_reg<<9)|(sizedef<<6),i_sub_ea);
		}
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

static void decodeA(int n)
{
	stop_decode=0;
	idef(n,0xF000,0xA000,i_aline);
}

static void decodeB(int n)
{
	stop_decode=0;
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_all_nobyteaddress(n,0xFFC0,0xB000|(main_reg<<9)|(sizedef<<6),i_cmp_dn);
		}
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_data_alterable (n,0xFFC0,0xB100|(main_reg<<9)|(sizedef<<6),i_eor_ea);
		}
	}

	main_size=WORD;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0xB0C0|(main_reg<<9),i_cmpa);

	main_size=LONG;
	for(main_reg=0;main_reg<8;main_reg++)
		eadef_all(n,0xFFC0,0xB1C0|(main_reg<<9),i_cmpa);
	for(sizedef=0;sizedef<3;sizedef++) {
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
			idef(n,0xFFF8,0xB108|(sizedef<<6)|(main_reg<<9),i_cmpm);
	}
}

static void decodeC(int n)
{
	stop_decode=0;
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_data(n,0xFFC0,0xC000|(main_reg<<9)|(sizedef<<6),i_and_dn);
		}
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_memory_alterable (n,0xFFC0,0xC100|(main_reg<<9)|(sizedef<<6),i_and_ea);
		}
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

static void decodeD(int n)
{
	stop_decode=0;
	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++)
		{
			eadef_all_nobyteaddress(n,0xFFC0,0xD000|(main_reg<<9)|(sizedef<<6),i_add_dn);
		}
	}

	for(sizedef=0;sizedef<3;sizedef++)
	{
		main_size=1<<sizedef;
		for(main_reg=0;main_reg<8;main_reg++) {
			eadef_memory_alterable (n,0xFFC0,0xD100|(main_reg<<9)|(sizedef<<6),i_add_ea);
		}
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

static void decodeE(int n)
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

static void decodeF(int n)
{
	stop_decode = 0;
	idef(n, 0xF000, 0xF000, i_fline);
}

/* Tabla principal de descodificación de instrucciones */
static void (*(decodetable[16]))(int n) =
{decode0, decode1, decode2, decode3, decode4, decode5, decode6, decode7,
 decode8, decode9, decodeA, decodeB, decodeC, decodeD, decodeE, decodeF};

/***************************************************************************/

/* Construcción de entradas de la tabla de saltos */
static void tableentry(int last, int rl)
{
	if(last == -1)
	{
		emit_il("dd r_illegal-top");
	}
	else
	{
		emit_il("dd %c%03X-top",((last >> 12) & 0xF) + 'K', last & 0xFFF);
	}

	if(rl > 1) 
		emit_il("+%u", ((dword)(rl - 1)) << 24);
	emit_il("\n");
}

/****************************************************************************/
/* Mostrar información de opciones de generación de código					*/
/****************************************************************************/

/* Muestra cabecera de información general acerca del programa */
void show_console_header(void)
{
	fprintf(stderr," --------------------------------------------------\n");
	fprintf(stderr," Fast and Accurate Motorola 68000 Emulation Library\n");
	fprintf(stderr," FAME x86 version %s\n",VERSION);
	fprintf(stderr," Emisor de codigo ensamblador de FAME\n");
	fprintf(stderr," Oscar Orallo Pelaez\n");
	fprintf(stderr," --------------------------------------------------\n");
}


/*********************************************************/
/* Mostrar información de ayuda                          */
/*********************************************************/
void show_help(char *exec_name)
{
	show_console_header();
	fprintf(stderr," Uso: %s [opciones]\n\n",exec_name);
	fprintf(stderr," Opciones:\n\n");
	fprintf(stderr,"  -h            Mostrar ayuda\n");
	fprintf(stderr,"  -o [fichero]  Fichero de salida\n");
	fprintf(stderr,"  -f [formato]  Formato de generacion\n");
	fprintf(stderr,"    omf          Codigo objeto OMF de 32 bits (i386)\n");
	fprintf(stderr,"    win32        Codigo objeto Microsoft Win32 (i386)\n");
	fprintf(stderr,"    elf          Codigo objeto ELF32 (i386)\n");
	fprintf(stderr,"  -so           Generar codigo ELF Shared Library (requiere formato ELF)\n");
	fprintf(stderr,"  -r            Convencion de llamada por registro (por defecto, por la pila)\n");
	fprintf(stderr,"  -i            Optimizacion de velocidad (codigo en linea)\n");
	fprintf(stderr,"  -ab32         Bus de direcciones de 32 bits (por defecto, 24)\n");
	fprintf(stderr,"  -nlt          No emular lecturas tontas (por defecto, ON)\n");
	fprintf(stderr,"  -ncnd         No emular comportamiento no documentado (por defecto, ON)\n");
	fprintf(stderr,"  -eum          Utilizar espacio unico de memoria (por defecto, multiple)\n");
	fprintf(stderr,"  -ne0          No emular excepciones del grupo 0 (por defecto, ON)\n");
	fprintf(stderr,"  -n [pref]     Usar [pref] como prefijo del nombre de las funciones de la API\n");
	fprintf(stderr,"  -net          Realizar calculo no preciso de ciclos de reloj (por defecto, OFF)\n");
	fprintf(stderr,"  -dm           Cachear descriptores de mapas de memoria (por defecto, OFF)\n");
	fprintf(stderr,"  -ncc          No realizar cuenta interna de ciclos de reloj (por defecto, ON)\n");
	fprintf(stderr,"  -nb0          No emular bit 0 de execinfo (por defecto, ON)\n");
	fprintf(stderr,"  -nt           No emular excepcion de traza (por defecto, ON)\n");
	fprintf(stderr,"  -nic          No contar ciclos de generacion de las IRQs (por defecto, ON)\n");
}

/*********************************************************/
/* Muestra mensaje argumento no reconocido y la ayuda    */
/* Rompe la ejecución del programa                       */
/*********************************************************/
void arg_no_reconocido(char *exec_name)
{
	/* ERROR: Argumento no reconocido */
	fprintf(stderr,"Argumento no reconocido...\n\n");
	show_help(exec_name);
	exit(EXIT_FAILURE);
}

/* ERROR: No se encuentra el prefijo en la linea de comandos */
void fprefix_no_encontrado(char *exec_name)
{
	fprintf(stderr,"No se encuentra el prefijo...\n\n");
	show_help(exec_name);
	exit(EXIT_FAILURE);
}

/*********************/
/* FUNCION PRINCIPAL */
/*********************/

int main(int argc, char *argv[])
{
	int i, j, last, rl, bank, getof=0, getname=0, getoutfile=0;
	char *codefilename = "fame.asm";
	char *default_fprefix = "m68k";

	/* Opciones de generación de código */
	for (i=1; i<argc; i++)
	{
		/* Tipo de formato de generacion (OMF, win32, ELF, etc) */
		if (getof)
		{
			if (!strcmp(argv[i],"omf"))    /* OBJ (Borland) */
			{
				borland = 1;
				getof = 0;
				continue;
			}
			else if (!strcmp(argv[i],"elf"))    /* ELF (Linux) */
			{
				elf = 1;
				getof = 0;
				continue;
			}
			else if (!strcmp(argv[i],"win32"))    /* WIN32 (Microsoft) */
			{
				getof = 0;
				continue;
			}
			else
				arg_no_reconocido(argv[0]);
		}

		/* Obtener nombre de prefijo de funciones */
		if (getname)
		{
			fprefix = argv[i];
			if (!fprefix)
			{
				fprefix_no_encontrado(argv[0]);
			}
			else
			{
				getname = 0;
				continue;
			}
		}

		/* Obtener nombre del fichero de salida */
		if (getoutfile)
		{
			codefilename = argv[i];

			if (!codefilename)
			{
				fprefix_no_encontrado(argv[0]);
			}
			else
			{
				getoutfile = 0;
				continue;
			}
		}

		/* Fichero de salida */
		if (!strcmp(argv[i],"-o"))
		{
			getoutfile = 1;
			continue;
		}

		/* Formato de generacion */
		if (!strcmp(argv[i],"-f"))
		{
			getof = 1;
			continue;
		}

		/* ELF Shared Library */
		if (!strcmp(argv[i],"-so"))
		{
			elfso = 1;
			continue;
		}

		/* Codigo alineado, optimizacion de velocidad/tamaño */
		if (!strcmp(argv[i],"-i"))
		{
			inline_fd_loop = 1;
			continue;
		}

		/* Tamaño del bus de direcciones */
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

		/* Convencion de llamada por registro */
		if (!strcmp(argv[i],"-r"))
		{
			stack_calling=0;
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

		/* No emular ciclos de generacion de las IRQs */
		if (!strcmp(argv[i],"-nic"))
		{
			irq_cycles = 0;
			continue;
		}

		/* Usar mapas de memoria directos (caches) */
		if (!strcmp(argv[i],"-dm"))
		{
			direct_mapping = 1;
			continue;
		}

		arg_no_reconocido(argv[0]);
	}

	/* Prefijo de nombre de las funciones por defecto */
	if (fprefix == NULL) fprefix = default_fprefix;

	/* Mostrar informacion acerca de la generacion de codigo */
	show_console_header();
	code_generation_info(stderr);

	linetag = 0;        /* Inicializar contador de lineas */

	/* Abrir fichero ensamblador */
	fp = fopen(codefilename, "w");
	if(!fp)
    {
		perror(codefilename);
		return 1;
	}

	gen_man_code();
	for(i=0; i<0x10000; i++) rproc[i] = -1;

	/* Descodificación de instrucciones */
	for(bank = 0; bank <= 0xF; bank++)
    {
		int bankend = (bank + 1) << 12;
		void (*decoderoutine)(int n) = decodetable[bank];
		for(i = bank << 12; i < bankend; i++) decoderoutine(i);
	}

	/* Generar espacio de memoria para tabla de instrucciones */
	emit_il("section .bss");

	if (borland)
		emit(" public align=4 class=BSS use32");
	else
		emit_il("\n");

	emit("bits 32");
	align(4);
	emit("__jmptbl resb 262144");		/* tabla de punteros a instrucciones */
	
	/* Tablas de indices para acceso a lista de regiones */
	emit("__sfmhtbl resd 4096");
	emit("__srbmhtbl resd 4096");
	emit("__srwmhtbl resd 4096");
	emit("__swbmhtbl resd 4096");
	emit("__swwmhtbl resd 4096");
	emit("__ufmhtbl resd 4096");
	emit("__urbmhtbl resd 4096");
	emit("__urwmhtbl resd 4096");
	emit("__uwbmhtbl resd 4096");
	emit("__uwwmhtbl resd 4096");
	
	emit("section .data");
	emit("bits 32");
	align(4);
	emit("__jmptblcomp:");
	last = -2;
	rl = 0;

	/* Generación de tabla comprimida */
	for(i = 0; i < 0x10000; i++)
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
			if(rl) tableentry(last, rl);
			rl = 1;
			last = j;
		}
	}
	tableentry(last, rl);
	align(4);
	emit("end");
	fclose(fp);    /* Cerrar fichero de salida */
	return 0;
}
