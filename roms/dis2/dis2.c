/*
 * simple m68k disassembler
 * can be used as library
 *
 * brad@heeltoe.com 9/2015
 */

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include "dis2.h"

struct OpCode {
   u8 *mnemonic;
   u16 result;
   u16 maske;
   u16 sourceadr;
   u16 destadr;
   u16 cputype;
   u8 flags;
};

char cpuname[][8] = {
   "MC68000","MC68010","MC68020","MC68030","MC68040","MC68060"
};

char *opcode[] = {
/*  0*/ "BF","","",
/*  3*/ "ILLEGAL","NOP","RESET","RTE","RTR","RTS","RTD","STOP","TRAPV","MOVEC",
/* 13*/ "BKPT","SWAP","LINK","LINK.L","UNLK","EXT","EXT.L","EXTB.L","MOVE.L","MOVE.L","TRAP",
/* 24*/   "DIV","MUL","TAS","JMP","JSR","PEA","NBCD","MOVE","MOVE","MOVE","MOVE",
/* 35*/   "MOVEM","MOVEM","MOVEM.L","MOVEM.L","LEA","CHK","CHK.L","CLR",
/* 43*/   "TST","NOT","NEG","NEGX",
/* 47*/   "ADDA","ADDA.L","ADDX","ADDX","ADD","ADD","EXG","EXG","EXG",
/* 56*/   "ABCD","ABCD","MULS","MULU","AND","AND",
/* 62*/   "CMPA","CMPA.L","CMPM","CMP","EOR",
/* 67*/   "PACK","PACK","UNPK","UNPK","SBCD","SBCD","DIVS","DIVU","OR","OR",
/* 77*/   "MOVE.B","MOVEA","MOVE","MOVEA.L","MOVE.L","MOVEQ",
/* 83*/   "SUBA","SUBA.L","SUBX","SUBX","SUB","SUB",
/* 89*/   "MOVEP","MOVEP","MOVEP.L","MOVEP.L","B","CAS2","CAS","RTM","CALLM","C",
/* 99*/   "CMPI","EORI","ANDI","ADDI","SUBI","ORI","B","MOVES",
/*107*/   "DB","TRAP","TRAP","TRAP","S","ADDQ","SUBQ","B",
/*115*/   "MOVE16","MOVE16","C"," ",
   "@" // [END]
};

u16 result[] = {
   0xe8c0,0xe0c0,0xe000,
   0x4afc,0x4e71,0x4e70,0x4e73,0x4e77,0x4e75,0x4e74,0x4e72,0x4e76,0x4e7a,
   0x4848,0x4840,0x4e50,0x4808,0x4e58,0x4880,0x48c0,0x49c0,0x4e68,0x4e60,0x4e40,
   0x4c40,0x4c00,0x4ac0,0x4ec0,0x4e80,0x4840,0x4800,0x44c0,0x46c0,0x40c0,0x42c0,
   0x4880,0x4c80,0x48c0,0x4cc0,0x41c0,0x4180,0x4100,0x4200,
   0x4a00,0x4600,0x4400,0x4000,
   0xd0c0,0xd1c0,0xd100,0xd108,0xd100,0xd000,0xc140,0xc148,0xc188,
   0xc100,0xc108,0xc1c0,0xc0c0,0xc100,0xc000,
   0xb0c0,0xb1c0,0xb108,0xb000,0xb100,
   0x8148,0x8140,0x8188,0x8180,0x8100,0x8108,0x81c0,0x80c0,0x8100,0x8000,
   0x1000,0x3040,0x3000,0x2040,0x2000,0x7000,
   0x90c0,0x91c0,0x9100,0x9108,0x9100,0x9000,
   0x0188,0x0108,0x01c8,0x0148,0x0800,0x08fc,0x08c0,0x06c0,0x06c0,0x00c0,
   0x0c00,0x0a00,0x0200,0x0600,0x0400,0x0000,0x0100,0x0e00,
   0x50c8,0x50fc,0x50fa,0x50fb,0x50c0,0x5000,0x5100,0x6000,
   0xf620,0xf600,0xf400,0x0000
};

u16 maske[] = {
   0xf8c0,0xf8c0,0xf000,
   0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xfffe,
   0xfff8,0xfff8,0xfff8,0xfff8,0xfff8,0xfff8,0xfff8,0xfff8,0xfff8,0xfff8,0xfff0,
   0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,0xffc0,
   0xffc0,0xffc0,0xffc0,0xffc0,0xf1c0,0xf1c0,0xf1c0,0xff00,
   0xff00,0xff00,0xff00,0xff00,
   0xf1c0,0xf1c0,0xf138,0xf138,0xf100,0xf100,0xf1f8,0xf1f8,0xf1f8,
   0xf1f8,0xf1f8,0xf1c0,0xf1c0,0xf100,0xf100,
   0xf1c0,0xf1c0,0xf138,0xf100,0xf100,
   0xf1f8,0xf1f8,0xf1f8,0xf1f8,0xf1f8,0xf1f8,0xf1c0,0xf1c0,0xf100,0xf100,
   0xf000,0xf1c0,0xf000,0xf1c0,0xf000,0xf100,
   0xf1c0,0xf1c0,0xf138,0xf138,0xf100,0xf100,
   0xf1f8,0xf1f8,0xf1f8,0xf1f8,0xff00,0xf9ff,0xf9c0,0xfff0,0xffc0,0xf9c0,
   0xff00,0xff00,0xff00,0xff00,0xff00,0xff00,0xf100,0xff00,
   0xf0f8,0xf0ff,0xf0ff,0xf0ff,0xf0c0,0xf100,0xf100,0xf000,
   0xfff8,0xffe0,0xff10,0x0000
};

   /* Note: Only applied to sourceadr[] and destadr[]. */
   /* Bit 15 (0x8000) : 1 ==> only poss in the lower Byte addressing*/
   /* Bit 13 (0x2000) : 0 ==> reg=reg2 */
   /*                     1 ==> reg=reg1 */
   /*                     determines weather reg1 or reg2. */

