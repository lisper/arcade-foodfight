
ASM = ./asssembler/src/asmx

all: test1.asm.bin test2.asm.bin test3.asm.bin test4.asm.bin

test1.asm.bin: test1.asm
	$(ASM) -C 68000 -b 0 -l test1.lst test1.asm 

test2.asm.bin: test2.asm
	$(ASM) -C 68000 -b 0 -l test2.lst test2.asm 

test3.asm.bin: test3.asm
	$(ASM) -C 68000 -b 0 -l test3.lst test3.asm 
	od -An -tx1 -w2 -v test3.asm.bin | sed 's/ //g' >test3.hex

test4.asm.bin: test4.asm
	$(ASM) -C 68000 -b 0 -l test4.lst test4.asm 
	od -An -tx1 -w2 -v test4.asm.bin | sed 's/ //g' >test4.hex

clean:
	rm -rf *.lst *.bin *.hex

