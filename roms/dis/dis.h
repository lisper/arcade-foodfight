/*
**
** DIS.H
**
** Well, nobody is going to write a 68000 disasembler for me
*/

typedef unsigned short u16;

typedef struct {
	char *op;		/*	pointer to assembly nemonic */
	unsigned op_code;	/*	base op code */
	unsigned mask;		/*	mask to get rid of variable data */
				/*	function to call */
	u16 *(*d_funct)(u16 *c,long adr,char *s,int index);
} OP_DEF;

/*
** size tokens
*/

#define BYTE_SIZE	256
#define WORD_SIZE	257
#define LONG_SIZE	258

extern void *dis(void *c,long adr,char *s);