u16 sourceadr[] = {
   0x0000,0x0000,0x0000,
   0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,
   0x0000,0x0000,0x8001,0x8001,0x0000,0x0000,0x0000,0x0000,0x800e,0x8001,0x0000,
   0x0bff,0x0bff,0x0000,0x0000,0x0000,0x0000,0x0000,0x0bff,0x0bff,0x800d,0x800c,
   0x800f,0x037e,0x800f,0x037e,0x027e,0x0bff,0x0bff,0x0000,
   0x0bf8,0x0000,0x0000,0x0000,
   0x0fff,0x0fff,0x8000,0x8004,0xa000,0x0fff,0xa000,0xa001,0xa000,
   0x8000,0x8004,0x0bff,0x0bff,0xa000,0x0bff,
   0x0fff,0x0fff,0x8003,0x0fff,0xa000,
   0x8004,0x8000,0x8004,0x8000,0x8000,0x8004,0x0bff,0x0bff,0xa000,0x0bff,
   0x0fff,0x0fff,0x0fff,0x0fff,0x0fff,0x8014,
   0x0fff,0x0fff,0x8000,0x8004,0xa000,0x0fff,
   0xa000,0x8005,0xa000,0x8005,0x8017,0x0000,0x801c,0x0000,0x800b,0x027e,
   0x800b,0x800b,0x800b,0x800b,0x800b,0x800b,0xa017,0x0000,
   0x8000,0x0000,0x800b,0x800b,0x0000,0xa010,0xa010,0x0000,
   0x8003,0x0000,0x8020,0x8000+NOADRMODE
};

u16 destadr[] =
{
   0x8019,0x03f8,0x8000,
   0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,0x8016,0x8018,0x0000,0x8021,
   0x8011,0x8000,0x8016,0x801e,0x8001,0x8000,0x8000,0x8000,0x8001,0x800e,0x8013,
   0x801d,0x801d,0x0bf8,0x027e,0x027e,0x027e,0x0bf8,0x800c,0x800d,0x0bf8,0x0bf8,
   0x02f8,0x800f,0x02f8,0x800f,0xa001,0xa000,0xa000,0x0bf8,
   0x0000,0x0bf8,0x0bf8,0x0bf8,
   0xa001,0xa001,0xa000,0xa004,0x03f8,0xa000,0x8000,0x8001,0x8001,
   0xa000,0xa004,0xa000,0xa000,0x03f8,0xa000,
   0xa001,0xa001,0xa003,0xa000,0x0bf8,
   0xa004,0xa000,0xa004,0xa000,0xa000,0xa004,0xa000,0xa000,0x03f8,0xa000,
   0x0bf8,0xa001,0x0bf8,0xa001,0x0bf8,0xa000,
   0xa001,0xa001,0xa000,0xa004,0x03f8,0xa000,
   0x8005,0xa000,0x8005,0xa000,0x0000,0x801b,0x03f8,0x801a,0x027e,0x0000,
   0x0bf8,0x0bf9,0x0bf9,0x0bf8,0x0bf8,0x0bf9,0x0000,0x0000,
   0x8012,0x0000,0x0000,0x0000,0x0bf8,0x0ff8,0x0ff8,0x8015,
   0x801f,0x0000,0x8002,0x0000
};

/*
   FLAGS:
   0x80 : operand size is in bits [0:1] (0=.B,1=.W,2=.L)
          else use opsize from opcode
   0x40 : operand size has to be appended to mnemonic
   0x20 : one further word has to be saved before further processing.
   0x10 : the condition code identifier has to be appended to the mnemonic.
*/

u8 flags[] =
{
   0x20,0x81,0x40,
   0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x82,
   0x80,0x80,0x81,0x81,0x81,0x81,0x82,0x82,0x82,0x82,0x80,
   0xa2,0xa2,0x80,0x81,0x81,0x80,0x80,0x81,0x81,0x81,0x81,
   0xa1,0xa1,0xa2,0xa2,0x80,0x81,0x82,0x40,
   0x40,0x40,0x40,0x40,
   0x81,0x82,0x40,0x40,0x40,0x40,0x82,0x82,0x82,
   0x80,0x80,0x81,0x81,0x40,0x40,
   0x81,0x82,0x40,0x40,0x40,
   0xa1,0xa1,0xa1,0xa1,0x80,0x80,0x81,0x81,0x40,0x40,
   0x80,0x81,0x81,0x82,0x82,0x80,
   0x81,0x82,0x40,0x40,0x40,0x40,
   0x81,0x81,0x82,0x82,0x00,0x20,0x00,0x00,0x81,0x40,
   0x40,0x40,0x40,0x40,0x40,0x40,0x00,0x40,
   0x90,0x90,0x91,0x92,0x90,0x40,0x40,0x90,
   0x82,0x82,0x00,0x80
};

u8 cputype[] =
{
   M020UP,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M010UP,M680x0,M680x0,M010UP,
   M020UP,M680x0,M680x0,M020UP,M680x0,M680x0,M680x0,M020UP,M680x0,M680x0,M680x0,
   M020UP,M020UP,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M010UP,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M020UP,M680x0,
   M680x0,M680x0,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,
   M020UP,M020UP,M020UP,M020UP,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,
   M680x0,M680x0,M680x0,M680x0,M680x0,M020UP,M020UP,M68020,M68020,M020UP,
   M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M680x0,M010UP,
   M680x0,M020UP,M020UP,M020UP,M680x0,M680x0,M680x0,M680x0,
   M040UP,M040UP,M68040,M680x0
};

char *bitshift[] =
{
   "AS","LS","ROX","RO",
   "@" // [END]
};

char *condcode[] =
{
   "T","F","HI","LS","CC","CS","NE","EQ","VC","VS","PL","MI",
   "GE","LT","GT","LE","RA","SR",
   "@" // [END]
};

char *mmu_cc[] =
{
   "BS","BC","LS","LC","SS","SC","AS","AC",
   "WS","WC","IS","IC","GS","GC","CS","CC"
   "@" // [END]
};

char *fpu_cc[] =
{
   "F","EQ","OGT","OGE","OLT","OLE","OGL","OR",
   "UN","UEQ","UGT","UGE","ULT","ULE","NE","T",
   "SF","SEQ","GT","GE","LT","LE","GL","GLE",
   "NGLE","NGL","NLE","NLT","NGE","NGT","SNE","ST"
   "@" // [END]
};

char *extension[] =
{
   ".B","",".L",
   "@" // [END]
};

char *caches[] =
{
   "NC","DC","IC","BC",
   "@" // [END]
};

char *bitop[] =
{
   "TST","CHG","CLR","SET",
   "@" // [END]
};

