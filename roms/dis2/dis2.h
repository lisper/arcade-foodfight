/*
 * simple m68k disassembler
 * can be used as library
 *
 * brad@heeltoe.com 9/2015
 */

/*
typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned int ULONG;
typedef char BYTE;
typedef short WORD;
typedef int LONG;
*/

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;

void dis2_init(void);
void *dis2(void *p, u32 adr, char *code);

unsigned get16(u16 *p);
unsigned get32(void *p);

#define M68000            1
#define M68010            2
#define M68020            4
#define M68030            8
#define M68040            16
#define M68060            32
#define M68851           128
#define M68881           256
#define M680x0            (1+2+4+8+16+32)
#define M010UP            (2+4+8+16+32)
#define M020UP            (4+8+16+32)
#define M030UP            (8+16+32)
#define M040UP            (16+32)


#define OPC_BITFIELD       0
#define OPC_BITSHIFT1      1
#define OPC_BITSHIFT2      2
#define OPC_RTE            6
#define OPC_RTR            7
#define OPC_RTS            8
#define OPC_RTD            9
#define OPC_DIVL          24
#define OPC_MULL          25
#define OPC_JMP           27
#define OPC_JSR           28
#define OPC_PEA           29
#define OPC_MOVEM1        35
#define OPC_MOVEM3        37
#define OPC_LEA           39
#define OPC_TST           43
#define OPC_PACK1         67
#define OPC_PACK2         68
#define OPC_UNPK1         69
#define OPC_UNPK2         70
#define OPC_MOVEB         77
#define OPC_MOVEW         79
#define OPC_MOVEAL        80
#define OPC_MOVEL         81
#define OPC_RTM           96
#define OPC_CALLM         97
#define OPC_C2            98
#define OPC_CMPI          99
#define OPC_MOVES        106
#define OPC_DBCC         107
#define OPC_BCC          114
#define OPC_MOVE162      116


#define NOADRMODE         99     /* Addressmode for DC.W */

struct x_adr {
	char name[12];
	u32 adr;
};

