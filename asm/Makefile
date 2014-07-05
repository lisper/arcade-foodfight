

all: test1.asm.bin test2.asm.bin test3.asm.bin

test1.asm.bin: test1.asm
	./asssembler/src/asmx  -C 68000 -b 0 -l test1.lst test1.asm 

test2.asm.bin: test2.asm
	./asssembler/src/asmx  -C 68000 -b 0 -l test2.lst test2.asm 

test3.asm.bin: test3.asm
	./asssembler/src/asmx  -C 68000 -b 0 -l test3.lst test3.asm 
	od -An -tx1 -w2 -v test3.asm.bin | sed 's/ //g' >test3.hex

clean:
	rm -rf *.lst *.bin *.hex