char *memtypename[] =
{
   "PUBLIC","CHIP","FAST","???",
   "@" // [END]
};

char *modname[] =
{
   "CODE","DATA","BSS",
   "@" // [END]
};

char *bitfield[] =
{
   "TST","EXTU","CHG","EXTS","CLR","FFO","SET","INS",
   "@" // [END]
};

char *cregname[] =
{
   "SFC","DFC","CACR","TC", "ITT0","ITT1", "DTT0","DTT1","BUSCR",
   "USP","VBR","CAAR","MSP","ISP", "MMUSR","URP", "SRP","PCR",
   "@" // [END]
};

u16 cregflag[18] =
{
   M010UP,M010UP,M020UP,M040UP,M040UP,M040UP,M040UP,M040UP,M68060,
   M010UP,M010UP,M68020|M68030,M020UP,M020UP,M68040,M040UP,M040UP,M68060
};

struct x_adr x_adrs[] =
{
   // =====================
   { "STACK_INIT",   0x0000, },
   { "PC_INIT",   0x0004, },
   { "BUS_ERROR",  0x0008, },
   { "ADR_ERROR",  0x000C, },
   { "ILLEG_OPC",  0x0010, },
   { "DIVISION0",  0x0014, },
   { "CHK",        0x0018, },
   { "TRAPV",      0x001C, },
   { "PRIVILEG",   0x0020, },
   { "TRACE",      0x0024, },
   { "LINEA_EMU",  0x0028, },
   { "LINEF_EMU",  0x002C, },
   // ---------------------
   { "INT_NOINI",  0x003C, },
   // ---------------------
   { "INT_WRONG",  0x0060, },
   { "AUTO_INT1",  0x0064, },
   { "AUTO_INT2",  0x0068, },
   { "AUTO_INT3",  0x006C, },
   { "AUTO_INT4",  0x0070, },
   { "AUTO_INT5",  0x0074, },
   { "AUTO_INT6",  0x0078, },
   { "NMI",        0x007C, },
   // ---------------------
   { "TRAP_01",    0x0080, },
   { "TRAP_02",    0x0084, },
   { "TRAP_03",    0x0088, },
   { "TRAP_04",    0x008C, },
   { "TRAP_05",    0x0090, },
   { "TRAP_06",    0x0094, },
   { "TRAP_07",    0x0098, },
   { "TRAP_08",    0x009C, },
   { "TRAP_09",    0x00A0, },
   { "TRAP_10",    0x00A4, },
   { "TRAP_11",    0x00A8, },
   { "TRAP_12",    0x00AC, },
   { "TRAP_13",    0x00B0, },
   { "TRAP_14",    0x00B4, },
   { "TRAP_15",    0x00B8, },
   // =====================
};


u16 opcstart[16];
u16 opccount[16];
u16 SIZEOF_RESULT;
u32 ADRCOUNT;
int extens;
int extra;
int dummy;
u32 displace;


int pflags;
#define OLDSTYLE 1
#define ADR_OUTPUT 2

void ExitPrg(char *errtext, ...)
{
va_list arguments;
u32 i;

   if (errtext) {
      va_start(arguments,errtext);
      vprintf(errtext,arguments);
      fprintf(stderr, "\n");
      va_end(arguments);
   }
   exit(1);
}

void InitOpcode(void)
{
   u16 i;

   SIZEOF_RESULT=sizeof(result);
   ADRCOUNT=sizeof(x_adrs)/sizeof(struct x_adr);
   for(i=0;i<(sizeof(result))/sizeof(u16)-1;i++) {
      if (opccount[result[i]>>12]==0) opcstart[result[i]>>12]=i;
      opccount[result[i]>>12]++;
   }

   if (sizeof(result)!=sizeof(sourceadr))
      ExitPrg("sizeof(result) != sizeof(sourceadr)");
   if (sizeof(result)!=sizeof(destadr))
      ExitPrg("sizeof(result) != sizeof(destadr)");
   if (sizeof(result)!=sizeof(maske))
      ExitPrg("sizeof(result) != sizeof(maske)");
   if (sizeof(result)/sizeof(u16)!=sizeof(flags)/sizeof(u8))
      ExitPrg("sizeof(result) != sizeof(flags)");

}

static int CPUTYPE;
static u16  sigw;
static int opcnumber;
static int adrmode;
static int reg1, reg2;

void GetOpcode(void)
{
u16 i;

   /* set the number of the opcode to the maximum (DC.W) as default. */
   opcnumber=SIZEOF_RESULT/sizeof(u16)-1;
   for(i=opcstart[sigw>>12];i<opcstart[sigw>>12]+opccount[sigw>>12];i++) {
      if ((sigw&maske[i])==result[i]) {
         if (cputype[i]&CPUTYPE) {
            opcnumber=i;
            break;
         }
      }
   }

   /* split up the opcode */
   reg1=(sigw&0x0e00)>>9;
   reg2=(sigw&0x0007);
   adrmode=(sigw&0x003f);
   if (adrmode<0x38) adrmode=(adrmode>>3);
   else adrmode=7+reg2;
   if (flags[opcnumber]&0x80) extens=flags[opcnumber]&0x03;
   else extens=(sigw&0x00c0)>>6;

}

// int to ascii (signed, decimal)
char *ira_itoa(u32 ta)
{
   static char ira_itoa_buf[64];

//   return itoa((int) ta, ira_itoa_buf, 10);
   sprintf(ira_itoa_buf, "%d", ta);
   return ira_itoa_buf;
}

char *ira_itox(u32 ta)
{
   static char ira_itoa_buf[64];

   sprintf(ira_itoa_buf, "$%x", ta);
   return ira_itoa_buf;
}

// int to ascii (signed, decimal)
char *itohex(u32 ta, u32 digits)
{
   static char ira_itohex_buf[64];
   char format[8];

   sprintf(format,"%%%02dX",digits);	// Make "%0?x"
   sprintf(ira_itohex_buf,format,ta);

   return ira_itohex_buf;
}

char mnebuf[256];
char adrbuf[256];
char dtabuf[256];

u16 *buffer;
int prgstart = 0;
int prgcount = 0;

char outline[256];

void GetLabel(int adr, int mode)
{
	char b[64];
	sprintf(b, "<label>");
	sprintf(b, "$%x.L", adr);
	strcat(adrbuf, b);
}

void output(void)
{
short i;
   if (pflags&ADR_OUTPUT) {
      if (dtabuf[0]) {
         i = 3-strlen(adrbuf)/8;
         if (i<=0) strcat(adrbuf, " ");
         for(;i>0;i--) strcat(adrbuf, "\t");
         sprintf(outline,"\t%s\t%s;%s",mnebuf,adrbuf,dtabuf);
      }
      else if (adrbuf[0])
	      sprintf(outline,"\t%s\t%sn",mnebuf,adrbuf);
      else
	      sprintf(outline,"\t%s",mnebuf);
   }
   else {
      if (adrbuf[0]) sprintf(outline,"\t%s\t%s",mnebuf,adrbuf);
      else sprintf(outline,"\t%s",mnebuf);
   }
   dtabuf[0]=0;
   adrbuf[0]=0;
   mnebuf[0]=0;
}

u16 NewAdrModes2(u16 mode,u16 reg)
/* AdrType :  6 --> Baseregister An */
/*           10 --> PC-relative     */
{
u16 buf=get16(&buffer[prgcount]);
u16 scale;
u16 bdsize;
u16 odsize;
u16 iis;
u16 is;
u16 operand,square1,square2;
int  adr;


   /* note:: odd offsets not allowed on A68K */
   if (CPUTYPE&(M68000|M68010)) {
      if (buf&0x0700) return(NOADRMODE);
      else {
         if (mode==10) {
            adr = ((prgcount-1)*2+prgstart+(char)buf);
            if ((adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR)))
               return(NOADRMODE);
         }
         if (pflags&OLDSTYLE) {
            if (mode==10) GetLabel(adr,mode);
	    strcat(adrbuf, ira_itoa((char)(buf&0x00FF)));
            strcat(adrbuf, "(");
         }
         else {
            strcat(adrbuf, "(");
            if (mode==10) GetLabel(adr,mode);
            strcat(adrbuf, ira_itoa((char)(buf&0x00FF)));
            strcat(adrbuf, ",");
         }
         if (mode==6) {
            strcat(adrbuf, "A");
            strcat(adrbuf, itohex(reg,1));
         }
         else strcat(adrbuf, "PC");
         if (buf&0x8000) strcat(adrbuf, ",A");
         else strcat(adrbuf, ",D");
         strcat(adrbuf, itohex((buf>>12)&7,1));
         if (buf&0x0800) strcat(adrbuf, ".L");
         /* else strcat(adrbuf, (".W"); */
      }
   }
   else {
      scale =(buf&0x0600)>>9;
      if (buf&0x0100) { /* MC68020 (& up) FULL FORMAT */
         bdsize=(buf&0x0030)>>4;
         odsize=(buf&0x0003);
         iis   =(buf&0x0007);
         is    =(buf&0x0040)>>6;
         operand=square1=square2=0;

         if (mode==10) reg=0;
         if (buf&8)                 return(NOADRMODE);
         if (bdsize==0)             return(NOADRMODE);
         if (is==0 && iis==4)       return(NOADRMODE);
         if (is==1 && iis>=4)       return(NOADRMODE);
/*
         if (is==1 && (buf&0xfe00)) return(NOADRMODE);
         if (buf&0x0080 && reg!=0)  return(NOADRMODE);
*/
         if (bdsize>1)               {operand|=1;square1|=1;}
         if (!(buf&0x0080))          {operand|=2;square1|=2;}
         if (buf&0x0080 && mode==10) {operand|=2;square1|=2;}
         if (is==0 || buf&0xF000) {
            operand|=4;
            if (iis<4) square1|=4;
         }
         if (odsize>1) operand|=8;
         if (iis!=0)   square2=square1;
         else          square1=0;
         operand&=~square1;
         if (!square1) operand|=6;

         strcat(adrbuf, "(");
         if (square1) strcat(adrbuf, "[");
         if ((square1|operand)&1) { /* base displacement */
            if (bdsize==2) {
               if (mode==10 && !(buf&0x0080)) {
                  adr = ((prgcount-1)*2+prgstart+(short)buffer[prgcount]);
                  if ((adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR)))
                     return(NOADRMODE);
                  GetLabel(adr,mode);
               }
               else {
		       strcat(adrbuf, ira_itoa((short)get16(&buffer[prgcount-1])));
               }
            }
            if (bdsize==3) {
		  strcat(dtabuf, itohex(get16(&buffer[prgcount++]),4));
                  if (mode==10 && !(buf&0x0080)) {
                     adr = ((prgcount-2)*2+prgstart+(buffer[prgcount-1]<<16)+buffer[prgcount]);
                     if ((adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR)))
                        return(NOADRMODE);
                     GetLabel(adr,mode);
                     strcat(adrbuf, ".L");
                  }
                  else {
                     strcat(adrbuf, "$");
                     strcat(adrbuf, itohex(get16(&buffer[prgcount-2]),4));
		     strcat(adrbuf, itohex(get16(&buffer[prgcount-1]),4));
                  }

            }
            square1&=~1;
            operand&=~1;
            if (square2 && !square1) {strcat(adrbuf, "]");square2=0;}
            if (square1 || operand)  strcat(adrbuf, ",");
         }
         /* base register or (Z)PC */
         if ((square1|operand)&2) {
            if (buf&0x0080) strcat(adrbuf, "Z");
            if (mode == 6) {
               strcat(adrbuf, "A");
               strcat(adrbuf, itohex(reg,1));
            }
            else {
               strcat(adrbuf, "PC");
            }
            square1&=~2;
            operand&=~2;
            if (square2 && !square1) {strcat(adrbuf, "]");square2=0;}
            if (square1 || operand)  strcat(adrbuf, ",");
         }
         /* index register */
         if ((square1|operand)&4) {
            if (is) strcat(adrbuf, "Z");
            if (buf&0x8000) strcat(adrbuf, "A");
            else strcat(adrbuf, "D");
            strcat(adrbuf, itohex((buf>>12)&7,1));
            if (buf&0x0800) strcat(adrbuf, ".L");
            /* else strcat(adrbuf, ".W"); */
            if (scale) {
               strcat(adrbuf, "*");
               strcat(adrbuf, ira_itoa(1<<scale));
            }
            square1&=~4;
            operand&=~4;
            if (square2 && !square1) {strcat(adrbuf, "]");square2=0;}
            if (square1 || operand)  strcat(adrbuf, ",");
         }
         /* outer displacement */
         if (operand&8) {
            if (odsize==2) {
		    strcat(adrbuf, ira_itoa((short)get16(&buffer[prgcount-1])));
            }
            if (odsize==3) {
		    strcat(dtabuf, itohex(get16(&buffer[prgcount++]),4));
		    adr=(get16(&buffer[prgcount-2])<<16)+get16(&buffer[prgcount-1]);
		    strcat(adrbuf, ira_itoa(adr));
		    strcat(adrbuf, ".L");
/*
                  strcat(adrbuf, "$");
                  strcat(adrbuf, itohex(buffer[prgcount-2],4));
                  strcat(adrbuf, itohex(buffer[prgcount-1],4));
*/

            }
         }
      }
      else { /* MC68020 (& up) BRIEF FORMAT */
         if (mode==10) {
            adr = ((prgcount-1)*2+prgstart+(char)buf);
            if ((adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR)))
               return(NOADRMODE);
         }
         if (pflags&OLDSTYLE) {
            if (mode==10) GetLabel(adr,mode);
            else strcat(adrbuf, ira_itoa((char)(buf&0x00FF)));
            strcat(adrbuf, "(");
         }
         else {
            strcat(adrbuf, "(");
            if (mode==10) GetLabel(adr,mode);
            else strcat(adrbuf, ira_itoa((char)(buf&0x00FF)));
            strcat(adrbuf, ",");
         }
         if (mode==6) {
            strcat(adrbuf, "A");
            strcat(adrbuf, itohex(reg,1));
         }
         else strcat(adrbuf, "PC");
         if (buf&0x8000) strcat(adrbuf, ",A");
         else strcat(adrbuf, ",D");
         strcat(adrbuf, itohex((buf>>12)&7,1));
         if (buf&0x0800) strcat(adrbuf, ".L");
         /* else strcat(adrbuf, ".W"); */
         if (scale) {
            strcat(adrbuf, "*");
            strcat(adrbuf, ira_itoa(1<<scale));
         }
      }
   }
   strcat(adrbuf, ")");
   return(mode);
}

int DoAdress2(u16 adrs)
{
u16 i;
u16 mode=adrmode;
u16 dummy1;
u16 buf=get16(&buffer[prgcount]);
u16 reg,creg;
int  adr;

   if (mode!=NOADRMODE) {
      /* if (mode>0x30) mode=0x07+(mode&0x07); */

      if (adrs&0x2000) reg=reg1;
      else reg=reg2;

      if (adrs&0x8000) mode=adrs&0x00FF;
      else
         if ((adrs&0x0fff)==adrs)
            if (!(adrs&(0x0800>>mode))) mode=NOADRMODE;
   }

   /* decode addressing mode */
   switch (mode) {
      case  0: /* data register direct */
               strcat(adrbuf, "D");
               strcat(adrbuf, itohex(reg,1));
               break;
      case  1: /* address register direct */
               if (extens || opcnumber==OPC_LEA) {
                  strcat(adrbuf, "A");
                  strcat(adrbuf, itohex(reg,1));
               }
               else mode=NOADRMODE;
               break;
      case  2: /* address register indirect */
               strcat(adrbuf, "(A");
               strcat(adrbuf, itohex(reg,1));
               strcat(adrbuf, ")");
               break;
      case  3: /* (An)+ address register indirect with postincrement */
               strcat(adrbuf, "(A");
               strcat(adrbuf, itohex(reg,1));
               strcat(adrbuf, ")+");
               break;
      case  4: /* address register indirect witht predecrement */
               strcat(adrbuf, "-(A");
               strcat(adrbuf, itohex(reg,1));
               strcat(adrbuf, ")");
               break;
      case  5: /* (d16,An) address register indirect with 16Bit-Offset */
               /* note: odd offsets are not allowed in A68K */
	      if (pflags&OLDSTYLE) {
		      strcat(adrbuf, ira_itoa((short)buf));
		      strcat(adrbuf, "(A");
	      }
	      else {
		      strcat(adrbuf, "(");
		      strcat(adrbuf, ira_itoa((short)buf));
		      strcat(adrbuf, ",A");
	      }

	      strcat(adrbuf, itohex(reg,1));
	      strcat(adrbuf, ")");
	      prgcount++;
               break;
      case  6: /* (bd,An,Xn.SIZE*SCALE) & ([bd,An,Xn.SIZE*SCALE],od) & ... */
      case 10: /* (bd,PC,Xn.SIZE*SCALE) & ([bd,PC,Xn.SIZE*SCALE],od) & ... */
               if ((mode=NewAdrModes2(mode,reg))==-1) return(-1);
               break;
      case  7: /* Absolute Adresse 16Bit */
               adr = (short)buf;
               if (adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR || opcnumber==OPC_BITSHIFT1))
                  mode=NOADRMODE;
               else {
                  /* strcat(adrbuf, "("); */
                  /* PEA  for c-programs */
                  if (opcnumber == OPC_PEA)   strcat(adrbuf, ira_itoa(adr));
                  else   {
                        GetLabel(adr,mode);
                  }
                  /* strcat(adrbuf, ").W"); */
                  strcat(adrbuf, ".W");
               }
	       prgcount++;
               break;
      case  8: /* Absolute Adresse 32Bit */
	      adr = ((buf<<16) + get16(&buffer[prgcount+1]));
               if (adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR || opcnumber==OPC_BITSHIFT1))
                  mode=NOADRMODE;
               else {
                     /* PEA  for c-programs */
                     if (opcnumber == OPC_PEA) {
                        strcat(adrbuf, "$");
                        strcat(adrbuf, itohex(adr,8));
                     }
                     else {
                           GetLabel(adr,mode);
                     }

		     strcat(dtabuf, itohex(get16(&buffer[prgcount++]),4));
		     strcat(dtabuf, itohex(get16(&buffer[prgcount++]),4));
               }
               break;
      case  9: /* PC - Relativ */
               adr = (prgcount*2+prgstart+(short)buf);
               if ((adr&1 && (extens || opcnumber==OPC_JMP || opcnumber==OPC_JSR))) mode=NOADRMODE;
               else {
                  if (pflags&OLDSTYLE) {
                     GetLabel(adr,mode);
                     strcat(adrbuf, "(PC)");
                  }
                  else {
                     strcat(adrbuf, "(");
                     GetLabel(adr,mode);
                     strcat(adrbuf, ",PC)");
                  }
               }
	       prgcount++;
               break;
      case 11: /* IMMEDIATE */
               if (adrs==sourceadr[opcnumber]) {
                  if (extens!=3) {
                     if (extens==0) {
                        if (buf&0xFF00) mode=NOADRMODE;
                        else {
                           strcat(adrbuf, "#$");
                           strcat(adrbuf, itohex(buf,2));
                        }
                     }
                     if (extens==1) {
                        strcat(adrbuf, "#$");
                        strcat(adrbuf, itohex(buf,4));
			prgcount++;
                     }
                     if (extens==2) {
                        /* adr = ((buf<<16) + buffer[prgcount+1]); */
			strcat(adrbuf, "#$");
			strcat(adrbuf, itohex(buf,4));
			strcat(adrbuf, itohex(get16(&buffer[prgcount+1]),4));

			strcat(dtabuf, itohex(get16(&buffer[prgcount++]),4));
			strcat(dtabuf, itohex(get16(&buffer[prgcount++]),4));
                     }
                  }
                  else mode=NOADRMODE;
               }
               else {
                  if (extens==0) strcat(adrbuf, "CCR");
                  if (extens==1) strcat(adrbuf, "SR");
                  if (extens==2) mode=NOADRMODE; /* d=immediate long */
               }
               break;
      case 12: strcat(adrbuf, "CCR");
               break;
      case 13: strcat(adrbuf, "SR");
               break;
      case 14: strcat(adrbuf, "USP");
               break;
      case 15: /* MOVEM */
               if (dummy1=extra) {
                  i=0;
                  if ((opcnumber==OPC_MOVEM1 || opcnumber==OPC_MOVEM3) && !(sigw&0x0018)) {
                     while(dummy1) {
                        if (dummy1&0x8000) {
                           if (i<8) strcat(adrbuf, "D");
                           else strcat(adrbuf, "A");
                           strcat(adrbuf, itohex(i&7,1));
                           if ((dummy1&0x4000) && (i&7)<7) {
                              strcat(adrbuf, "-");
                              while((dummy1&0x4000) && (i&7)<7) {
                                 dummy1<<=1;
                                 i++;
                              }
                              if (i<8) strcat(adrbuf, "D");
                              else strcat(adrbuf, "A");
                              strcat(adrbuf, itohex(i&7,1));
                           }
                           if ((u16)(dummy1<<1)) strcat(adrbuf, "/");
                        }
                        i++;
                        dummy1<<=1;
                     }
                  }
                  else {
                     while(dummy1 || i<16) {
                        if (dummy1&0x0001) {
                           if (i<8) strcat(adrbuf, "D");
                           else strcat(adrbuf, "A");
                           strcat(adrbuf, itohex(i&7,1));
                           if ((dummy1&0x0002) && (i&7)<7) {
                              strcat(adrbuf, "-");
                              while((dummy1&0x0002) && (i&7)<7) {
                                 dummy1>>=1;
                                 i++;
                              }
                              if (i<8) strcat(adrbuf, "D");
                              else strcat(adrbuf, "A");
                              strcat(adrbuf, itohex(i&7,1));
                           }
                           if (dummy1>>1) strcat(adrbuf, "/");
                        }
                        i++;
                        dummy1>>=1;
                     }
                  }
               }
               else {
                  strcat(adrbuf, "(NOREG!)");
               }
               break;
      case 16: /* ADDQ,SUBQ */
               strcat(adrbuf, "#");
               if (!reg) reg=8;
               strcat(adrbuf, itohex(reg,1));
               break;
      case 17: /* BKPT */
               strcat(adrbuf, "#");
               strcat(adrbuf, itohex(reg,1));
               break;
      case 18: /* DBcc */
               adr = (prgcount*2+prgstart+(short)buf);
               if (adr&1 || !buf)
                  mode=NOADRMODE;
               else {
                  GetLabel(adr,mode);
               }
	       prgcount++;
               break;
      case 19: /* TRAP */
               strcat(adrbuf, "#");
               strcat(adrbuf, ira_itoa(sigw&0xF));
               break;
      case 20: /* moveq */
               strcat(adrbuf, "#");
               strcat(adrbuf, ira_itox((char)(sigw&0x00FF)));
               break;
      case 21: /* Bcc */
               if ((sigw&0x00ff)==0x00ff) {
                  if (CPUTYPE&M020UP) {
			  displace=(buf<<16)|get16(&buffer[prgcount+1]);
                     if (displace!=0 && displace!=2) {
                        displace+=prgcount*2;
                        strcat(mnebuf, ".L");
			prgcount++;
			prgcount++;
                     }
                     else mode=NOADRMODE;
                  }
                  else mode=NOADRMODE;
               } else if ((sigw&0x00ff)==0x0000) {
                  if (buf) {
                     displace=(prgcount*2+(short)(buf));
		     prgcount++;
                  }
                  else mode=NOADRMODE;
               } else {
                  strcat(mnebuf, ".S");
                  displace=(prgcount*2+(char)(sigw&0x00ff));
               }
               adr = prgstart+displace;
               if (adr&1)
                  mode=NOADRMODE;
               else GetLabel(adr,mode);
               break;
      case 22: /* LINK , RTD */
               if (buf&1) mode=NOADRMODE;
               else {
                  strcat(adrbuf, "#");
                  strcat(adrbuf, ira_itoa((short)buf));
		  prgcount++;
               }
               break;
      case 23: /* BTST,BCLR,... IMMEDIATE&REGISTER,SOURCEOP ONLY */
               strcat(mnebuf, &bitop[extens][0]);
               if (!extens) destadr[opcnumber]=0x0bfe; /* BTST */
               else destadr[opcnumber]=0x0bf8;        /* sonstige B... */
               if (sigw&0x0100) {
                  strcat(adrbuf, "D");
                  strcat(adrbuf, itohex(reg,1));
               }
               else {
                  strcat(adrbuf, "#");
                  if (sigw&0x0038) {
                     if (buf&0xFFF8) mode=NOADRMODE;
                  }
                  else {
                     if (buf&0xFFE0) mode=NOADRMODE;
                  }
                  strcat(adrbuf, ira_itoa(buf));
               }
               extens=0; /* Set extension to BYTE (undefined before) */
	       prgcount++;
               break;
      case 24: /* STOP */
               strcat(adrbuf, "#$");
               strcat(adrbuf, itohex(buf,4));
	       prgcount++;
               break;
      case 25: /* BITFIELD */
               strcat(adrbuf, "{");
               reg=(extra&0x07c0)>>6;
               if (extra&0x0800) {
                  if (reg>7) mode=NOADRMODE;
                  strcat(adrbuf, "D");
               }
               strcat(adrbuf, ira_itoa(reg));
               strcat(adrbuf, ":");
               reg=(extra&0x001F);
               if (extra&0x0020) {
                  if (reg>7) mode=NOADRMODE;
                  strcat(adrbuf, "D");
               }
               strcat(adrbuf, ira_itoa(reg));
               strcat(adrbuf, "}");
               if (((sigw&0x0700)>>8)&1) {
                  /* BFEXTU, BFEXTS, BFFFO, BFINS */
                  if (extra&0x8000) mode=NOADRMODE;
                  strcat(adrbuf, ",D");
                  reg=(extra&0x7000)>>12;
                  strcat(adrbuf, ira_itoa(reg));
               }
               else {
                  if (extra&0xF000) mode=NOADRMODE;
               }
               break;
      case 26: /* RTM */
               if (sigw&0x0008) strcat(adrbuf, "A");
               else strcat(adrbuf, "D");
               strcat(adrbuf, ira_itoa(reg2));
               break;
      case 27: /* CAS2  SOURCE/DESTINATION */
	      buf=get16(&buffer[prgcount]);
               extens=(sigw&0x0600)>>9;
               if (extens==0 || extens==1) mode=NOADRMODE;
               else strcat(mnebuf, extension[--extens]);
               if (buf&0x0e38 || extra&0x0e38) mode=NOADRMODE;
               else {
                  strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa(extra&7));
                  strcat(adrbuf, ":");
                  strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa(buf&7));
                  strcat(adrbuf, ",");
                  strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa((extra&0x01c0)>>6));
                  strcat(adrbuf, ":");
                  strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa((buf&0x01c0)>>6));
                  strcat(adrbuf, ",");
                  if (extra&0x8000) strcat(adrbuf, "(A");
                  else strcat(adrbuf, "(D");
                  strcat(adrbuf, ira_itoa((extra&0x7000)>>12));
                  strcat(adrbuf, "):(");
                  if (buf&0x8000) strcat(adrbuf, "(A");
                  else strcat(adrbuf, "(D");
                  strcat(adrbuf, ira_itoa((buf&0x7000)>>12));
                  strcat(adrbuf, ")");
               }
	       prgcount++;
               break;
      case 28: /* CAS SOURCE */
               extens=(sigw&0x0600)>>9;
               if (extens==0) mode=NOADRMODE;
               else strcat(mnebuf, extension[--extens]);
               if (extra&0xfe38) mode=NOADRMODE;
               else {
                  strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa(extra&7));
                  strcat(adrbuf, ",");
                  strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa((extra&0x01c0)>>6));
               }
               break;
      case 29: /* DIVIDE/MULTIPLY int  SIGNED/UNSIGNED */
               if (extra&0x83f8) mode=NOADRMODE;
               else {
                  if (extra&0x0800) strcat(mnebuf, "S");
                  else strcat(mnebuf, "U");
                  if (!(extra&0x0400) && opcnumber==OPC_DIVL) strcat(mnebuf, "L");
                  reg=(extra&0x7000)>>12;
                  strcat(adrbuf, "D");
                  if (reg==(extra&0x0007)) {
                     if (opcnumber==OPC_MULL) mode=NOADRMODE;
                     else strcat(adrbuf, ira_itoa(reg));
                  }
                  else {                  
                     strcat(adrbuf, ira_itoa(extra&0x0007));
                     strcat(adrbuf, ":D");
                     strcat(adrbuf, ira_itoa(reg));
                  }
                  strcat(mnebuf, ".L");
               }
               break;
      case 30: /* LINK LONG */
	      displace=(buf<<16)|get16(&buffer[prgcount+1]);
               if (displace&1) mode=NOADRMODE;
               else {
                  strcat(adrbuf, "#");
                  strcat(adrbuf, ira_itoa(displace));
               }
	       prgcount++;
	       prgcount++;
               break;
      case 31: /* MOVE16 POSTINCREMENT ONLY (DESTINATION) */
               if ((buf&0x8fff)!=0x8000) mode=NOADRMODE;
               else {
                  strcat(adrbuf, "(A");
                  strcat(adrbuf, ira_itoa((buf&0x7000)>>12));
                  strcat(adrbuf, ")+");
               }
	       prgcount++;
               break;
      case 32: /* CINV & CPUSH */
               if (sigw&0x0020) strcat(mnebuf, "PUSH");
               else strcat(mnebuf, "INV");
               destadr[opcnumber]=0x8002;
               switch ((sigw&0x0018)>>3) {
                  case 0:
                     mode=NOADRMODE;
                     break;
                  case 1:
                     strcat(mnebuf, "L");
                     break;
                  case 2:
                     strcat(mnebuf, "P");
                     break;
                  case 3:
                     if (sigw&7) mode=NOADRMODE;
                     else {
                        strcat(mnebuf, "A");
                        destadr[opcnumber]=0x0000;
                     }
                     break;
               }
               strcat(adrbuf, caches[(sigw&0x00c0)>>6]);
               break;
      case 33: /* MOVEC */
               reg =(buf&0x7000)>>12;
               creg=buf&0x0fff;
               if (creg&0x07f8) mode=NOADRMODE;
               else {
                  if (sigw&1) {
                     if (buf&0x8000) strcat(adrbuf, "A");
                     else strcat(adrbuf, "D");
                     strcat(adrbuf, ira_itoa(reg));
                     strcat(adrbuf, ",");
                  }
                  if (creg&0x0800) creg=(creg%8)+9;
                  if (CPUTYPE&cregflag[creg]) strcat(adrbuf, cregname[creg]);
                  else mode=NOADRMODE;
                  if (!(sigw&1)) {
                     strcat(adrbuf, ",");
                     if (buf&0x8000) strcat(adrbuf, "A");
                     else strcat(adrbuf, "D");
                     strcat(adrbuf, ira_itoa(reg));
                  }
               }
	       prgcount++;
               break;
         case 34: /* MOVES */
               if (extra&0x07ff) mode=NOADRMODE;
               else {
                  reg=(extra&0x7000)>>12;
                  if (extra&0x8000) strcat(adrbuf, "A");
                  else strcat(adrbuf, "D");
                  strcat(adrbuf, ira_itoa(reg));
               }
               break;
   }

   if (mode==NOADRMODE) {
      adrbuf[0]=0;
      mnebuf[0]=0;
      dtabuf[0]=0;
      strcat(mnebuf, "DC.W");
      strcat(adrbuf, "$");
      strcat(adrbuf, itohex(sigw,4));
      strcat(dtabuf, itohex(/*pc*2+*/prgstart,4/*adrlen*/));
      prgcount += 2;
      output();
      return(-1);
   }

   return(0);
}

void *dis2(void *p, u32 adr, char *code)
{
	buffer = (u16 *)p;
	prgstart = adr;
	prgcount = 0;
again:
	sigw=(u16)get16(&buffer[prgcount++]);

	 mnebuf[0] = 0;
	 adrbuf[0] = 0;
	 dtabuf[0] = 0;

         GetOpcode();
         strcat(mnebuf, &opcode[opcnumber][0]);
         if (flags[opcnumber]&0x20) {
		 extra=get16(&buffer[prgcount]);
		 prgcount++;
         }
         if (flags[opcnumber]&0x10) {
            dummy=(sigw&0x0f00)>>8;
            if (opcnumber==OPC_BCC && dummy<2) dummy+=16;
            strcat(mnebuf, condcode[dummy]);
         }

         if (opcnumber == OPC_CMPI) {
            if (CPUTYPE&M020UP) destadr[opcnumber]=0x0bfe;
            else destadr[opcnumber]=0x0bf8;
         } else if (opcnumber == OPC_BITSHIFT1) {
            /* SHIFT & ROTATE memory */
            strcat(mnebuf, bitshift[(sigw>>9)&0x0003]);
            if (sigw&0x0100) strcat(mnebuf, "L");
            else strcat(mnebuf, "R");
         } else if (opcnumber == OPC_BITSHIFT2) {
            /* SHIFT & ROTATE Data Register */
            strcat(mnebuf, bitshift[(sigw>>3)&0x0003]);
            if (sigw&0x0100) strcat(mnebuf, "L");
            else strcat(mnebuf, "R");
            if (sigw&0x0020) strcat(adrbuf, "D");
            else {
               strcat(adrbuf, "#");
               if (!reg1) reg1=8;
            }
            strcat(adrbuf, itohex(reg1,1));
            strcat(adrbuf, ",");
         } else if (opcnumber==OPC_TST) {
            if (CPUTYPE&M020UP) sourceadr[opcnumber]=0x0fff;
            else sourceadr[opcnumber]=0x0bf8;
         } else if (opcnumber==OPC_BITFIELD) {
            dummy=(sigw&0x0700)>>8;
            strcat(mnebuf, bitfield[dummy]);
            if (dummy==2 || dummy==4 || dummy==6 || dummy==7) sourceadr[opcnumber]=0x0a78;
            else sourceadr[opcnumber]=0x0a7e;
         } else if (opcnumber==OPC_C2) {
            if (extra&0x07ff) adrmode=NOADRMODE;
            else {
               if (extra&0x0800) strcat(mnebuf, "HK2");
               else strcat(mnebuf, "MP2");
               reg1=(extra&0x7000)>>12;
               if (extra&0x8000) destadr[opcnumber]=0xa001;
               else destadr[opcnumber]=0xa000;
            }
         } else if (opcnumber==OPC_MOVE162) {
		 switch ((get16(&buffer[prgcount])&0x0018)>>3) {
               case 0: /* (An)+,(xxx).L */
                  sourceadr[opcnumber]=0x8003;
                  destadr[opcnumber]  =0x8008;
                  break;
               case 1: /* (xxx).L,(An)+ */
                  sourceadr[opcnumber]=0x8008;
                  destadr[opcnumber]  =0x8003;
                  break;
               case 2: /* (An) ,(xxx).L */
                  sourceadr[opcnumber]=0x8002;
                  destadr[opcnumber]  =0x8008;
                  break;
               case 3: /* (xxx).L, (An) */
                  sourceadr[opcnumber]=0x8008;
                  destadr[opcnumber]  =0x8002;
                  break;
            }
         } else if (opcnumber==OPC_MOVES) {
            if (extra&0x0800) {
               sourceadr[opcnumber]=0x8022;
               destadr[opcnumber]  =0x03f8;
            }
            else {
               sourceadr[opcnumber]=0x03f8;
               destadr[opcnumber]  =0x8022;
            }
         }

         if (flags[opcnumber]&0x40) {
            if (extens!=3)
               strcat(mnebuf, extension[extens]);
            else
               adrmode=NOADRMODE;
         }

         if (sourceadr[opcnumber]) {
		 if (DoAdress2(sourceadr[opcnumber])) goto bail/*continue*/;
            if (opcnumber!=OPC_BITFIELD)
               if (destadr[opcnumber]) strcat(adrbuf, ",");
         }
         if (destadr[opcnumber]) {
            if (opcnumber==OPC_MOVEB || opcnumber==OPC_MOVEW || opcnumber==OPC_MOVEL) {
               adrmode=((sigw&0x01c0)>>3)|reg1;
               if (adrmode<0x38) adrmode=(adrmode>>3);
               else adrmode=7+reg1;
               reg2=reg1;
            }
            if (DoAdress2(destadr[opcnumber])) goto bail; /*continue*/;
            if (opcnumber==OPC_PACK1 || opcnumber==OPC_PACK2 ||
                opcnumber==OPC_UNPK1 || opcnumber==OPC_UNPK2) {
               strcat(adrbuf, ",#$");
               strcat(adrbuf, itohex(extra,4));
            }
         }

bail:
         output();
	 sprintf(code, "%08x %s", adr, outline);

	 return (void *)&buffer[prgcount];
}

void dis2_init(void)
{
	CPUTYPE = M68000;
	pflags = OLDSTYLE/* | ADR_OUTPUT*/;

	InitOpcode();
}
