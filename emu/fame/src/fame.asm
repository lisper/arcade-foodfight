; --------------------------------------------------
; Fast and Accurate Motorola 68000 Emulation Library
; FAME x86 version 2.0a (14-03-2006)
; Oscar Orallo Pelaez
; Assembly file generated on Jun  4 2014 14:56:36
; --------------------------------------------------
; Opciones de generacion empleadas:
; - Formato de generacion ELF (Linux)
; - Convencion de llamada por la pila
; - Optimizacion de tamano (codigo no alineado)
; - Bus de direcciones de 24 bits
; - Emulacion de lecturas tontas (ON)
; - Emulacion de comportamiento no documentado (ON)
; - Espacio de memoria multiple (usuario y supervisor)
; - Emulacion de excepciones del grupo 0 (ON)
; - Prefijo del nombre de las funciones: m68k
; - Realizar calculo preciso de ciclos de reloj (ON)
; - Cachear descriptores de mapas de memoria (OFF)
; - Realizar cuenta interna de ciclos de reloj (ON)
; - Emular bit 0 de execinfo (ON)
; - Emular excepcion de traza (ON)
; - Contar ciclos de generacion de las IRQs (ON)
; --------------------------------------------------
section .data
global _m68kcontext
times ($$-$)&7 db 0
_m68kcontext:
contextbegin:
__fetch                dd 0
__readbyte             dd 0
__readword             dd 0
__writebyte            dd 0
__writeword            dd 0
__s_fetch              dd 0
__s_readbyte           dd 0
__s_readword           dd 0
__s_writebyte          dd 0
__s_writeword          dd 0
__u_fetch              dd 0
__u_readbyte           dd 0
__u_readword           dd 0
__u_writebyte          dd 0
__u_writeword          dd 0
__resethandler         dd 0
__iackhandler          dd 0
__icusthandler         dd 0
__reg:
__dreg                 dd 0,0,0,0,0,0,0,0
__areg                 dd 0,0,0,0,0,0,0
__a7                   dd 0
__asp                  dd 0
__pc                   dd 0
__cycles_counter       dd 0
__interrupts           db 0,0,0,0,0,0,0,0
__sr                   dw 0
__execinfo             dw 0
contextend:
__cycles_needed        dd 0
__fetch_bank           dw 0
__xflag                db 0
__g0_spec_info     db 0
__io_cycle_counter     dd -1
__io_fetchbase         dd 0
__io_fetchbased_pc     dd 0
__access_address       dd 0
__tmp_int_level        dd 0
__fetch_vector         dd __sfmhtbl, __srwmhtbl, __ufmhtbl, __urwmhtbl
__fetch_idx            dd 0
__readbyte_idx         dd 0
__readword_idx         dd 0
__writebyte_idx        dd 0
__writeword_idx        dd 0
__excep_ptr        dd 0
__inst_reg         dw 0
__filler2          dw 0
__cb_table       db 0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,3,4,4,5,4,5,5,6,4,5,5,6,5,6,6,7,4,5,5,6,5,6,6,7,5,6,6,7,6,7,7,8
section .text
bits 32
cpu 386
top:
global m68k_init
m68k_init:
push esi
push edi
mov edi,__jmptbl
mov esi,__jmptblcomp
.decomp:
lodsd
mov ecx,eax
and eax,0FFFFFFh
shr ecx,24
add eax,top
inc ecx
.jloop:
mov [edi],eax
add edi,byte 4
dec ecx
jnz short .jloop
cmp edi,__jmptbl+262144
jne short .decomp
pop edi
pop esi
xor eax,eax
ret
global m68k_emulate
m68k_emulate:
test byte[__execinfo],4
jz short .cpuok
or eax,-1
ret
.cpuok:
mov eax,[esp+4]
test byte[__execinfo],80h
jz short .notstopped
add [__cycles_counter],eax
xor eax,eax
ret
.notstopped:
push ebp
push ebx
push esi
push edi
mov [__excep_ptr],esp
mov [__cycles_needed],eax
lea edi,[eax-1]
xor ebx,ebx
mov esi,[__pc]
mov al,[__sr]
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
or byte[__execinfo],1
call basefunction
add esi,ebp
test byte[__execinfo],0xA
jnz short execloop
int_check:
movsx cx,byte [__interrupts]
or cl,1
bsr cx,cx
mov ch,cl
mov cl,[__sr+1]
and cl,7
cmp ch,cl
ja flush_int
test byte[__execinfo],0x8
jnz short trace_excep
test_trace:
test byte[__sr+1],80h
jz short execloop
trace_excep:
or byte[__execinfo],8
mov [__cycles_needed],edi
xor edi,edi
add [__cycles_needed],byte 1
execloop:
mov bx,[esi]
add esi,byte 2
jmp dword[__jmptbl+ebx*4]
flush_int:
call flush_interrupts
call basefunction
add esi,ebp
sub edi,byte 44
jns short execloop
execend:
jns short execloop
execexit:
test byte[__execinfo],0x8
jz short cont_execexit
mov edi,[__cycles_needed]
dec edi
and byte[__execinfo],0xF7
or byte[__execinfo],16
mov edx,24h
call group_1_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln0
call basefunction
ln0:
add esi,ebp
sub edi,byte 34
jns short execloop
cont_execexit:
sub esi,ebp
btr ax,8
adc al,al
or ah,[__xflag]
rol ah,4
and ah,1Ch
or al,ah
mov [__sr],al
mov [__pc],esi
inc edi
mov edx,[__cycles_needed]
sub edx,edi
xor eax,eax
add [__cycles_counter],edx
and byte[__execinfo],0FEh
mov dword[__cycles_needed],eax
pop edi
pop esi
pop ebx
pop ebp
ret
global m68k_reset
m68k_reset:
xor eax,eax
test byte[__execinfo],1
jz short .checksfmm
mov al,1
ret
.checksfmm:
cmp dword[__s_fetch],eax
jne short .setup
mov al,2
ret
.setup:
mov [__execinfo],ax
and [__interrupts],byte 1
push esi
push ebp
xor ebp,ebp
mov cl,16
mov esi,4
mov eax,__reg
.cl_reg:
mov [eax],ebp
add eax,esi
dec cl
jnz short .cl_reg
mov [__asp],ebp
mov word[__sr],2700h
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
xor esi,esi
call basefunction
add esi,ebp
mov eax,[esi]
rol eax,16
mov [__a7],eax
mov eax,[esi+4]
rol eax,16
mov [__pc],eax
xor eax,eax
pop ebp
pop esi
ret
global m68k_raise_irq
m68k_raise_irq:
push edx
mov eax,[esp+8]
mov edx,[esp+12]
and eax, byte 7
jz short .badinput
cmp edx,255
jg short .badinput
cmp edx,byte -2
jl short .badinput
jne short .notspurious
mov edx,18h
.notspurious:
test edx,edx
jns short .notauto
lea edx,[eax+18h]
.notauto:
mov cl,al
mov ah,1
shl ah,cl
test [__interrupts],ah
jnz short .failure
or [__interrupts],ah
xor ah,ah
mov [__interrupts+eax],dl
test byte[__execinfo],80h
jz short .notstopped
mov cl,[__sr+1]
and cl,7
cmp al,7
sete ah
add al,ah
cmp al,cl
setbe cl
shl cl,7
and byte[__execinfo],7Fh
or byte[__execinfo],cl
.notstopped:
pop edx
xor eax,eax
ret
.badinput:
pop edx
mov eax,-2
ret
.failure:
pop edx
mov eax,-1
ret
global m68k_lower_irq
m68k_lower_irq:
mov eax,[esp+4]
cmp eax,byte 6
ja short .badlevel
test eax,eax
jz short .badlevel
mov cl,al
mov ah,1
shl ah,cl
test [__interrupts],ah
jz short .failstat
not ah
and [__interrupts],ah
xor eax,eax
ret
.failstat:
mov eax,-1
ret
.badlevel:
mov eax,-2
ret
global m68k_set_irq_type
m68k_set_irq_type:
push edx
mov eax,[esp+8]
mov edx,[esp+12]
and dl,1
test eax,eax
jz short .si_irq
or byte[eax+__interrupts-contextbegin],dl
pop edx
xor eax,eax
ret
.si_irq:
or byte[__interrupts],dl
pop edx
xor eax,eax
ret
global m68k_get_irq_vector
m68k_get_irq_vector:
mov eax,[esp+4]
and eax, byte 7
jz short .badlev
mov cl,al
mov ah,1
shl ah,cl
test [__interrupts],ah
jz short .notraised
xor ah,ah
mov cl,[__interrupts+eax]
mov al,cl
ret
.notraised:
mov eax,-1
ret
.badlev:
mov eax,-2
ret
global m68k_change_irq_vector
m68k_change_irq_vector:
push edx
mov eax,[esp+8]
mov edx,[esp+12]
and eax,byte 7
jz short .badin
mov cl,al
mov ah,1
shl ah,cl
test [__interrupts],ah
jz short .nraised
cmp edx,255
jg short .badin
cmp edx,byte -2
jl short .badin
jne short .notspur
mov edx,18h
.notspur:
test edx,edx
jns short .notaut
lea edx,[eax+18h]
.notaut:
xor ah,ah
mov [__interrupts+eax],dl
pop edx
xor al,al
ret
.nraised:
pop edx
mov eax,-1
ret
.badin:
pop edx
mov eax,-2
ret
global m68k_get_context_size
m68k_get_context_size:
mov eax,contextend-contextbegin
ret
global m68k_get_context
m68k_get_context:
push esi
push edi
cld
mov ecx,contextend-contextbegin
shr ecx,2
mov edi,[esp+12]
mov esi,contextbegin
rep movsd
pop edi
pop esi
xor eax,eax
ret
global m68k_set_context
m68k_set_context:
push esi
push edi
cld
mov ecx,contextend-contextbegin
shr ecx,2
mov esi,[esp+12]
mov edi,contextbegin
rep movsd
mov ecx,0A000h
mov eax,__sfmhtbl
xor edi,edi
mov edx,4
.dirty_idx:
mov [eax],edi
add eax,edx
dec ecx
jnz short .dirty_idx
mov edx,__sfmhtbl
mov eax,[__s_fetch]
.begincmm0:
cmp dword [eax],byte -1
je short .endcmm0
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 12
jmp short .begincmm0
.endcmm0:
mov edx,__ufmhtbl
mov eax,[__u_fetch]
.begincmm1:
cmp dword [eax],byte -1
je short .endcmm1
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 12
jmp short .begincmm1
.endcmm1:
mov edx,__srbmhtbl
mov eax,[__s_readbyte]
.begincmm2:
cmp dword [eax],byte -1
je short .endcmm2
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm2
.endcmm2:
mov edx,__srwmhtbl
mov eax,[__s_readword]
.begincmm3:
cmp dword [eax],byte -1
je short .endcmm3
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm3
.endcmm3:
mov edx,__urbmhtbl
mov eax,[__u_readbyte]
.begincmm4:
cmp dword [eax],byte -1
je short .endcmm4
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm4
.endcmm4:
mov edx,__urwmhtbl
mov eax,[__u_readword]
.begincmm5:
cmp dword [eax],byte -1
je short .endcmm5
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm5
.endcmm5:
mov edx,__swbmhtbl
mov eax,[__s_writebyte]
.begincmm6:
cmp dword [eax],byte -1
je short .endcmm6
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm6
.endcmm6:
mov edx,__uwbmhtbl
mov eax,[__u_writebyte]
.begincmm7:
cmp dword [eax],byte -1
je short .endcmm7
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm7
.endcmm7:
mov edx,__swwmhtbl
mov eax,[__s_writeword]
.begincmm8:
cmp dword [eax],byte -1
je short .endcmm8
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm8
.endcmm8:
mov edx,__uwwmhtbl
mov eax,[__u_writeword]
.begincmm9:
cmp dword [eax],byte -1
je short .endcmm9
mov esi,[eax]
mov ecx,[eax+4]
shr esi,12
shr ecx,12
sub ecx,esi
inc ecx
shl esi,2
mov edi,edx
add edi,esi
rep stosd
add eax,byte 16
jmp short .begincmm9
.endcmm9:
pop edi
pop esi
xor eax,eax
ret
global m68k_get_register
m68k_get_register:
mov eax,[esp+4]
cmp eax,byte 17
ja short .cont_get_funct
cmp eax,byte 16
ja short m68k_get_pc
mov eax,[__reg+eax*4]
ret
.cont_get_funct:
cmp eax,byte 18
jne short .inv_idx
xor eax,eax
mov ax,word[__sr]
ret
.inv_idx:
or eax,-1
ret
global m68k_get_pc
m68k_get_pc:
test byte[__execinfo],1
jnz short .live
mov eax,[__pc]
ret
.live:
mov eax,[__io_fetchbased_pc]
sub eax,[__io_fetchbase]
ret
global m68k_set_register
m68k_set_register:
push edx
mov eax,[esp+8]
mov edx,[esp+12]
cmp eax,byte 17
ja short .cont_set
cmp eax,byte 16
ja short .set_pc
mov [__reg+eax*4],edx
pop edx
xor eax,eax
ret
.set_pc:
and edx,16777215
test byte[__execinfo],1
jnz short .cpulive
mov [__pc],edx
pop edx
xor eax,eax
ret
.cpulive:
add edx,[__io_fetchbase]
mov [__io_fetchbased_pc],edx
pop edx
xor eax,eax
ret
.cont_set:
cmp eax,byte 18
jne short .inv_idx
mov [__sr],dx
pop edx
xor eax,eax
ret
.inv_idx:
pop edx
or eax,-1
ret
global m68k_fetch
m68k_fetch:
push edx
mov eax,[esp+8]
mov edx,[esp+12]
and edx,3
push eax
shr eax,12
mov ecx,[__fetch_vector+edx*4]
mov ecx,[ecx+eax*4]
pop eax
test ecx,ecx
jz short .outofrange
test dl,1
jz short .base_prg
jmp short .base_dat
.outofrange:
pop edx
or eax,-1
ret
.base_prg:
add eax,[ecx+8]
movzx eax,word[eax]
pop edx
ret
.base_dat:
test dword[ecx+8],0xFFFFFFFF
jnz short .callio
add eax,[ecx+12]
movzx eax,word[eax]
pop edx
ret
.callio:
push edx
push eax
call dword[ecx+8]
add esp,byte 8
pop edx
ret
global m68k_get_cycles_counter
m68k_get_cycles_counter:
mov eax,[__cycles_needed]
test byte[__execinfo],1
jz short .cpuidle
sub eax,[__io_cycle_counter]
.cpuidle:
add eax,[__cycles_counter]
ret
global m68k_control_cycles_counter
m68k_control_cycles_counter:
mov eax,[esp+4]
test eax,eax
jnz short m68k_trip_cycles_counter
jmp short m68k_get_cycles_counter
global m68k_trip_cycles_counter
m68k_trip_cycles_counter:
mov eax,[__cycles_needed]
test byte[__execinfo],1
jz short .cpuidle
sub eax,[__io_cycle_counter]
.cpuidle:
add [__cycles_counter],eax
test byte[__execinfo],1
jz short .cpuidle2
mov eax,[__io_cycle_counter]
.cpuidle2:
mov [__cycles_needed],eax
mov eax,[__cycles_counter]
mov dword[__cycles_counter],0
ret
global m68k_release_timeslice
m68k_release_timeslice:
test byte[__execinfo],1
jz short .cpuidle
mov eax,[__cycles_needed]
sub [__io_cycle_counter],eax
.cpuidle:
xor eax,eax
mov [__cycles_needed],eax
ret
global m68k_add_cycles
m68k_add_cycles:
mov eax,[esp+4]
add [__cycles_counter],eax
xor eax,eax
ret
global m68k_release_cycles
m68k_release_cycles:
mov eax,[esp+4]
sub [__cycles_counter],eax
xor eax,eax
ret
global m68k_get_cpu_state
m68k_get_cpu_state:
xor eax,eax
mov ax,[__execinfo]
ret
times ($$-$)&15 db 0
basefunction:
test si,1
jz short .access_ok
mov esp,[__excep_ptr]
xor ebx,ebx
mov word[__inst_reg],bx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
add bl,2
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,esi
or byte[__execinfo],40h
mov edx,0Ch
jmp group_0_exception
.access_ok:
and esi,16777215
mov ecx,esi
shr ecx,12
mov ebp,[__fetch_idx]
mov [__fetch_bank],cx
mov ecx,[ebp+ecx*4]
test ecx,ecx
jz short .outofrange
mov ebp,[ecx+8]
ret
.outofrange:
mov esp,[__excep_ptr]
xor ebx,ebx
mov word[__inst_reg],bx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
add bl,2
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,esi
or byte[__execinfo],20h
mov edx,8h
jmp group_0_exception
times ($$-$)&15 db 0
decode_ext:
push eax
xor edx,edx
mov dx,[esi]
movsx eax,dl
add esi,byte 2
shr edx,12
mov edx,[__reg+edx*4]
jc short .long
movsx edx,dx
.long:
add edx,eax
pop eax
ret
times ($$-$)&15 db 0
readmemorybyte:
mov [__access_address],edx
and edx,16777215
shr edx,12
mov ecx,[__readbyte_idx]
mov ecx,[ecx+edx*4]
mov edx,[__access_address]
and edx,16777215
test ecx,ecx
jz readb_outofrange
test dword[ecx+8],0FFFFFFFFh
jnz short readb_callio
add edx,[ecx+12]
xor edx,byte 1
mov cl,[edx]
mov edx,[__access_address]
ret
readb_callio:
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
push edx
call dword[ecx+8]
add esp,byte 4
mov ecx,eax
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
ret
readb_outofrange:
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],20h
mov edx,8h
jmp group_0_exception
times ($$-$)&15 db 0
readmemoryword:
test dl,1
jz short .access_ok
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],40h
mov edx,0Ch
jmp group_0_exception
.access_ok:
mov [__access_address],edx
and edx,16777215
shr edx,12
mov ecx,[__readword_idx]
mov ecx,[ecx+edx*4]
mov edx,[__access_address]
and edx,16777215
test ecx,ecx
jz readw_outofrange
test dword[ecx+8],0FFFFFFFFh
jnz short readw_callio
add edx,[ecx+12]
mov cx,[edx]
mov edx,[__access_address]
ret
readw_callio:
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
push edx
call dword[ecx+8]
add esp,byte 4
mov ecx,eax
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
ret
readw_outofrange:
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],20h
mov edx,8h
jmp group_0_exception
times ($$-$)&15 db 0
readmemorydword:
test dl,1
jz short .access_ok
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],40h
mov edx,0Ch
jmp group_0_exception
.access_ok:
mov [__access_address],edx
and edx,16777215
shr edx,12
mov ecx,[__readword_idx]
mov ecx,[ecx+edx*4]
mov edx,[__access_address]
and edx,16777215
test ecx,ecx
jz readw_outofrange
readl_call:
test dword[ecx+8],0FFFFFFFFh
jnz short readl_callio
add edx,byte 2
cmp edx,[ecx+4]
ja short readl_split
add edx,[ecx+12]
mov ecx,[edx-2]
rol ecx,16
mov edx,[__access_address]
ret
readl_split:
add edx,[ecx+12]
mov cx,[edx-2]
shl ecx,16
push ecx
mov edx,[__access_address]
add edx,byte 2
and edx,16777215
push edx
shr edx,12
mov ecx,[__readword_idx]
mov ecx,[ecx+edx*4]
test ecx,ecx
jz readw_outofrange
test dword[ecx+8],0FFFFFFFFh
jnz short readlower_callio
pop edx
add edx,[ecx+12]
xor ecx,ecx
mov cx,[edx]
pop edx
or ecx,edx
mov edx,[__access_address]
ret
readlower_callio:
mov edx,[__access_address]
ret
readl_callio:
add edx,byte 2
cmp edx,[ecx+4]
ja short readl_iosplit
sub edx,byte 2
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
push edx
push ecx
push edx
call dword[ecx+8]
add esp,byte 4
pop ecx
xchg eax,[esp]
add eax,byte 2
push eax
call dword[ecx+8]
add esp,byte 4
pop ecx
shl ecx,16
mov cx,ax
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
ret
readl_iosplit:
sub edx,byte 2
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
push edx
call dword[ecx+8]
add esp,byte 4
mov ecx,eax
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
ret
times ($$-$)&15 db 0
writememorybyte:
mov [__access_address],edx
push ecx
and edx,16777215
shr edx,12
mov ecx,[__writebyte_idx]
mov ecx,[ecx+edx*4]
mov edx,[__access_address]
and edx,16777215
test ecx,ecx
jz writeb_outofrange
test dword[ecx+8],0FFFFFFFFh
jnz short writeb_callio
add edx,[ecx+12]
xor edx,byte 1
pop ecx
mov [edx],cl
mov edx,[__access_address]
ret
writeb_callio:
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
mov eax,edx
xor edx,edx
mov dl,[esp+8]
push edx
push eax
call dword[ecx+8]
add esp,byte 8
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
pop ecx
ret
writeb_outofrange:
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],20h
mov edx,8h
jmp group_0_exception
times ($$-$)&15 db 0
writememoryword:
test dl,1
jz short .access_ok
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],40h
mov edx,0Ch
jmp group_0_exception
.access_ok:
mov [__access_address],edx
push ecx
and edx,16777215
shr edx,12
mov ecx,[__writeword_idx]
mov ecx,[ecx+edx*4]
mov edx,[__access_address]
and edx,16777215
test ecx,ecx
jz writew_outofrange
test dword[ecx+8],0FFFFFFFFh
jnz short writew_callio
add edx,[ecx+12]
pop ecx
mov [edx],cx
mov edx,[__access_address]
ret
writew_callio:
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
mov eax,edx
xor edx,edx
mov dx,[esp+8]
push edx
push eax
call dword[ecx+8]
add esp,byte 8
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
pop ecx
ret
writew_outofrange:
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
or bl,10h
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],20h
mov edx,8h
jmp group_0_exception
times ($$-$)&15 db 0
writememorydword:
test dl,1
jz short .access_ok
mov esp,[__excep_ptr]
mov ecx,[esi-2]
mov [__inst_reg],ecx
xor ebx,ebx
test byte[__sr+1],20h
setz bl
inc bl
shl bl,2
inc bl
and bl,0F7h
mov byte[__g0_spec_info],bl
mov ebx,edx
or byte[__execinfo],40h
mov edx,0Ch
jmp group_0_exception
.access_ok:
mov [__access_address],edx
push ecx
and edx,16777215
shr edx,12
mov ecx,[__writeword_idx]
mov ecx,[ecx+edx*4]
mov edx,[__access_address]
and edx,16777215
test ecx,ecx
jz writew_outofrange
writel_call:
test dword[ecx+8],0FFFFFFFFh
jnz short writel_callio
add edx,byte 2
cmp edx,[ecx+4]
ja near writel_split
add edx,[ecx+12]
pop ecx
rol ecx,16
mov [edx-2],ecx
rol ecx,16
mov edx,[__access_address]
ret
writel_callio:
add edx,byte 2
cmp edx,[ecx+4]
ja short writel_iosplit
sub edx,byte 2
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
mov eax,edx
xor edx,edx
mov dx,word[esp+10]
push ecx
push eax
push edx
push eax
call dword[ecx+8]
add esp,byte 8
pop eax
pop ecx
add eax,byte 2
xor edx,edx
mov dx,word[esp+8]
push edx
push eax
call dword[ecx+8]
add esp,byte 8
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[__access_address]
pop ecx
ret
writel_iosplit:
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
mov eax,edx
xor edx,edx
mov dx,word[esp+10]
push edx
push eax
call dword[ebx+8]
add esp,byte 8
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
mov edx,[esp+4]
add edx,byte 2
mov edx,[__access_address]
ret
writel_split:
add edx,[ecx+12]
mov cx,[esp+2]
mov [edx-2],cx
mov edx,[__access_address]
add edx,byte 2
and edx,16777215
push edx
shr edx,12
mov ecx,[__writeword_idx]
mov ecx,[ecx+edx*4]
test ecx,ecx
jz writew_outofrange
test dword[ecx+8],0FFFFFFFFh
jnz writelower_callio
pop edx
add edx,[ecx+12]
mov cx,[esp]
mov [edx],cx
mov edx,[__access_address]
pop ecx
ret
writelower_callio:
mov edx,[__access_address]
ret
times ($$-$)&15 db 0
group_0_exception:
test byte[__execinfo],2
jz short .excflow
or byte[__execinfo],4
sub edi,50
jmp execexit
.excflow:
or byte[__execinfo],2
and byte[__execinfo],7Fh
sub edi,50
call readmemorydword
push ecx
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
push ecx
test byte[__sr+1],20h
jnz short ln1
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
or byte[__sr+1],20h
ln1:
and byte[__sr+1],27h
test byte[__execinfo],20h
jz short .bus_error
mov ecx,esi
sub ecx,ebp
.bus_error:
mov ecx,[__io_fetchbased_pc]
sub ecx,[__io_fetchbase]
mov edx,[__a7]
sub edx,byte 4
call writememorydword
pop ecx
sub edx,byte 2
call writememoryword
mov cx,word [__inst_reg]
sub edx,byte 2
call writememoryword
mov ecx,ebx
sub edx,byte 4
call writememorydword
xor ch,ch
mov cl,byte[__g0_spec_info]
sub edx,byte 2
call writememoryword
mov [__a7],edx
pop esi
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln2
call basefunction
ln2:
add esi,ebp
test edi,edi
jmp near execend
times ($$-$)&15 db 0
group_1_exception:
group_2_exception:
and byte[__execinfo],7Fh
mov ecx,[__icusthandler]
test ecx,ecx
jz short .vect_except
test dword[ecx+edx*4],0FFFFFFFFh
jz short .vect_except
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
push edx
call dword[ecx+edx*4]
add esp,byte 4
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
sub esi,ebp
ret
.vect_except:
call readmemorydword
push ecx
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
push ecx
test byte[__sr+1],20h
jnz short ln3
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
or byte[__sr+1],20h
ln3:
and byte[__sr+1],27h
mov ecx,esi
sub ecx,ebp
mov edx,[__a7]
sub edx,byte 4
call writememorydword
pop ecx
sub edx,byte 2
call writememoryword
mov [__a7],edx
pop esi
ret
times ($$-$)&15 db 0
privilege_violation:
sub esi,byte 2
mov edx,20h
call group_1_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln4
call basefunction
ln4:
add esi,ebp
sub edi,byte 34
jmp near execend
times ($$-$)&15 db 0
flush_interrupts:
sub esi,ebp
xor ebp,ebp
mov edx,7
mov cl,80h
mov ch,[__sr+1]
and ch,7
.loop:
test [__interrupts],cl
jz short .noint
mov [__tmp_int_level], dl
not cl
and [__interrupts],cl
mov dl,[__interrupts+edx]
shl edx,2
call group_1_exception
and [__sr+1], byte 0F8h
mov dl, [__tmp_int_level]
or [__sr+1], dl
test dword[__iackhandler],0FFFFFFFFh
jz short .intdone
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
push edx
call dword[__iackhandler]
add esp,byte 4
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
jmp short .intdone
.noint:
dec dl
jz short .intdone
shr cl,1
cmp dl,ch
jg .loop
.intdone:
ret
; Opcodes 0000 - 0007
K000:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
or [__dreg+ebx*4],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 0010 - 0017
K010:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0018 - 001F
K018:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0020 - 0027
K020:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0028 - 002F
K028:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0030 - 0037
K030:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 0038
K038:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 0039
K039:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcode 003C
K03C:
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
or cl,[esi]
add esi,byte 2
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
jmp near execend
; Opcodes 0040 - 0047
K040:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
or [__dreg+ebx*4],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 0050 - 0057
K050:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 0058 - 005F
K058:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0060 - 0067
K060:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0068 - 006F
K068:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 0070 - 0077
K070:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 22
jmp near execend
; Opcode 0078
K078:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcode 0079
K079:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 24
jmp near execend
; Opcode 007C
K07C:
test byte[__sr+1],20h
jz privilege_violation
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
or cx,[esi]
add esi,byte 2
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln5
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln6
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln5
ln6:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln5:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 0080 - 0087
K080:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+ebx*4],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 0090 - 0097
K090:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 0098 - 009F
K098:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 28
jmp near execend
; Opcodes 00A0 - 00A7
K0A0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 30
jmp near execend
; Opcodes 00A8 - 00AF
K0A8:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcodes 00B0 - 00B7
K0B0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 34
jmp near execend
; Opcode 00B8
K0B8:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcode 00B9
K0B9:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 36
jmp near execend
; Opcodes 0100 - 0107
K100:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln7
and ah,0BFh
jmp short ln8
ln7:
or ah,40h
ln8:
sub edi,byte 6
jmp near execend
; Opcodes 0108 - 010F
K108:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+0],bx
sub edi,byte 16
jmp near execend
; Opcodes 0110 - 0117
K110:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln9
and ah,0BFh
jmp short ln10
ln9:
or ah,40h
ln10:
sub edi,byte 8
jmp near execend
; Opcodes 0118 - 011F
K118:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln11
and ah,0BFh
jmp short ln12
ln11:
or ah,40h
ln12:
sub edi,byte 8
jmp near execend
; Opcodes 0120 - 0127
K120:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln13
and ah,0BFh
jmp short ln14
ln13:
or ah,40h
ln14:
sub edi,byte 10
jmp near execend
; Opcodes 0128 - 012F
K128:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln15
and ah,0BFh
jmp short ln16
ln15:
or ah,40h
ln16:
sub edi,byte 12
jmp near execend
; Opcodes 0130 - 0137
K130:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln17
and ah,0BFh
jmp short ln18
ln17:
or ah,40h
ln18:
sub edi,byte 14
jmp near execend
; Opcode 0138
K138:
mov cl,byte[__dreg+0]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln19
and ah,0BFh
jmp short ln20
ln19:
or ah,40h
ln20:
sub edi,byte 12
jmp near execend
; Opcode 0139
K139:
mov cl,byte[__dreg+0]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln21
and ah,0BFh
jmp short ln22
ln21:
or ah,40h
ln22:
sub edi,byte 16
jmp near execend
; Opcode 013A
K13A:
mov cl,byte[__dreg+0]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln23
and ah,0BFh
jmp short ln24
ln23:
or ah,40h
ln24:
sub edi,byte 12
jmp near execend
; Opcode 013B
K13B:
mov cl,byte[__dreg+0]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln25
and ah,0BFh
jmp short ln26
ln25:
or ah,40h
ln26:
sub edi,byte 14
jmp near execend
; Opcode 013C
K13C:
mov cl,byte[__dreg+0]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln27
and ah,0BFh
jmp short ln28
ln27:
or ah,40h
ln28:
sub edi,byte 8
jmp near execend
; Opcodes 0140 - 0147
K140:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln29
and ah,0BFh
jmp short ln30
ln29:
or ah,40h
ln30:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0148 - 014F
K148:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+0],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0150 - 0157
K150:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln31
and ah,0BFh
jmp short ln32
ln31:
or ah,40h
ln32:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0158 - 015F
K158:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln33
and ah,0BFh
jmp short ln34
ln33:
or ah,40h
ln34:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0160 - 0167
K160:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln35
and ah,0BFh
jmp short ln36
ln35:
or ah,40h
ln36:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0168 - 016F
K168:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln37
and ah,0BFh
jmp short ln38
ln37:
or ah,40h
ln38:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0170 - 0177
K170:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln39
and ah,0BFh
jmp short ln40
ln39:
or ah,40h
ln40:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0178
K178:
mov cl,byte[__dreg+0]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln41
and ah,0BFh
jmp short ln42
ln41:
or ah,40h
ln42:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0179
K179:
mov cl,byte[__dreg+0]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln43
and ah,0BFh
jmp short ln44
ln43:
or ah,40h
ln44:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0180 - 0187
K180:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln45
and ah,0BFh
jmp short ln46
ln45:
or ah,40h
ln46:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0188 - 018F
K188:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+0]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0190 - 0197
K190:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln47
and ah,0BFh
jmp short ln48
ln47:
or ah,40h
ln48:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0198 - 019F
K198:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln49
and ah,0BFh
jmp short ln50
ln49:
or ah,40h
ln50:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 01A0 - 01A7
K1A0:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln51
and ah,0BFh
jmp short ln52
ln51:
or ah,40h
ln52:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 01A8 - 01AF
K1A8:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln53
and ah,0BFh
jmp short ln54
ln53:
or ah,40h
ln54:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 01B0 - 01B7
K1B0:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln55
and ah,0BFh
jmp short ln56
ln55:
or ah,40h
ln56:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 01B8
K1B8:
mov cl,byte[__dreg+0]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln57
and ah,0BFh
jmp short ln58
ln57:
or ah,40h
ln58:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 01B9
K1B9:
mov cl,byte[__dreg+0]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln59
and ah,0BFh
jmp short ln60
ln59:
or ah,40h
ln60:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 01C0 - 01C7
K1C0:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln61
and ah,0BFh
jmp short ln62
ln61:
or ah,40h
ln62:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 01C8 - 01CF
K1C8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+0]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 01D0 - 01D7
K1D0:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln63
and ah,0BFh
jmp short ln64
ln63:
or ah,40h
ln64:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 01D8 - 01DF
K1D8:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln65
and ah,0BFh
jmp short ln66
ln65:
or ah,40h
ln66:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 01E0 - 01E7
K1E0:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln67
and ah,0BFh
jmp short ln68
ln67:
or ah,40h
ln68:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 01E8 - 01EF
K1E8:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln69
and ah,0BFh
jmp short ln70
ln69:
or ah,40h
ln70:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 01F0 - 01F7
K1F0:
mov cl,byte[__dreg+0]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln71
and ah,0BFh
jmp short ln72
ln71:
or ah,40h
ln72:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 01F8
K1F8:
mov cl,byte[__dreg+0]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln73
and ah,0BFh
jmp short ln74
ln73:
or ah,40h
ln74:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 01F9
K1F9:
mov cl,byte[__dreg+0]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln75
and ah,0BFh
jmp short ln76
ln75:
or ah,40h
ln76:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0200 - 0207
K200:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
and [__dreg+ebx*4],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 0210 - 0217
K210:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0218 - 021F
K218:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0220 - 0227
K220:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0228 - 022F
K228:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0230 - 0237
K230:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 0238
K238:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 0239
K239:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
and cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcode 023C
K23C:
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
and cl,[esi]
add esi,byte 2
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
jmp near execend
; Opcodes 0240 - 0247
K240:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
and [__dreg+ebx*4],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 0250 - 0257
K250:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 0258 - 025F
K258:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0260 - 0267
K260:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0268 - 026F
K268:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 0270 - 0277
K270:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 22
jmp near execend
; Opcode 0278
K278:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcode 0279
K279:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
and cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 24
jmp near execend
; Opcode 027C
K27C:
test byte[__sr+1],20h
jz privilege_violation
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
and cx,[esi]
add esi,byte 2
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln77
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln78
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln77
ln78:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln77:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 0280 - 0287
K280:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
and [__dreg+ebx*4],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 0290 - 0297
K290:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 0298 - 029F
K298:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 28
jmp near execend
; Opcodes 02A0 - 02A7
K2A0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 30
jmp near execend
; Opcodes 02A8 - 02AF
K2A8:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcodes 02B0 - 02B7
K2B0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 34
jmp near execend
; Opcode 02B8
K2B8:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcode 02B9
K2B9:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
and ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 36
jmp near execend
; Opcodes 0300 - 0307
K300:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln79
and ah,0BFh
jmp short ln80
ln79:
or ah,40h
ln80:
sub edi,byte 6
jmp near execend
; Opcodes 0308 - 030F
K308:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+4],bx
sub edi,byte 16
jmp near execend
; Opcodes 0310 - 0317
K310:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln81
and ah,0BFh
jmp short ln82
ln81:
or ah,40h
ln82:
sub edi,byte 8
jmp near execend
; Opcodes 0318 - 031F
K318:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln83
and ah,0BFh
jmp short ln84
ln83:
or ah,40h
ln84:
sub edi,byte 8
jmp near execend
; Opcodes 0320 - 0327
K320:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln85
and ah,0BFh
jmp short ln86
ln85:
or ah,40h
ln86:
sub edi,byte 10
jmp near execend
; Opcodes 0328 - 032F
K328:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln87
and ah,0BFh
jmp short ln88
ln87:
or ah,40h
ln88:
sub edi,byte 12
jmp near execend
; Opcodes 0330 - 0337
K330:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln89
and ah,0BFh
jmp short ln90
ln89:
or ah,40h
ln90:
sub edi,byte 14
jmp near execend
; Opcode 0338
K338:
mov cl,byte[__dreg+4]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln91
and ah,0BFh
jmp short ln92
ln91:
or ah,40h
ln92:
sub edi,byte 12
jmp near execend
; Opcode 0339
K339:
mov cl,byte[__dreg+4]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln93
and ah,0BFh
jmp short ln94
ln93:
or ah,40h
ln94:
sub edi,byte 16
jmp near execend
; Opcode 033A
K33A:
mov cl,byte[__dreg+4]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln95
and ah,0BFh
jmp short ln96
ln95:
or ah,40h
ln96:
sub edi,byte 12
jmp near execend
; Opcode 033B
K33B:
mov cl,byte[__dreg+4]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln97
and ah,0BFh
jmp short ln98
ln97:
or ah,40h
ln98:
sub edi,byte 14
jmp near execend
; Opcode 033C
K33C:
mov cl,byte[__dreg+4]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln99
and ah,0BFh
jmp short ln100
ln99:
or ah,40h
ln100:
sub edi,byte 8
jmp near execend
; Opcodes 0340 - 0347
K340:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln101
and ah,0BFh
jmp short ln102
ln101:
or ah,40h
ln102:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0348 - 034F
K348:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+4],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0350 - 0357
K350:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln103
and ah,0BFh
jmp short ln104
ln103:
or ah,40h
ln104:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0358 - 035F
K358:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln105
and ah,0BFh
jmp short ln106
ln105:
or ah,40h
ln106:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0360 - 0367
K360:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln107
and ah,0BFh
jmp short ln108
ln107:
or ah,40h
ln108:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0368 - 036F
K368:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln109
and ah,0BFh
jmp short ln110
ln109:
or ah,40h
ln110:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0370 - 0377
K370:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln111
and ah,0BFh
jmp short ln112
ln111:
or ah,40h
ln112:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0378
K378:
mov cl,byte[__dreg+4]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln113
and ah,0BFh
jmp short ln114
ln113:
or ah,40h
ln114:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0379
K379:
mov cl,byte[__dreg+4]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln115
and ah,0BFh
jmp short ln116
ln115:
or ah,40h
ln116:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0380 - 0387
K380:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln117
and ah,0BFh
jmp short ln118
ln117:
or ah,40h
ln118:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0388 - 038F
K388:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+4]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0390 - 0397
K390:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln119
and ah,0BFh
jmp short ln120
ln119:
or ah,40h
ln120:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0398 - 039F
K398:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln121
and ah,0BFh
jmp short ln122
ln121:
or ah,40h
ln122:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 03A0 - 03A7
K3A0:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln123
and ah,0BFh
jmp short ln124
ln123:
or ah,40h
ln124:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 03A8 - 03AF
K3A8:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln125
and ah,0BFh
jmp short ln126
ln125:
or ah,40h
ln126:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 03B0 - 03B7
K3B0:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln127
and ah,0BFh
jmp short ln128
ln127:
or ah,40h
ln128:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 03B8
K3B8:
mov cl,byte[__dreg+4]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln129
and ah,0BFh
jmp short ln130
ln129:
or ah,40h
ln130:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 03B9
K3B9:
mov cl,byte[__dreg+4]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln131
and ah,0BFh
jmp short ln132
ln131:
or ah,40h
ln132:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 03C0 - 03C7
K3C0:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln133
and ah,0BFh
jmp short ln134
ln133:
or ah,40h
ln134:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 03C8 - 03CF
K3C8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+4]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 03D0 - 03D7
K3D0:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln135
and ah,0BFh
jmp short ln136
ln135:
or ah,40h
ln136:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 03D8 - 03DF
K3D8:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln137
and ah,0BFh
jmp short ln138
ln137:
or ah,40h
ln138:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 03E0 - 03E7
K3E0:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln139
and ah,0BFh
jmp short ln140
ln139:
or ah,40h
ln140:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 03E8 - 03EF
K3E8:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln141
and ah,0BFh
jmp short ln142
ln141:
or ah,40h
ln142:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 03F0 - 03F7
K3F0:
mov cl,byte[__dreg+4]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln143
and ah,0BFh
jmp short ln144
ln143:
or ah,40h
ln144:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 03F8
K3F8:
mov cl,byte[__dreg+4]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln145
and ah,0BFh
jmp short ln146
ln145:
or ah,40h
ln146:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 03F9
K3F9:
mov cl,byte[__dreg+4]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln147
and ah,0BFh
jmp short ln148
ln147:
or ah,40h
ln148:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0400 - 0407
K400:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
sub [__dreg+ebx*4],cl
setc [__xflag]
lahf
seto al
sub edi,byte 8
jmp near execend
; Opcodes 0410 - 0417
K410:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0418 - 041F
K418:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0420 - 0427
K420:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0428 - 042F
K428:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0430 - 0437
K430:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 0438
K438:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 0439
K439:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0440 - 0447
K440:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
sub [__dreg+ebx*4],cx
setc [__xflag]
lahf
seto al
sub edi,byte 8
jmp near execend
; Opcodes 0450 - 0457
K450:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 0458 - 045F
K458:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0460 - 0467
K460:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0468 - 046F
K468:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 0470 - 0477
K470:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 22
jmp near execend
; Opcode 0478
K478:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcode 0479
K479:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 24
jmp near execend
; Opcodes 0480 - 0487
K480:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
sub [__dreg+ebx*4],ecx
setc [__xflag]
lahf
seto al
sub edi,byte 16
jmp near execend
; Opcodes 0490 - 0497
K490:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 0498 - 049F
K498:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 28
jmp near execend
; Opcodes 04A0 - 04A7
K4A0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 30
jmp near execend
; Opcodes 04A8 - 04AF
K4A8:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcodes 04B0 - 04B7
K4B0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 34
jmp near execend
; Opcode 04B8
K4B8:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcode 04B9
K4B9:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 36
jmp near execend
; Opcodes 0500 - 0507
K500:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln149
and ah,0BFh
jmp short ln150
ln149:
or ah,40h
ln150:
sub edi,byte 6
jmp near execend
; Opcodes 0508 - 050F
K508:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+8],bx
sub edi,byte 16
jmp near execend
; Opcodes 0510 - 0517
K510:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln151
and ah,0BFh
jmp short ln152
ln151:
or ah,40h
ln152:
sub edi,byte 8
jmp near execend
; Opcodes 0518 - 051F
K518:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln153
and ah,0BFh
jmp short ln154
ln153:
or ah,40h
ln154:
sub edi,byte 8
jmp near execend
; Opcodes 0520 - 0527
K520:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln155
and ah,0BFh
jmp short ln156
ln155:
or ah,40h
ln156:
sub edi,byte 10
jmp near execend
; Opcodes 0528 - 052F
K528:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln157
and ah,0BFh
jmp short ln158
ln157:
or ah,40h
ln158:
sub edi,byte 12
jmp near execend
; Opcodes 0530 - 0537
K530:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln159
and ah,0BFh
jmp short ln160
ln159:
or ah,40h
ln160:
sub edi,byte 14
jmp near execend
; Opcode 0538
K538:
mov cl,byte[__dreg+8]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln161
and ah,0BFh
jmp short ln162
ln161:
or ah,40h
ln162:
sub edi,byte 12
jmp near execend
; Opcode 0539
K539:
mov cl,byte[__dreg+8]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln163
and ah,0BFh
jmp short ln164
ln163:
or ah,40h
ln164:
sub edi,byte 16
jmp near execend
; Opcode 053A
K53A:
mov cl,byte[__dreg+8]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln165
and ah,0BFh
jmp short ln166
ln165:
or ah,40h
ln166:
sub edi,byte 12
jmp near execend
; Opcode 053B
K53B:
mov cl,byte[__dreg+8]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln167
and ah,0BFh
jmp short ln168
ln167:
or ah,40h
ln168:
sub edi,byte 14
jmp near execend
; Opcode 053C
K53C:
mov cl,byte[__dreg+8]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln169
and ah,0BFh
jmp short ln170
ln169:
or ah,40h
ln170:
sub edi,byte 8
jmp near execend
; Opcodes 0540 - 0547
K540:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln171
and ah,0BFh
jmp short ln172
ln171:
or ah,40h
ln172:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0548 - 054F
K548:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+8],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0550 - 0557
K550:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln173
and ah,0BFh
jmp short ln174
ln173:
or ah,40h
ln174:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0558 - 055F
K558:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln175
and ah,0BFh
jmp short ln176
ln175:
or ah,40h
ln176:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0560 - 0567
K560:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln177
and ah,0BFh
jmp short ln178
ln177:
or ah,40h
ln178:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0568 - 056F
K568:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln179
and ah,0BFh
jmp short ln180
ln179:
or ah,40h
ln180:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0570 - 0577
K570:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln181
and ah,0BFh
jmp short ln182
ln181:
or ah,40h
ln182:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0578
K578:
mov cl,byte[__dreg+8]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln183
and ah,0BFh
jmp short ln184
ln183:
or ah,40h
ln184:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0579
K579:
mov cl,byte[__dreg+8]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln185
and ah,0BFh
jmp short ln186
ln185:
or ah,40h
ln186:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0580 - 0587
K580:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln187
and ah,0BFh
jmp short ln188
ln187:
or ah,40h
ln188:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0588 - 058F
K588:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+8]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0590 - 0597
K590:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln189
and ah,0BFh
jmp short ln190
ln189:
or ah,40h
ln190:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0598 - 059F
K598:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln191
and ah,0BFh
jmp short ln192
ln191:
or ah,40h
ln192:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 05A0 - 05A7
K5A0:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln193
and ah,0BFh
jmp short ln194
ln193:
or ah,40h
ln194:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 05A8 - 05AF
K5A8:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln195
and ah,0BFh
jmp short ln196
ln195:
or ah,40h
ln196:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 05B0 - 05B7
K5B0:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln197
and ah,0BFh
jmp short ln198
ln197:
or ah,40h
ln198:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 05B8
K5B8:
mov cl,byte[__dreg+8]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln199
and ah,0BFh
jmp short ln200
ln199:
or ah,40h
ln200:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 05B9
K5B9:
mov cl,byte[__dreg+8]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln201
and ah,0BFh
jmp short ln202
ln201:
or ah,40h
ln202:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 05C0 - 05C7
K5C0:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln203
and ah,0BFh
jmp short ln204
ln203:
or ah,40h
ln204:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 05C8 - 05CF
K5C8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+8]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 05D0 - 05D7
K5D0:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln205
and ah,0BFh
jmp short ln206
ln205:
or ah,40h
ln206:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 05D8 - 05DF
K5D8:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln207
and ah,0BFh
jmp short ln208
ln207:
or ah,40h
ln208:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 05E0 - 05E7
K5E0:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln209
and ah,0BFh
jmp short ln210
ln209:
or ah,40h
ln210:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 05E8 - 05EF
K5E8:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln211
and ah,0BFh
jmp short ln212
ln211:
or ah,40h
ln212:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 05F0 - 05F7
K5F0:
mov cl,byte[__dreg+8]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln213
and ah,0BFh
jmp short ln214
ln213:
or ah,40h
ln214:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 05F8
K5F8:
mov cl,byte[__dreg+8]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln215
and ah,0BFh
jmp short ln216
ln215:
or ah,40h
ln216:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 05F9
K5F9:
mov cl,byte[__dreg+8]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln217
and ah,0BFh
jmp short ln218
ln217:
or ah,40h
ln218:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0600 - 0607
K600:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
add [__dreg+ebx*4],cl
setc [__xflag]
lahf
seto al
sub edi,byte 8
jmp near execend
; Opcodes 0610 - 0617
K610:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0618 - 061F
K618:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0620 - 0627
K620:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0628 - 062F
K628:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0630 - 0637
K630:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 0638
K638:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 0639
K639:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0640 - 0647
K640:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
add [__dreg+ebx*4],cx
setc [__xflag]
lahf
seto al
sub edi,byte 8
jmp near execend
; Opcodes 0650 - 0657
K650:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 0658 - 065F
K658:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0660 - 0667
K660:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0668 - 066F
K668:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 0670 - 0677
K670:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 22
jmp near execend
; Opcode 0678
K678:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcode 0679
K679:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememoryword
sub edi,byte 24
jmp near execend
; Opcodes 0680 - 0687
K680:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
add [__dreg+ebx*4],ecx
setc [__xflag]
lahf
seto al
sub edi,byte 16
jmp near execend
; Opcodes 0690 - 0697
K690:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 0698 - 069F
K698:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 28
jmp near execend
; Opcodes 06A0 - 06A7
K6A0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 30
jmp near execend
; Opcodes 06A8 - 06AF
K6A8:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcodes 06B0 - 06B7
K6B0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 34
jmp near execend
; Opcode 06B8
K6B8:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcode 06B9
K6B9:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,[esp]
setc [__xflag]
lahf
seto al
add esp,byte 4
call writememorydword
sub edi,byte 36
jmp near execend
; Opcodes 0700 - 0707
K700:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln219
and ah,0BFh
jmp short ln220
ln219:
or ah,40h
ln220:
sub edi,byte 6
jmp near execend
; Opcodes 0708 - 070F
K708:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+12],bx
sub edi,byte 16
jmp near execend
; Opcodes 0710 - 0717
K710:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln221
and ah,0BFh
jmp short ln222
ln221:
or ah,40h
ln222:
sub edi,byte 8
jmp near execend
; Opcodes 0718 - 071F
K718:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln223
and ah,0BFh
jmp short ln224
ln223:
or ah,40h
ln224:
sub edi,byte 8
jmp near execend
; Opcodes 0720 - 0727
K720:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln225
and ah,0BFh
jmp short ln226
ln225:
or ah,40h
ln226:
sub edi,byte 10
jmp near execend
; Opcodes 0728 - 072F
K728:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln227
and ah,0BFh
jmp short ln228
ln227:
or ah,40h
ln228:
sub edi,byte 12
jmp near execend
; Opcodes 0730 - 0737
K730:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln229
and ah,0BFh
jmp short ln230
ln229:
or ah,40h
ln230:
sub edi,byte 14
jmp near execend
; Opcode 0738
K738:
mov cl,byte[__dreg+12]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln231
and ah,0BFh
jmp short ln232
ln231:
or ah,40h
ln232:
sub edi,byte 12
jmp near execend
; Opcode 0739
K739:
mov cl,byte[__dreg+12]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln233
and ah,0BFh
jmp short ln234
ln233:
or ah,40h
ln234:
sub edi,byte 16
jmp near execend
; Opcode 073A
K73A:
mov cl,byte[__dreg+12]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln235
and ah,0BFh
jmp short ln236
ln235:
or ah,40h
ln236:
sub edi,byte 12
jmp near execend
; Opcode 073B
K73B:
mov cl,byte[__dreg+12]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln237
and ah,0BFh
jmp short ln238
ln237:
or ah,40h
ln238:
sub edi,byte 14
jmp near execend
; Opcode 073C
K73C:
mov cl,byte[__dreg+12]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln239
and ah,0BFh
jmp short ln240
ln239:
or ah,40h
ln240:
sub edi,byte 8
jmp near execend
; Opcodes 0740 - 0747
K740:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln241
and ah,0BFh
jmp short ln242
ln241:
or ah,40h
ln242:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0748 - 074F
K748:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+12],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0750 - 0757
K750:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln243
and ah,0BFh
jmp short ln244
ln243:
or ah,40h
ln244:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0758 - 075F
K758:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln245
and ah,0BFh
jmp short ln246
ln245:
or ah,40h
ln246:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0760 - 0767
K760:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln247
and ah,0BFh
jmp short ln248
ln247:
or ah,40h
ln248:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0768 - 076F
K768:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln249
and ah,0BFh
jmp short ln250
ln249:
or ah,40h
ln250:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0770 - 0777
K770:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln251
and ah,0BFh
jmp short ln252
ln251:
or ah,40h
ln252:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0778
K778:
mov cl,byte[__dreg+12]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln253
and ah,0BFh
jmp short ln254
ln253:
or ah,40h
ln254:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0779
K779:
mov cl,byte[__dreg+12]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln255
and ah,0BFh
jmp short ln256
ln255:
or ah,40h
ln256:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0780 - 0787
K780:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln257
and ah,0BFh
jmp short ln258
ln257:
or ah,40h
ln258:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0788 - 078F
K788:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+12]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0790 - 0797
K790:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln259
and ah,0BFh
jmp short ln260
ln259:
or ah,40h
ln260:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0798 - 079F
K798:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln261
and ah,0BFh
jmp short ln262
ln261:
or ah,40h
ln262:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 07A0 - 07A7
K7A0:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln263
and ah,0BFh
jmp short ln264
ln263:
or ah,40h
ln264:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 07A8 - 07AF
K7A8:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln265
and ah,0BFh
jmp short ln266
ln265:
or ah,40h
ln266:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 07B0 - 07B7
K7B0:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln267
and ah,0BFh
jmp short ln268
ln267:
or ah,40h
ln268:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 07B8
K7B8:
mov cl,byte[__dreg+12]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln269
and ah,0BFh
jmp short ln270
ln269:
or ah,40h
ln270:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 07B9
K7B9:
mov cl,byte[__dreg+12]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln271
and ah,0BFh
jmp short ln272
ln271:
or ah,40h
ln272:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 07C0 - 07C7
K7C0:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln273
and ah,0BFh
jmp short ln274
ln273:
or ah,40h
ln274:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 07C8 - 07CF
K7C8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+12]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 07D0 - 07D7
K7D0:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln275
and ah,0BFh
jmp short ln276
ln275:
or ah,40h
ln276:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 07D8 - 07DF
K7D8:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln277
and ah,0BFh
jmp short ln278
ln277:
or ah,40h
ln278:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 07E0 - 07E7
K7E0:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln279
and ah,0BFh
jmp short ln280
ln279:
or ah,40h
ln280:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 07E8 - 07EF
K7E8:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln281
and ah,0BFh
jmp short ln282
ln281:
or ah,40h
ln282:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 07F0 - 07F7
K7F0:
mov cl,byte[__dreg+12]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln283
and ah,0BFh
jmp short ln284
ln283:
or ah,40h
ln284:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 07F8
K7F8:
mov cl,byte[__dreg+12]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln285
and ah,0BFh
jmp short ln286
ln285:
or ah,40h
ln286:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 07F9
K7F9:
mov cl,byte[__dreg+12]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln287
and ah,0BFh
jmp short ln288
ln287:
or ah,40h
ln288:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0800 - 0807
K800:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln289
and ah,0BFh
jmp short ln290
ln289:
or ah,40h
ln290:
sub edi,byte 10
jmp near execend
; Opcodes 0810 - 0817
K810:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln291
and ah,0BFh
jmp short ln292
ln291:
or ah,40h
ln292:
sub edi,byte 12
jmp near execend
; Opcodes 0818 - 081F
K818:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln293
and ah,0BFh
jmp short ln294
ln293:
or ah,40h
ln294:
sub edi,byte 12
jmp near execend
; Opcodes 0820 - 0827
K820:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln295
and ah,0BFh
jmp short ln296
ln295:
or ah,40h
ln296:
sub edi,byte 14
jmp near execend
; Opcodes 0828 - 082F
K828:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln297
and ah,0BFh
jmp short ln298
ln297:
or ah,40h
ln298:
sub edi,byte 16
jmp near execend
; Opcodes 0830 - 0837
K830:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln299
and ah,0BFh
jmp short ln300
ln299:
or ah,40h
ln300:
sub edi,byte 18
jmp near execend
; Opcode 0838
K838:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln301
and ah,0BFh
jmp short ln302
ln301:
or ah,40h
ln302:
sub edi,byte 16
jmp near execend
; Opcode 0839
K839:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln303
and ah,0BFh
jmp short ln304
ln303:
or ah,40h
ln304:
sub edi,byte 20
jmp near execend
; Opcode 083A
K83A:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln305
and ah,0BFh
jmp short ln306
ln305:
or ah,40h
ln306:
sub edi,byte 16
jmp near execend
; Opcode 083B
K83B:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln307
and ah,0BFh
jmp short ln308
ln307:
or ah,40h
ln308:
sub edi,byte 18
jmp near execend
; Opcode 083C
K83C:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln309
and ah,0BFh
jmp short ln310
ln309:
or ah,40h
ln310:
sub edi,byte 12
jmp near execend
; Opcodes 0840 - 0847
K840:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln311
and ah,0BFh
jmp short ln312
ln311:
or ah,40h
ln312:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 0850 - 0857
K850:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln313
and ah,0BFh
jmp short ln314
ln313:
or ah,40h
ln314:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0858 - 085F
K858:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln315
and ah,0BFh
jmp short ln316
ln315:
or ah,40h
ln316:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0860 - 0867
K860:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln317
and ah,0BFh
jmp short ln318
ln317:
or ah,40h
ln318:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0868 - 086F
K868:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln319
and ah,0BFh
jmp short ln320
ln319:
or ah,40h
ln320:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0870 - 0877
K870:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln321
and ah,0BFh
jmp short ln322
ln321:
or ah,40h
ln322:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 0878
K878:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln323
and ah,0BFh
jmp short ln324
ln323:
or ah,40h
ln324:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 0879
K879:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln325
and ah,0BFh
jmp short ln326
ln325:
or ah,40h
ln326:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0880 - 0887
K880:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln327
and ah,0BFh
jmp short ln328
ln327:
or ah,40h
ln328:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 14
jmp near execend
; Opcodes 0890 - 0897
K890:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln329
and ah,0BFh
jmp short ln330
ln329:
or ah,40h
ln330:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0898 - 089F
K898:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln331
and ah,0BFh
jmp short ln332
ln331:
or ah,40h
ln332:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 08A0 - 08A7
K8A0:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln333
and ah,0BFh
jmp short ln334
ln333:
or ah,40h
ln334:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 08A8 - 08AF
K8A8:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln335
and ah,0BFh
jmp short ln336
ln335:
or ah,40h
ln336:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 08B0 - 08B7
K8B0:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln337
and ah,0BFh
jmp short ln338
ln337:
or ah,40h
ln338:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 08B8
K8B8:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln339
and ah,0BFh
jmp short ln340
ln339:
or ah,40h
ln340:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 08B9
K8B9:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln341
and ah,0BFh
jmp short ln342
ln341:
or ah,40h
ln342:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 08C0 - 08C7
K8C0:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln343
and ah,0BFh
jmp short ln344
ln343:
or ah,40h
ln344:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 08D0 - 08D7
K8D0:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln345
and ah,0BFh
jmp short ln346
ln345:
or ah,40h
ln346:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 08D8 - 08DF
K8D8:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln347
and ah,0BFh
jmp short ln348
ln347:
or ah,40h
ln348:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 08E0 - 08E7
K8E0:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln349
and ah,0BFh
jmp short ln350
ln349:
or ah,40h
ln350:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 08E8 - 08EF
K8E8:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln351
and ah,0BFh
jmp short ln352
ln351:
or ah,40h
ln352:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 08F0 - 08F7
K8F0:
mov cl,[esi]
add esi,byte 2
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln353
and ah,0BFh
jmp short ln354
ln353:
or ah,40h
ln354:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 08F8
K8F8:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln355
and ah,0BFh
jmp short ln356
ln355:
or ah,40h
ln356:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 08F9
K8F9:
mov cl,[esi]
add esi,byte 2
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln357
and ah,0BFh
jmp short ln358
ln357:
or ah,40h
ln358:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0900 - 0907
K900:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln359
and ah,0BFh
jmp short ln360
ln359:
or ah,40h
ln360:
sub edi,byte 6
jmp near execend
; Opcodes 0908 - 090F
K908:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+16],bx
sub edi,byte 16
jmp near execend
; Opcodes 0910 - 0917
K910:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln361
and ah,0BFh
jmp short ln362
ln361:
or ah,40h
ln362:
sub edi,byte 8
jmp near execend
; Opcodes 0918 - 091F
K918:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln363
and ah,0BFh
jmp short ln364
ln363:
or ah,40h
ln364:
sub edi,byte 8
jmp near execend
; Opcodes 0920 - 0927
K920:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln365
and ah,0BFh
jmp short ln366
ln365:
or ah,40h
ln366:
sub edi,byte 10
jmp near execend
; Opcodes 0928 - 092F
K928:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln367
and ah,0BFh
jmp short ln368
ln367:
or ah,40h
ln368:
sub edi,byte 12
jmp near execend
; Opcodes 0930 - 0937
K930:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln369
and ah,0BFh
jmp short ln370
ln369:
or ah,40h
ln370:
sub edi,byte 14
jmp near execend
; Opcode 0938
K938:
mov cl,byte[__dreg+16]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln371
and ah,0BFh
jmp short ln372
ln371:
or ah,40h
ln372:
sub edi,byte 12
jmp near execend
; Opcode 0939
K939:
mov cl,byte[__dreg+16]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln373
and ah,0BFh
jmp short ln374
ln373:
or ah,40h
ln374:
sub edi,byte 16
jmp near execend
; Opcode 093A
K93A:
mov cl,byte[__dreg+16]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln375
and ah,0BFh
jmp short ln376
ln375:
or ah,40h
ln376:
sub edi,byte 12
jmp near execend
; Opcode 093B
K93B:
mov cl,byte[__dreg+16]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln377
and ah,0BFh
jmp short ln378
ln377:
or ah,40h
ln378:
sub edi,byte 14
jmp near execend
; Opcode 093C
K93C:
mov cl,byte[__dreg+16]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln379
and ah,0BFh
jmp short ln380
ln379:
or ah,40h
ln380:
sub edi,byte 8
jmp near execend
; Opcodes 0940 - 0947
K940:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln381
and ah,0BFh
jmp short ln382
ln381:
or ah,40h
ln382:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0948 - 094F
K948:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+16],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0950 - 0957
K950:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln383
and ah,0BFh
jmp short ln384
ln383:
or ah,40h
ln384:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0958 - 095F
K958:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln385
and ah,0BFh
jmp short ln386
ln385:
or ah,40h
ln386:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0960 - 0967
K960:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln387
and ah,0BFh
jmp short ln388
ln387:
or ah,40h
ln388:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0968 - 096F
K968:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln389
and ah,0BFh
jmp short ln390
ln389:
or ah,40h
ln390:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0970 - 0977
K970:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln391
and ah,0BFh
jmp short ln392
ln391:
or ah,40h
ln392:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0978
K978:
mov cl,byte[__dreg+16]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln393
and ah,0BFh
jmp short ln394
ln393:
or ah,40h
ln394:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0979
K979:
mov cl,byte[__dreg+16]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln395
and ah,0BFh
jmp short ln396
ln395:
or ah,40h
ln396:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0980 - 0987
K980:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln397
and ah,0BFh
jmp short ln398
ln397:
or ah,40h
ln398:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0988 - 098F
K988:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+16]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0990 - 0997
K990:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln399
and ah,0BFh
jmp short ln400
ln399:
or ah,40h
ln400:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0998 - 099F
K998:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln401
and ah,0BFh
jmp short ln402
ln401:
or ah,40h
ln402:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 09A0 - 09A7
K9A0:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln403
and ah,0BFh
jmp short ln404
ln403:
or ah,40h
ln404:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 09A8 - 09AF
K9A8:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln405
and ah,0BFh
jmp short ln406
ln405:
or ah,40h
ln406:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 09B0 - 09B7
K9B0:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln407
and ah,0BFh
jmp short ln408
ln407:
or ah,40h
ln408:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 09B8
K9B8:
mov cl,byte[__dreg+16]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln409
and ah,0BFh
jmp short ln410
ln409:
or ah,40h
ln410:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 09B9
K9B9:
mov cl,byte[__dreg+16]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln411
and ah,0BFh
jmp short ln412
ln411:
or ah,40h
ln412:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 09C0 - 09C7
K9C0:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln413
and ah,0BFh
jmp short ln414
ln413:
or ah,40h
ln414:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 09C8 - 09CF
K9C8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+16]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 09D0 - 09D7
K9D0:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln415
and ah,0BFh
jmp short ln416
ln415:
or ah,40h
ln416:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 09D8 - 09DF
K9D8:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln417
and ah,0BFh
jmp short ln418
ln417:
or ah,40h
ln418:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 09E0 - 09E7
K9E0:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln419
and ah,0BFh
jmp short ln420
ln419:
or ah,40h
ln420:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 09E8 - 09EF
K9E8:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln421
and ah,0BFh
jmp short ln422
ln421:
or ah,40h
ln422:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 09F0 - 09F7
K9F0:
mov cl,byte[__dreg+16]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln423
and ah,0BFh
jmp short ln424
ln423:
or ah,40h
ln424:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 09F8
K9F8:
mov cl,byte[__dreg+16]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln425
and ah,0BFh
jmp short ln426
ln425:
or ah,40h
ln426:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 09F9
K9F9:
mov cl,byte[__dreg+16]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln427
and ah,0BFh
jmp short ln428
ln427:
or ah,40h
ln428:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0A00 - 0A07
KA00:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
xor [__dreg+ebx*4],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 0A10 - 0A17
KA10:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0A18 - 0A1F
KA18:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0A20 - 0A27
KA20:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0A28 - 0A2F
KA28:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0A30 - 0A37
KA30:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 0A38
KA38:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 0A39
KA39:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xor cl,[esp]
lahf
xor al,al
add esp,byte 4
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcode 0A3C
KA3C:
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
xor cl,[esi]
add esi,byte 2
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
jmp near execend
; Opcodes 0A40 - 0A47
KA40:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
xor [__dreg+ebx*4],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 0A50 - 0A57
KA50:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 0A58 - 0A5F
KA58:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 16
jmp near execend
; Opcodes 0A60 - 0A67
KA60:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 0A68 - 0A6F
KA68:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 0A70 - 0A77
KA70:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 22
jmp near execend
; Opcode 0A78
KA78:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 20
jmp near execend
; Opcode 0A79
KA79:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor cx,[esp]
lahf
xor al,al
add esp,byte 4
call writememoryword
sub edi,byte 24
jmp near execend
; Opcode 0A7C
KA7C:
test byte[__sr+1],20h
jz privilege_violation
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
xor cx,[esi]
add esi,byte 2
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln429
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln430
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln429
ln430:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln429:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 0A80 - 0A87
KA80:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
xor [__dreg+ebx*4],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 0A90 - 0A97
KA90:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 0A98 - 0A9F
KA98:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 28
jmp near execend
; Opcodes 0AA0 - 0AA7
KAA0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 30
jmp near execend
; Opcodes 0AA8 - 0AAF
KAA8:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcodes 0AB0 - 0AB7
KAB0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 34
jmp near execend
; Opcode 0AB8
KAB8:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 32
jmp near execend
; Opcode 0AB9
KAB9:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
xor ecx,[esp]
lahf
xor al,al
add esp,byte 4
call writememorydword
sub edi,byte 36
jmp near execend
; Opcodes 0B00 - 0B07
KB00:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln431
and ah,0BFh
jmp short ln432
ln431:
or ah,40h
ln432:
sub edi,byte 6
jmp near execend
; Opcodes 0B08 - 0B0F
KB08:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+20],bx
sub edi,byte 16
jmp near execend
; Opcodes 0B10 - 0B17
KB10:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln433
and ah,0BFh
jmp short ln434
ln433:
or ah,40h
ln434:
sub edi,byte 8
jmp near execend
; Opcodes 0B18 - 0B1F
KB18:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln435
and ah,0BFh
jmp short ln436
ln435:
or ah,40h
ln436:
sub edi,byte 8
jmp near execend
; Opcodes 0B20 - 0B27
KB20:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln437
and ah,0BFh
jmp short ln438
ln437:
or ah,40h
ln438:
sub edi,byte 10
jmp near execend
; Opcodes 0B28 - 0B2F
KB28:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln439
and ah,0BFh
jmp short ln440
ln439:
or ah,40h
ln440:
sub edi,byte 12
jmp near execend
; Opcodes 0B30 - 0B37
KB30:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln441
and ah,0BFh
jmp short ln442
ln441:
or ah,40h
ln442:
sub edi,byte 14
jmp near execend
; Opcode 0B38
KB38:
mov cl,byte[__dreg+20]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln443
and ah,0BFh
jmp short ln444
ln443:
or ah,40h
ln444:
sub edi,byte 12
jmp near execend
; Opcode 0B39
KB39:
mov cl,byte[__dreg+20]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln445
and ah,0BFh
jmp short ln446
ln445:
or ah,40h
ln446:
sub edi,byte 16
jmp near execend
; Opcode 0B3A
KB3A:
mov cl,byte[__dreg+20]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln447
and ah,0BFh
jmp short ln448
ln447:
or ah,40h
ln448:
sub edi,byte 12
jmp near execend
; Opcode 0B3B
KB3B:
mov cl,byte[__dreg+20]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln449
and ah,0BFh
jmp short ln450
ln449:
or ah,40h
ln450:
sub edi,byte 14
jmp near execend
; Opcode 0B3C
KB3C:
mov cl,byte[__dreg+20]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln451
and ah,0BFh
jmp short ln452
ln451:
or ah,40h
ln452:
sub edi,byte 8
jmp near execend
; Opcodes 0B40 - 0B47
KB40:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln453
and ah,0BFh
jmp short ln454
ln453:
or ah,40h
ln454:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0B48 - 0B4F
KB48:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+20],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0B50 - 0B57
KB50:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln455
and ah,0BFh
jmp short ln456
ln455:
or ah,40h
ln456:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0B58 - 0B5F
KB58:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln457
and ah,0BFh
jmp short ln458
ln457:
or ah,40h
ln458:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0B60 - 0B67
KB60:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln459
and ah,0BFh
jmp short ln460
ln459:
or ah,40h
ln460:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0B68 - 0B6F
KB68:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln461
and ah,0BFh
jmp short ln462
ln461:
or ah,40h
ln462:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0B70 - 0B77
KB70:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln463
and ah,0BFh
jmp short ln464
ln463:
or ah,40h
ln464:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0B78
KB78:
mov cl,byte[__dreg+20]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln465
and ah,0BFh
jmp short ln466
ln465:
or ah,40h
ln466:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0B79
KB79:
mov cl,byte[__dreg+20]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln467
and ah,0BFh
jmp short ln468
ln467:
or ah,40h
ln468:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0B80 - 0B87
KB80:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln469
and ah,0BFh
jmp short ln470
ln469:
or ah,40h
ln470:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0B88 - 0B8F
KB88:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+20]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0B90 - 0B97
KB90:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln471
and ah,0BFh
jmp short ln472
ln471:
or ah,40h
ln472:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0B98 - 0B9F
KB98:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln473
and ah,0BFh
jmp short ln474
ln473:
or ah,40h
ln474:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0BA0 - 0BA7
KBA0:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln475
and ah,0BFh
jmp short ln476
ln475:
or ah,40h
ln476:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0BA8 - 0BAF
KBA8:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln477
and ah,0BFh
jmp short ln478
ln477:
or ah,40h
ln478:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0BB0 - 0BB7
KBB0:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln479
and ah,0BFh
jmp short ln480
ln479:
or ah,40h
ln480:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0BB8
KBB8:
mov cl,byte[__dreg+20]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln481
and ah,0BFh
jmp short ln482
ln481:
or ah,40h
ln482:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0BB9
KBB9:
mov cl,byte[__dreg+20]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln483
and ah,0BFh
jmp short ln484
ln483:
or ah,40h
ln484:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0BC0 - 0BC7
KBC0:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln485
and ah,0BFh
jmp short ln486
ln485:
or ah,40h
ln486:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0BC8 - 0BCF
KBC8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+20]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0BD0 - 0BD7
KBD0:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln487
and ah,0BFh
jmp short ln488
ln487:
or ah,40h
ln488:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0BD8 - 0BDF
KBD8:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln489
and ah,0BFh
jmp short ln490
ln489:
or ah,40h
ln490:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0BE0 - 0BE7
KBE0:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln491
and ah,0BFh
jmp short ln492
ln491:
or ah,40h
ln492:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0BE8 - 0BEF
KBE8:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln493
and ah,0BFh
jmp short ln494
ln493:
or ah,40h
ln494:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0BF0 - 0BF7
KBF0:
mov cl,byte[__dreg+20]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln495
and ah,0BFh
jmp short ln496
ln495:
or ah,40h
ln496:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0BF8
KBF8:
mov cl,byte[__dreg+20]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln497
and ah,0BFh
jmp short ln498
ln497:
or ah,40h
ln498:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0BF9
KBF9:
mov cl,byte[__dreg+20]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln499
and ah,0BFh
jmp short ln500
ln499:
or ah,40h
ln500:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0C00 - 0C07
KC00:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
cmp [__dreg+ebx*4],cl
lahf
seto al
sub edi,byte 8
jmp near execend
; Opcodes 0C10 - 0C17
KC10:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 12
jmp near execend
; Opcodes 0C18 - 0C1F
KC18:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 12
jmp near execend
; Opcodes 0C20 - 0C27
KC20:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 14
jmp near execend
; Opcodes 0C28 - 0C2F
KC28:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 16
jmp near execend
; Opcodes 0C30 - 0C37
KC30:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 18
jmp near execend
; Opcode 0C38
KC38:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 16
jmp near execend
; Opcode 0C39
KC39:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
cmp cl,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 20
jmp near execend
; Opcodes 0C40 - 0C47
KC40:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
cmp [__dreg+ebx*4],cx
lahf
seto al
sub edi,byte 8
jmp near execend
; Opcodes 0C50 - 0C57
KC50:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 12
jmp near execend
; Opcodes 0C58 - 0C5F
KC58:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 12
jmp near execend
; Opcodes 0C60 - 0C67
KC60:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 14
jmp near execend
; Opcodes 0C68 - 0C6F
KC68:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 16
jmp near execend
; Opcodes 0C70 - 0C77
KC70:
and ebx,byte 7
mov cx,[esi]
add esi,byte 2
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 18
jmp near execend
; Opcode 0C78
KC78:
mov cx,[esi]
add esi,byte 2
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 16
jmp near execend
; Opcode 0C79
KC79:
mov cx,[esi]
add esi,byte 2
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
cmp cx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 20
jmp near execend
; Opcodes 0C80 - 0C87
KC80:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
cmp [__dreg+ebx*4],ecx
lahf
seto al
sub edi,byte 14
jmp near execend
; Opcodes 0C90 - 0C97
KC90:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 20
jmp near execend
; Opcodes 0C98 - 0C9F
KC98:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 20
jmp near execend
; Opcodes 0CA0 - 0CA7
KCA0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 22
jmp near execend
; Opcodes 0CA8 - 0CAF
KCA8:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 24
jmp near execend
; Opcodes 0CB0 - 0CB7
KCB0:
and ebx,byte 7
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 26
jmp near execend
; Opcode 0CB8
KCB8:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 24
jmp near execend
; Opcode 0CB9
KCB9:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
cmp ecx,[esp]
lahf
seto al
add esp,byte 4
sub edi,byte 28
jmp near execend
; Opcodes 0D00 - 0D07
KD00:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln501
and ah,0BFh
jmp short ln502
ln501:
or ah,40h
ln502:
sub edi,byte 6
jmp near execend
; Opcodes 0D08 - 0D0F
KD08:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+24],bx
sub edi,byte 16
jmp near execend
; Opcodes 0D10 - 0D17
KD10:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln503
and ah,0BFh
jmp short ln504
ln503:
or ah,40h
ln504:
sub edi,byte 8
jmp near execend
; Opcodes 0D18 - 0D1F
KD18:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln505
and ah,0BFh
jmp short ln506
ln505:
or ah,40h
ln506:
sub edi,byte 8
jmp near execend
; Opcodes 0D20 - 0D27
KD20:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln507
and ah,0BFh
jmp short ln508
ln507:
or ah,40h
ln508:
sub edi,byte 10
jmp near execend
; Opcodes 0D28 - 0D2F
KD28:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln509
and ah,0BFh
jmp short ln510
ln509:
or ah,40h
ln510:
sub edi,byte 12
jmp near execend
; Opcodes 0D30 - 0D37
KD30:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln511
and ah,0BFh
jmp short ln512
ln511:
or ah,40h
ln512:
sub edi,byte 14
jmp near execend
; Opcode 0D38
KD38:
mov cl,byte[__dreg+24]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln513
and ah,0BFh
jmp short ln514
ln513:
or ah,40h
ln514:
sub edi,byte 12
jmp near execend
; Opcode 0D39
KD39:
mov cl,byte[__dreg+24]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln515
and ah,0BFh
jmp short ln516
ln515:
or ah,40h
ln516:
sub edi,byte 16
jmp near execend
; Opcode 0D3A
KD3A:
mov cl,byte[__dreg+24]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln517
and ah,0BFh
jmp short ln518
ln517:
or ah,40h
ln518:
sub edi,byte 12
jmp near execend
; Opcode 0D3B
KD3B:
mov cl,byte[__dreg+24]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln519
and ah,0BFh
jmp short ln520
ln519:
or ah,40h
ln520:
sub edi,byte 14
jmp near execend
; Opcode 0D3C
KD3C:
mov cl,byte[__dreg+24]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln521
and ah,0BFh
jmp short ln522
ln521:
or ah,40h
ln522:
sub edi,byte 8
jmp near execend
; Opcodes 0D40 - 0D47
KD40:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln523
and ah,0BFh
jmp short ln524
ln523:
or ah,40h
ln524:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0D48 - 0D4F
KD48:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+24],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0D50 - 0D57
KD50:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln525
and ah,0BFh
jmp short ln526
ln525:
or ah,40h
ln526:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0D58 - 0D5F
KD58:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln527
and ah,0BFh
jmp short ln528
ln527:
or ah,40h
ln528:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0D60 - 0D67
KD60:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln529
and ah,0BFh
jmp short ln530
ln529:
or ah,40h
ln530:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0D68 - 0D6F
KD68:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln531
and ah,0BFh
jmp short ln532
ln531:
or ah,40h
ln532:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0D70 - 0D77
KD70:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln533
and ah,0BFh
jmp short ln534
ln533:
or ah,40h
ln534:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0D78
KD78:
mov cl,byte[__dreg+24]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln535
and ah,0BFh
jmp short ln536
ln535:
or ah,40h
ln536:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0D79
KD79:
mov cl,byte[__dreg+24]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln537
and ah,0BFh
jmp short ln538
ln537:
or ah,40h
ln538:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0D80 - 0D87
KD80:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln539
and ah,0BFh
jmp short ln540
ln539:
or ah,40h
ln540:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0D88 - 0D8F
KD88:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+24]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0D90 - 0D97
KD90:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln541
and ah,0BFh
jmp short ln542
ln541:
or ah,40h
ln542:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0D98 - 0D9F
KD98:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln543
and ah,0BFh
jmp short ln544
ln543:
or ah,40h
ln544:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0DA0 - 0DA7
KDA0:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln545
and ah,0BFh
jmp short ln546
ln545:
or ah,40h
ln546:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0DA8 - 0DAF
KDA8:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln547
and ah,0BFh
jmp short ln548
ln547:
or ah,40h
ln548:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0DB0 - 0DB7
KDB0:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln549
and ah,0BFh
jmp short ln550
ln549:
or ah,40h
ln550:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0DB8
KDB8:
mov cl,byte[__dreg+24]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln551
and ah,0BFh
jmp short ln552
ln551:
or ah,40h
ln552:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0DB9
KDB9:
mov cl,byte[__dreg+24]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln553
and ah,0BFh
jmp short ln554
ln553:
or ah,40h
ln554:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0DC0 - 0DC7
KDC0:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln555
and ah,0BFh
jmp short ln556
ln555:
or ah,40h
ln556:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0DC8 - 0DCF
KDC8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+24]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0DD0 - 0DD7
KDD0:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln557
and ah,0BFh
jmp short ln558
ln557:
or ah,40h
ln558:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0DD8 - 0DDF
KDD8:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln559
and ah,0BFh
jmp short ln560
ln559:
or ah,40h
ln560:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0DE0 - 0DE7
KDE0:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln561
and ah,0BFh
jmp short ln562
ln561:
or ah,40h
ln562:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0DE8 - 0DEF
KDE8:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln563
and ah,0BFh
jmp short ln564
ln563:
or ah,40h
ln564:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0DF0 - 0DF7
KDF0:
mov cl,byte[__dreg+24]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln565
and ah,0BFh
jmp short ln566
ln565:
or ah,40h
ln566:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0DF8
KDF8:
mov cl,byte[__dreg+24]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln567
and ah,0BFh
jmp short ln568
ln567:
or ah,40h
ln568:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0DF9
KDF9:
mov cl,byte[__dreg+24]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln569
and ah,0BFh
jmp short ln570
ln569:
or ah,40h
ln570:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0F00 - 0F07
KF00:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
test [__dreg+ebx*4],edx
jz short ln571
and ah,0BFh
jmp short ln572
ln571:
or ah,40h
ln572:
sub edi,byte 6
jmp near execend
; Opcodes 0F08 - 0F0F
KF08:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+28],bx
sub edi,byte 16
jmp near execend
; Opcodes 0F10 - 0F17
KF10:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln573
and ah,0BFh
jmp short ln574
ln573:
or ah,40h
ln574:
sub edi,byte 8
jmp near execend
; Opcodes 0F18 - 0F1F
KF18:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln575
and ah,0BFh
jmp short ln576
ln575:
or ah,40h
ln576:
sub edi,byte 8
jmp near execend
; Opcodes 0F20 - 0F27
KF20:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
push ecx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln577
and ah,0BFh
jmp short ln578
ln577:
or ah,40h
ln578:
sub edi,byte 10
jmp near execend
; Opcodes 0F28 - 0F2F
KF28:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln579
and ah,0BFh
jmp short ln580
ln579:
or ah,40h
ln580:
sub edi,byte 12
jmp near execend
; Opcodes 0F30 - 0F37
KF30:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
push ecx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln581
and ah,0BFh
jmp short ln582
ln581:
or ah,40h
ln582:
sub edi,byte 14
jmp near execend
; Opcode 0F38
KF38:
mov cl,byte[__dreg+28]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln583
and ah,0BFh
jmp short ln584
ln583:
or ah,40h
ln584:
sub edi,byte 12
jmp near execend
; Opcode 0F39
KF39:
mov cl,byte[__dreg+28]
and ecx,byte 7
push ecx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln585
and ah,0BFh
jmp short ln586
ln585:
or ah,40h
ln586:
sub edi,byte 16
jmp near execend
; Opcode 0F3A
KF3A:
mov cl,byte[__dreg+28]
and ecx,byte 7
push ecx
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln587
and ah,0BFh
jmp short ln588
ln587:
or ah,40h
ln588:
sub edi,byte 12
jmp near execend
; Opcode 0F3B
KF3B:
mov cl,byte[__dreg+28]
and ecx,byte 7
push ecx
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln589
and ah,0BFh
jmp short ln590
ln589:
or ah,40h
ln590:
sub edi,byte 14
jmp near execend
; Opcode 0F3C
KF3C:
mov cl,byte[__dreg+28]
and ecx,byte 7
push ecx
mov cx,[esi]
add esi,byte 2
mov edx,ecx
pop ecx
inc cl
shr dl,cl
jnc short ln591
and ah,0BFh
jmp short ln592
ln591:
or ah,40h
ln592:
sub edi,byte 8
jmp near execend
; Opcodes 0F40 - 0F47
KF40:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln593
and ah,0BFh
jmp short ln594
ln593:
or ah,40h
ln594:
xor ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0F48 - 0F4F
KF48:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
add edx,byte 2
shl ebx,16
call readmemorybyte
mov bh,cl
add edx,byte 2
call readmemorybyte
mov bl,cl
mov [__dreg+28],ebx
xor ebx,ebx
sub edi,byte 24
jmp near execend
; Opcodes 0F50 - 0F57
KF50:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln595
and ah,0BFh
jmp short ln596
ln595:
or ah,40h
ln596:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0F58 - 0F5F
KF58:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln597
and ah,0BFh
jmp short ln598
ln597:
or ah,40h
ln598:
xor cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0F60 - 0F67
KF60:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln599
and ah,0BFh
jmp short ln600
ln599:
or ah,40h
ln600:
xor cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0F68 - 0F6F
KF68:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln601
and ah,0BFh
jmp short ln602
ln601:
or ah,40h
ln602:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0F70 - 0F77
KF70:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln603
and ah,0BFh
jmp short ln604
ln603:
or ah,40h
ln604:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0F78
KF78:
mov cl,byte[__dreg+28]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln605
and ah,0BFh
jmp short ln606
ln605:
or ah,40h
ln606:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0F79
KF79:
mov cl,byte[__dreg+28]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln607
and ah,0BFh
jmp short ln608
ln607:
or ah,40h
ln608:
xor cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0F80 - 0F87
KF80:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln609
and ah,0BFh
jmp short ln610
ln609:
or ah,40h
ln610:
not edx
and ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 0F88 - 0F8F
KF88:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+28]
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0F90 - 0F97
KF90:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln611
and ah,0BFh
jmp short ln612
ln611:
or ah,40h
ln612:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0F98 - 0F9F
KF98:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln613
and ah,0BFh
jmp short ln614
ln613:
or ah,40h
ln614:
not dl
and cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0FA0 - 0FA7
KFA0:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln615
and ah,0BFh
jmp short ln616
ln615:
or ah,40h
ln616:
not dl
and cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0FA8 - 0FAF
KFA8:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln617
and ah,0BFh
jmp short ln618
ln617:
or ah,40h
ln618:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0FB0 - 0FB7
KFB0:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln619
and ah,0BFh
jmp short ln620
ln619:
or ah,40h
ln620:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0FB8
KFB8:
mov cl,byte[__dreg+28]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln621
and ah,0BFh
jmp short ln622
ln621:
or ah,40h
ln622:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0FB9
KFB9:
mov cl,byte[__dreg+28]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln623
and ah,0BFh
jmp short ln624
ln623:
or ah,40h
ln624:
not dl
and cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 0FC0 - 0FC7
KFC0:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 31
mov edx,1
shl edx,cl
mov ecx,[__dreg+ebx*4]
test ecx,edx
jz short ln625
and ah,0BFh
jmp short ln626
ln625:
or ah,40h
ln626:
or ecx,edx
mov [__dreg+ebx*4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 0FC8 - 0FCF
KFC8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ebx,[__dreg+28]
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
add edx,byte 2
rol ebx,16
mov cl,bh
call writememorybyte
add edx,byte 2
mov cl,bl
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcodes 0FD0 - 0FD7
KFD0:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln627
and ah,0BFh
jmp short ln628
ln627:
or ah,40h
ln628:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 0FD8 - 0FDF
KFD8:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln629
and ah,0BFh
jmp short ln630
ln629:
or ah,40h
ln630:
or cl,dl
pop edx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 0FE0 - 0FE7
KFE0:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln631
and ah,0BFh
jmp short ln632
ln631:
or ah,40h
ln632:
or cl,dl
pop edx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 0FE8 - 0FEF
KFE8:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln633
and ah,0BFh
jmp short ln634
ln633:
or ah,40h
ln634:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 0FF0 - 0FF7
KFF0:
mov cl,byte[__dreg+28]
and ebx,byte 7
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln635
and ah,0BFh
jmp short ln636
ln635:
or ah,40h
ln636:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 0FF8
KFF8:
mov cl,byte[__dreg+28]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln637
and ah,0BFh
jmp short ln638
ln637:
or ah,40h
ln638:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 0FF9
KFF9:
mov cl,byte[__dreg+28]
and ecx,byte 7
mov dl,1
shl dl,cl
push edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xchg edx,[esp]
test cl,dl
jz short ln639
and ah,0BFh
jmp short ln640
ln639:
or ah,40h
ln640:
or cl,dl
pop edx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 1000 - 1007
L000:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1008 - 100F
L008:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1010 - 1017
L010:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1018 - 101F
L018:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1020 - 1027
L020:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1028 - 102F
L028:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1030 - 1037
L030:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1038
L038:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1039
L039:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 103A
L03A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 103B
L03B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 103C
L03C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+0],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1080 - 1087
L080:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1088 - 108F
L088:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1090 - 1097
L090:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1098 - 109F
L098:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 10A0 - 10A7
L0A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 10A8 - 10AF
L0A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 10B0 - 10B7
L0B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 10B8
L0B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 10B9
L0B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 10BA
L0BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 10BB
L0BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 10BC
L0BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 10C0 - 10C7
L0C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 10C8 - 10CF
L0C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 10D0 - 10D7
L0D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 10D8 - 10DF
L0D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 10E0 - 10E7
L0E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 10E8 - 10EF
L0E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 10F0 - 10F7
L0F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 10F8
L0F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 10F9
L0F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 10FA
L0FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 10FB
L0FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 10FC
L0FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+0]
call writememorybyte
inc edx
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1100 - 1107
L100:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1108 - 110F
L108:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1110 - 1117
L110:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1118 - 111F
L118:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1120 - 1127
L120:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1128 - 112F
L128:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1130 - 1137
L130:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1138
L138:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1139
L139:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 113A
L13A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 113B
L13B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 113C
L13C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+0]
dec edx
call writememorybyte
mov [__areg+0],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1140 - 1147
L140:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1148 - 114F
L148:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1150 - 1157
L150:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1158 - 115F
L158:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1160 - 1167
L160:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1168 - 116F
L168:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1170 - 1177
L170:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1178
L178:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1179
L179:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 117A
L17A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 117B
L17B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 117C
L17C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1180 - 1187
L180:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1188 - 118F
L188:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1190 - 1197
L190:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1198 - 119F
L198:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 11A0 - 11A7
L1A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 11A8 - 11AF
L1A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 11B0 - 11B7
L1B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 11B8
L1B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 11B9
L1B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 11BA
L1BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 11BB
L1BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 11BC
L1BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+0]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 11C0 - 11C7
L1C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 11C8 - 11CF
L1C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 11D0 - 11D7
L1D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 11D8 - 11DF
L1D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 11E0 - 11E7
L1E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 11E8 - 11EF
L1E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 11F0 - 11F7
L1F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 11F8
L1F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 11F9
L1F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 11FA
L1FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 11FB
L1FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 11FC
L1FC:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1200 - 1207
L200:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1208 - 120F
L208:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1210 - 1217
L210:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1218 - 121F
L218:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1220 - 1227
L220:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1228 - 122F
L228:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1230 - 1237
L230:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1238
L238:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1239
L239:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 123A
L23A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 123B
L23B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 123C
L23C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+4],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1280 - 1287
L280:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1288 - 128F
L288:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1290 - 1297
L290:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1298 - 129F
L298:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 12A0 - 12A7
L2A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 12A8 - 12AF
L2A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 12B0 - 12B7
L2B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 12B8
L2B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 12B9
L2B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 12BA
L2BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 12BB
L2BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 12BC
L2BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 12C0 - 12C7
L2C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 12C8 - 12CF
L2C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 12D0 - 12D7
L2D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 12D8 - 12DF
L2D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 12E0 - 12E7
L2E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 12E8 - 12EF
L2E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 12F0 - 12F7
L2F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 12F8
L2F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 12F9
L2F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 12FA
L2FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 12FB
L2FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 12FC
L2FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+4]
call writememorybyte
inc edx
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1300 - 1307
L300:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1308 - 130F
L308:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1310 - 1317
L310:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1318 - 131F
L318:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1320 - 1327
L320:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1328 - 132F
L328:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1330 - 1337
L330:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1338
L338:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1339
L339:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 133A
L33A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 133B
L33B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 133C
L33C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+4]
dec edx
call writememorybyte
mov [__areg+4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1340 - 1347
L340:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1348 - 134F
L348:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1350 - 1357
L350:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1358 - 135F
L358:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1360 - 1367
L360:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1368 - 136F
L368:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1370 - 1377
L370:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1378
L378:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1379
L379:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 137A
L37A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 137B
L37B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 137C
L37C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1380 - 1387
L380:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1388 - 138F
L388:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1390 - 1397
L390:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1398 - 139F
L398:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 13A0 - 13A7
L3A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 13A8 - 13AF
L3A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 13B0 - 13B7
L3B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 13B8
L3B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 13B9
L3B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 13BA
L3BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 13BB
L3BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 13BC
L3BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+4]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 13C0 - 13C7
L3C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 13C8 - 13CF
L3C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 13D0 - 13D7
L3D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 13D8 - 13DF
L3D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 13E0 - 13E7
L3E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 13E8 - 13EF
L3E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 13F0 - 13F7
L3F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 13F8
L3F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 13F9
L3F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 13FA
L3FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 13FB
L3FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 13FC
L3FC:
mov cx,[esi]
add esi,byte 2
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1400 - 1407
L400:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1408 - 140F
L408:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1410 - 1417
L410:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1418 - 141F
L418:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1420 - 1427
L420:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1428 - 142F
L428:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1430 - 1437
L430:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1438
L438:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1439
L439:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 143A
L43A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 143B
L43B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 143C
L43C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+8],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1480 - 1487
L480:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1488 - 148F
L488:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1490 - 1497
L490:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1498 - 149F
L498:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 14A0 - 14A7
L4A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 14A8 - 14AF
L4A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 14B0 - 14B7
L4B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 14B8
L4B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 14B9
L4B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 14BA
L4BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 14BB
L4BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 14BC
L4BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 14C0 - 14C7
L4C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 14C8 - 14CF
L4C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 14D0 - 14D7
L4D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 14D8 - 14DF
L4D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 14E0 - 14E7
L4E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 14E8 - 14EF
L4E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 14F0 - 14F7
L4F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 14F8
L4F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 14F9
L4F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 14FA
L4FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 14FB
L4FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 14FC
L4FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+8]
call writememorybyte
inc edx
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1500 - 1507
L500:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1508 - 150F
L508:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1510 - 1517
L510:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1518 - 151F
L518:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1520 - 1527
L520:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1528 - 152F
L528:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1530 - 1537
L530:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1538
L538:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1539
L539:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 153A
L53A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 153B
L53B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 153C
L53C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+8]
dec edx
call writememorybyte
mov [__areg+8],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1540 - 1547
L540:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1548 - 154F
L548:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1550 - 1557
L550:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1558 - 155F
L558:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1560 - 1567
L560:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1568 - 156F
L568:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1570 - 1577
L570:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1578
L578:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1579
L579:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 157A
L57A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 157B
L57B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 157C
L57C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1580 - 1587
L580:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1588 - 158F
L588:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1590 - 1597
L590:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1598 - 159F
L598:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 15A0 - 15A7
L5A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 15A8 - 15AF
L5A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 15B0 - 15B7
L5B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 15B8
L5B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 15B9
L5B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 15BA
L5BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 15BB
L5BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 15BC
L5BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+8]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1600 - 1607
L600:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1608 - 160F
L608:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1610 - 1617
L610:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1618 - 161F
L618:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1620 - 1627
L620:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1628 - 162F
L628:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1630 - 1637
L630:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1638
L638:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1639
L639:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 163A
L63A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 163B
L63B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 163C
L63C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+12],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1680 - 1687
L680:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1688 - 168F
L688:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1690 - 1697
L690:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1698 - 169F
L698:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 16A0 - 16A7
L6A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 16A8 - 16AF
L6A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 16B0 - 16B7
L6B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 16B8
L6B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 16B9
L6B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 16BA
L6BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 16BB
L6BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 16BC
L6BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 16C0 - 16C7
L6C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 16C8 - 16CF
L6C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 16D0 - 16D7
L6D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 16D8 - 16DF
L6D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 16E0 - 16E7
L6E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 16E8 - 16EF
L6E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 16F0 - 16F7
L6F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 16F8
L6F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 16F9
L6F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 16FA
L6FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 16FB
L6FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 16FC
L6FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+12]
call writememorybyte
inc edx
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1700 - 1707
L700:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1708 - 170F
L708:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1710 - 1717
L710:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1718 - 171F
L718:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1720 - 1727
L720:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1728 - 172F
L728:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1730 - 1737
L730:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1738
L738:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1739
L739:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 173A
L73A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 173B
L73B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 173C
L73C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+12]
dec edx
call writememorybyte
mov [__areg+12],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1740 - 1747
L740:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1748 - 174F
L748:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1750 - 1757
L750:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1758 - 175F
L758:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1760 - 1767
L760:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1768 - 176F
L768:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1770 - 1777
L770:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1778
L778:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1779
L779:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 177A
L77A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 177B
L77B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 177C
L77C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1780 - 1787
L780:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1788 - 178F
L788:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1790 - 1797
L790:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1798 - 179F
L798:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 17A0 - 17A7
L7A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 17A8 - 17AF
L7A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 17B0 - 17B7
L7B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 17B8
L7B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 17B9
L7B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 17BA
L7BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 17BB
L7BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 17BC
L7BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+12]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1800 - 1807
L800:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1808 - 180F
L808:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1810 - 1817
L810:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1818 - 181F
L818:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1820 - 1827
L820:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1828 - 182F
L828:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1830 - 1837
L830:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1838
L838:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1839
L839:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 183A
L83A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 183B
L83B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 183C
L83C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+16],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1880 - 1887
L880:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1888 - 188F
L888:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1890 - 1897
L890:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1898 - 189F
L898:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 18A0 - 18A7
L8A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 18A8 - 18AF
L8A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 18B0 - 18B7
L8B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 18B8
L8B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 18B9
L8B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 18BA
L8BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 18BB
L8BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 18BC
L8BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 18C0 - 18C7
L8C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 18C8 - 18CF
L8C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 18D0 - 18D7
L8D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 18D8 - 18DF
L8D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 18E0 - 18E7
L8E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 18E8 - 18EF
L8E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 18F0 - 18F7
L8F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 18F8
L8F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 18F9
L8F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 18FA
L8FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 18FB
L8FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 18FC
L8FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+16]
call writememorybyte
inc edx
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1900 - 1907
L900:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1908 - 190F
L908:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1910 - 1917
L910:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1918 - 191F
L918:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1920 - 1927
L920:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1928 - 192F
L928:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1930 - 1937
L930:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1938
L938:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1939
L939:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 193A
L93A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 193B
L93B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 193C
L93C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+16]
dec edx
call writememorybyte
mov [__areg+16],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1940 - 1947
L940:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1948 - 194F
L948:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1950 - 1957
L950:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1958 - 195F
L958:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1960 - 1967
L960:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1968 - 196F
L968:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1970 - 1977
L970:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1978
L978:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1979
L979:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 197A
L97A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 197B
L97B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 197C
L97C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1980 - 1987
L980:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1988 - 198F
L988:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1990 - 1997
L990:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1998 - 199F
L998:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 19A0 - 19A7
L9A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 19A8 - 19AF
L9A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 19B0 - 19B7
L9B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 19B8
L9B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 19B9
L9B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 19BA
L9BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 19BB
L9BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 19BC
L9BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+16]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1A00 - 1A07
LA00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1A08 - 1A0F
LA08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1A10 - 1A17
LA10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1A18 - 1A1F
LA18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1A20 - 1A27
LA20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1A28 - 1A2F
LA28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1A30 - 1A37
LA30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1A38
LA38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1A39
LA39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1A3A
LA3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1A3B
LA3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1A3C
LA3C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+20],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1A80 - 1A87
LA80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1A88 - 1A8F
LA88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1A90 - 1A97
LA90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1A98 - 1A9F
LA98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1AA0 - 1AA7
LAA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1AA8 - 1AAF
LAA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1AB0 - 1AB7
LAB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1AB8
LAB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1AB9
LAB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1ABA
LABA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1ABB
LABB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1ABC
LABC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1AC0 - 1AC7
LAC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1AC8 - 1ACF
LAC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1AD0 - 1AD7
LAD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1AD8 - 1ADF
LAD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1AE0 - 1AE7
LAE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1AE8 - 1AEF
LAE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1AF0 - 1AF7
LAF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1AF8
LAF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1AF9
LAF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1AFA
LAFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1AFB
LAFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1AFC
LAFC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+20]
call writememorybyte
inc edx
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1B00 - 1B07
LB00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1B08 - 1B0F
LB08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1B10 - 1B17
LB10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1B18 - 1B1F
LB18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1B20 - 1B27
LB20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1B28 - 1B2F
LB28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1B30 - 1B37
LB30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1B38
LB38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1B39
LB39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1B3A
LB3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1B3B
LB3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1B3C
LB3C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+20]
dec edx
call writememorybyte
mov [__areg+20],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1B40 - 1B47
LB40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1B48 - 1B4F
LB48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1B50 - 1B57
LB50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1B58 - 1B5F
LB58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1B60 - 1B67
LB60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1B68 - 1B6F
LB68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1B70 - 1B77
LB70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1B78
LB78:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1B79
LB79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1B7A
LB7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1B7B
LB7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1B7C
LB7C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1B80 - 1B87
LB80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1B88 - 1B8F
LB88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1B90 - 1B97
LB90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1B98 - 1B9F
LB98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1BA0 - 1BA7
LBA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1BA8 - 1BAF
LBA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 1BB0 - 1BB7
LBB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1BB8
LBB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1BB9
LBB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 1BBA
LBBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1BBB
LBBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1BBC
LBBC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+20]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1C00 - 1C07
LC00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1C08 - 1C0F
LC08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1C10 - 1C17
LC10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1C18 - 1C1F
LC18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1C20 - 1C27
LC20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1C28 - 1C2F
LC28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1C30 - 1C37
LC30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1C38
LC38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1C39
LC39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1C3A
LC3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1C3B
LC3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1C3C
LC3C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+24],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1C80 - 1C87
LC80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1C88 - 1C8F
LC88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1C90 - 1C97
LC90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1C98 - 1C9F
LC98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1CA0 - 1CA7
LCA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1CA8 - 1CAF
LCA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1CB0 - 1CB7
LCB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1CB8
LCB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1CB9
LCB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1CBA
LCBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1CBB
LCBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1CBC
LCBC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1CC0 - 1CC7
LCC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1CC8 - 1CCF
LCC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1CD0 - 1CD7
LCD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1CD8 - 1CDF
LCD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1CE0 - 1CE7
LCE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1CE8 - 1CEF
LCE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1CF0 - 1CF7
LCF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1CF8
LCF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1CF9
LCF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1CFA
LCFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1CFB
LCFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1CFC
LCFC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+24]
call writememorybyte
inc edx
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1D00 - 1D07
LD00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1D08 - 1D0F
LD08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1D10 - 1D17
LD10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1D18 - 1D1F
LD18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1D20 - 1D27
LD20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1D28 - 1D2F
LD28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1D30 - 1D37
LD30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1D38
LD38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1D39
LD39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1D3A
LD3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1D3B
LD3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1D3C
LD3C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+24]
dec edx
call writememorybyte
mov [__areg+24],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1D40 - 1D47
LD40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1D48 - 1D4F
LD48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1D50 - 1D57
LD50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1D58 - 1D5F
LD58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1D60 - 1D67
LD60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1D68 - 1D6F
LD68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1D70 - 1D77
LD70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1D78
LD78:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1D79
LD79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1D7A
LD7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1D7B
LD7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1D7C
LD7C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1D80 - 1D87
LD80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1D88 - 1D8F
LD88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1D90 - 1D97
LD90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1D98 - 1D9F
LD98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1DA0 - 1DA7
LDA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1DA8 - 1DAF
LDA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 1DB0 - 1DB7
LDB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1DB8
LDB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1DB9
LDB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 1DBA
LDBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1DBB
LDBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1DBC
LDBC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+24]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1E00 - 1E07
LE00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1E08 - 1E0F
LE08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 1E10 - 1E17
LE10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1E18 - 1E1F
LE18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1E20 - 1E27
LE20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 1E28 - 1E2F
LE28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1E30 - 1E37
LE30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1E38
LE38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1E39
LE39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1E3A
LE3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 1E3B
LE3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 1E3C
LE3C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+28],cl
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1E80 - 1E87
LE80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1E88 - 1E8F
LE88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1E90 - 1E97
LE90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1E98 - 1E9F
LE98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1EA0 - 1EA7
LEA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1EA8 - 1EAF
LEA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1EB0 - 1EB7
LEB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1EB8
LEB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1EB9
LEB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1EBA
LEBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1EBB
LEBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1EBC
LEBC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1EC0 - 1EC7
LEC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1EC8 - 1ECF
LEC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1ED0 - 1ED7
LED0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1ED8 - 1EDF
LED8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1EE0 - 1EE7
LEE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1EE8 - 1EEF
LEE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1EF0 - 1EF7
LEF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1EF8
LEF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1EF9
LEF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1EFA
LEFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1EFB
LEFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1EFC
LEFC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+28]
call writememorybyte
add edx,byte 2
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1F00 - 1F07
LF00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1F08 - 1F0F
LF08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 1F10 - 1F17
LF10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1F18 - 1F1F
LF18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1F20 - 1F27
LF20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1F28 - 1F2F
LF28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1F30 - 1F37
LF30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1F38
LF38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1F39
LF39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1F3A
LF3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 1F3B
LF3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 1F3C
LF3C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+28]
sub edx,byte 2
call writememorybyte
mov [__areg+28],edx
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1F40 - 1F47
LF40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1F48 - 1F4F
LF48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 1F50 - 1F57
LF50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1F58 - 1F5F
LF58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1F60 - 1F67
LF60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1F68 - 1F6F
LF68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1F70 - 1F77
LF70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1F78
LF78:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1F79
LF79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1F7A
LF7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 1F7B
LF7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1F7C
LF7C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 1F80 - 1F87
LF80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1F88 - 1F8F
LF88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 1F90 - 1F97
LF90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1F98 - 1F9F
LF98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 1FA0 - 1FA7
LFA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 1FA8 - 1FAF
LFA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 1FB0 - 1FB7
LFB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1FB8
LFB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1FB9
LFB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 1FBA
LFBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 1FBB
LFBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 1FBC
LFBC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+28]
call writememorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2000 - 2007
M000:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2008 - 200F
M008:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2010 - 2017
M010:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2018 - 201F
M018:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2020 - 2027
M020:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2028 - 202F
M028:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2030 - 2037
M030:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2038
M038:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2039
M039:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 203A
M03A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 203B
M03B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 203C
M03C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+0],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2040 - 2047
M040:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+0],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2048 - 204F
M048:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+0],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2050 - 2057
M050:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2058 - 205F
M058:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+0],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2060 - 2067
M060:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+0],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2068 - 206F
M068:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2070 - 2077
M070:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 18
jmp near execend
; Opcode 2078
M078:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 16
jmp near execend
; Opcode 2079
M079:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 20
jmp near execend
; Opcode 207A
M07A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 16
jmp near execend
; Opcode 207B
M07B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+0],ecx
sub edi,byte 18
jmp near execend
; Opcode 207C
M07C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+0],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2080 - 2087
M080:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2088 - 208F
M088:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2090 - 2097
M090:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2098 - 209F
M098:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 20A0 - 20A7
M0A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 20A8 - 20AF
M0A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 20B0 - 20B7
M0B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 20B8
M0B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 20B9
M0B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 20BA
M0BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 20BB
M0BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 20BC
M0BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 20C0 - 20C7
M0C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 20C8 - 20CF
M0C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 20D0 - 20D7
M0D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 20D8 - 20DF
M0D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 20E0 - 20E7
M0E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 20E8 - 20EF
M0E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 20F0 - 20F7
M0F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 20F8
M0F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 20F9
M0F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 20FA
M0FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 20FB
M0FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 20FC
M0FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+0]
call writememorydword
add edx,byte 4
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2100 - 2107
M100:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2108 - 210F
M108:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2110 - 2117
M110:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2118 - 211F
M118:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2120 - 2127
M120:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2128 - 212F
M128:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2130 - 2137
M130:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2138
M138:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2139
M139:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 213A
M13A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 213B
M13B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 213C
M13C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+0]
sub edx,byte 4
call writememorydword
mov [__areg+0],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2140 - 2147
M140:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2148 - 214F
M148:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2150 - 2157
M150:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2158 - 215F
M158:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2160 - 2167
M160:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2168 - 216F
M168:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2170 - 2177
M170:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2178
M178:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2179
M179:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 217A
M17A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 217B
M17B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 217C
M17C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2180 - 2187
M180:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2188 - 218F
M188:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2190 - 2197
M190:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2198 - 219F
M198:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 21A0 - 21A7
M1A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 21A8 - 21AF
M1A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 21B0 - 21B7
M1B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 21B8
M1B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 21B9
M1B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 21BA
M1BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 21BB
M1BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 21BC
M1BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+0]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 21C0 - 21C7
M1C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 21C8 - 21CF
M1C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 21D0 - 21D7
M1D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 21D8 - 21DF
M1D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 21E0 - 21E7
M1E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 21E8 - 21EF
M1E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 21F0 - 21F7
M1F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 21F8
M1F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 21F9
M1F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 21FA
M1FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 21FB
M1FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 21FC
M1FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2200 - 2207
M200:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2208 - 220F
M208:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2210 - 2217
M210:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2218 - 221F
M218:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2220 - 2227
M220:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2228 - 222F
M228:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2230 - 2237
M230:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2238
M238:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2239
M239:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 223A
M23A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 223B
M23B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 223C
M23C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2240 - 2247
M240:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+4],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2248 - 224F
M248:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+4],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2250 - 2257
M250:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2258 - 225F
M258:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2260 - 2267
M260:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+4],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2268 - 226F
M268:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2270 - 2277
M270:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 18
jmp near execend
; Opcode 2278
M278:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 16
jmp near execend
; Opcode 2279
M279:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 20
jmp near execend
; Opcode 227A
M27A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 16
jmp near execend
; Opcode 227B
M27B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+4],ecx
sub edi,byte 18
jmp near execend
; Opcode 227C
M27C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2280 - 2287
M280:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2288 - 228F
M288:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2290 - 2297
M290:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2298 - 229F
M298:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 22A0 - 22A7
M2A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 22A8 - 22AF
M2A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 22B0 - 22B7
M2B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 22B8
M2B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 22B9
M2B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 22BA
M2BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 22BB
M2BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 22BC
M2BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 22C0 - 22C7
M2C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 22C8 - 22CF
M2C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 22D0 - 22D7
M2D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 22D8 - 22DF
M2D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 22E0 - 22E7
M2E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 22E8 - 22EF
M2E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 22F0 - 22F7
M2F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 22F8
M2F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 22F9
M2F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 22FA
M2FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 22FB
M2FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 22FC
M2FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+4]
call writememorydword
add edx,byte 4
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2300 - 2307
M300:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2308 - 230F
M308:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2310 - 2317
M310:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2318 - 231F
M318:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2320 - 2327
M320:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2328 - 232F
M328:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2330 - 2337
M330:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2338
M338:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2339
M339:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 233A
M33A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 233B
M33B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 233C
M33C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+4]
sub edx,byte 4
call writememorydword
mov [__areg+4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2340 - 2347
M340:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2348 - 234F
M348:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2350 - 2357
M350:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2358 - 235F
M358:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2360 - 2367
M360:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2368 - 236F
M368:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2370 - 2377
M370:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2378
M378:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2379
M379:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 237A
M37A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 237B
M37B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 237C
M37C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2380 - 2387
M380:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2388 - 238F
M388:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2390 - 2397
M390:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2398 - 239F
M398:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 23A0 - 23A7
M3A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 23A8 - 23AF
M3A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 23B0 - 23B7
M3B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 23B8
M3B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 23B9
M3B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 23BA
M3BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 23BB
M3BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 23BC
M3BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+4]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 23C0 - 23C7
M3C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 23C8 - 23CF
M3C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 23D0 - 23D7
M3D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 23D8 - 23DF
M3D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 23E0 - 23E7
M3E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 23E8 - 23EF
M3E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcodes 23F0 - 23F7
M3F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 23F8
M3F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 23F9
M3F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 36
jmp near execend
; Opcode 23FA
M3FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 23FB
M3FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 23FC
M3FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2400 - 2407
M400:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2408 - 240F
M408:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2410 - 2417
M410:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2418 - 241F
M418:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2420 - 2427
M420:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2428 - 242F
M428:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2430 - 2437
M430:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2438
M438:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2439
M439:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 243A
M43A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 243B
M43B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 243C
M43C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+8],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2440 - 2447
M440:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+8],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2448 - 244F
M448:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+8],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2450 - 2457
M450:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2458 - 245F
M458:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+8],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2460 - 2467
M460:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+8],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2468 - 246F
M468:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2470 - 2477
M470:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 18
jmp near execend
; Opcode 2478
M478:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 16
jmp near execend
; Opcode 2479
M479:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 20
jmp near execend
; Opcode 247A
M47A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 16
jmp near execend
; Opcode 247B
M47B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+8],ecx
sub edi,byte 18
jmp near execend
; Opcode 247C
M47C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+8],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2480 - 2487
M480:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2488 - 248F
M488:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2490 - 2497
M490:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2498 - 249F
M498:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 24A0 - 24A7
M4A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 24A8 - 24AF
M4A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 24B0 - 24B7
M4B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 24B8
M4B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 24B9
M4B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 24BA
M4BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 24BB
M4BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 24BC
M4BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 24C0 - 24C7
M4C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 24C8 - 24CF
M4C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 24D0 - 24D7
M4D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 24D8 - 24DF
M4D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 24E0 - 24E7
M4E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 24E8 - 24EF
M4E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 24F0 - 24F7
M4F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 24F8
M4F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 24F9
M4F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 24FA
M4FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 24FB
M4FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 24FC
M4FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+8]
call writememorydword
add edx,byte 4
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2500 - 2507
M500:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2508 - 250F
M508:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2510 - 2517
M510:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2518 - 251F
M518:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2520 - 2527
M520:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2528 - 252F
M528:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2530 - 2537
M530:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2538
M538:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2539
M539:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 253A
M53A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 253B
M53B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 253C
M53C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+8]
sub edx,byte 4
call writememorydword
mov [__areg+8],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2540 - 2547
M540:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2548 - 254F
M548:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2550 - 2557
M550:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2558 - 255F
M558:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2560 - 2567
M560:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2568 - 256F
M568:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2570 - 2577
M570:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2578
M578:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2579
M579:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 257A
M57A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 257B
M57B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 257C
M57C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2580 - 2587
M580:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2588 - 258F
M588:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2590 - 2597
M590:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2598 - 259F
M598:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 25A0 - 25A7
M5A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 25A8 - 25AF
M5A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 25B0 - 25B7
M5B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 25B8
M5B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 25B9
M5B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 25BA
M5BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 25BB
M5BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 25BC
M5BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+8]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2600 - 2607
M600:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2608 - 260F
M608:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2610 - 2617
M610:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2618 - 261F
M618:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2620 - 2627
M620:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2628 - 262F
M628:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2630 - 2637
M630:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2638
M638:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2639
M639:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 263A
M63A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 263B
M63B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 263C
M63C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+12],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2640 - 2647
M640:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+12],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2648 - 264F
M648:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+12],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2650 - 2657
M650:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2658 - 265F
M658:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+12],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2660 - 2667
M660:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+12],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2668 - 266F
M668:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2670 - 2677
M670:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 18
jmp near execend
; Opcode 2678
M678:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 16
jmp near execend
; Opcode 2679
M679:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 20
jmp near execend
; Opcode 267A
M67A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 16
jmp near execend
; Opcode 267B
M67B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+12],ecx
sub edi,byte 18
jmp near execend
; Opcode 267C
M67C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+12],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2680 - 2687
M680:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2688 - 268F
M688:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2690 - 2697
M690:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2698 - 269F
M698:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 26A0 - 26A7
M6A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 26A8 - 26AF
M6A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 26B0 - 26B7
M6B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 26B8
M6B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 26B9
M6B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 26BA
M6BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 26BB
M6BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 26BC
M6BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 26C0 - 26C7
M6C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 26C8 - 26CF
M6C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 26D0 - 26D7
M6D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 26D8 - 26DF
M6D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 26E0 - 26E7
M6E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 26E8 - 26EF
M6E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 26F0 - 26F7
M6F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 26F8
M6F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 26F9
M6F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 26FA
M6FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 26FB
M6FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 26FC
M6FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+12]
call writememorydword
add edx,byte 4
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2700 - 2707
M700:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2708 - 270F
M708:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2710 - 2717
M710:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2718 - 271F
M718:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2720 - 2727
M720:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2728 - 272F
M728:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2730 - 2737
M730:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2738
M738:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2739
M739:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 273A
M73A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 273B
M73B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 273C
M73C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+12]
sub edx,byte 4
call writememorydword
mov [__areg+12],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2740 - 2747
M740:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2748 - 274F
M748:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2750 - 2757
M750:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2758 - 275F
M758:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2760 - 2767
M760:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2768 - 276F
M768:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2770 - 2777
M770:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2778
M778:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2779
M779:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 277A
M77A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 277B
M77B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 277C
M77C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2780 - 2787
M780:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2788 - 278F
M788:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2790 - 2797
M790:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2798 - 279F
M798:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 27A0 - 27A7
M7A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 27A8 - 27AF
M7A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 27B0 - 27B7
M7B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 27B8
M7B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 27B9
M7B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 27BA
M7BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 27BB
M7BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 27BC
M7BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+12]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2800 - 2807
M800:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2808 - 280F
M808:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2810 - 2817
M810:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2818 - 281F
M818:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2820 - 2827
M820:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2828 - 282F
M828:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2830 - 2837
M830:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2838
M838:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2839
M839:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 283A
M83A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 283B
M83B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 283C
M83C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+16],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2840 - 2847
M840:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+16],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2848 - 284F
M848:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+16],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2850 - 2857
M850:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2858 - 285F
M858:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+16],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2860 - 2867
M860:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+16],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2868 - 286F
M868:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2870 - 2877
M870:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 18
jmp near execend
; Opcode 2878
M878:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 16
jmp near execend
; Opcode 2879
M879:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 20
jmp near execend
; Opcode 287A
M87A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 16
jmp near execend
; Opcode 287B
M87B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+16],ecx
sub edi,byte 18
jmp near execend
; Opcode 287C
M87C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+16],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2880 - 2887
M880:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2888 - 288F
M888:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2890 - 2897
M890:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2898 - 289F
M898:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 28A0 - 28A7
M8A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 28A8 - 28AF
M8A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 28B0 - 28B7
M8B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 28B8
M8B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 28B9
M8B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 28BA
M8BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 28BB
M8BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 28BC
M8BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 28C0 - 28C7
M8C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 28C8 - 28CF
M8C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 28D0 - 28D7
M8D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 28D8 - 28DF
M8D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 28E0 - 28E7
M8E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 28E8 - 28EF
M8E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 28F0 - 28F7
M8F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 28F8
M8F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 28F9
M8F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 28FA
M8FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 28FB
M8FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 28FC
M8FC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+16]
call writememorydword
add edx,byte 4
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2900 - 2907
M900:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2908 - 290F
M908:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2910 - 2917
M910:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2918 - 291F
M918:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2920 - 2927
M920:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2928 - 292F
M928:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2930 - 2937
M930:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2938
M938:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2939
M939:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 293A
M93A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 293B
M93B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 293C
M93C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+16]
sub edx,byte 4
call writememorydword
mov [__areg+16],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2940 - 2947
M940:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2948 - 294F
M948:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2950 - 2957
M950:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2958 - 295F
M958:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2960 - 2967
M960:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2968 - 296F
M968:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2970 - 2977
M970:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2978
M978:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2979
M979:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 297A
M97A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 297B
M97B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 297C
M97C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2980 - 2987
M980:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2988 - 298F
M988:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2990 - 2997
M990:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2998 - 299F
M998:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 29A0 - 29A7
M9A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 29A8 - 29AF
M9A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 29B0 - 29B7
M9B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 29B8
M9B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 29B9
M9B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 29BA
M9BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 29BB
M9BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 29BC
M9BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+16]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2A00 - 2A07
MA00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2A08 - 2A0F
MA08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2A10 - 2A17
MA10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2A18 - 2A1F
MA18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2A20 - 2A27
MA20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2A28 - 2A2F
MA28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2A30 - 2A37
MA30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2A38
MA38:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2A39
MA39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 2A3A
MA3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2A3B
MA3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2A3C
MA3C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+20],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2A40 - 2A47
MA40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+20],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2A48 - 2A4F
MA48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+20],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2A50 - 2A57
MA50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2A58 - 2A5F
MA58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+20],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2A60 - 2A67
MA60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+20],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2A68 - 2A6F
MA68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2A70 - 2A77
MA70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 18
jmp near execend
; Opcode 2A78
MA78:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 16
jmp near execend
; Opcode 2A79
MA79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 20
jmp near execend
; Opcode 2A7A
MA7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 16
jmp near execend
; Opcode 2A7B
MA7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+20],ecx
sub edi,byte 18
jmp near execend
; Opcode 2A7C
MA7C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+20],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2A80 - 2A87
MA80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2A88 - 2A8F
MA88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2A90 - 2A97
MA90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2A98 - 2A9F
MA98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2AA0 - 2AA7
MAA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2AA8 - 2AAF
MAA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2AB0 - 2AB7
MAB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2AB8
MAB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2AB9
MAB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2ABA
MABA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2ABB
MABB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2ABC
MABC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2AC0 - 2AC7
MAC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2AC8 - 2ACF
MAC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2AD0 - 2AD7
MAD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2AD8 - 2ADF
MAD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2AE0 - 2AE7
MAE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2AE8 - 2AEF
MAE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2AF0 - 2AF7
MAF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2AF8
MAF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2AF9
MAF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2AFA
MAFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2AFB
MAFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2AFC
MAFC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+20]
call writememorydword
add edx,byte 4
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2B00 - 2B07
MB00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2B08 - 2B0F
MB08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2B10 - 2B17
MB10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2B18 - 2B1F
MB18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2B20 - 2B27
MB20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2B28 - 2B2F
MB28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2B30 - 2B37
MB30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2B38
MB38:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2B39
MB39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2B3A
MB3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2B3B
MB3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2B3C
MB3C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+20]
sub edx,byte 4
call writememorydword
mov [__areg+20],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2B40 - 2B47
MB40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2B48 - 2B4F
MB48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2B50 - 2B57
MB50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2B58 - 2B5F
MB58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2B60 - 2B67
MB60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2B68 - 2B6F
MB68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2B70 - 2B77
MB70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2B78
MB78:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2B79
MB79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2B7A
MB7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2B7B
MB7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2B7C
MB7C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2B80 - 2B87
MB80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2B88 - 2B8F
MB88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2B90 - 2B97
MB90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2B98 - 2B9F
MB98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2BA0 - 2BA7
MBA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2BA8 - 2BAF
MBA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 2BB0 - 2BB7
MBB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2BB8
MBB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2BB9
MBB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 2BBA
MBBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2BBB
MBBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2BBC
MBBC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+20]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2C00 - 2C07
MC00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2C08 - 2C0F
MC08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2C10 - 2C17
MC10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2C18 - 2C1F
MC18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2C20 - 2C27
MC20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2C28 - 2C2F
MC28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2C30 - 2C37
MC30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2C38
MC38:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2C39
MC39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 2C3A
MC3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2C3B
MC3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2C3C
MC3C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+24],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2C40 - 2C47
MC40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+24],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2C48 - 2C4F
MC48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+24],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2C50 - 2C57
MC50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2C58 - 2C5F
MC58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+24],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2C60 - 2C67
MC60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+24],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2C68 - 2C6F
MC68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2C70 - 2C77
MC70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 18
jmp near execend
; Opcode 2C78
MC78:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 16
jmp near execend
; Opcode 2C79
MC79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 20
jmp near execend
; Opcode 2C7A
MC7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 16
jmp near execend
; Opcode 2C7B
MC7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+24],ecx
sub edi,byte 18
jmp near execend
; Opcode 2C7C
MC7C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+24],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2C80 - 2C87
MC80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2C88 - 2C8F
MC88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2C90 - 2C97
MC90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2C98 - 2C9F
MC98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2CA0 - 2CA7
MCA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2CA8 - 2CAF
MCA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2CB0 - 2CB7
MCB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2CB8
MCB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2CB9
MCB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2CBA
MCBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2CBB
MCBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2CBC
MCBC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2CC0 - 2CC7
MCC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2CC8 - 2CCF
MCC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2CD0 - 2CD7
MCD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2CD8 - 2CDF
MCD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2CE0 - 2CE7
MCE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2CE8 - 2CEF
MCE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2CF0 - 2CF7
MCF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2CF8
MCF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2CF9
MCF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2CFA
MCFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2CFB
MCFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2CFC
MCFC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+24]
call writememorydword
add edx,byte 4
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2D00 - 2D07
MD00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2D08 - 2D0F
MD08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2D10 - 2D17
MD10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2D18 - 2D1F
MD18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2D20 - 2D27
MD20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2D28 - 2D2F
MD28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2D30 - 2D37
MD30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2D38
MD38:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2D39
MD39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2D3A
MD3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2D3B
MD3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2D3C
MD3C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+24]
sub edx,byte 4
call writememorydword
mov [__areg+24],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2D40 - 2D47
MD40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2D48 - 2D4F
MD48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2D50 - 2D57
MD50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2D58 - 2D5F
MD58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2D60 - 2D67
MD60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2D68 - 2D6F
MD68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2D70 - 2D77
MD70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2D78
MD78:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2D79
MD79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2D7A
MD7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2D7B
MD7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2D7C
MD7C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2D80 - 2D87
MD80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2D88 - 2D8F
MD88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2D90 - 2D97
MD90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2D98 - 2D9F
MD98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2DA0 - 2DA7
MDA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2DA8 - 2DAF
MDA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 2DB0 - 2DB7
MDB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2DB8
MDB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2DB9
MDB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 2DBA
MDBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2DBB
MDBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2DBC
MDBC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+24]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2E00 - 2E07
ME00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2E08 - 2E0F
ME08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 2E10 - 2E17
ME10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2E18 - 2E1F
ME18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2E20 - 2E27
ME20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 2E28 - 2E2F
ME28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2E30 - 2E37
ME30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2E38
ME38:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2E39
ME39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 2E3A
ME3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 2E3B
ME3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 2E3C
ME3C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__dreg+28],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2E40 - 2E47
ME40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__areg+28],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2E48 - 2E4F
ME48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__areg+28],ecx
sub edi,byte 4
jmp near execend
; Opcodes 2E50 - 2E57
ME50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2E58 - 2E5F
ME58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov [__areg+28],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2E60 - 2E67
ME60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov [__areg+28],ecx
sub edi,byte 14
jmp near execend
; Opcodes 2E68 - 2E6F
ME68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 16
jmp near execend
; Opcodes 2E70 - 2E77
ME70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 18
jmp near execend
; Opcode 2E78
ME78:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 16
jmp near execend
; Opcode 2E79
ME79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 20
jmp near execend
; Opcode 2E7A
ME7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 16
jmp near execend
; Opcode 2E7B
ME7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov [__areg+28],ecx
sub edi,byte 18
jmp near execend
; Opcode 2E7C
ME7C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov [__areg+28],ecx
sub edi,byte 12
jmp near execend
; Opcodes 2E80 - 2E87
ME80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2E88 - 2E8F
ME88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2E90 - 2E97
ME90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2E98 - 2E9F
ME98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2EA0 - 2EA7
MEA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2EA8 - 2EAF
MEA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2EB0 - 2EB7
MEB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2EB8
MEB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2EB9
MEB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2EBA
MEBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2EBB
MEBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2EBC
MEBC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2EC0 - 2EC7
MEC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2EC8 - 2ECF
MEC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2ED0 - 2ED7
MED0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2ED8 - 2EDF
MED8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2EE0 - 2EE7
MEE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2EE8 - 2EEF
MEE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2EF0 - 2EF7
MEF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2EF8
MEF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2EF9
MEF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2EFA
MEFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2EFB
MEFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2EFC
MEFC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+28]
call writememorydword
add edx,byte 4
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2F00 - 2F07
MF00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2F08 - 2F0F
MF08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 2F10 - 2F17
MF10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2F18 - 2F1F
MF18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2F20 - 2F27
MF20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 2F28 - 2F2F
MF28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2F30 - 2F37
MF30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2F38
MF38:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2F39
MF39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2F3A
MF3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 2F3B
MF3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 2F3C
MF3C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 2F40 - 2F47
MF40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2F48 - 2F4F
MF48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 2F50 - 2F57
MF50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2F58 - 2F5F
MF58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2F60 - 2F67
MF60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2F68 - 2F6F
MF68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2F70 - 2F77
MF70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2F78
MF78:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2F79
MF79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2F7A
MF7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 2F7B
MF7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2F7C
MF7C:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 2F80 - 2F87
MF80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2F88 - 2F8F
MF88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 2F90 - 2F97
MF90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2F98 - 2F9F
MF98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 2FA0 - 2FA7
MFA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcodes 2FA8 - 2FAF
MFA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcodes 2FB0 - 2FB7
MFB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2FB8
MFB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2FB9
MFB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 34
jmp near execend
; Opcode 2FBA
MFBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 30
jmp near execend
; Opcode 2FBB
MFBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 32
jmp near execend
; Opcode 2FBC
MFBC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
call decode_ext
add edx,[__areg+28]
call writememorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcodes 3000 - 3007
N000:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3008 - 300F
N008:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3010 - 3017
N010:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3018 - 301F
N018:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3020 - 3027
N020:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3028 - 302F
N028:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3030 - 3037
N030:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3038
N038:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3039
N039:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 303A
N03A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 303B
N03B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 303C
N03C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+0],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3040 - 3047
N040:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+0],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3048 - 304F
N048:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+0],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3050 - 3057
N050:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3058 - 305F
N058:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+0],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3060 - 3067
N060:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+0],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3068 - 306F
N068:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3070 - 3077
N070:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 14
jmp near execend
; Opcode 3078
N078:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 12
jmp near execend
; Opcode 3079
N079:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 16
jmp near execend
; Opcode 307A
N07A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 12
jmp near execend
; Opcode 307B
N07B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+0],ecx
sub edi,byte 14
jmp near execend
; Opcode 307C
N07C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+0],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3080 - 3087
N080:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3088 - 308F
N088:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3090 - 3097
N090:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3098 - 309F
N098:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 30A0 - 30A7
N0A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 30A8 - 30AF
N0A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 30B0 - 30B7
N0B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 30B8
N0B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 30B9
N0B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 30BA
N0BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 30BB
N0BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 30BC
N0BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 30C0 - 30C7
N0C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 30C8 - 30CF
N0C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 30D0 - 30D7
N0D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 30D8 - 30DF
N0D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 30E0 - 30E7
N0E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 30E8 - 30EF
N0E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 30F0 - 30F7
N0F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 30F8
N0F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 30F9
N0F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 30FA
N0FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 30FB
N0FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 30FC
N0FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+0]
call writememoryword
add edx,byte 2
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3100 - 3107
N100:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3108 - 310F
N108:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3110 - 3117
N110:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3118 - 311F
N118:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3120 - 3127
N120:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3128 - 312F
N128:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3130 - 3137
N130:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3138
N138:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3139
N139:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 313A
N13A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 313B
N13B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 313C
N13C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+0]
sub edx,byte 2
call writememoryword
mov [__areg+0],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3140 - 3147
N140:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3148 - 314F
N148:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3150 - 3157
N150:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3158 - 315F
N158:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3160 - 3167
N160:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3168 - 316F
N168:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3170 - 3177
N170:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3178
N178:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3179
N179:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 317A
N17A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 317B
N17B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 317C
N17C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3180 - 3187
N180:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3188 - 318F
N188:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3190 - 3197
N190:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3198 - 319F
N198:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 31A0 - 31A7
N1A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 31A8 - 31AF
N1A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 31B0 - 31B7
N1B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 31B8
N1B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 31B9
N1B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 31BA
N1BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 31BB
N1BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 31BC
N1BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+0]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 31C0 - 31C7
N1C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 31C8 - 31CF
N1C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 31D0 - 31D7
N1D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 31D8 - 31DF
N1D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 31E0 - 31E7
N1E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 31E8 - 31EF
N1E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 31F0 - 31F7
N1F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 31F8
N1F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 31F9
N1F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 31FA
N1FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 31FB
N1FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 31FC
N1FC:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3200 - 3207
N200:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3208 - 320F
N208:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3210 - 3217
N210:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3218 - 321F
N218:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3220 - 3227
N220:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3228 - 322F
N228:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3230 - 3237
N230:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3238
N238:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3239
N239:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 323A
N23A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 323B
N23B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 323C
N23C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3240 - 3247
N240:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+4],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3248 - 324F
N248:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+4],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3250 - 3257
N250:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3258 - 325F
N258:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3260 - 3267
N260:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+4],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3268 - 326F
N268:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3270 - 3277
N270:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 14
jmp near execend
; Opcode 3278
N278:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 12
jmp near execend
; Opcode 3279
N279:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 16
jmp near execend
; Opcode 327A
N27A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 12
jmp near execend
; Opcode 327B
N27B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+4],ecx
sub edi,byte 14
jmp near execend
; Opcode 327C
N27C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+4],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3280 - 3287
N280:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3288 - 328F
N288:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3290 - 3297
N290:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3298 - 329F
N298:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 32A0 - 32A7
N2A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 32A8 - 32AF
N2A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 32B0 - 32B7
N2B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 32B8
N2B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 32B9
N2B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 32BA
N2BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 32BB
N2BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 32BC
N2BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 32C0 - 32C7
N2C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 32C8 - 32CF
N2C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 32D0 - 32D7
N2D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 32D8 - 32DF
N2D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 32E0 - 32E7
N2E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 32E8 - 32EF
N2E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 32F0 - 32F7
N2F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 32F8
N2F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 32F9
N2F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 32FA
N2FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 32FB
N2FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 32FC
N2FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+4]
call writememoryword
add edx,byte 2
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3300 - 3307
N300:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3308 - 330F
N308:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3310 - 3317
N310:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3318 - 331F
N318:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3320 - 3327
N320:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3328 - 332F
N328:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3330 - 3337
N330:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3338
N338:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3339
N339:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 333A
N33A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 333B
N33B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 333C
N33C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+4]
sub edx,byte 2
call writememoryword
mov [__areg+4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3340 - 3347
N340:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3348 - 334F
N348:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3350 - 3357
N350:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3358 - 335F
N358:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3360 - 3367
N360:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3368 - 336F
N368:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3370 - 3377
N370:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3378
N378:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3379
N379:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 337A
N37A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 337B
N37B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 337C
N37C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3380 - 3387
N380:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3388 - 338F
N388:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3390 - 3397
N390:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3398 - 339F
N398:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 33A0 - 33A7
N3A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 33A8 - 33AF
N3A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 33B0 - 33B7
N3B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 33B8
N3B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 33B9
N3B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 33BA
N3BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 33BB
N3BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 33BC
N3BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+4]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 33C0 - 33C7
N3C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 33C8 - 33CF
N3C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 33D0 - 33D7
N3D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 33D8 - 33DF
N3D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 33E0 - 33E7
N3E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 33E8 - 33EF
N3E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcodes 33F0 - 33F7
N3F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 33F8
N3F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 33F9
N3F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 28
jmp near execend
; Opcode 33FA
N3FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 33FB
N3FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 33FC
N3FC:
mov cx,[esi]
add esi,byte 2
mov edx,[esi]
add esi,byte 4
rol edx,16
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3400 - 3407
N400:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3408 - 340F
N408:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3410 - 3417
N410:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3418 - 341F
N418:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3420 - 3427
N420:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3428 - 342F
N428:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3430 - 3437
N430:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3438
N438:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3439
N439:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 343A
N43A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 343B
N43B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 343C
N43C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+8],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3440 - 3447
N440:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+8],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3448 - 344F
N448:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+8],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3450 - 3457
N450:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3458 - 345F
N458:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+8],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3460 - 3467
N460:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+8],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3468 - 346F
N468:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3470 - 3477
N470:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 14
jmp near execend
; Opcode 3478
N478:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 12
jmp near execend
; Opcode 3479
N479:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 16
jmp near execend
; Opcode 347A
N47A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 12
jmp near execend
; Opcode 347B
N47B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+8],ecx
sub edi,byte 14
jmp near execend
; Opcode 347C
N47C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+8],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3480 - 3487
N480:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3488 - 348F
N488:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3490 - 3497
N490:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3498 - 349F
N498:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 34A0 - 34A7
N4A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 34A8 - 34AF
N4A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 34B0 - 34B7
N4B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 34B8
N4B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 34B9
N4B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 34BA
N4BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 34BB
N4BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 34BC
N4BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 34C0 - 34C7
N4C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 34C8 - 34CF
N4C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 34D0 - 34D7
N4D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 34D8 - 34DF
N4D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 34E0 - 34E7
N4E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 34E8 - 34EF
N4E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 34F0 - 34F7
N4F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 34F8
N4F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 34F9
N4F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 34FA
N4FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 34FB
N4FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 34FC
N4FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+8]
call writememoryword
add edx,byte 2
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3500 - 3507
N500:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3508 - 350F
N508:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3510 - 3517
N510:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3518 - 351F
N518:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3520 - 3527
N520:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3528 - 352F
N528:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3530 - 3537
N530:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3538
N538:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3539
N539:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 353A
N53A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 353B
N53B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 353C
N53C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+8]
sub edx,byte 2
call writememoryword
mov [__areg+8],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3540 - 3547
N540:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3548 - 354F
N548:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3550 - 3557
N550:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3558 - 355F
N558:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3560 - 3567
N560:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3568 - 356F
N568:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3570 - 3577
N570:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3578
N578:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3579
N579:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 357A
N57A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 357B
N57B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 357C
N57C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3580 - 3587
N580:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3588 - 358F
N588:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3590 - 3597
N590:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3598 - 359F
N598:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 35A0 - 35A7
N5A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 35A8 - 35AF
N5A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 35B0 - 35B7
N5B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 35B8
N5B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 35B9
N5B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 35BA
N5BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 35BB
N5BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 35BC
N5BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+8]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3600 - 3607
N600:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3608 - 360F
N608:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3610 - 3617
N610:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3618 - 361F
N618:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3620 - 3627
N620:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3628 - 362F
N628:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3630 - 3637
N630:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3638
N638:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3639
N639:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 363A
N63A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 363B
N63B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 363C
N63C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+12],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3640 - 3647
N640:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+12],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3648 - 364F
N648:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+12],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3650 - 3657
N650:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3658 - 365F
N658:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+12],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3660 - 3667
N660:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+12],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3668 - 366F
N668:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3670 - 3677
N670:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 14
jmp near execend
; Opcode 3678
N678:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 12
jmp near execend
; Opcode 3679
N679:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 16
jmp near execend
; Opcode 367A
N67A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 12
jmp near execend
; Opcode 367B
N67B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+12],ecx
sub edi,byte 14
jmp near execend
; Opcode 367C
N67C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+12],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3680 - 3687
N680:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3688 - 368F
N688:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3690 - 3697
N690:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3698 - 369F
N698:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 36A0 - 36A7
N6A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 36A8 - 36AF
N6A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 36B0 - 36B7
N6B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 36B8
N6B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 36B9
N6B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 36BA
N6BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 36BB
N6BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 36BC
N6BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 36C0 - 36C7
N6C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 36C8 - 36CF
N6C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 36D0 - 36D7
N6D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 36D8 - 36DF
N6D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 36E0 - 36E7
N6E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 36E8 - 36EF
N6E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 36F0 - 36F7
N6F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 36F8
N6F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 36F9
N6F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 36FA
N6FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 36FB
N6FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 36FC
N6FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+12]
call writememoryword
add edx,byte 2
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3700 - 3707
N700:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3708 - 370F
N708:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3710 - 3717
N710:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3718 - 371F
N718:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3720 - 3727
N720:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3728 - 372F
N728:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3730 - 3737
N730:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3738
N738:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3739
N739:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 373A
N73A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 373B
N73B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 373C
N73C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+12]
sub edx,byte 2
call writememoryword
mov [__areg+12],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3740 - 3747
N740:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3748 - 374F
N748:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3750 - 3757
N750:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3758 - 375F
N758:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3760 - 3767
N760:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3768 - 376F
N768:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3770 - 3777
N770:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3778
N778:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3779
N779:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 377A
N77A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 377B
N77B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 377C
N77C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3780 - 3787
N780:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3788 - 378F
N788:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3790 - 3797
N790:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3798 - 379F
N798:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 37A0 - 37A7
N7A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 37A8 - 37AF
N7A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 37B0 - 37B7
N7B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 37B8
N7B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 37B9
N7B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 37BA
N7BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 37BB
N7BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 37BC
N7BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+12]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3800 - 3807
N800:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3808 - 380F
N808:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3810 - 3817
N810:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3818 - 381F
N818:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3820 - 3827
N820:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3828 - 382F
N828:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3830 - 3837
N830:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3838
N838:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3839
N839:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 383A
N83A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 383B
N83B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 383C
N83C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+16],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3840 - 3847
N840:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+16],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3848 - 384F
N848:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+16],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3850 - 3857
N850:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3858 - 385F
N858:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+16],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3860 - 3867
N860:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+16],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3868 - 386F
N868:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3870 - 3877
N870:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 14
jmp near execend
; Opcode 3878
N878:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 12
jmp near execend
; Opcode 3879
N879:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 16
jmp near execend
; Opcode 387A
N87A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 12
jmp near execend
; Opcode 387B
N87B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+16],ecx
sub edi,byte 14
jmp near execend
; Opcode 387C
N87C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+16],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3880 - 3887
N880:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3888 - 388F
N888:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3890 - 3897
N890:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3898 - 389F
N898:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 38A0 - 38A7
N8A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 38A8 - 38AF
N8A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 38B0 - 38B7
N8B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 38B8
N8B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 38B9
N8B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 38BA
N8BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 38BB
N8BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 38BC
N8BC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 38C0 - 38C7
N8C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 38C8 - 38CF
N8C8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 38D0 - 38D7
N8D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 38D8 - 38DF
N8D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 38E0 - 38E7
N8E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 38E8 - 38EF
N8E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 38F0 - 38F7
N8F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 38F8
N8F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 38F9
N8F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 38FA
N8FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 38FB
N8FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 38FC
N8FC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+16]
call writememoryword
add edx,byte 2
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3900 - 3907
N900:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3908 - 390F
N908:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3910 - 3917
N910:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3918 - 391F
N918:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3920 - 3927
N920:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3928 - 392F
N928:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3930 - 3937
N930:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3938
N938:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3939
N939:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 393A
N93A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 393B
N93B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 393C
N93C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+16]
sub edx,byte 2
call writememoryword
mov [__areg+16],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3940 - 3947
N940:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3948 - 394F
N948:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3950 - 3957
N950:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3958 - 395F
N958:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3960 - 3967
N960:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3968 - 396F
N968:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3970 - 3977
N970:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3978
N978:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3979
N979:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 397A
N97A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 397B
N97B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 397C
N97C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3980 - 3987
N980:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3988 - 398F
N988:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3990 - 3997
N990:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3998 - 399F
N998:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 39A0 - 39A7
N9A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 39A8 - 39AF
N9A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 39B0 - 39B7
N9B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 39B8
N9B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 39B9
N9B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 39BA
N9BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 39BB
N9BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 39BC
N9BC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+16]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3A00 - 3A07
NA00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3A08 - 3A0F
NA08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3A10 - 3A17
NA10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3A18 - 3A1F
NA18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3A20 - 3A27
NA20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3A28 - 3A2F
NA28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3A30 - 3A37
NA30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3A38
NA38:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3A39
NA39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3A3A
NA3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3A3B
NA3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3A3C
NA3C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+20],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3A40 - 3A47
NA40:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+20],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3A48 - 3A4F
NA48:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+20],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3A50 - 3A57
NA50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3A58 - 3A5F
NA58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+20],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3A60 - 3A67
NA60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+20],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3A68 - 3A6F
NA68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3A70 - 3A77
NA70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 14
jmp near execend
; Opcode 3A78
NA78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 12
jmp near execend
; Opcode 3A79
NA79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 16
jmp near execend
; Opcode 3A7A
NA7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 12
jmp near execend
; Opcode 3A7B
NA7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+20],ecx
sub edi,byte 14
jmp near execend
; Opcode 3A7C
NA7C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+20],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3A80 - 3A87
NA80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3A88 - 3A8F
NA88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3A90 - 3A97
NA90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3A98 - 3A9F
NA98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3AA0 - 3AA7
NAA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3AA8 - 3AAF
NAA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3AB0 - 3AB7
NAB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3AB8
NAB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3AB9
NAB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3ABA
NABA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3ABB
NABB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3ABC
NABC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3AC0 - 3AC7
NAC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3AC8 - 3ACF
NAC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3AD0 - 3AD7
NAD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3AD8 - 3ADF
NAD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3AE0 - 3AE7
NAE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3AE8 - 3AEF
NAE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3AF0 - 3AF7
NAF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3AF8
NAF8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3AF9
NAF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3AFA
NAFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3AFB
NAFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3AFC
NAFC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+20]
call writememoryword
add edx,byte 2
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3B00 - 3B07
NB00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3B08 - 3B0F
NB08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3B10 - 3B17
NB10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3B18 - 3B1F
NB18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3B20 - 3B27
NB20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3B28 - 3B2F
NB28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3B30 - 3B37
NB30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3B38
NB38:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3B39
NB39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3B3A
NB3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3B3B
NB3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3B3C
NB3C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+20]
sub edx,byte 2
call writememoryword
mov [__areg+20],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3B40 - 3B47
NB40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3B48 - 3B4F
NB48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3B50 - 3B57
NB50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3B58 - 3B5F
NB58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3B60 - 3B67
NB60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3B68 - 3B6F
NB68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3B70 - 3B77
NB70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3B78
NB78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3B79
NB79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3B7A
NB7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3B7B
NB7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3B7C
NB7C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3B80 - 3B87
NB80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3B88 - 3B8F
NB88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3B90 - 3B97
NB90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3B98 - 3B9F
NB98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3BA0 - 3BA7
NBA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3BA8 - 3BAF
NBA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 3BB0 - 3BB7
NBB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3BB8
NBB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3BB9
NBB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 3BBA
NBBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3BBB
NBBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3BBC
NBBC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+20]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3C00 - 3C07
NC00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3C08 - 3C0F
NC08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3C10 - 3C17
NC10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3C18 - 3C1F
NC18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3C20 - 3C27
NC20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3C28 - 3C2F
NC28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3C30 - 3C37
NC30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3C38
NC38:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3C39
NC39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3C3A
NC3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3C3B
NC3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3C3C
NC3C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+24],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3C40 - 3C47
NC40:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+24],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3C48 - 3C4F
NC48:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+24],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3C50 - 3C57
NC50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3C58 - 3C5F
NC58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+24],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3C60 - 3C67
NC60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+24],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3C68 - 3C6F
NC68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3C70 - 3C77
NC70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 14
jmp near execend
; Opcode 3C78
NC78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 12
jmp near execend
; Opcode 3C79
NC79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 16
jmp near execend
; Opcode 3C7A
NC7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 12
jmp near execend
; Opcode 3C7B
NC7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+24],ecx
sub edi,byte 14
jmp near execend
; Opcode 3C7C
NC7C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+24],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3C80 - 3C87
NC80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3C88 - 3C8F
NC88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3C90 - 3C97
NC90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3C98 - 3C9F
NC98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3CA0 - 3CA7
NCA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3CA8 - 3CAF
NCA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3CB0 - 3CB7
NCB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3CB8
NCB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3CB9
NCB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3CBA
NCBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3CBB
NCBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3CBC
NCBC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3CC0 - 3CC7
NCC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3CC8 - 3CCF
NCC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3CD0 - 3CD7
NCD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3CD8 - 3CDF
NCD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3CE0 - 3CE7
NCE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3CE8 - 3CEF
NCE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3CF0 - 3CF7
NCF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3CF8
NCF8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3CF9
NCF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3CFA
NCFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3CFB
NCFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3CFC
NCFC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+24]
call writememoryword
add edx,byte 2
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3D00 - 3D07
ND00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3D08 - 3D0F
ND08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3D10 - 3D17
ND10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3D18 - 3D1F
ND18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3D20 - 3D27
ND20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3D28 - 3D2F
ND28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3D30 - 3D37
ND30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3D38
ND38:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3D39
ND39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3D3A
ND3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3D3B
ND3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3D3C
ND3C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+24]
sub edx,byte 2
call writememoryword
mov [__areg+24],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3D40 - 3D47
ND40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3D48 - 3D4F
ND48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3D50 - 3D57
ND50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3D58 - 3D5F
ND58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3D60 - 3D67
ND60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3D68 - 3D6F
ND68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3D70 - 3D77
ND70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3D78
ND78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3D79
ND79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3D7A
ND7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3D7B
ND7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3D7C
ND7C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3D80 - 3D87
ND80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3D88 - 3D8F
ND88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3D90 - 3D97
ND90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3D98 - 3D9F
ND98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3DA0 - 3DA7
NDA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3DA8 - 3DAF
NDA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 3DB0 - 3DB7
NDB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3DB8
NDB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3DB9
NDB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 3DBA
NDBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3DBB
NDBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3DBC
NDBC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+24]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3E00 - 3E07
NE00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3E08 - 3E0F
NE08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 3E10 - 3E17
NE10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3E18 - 3E1F
NE18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3E20 - 3E27
NE20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 3E28 - 3E2F
NE28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3E30 - 3E37
NE30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3E38
NE38:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3E39
NE39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3E3A
NE3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 3E3B
NE3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 3E3C
NE3C:
mov cx,[esi]
add esi,byte 2
mov [__dreg+28],cx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3E40 - 3E47
NE40:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__areg+28],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3E48 - 3E4F
NE48:
and ebx,byte 7
movsx ecx,word[__areg+ebx*4]
mov [__areg+28],ecx
sub edi,byte 4
jmp near execend
; Opcodes 3E50 - 3E57
NE50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3E58 - 3E5F
NE58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
add edx,byte 2
mov [__areg+ebx*4],edx
mov [__areg+28],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3E60 - 3E67
NE60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+ebx*4],edx
mov [__areg+28],ecx
sub edi,byte 10
jmp near execend
; Opcodes 3E68 - 3E6F
NE68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 12
jmp near execend
; Opcodes 3E70 - 3E77
NE70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 14
jmp near execend
; Opcode 3E78
NE78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 12
jmp near execend
; Opcode 3E79
NE79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 16
jmp near execend
; Opcode 3E7A
NE7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 12
jmp near execend
; Opcode 3E7B
NE7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx ecx,cx
mov [__areg+28],ecx
sub edi,byte 14
jmp near execend
; Opcode 3E7C
NE7C:
movsx ecx,word[esi]
add esi,byte 2
mov [__areg+28],ecx
sub edi,byte 8
jmp near execend
; Opcodes 3E80 - 3E87
NE80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3E88 - 3E8F
NE88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3E90 - 3E97
NE90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3E98 - 3E9F
NE98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3EA0 - 3EA7
NEA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3EA8 - 3EAF
NEA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3EB0 - 3EB7
NEB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3EB8
NEB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3EB9
NEB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3EBA
NEBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3EBB
NEBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3EBC
NEBC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3EC0 - 3EC7
NEC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3EC8 - 3ECF
NEC8:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3ED0 - 3ED7
NED0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3ED8 - 3EDF
NED8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3EE0 - 3EE7
NEE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3EE8 - 3EEF
NEE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3EF0 - 3EF7
NEF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3EF8
NEF8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3EF9
NEF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3EFA
NEFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3EFB
NEFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3EFC
NEFC:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+28]
call writememoryword
add edx,byte 2
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3F00 - 3F07
NF00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3F08 - 3F0F
NF08:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 3F10 - 3F17
NF10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3F18 - 3F1F
NF18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3F20 - 3F27
NF20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3F28 - 3F2F
NF28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3F30 - 3F37
NF30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3F38
NF38:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3F39
NF39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3F3A
NF3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 3F3B
NF3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 3F3C
NF3C:
mov cx,[esi]
add esi,byte 2
mov edx,[__areg+28]
sub edx,byte 2
call writememoryword
mov [__areg+28],edx
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3F40 - 3F47
NF40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3F48 - 3F4F
NF48:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 3F50 - 3F57
NF50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3F58 - 3F5F
NF58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3F60 - 3F67
NF60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3F68 - 3F6F
NF68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3F70 - 3F77
NF70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3F78
NF78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3F79
NF79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3F7A
NF7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 3F7B
NF7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3F7C
NF7C:
mov cx,[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 3F80 - 3F87
NF80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3F88 - 3F8F
NF88:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 3F90 - 3F97
NF90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3F98 - 3F9F
NF98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 3FA0 - 3FA7
NFA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 3FA8 - 3FAF
NFA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcodes 3FB0 - 3FB7
NFB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3FB8
NFB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3FB9
NFB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 26
jmp near execend
; Opcode 3FBA
NFBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 3FBB
NFBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 24
jmp near execend
; Opcode 3FBC
NFBC:
mov cx,[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+28]
call writememoryword
test cx,cx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 4000 - 4007
O000:
and ebx,byte 7
xor cl,cl
shr byte[__xflag],1
sbb cl,[__dreg+ebx*4]
mov dl,ah
lahf
seto al
setc [__xflag]
jnz short ln641
or dl,0BFh
and ah,dl
ln641:
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 4010 - 4017
O010:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln642
or bl,0BFh
and ah,bl
ln642:
pop ebx
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 4018 - 401F
O018:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln643
or bl,0BFh
and ah,bl
ln643:
pop ebx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4020 - 4027
O020:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln644
or bl,0BFh
and ah,bl
ln644:
pop ebx
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4028 - 402F
O028:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln645
or bl,0BFh
and ah,bl
ln645:
pop ebx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 4030 - 4037
O030:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln646
or bl,0BFh
and ah,bl
ln646:
pop ebx
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 4038
O038:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln647
or bl,0BFh
and ah,bl
ln647:
pop ebx
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 4039
O039:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
push ebx
xor bl,bl
shr byte[__xflag],1
sbb bl,cl
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln648
or bl,0BFh
and ah,bl
ln648:
pop ebx
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 4040 - 4047
O040:
and ebx,byte 7
xor cx,cx
shr byte[__xflag],1
sbb cx,[__dreg+ebx*4]
mov dl,ah
lahf
seto al
setc [__xflag]
jnz short ln649
or dl,0BFh
and ah,dl
ln649:
mov [__dreg+ebx*4],cx
sub edi,byte 4
jmp near execend
; Opcodes 4050 - 4057
O050:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln650
or bl,0BFh
and ah,bl
ln650:
pop ebx
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 4058 - 405F
O058:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln651
or bl,0BFh
and ah,bl
ln651:
pop ebx
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4060 - 4067
O060:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln652
or bl,0BFh
and ah,bl
ln652:
pop ebx
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4068 - 406F
O068:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln653
or bl,0BFh
and ah,bl
ln653:
pop ebx
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 4070 - 4077
O070:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln654
or bl,0BFh
and ah,bl
ln654:
pop ebx
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 4078
O078:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln655
or bl,0BFh
and ah,bl
ln655:
pop ebx
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 4079
O079:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
push ebx
xor bx,bx
shr byte[__xflag],1
sbb bx,cx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln656
or bl,0BFh
and ah,bl
ln656:
pop ebx
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 4080 - 4087
O080:
and ebx,byte 7
xor ecx,ecx
shr byte[__xflag],1
sbb ecx,[__dreg+ebx*4]
mov dl,ah
lahf
seto al
setc [__xflag]
jnz short ln657
or dl,0BFh
and ah,dl
ln657:
mov [__dreg+ebx*4],ecx
sub edi,byte 6
jmp near execend
; Opcodes 4090 - 4097
O090:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln658
or bl,0BFh
and ah,bl
ln658:
pop ebx
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 4098 - 409F
O098:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln659
or bl,0BFh
and ah,bl
ln659:
pop ebx
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 40A0 - 40A7
O0A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln660
or bl,0BFh
and ah,bl
ln660:
pop ebx
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 40A8 - 40AF
O0A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln661
or bl,0BFh
and ah,bl
ln661:
pop ebx
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 40B0 - 40B7
O0B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln662
or bl,0BFh
and ah,bl
ln662:
pop ebx
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 40B8
O0B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln663
or bl,0BFh
and ah,bl
ln663:
pop ebx
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 40B9
O0B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
push ebx
xor ebx,ebx
shr byte[__xflag],1
sbb ebx,ecx
mov ecx,ebx
mov bl,ah
lahf
seto al
setc [__xflag]
jnz short ln664
or bl,0BFh
and ah,bl
ln664:
pop ebx
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 40C0 - 40C7
O0C0:
and ebx,byte 7
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
mov [__dreg+ebx*4],cx
sub edi,byte 6
jmp near execend
; Opcodes 40D0 - 40D7
O0D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 40D8 - 40DF
O0D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 40E0 - 40E7
O0E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 40E8 - 40EF
O0E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 40F0 - 40F7
O0F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 40F8
O0F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 40F9
O0F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov cx,ax
btr cx,8
adc cl,cl
or ch,[__xflag]
rol ch,4
and ch,1Ch
or cl,ch
mov ch,[__sr+1]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 4180 - 4187
O180:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn665
cmp word[__dreg+0],cx
jg short ln665
sub edi,byte 10
jmp near execend
setn665:
or ah,80h
ln665:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln666
call basefunction
ln666:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4190 - 4197
O190:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn667
cmp word[__dreg+0],cx
jg short ln667
sub edi,byte 14
jmp near execend
setn667:
or ah,80h
ln667:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln668
call basefunction
ln668:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4198 - 419F
O198:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn669
cmp word[__dreg+0],cx
jg short ln669
sub edi,byte 14
jmp near execend
setn669:
or ah,80h
ln669:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln670
call basefunction
ln670:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 41A0 - 41A7
O1A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn671
cmp word[__dreg+0],cx
jg short ln671
sub edi,byte 16
jmp near execend
setn671:
or ah,80h
ln671:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln672
call basefunction
ln672:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 41A8 - 41AF
O1A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn673
cmp word[__dreg+0],cx
jg short ln673
sub edi,byte 18
jmp near execend
setn673:
or ah,80h
ln673:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln674
call basefunction
ln674:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 41B0 - 41B7
O1B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn675
cmp word[__dreg+0],cx
jg short ln675
sub edi,byte 20
jmp near execend
setn675:
or ah,80h
ln675:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln676
call basefunction
ln676:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 41B8
O1B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn677
cmp word[__dreg+0],cx
jg short ln677
sub edi,byte 18
jmp near execend
setn677:
or ah,80h
ln677:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln678
call basefunction
ln678:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 41B9
O1B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn679
cmp word[__dreg+0],cx
jg short ln679
sub edi,byte 22
jmp near execend
setn679:
or ah,80h
ln679:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln680
call basefunction
ln680:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 41BA
O1BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn681
cmp word[__dreg+0],cx
jg short ln681
sub edi,byte 18
jmp near execend
setn681:
or ah,80h
ln681:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln682
call basefunction
ln682:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 41BB
O1BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn683
cmp word[__dreg+0],cx
jg short ln683
sub edi,byte 20
jmp near execend
setn683:
or ah,80h
ln683:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln684
call basefunction
ln684:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 41BC
O1BC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+0]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+0],word 0
jl short setn685
cmp word[__dreg+0],cx
jg short ln685
sub edi,byte 14
jmp near execend
setn685:
or ah,80h
ln685:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln686
call basefunction
ln686:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 41D0 - 41D7
O1D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+0],edx
sub edi,byte 4
jmp near execend
; Opcodes 41E8 - 41EF
O1E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+0],edx
sub edi,byte 8
jmp near execend
; Opcodes 41F0 - 41F7
O1F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+0],edx
sub edi,byte 12
jmp near execend
; Opcode 41F8
O1F8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+0],edx
sub edi,byte 8
jmp near execend
; Opcode 41F9
O1F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+0],edx
sub edi,byte 12
jmp near execend
; Opcode 41FA
O1FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+0],edx
sub edi,byte 8
jmp near execend
; Opcode 41FB
O1FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+0],edx
sub edi,byte 12
jmp near execend
; Opcodes 4200 - 4207
O200:
and ebx,byte 7
xor ecx,ecx
mov [__dreg+ebx*4],cl
mov ax,4000h
sub edi,byte 4
jmp near execend
; Opcodes 4210 - 4217
O210:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
xor ecx,ecx
call writememorybyte
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 4218 - 421F
O218:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
xor ecx,ecx
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 4220 - 4227
O220:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xor ecx,ecx
call writememorybyte
mov [__areg+ebx*4],edx
mov ax,4000h
sub edi,byte 14
jmp near execend
; Opcodes 4228 - 422F
O228:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xor ecx,ecx
call writememorybyte
mov ax,4000h
sub edi,byte 16
jmp near execend
; Opcodes 4230 - 4237
O230:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xor ecx,ecx
call writememorybyte
mov ax,4000h
sub edi,byte 18
jmp near execend
; Opcode 4238
O238:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xor ecx,ecx
call writememorybyte
mov ax,4000h
sub edi,byte 16
jmp near execend
; Opcode 4239
O239:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xor ecx,ecx
call writememorybyte
mov ax,4000h
sub edi,byte 20
jmp near execend
; Opcodes 4240 - 4247
O240:
and ebx,byte 7
xor ecx,ecx
mov [__dreg+ebx*4],cx
mov ax,4000h
sub edi,byte 4
jmp near execend
; Opcodes 4250 - 4257
O250:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor ecx,ecx
call writememoryword
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 4258 - 425F
O258:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor ecx,ecx
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 4260 - 4267
O260:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
xor ecx,ecx
call writememoryword
mov [__areg+ebx*4],edx
mov ax,4000h
sub edi,byte 14
jmp near execend
; Opcodes 4268 - 426F
O268:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor ecx,ecx
call writememoryword
mov ax,4000h
sub edi,byte 16
jmp near execend
; Opcodes 4270 - 4277
O270:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor ecx,ecx
call writememoryword
mov ax,4000h
sub edi,byte 18
jmp near execend
; Opcode 4278
O278:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor ecx,ecx
call writememoryword
mov ax,4000h
sub edi,byte 16
jmp near execend
; Opcode 4279
O279:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor ecx,ecx
call writememoryword
mov ax,4000h
sub edi,byte 20
jmp near execend
; Opcodes 4280 - 4287
O280:
and ebx,byte 7
xor ecx,ecx
mov [__dreg+ebx*4],ecx
mov ax,4000h
sub edi,byte 6
jmp near execend
; Opcodes 4290 - 4297
O290:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
xor ecx,ecx
call writememorydword
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 4298 - 429F
O298:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
xor ecx,ecx
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 42A0 - 42A7
O2A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
xor ecx,ecx
call writememorydword
mov [__areg+ebx*4],edx
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 42A8 - 42AF
O2A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
xor ecx,ecx
call writememorydword
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 42B0 - 42B7
O2B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
xor ecx,ecx
call writememorydword
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcode 42B8
O2B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
xor ecx,ecx
call writememorydword
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcode 42B9
O2B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
xor ecx,ecx
call writememorydword
mov ax,4000h
sub edi,byte 12
jmp near execend
; Opcodes 4380 - 4387
O380:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn687
cmp word[__dreg+4],cx
jg short ln687
sub edi,byte 10
jmp near execend
setn687:
or ah,80h
ln687:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln688
call basefunction
ln688:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4390 - 4397
O390:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn689
cmp word[__dreg+4],cx
jg short ln689
sub edi,byte 14
jmp near execend
setn689:
or ah,80h
ln689:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln690
call basefunction
ln690:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4398 - 439F
O398:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn691
cmp word[__dreg+4],cx
jg short ln691
sub edi,byte 14
jmp near execend
setn691:
or ah,80h
ln691:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln692
call basefunction
ln692:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 43A0 - 43A7
O3A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn693
cmp word[__dreg+4],cx
jg short ln693
sub edi,byte 16
jmp near execend
setn693:
or ah,80h
ln693:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln694
call basefunction
ln694:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 43A8 - 43AF
O3A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn695
cmp word[__dreg+4],cx
jg short ln695
sub edi,byte 18
jmp near execend
setn695:
or ah,80h
ln695:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln696
call basefunction
ln696:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 43B0 - 43B7
O3B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn697
cmp word[__dreg+4],cx
jg short ln697
sub edi,byte 20
jmp near execend
setn697:
or ah,80h
ln697:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln698
call basefunction
ln698:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 43B8
O3B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn699
cmp word[__dreg+4],cx
jg short ln699
sub edi,byte 18
jmp near execend
setn699:
or ah,80h
ln699:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln700
call basefunction
ln700:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 43B9
O3B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn701
cmp word[__dreg+4],cx
jg short ln701
sub edi,byte 22
jmp near execend
setn701:
or ah,80h
ln701:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln702
call basefunction
ln702:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 43BA
O3BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn703
cmp word[__dreg+4],cx
jg short ln703
sub edi,byte 18
jmp near execend
setn703:
or ah,80h
ln703:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln704
call basefunction
ln704:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 43BB
O3BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn705
cmp word[__dreg+4],cx
jg short ln705
sub edi,byte 20
jmp near execend
setn705:
or ah,80h
ln705:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln706
call basefunction
ln706:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 43BC
O3BC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+4]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+4],word 0
jl short setn707
cmp word[__dreg+4],cx
jg short ln707
sub edi,byte 14
jmp near execend
setn707:
or ah,80h
ln707:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln708
call basefunction
ln708:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 43D0 - 43D7
O3D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+4],edx
sub edi,byte 4
jmp near execend
; Opcodes 43E8 - 43EF
O3E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+4],edx
sub edi,byte 8
jmp near execend
; Opcodes 43F0 - 43F7
O3F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+4],edx
sub edi,byte 12
jmp near execend
; Opcode 43F8
O3F8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+4],edx
sub edi,byte 8
jmp near execend
; Opcode 43F9
O3F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+4],edx
sub edi,byte 12
jmp near execend
; Opcode 43FA
O3FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+4],edx
sub edi,byte 8
jmp near execend
; Opcode 43FB
O3FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4400 - 4407
O400:
and ebx,byte 7
neg byte[__dreg+ebx*4]
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 4410 - 4417
O410:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 4418 - 441F
O418:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4420 - 4427
O420:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4428 - 442F
O428:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 4430 - 4437
O430:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 4438
O438:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 4439
O439:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
neg cl
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 4440 - 4447
O440:
and ebx,byte 7
neg word[__dreg+ebx*4]
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 4450 - 4457
O450:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 4458 - 445F
O458:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4460 - 4467
O460:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4468 - 446F
O468:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 4470 - 4477
O470:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 4478
O478:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 4479
O479:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
neg cx
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 4480 - 4487
O480:
and ebx,byte 7
neg dword[__dreg+ebx*4]
lahf
seto al
setc [__xflag]
sub edi,byte 6
jmp near execend
; Opcodes 4490 - 4497
O490:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 4498 - 449F
O498:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 44A0 - 44A7
O4A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 44A8 - 44AF
O4A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 44B0 - 44B7
O4B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 44B8
O4B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 44B9
O4B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
neg ecx
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 44C0 - 44C7
O4C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 12
jmp near execend
; Opcodes 44D0 - 44D7
O4D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 16
jmp near execend
; Opcodes 44D8 - 44DF
O4D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 16
jmp near execend
; Opcodes 44E0 - 44E7
O4E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 18
jmp near execend
; Opcodes 44E8 - 44EF
O4E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
jmp near execend
; Opcodes 44F0 - 44F7
O4F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 22
jmp near execend
; Opcode 44F8
O4F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
jmp near execend
; Opcode 44F9
O4F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 24
jmp near execend
; Opcode 44FA
O4FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
jmp near execend
; Opcode 44FB
O4FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 22
jmp near execend
; Opcode 44FC
O4FC:
mov cx,[esi]
add esi,byte 2
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 16
jmp near execend
; Opcodes 4580 - 4587
O580:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn709
cmp word[__dreg+8],cx
jg short ln709
sub edi,byte 10
jmp near execend
setn709:
or ah,80h
ln709:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln710
call basefunction
ln710:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4590 - 4597
O590:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn711
cmp word[__dreg+8],cx
jg short ln711
sub edi,byte 14
jmp near execend
setn711:
or ah,80h
ln711:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln712
call basefunction
ln712:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4598 - 459F
O598:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn713
cmp word[__dreg+8],cx
jg short ln713
sub edi,byte 14
jmp near execend
setn713:
or ah,80h
ln713:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln714
call basefunction
ln714:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 45A0 - 45A7
O5A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn715
cmp word[__dreg+8],cx
jg short ln715
sub edi,byte 16
jmp near execend
setn715:
or ah,80h
ln715:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln716
call basefunction
ln716:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 45A8 - 45AF
O5A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn717
cmp word[__dreg+8],cx
jg short ln717
sub edi,byte 18
jmp near execend
setn717:
or ah,80h
ln717:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln718
call basefunction
ln718:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 45B0 - 45B7
O5B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn719
cmp word[__dreg+8],cx
jg short ln719
sub edi,byte 20
jmp near execend
setn719:
or ah,80h
ln719:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln720
call basefunction
ln720:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 45B8
O5B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn721
cmp word[__dreg+8],cx
jg short ln721
sub edi,byte 18
jmp near execend
setn721:
or ah,80h
ln721:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln722
call basefunction
ln722:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 45B9
O5B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn723
cmp word[__dreg+8],cx
jg short ln723
sub edi,byte 22
jmp near execend
setn723:
or ah,80h
ln723:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln724
call basefunction
ln724:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 45BA
O5BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn725
cmp word[__dreg+8],cx
jg short ln725
sub edi,byte 18
jmp near execend
setn725:
or ah,80h
ln725:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln726
call basefunction
ln726:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 45BB
O5BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn727
cmp word[__dreg+8],cx
jg short ln727
sub edi,byte 20
jmp near execend
setn727:
or ah,80h
ln727:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln728
call basefunction
ln728:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 45BC
O5BC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+8]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+8],word 0
jl short setn729
cmp word[__dreg+8],cx
jg short ln729
sub edi,byte 14
jmp near execend
setn729:
or ah,80h
ln729:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln730
call basefunction
ln730:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 45D0 - 45D7
O5D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+8],edx
sub edi,byte 4
jmp near execend
; Opcodes 45E8 - 45EF
O5E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+8],edx
sub edi,byte 8
jmp near execend
; Opcodes 45F0 - 45F7
O5F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+8],edx
sub edi,byte 12
jmp near execend
; Opcode 45F8
O5F8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+8],edx
sub edi,byte 8
jmp near execend
; Opcode 45F9
O5F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+8],edx
sub edi,byte 12
jmp near execend
; Opcode 45FA
O5FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+8],edx
sub edi,byte 8
jmp near execend
; Opcode 45FB
O5FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+8],edx
sub edi,byte 12
jmp near execend
; Opcodes 4600 - 4607
O600:
and ebx,byte 7
xor byte[__dreg+ebx*4],byte -1
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4610 - 4617
O610:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 4618 - 461F
O618:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4620 - 4627
O620:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4628 - 462F
O628:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 4630 - 4637
O630:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 4638
O638:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 4639
O639:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xor cl,byte -1
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 4640 - 4647
O640:
and ebx,byte 7
xor word[__dreg+ebx*4],byte -1
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4650 - 4657
O650:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 4658 - 465F
O658:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4660 - 4667
O660:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4668 - 466F
O668:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 4670 - 4677
O670:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 4678
O678:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 4679
O679:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor cx,byte -1
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 4680 - 4687
O680:
and ebx,byte 7
xor dword[__dreg+ebx*4],byte -1
lahf
xor al,al
sub edi,byte 6
jmp near execend
; Opcodes 4690 - 4697
O690:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 4698 - 469F
O698:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 46A0 - 46A7
O6A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 46A8 - 46AF
O6A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 46B0 - 46B7
O6B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 46B8
O6B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 46B9
O6B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
xor ecx,byte -1
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 46C0 - 46C7
O6C0:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln731
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln732
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln731
ln732:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln731:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 12
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 46D0 - 46D7
O6D0:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln733
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln734
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln733
ln734:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln733:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 16
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 46D8 - 46DF
O6D8:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln735
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln736
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln735
ln736:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln735:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 16
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 46E0 - 46E7
O6E0:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln737
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln738
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln737
ln738:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln737:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 18
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 46E8 - 46EF
O6E8:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln739
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln740
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln739
ln740:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln739:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 46F0 - 46F7
O6F0:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln741
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln742
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln741
ln742:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln741:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 22
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcode 46F8
O6F8:
test byte[__sr+1],20h
jz privilege_violation
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln743
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln744
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln743
ln744:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln743:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcode 46F9
O6F9:
test byte[__sr+1],20h
jz privilege_violation
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln745
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln746
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln745
ln746:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln745:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 24
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcode 46FA
O6FA:
test byte[__sr+1],20h
jz privilege_violation
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln747
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln748
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln747
ln748:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln747:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcode 46FB
O6FB:
test byte[__sr+1],20h
jz privilege_violation
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln749
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln750
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln749
ln750:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln749:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 22
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcode 46FC
O6FC:
test byte[__sr+1],20h
jz privilege_violation
mov cx,[esi]
add esi,byte 2
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln751
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln752
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln751
ln752:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln751:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
sub edi,byte 16
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcodes 4780 - 4787
O780:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn753
cmp word[__dreg+12],cx
jg short ln753
sub edi,byte 10
jmp near execend
setn753:
or ah,80h
ln753:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln754
call basefunction
ln754:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4790 - 4797
O790:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn755
cmp word[__dreg+12],cx
jg short ln755
sub edi,byte 14
jmp near execend
setn755:
or ah,80h
ln755:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln756
call basefunction
ln756:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4798 - 479F
O798:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn757
cmp word[__dreg+12],cx
jg short ln757
sub edi,byte 14
jmp near execend
setn757:
or ah,80h
ln757:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln758
call basefunction
ln758:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 47A0 - 47A7
O7A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn759
cmp word[__dreg+12],cx
jg short ln759
sub edi,byte 16
jmp near execend
setn759:
or ah,80h
ln759:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln760
call basefunction
ln760:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 47A8 - 47AF
O7A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn761
cmp word[__dreg+12],cx
jg short ln761
sub edi,byte 18
jmp near execend
setn761:
or ah,80h
ln761:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln762
call basefunction
ln762:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 47B0 - 47B7
O7B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn763
cmp word[__dreg+12],cx
jg short ln763
sub edi,byte 20
jmp near execend
setn763:
or ah,80h
ln763:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln764
call basefunction
ln764:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 47B8
O7B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn765
cmp word[__dreg+12],cx
jg short ln765
sub edi,byte 18
jmp near execend
setn765:
or ah,80h
ln765:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln766
call basefunction
ln766:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 47B9
O7B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn767
cmp word[__dreg+12],cx
jg short ln767
sub edi,byte 22
jmp near execend
setn767:
or ah,80h
ln767:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln768
call basefunction
ln768:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 47BA
O7BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn769
cmp word[__dreg+12],cx
jg short ln769
sub edi,byte 18
jmp near execend
setn769:
or ah,80h
ln769:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln770
call basefunction
ln770:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 47BB
O7BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn771
cmp word[__dreg+12],cx
jg short ln771
sub edi,byte 20
jmp near execend
setn771:
or ah,80h
ln771:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln772
call basefunction
ln772:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 47BC
O7BC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+12]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+12],word 0
jl short setn773
cmp word[__dreg+12],cx
jg short ln773
sub edi,byte 14
jmp near execend
setn773:
or ah,80h
ln773:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln774
call basefunction
ln774:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 47D0 - 47D7
O7D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+12],edx
sub edi,byte 4
jmp near execend
; Opcodes 47E8 - 47EF
O7E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+12],edx
sub edi,byte 8
jmp near execend
; Opcodes 47F0 - 47F7
O7F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+12],edx
sub edi,byte 12
jmp near execend
; Opcode 47F8
O7F8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+12],edx
sub edi,byte 8
jmp near execend
; Opcode 47F9
O7F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+12],edx
sub edi,byte 12
jmp near execend
; Opcode 47FA
O7FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+12],edx
sub edi,byte 8
jmp near execend
; Opcode 47FB
O7FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+12],edx
sub edi,byte 12
jmp near execend
; Opcodes 4800 - 4807
O800:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln775
or ch,0BFh
and ah,ch
ln775:
mov bh,al
test al,al
jns short ln776
xor al,al
jmp short ln777
ln776:
test cl,cl
sets al
ln777:
mov cl,bh
xor bh,bh
mov [__dreg+ebx*4],cl
sub edi,byte 6
jmp near execend
; Opcodes 4810 - 4817
O810:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln778
or ch,0BFh
and ah,ch
ln778:
mov bh,al
test al,al
jns short ln779
xor al,al
jmp short ln780
ln779:
test cl,cl
sets al
ln780:
mov cl,bh
xor bh,bh
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 4818 - 481F
O818:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln781
or ch,0BFh
and ah,ch
ln781:
mov bh,al
test al,al
jns short ln782
xor al,al
jmp short ln783
ln782:
test cl,cl
sets al
ln783:
mov cl,bh
xor bh,bh
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4820 - 4827
O820:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln784
or ch,0BFh
and ah,ch
ln784:
mov bh,al
test al,al
jns short ln785
xor al,al
jmp short ln786
ln785:
test cl,cl
sets al
ln786:
mov cl,bh
xor bh,bh
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 4828 - 482F
O828:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln787
or ch,0BFh
and ah,ch
ln787:
mov bh,al
test al,al
jns short ln788
xor al,al
jmp short ln789
ln788:
test cl,cl
sets al
ln789:
mov cl,bh
xor bh,bh
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 4830 - 4837
O830:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln790
or ch,0BFh
and ah,ch
ln790:
mov bh,al
test al,al
jns short ln791
xor al,al
jmp short ln792
ln791:
test cl,cl
sets al
ln792:
mov cl,bh
xor bh,bh
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 4838
O838:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln793
or ch,0BFh
and ah,ch
ln793:
mov bh,al
test al,al
jns short ln794
xor al,al
jmp short ln795
ln794:
test cl,cl
sets al
ln795:
mov cl,bh
xor bh,bh
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 4839
O839:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
xor al,al
mov ch,ah
shr byte[__xflag],1
sbb al,cl
mov cl,al
das
lahf
setc [__xflag]
jnz short ln796
or ch,0BFh
and ah,ch
ln796:
mov bh,al
test al,al
jns short ln797
xor al,al
jmp short ln798
ln797:
test cl,cl
sets al
ln798:
mov cl,bh
xor bh,bh
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 4840 - 4847
O840:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
rol ecx,16
mov [__dreg+ebx*4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4850 - 4857
O850:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 12
jmp near execend
; Opcodes 4868 - 486F
O868:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 16
jmp near execend
; Opcodes 4870 - 4877
O870:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 20
jmp near execend
; Opcode 4878
O878:
movsx edx,word[esi]
add esi,byte 2
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 16
jmp near execend
; Opcode 4879
O879:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 20
jmp near execend
; Opcode 487A
O87A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 16
jmp near execend
; Opcode 487B
O87B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov ecx,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 20
jmp near execend
; Opcodes 4880 - 4887
O880:
and ebx,byte 7
movsx cx,byte[__dreg+ebx*4]
mov [__dreg+ebx*4],cx
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4890 - 4897
O890:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
xor ebx,ebx
ln799:
shr ax,1
jnc short ln800
mov ecx,[__reg+ebx]
call writememoryword
add edx,byte 2
sub edi,byte 4
ln800:
add bl,byte 4
test bl,byte 64
jz short ln799
pop eax
sub edi,byte 8
jmp near execend
; Opcodes 48A0 - 48A7
O8A0:
and ebx,byte 7
push eax
xor eax,eax
mov ax,word [esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
push ebx
mov ebx,60
ln801:
shr ax,1
jnc short ln802
mov ecx,[__reg+ebx]
sub edx,byte 2
sub edi,byte 4
call writememoryword
ln802:
sub ebx,byte 4
jns short ln801
pop ebx
pop eax
mov [__areg+ebx*4],edx
sub edi,byte 8
jmp near execend
; Opcodes 48A8 - 48AF
O8A8:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
xor ebx,ebx
ln803:
shr ax,1
jnc short ln804
mov ecx,[__reg+ebx]
call writememoryword
add edx,byte 2
sub edi,byte 4
ln804:
add bl,byte 4
test bl,byte 64
jz short ln803
pop eax
sub edi,byte 12
jmp near execend
; Opcodes 48B0 - 48B7
O8B0:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+ebx*4]
xor ebx,ebx
ln805:
shr ax,1
jnc short ln806
mov ecx,[__reg+ebx]
call writememoryword
add edx,byte 2
sub edi,byte 4
ln806:
add bl,byte 4
test bl,byte 64
jz short ln805
pop eax
sub edi,byte 14
jmp near execend
; Opcode 48B8
O8B8:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
xor ebx,ebx
ln807:
shr ax,1
jnc short ln808
mov ecx,[__reg+ebx]
call writememoryword
add edx,byte 2
sub edi,byte 4
ln808:
add bl,byte 4
test bl,byte 64
jz short ln807
pop eax
sub edi,byte 12
jmp near execend
; Opcode 48B9
O8B9:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[esi]
add esi,byte 4
rol edx,16
xor ebx,ebx
ln809:
shr ax,1
jnc short ln810
mov ecx,[__reg+ebx]
call writememoryword
add edx,byte 2
sub edi,byte 4
ln810:
add bl,byte 4
test bl,byte 64
jz short ln809
pop eax
sub edi,byte 16
jmp near execend
; Opcodes 48C0 - 48C7
O8C0:
and ebx,byte 7
movsx ecx,word[__dreg+ebx*4]
mov [__dreg+ebx*4],ecx
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 48D0 - 48D7
O8D0:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
xor ebx,ebx
ln811:
shr ax,1
jnc short ln812
mov ecx,[__reg+ebx]
call writememorydword
add edx,byte 4
sub edi,byte 8
ln812:
add bl,byte 4
test bl,byte 64
jz short ln811
pop eax
sub edi,byte 8
jmp near execend
; Opcodes 48E0 - 48E7
O8E0:
and ebx,byte 7
push eax
xor eax,eax
mov ax,word [esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
push ebx
mov ebx,60
ln813:
shr ax,1
jnc short ln814
mov ecx,[__reg+ebx]
sub edx,byte 4
sub edi,byte 8
call writememorydword
ln814:
sub ebx,byte 4
jns short ln813
pop ebx
pop eax
mov [__areg+ebx*4],edx
sub edi,byte 8
jmp near execend
; Opcodes 48E8 - 48EF
O8E8:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
xor ebx,ebx
ln815:
shr ax,1
jnc short ln816
mov ecx,[__reg+ebx]
call writememorydword
add edx,byte 4
sub edi,byte 8
ln816:
add bl,byte 4
test bl,byte 64
jz short ln815
pop eax
sub edi,byte 12
jmp near execend
; Opcodes 48F0 - 48F7
O8F0:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+ebx*4]
xor ebx,ebx
ln817:
shr ax,1
jnc short ln818
mov ecx,[__reg+ebx]
call writememorydword
add edx,byte 4
sub edi,byte 8
ln818:
add bl,byte 4
test bl,byte 64
jz short ln817
pop eax
sub edi,byte 14
jmp near execend
; Opcode 48F8
O8F8:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
xor ebx,ebx
ln819:
shr ax,1
jnc short ln820
mov ecx,[__reg+ebx]
call writememorydword
add edx,byte 4
sub edi,byte 8
ln820:
add bl,byte 4
test bl,byte 64
jz short ln819
pop eax
sub edi,byte 12
jmp near execend
; Opcode 48F9
O8F9:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[esi]
add esi,byte 4
rol edx,16
xor ebx,ebx
ln821:
shr ax,1
jnc short ln822
mov ecx,[__reg+ebx]
call writememorydword
add edx,byte 4
sub edi,byte 8
ln822:
add bl,byte 4
test bl,byte 64
jz short ln821
pop eax
sub edi,byte 16
jmp near execend
; Opcodes 4980 - 4987
O980:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn823
cmp word[__dreg+16],cx
jg short ln823
sub edi,byte 10
jmp near execend
setn823:
or ah,80h
ln823:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln824
call basefunction
ln824:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4990 - 4997
O990:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn825
cmp word[__dreg+16],cx
jg short ln825
sub edi,byte 14
jmp near execend
setn825:
or ah,80h
ln825:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln826
call basefunction
ln826:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4998 - 499F
O998:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn827
cmp word[__dreg+16],cx
jg short ln827
sub edi,byte 14
jmp near execend
setn827:
or ah,80h
ln827:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln828
call basefunction
ln828:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 49A0 - 49A7
O9A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn829
cmp word[__dreg+16],cx
jg short ln829
sub edi,byte 16
jmp near execend
setn829:
or ah,80h
ln829:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln830
call basefunction
ln830:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 49A8 - 49AF
O9A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn831
cmp word[__dreg+16],cx
jg short ln831
sub edi,byte 18
jmp near execend
setn831:
or ah,80h
ln831:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln832
call basefunction
ln832:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 49B0 - 49B7
O9B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn833
cmp word[__dreg+16],cx
jg short ln833
sub edi,byte 20
jmp near execend
setn833:
or ah,80h
ln833:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln834
call basefunction
ln834:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 49B8
O9B8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn835
cmp word[__dreg+16],cx
jg short ln835
sub edi,byte 18
jmp near execend
setn835:
or ah,80h
ln835:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln836
call basefunction
ln836:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 49B9
O9B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn837
cmp word[__dreg+16],cx
jg short ln837
sub edi,byte 22
jmp near execend
setn837:
or ah,80h
ln837:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln838
call basefunction
ln838:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 49BA
O9BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn839
cmp word[__dreg+16],cx
jg short ln839
sub edi,byte 18
jmp near execend
setn839:
or ah,80h
ln839:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln840
call basefunction
ln840:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 49BB
O9BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn841
cmp word[__dreg+16],cx
jg short ln841
sub edi,byte 20
jmp near execend
setn841:
or ah,80h
ln841:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln842
call basefunction
ln842:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 49BC
O9BC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+16]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+16],word 0
jl short setn843
cmp word[__dreg+16],cx
jg short ln843
sub edi,byte 14
jmp near execend
setn843:
or ah,80h
ln843:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln844
call basefunction
ln844:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 49D0 - 49D7
O9D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+16],edx
sub edi,byte 4
jmp near execend
; Opcodes 49E8 - 49EF
O9E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+16],edx
sub edi,byte 8
jmp near execend
; Opcodes 49F0 - 49F7
O9F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+16],edx
sub edi,byte 12
jmp near execend
; Opcode 49F8
O9F8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+16],edx
sub edi,byte 8
jmp near execend
; Opcode 49F9
O9F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+16],edx
sub edi,byte 12
jmp near execend
; Opcode 49FA
O9FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+16],edx
sub edi,byte 8
jmp near execend
; Opcode 49FB
O9FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+16],edx
sub edi,byte 12
jmp near execend
; Opcodes 4A00 - 4A07
OA00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4A10 - 4A17
OA10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 4A18 - 4A1F
OA18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 4A20 - 4A27
OA20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
test cl,cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 4A28 - 4A2F
OA28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 4A30 - 4A37
OA30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 4A38
OA38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 4A39
OA39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test cl,cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 4A40 - 4A47
OA40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4A50 - 4A57
OA50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 4A58 - 4A5F
OA58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 4A60 - 4A67
OA60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 4A68 - 4A6F
OA68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 4A70 - 4A77
OA70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 4A78
OA78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 4A79
OA79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 4A80 - 4A87
OA80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test ecx,ecx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 4A90 - 4A97
OA90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 4A98 - 4A9F
OA98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 4AA0 - 4AA7
OAA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
test ecx,ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 4AA8 - 4AAF
OAA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 4AB0 - 4AB7
OAB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 4AB8
OAB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 4AB9
OAB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
test ecx,ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcodes 4AC0 - 4AC7
OAC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cl,cl
lahf
xor al,al
or cl,80h
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 4AD0 - 4AD7
OAD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcodes 4AD8 - 4ADF
OAD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 18
jmp near execend
; Opcodes 4AE0 - 4AE7
OAE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 4AE8 - 4AEF
OAE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcodes 4AF0 - 4AF7
OAF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
sub edi,byte 24
jmp near execend
; Opcode 4AF8
OAF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
sub edi,byte 22
jmp near execend
; Opcode 4AF9
OAF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test cl,cl
lahf
xor al,al
or cl,80h
call writememorybyte
sub edi,byte 26
jmp near execend
; Opcode 4AFA
OAFA:
r_illegal:
sub esi,byte 2
mov edx,10h
call group_1_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln845
call basefunction
ln845:
add esi,ebp
sub edi,byte 34
jmp near execend
; Opcode 4AFB
OAFB:
sub esi,byte 2
mov edx,10h
call group_1_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln846
call basefunction
ln846:
add esi,ebp
sub edi,byte 34
jmp near execend
; Opcode 4AFC
OAFC:
sub esi,byte 2
mov edx,10h
call group_1_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln847
call basefunction
ln847:
add esi,ebp
sub edi,byte 34
jmp near execend
; Opcodes 4B80 - 4B87
OB80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn848
cmp word[__dreg+20],cx
jg short ln848
sub edi,byte 10
jmp near execend
setn848:
or ah,80h
ln848:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln849
call basefunction
ln849:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4B90 - 4B97
OB90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn850
cmp word[__dreg+20],cx
jg short ln850
sub edi,byte 14
jmp near execend
setn850:
or ah,80h
ln850:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln851
call basefunction
ln851:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4B98 - 4B9F
OB98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn852
cmp word[__dreg+20],cx
jg short ln852
sub edi,byte 14
jmp near execend
setn852:
or ah,80h
ln852:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln853
call basefunction
ln853:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4BA0 - 4BA7
OBA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn854
cmp word[__dreg+20],cx
jg short ln854
sub edi,byte 16
jmp near execend
setn854:
or ah,80h
ln854:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln855
call basefunction
ln855:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 4BA8 - 4BAF
OBA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn856
cmp word[__dreg+20],cx
jg short ln856
sub edi,byte 18
jmp near execend
setn856:
or ah,80h
ln856:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln857
call basefunction
ln857:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 4BB0 - 4BB7
OBB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn858
cmp word[__dreg+20],cx
jg short ln858
sub edi,byte 20
jmp near execend
setn858:
or ah,80h
ln858:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln859
call basefunction
ln859:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 4BB8
OBB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn860
cmp word[__dreg+20],cx
jg short ln860
sub edi,byte 18
jmp near execend
setn860:
or ah,80h
ln860:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln861
call basefunction
ln861:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 4BB9
OBB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn862
cmp word[__dreg+20],cx
jg short ln862
sub edi,byte 22
jmp near execend
setn862:
or ah,80h
ln862:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln863
call basefunction
ln863:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 4BBA
OBBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn864
cmp word[__dreg+20],cx
jg short ln864
sub edi,byte 18
jmp near execend
setn864:
or ah,80h
ln864:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln865
call basefunction
ln865:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 4BBB
OBBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn866
cmp word[__dreg+20],cx
jg short ln866
sub edi,byte 20
jmp near execend
setn866:
or ah,80h
ln866:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln867
call basefunction
ln867:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 4BBC
OBBC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+20]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+20],word 0
jl short setn868
cmp word[__dreg+20],cx
jg short ln868
sub edi,byte 14
jmp near execend
setn868:
or ah,80h
ln868:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln869
call basefunction
ln869:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4BD0 - 4BD7
OBD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+20],edx
sub edi,byte 4
jmp near execend
; Opcodes 4BE8 - 4BEF
OBE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+20],edx
sub edi,byte 8
jmp near execend
; Opcodes 4BF0 - 4BF7
OBF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+20],edx
sub edi,byte 12
jmp near execend
; Opcode 4BF8
OBF8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+20],edx
sub edi,byte 8
jmp near execend
; Opcode 4BF9
OBF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+20],edx
sub edi,byte 12
jmp near execend
; Opcode 4BFA
OBFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+20],edx
sub edi,byte 8
jmp near execend
; Opcode 4BFB
OBFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+20],edx
sub edi,byte 12
jmp near execend
; Opcodes 4C90 - 4C97
OC90:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
xor ebx,ebx
ln870:
shr ax,1
jnc short ln871
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln871:
add bl,byte 4
test bl,byte 64
jz short ln870
pop eax
sub edi,byte 12
jmp near execend
; Opcodes 4C98 - 4C9F
OC98:
and ebx,byte 7
push eax
xor eax,eax
mov ax,word [esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
push ebx
xor ebx,ebx
ln872:
shr ax,1
jnc short ln873
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln873:
add ebx,byte 4
test bl,byte 64
jz short ln872
pop ebx
pop eax
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4CA8 - 4CAF
OCA8:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
xor ebx,ebx
ln874:
shr ax,1
jnc short ln875
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln875:
add bl,byte 4
test bl,byte 64
jz short ln874
pop eax
sub edi,byte 16
jmp near execend
; Opcodes 4CB0 - 4CB7
OCB0:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+ebx*4]
xor ebx,ebx
ln876:
shr ax,1
jnc short ln877
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln877:
add bl,byte 4
test bl,byte 64
jz short ln876
pop eax
sub edi,byte 18
jmp near execend
; Opcode 4CB8
OCB8:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
xor ebx,ebx
ln878:
shr ax,1
jnc short ln879
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln879:
add bl,byte 4
test bl,byte 64
jz short ln878
pop eax
sub edi,byte 16
jmp near execend
; Opcode 4CB9
OCB9:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[esi]
add esi,byte 4
rol edx,16
xor ebx,ebx
ln880:
shr ax,1
jnc short ln881
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln881:
add bl,byte 4
test bl,byte 64
jz short ln880
pop eax
sub edi,byte 20
jmp near execend
; Opcode 4CBA
OCBA:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
xor ebx,ebx
ln882:
shr ax,1
jnc short ln883
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln883:
add bl,byte 4
test bl,byte 64
jz short ln882
pop eax
sub edi,byte 16
jmp near execend
; Opcode 4CBB
OCBB:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
xor ebx,ebx
ln884:
shr ax,1
jnc short ln885
call readmemoryword
movsx ecx,cx
mov [__reg+ebx],ecx
add edx,byte 2
sub edi,byte 4
ln885:
add bl,byte 4
test bl,byte 64
jz short ln884
pop eax
sub edi,byte 18
jmp near execend
; Opcodes 4CD0 - 4CD7
OCD0:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
xor ebx,ebx
ln886:
shr ax,1
jnc short ln887
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln887:
add bl,byte 4
test bl,byte 64
jz short ln886
pop eax
sub edi,byte 12
jmp near execend
; Opcodes 4CD8 - 4CDF
OCD8:
and ebx,byte 7
push eax
xor eax,eax
mov ax,word [esi]
add esi,byte 2
mov edx,[__areg+ebx*4]
push ebx
xor ebx,ebx
ln888:
shr ax,1
jnc short ln889
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln889:
add ebx,byte 4
test bl,byte 64
jz short ln888
pop ebx
pop eax
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 4CE8 - 4CEF
OCE8:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
xor ebx,ebx
ln890:
shr ax,1
jnc short ln891
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln891:
add bl,byte 4
test bl,byte 64
jz short ln890
pop eax
sub edi,byte 16
jmp near execend
; Opcodes 4CF0 - 4CF7
OCF0:
push eax
and ebx,byte 7
xor eax,eax
mov ax,word[esi]
add esi,byte 2
call decode_ext
add edx,[__areg+ebx*4]
xor ebx,ebx
ln892:
shr ax,1
jnc short ln893
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln893:
add bl,byte 4
test bl,byte 64
jz short ln892
pop eax
sub edi,byte 18
jmp near execend
; Opcode 4CF8
OCF8:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add esi,byte 2
xor ebx,ebx
ln894:
shr ax,1
jnc short ln895
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln895:
add bl,byte 4
test bl,byte 64
jz short ln894
pop eax
sub edi,byte 16
jmp near execend
; Opcode 4CF9
OCF9:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
mov edx,[esi]
add esi,byte 4
rol edx,16
xor ebx,ebx
ln896:
shr ax,1
jnc short ln897
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln897:
add bl,byte 4
test bl,byte 64
jz short ln896
pop eax
sub edi,byte 20
jmp near execend
; Opcode 4CFA
OCFA:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
xor ebx,ebx
ln898:
shr ax,1
jnc short ln899
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln899:
add bl,byte 4
test bl,byte 64
jz short ln898
pop eax
sub edi,byte 16
jmp near execend
; Opcode 4CFB
OCFB:
push eax
xor eax,eax
mov ax,word[esi]
add esi,byte 2
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
xor ebx,ebx
ln900:
shr ax,1
jnc short ln901
call readmemorydword
mov [__reg+ebx],ecx
add edx,byte 4
sub edi,byte 8
ln901:
add bl,byte 4
test bl,byte 64
jz short ln900
pop eax
sub edi,byte 18
jmp near execend
; Opcodes 4D80 - 4D87
OD80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn902
cmp word[__dreg+24],cx
jg short ln902
sub edi,byte 10
jmp near execend
setn902:
or ah,80h
ln902:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln903
call basefunction
ln903:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4D90 - 4D97
OD90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn904
cmp word[__dreg+24],cx
jg short ln904
sub edi,byte 14
jmp near execend
setn904:
or ah,80h
ln904:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln905
call basefunction
ln905:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4D98 - 4D9F
OD98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn906
cmp word[__dreg+24],cx
jg short ln906
sub edi,byte 14
jmp near execend
setn906:
or ah,80h
ln906:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln907
call basefunction
ln907:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4DA0 - 4DA7
ODA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn908
cmp word[__dreg+24],cx
jg short ln908
sub edi,byte 16
jmp near execend
setn908:
or ah,80h
ln908:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln909
call basefunction
ln909:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 4DA8 - 4DAF
ODA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn910
cmp word[__dreg+24],cx
jg short ln910
sub edi,byte 18
jmp near execend
setn910:
or ah,80h
ln910:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln911
call basefunction
ln911:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 4DB0 - 4DB7
ODB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn912
cmp word[__dreg+24],cx
jg short ln912
sub edi,byte 20
jmp near execend
setn912:
or ah,80h
ln912:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln913
call basefunction
ln913:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 4DB8
ODB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn914
cmp word[__dreg+24],cx
jg short ln914
sub edi,byte 18
jmp near execend
setn914:
or ah,80h
ln914:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln915
call basefunction
ln915:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 4DB9
ODB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn916
cmp word[__dreg+24],cx
jg short ln916
sub edi,byte 22
jmp near execend
setn916:
or ah,80h
ln916:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln917
call basefunction
ln917:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 4DBA
ODBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn918
cmp word[__dreg+24],cx
jg short ln918
sub edi,byte 18
jmp near execend
setn918:
or ah,80h
ln918:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln919
call basefunction
ln919:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 4DBB
ODBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn920
cmp word[__dreg+24],cx
jg short ln920
sub edi,byte 20
jmp near execend
setn920:
or ah,80h
ln920:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln921
call basefunction
ln921:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 4DBC
ODBC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+24]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+24],word 0
jl short setn922
cmp word[__dreg+24],cx
jg short ln922
sub edi,byte 14
jmp near execend
setn922:
or ah,80h
ln922:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln923
call basefunction
ln923:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4DD0 - 4DD7
ODD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+24],edx
sub edi,byte 4
jmp near execend
; Opcodes 4DE8 - 4DEF
ODE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+24],edx
sub edi,byte 8
jmp near execend
; Opcodes 4DF0 - 4DF7
ODF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+24],edx
sub edi,byte 12
jmp near execend
; Opcode 4DF8
ODF8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+24],edx
sub edi,byte 8
jmp near execend
; Opcode 4DF9
ODF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+24],edx
sub edi,byte 12
jmp near execend
; Opcode 4DFA
ODFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+24],edx
sub edi,byte 8
jmp near execend
; Opcode 4DFB
ODFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+24],edx
sub edi,byte 12
jmp near execend
; Opcodes 4E40 - 4E4F
OE40:
and ebx,byte 0Fh
lea edx,[80h+ebx*4]
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln924
call basefunction
ln924:
add esi,ebp
sub edi,byte 34
jmp near execend
; Opcodes 4E50 - 4E57
OE50:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
mov ecx,[__a7]
mov [__areg+ebx*4],ecx
movsx edx,word[esi]
add ecx,edx
mov [__a7],ecx
add esi,byte 2
sub edi,byte 16
jmp near execend
; Opcodes 4E58 - 4E5F
OE58:
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__a7],ecx
mov edx,[__areg+28]
call readmemorydword
add edx,byte 4
mov [__areg+28],edx
mov [__areg+ebx*4],ecx
sub edi,byte 12
jmp near execend
; Opcodes 4E60 - 4E67
OE60:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
mov ecx,[__areg+ebx*4]
mov [__asp],ecx
sub edi,byte 4
jmp near execend
; Opcodes 4E68 - 4E6F
OE68:
test byte[__sr+1],20h
jz privilege_violation
and ebx,byte 7
mov ecx,[__asp]
mov [__areg+ebx*4],ecx
sub edi,byte 4
jmp near execend
; Opcode 4E70
OE70:
test byte[__sr+1],20h
jz privilege_violation
mov ecx,[__resethandler]
test ecx,ecx
jz short .r_done
mov [__io_cycle_counter],edi
mov [__io_fetchbase],ebp
mov [__io_fetchbased_pc],esi
push ebx
push eax
call ecx
pop eax
pop ebx
mov edi,[__io_cycle_counter]
mov ebp,[__io_fetchbase]
mov esi,[__io_fetchbased_pc]
.r_done:
sub edi,132
jmp near execend
; Opcode 4E71
OE71:
sub edi,byte 4
jmp near execend
; Opcode 4E72
OE72:
test byte[__sr+1],20h
jz privilege_violation
mov cx,[esi]
add esi,byte 2
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln925
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln926
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln925
ln926:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln925:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
or byte[__execinfo],80h
sub edi,byte 4
xor ecx,ecx
jmp near execexit
; Opcode 4E73
OE73:
test byte[__sr+1],20h
jz privilege_violation
mov edx,[__a7]
call readmemoryword
add edx,byte 2
push ecx
mov cl,[__sr+1]
and cx,2020h
xor ch,cl
jz short ln927
mov ecx,[__a7]
xchg ecx,[__asp]
mov [__a7],ecx
test byte[esp+1],20h
jz short ln928
mov [__fetch_idx],dword __sfmhtbl
mov [__readbyte_idx],dword __srbmhtbl
mov [__readword_idx],dword __srwmhtbl
mov [__writebyte_idx],dword __swbmhtbl
mov [__writeword_idx],dword __swwmhtbl
jmp short ln927
ln928:
mov [__fetch_idx],dword __ufmhtbl
mov [__readbyte_idx],dword __urbmhtbl
mov [__readword_idx],dword __urwmhtbl
mov [__writebyte_idx],dword __uwbmhtbl
mov [__writeword_idx],dword __uwwmhtbl
ln927:
pop ecx
mov [__sr+1],ch
and byte[__sr+1],0A7h
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
test ch,20h
setz cl
movzx ecx,cl
lea ecx,[__a7+ecx*4]
add dword[ecx],byte 6
call readmemorydword
and byte[__execinfo],0E5h
and ecx,16777215
mov esi,ecx
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln929
call basefunction
ln929:
add esi,ebp
sub edi,byte 20
test edi,edi
js near execend
test byte[__sr+1],80h
jnz near trace_excep
jmp near execend
; Opcode 4E75
OE75:
mov edx,[__areg+28]
call readmemorydword
add edx,byte 4
mov [__areg+28],edx
and ecx,16777215
mov esi,ecx
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln930
call basefunction
ln930:
add esi,ebp
sub edi,byte 16
jmp near execend
; Opcode 4E76
OE76:
test al,1
jnz short ln931
sub edi,byte 4
jmp near execend
ln931:
mov edx,1Ch
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln932
call basefunction
ln932:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcode 4E77
OE77:
mov edx,[__areg+28]
call readmemoryword
add edx,byte 2
mov [__areg+28],edx
mov al,cl
shl ax,6
shl ah,5
sets [__xflag]
shr al,7
adc ah,ah
mov edx,[__areg+28]
call readmemorydword
add edx,byte 4
mov [__areg+28],edx
and ecx,16777215
mov esi,ecx
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln933
call basefunction
ln933:
add esi,ebp
sub edi,byte 20
jmp near execend
; Opcodes 4E90 - 4E97
OE90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln934
call basefunction
ln934:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 16
jmp near execend
; Opcodes 4EA8 - 4EAF
OEA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln935
call basefunction
ln935:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 18
jmp near execend
; Opcodes 4EB0 - 4EB7
OEB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln936
call basefunction
ln936:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 22
jmp near execend
; Opcode 4EB8
OEB8:
movsx edx,word[esi]
add esi,byte 2
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln937
call basefunction
ln937:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 18
jmp near execend
; Opcode 4EB9
OEB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln938
call basefunction
ln938:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 20
jmp near execend
; Opcode 4EBA
OEBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln939
call basefunction
ln939:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 18
jmp near execend
; Opcode 4EBB
OEBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov ecx,esi
sub ecx,ebp
push ecx
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln940
call basefunction
ln940:
add esi,ebp
pop ecx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 22
jmp near execend
; Opcodes 4ED0 - 4ED7
OED0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln941
call basefunction
ln941:
add esi,ebp
sub edi,byte 8
jmp near execend
; Opcodes 4EE8 - 4EEF
OEE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln942
call basefunction
ln942:
add esi,ebp
sub edi,byte 10
jmp near execend
; Opcodes 4EF0 - 4EF7
OEF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln943
call basefunction
ln943:
add esi,ebp
sub edi,byte 14
jmp near execend
; Opcode 4EF8
OEF8:
movsx edx,word[esi]
add esi,byte 2
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln944
call basefunction
ln944:
add esi,ebp
sub edi,byte 10
jmp near execend
; Opcode 4EF9
OEF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln945
call basefunction
ln945:
add esi,ebp
sub edi,byte 12
jmp near execend
; Opcode 4EFA
OEFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln946
call basefunction
ln946:
add esi,ebp
sub edi,byte 10
jmp near execend
; Opcode 4EFB
OEFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
and edx,16777215
mov esi,edx
shr edx,12
cmp dx,word[__fetch_bank]
je short ln947
call basefunction
ln947:
add esi,ebp
sub edi,byte 14
jmp near execend
; Opcodes 4F80 - 4F87
OF80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn948
cmp word[__dreg+28],cx
jg short ln948
sub edi,byte 10
jmp near execend
setn948:
or ah,80h
ln948:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln949
call basefunction
ln949:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcodes 4F90 - 4F97
OF90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn950
cmp word[__dreg+28],cx
jg short ln950
sub edi,byte 14
jmp near execend
setn950:
or ah,80h
ln950:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln951
call basefunction
ln951:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4F98 - 4F9F
OF98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn952
cmp word[__dreg+28],cx
jg short ln952
sub edi,byte 14
jmp near execend
setn952:
or ah,80h
ln952:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln953
call basefunction
ln953:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4FA0 - 4FA7
OFA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn954
cmp word[__dreg+28],cx
jg short ln954
sub edi,byte 16
jmp near execend
setn954:
or ah,80h
ln954:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln955
call basefunction
ln955:
add esi,ebp
sub edi,byte 56
jmp near execend
; Opcodes 4FA8 - 4FAF
OFA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn956
cmp word[__dreg+28],cx
jg short ln956
sub edi,byte 18
jmp near execend
setn956:
or ah,80h
ln956:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln957
call basefunction
ln957:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcodes 4FB0 - 4FB7
OFB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn958
cmp word[__dreg+28],cx
jg short ln958
sub edi,byte 20
jmp near execend
setn958:
or ah,80h
ln958:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln959
call basefunction
ln959:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 4FB8
OFB8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn960
cmp word[__dreg+28],cx
jg short ln960
sub edi,byte 18
jmp near execend
setn960:
or ah,80h
ln960:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln961
call basefunction
ln961:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 4FB9
OFB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn962
cmp word[__dreg+28],cx
jg short ln962
sub edi,byte 22
jmp near execend
setn962:
or ah,80h
ln962:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln963
call basefunction
ln963:
add esi,ebp
sub edi,byte 62
jmp near execend
; Opcode 4FBA
OFBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn964
cmp word[__dreg+28],cx
jg short ln964
sub edi,byte 18
jmp near execend
setn964:
or ah,80h
ln964:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln965
call basefunction
ln965:
add esi,ebp
sub edi,byte 58
jmp near execend
; Opcode 4FBB
OFBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn966
cmp word[__dreg+28],cx
jg short ln966
sub edi,byte 20
jmp near execend
setn966:
or ah,80h
ln966:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln967
call basefunction
ln967:
add esi,ebp
sub edi,byte 60
jmp near execend
; Opcode 4FBC
OFBC:
mov cx,[esi]
add esi,byte 2
xor al,al
mov bx,word[__dreg+28]
test bx,bx
setz ah
shr ah,6
cmp word[__dreg+28],word 0
jl short setn968
cmp word[__dreg+28],cx
jg short ln968
sub edi,byte 14
jmp near execend
setn968:
or ah,80h
ln968:
mov edx,18h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln969
call basefunction
ln969:
add esi,ebp
sub edi,byte 54
jmp near execend
; Opcodes 4FD0 - 4FD7
OFD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
mov [__areg+28],edx
sub edi,byte 4
jmp near execend
; Opcodes 4FE8 - 4FEF
OFE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
mov [__areg+28],edx
sub edi,byte 8
jmp near execend
; Opcodes 4FF0 - 4FF7
OFF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
mov [__areg+28],edx
sub edi,byte 12
jmp near execend
; Opcode 4FF8
OFF8:
movsx edx,word[esi]
add esi,byte 2
mov [__areg+28],edx
sub edi,byte 8
jmp near execend
; Opcode 4FF9
OFF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
mov [__areg+28],edx
sub edi,byte 12
jmp near execend
; Opcode 4FFA
OFFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
mov [__areg+28],edx
sub edi,byte 8
jmp near execend
; Opcode 4FFB
OFFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
mov [__areg+28],edx
sub edi,byte 12
jmp near execend
; Opcodes 5000 - 5007
P000:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5008 - 500F
P008:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5010 - 5017
P010:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5018 - 501F
P018:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5020 - 5027
P020:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5028 - 502F
P028:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5030 - 5037
P030:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5038
P038:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5039
P039:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5040 - 5047
P040:
and ebx,byte 7
add word[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5048 - 504F
P048:
and ebx,byte 7
add dword[__areg+ebx*4],byte 8
sub edi,byte 4
jmp near execend
; Opcodes 5050 - 5057
P050:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5058 - 505F
P058:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5060 - 5067
P060:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5068 - 506F
P068:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5070 - 5077
P070:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5078
P078:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5079
P079:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5080 - 5087
P080:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5088 - 508F
P088:
and ebx,byte 7
add dword[__areg+ebx*4],byte 8
sub edi,byte 8
jmp near execend
; Opcodes 5090 - 5097
P090:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5098 - 509F
P098:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 50A0 - 50A7
P0A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 50A8 - 50AF
P0A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 50B0 - 50B7
P0B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 50B8
P0B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 50B9
P0B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 50C0 - 50C7
P0C0:
and ebx,byte 7
mov cl,255
mov [__dreg+ebx*4],cl
sub edi,byte 6
jmp near execend
; Opcodes 50C8 - 50CF
P0C8:
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 50D0 - 50D7
P0D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov cl,255
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 50D8 - 50DF
P0D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov cl,255
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 50E0 - 50E7
P0E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov cl,255
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 50E8 - 50EF
P0E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov cl,255
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 50F0 - 50F7
P0F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov cl,255
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 50F8
P0F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov cl,255
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 50F9
P0F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov cl,255
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5100 - 5107
P100:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5108 - 510F
P108:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5110 - 5117
P110:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5118 - 511F
P118:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5120 - 5127
P120:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5128 - 512F
P128:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5130 - 5137
P130:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5138
P138:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5139
P139:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 8
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5140 - 5147
P140:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5148 - 514F
P148:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 8
sub edi,byte 8
jmp near execend
; Opcodes 5150 - 5157
P150:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5158 - 515F
P158:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5160 - 5167
P160:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5168 - 516F
P168:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5170 - 5177
P170:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5178
P178:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5179
P179:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 8
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5180 - 5187
P180:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 8
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5188 - 518F
P188:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 8
sub edi,byte 8
jmp near execend
; Opcodes 5190 - 5197
P190:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5198 - 519F
P198:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 51A0 - 51A7
P1A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 51A8 - 51AF
P1A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 51B0 - 51B7
P1B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 51B8
P1B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 51B9
P1B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 8
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 51C0 - 51C7
P1C0:
and ebx,byte 7
mov cl,0
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 51C8 - 51CF
P1C8:
r_dbra:
and ebx,byte 7
sub word[__dreg+ebx*4],1
jnc near r_bra_w
add esi,byte 2
sub edi,byte 14
jmp near execend
; Opcodes 51D0 - 51D7
P1D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov cl,0
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 51D8 - 51DF
P1D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
mov cl,0
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 51E0 - 51E7
P1E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov cl,0
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 51E8 - 51EF
P1E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
mov cl,0
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 51F0 - 51F7
P1F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
mov cl,0
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 51F8
P1F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
mov cl,0
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 51F9
P1F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
mov cl,0
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5200 - 5207
P200:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5208 - 520F
P208:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5210 - 5217
P210:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5218 - 521F
P218:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5220 - 5227
P220:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5228 - 522F
P228:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5230 - 5237
P230:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5238
P238:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5239
P239:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5240 - 5247
P240:
and ebx,byte 7
add word[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5248 - 524F
P248:
and ebx,byte 7
add dword[__areg+ebx*4],byte 1
sub edi,byte 4
jmp near execend
; Opcodes 5250 - 5257
P250:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5258 - 525F
P258:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5260 - 5267
P260:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5268 - 526F
P268:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5270 - 5277
P270:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5278
P278:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5279
P279:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5280 - 5287
P280:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5288 - 528F
P288:
and ebx,byte 7
add dword[__areg+ebx*4],byte 1
sub edi,byte 8
jmp near execend
; Opcodes 5290 - 5297
P290:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5298 - 529F
P298:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 52A0 - 52A7
P2A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 52A8 - 52AF
P2A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 52B0 - 52B7
P2B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 52B8
P2B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 52B9
P2B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 52C0 - 52C7
P2C0:
and ebx,byte 7
xor ecx,ecx
test ah,41h
setz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 52C8 - 52CF
P2C8:
test ah,41h
jnz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 52D0 - 52D7
P2D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 52D8 - 52DF
P2D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 52E0 - 52E7
P2E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 52E8 - 52EF
P2E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 52F0 - 52F7
P2F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 52F8
P2F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 52F9
P2F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,41h
setz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5300 - 5307
P300:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5308 - 530F
P308:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5310 - 5317
P310:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5318 - 531F
P318:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5320 - 5327
P320:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5328 - 532F
P328:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5330 - 5337
P330:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5338
P338:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5339
P339:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 1
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5340 - 5347
P340:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5348 - 534F
P348:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 1
sub edi,byte 8
jmp near execend
; Opcodes 5350 - 5357
P350:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5358 - 535F
P358:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5360 - 5367
P360:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5368 - 536F
P368:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5370 - 5377
P370:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5378
P378:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5379
P379:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 1
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5380 - 5387
P380:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 1
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5388 - 538F
P388:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 1
sub edi,byte 8
jmp near execend
; Opcodes 5390 - 5397
P390:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5398 - 539F
P398:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 53A0 - 53A7
P3A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 53A8 - 53AF
P3A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 53B0 - 53B7
P3B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 53B8
P3B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 53B9
P3B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 1
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 53C0 - 53C7
P3C0:
and ebx,byte 7
xor ecx,ecx
test ah,41h
setnz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 53C8 - 53CF
P3C8:
test ah,41h
jz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 53D0 - 53D7
P3D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 53D8 - 53DF
P3D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 53E0 - 53E7
P3E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 53E8 - 53EF
P3E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 53F0 - 53F7
P3F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 53F8
P3F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 53F9
P3F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,41h
setnz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5400 - 5407
P400:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5408 - 540F
P408:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5410 - 5417
P410:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5418 - 541F
P418:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5420 - 5427
P420:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5428 - 542F
P428:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5430 - 5437
P430:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5438
P438:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5439
P439:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5440 - 5447
P440:
and ebx,byte 7
add word[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5448 - 544F
P448:
and ebx,byte 7
add dword[__areg+ebx*4],byte 2
sub edi,byte 4
jmp near execend
; Opcodes 5450 - 5457
P450:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5458 - 545F
P458:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5460 - 5467
P460:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5468 - 546F
P468:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5470 - 5477
P470:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5478
P478:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5479
P479:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5480 - 5487
P480:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5488 - 548F
P488:
and ebx,byte 7
add dword[__areg+ebx*4],byte 2
sub edi,byte 8
jmp near execend
; Opcodes 5490 - 5497
P490:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5498 - 549F
P498:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 54A0 - 54A7
P4A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 54A8 - 54AF
P4A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 54B0 - 54B7
P4B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 54B8
P4B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 54B9
P4B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 54C0 - 54C7
P4C0:
and ebx,byte 7
xor ecx,ecx
test ah,1
setz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 54C8 - 54CF
P4C8:
test ah,1
jnz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 54D0 - 54D7
P4D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 54D8 - 54DF
P4D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 54E0 - 54E7
P4E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 54E8 - 54EF
P4E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 54F0 - 54F7
P4F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 54F8
P4F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 54F9
P4F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,1
setz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5500 - 5507
P500:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5508 - 550F
P508:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5510 - 5517
P510:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5518 - 551F
P518:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5520 - 5527
P520:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5528 - 552F
P528:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5530 - 5537
P530:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5538
P538:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5539
P539:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 2
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5540 - 5547
P540:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5548 - 554F
P548:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 2
sub edi,byte 8
jmp near execend
; Opcodes 5550 - 5557
P550:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5558 - 555F
P558:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5560 - 5567
P560:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5568 - 556F
P568:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5570 - 5577
P570:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5578
P578:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5579
P579:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 2
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5580 - 5587
P580:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 2
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5588 - 558F
P588:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 2
sub edi,byte 8
jmp near execend
; Opcodes 5590 - 5597
P590:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5598 - 559F
P598:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 55A0 - 55A7
P5A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 55A8 - 55AF
P5A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 55B0 - 55B7
P5B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 55B8
P5B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 55B9
P5B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 2
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 55C0 - 55C7
P5C0:
and ebx,byte 7
xor ecx,ecx
test ah,1
setnz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 55C8 - 55CF
P5C8:
test ah,1
jz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 55D0 - 55D7
P5D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 55D8 - 55DF
P5D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 55E0 - 55E7
P5E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 55E8 - 55EF
P5E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 55F0 - 55F7
P5F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 55F8
P5F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 55F9
P5F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5600 - 5607
P600:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5608 - 560F
P608:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5610 - 5617
P610:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5618 - 561F
P618:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5620 - 5627
P620:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5628 - 562F
P628:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5630 - 5637
P630:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5638
P638:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5639
P639:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5640 - 5647
P640:
and ebx,byte 7
add word[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5648 - 564F
P648:
and ebx,byte 7
add dword[__areg+ebx*4],byte 3
sub edi,byte 4
jmp near execend
; Opcodes 5650 - 5657
P650:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5658 - 565F
P658:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5660 - 5667
P660:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5668 - 566F
P668:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5670 - 5677
P670:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5678
P678:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5679
P679:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5680 - 5687
P680:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5688 - 568F
P688:
and ebx,byte 7
add dword[__areg+ebx*4],byte 3
sub edi,byte 8
jmp near execend
; Opcodes 5690 - 5697
P690:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5698 - 569F
P698:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 56A0 - 56A7
P6A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 56A8 - 56AF
P6A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 56B0 - 56B7
P6B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 56B8
P6B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 56B9
P6B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 56C0 - 56C7
P6C0:
and ebx,byte 7
xor ecx,ecx
test ah,40h
setz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 56C8 - 56CF
P6C8:
test ah,40h
jnz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 56D0 - 56D7
P6D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 56D8 - 56DF
P6D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 56E0 - 56E7
P6E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 56E8 - 56EF
P6E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 56F0 - 56F7
P6F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 56F8
P6F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 56F9
P6F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,40h
setz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5700 - 5707
P700:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5708 - 570F
P708:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5710 - 5717
P710:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5718 - 571F
P718:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5720 - 5727
P720:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5728 - 572F
P728:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5730 - 5737
P730:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5738
P738:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5739
P739:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 3
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5740 - 5747
P740:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5748 - 574F
P748:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 3
sub edi,byte 8
jmp near execend
; Opcodes 5750 - 5757
P750:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5758 - 575F
P758:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5760 - 5767
P760:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5768 - 576F
P768:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5770 - 5777
P770:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5778
P778:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5779
P779:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 3
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5780 - 5787
P780:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 3
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5788 - 578F
P788:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 3
sub edi,byte 8
jmp near execend
; Opcodes 5790 - 5797
P790:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5798 - 579F
P798:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 57A0 - 57A7
P7A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 57A8 - 57AF
P7A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 57B0 - 57B7
P7B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 57B8
P7B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 57B9
P7B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 3
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 57C0 - 57C7
P7C0:
and ebx,byte 7
xor ecx,ecx
test ah,40h
setnz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 57C8 - 57CF
P7C8:
test ah,40h
jz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 57D0 - 57D7
P7D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 57D8 - 57DF
P7D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 57E0 - 57E7
P7E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 57E8 - 57EF
P7E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 57F0 - 57F7
P7F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 57F8
P7F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 57F9
P7F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,40h
setnz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5800 - 5807
P800:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5808 - 580F
P808:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5810 - 5817
P810:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5818 - 581F
P818:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5820 - 5827
P820:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5828 - 582F
P828:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5830 - 5837
P830:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5838
P838:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5839
P839:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5840 - 5847
P840:
and ebx,byte 7
add word[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5848 - 584F
P848:
and ebx,byte 7
add dword[__areg+ebx*4],byte 4
sub edi,byte 4
jmp near execend
; Opcodes 5850 - 5857
P850:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5858 - 585F
P858:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5860 - 5867
P860:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5868 - 586F
P868:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5870 - 5877
P870:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5878
P878:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5879
P879:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5880 - 5887
P880:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5888 - 588F
P888:
and ebx,byte 7
add dword[__areg+ebx*4],byte 4
sub edi,byte 8
jmp near execend
; Opcodes 5890 - 5897
P890:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5898 - 589F
P898:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 58A0 - 58A7
P8A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 58A8 - 58AF
P8A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 58B0 - 58B7
P8B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 58B8
P8B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 58B9
P8B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 58C0 - 58C7
P8C0:
and ebx,byte 7
xor ecx,ecx
test al,1
setz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 58C8 - 58CF
P8C8:
test al,1
jnz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 58D0 - 58D7
P8D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 58D8 - 58DF
P8D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 58E0 - 58E7
P8E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 58E8 - 58EF
P8E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 58F0 - 58F7
P8F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 58F8
P8F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 58F9
P8F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test al,1
setz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5900 - 5907
P900:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5908 - 590F
P908:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5910 - 5917
P910:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5918 - 591F
P918:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5920 - 5927
P920:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5928 - 592F
P928:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5930 - 5937
P930:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5938
P938:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5939
P939:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 4
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5940 - 5947
P940:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5948 - 594F
P948:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 4
sub edi,byte 8
jmp near execend
; Opcodes 5950 - 5957
P950:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5958 - 595F
P958:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5960 - 5967
P960:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5968 - 596F
P968:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5970 - 5977
P970:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5978
P978:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5979
P979:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 4
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5980 - 5987
P980:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 4
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5988 - 598F
P988:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 4
sub edi,byte 8
jmp near execend
; Opcodes 5990 - 5997
P990:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5998 - 599F
P998:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 59A0 - 59A7
P9A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 59A8 - 59AF
P9A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 59B0 - 59B7
P9B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 59B8
P9B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 59B9
P9B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 4
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 59C0 - 59C7
P9C0:
and ebx,byte 7
xor ecx,ecx
test al,1
setnz cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 59C8 - 59CF
P9C8:
test al,1
jz near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 59D0 - 59D7
P9D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 59D8 - 59DF
P9D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 59E0 - 59E7
P9E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 59E8 - 59EF
P9E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 59F0 - 59F7
P9F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 59F8
P9F8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 59F9
P9F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test al,1
setnz cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5A00 - 5A07
PA00:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5A08 - 5A0F
PA08:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5A10 - 5A17
PA10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5A18 - 5A1F
PA18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5A20 - 5A27
PA20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5A28 - 5A2F
PA28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5A30 - 5A37
PA30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5A38
PA38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5A39
PA39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5A40 - 5A47
PA40:
and ebx,byte 7
add word[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5A48 - 5A4F
PA48:
and ebx,byte 7
add dword[__areg+ebx*4],byte 5
sub edi,byte 4
jmp near execend
; Opcodes 5A50 - 5A57
PA50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5A58 - 5A5F
PA58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5A60 - 5A67
PA60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5A68 - 5A6F
PA68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5A70 - 5A77
PA70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5A78
PA78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5A79
PA79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5A80 - 5A87
PA80:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5A88 - 5A8F
PA88:
and ebx,byte 7
add dword[__areg+ebx*4],byte 5
sub edi,byte 8
jmp near execend
; Opcodes 5A90 - 5A97
PA90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5A98 - 5A9F
PA98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 5AA0 - 5AA7
PAA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 5AA8 - 5AAF
PAA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 5AB0 - 5AB7
PAB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 5AB8
PAB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 5AB9
PAB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 5AC0 - 5AC7
PAC0:
and ebx,byte 7
xor ecx,ecx
test ah,ah
setns cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 5AC8 - 5ACF
PAC8:
test ah,ah
js near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 5AD0 - 5AD7
PAD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5AD8 - 5ADF
PAD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5AE0 - 5AE7
PAE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5AE8 - 5AEF
PAE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5AF0 - 5AF7
PAF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5AF8
PAF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5AF9
PAF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,ah
setns cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5B00 - 5B07
PB00:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5B08 - 5B0F
PB08:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5B10 - 5B17
PB10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5B18 - 5B1F
PB18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5B20 - 5B27
PB20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5B28 - 5B2F
PB28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5B30 - 5B37
PB30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5B38
PB38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5B39
PB39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 5
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5B40 - 5B47
PB40:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5B48 - 5B4F
PB48:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 5
sub edi,byte 8
jmp near execend
; Opcodes 5B50 - 5B57
PB50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5B58 - 5B5F
PB58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5B60 - 5B67
PB60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5B68 - 5B6F
PB68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5B70 - 5B77
PB70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5B78
PB78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5B79
PB79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 5
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5B80 - 5B87
PB80:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 5
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5B88 - 5B8F
PB88:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 5
sub edi,byte 8
jmp near execend
; Opcodes 5B90 - 5B97
PB90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5B98 - 5B9F
PB98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 5BA0 - 5BA7
PBA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 5BA8 - 5BAF
PBA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 5BB0 - 5BB7
PBB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 5BB8
PBB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 5BB9
PBB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 5
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 5BC0 - 5BC7
PBC0:
and ebx,byte 7
xor ecx,ecx
test ah,ah
sets cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 5BC8 - 5BCF
PBC8:
test ah,ah
jns near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 5BD0 - 5BD7
PBD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5BD8 - 5BDF
PBD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5BE0 - 5BE7
PBE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5BE8 - 5BEF
PBE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5BF0 - 5BF7
PBF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5BF8
PBF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5BF9
PBF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
test ah,ah
sets cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5C00 - 5C07
PC00:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5C08 - 5C0F
PC08:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5C10 - 5C17
PC10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5C18 - 5C1F
PC18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5C20 - 5C27
PC20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5C28 - 5C2F
PC28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5C30 - 5C37
PC30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5C38
PC38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5C39
PC39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5C40 - 5C47
PC40:
and ebx,byte 7
add word[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5C48 - 5C4F
PC48:
and ebx,byte 7
add dword[__areg+ebx*4],byte 6
sub edi,byte 4
jmp near execend
; Opcodes 5C50 - 5C57
PC50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5C58 - 5C5F
PC58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5C60 - 5C67
PC60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5C68 - 5C6F
PC68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5C70 - 5C77
PC70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5C78
PC78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5C79
PC79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5C80 - 5C87
PC80:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5C88 - 5C8F
PC88:
and ebx,byte 7
add dword[__areg+ebx*4],byte 6
sub edi,byte 8
jmp near execend
; Opcodes 5C90 - 5C97
PC90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5C98 - 5C9F
PC98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 5CA0 - 5CA7
PCA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 5CA8 - 5CAF
PCA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 5CB0 - 5CB7
PCB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 5CB8
PCB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 5CB9
PCB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 5CC0 - 5CC7
PCC0:
and ebx,byte 7
xor ecx,ecx
push eax
neg al
xor al,ah
pop eax
setns cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 5CC8 - 5CCF
PCC8:
push eax
neg al
xor al,ah
pop eax
js near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 5CD0 - 5CD7
PCD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5CD8 - 5CDF
PCD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5CE0 - 5CE7
PCE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5CE8 - 5CEF
PCE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5CF0 - 5CF7
PCF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5CF8
PCF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5CF9
PCF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5D00 - 5D07
PD00:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5D08 - 5D0F
PD08:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5D10 - 5D17
PD10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5D18 - 5D1F
PD18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5D20 - 5D27
PD20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5D28 - 5D2F
PD28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5D30 - 5D37
PD30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5D38
PD38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5D39
PD39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 6
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5D40 - 5D47
PD40:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5D48 - 5D4F
PD48:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 6
sub edi,byte 8
jmp near execend
; Opcodes 5D50 - 5D57
PD50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5D58 - 5D5F
PD58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5D60 - 5D67
PD60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5D68 - 5D6F
PD68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5D70 - 5D77
PD70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5D78
PD78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5D79
PD79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 6
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5D80 - 5D87
PD80:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 6
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5D88 - 5D8F
PD88:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 6
sub edi,byte 8
jmp near execend
; Opcodes 5D90 - 5D97
PD90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5D98 - 5D9F
PD98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 5DA0 - 5DA7
PDA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 5DA8 - 5DAF
PDA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 5DB0 - 5DB7
PDB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 5DB8
PDB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 5DB9
PDB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 6
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 5DC0 - 5DC7
PDC0:
and ebx,byte 7
xor ecx,ecx
push eax
neg al
xor al,ah
pop eax
sets cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 5DC8 - 5DCF
PDC8:
push eax
neg al
xor al,ah
pop eax
jns near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 5DD0 - 5DD7
PDD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5DD8 - 5DDF
PDD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5DE0 - 5DE7
PDE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5DE8 - 5DEF
PDE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5DF0 - 5DF7
PDF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5DF8
PDF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5DF9
PDF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
push eax
neg al
xor al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5E00 - 5E07
PE00:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5E08 - 5E0F
PE08:
and ebx,byte 7
add byte[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5E10 - 5E17
PE10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5E18 - 5E1F
PE18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5E20 - 5E27
PE20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5E28 - 5E2F
PE28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5E30 - 5E37
PE30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5E38
PE38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5E39
PE39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
add cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5E40 - 5E47
PE40:
and ebx,byte 7
add word[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5E48 - 5E4F
PE48:
and ebx,byte 7
add dword[__areg+ebx*4],byte 7
sub edi,byte 4
jmp near execend
; Opcodes 5E50 - 5E57
PE50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5E58 - 5E5F
PE58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5E60 - 5E67
PE60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5E68 - 5E6F
PE68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5E70 - 5E77
PE70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5E78
PE78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5E79
PE79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
add cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5E80 - 5E87
PE80:
and ebx,byte 7
add dword[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5E88 - 5E8F
PE88:
and ebx,byte 7
add dword[__areg+ebx*4],byte 7
sub edi,byte 8
jmp near execend
; Opcodes 5E90 - 5E97
PE90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5E98 - 5E9F
PE98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 5EA0 - 5EA7
PEA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 5EA8 - 5EAF
PEA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 5EB0 - 5EB7
PEB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 5EB8
PEB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 5EB9
PEB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
add ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 5EC0 - 5EC7
PEC0:
and ebx,byte 7
xor ecx,ecx
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 5EC8 - 5ECF
PEC8:
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
js near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 5ED0 - 5ED7
PED0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5ED8 - 5EDF
PED8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5EE0 - 5EE7
PEE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5EE8 - 5EEF
PEE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5EF0 - 5EF7
PEF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5EF8
PEF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5EF9
PEF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
setns cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5F00 - 5F07
PF00:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5F08 - 5F0F
PF08:
and ebx,byte 7
sub byte[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5F10 - 5F17
PF10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5F18 - 5F1F
PF18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5F20 - 5F27
PF20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5F28 - 5F2F
PF28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5F30 - 5F37
PF30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5F38
PF38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5F39
PF39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
sub cl,byte 7
lahf
seto al
setc [__xflag]
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 5F40 - 5F47
PF40:
and ebx,byte 7
sub word[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 4
jmp near execend
; Opcodes 5F48 - 5F4F
PF48:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 7
sub edi,byte 8
jmp near execend
; Opcodes 5F50 - 5F57
PF50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 5F58 - 5F5F
PF58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5F60 - 5F67
PF60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5F68 - 5F6F
PF68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 5F70 - 5F77
PF70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 5F78
PF78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 5F79
PF79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
sub cx,byte 7
lahf
seto al
setc [__xflag]
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 5F80 - 5F87
PF80:
and ebx,byte 7
sub dword[__dreg+ebx*4],byte 7
lahf
seto al
setc [__xflag]
sub edi,byte 8
jmp near execend
; Opcodes 5F88 - 5F8F
PF88:
and ebx,byte 7
sub dword[__areg+ebx*4],byte 7
sub edi,byte 8
jmp near execend
; Opcodes 5F90 - 5F97
PF90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 5F98 - 5F9F
PF98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 5FA0 - 5FA7
PFA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 5FA8 - 5FAF
PFA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 5FB0 - 5FB7
PFB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 5FB8
PFB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 5FB9
PFB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
sub ecx,byte 7
lahf
seto al
setc [__xflag]
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 5FC0 - 5FC7
PFC0:
and ebx,byte 7
xor ecx,ecx
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
sub edi,ecx
sub edi,ecx
neg cl
mov [__dreg+ebx*4],cl
sub edi,byte 4
jmp near execend
; Opcodes 5FC8 - 5FCF
PFC8:
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
jns near r_dbra
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 5FD0 - 5FD7
PFD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 5FD8 - 5FDF
PFD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 5FE0 - 5FE7
PFE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 5FE8 - 5FEF
PFE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 5FF0 - 5FF7
PFF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 5FF8
PFF8:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 5FF9
PFF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
sets cl
neg cl
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcode 6000
Q000:
r_bra_w:
movsx ecx,word[esi]
add esi,ecx
sub edi,byte 10
jmp near execend
; Opcodes 6001 - 60FF
Q001:
r_bra_b:
movsx ecx,bl
add esi,ecx
sub edi,byte 10
jmp near execend
; Opcode 6100
Q100:
movsx edx,word[esi]
lea ecx,[esi+2]
sub ecx,ebp
add esi,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 18
jmp near execend
; Opcodes 6101 - 61FF
Q101:
movsx edx,bl
mov ecx,esi
sub ecx,ebp
add esi,edx
mov edx,[__areg+28]
sub edx,byte 4
call writememorydword
mov [__areg+28],edx
sub edi,byte 18
jmp near execend
; Opcode 6200
Q200:
test ah,41h
jz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6201 - 62FF
Q201:
test ah,41h
jz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6300
Q300:
test ah,41h
jnz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6301 - 63FF
Q301:
test ah,41h
jnz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6400
Q400:
test ah,1
jz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6401 - 64FF
Q401:
test ah,1
jz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6500
Q500:
test ah,1
jnz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6501 - 65FF
Q501:
test ah,1
jnz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6600
Q600:
test ah,40h
jz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6601 - 66FF
Q601:
test ah,40h
jz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6700
Q700:
test ah,40h
jnz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6701 - 67FF
Q701:
test ah,40h
jnz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6800
Q800:
test al,1
jz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6801 - 68FF
Q801:
test al,1
jz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6900
Q900:
test al,1
jnz near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6901 - 69FF
Q901:
test al,1
jnz near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6A00
QA00:
test ah,ah
jns near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6A01 - 6AFF
QA01:
test ah,ah
jns near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6B00
QB00:
test ah,ah
js near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6B01 - 6BFF
QB01:
test ah,ah
js near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6C00
QC00:
push eax
neg al
xor al,ah
pop eax
jns near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6C01 - 6CFF
QC01:
push eax
neg al
xor al,ah
pop eax
jns near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6D00
QD00:
push eax
neg al
xor al,ah
pop eax
js near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6D01 - 6DFF
QD01:
push eax
neg al
xor al,ah
pop eax
js near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6E00
QE00:
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
jns near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6E01 - 6EFF
QE01:
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
jns near r_bra_b
sub edi,byte 8
jmp near execend
; Opcode 6F00
QF00:
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
js near r_bra_w
add esi,byte 2
sub edi,byte 12
jmp near execend
; Opcodes 6F01 - 6FFF
QF01:
push eax
neg al
xor al,ah
add ah,ah
or al,ah
pop eax
js near r_bra_b
sub edi,byte 8
jmp near execend
; Opcodes 7000 - 70FF
R000:
movsx ecx,bl
mov [__dreg+0],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7200 - 72FF
R200:
movsx ecx,bl
mov [__dreg+4],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7400 - 74FF
R400:
movsx ecx,bl
mov [__dreg+8],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7600 - 76FF
R600:
movsx ecx,bl
mov [__dreg+12],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7800 - 78FF
R800:
movsx ecx,bl
mov [__dreg+16],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7A00 - 7AFF
RA00:
movsx ecx,bl
mov [__dreg+20],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7C00 - 7CFF
RC00:
movsx ecx,bl
mov [__dreg+24],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 7E00 - 7EFF
RE00:
movsx ecx,bl
mov [__dreg+28],ecx
test cl,cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8000 - 8007
S000:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8010 - 8017
S010:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8018 - 801F
S018:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8020 - 8027
S020:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8028 - 802F
S028:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8030 - 8037
S030:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8038
S038:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8039
S039:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 803A
S03A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 803B
S03B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 803C
S03C:
mov cx,[esi]
add esi,byte 2
or [__dreg+0],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8040 - 8047
S040:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8050 - 8057
S050:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8058 - 805F
S058:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8060 - 8067
S060:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8068 - 806F
S068:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8070 - 8077
S070:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8078
S078:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8079
S079:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 807A
S07A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 807B
S07B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 807C
S07C:
mov cx,[esi]
add esi,byte 2
or [__dreg+0],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8080 - 8087
S080:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8090 - 8097
S090:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8098 - 809F
S098:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 80A0 - 80A7
S0A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 80A8 - 80AF
S0A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 80B0 - 80B7
S0B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 80B8
S0B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 80B9
S0B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 80BA
S0BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 80BB
S0BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 80BC
S0BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+0],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 80C0 - 80C7
S0C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex970
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov970
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop970:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd970
sub ebx,ecx
add edi,byte 2
.nsbhd970:
dec al
jnz short .detloop970
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov970:
mov ax,1
sub edi,byte 10
jmp near execend
zex970:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln971
call basefunction
ln971:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 80D0 - 80D7
S0D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex972
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov972
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop972:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd972
sub ebx,ecx
add edi,byte 2
.nsbhd972:
dec al
jnz short .detloop972
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov972:
mov ax,1
sub edi,byte 14
jmp near execend
zex972:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln973
call basefunction
ln973:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 80D8 - 80DF
S0D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex974
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov974
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop974:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd974
sub ebx,ecx
add edi,byte 2
.nsbhd974:
dec al
jnz short .detloop974
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov974:
mov ax,1
sub edi,byte 14
jmp near execend
zex974:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln975
call basefunction
ln975:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 80E0 - 80E7
S0E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex976
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov976
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop976:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd976
sub ebx,ecx
add edi,byte 2
.nsbhd976:
dec al
jnz short .detloop976
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov976:
mov ax,1
sub edi,byte 16
jmp near execend
zex976:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln977
call basefunction
ln977:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 80E8 - 80EF
S0E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex978
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov978
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop978:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd978
sub ebx,ecx
add edi,byte 2
.nsbhd978:
dec al
jnz short .detloop978
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov978:
mov ax,1
sub edi,byte 18
jmp near execend
zex978:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln979
call basefunction
ln979:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 80F0 - 80F7
S0F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex980
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov980
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop980:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd980
sub ebx,ecx
add edi,byte 2
.nsbhd980:
dec al
jnz short .detloop980
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov980:
mov ax,1
sub edi,byte 20
jmp near execend
zex980:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln981
call basefunction
ln981:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 80F8
S0F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex982
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov982
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop982:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd982
sub ebx,ecx
add edi,byte 2
.nsbhd982:
dec al
jnz short .detloop982
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov982:
mov ax,1
sub edi,byte 18
jmp near execend
zex982:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln983
call basefunction
ln983:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 80F9
S0F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex984
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov984
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop984:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd984
sub ebx,ecx
add edi,byte 2
.nsbhd984:
dec al
jnz short .detloop984
xor ebx,ebx
sub edi,byte 88
jmp near execend
ov984:
mov ax,1
sub edi,byte 22
jmp near execend
zex984:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln985
call basefunction
ln985:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 80FA
S0FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex986
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov986
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop986:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd986
sub ebx,ecx
add edi,byte 2
.nsbhd986:
dec al
jnz short .detloop986
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov986:
mov ax,1
sub edi,byte 18
jmp near execend
zex986:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln987
call basefunction
ln987:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 80FB
S0FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex988
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov988
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop988:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd988
sub ebx,ecx
add edi,byte 2
.nsbhd988:
dec al
jnz short .detloop988
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov988:
mov ax,1
sub edi,byte 20
jmp near execend
zex988:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln989
call basefunction
ln989:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 80FC
S0FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex990
mov eax,[__dreg+0]
shl ecx,16
cmp eax,ecx
jae short ov990
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
mov al,15
pop ecx
shl ecx,16
.detloop990:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd990
sub ebx,ecx
add edi,byte 2
.nsbhd990:
dec al
jnz short .detloop990
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov990:
mov ax,1
sub edi,byte 14
jmp near execend
zex990:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln991
call basefunction
ln991:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8100 - 8107
S100:
and ebx,byte 7
mov ch,ah
shr byte[__xflag],1
mov eax,[__dreg+0]
sbb al,[__dreg+ebx*4]
mov cl,al
das
mov [__dreg+0],al
lahf
setc [__xflag]
jnz short ln992
or ch,0BFh
and ah,ch
ln992:
test al,al
jns short ln993
xor al,al
jmp short ln994
ln993:
test cl,cl
sets al
ln994:
sub edi,byte 6
jmp near execend
; Opcodes 8108 - 810F
S108:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov ebx,ecx
mov edx,[__areg+0]
dec edx
call readmemorybyte
xchg ecx,eax
shr byte[__xflag],1
sbb al,bl
mov cl,al
das
mov ebx,eax
lahf
setc [__xflag]
jnz short ln995
or ch,0BFh
and ah,ch
ln995:
test al,al
jns short ln996
xor al,al
jmp short ln997
ln996:
test cl,cl
sets al
ln997:
mov ecx,ebx
xor ebx,ebx
call writememorybyte
mov [__areg+0],edx
sub edi,byte 18
jmp near execend
; Opcodes 8110 - 8117
S110:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 8118 - 811F
S118:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8120 - 8127
S120:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8128 - 812F
S128:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 8130 - 8137
S130:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 8138
S138:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 8139
S139:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[__dreg+0]
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 8150 - 8157
S150:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 8158 - 815F
S158:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8160 - 8167
S160:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8168 - 816F
S168:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 8170 - 8177
S170:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 8178
S178:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 8179
S179:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[__dreg+0]
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 8190 - 8197
S190:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 8198 - 819F
S198:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 81A0 - 81A7
S1A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 81A8 - 81AF
S1A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 81B0 - 81B7
S1B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 81B8
S1B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 81B9
S1B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[__dreg+0]
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 81C0 - 81C7
S1C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex998
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov998
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs998
test ebx,ebx
js short .ndivd998
add edi,byte 4
.ndivd998:
sub edi,byte 2
.ndivs998:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop998
neg dx
.dsetloop998:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop998
xor ebx,ebx
sub edi,byte 122
jmp near execend
ov998:
mov ax,1
sub edi,byte 16
jmp near execend
zex998:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln999
call basefunction
ln999:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 81D0 - 81D7
S1D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1000
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1000
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1000
test ebx,ebx
js short .ndivd1000
add edi,byte 4
.ndivd1000:
sub edi,byte 2
.ndivs1000:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1000
neg dx
.dsetloop1000:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1000
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1000:
mov ax,1
sub edi,byte 20
jmp near execend
zex1000:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1001
call basefunction
ln1001:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 81D8 - 81DF
S1D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1002
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1002
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1002
test ebx,ebx
js short .ndivd1002
add edi,byte 4
.ndivd1002:
sub edi,byte 2
.ndivs1002:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1002
neg dx
.dsetloop1002:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1002
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1002:
mov ax,1
sub edi,byte 20
jmp near execend
zex1002:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1003
call basefunction
ln1003:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 81E0 - 81E7
S1E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1004
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1004
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1004
test ebx,ebx
js short .ndivd1004
add edi,byte 4
.ndivd1004:
sub edi,byte 2
.ndivs1004:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1004
neg dx
.dsetloop1004:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1004
xor ebx,ebx
sub edi,128
jmp near execend
ov1004:
mov ax,1
sub edi,byte 22
jmp near execend
zex1004:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1005
call basefunction
ln1005:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 81E8 - 81EF
S1E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1006
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1006
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1006
test ebx,ebx
js short .ndivd1006
add edi,byte 4
.ndivd1006:
sub edi,byte 2
.ndivs1006:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1006
neg dx
.dsetloop1006:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1006
xor ebx,ebx
sub edi,130
jmp near execend
ov1006:
mov ax,1
sub edi,byte 24
jmp near execend
zex1006:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1007
call basefunction
ln1007:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 81F0 - 81F7
S1F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1008
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1008
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1008
test ebx,ebx
js short .ndivd1008
add edi,byte 4
.ndivd1008:
sub edi,byte 2
.ndivs1008:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1008
neg dx
.dsetloop1008:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1008
xor ebx,ebx
sub edi,132
jmp near execend
ov1008:
mov ax,1
sub edi,byte 26
jmp near execend
zex1008:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1009
call basefunction
ln1009:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 81F8
S1F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1010
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1010
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1010
test ebx,ebx
js short .ndivd1010
add edi,byte 4
.ndivd1010:
sub edi,byte 2
.ndivs1010:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1010
neg dx
.dsetloop1010:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1010
xor ebx,ebx
sub edi,130
jmp near execend
ov1010:
mov ax,1
sub edi,byte 24
jmp near execend
zex1010:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1011
call basefunction
ln1011:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 81F9
S1F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1012
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1012
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1012
test ebx,ebx
js short .ndivd1012
add edi,byte 4
.ndivd1012:
sub edi,byte 2
.ndivs1012:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1012
neg dx
.dsetloop1012:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1012
xor ebx,ebx
sub edi,134
jmp near execend
ov1012:
mov ax,1
sub edi,byte 28
jmp near execend
zex1012:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1013
call basefunction
ln1013:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 81FA
S1FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1014
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1014
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1014
test ebx,ebx
js short .ndivd1014
add edi,byte 4
.ndivd1014:
sub edi,byte 2
.ndivs1014:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1014
neg dx
.dsetloop1014:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1014
xor ebx,ebx
sub edi,130
jmp near execend
ov1014:
mov ax,1
sub edi,byte 24
jmp near execend
zex1014:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1015
call basefunction
ln1015:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 81FB
S1FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1016
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1016
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1016
test ebx,ebx
js short .ndivd1016
add edi,byte 4
.ndivd1016:
sub edi,byte 2
.ndivs1016:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1016
neg dx
.dsetloop1016:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1016
xor ebx,ebx
sub edi,132
jmp near execend
ov1016:
mov ax,1
sub edi,byte 26
jmp near execend
zex1016:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1017
call basefunction
ln1017:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 81FC
S1FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1018
mov eax,[__dreg+0]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1018
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+0],edx
pop ecx
test cx,cx
js short .ndivs1018
test ebx,ebx
js short .ndivd1018
add edi,byte 4
.ndivd1018:
sub edi,byte 2
.ndivs1018:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1018
neg dx
.dsetloop1018:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1018
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1018:
mov ax,1
sub edi,byte 20
jmp near execend
zex1018:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1019
call basefunction
ln1019:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8200 - 8207
S200:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8210 - 8217
S210:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8218 - 821F
S218:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8220 - 8227
S220:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8228 - 822F
S228:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8230 - 8237
S230:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8238
S238:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8239
S239:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 823A
S23A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 823B
S23B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 823C
S23C:
mov cx,[esi]
add esi,byte 2
or [__dreg+4],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8240 - 8247
S240:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8250 - 8257
S250:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8258 - 825F
S258:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8260 - 8267
S260:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8268 - 826F
S268:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8270 - 8277
S270:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8278
S278:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8279
S279:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 827A
S27A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 827B
S27B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 827C
S27C:
mov cx,[esi]
add esi,byte 2
or [__dreg+4],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8280 - 8287
S280:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8290 - 8297
S290:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8298 - 829F
S298:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 82A0 - 82A7
S2A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 82A8 - 82AF
S2A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 82B0 - 82B7
S2B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 82B8
S2B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 82B9
S2B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 82BA
S2BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 82BB
S2BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 82BC
S2BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+4],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 82C0 - 82C7
S2C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1020
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1020
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1020:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1020
sub ebx,ecx
add edi,byte 2
.nsbhd1020:
dec al
jnz short .detloop1020
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov1020:
mov ax,1
sub edi,byte 10
jmp near execend
zex1020:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1021
call basefunction
ln1021:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 82D0 - 82D7
S2D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1022
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1022
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1022:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1022
sub ebx,ecx
add edi,byte 2
.nsbhd1022:
dec al
jnz short .detloop1022
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1022:
mov ax,1
sub edi,byte 14
jmp near execend
zex1022:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1023
call basefunction
ln1023:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 82D8 - 82DF
S2D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1024
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1024
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1024:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1024
sub ebx,ecx
add edi,byte 2
.nsbhd1024:
dec al
jnz short .detloop1024
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1024:
mov ax,1
sub edi,byte 14
jmp near execend
zex1024:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1025
call basefunction
ln1025:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 82E0 - 82E7
S2E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1026
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1026
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1026:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1026
sub ebx,ecx
add edi,byte 2
.nsbhd1026:
dec al
jnz short .detloop1026
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov1026:
mov ax,1
sub edi,byte 16
jmp near execend
zex1026:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1027
call basefunction
ln1027:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 82E8 - 82EF
S2E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1028
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1028
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1028:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1028
sub ebx,ecx
add edi,byte 2
.nsbhd1028:
dec al
jnz short .detloop1028
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1028:
mov ax,1
sub edi,byte 18
jmp near execend
zex1028:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1029
call basefunction
ln1029:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 82F0 - 82F7
S2F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1030
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1030
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1030:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1030
sub ebx,ecx
add edi,byte 2
.nsbhd1030:
dec al
jnz short .detloop1030
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1030:
mov ax,1
sub edi,byte 20
jmp near execend
zex1030:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1031
call basefunction
ln1031:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 82F8
S2F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1032
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1032
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1032:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1032
sub ebx,ecx
add edi,byte 2
.nsbhd1032:
dec al
jnz short .detloop1032
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1032:
mov ax,1
sub edi,byte 18
jmp near execend
zex1032:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1033
call basefunction
ln1033:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 82F9
S2F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1034
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1034
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1034:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1034
sub ebx,ecx
add edi,byte 2
.nsbhd1034:
dec al
jnz short .detloop1034
xor ebx,ebx
sub edi,byte 88
jmp near execend
ov1034:
mov ax,1
sub edi,byte 22
jmp near execend
zex1034:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1035
call basefunction
ln1035:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 82FA
S2FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1036
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1036
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1036:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1036
sub ebx,ecx
add edi,byte 2
.nsbhd1036:
dec al
jnz short .detloop1036
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1036:
mov ax,1
sub edi,byte 18
jmp near execend
zex1036:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1037
call basefunction
ln1037:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 82FB
S2FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1038
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1038
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1038:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1038
sub ebx,ecx
add edi,byte 2
.nsbhd1038:
dec al
jnz short .detloop1038
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1038:
mov ax,1
sub edi,byte 20
jmp near execend
zex1038:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1039
call basefunction
ln1039:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 82FC
S2FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1040
mov eax,[__dreg+4]
shl ecx,16
cmp eax,ecx
jae short ov1040
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
mov al,15
pop ecx
shl ecx,16
.detloop1040:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1040
sub ebx,ecx
add edi,byte 2
.nsbhd1040:
dec al
jnz short .detloop1040
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1040:
mov ax,1
sub edi,byte 14
jmp near execend
zex1040:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1041
call basefunction
ln1041:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8300 - 8307
S300:
and ebx,byte 7
mov ch,ah
shr byte[__xflag],1
mov eax,[__dreg+4]
sbb al,[__dreg+ebx*4]
mov cl,al
das
mov [__dreg+4],al
lahf
setc [__xflag]
jnz short ln1042
or ch,0BFh
and ah,ch
ln1042:
test al,al
jns short ln1043
xor al,al
jmp short ln1044
ln1043:
test cl,cl
sets al
ln1044:
sub edi,byte 6
jmp near execend
; Opcodes 8308 - 830F
S308:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov ebx,ecx
mov edx,[__areg+4]
dec edx
call readmemorybyte
xchg ecx,eax
shr byte[__xflag],1
sbb al,bl
mov cl,al
das
mov ebx,eax
lahf
setc [__xflag]
jnz short ln1045
or ch,0BFh
and ah,ch
ln1045:
test al,al
jns short ln1046
xor al,al
jmp short ln1047
ln1046:
test cl,cl
sets al
ln1047:
mov ecx,ebx
xor ebx,ebx
call writememorybyte
mov [__areg+4],edx
sub edi,byte 18
jmp near execend
; Opcodes 8310 - 8317
S310:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 8318 - 831F
S318:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8320 - 8327
S320:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8328 - 832F
S328:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 8330 - 8337
S330:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 8338
S338:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 8339
S339:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[__dreg+4]
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 8350 - 8357
S350:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 8358 - 835F
S358:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8360 - 8367
S360:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8368 - 836F
S368:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 8370 - 8377
S370:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 8378
S378:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 8379
S379:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[__dreg+4]
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 8390 - 8397
S390:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 8398 - 839F
S398:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 83A0 - 83A7
S3A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 83A8 - 83AF
S3A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 83B0 - 83B7
S3B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 83B8
S3B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 83B9
S3B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[__dreg+4]
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 83C0 - 83C7
S3C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1048
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1048
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1048
test ebx,ebx
js short .ndivd1048
add edi,byte 4
.ndivd1048:
sub edi,byte 2
.ndivs1048:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1048
neg dx
.dsetloop1048:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1048
xor ebx,ebx
sub edi,byte 122
jmp near execend
ov1048:
mov ax,1
sub edi,byte 16
jmp near execend
zex1048:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1049
call basefunction
ln1049:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 83D0 - 83D7
S3D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1050
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1050
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1050
test ebx,ebx
js short .ndivd1050
add edi,byte 4
.ndivd1050:
sub edi,byte 2
.ndivs1050:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1050
neg dx
.dsetloop1050:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1050
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1050:
mov ax,1
sub edi,byte 20
jmp near execend
zex1050:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1051
call basefunction
ln1051:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 83D8 - 83DF
S3D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1052
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1052
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1052
test ebx,ebx
js short .ndivd1052
add edi,byte 4
.ndivd1052:
sub edi,byte 2
.ndivs1052:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1052
neg dx
.dsetloop1052:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1052
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1052:
mov ax,1
sub edi,byte 20
jmp near execend
zex1052:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1053
call basefunction
ln1053:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 83E0 - 83E7
S3E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1054
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1054
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1054
test ebx,ebx
js short .ndivd1054
add edi,byte 4
.ndivd1054:
sub edi,byte 2
.ndivs1054:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1054
neg dx
.dsetloop1054:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1054
xor ebx,ebx
sub edi,128
jmp near execend
ov1054:
mov ax,1
sub edi,byte 22
jmp near execend
zex1054:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1055
call basefunction
ln1055:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 83E8 - 83EF
S3E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1056
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1056
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1056
test ebx,ebx
js short .ndivd1056
add edi,byte 4
.ndivd1056:
sub edi,byte 2
.ndivs1056:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1056
neg dx
.dsetloop1056:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1056
xor ebx,ebx
sub edi,130
jmp near execend
ov1056:
mov ax,1
sub edi,byte 24
jmp near execend
zex1056:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1057
call basefunction
ln1057:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 83F0 - 83F7
S3F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1058
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1058
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1058
test ebx,ebx
js short .ndivd1058
add edi,byte 4
.ndivd1058:
sub edi,byte 2
.ndivs1058:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1058
neg dx
.dsetloop1058:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1058
xor ebx,ebx
sub edi,132
jmp near execend
ov1058:
mov ax,1
sub edi,byte 26
jmp near execend
zex1058:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1059
call basefunction
ln1059:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 83F8
S3F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1060
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1060
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1060
test ebx,ebx
js short .ndivd1060
add edi,byte 4
.ndivd1060:
sub edi,byte 2
.ndivs1060:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1060
neg dx
.dsetloop1060:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1060
xor ebx,ebx
sub edi,130
jmp near execend
ov1060:
mov ax,1
sub edi,byte 24
jmp near execend
zex1060:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1061
call basefunction
ln1061:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 83F9
S3F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1062
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1062
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1062
test ebx,ebx
js short .ndivd1062
add edi,byte 4
.ndivd1062:
sub edi,byte 2
.ndivs1062:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1062
neg dx
.dsetloop1062:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1062
xor ebx,ebx
sub edi,134
jmp near execend
ov1062:
mov ax,1
sub edi,byte 28
jmp near execend
zex1062:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1063
call basefunction
ln1063:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 83FA
S3FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1064
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1064
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1064
test ebx,ebx
js short .ndivd1064
add edi,byte 4
.ndivd1064:
sub edi,byte 2
.ndivs1064:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1064
neg dx
.dsetloop1064:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1064
xor ebx,ebx
sub edi,130
jmp near execend
ov1064:
mov ax,1
sub edi,byte 24
jmp near execend
zex1064:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1065
call basefunction
ln1065:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 83FB
S3FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1066
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1066
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1066
test ebx,ebx
js short .ndivd1066
add edi,byte 4
.ndivd1066:
sub edi,byte 2
.ndivs1066:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1066
neg dx
.dsetloop1066:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1066
xor ebx,ebx
sub edi,132
jmp near execend
ov1066:
mov ax,1
sub edi,byte 26
jmp near execend
zex1066:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1067
call basefunction
ln1067:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 83FC
S3FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1068
mov eax,[__dreg+4]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1068
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+4],edx
pop ecx
test cx,cx
js short .ndivs1068
test ebx,ebx
js short .ndivd1068
add edi,byte 4
.ndivd1068:
sub edi,byte 2
.ndivs1068:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1068
neg dx
.dsetloop1068:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1068
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1068:
mov ax,1
sub edi,byte 20
jmp near execend
zex1068:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1069
call basefunction
ln1069:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8400 - 8407
S400:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8410 - 8417
S410:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8418 - 841F
S418:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8420 - 8427
S420:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8428 - 842F
S428:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8430 - 8437
S430:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8438
S438:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8439
S439:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 843A
S43A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 843B
S43B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 843C
S43C:
mov cx,[esi]
add esi,byte 2
or [__dreg+8],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8440 - 8447
S440:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8450 - 8457
S450:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8458 - 845F
S458:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8460 - 8467
S460:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8468 - 846F
S468:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8470 - 8477
S470:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8478
S478:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8479
S479:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 847A
S47A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 847B
S47B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 847C
S47C:
mov cx,[esi]
add esi,byte 2
or [__dreg+8],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8480 - 8487
S480:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8490 - 8497
S490:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8498 - 849F
S498:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 84A0 - 84A7
S4A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 84A8 - 84AF
S4A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 84B0 - 84B7
S4B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 84B8
S4B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 84B9
S4B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 84BA
S4BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 84BB
S4BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 84BC
S4BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+8],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 84C0 - 84C7
S4C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1070
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1070
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1070:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1070
sub ebx,ecx
add edi,byte 2
.nsbhd1070:
dec al
jnz short .detloop1070
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov1070:
mov ax,1
sub edi,byte 10
jmp near execend
zex1070:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1071
call basefunction
ln1071:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 84D0 - 84D7
S4D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1072
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1072
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1072:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1072
sub ebx,ecx
add edi,byte 2
.nsbhd1072:
dec al
jnz short .detloop1072
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1072:
mov ax,1
sub edi,byte 14
jmp near execend
zex1072:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1073
call basefunction
ln1073:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 84D8 - 84DF
S4D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1074
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1074
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1074:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1074
sub ebx,ecx
add edi,byte 2
.nsbhd1074:
dec al
jnz short .detloop1074
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1074:
mov ax,1
sub edi,byte 14
jmp near execend
zex1074:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1075
call basefunction
ln1075:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 84E0 - 84E7
S4E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1076
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1076
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1076:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1076
sub ebx,ecx
add edi,byte 2
.nsbhd1076:
dec al
jnz short .detloop1076
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov1076:
mov ax,1
sub edi,byte 16
jmp near execend
zex1076:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1077
call basefunction
ln1077:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 84E8 - 84EF
S4E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1078
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1078
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1078:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1078
sub ebx,ecx
add edi,byte 2
.nsbhd1078:
dec al
jnz short .detloop1078
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1078:
mov ax,1
sub edi,byte 18
jmp near execend
zex1078:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1079
call basefunction
ln1079:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 84F0 - 84F7
S4F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1080
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1080
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1080:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1080
sub ebx,ecx
add edi,byte 2
.nsbhd1080:
dec al
jnz short .detloop1080
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1080:
mov ax,1
sub edi,byte 20
jmp near execend
zex1080:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1081
call basefunction
ln1081:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 84F8
S4F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1082
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1082
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1082:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1082
sub ebx,ecx
add edi,byte 2
.nsbhd1082:
dec al
jnz short .detloop1082
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1082:
mov ax,1
sub edi,byte 18
jmp near execend
zex1082:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1083
call basefunction
ln1083:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 84F9
S4F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1084
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1084
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1084:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1084
sub ebx,ecx
add edi,byte 2
.nsbhd1084:
dec al
jnz short .detloop1084
xor ebx,ebx
sub edi,byte 88
jmp near execend
ov1084:
mov ax,1
sub edi,byte 22
jmp near execend
zex1084:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1085
call basefunction
ln1085:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 84FA
S4FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1086
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1086
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1086:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1086
sub ebx,ecx
add edi,byte 2
.nsbhd1086:
dec al
jnz short .detloop1086
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1086:
mov ax,1
sub edi,byte 18
jmp near execend
zex1086:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1087
call basefunction
ln1087:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 84FB
S4FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1088
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1088
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1088:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1088
sub ebx,ecx
add edi,byte 2
.nsbhd1088:
dec al
jnz short .detloop1088
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1088:
mov ax,1
sub edi,byte 20
jmp near execend
zex1088:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1089
call basefunction
ln1089:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 84FC
S4FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1090
mov eax,[__dreg+8]
shl ecx,16
cmp eax,ecx
jae short ov1090
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
mov al,15
pop ecx
shl ecx,16
.detloop1090:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1090
sub ebx,ecx
add edi,byte 2
.nsbhd1090:
dec al
jnz short .detloop1090
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1090:
mov ax,1
sub edi,byte 14
jmp near execend
zex1090:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1091
call basefunction
ln1091:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8500 - 8507
S500:
and ebx,byte 7
mov ch,ah
shr byte[__xflag],1
mov eax,[__dreg+8]
sbb al,[__dreg+ebx*4]
mov cl,al
das
mov [__dreg+8],al
lahf
setc [__xflag]
jnz short ln1092
or ch,0BFh
and ah,ch
ln1092:
test al,al
jns short ln1093
xor al,al
jmp short ln1094
ln1093:
test cl,cl
sets al
ln1094:
sub edi,byte 6
jmp near execend
; Opcodes 8508 - 850F
S508:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov ebx,ecx
mov edx,[__areg+8]
dec edx
call readmemorybyte
xchg ecx,eax
shr byte[__xflag],1
sbb al,bl
mov cl,al
das
mov ebx,eax
lahf
setc [__xflag]
jnz short ln1095
or ch,0BFh
and ah,ch
ln1095:
test al,al
jns short ln1096
xor al,al
jmp short ln1097
ln1096:
test cl,cl
sets al
ln1097:
mov ecx,ebx
xor ebx,ebx
call writememorybyte
mov [__areg+8],edx
sub edi,byte 18
jmp near execend
; Opcodes 8510 - 8517
S510:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 8518 - 851F
S518:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8520 - 8527
S520:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8528 - 852F
S528:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 8530 - 8537
S530:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 8538
S538:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 8539
S539:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[__dreg+8]
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 8550 - 8557
S550:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 8558 - 855F
S558:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8560 - 8567
S560:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8568 - 856F
S568:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 8570 - 8577
S570:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 8578
S578:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 8579
S579:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[__dreg+8]
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 8590 - 8597
S590:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 8598 - 859F
S598:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 85A0 - 85A7
S5A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 85A8 - 85AF
S5A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 85B0 - 85B7
S5B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 85B8
S5B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 85B9
S5B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[__dreg+8]
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 85C0 - 85C7
S5C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1098
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1098
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1098
test ebx,ebx
js short .ndivd1098
add edi,byte 4
.ndivd1098:
sub edi,byte 2
.ndivs1098:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1098
neg dx
.dsetloop1098:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1098
xor ebx,ebx
sub edi,byte 122
jmp near execend
ov1098:
mov ax,1
sub edi,byte 16
jmp near execend
zex1098:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1099
call basefunction
ln1099:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 85D0 - 85D7
S5D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1100
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1100
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1100
test ebx,ebx
js short .ndivd1100
add edi,byte 4
.ndivd1100:
sub edi,byte 2
.ndivs1100:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1100
neg dx
.dsetloop1100:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1100
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1100:
mov ax,1
sub edi,byte 20
jmp near execend
zex1100:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1101
call basefunction
ln1101:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 85D8 - 85DF
S5D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1102
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1102
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1102
test ebx,ebx
js short .ndivd1102
add edi,byte 4
.ndivd1102:
sub edi,byte 2
.ndivs1102:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1102
neg dx
.dsetloop1102:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1102
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1102:
mov ax,1
sub edi,byte 20
jmp near execend
zex1102:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1103
call basefunction
ln1103:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 85E0 - 85E7
S5E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1104
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1104
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1104
test ebx,ebx
js short .ndivd1104
add edi,byte 4
.ndivd1104:
sub edi,byte 2
.ndivs1104:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1104
neg dx
.dsetloop1104:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1104
xor ebx,ebx
sub edi,128
jmp near execend
ov1104:
mov ax,1
sub edi,byte 22
jmp near execend
zex1104:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1105
call basefunction
ln1105:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 85E8 - 85EF
S5E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1106
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1106
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1106
test ebx,ebx
js short .ndivd1106
add edi,byte 4
.ndivd1106:
sub edi,byte 2
.ndivs1106:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1106
neg dx
.dsetloop1106:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1106
xor ebx,ebx
sub edi,130
jmp near execend
ov1106:
mov ax,1
sub edi,byte 24
jmp near execend
zex1106:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1107
call basefunction
ln1107:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 85F0 - 85F7
S5F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1108
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1108
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1108
test ebx,ebx
js short .ndivd1108
add edi,byte 4
.ndivd1108:
sub edi,byte 2
.ndivs1108:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1108
neg dx
.dsetloop1108:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1108
xor ebx,ebx
sub edi,132
jmp near execend
ov1108:
mov ax,1
sub edi,byte 26
jmp near execend
zex1108:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1109
call basefunction
ln1109:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 85F8
S5F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1110
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1110
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1110
test ebx,ebx
js short .ndivd1110
add edi,byte 4
.ndivd1110:
sub edi,byte 2
.ndivs1110:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1110
neg dx
.dsetloop1110:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1110
xor ebx,ebx
sub edi,130
jmp near execend
ov1110:
mov ax,1
sub edi,byte 24
jmp near execend
zex1110:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1111
call basefunction
ln1111:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 85F9
S5F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1112
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1112
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1112
test ebx,ebx
js short .ndivd1112
add edi,byte 4
.ndivd1112:
sub edi,byte 2
.ndivs1112:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1112
neg dx
.dsetloop1112:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1112
xor ebx,ebx
sub edi,134
jmp near execend
ov1112:
mov ax,1
sub edi,byte 28
jmp near execend
zex1112:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1113
call basefunction
ln1113:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 85FA
S5FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1114
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1114
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1114
test ebx,ebx
js short .ndivd1114
add edi,byte 4
.ndivd1114:
sub edi,byte 2
.ndivs1114:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1114
neg dx
.dsetloop1114:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1114
xor ebx,ebx
sub edi,130
jmp near execend
ov1114:
mov ax,1
sub edi,byte 24
jmp near execend
zex1114:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1115
call basefunction
ln1115:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 85FB
S5FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1116
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1116
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1116
test ebx,ebx
js short .ndivd1116
add edi,byte 4
.ndivd1116:
sub edi,byte 2
.ndivs1116:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1116
neg dx
.dsetloop1116:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1116
xor ebx,ebx
sub edi,132
jmp near execend
ov1116:
mov ax,1
sub edi,byte 26
jmp near execend
zex1116:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1117
call basefunction
ln1117:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 85FC
S5FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1118
mov eax,[__dreg+8]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1118
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+8],edx
pop ecx
test cx,cx
js short .ndivs1118
test ebx,ebx
js short .ndivd1118
add edi,byte 4
.ndivd1118:
sub edi,byte 2
.ndivs1118:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1118
neg dx
.dsetloop1118:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1118
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1118:
mov ax,1
sub edi,byte 20
jmp near execend
zex1118:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1119
call basefunction
ln1119:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8600 - 8607
S600:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8610 - 8617
S610:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8618 - 861F
S618:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8620 - 8627
S620:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8628 - 862F
S628:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8630 - 8637
S630:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8638
S638:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8639
S639:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 863A
S63A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 863B
S63B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 863C
S63C:
mov cx,[esi]
add esi,byte 2
or [__dreg+12],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8640 - 8647
S640:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8650 - 8657
S650:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8658 - 865F
S658:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8660 - 8667
S660:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8668 - 866F
S668:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8670 - 8677
S670:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8678
S678:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8679
S679:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 867A
S67A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 867B
S67B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 867C
S67C:
mov cx,[esi]
add esi,byte 2
or [__dreg+12],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8680 - 8687
S680:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8690 - 8697
S690:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8698 - 869F
S698:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 86A0 - 86A7
S6A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 86A8 - 86AF
S6A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 86B0 - 86B7
S6B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 86B8
S6B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 86B9
S6B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 86BA
S6BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 86BB
S6BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 86BC
S6BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+12],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 86C0 - 86C7
S6C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1120
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1120
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1120:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1120
sub ebx,ecx
add edi,byte 2
.nsbhd1120:
dec al
jnz short .detloop1120
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov1120:
mov ax,1
sub edi,byte 10
jmp near execend
zex1120:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1121
call basefunction
ln1121:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 86D0 - 86D7
S6D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1122
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1122
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1122:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1122
sub ebx,ecx
add edi,byte 2
.nsbhd1122:
dec al
jnz short .detloop1122
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1122:
mov ax,1
sub edi,byte 14
jmp near execend
zex1122:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1123
call basefunction
ln1123:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 86D8 - 86DF
S6D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1124
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1124
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1124:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1124
sub ebx,ecx
add edi,byte 2
.nsbhd1124:
dec al
jnz short .detloop1124
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1124:
mov ax,1
sub edi,byte 14
jmp near execend
zex1124:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1125
call basefunction
ln1125:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 86E0 - 86E7
S6E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1126
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1126
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1126:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1126
sub ebx,ecx
add edi,byte 2
.nsbhd1126:
dec al
jnz short .detloop1126
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov1126:
mov ax,1
sub edi,byte 16
jmp near execend
zex1126:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1127
call basefunction
ln1127:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 86E8 - 86EF
S6E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1128
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1128
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1128:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1128
sub ebx,ecx
add edi,byte 2
.nsbhd1128:
dec al
jnz short .detloop1128
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1128:
mov ax,1
sub edi,byte 18
jmp near execend
zex1128:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1129
call basefunction
ln1129:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 86F0 - 86F7
S6F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1130
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1130
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1130:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1130
sub ebx,ecx
add edi,byte 2
.nsbhd1130:
dec al
jnz short .detloop1130
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1130:
mov ax,1
sub edi,byte 20
jmp near execend
zex1130:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1131
call basefunction
ln1131:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 86F8
S6F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1132
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1132
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1132:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1132
sub ebx,ecx
add edi,byte 2
.nsbhd1132:
dec al
jnz short .detloop1132
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1132:
mov ax,1
sub edi,byte 18
jmp near execend
zex1132:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1133
call basefunction
ln1133:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 86F9
S6F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1134
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1134
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1134:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1134
sub ebx,ecx
add edi,byte 2
.nsbhd1134:
dec al
jnz short .detloop1134
xor ebx,ebx
sub edi,byte 88
jmp near execend
ov1134:
mov ax,1
sub edi,byte 22
jmp near execend
zex1134:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1135
call basefunction
ln1135:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 86FA
S6FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1136
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1136
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1136:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1136
sub ebx,ecx
add edi,byte 2
.nsbhd1136:
dec al
jnz short .detloop1136
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1136:
mov ax,1
sub edi,byte 18
jmp near execend
zex1136:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1137
call basefunction
ln1137:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 86FB
S6FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1138
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1138
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1138:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1138
sub ebx,ecx
add edi,byte 2
.nsbhd1138:
dec al
jnz short .detloop1138
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1138:
mov ax,1
sub edi,byte 20
jmp near execend
zex1138:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1139
call basefunction
ln1139:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 86FC
S6FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1140
mov eax,[__dreg+12]
shl ecx,16
cmp eax,ecx
jae short ov1140
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
mov al,15
pop ecx
shl ecx,16
.detloop1140:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1140
sub ebx,ecx
add edi,byte 2
.nsbhd1140:
dec al
jnz short .detloop1140
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1140:
mov ax,1
sub edi,byte 14
jmp near execend
zex1140:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1141
call basefunction
ln1141:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8700 - 8707
S700:
and ebx,byte 7
mov ch,ah
shr byte[__xflag],1
mov eax,[__dreg+12]
sbb al,[__dreg+ebx*4]
mov cl,al
das
mov [__dreg+12],al
lahf
setc [__xflag]
jnz short ln1142
or ch,0BFh
and ah,ch
ln1142:
test al,al
jns short ln1143
xor al,al
jmp short ln1144
ln1143:
test cl,cl
sets al
ln1144:
sub edi,byte 6
jmp near execend
; Opcodes 8708 - 870F
S708:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov ebx,ecx
mov edx,[__areg+12]
dec edx
call readmemorybyte
xchg ecx,eax
shr byte[__xflag],1
sbb al,bl
mov cl,al
das
mov ebx,eax
lahf
setc [__xflag]
jnz short ln1145
or ch,0BFh
and ah,ch
ln1145:
test al,al
jns short ln1146
xor al,al
jmp short ln1147
ln1146:
test cl,cl
sets al
ln1147:
mov ecx,ebx
xor ebx,ebx
call writememorybyte
mov [__areg+12],edx
sub edi,byte 18
jmp near execend
; Opcodes 8710 - 8717
S710:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 8718 - 871F
S718:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8720 - 8727
S720:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8728 - 872F
S728:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 8730 - 8737
S730:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 8738
S738:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 8739
S739:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[__dreg+12]
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 8750 - 8757
S750:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 8758 - 875F
S758:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8760 - 8767
S760:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8768 - 876F
S768:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 8770 - 8777
S770:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 8778
S778:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 8779
S779:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[__dreg+12]
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 8790 - 8797
S790:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 8798 - 879F
S798:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 87A0 - 87A7
S7A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 87A8 - 87AF
S7A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 87B0 - 87B7
S7B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 87B8
S7B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 87B9
S7B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[__dreg+12]
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 87C0 - 87C7
S7C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1148
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1148
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1148
test ebx,ebx
js short .ndivd1148
add edi,byte 4
.ndivd1148:
sub edi,byte 2
.ndivs1148:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1148
neg dx
.dsetloop1148:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1148
xor ebx,ebx
sub edi,byte 122
jmp near execend
ov1148:
mov ax,1
sub edi,byte 16
jmp near execend
zex1148:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1149
call basefunction
ln1149:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 87D0 - 87D7
S7D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1150
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1150
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1150
test ebx,ebx
js short .ndivd1150
add edi,byte 4
.ndivd1150:
sub edi,byte 2
.ndivs1150:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1150
neg dx
.dsetloop1150:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1150
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1150:
mov ax,1
sub edi,byte 20
jmp near execend
zex1150:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1151
call basefunction
ln1151:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 87D8 - 87DF
S7D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1152
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1152
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1152
test ebx,ebx
js short .ndivd1152
add edi,byte 4
.ndivd1152:
sub edi,byte 2
.ndivs1152:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1152
neg dx
.dsetloop1152:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1152
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1152:
mov ax,1
sub edi,byte 20
jmp near execend
zex1152:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1153
call basefunction
ln1153:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 87E0 - 87E7
S7E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1154
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1154
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1154
test ebx,ebx
js short .ndivd1154
add edi,byte 4
.ndivd1154:
sub edi,byte 2
.ndivs1154:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1154
neg dx
.dsetloop1154:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1154
xor ebx,ebx
sub edi,128
jmp near execend
ov1154:
mov ax,1
sub edi,byte 22
jmp near execend
zex1154:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1155
call basefunction
ln1155:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 87E8 - 87EF
S7E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1156
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1156
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1156
test ebx,ebx
js short .ndivd1156
add edi,byte 4
.ndivd1156:
sub edi,byte 2
.ndivs1156:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1156
neg dx
.dsetloop1156:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1156
xor ebx,ebx
sub edi,130
jmp near execend
ov1156:
mov ax,1
sub edi,byte 24
jmp near execend
zex1156:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1157
call basefunction
ln1157:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 87F0 - 87F7
S7F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1158
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1158
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1158
test ebx,ebx
js short .ndivd1158
add edi,byte 4
.ndivd1158:
sub edi,byte 2
.ndivs1158:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1158
neg dx
.dsetloop1158:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1158
xor ebx,ebx
sub edi,132
jmp near execend
ov1158:
mov ax,1
sub edi,byte 26
jmp near execend
zex1158:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1159
call basefunction
ln1159:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 87F8
S7F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1160
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1160
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1160
test ebx,ebx
js short .ndivd1160
add edi,byte 4
.ndivd1160:
sub edi,byte 2
.ndivs1160:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1160
neg dx
.dsetloop1160:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1160
xor ebx,ebx
sub edi,130
jmp near execend
ov1160:
mov ax,1
sub edi,byte 24
jmp near execend
zex1160:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1161
call basefunction
ln1161:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 87F9
S7F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1162
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1162
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1162
test ebx,ebx
js short .ndivd1162
add edi,byte 4
.ndivd1162:
sub edi,byte 2
.ndivs1162:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1162
neg dx
.dsetloop1162:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1162
xor ebx,ebx
sub edi,134
jmp near execend
ov1162:
mov ax,1
sub edi,byte 28
jmp near execend
zex1162:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1163
call basefunction
ln1163:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 87FA
S7FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1164
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1164
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1164
test ebx,ebx
js short .ndivd1164
add edi,byte 4
.ndivd1164:
sub edi,byte 2
.ndivs1164:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1164
neg dx
.dsetloop1164:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1164
xor ebx,ebx
sub edi,130
jmp near execend
ov1164:
mov ax,1
sub edi,byte 24
jmp near execend
zex1164:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1165
call basefunction
ln1165:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 87FB
S7FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1166
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1166
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1166
test ebx,ebx
js short .ndivd1166
add edi,byte 4
.ndivd1166:
sub edi,byte 2
.ndivs1166:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1166
neg dx
.dsetloop1166:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1166
xor ebx,ebx
sub edi,132
jmp near execend
ov1166:
mov ax,1
sub edi,byte 26
jmp near execend
zex1166:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1167
call basefunction
ln1167:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 87FC
S7FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1168
mov eax,[__dreg+12]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1168
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+12],edx
pop ecx
test cx,cx
js short .ndivs1168
test ebx,ebx
js short .ndivd1168
add edi,byte 4
.ndivd1168:
sub edi,byte 2
.ndivs1168:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1168
neg dx
.dsetloop1168:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1168
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1168:
mov ax,1
sub edi,byte 20
jmp near execend
zex1168:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1169
call basefunction
ln1169:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8800 - 8807
S800:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8810 - 8817
S810:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8818 - 881F
S818:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8820 - 8827
S820:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8828 - 882F
S828:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8830 - 8837
S830:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8838
S838:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8839
S839:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 883A
S83A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 883B
S83B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 883C
S83C:
mov cx,[esi]
add esi,byte 2
or [__dreg+16],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8840 - 8847
S840:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8850 - 8857
S850:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8858 - 885F
S858:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8860 - 8867
S860:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8868 - 886F
S868:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8870 - 8877
S870:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8878
S878:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8879
S879:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 887A
S87A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 887B
S87B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 887C
S87C:
mov cx,[esi]
add esi,byte 2
or [__dreg+16],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8880 - 8887
S880:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8890 - 8897
S890:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8898 - 889F
S898:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 88A0 - 88A7
S8A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 88A8 - 88AF
S8A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 88B0 - 88B7
S8B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 88B8
S8B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 88B9
S8B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 88BA
S8BA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 88BB
S8BB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 88BC
S8BC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+16],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 88C0 - 88C7
S8C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1170
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1170
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1170:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1170
sub ebx,ecx
add edi,byte 2
.nsbhd1170:
dec al
jnz short .detloop1170
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov1170:
mov ax,1
sub edi,byte 10
jmp near execend
zex1170:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1171
call basefunction
ln1171:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 88D0 - 88D7
S8D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1172
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1172
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1172:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1172
sub ebx,ecx
add edi,byte 2
.nsbhd1172:
dec al
jnz short .detloop1172
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1172:
mov ax,1
sub edi,byte 14
jmp near execend
zex1172:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1173
call basefunction
ln1173:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 88D8 - 88DF
S8D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1174
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1174
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1174:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1174
sub ebx,ecx
add edi,byte 2
.nsbhd1174:
dec al
jnz short .detloop1174
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1174:
mov ax,1
sub edi,byte 14
jmp near execend
zex1174:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1175
call basefunction
ln1175:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 88E0 - 88E7
S8E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1176
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1176
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1176:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1176
sub ebx,ecx
add edi,byte 2
.nsbhd1176:
dec al
jnz short .detloop1176
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov1176:
mov ax,1
sub edi,byte 16
jmp near execend
zex1176:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1177
call basefunction
ln1177:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 88E8 - 88EF
S8E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1178
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1178
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1178:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1178
sub ebx,ecx
add edi,byte 2
.nsbhd1178:
dec al
jnz short .detloop1178
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1178:
mov ax,1
sub edi,byte 18
jmp near execend
zex1178:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1179
call basefunction
ln1179:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 88F0 - 88F7
S8F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1180
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1180
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1180:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1180
sub ebx,ecx
add edi,byte 2
.nsbhd1180:
dec al
jnz short .detloop1180
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1180:
mov ax,1
sub edi,byte 20
jmp near execend
zex1180:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1181
call basefunction
ln1181:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 88F8
S8F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1182
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1182
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1182:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1182
sub ebx,ecx
add edi,byte 2
.nsbhd1182:
dec al
jnz short .detloop1182
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1182:
mov ax,1
sub edi,byte 18
jmp near execend
zex1182:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1183
call basefunction
ln1183:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 88F9
S8F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1184
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1184
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1184:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1184
sub ebx,ecx
add edi,byte 2
.nsbhd1184:
dec al
jnz short .detloop1184
xor ebx,ebx
sub edi,byte 88
jmp near execend
ov1184:
mov ax,1
sub edi,byte 22
jmp near execend
zex1184:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1185
call basefunction
ln1185:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 88FA
S8FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1186
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1186
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1186:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1186
sub ebx,ecx
add edi,byte 2
.nsbhd1186:
dec al
jnz short .detloop1186
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1186:
mov ax,1
sub edi,byte 18
jmp near execend
zex1186:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1187
call basefunction
ln1187:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 88FB
S8FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1188
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1188
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1188:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1188
sub ebx,ecx
add edi,byte 2
.nsbhd1188:
dec al
jnz short .detloop1188
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1188:
mov ax,1
sub edi,byte 20
jmp near execend
zex1188:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1189
call basefunction
ln1189:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 88FC
S8FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1190
mov eax,[__dreg+16]
shl ecx,16
cmp eax,ecx
jae short ov1190
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
mov al,15
pop ecx
shl ecx,16
.detloop1190:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1190
sub ebx,ecx
add edi,byte 2
.nsbhd1190:
dec al
jnz short .detloop1190
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1190:
mov ax,1
sub edi,byte 14
jmp near execend
zex1190:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1191
call basefunction
ln1191:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8900 - 8907
S900:
and ebx,byte 7
mov ch,ah
shr byte[__xflag],1
mov eax,[__dreg+16]
sbb al,[__dreg+ebx*4]
mov cl,al
das
mov [__dreg+16],al
lahf
setc [__xflag]
jnz short ln1192
or ch,0BFh
and ah,ch
ln1192:
test al,al
jns short ln1193
xor al,al
jmp short ln1194
ln1193:
test cl,cl
sets al
ln1194:
sub edi,byte 6
jmp near execend
; Opcodes 8908 - 890F
S908:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov ebx,ecx
mov edx,[__areg+16]
dec edx
call readmemorybyte
xchg ecx,eax
shr byte[__xflag],1
sbb al,bl
mov cl,al
das
mov ebx,eax
lahf
setc [__xflag]
jnz short ln1195
or ch,0BFh
and ah,ch
ln1195:
test al,al
jns short ln1196
xor al,al
jmp short ln1197
ln1196:
test cl,cl
sets al
ln1197:
mov ecx,ebx
xor ebx,ebx
call writememorybyte
mov [__areg+16],edx
sub edi,byte 18
jmp near execend
; Opcodes 8910 - 8917
S910:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 8918 - 891F
S918:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8920 - 8927
S920:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8928 - 892F
S928:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 8930 - 8937
S930:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 8938
S938:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 8939
S939:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[__dreg+16]
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 8950 - 8957
S950:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 8958 - 895F
S958:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8960 - 8967
S960:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8968 - 896F
S968:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 8970 - 8977
S970:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 8978
S978:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 8979
S979:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[__dreg+16]
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 8990 - 8997
S990:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 8998 - 899F
S998:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 89A0 - 89A7
S9A0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 89A8 - 89AF
S9A8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 89B0 - 89B7
S9B0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 89B8
S9B8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 89B9
S9B9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[__dreg+16]
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 89C0 - 89C7
S9C0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1198
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1198
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1198
test ebx,ebx
js short .ndivd1198
add edi,byte 4
.ndivd1198:
sub edi,byte 2
.ndivs1198:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1198
neg dx
.dsetloop1198:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1198
xor ebx,ebx
sub edi,byte 122
jmp near execend
ov1198:
mov ax,1
sub edi,byte 16
jmp near execend
zex1198:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1199
call basefunction
ln1199:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 89D0 - 89D7
S9D0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1200
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1200
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1200
test ebx,ebx
js short .ndivd1200
add edi,byte 4
.ndivd1200:
sub edi,byte 2
.ndivs1200:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1200
neg dx
.dsetloop1200:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1200
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1200:
mov ax,1
sub edi,byte 20
jmp near execend
zex1200:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1201
call basefunction
ln1201:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 89D8 - 89DF
S9D8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1202
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1202
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1202
test ebx,ebx
js short .ndivd1202
add edi,byte 4
.ndivd1202:
sub edi,byte 2
.ndivs1202:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1202
neg dx
.dsetloop1202:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1202
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1202:
mov ax,1
sub edi,byte 20
jmp near execend
zex1202:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1203
call basefunction
ln1203:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 89E0 - 89E7
S9E0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1204
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1204
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1204
test ebx,ebx
js short .ndivd1204
add edi,byte 4
.ndivd1204:
sub edi,byte 2
.ndivs1204:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1204
neg dx
.dsetloop1204:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1204
xor ebx,ebx
sub edi,128
jmp near execend
ov1204:
mov ax,1
sub edi,byte 22
jmp near execend
zex1204:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1205
call basefunction
ln1205:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 89E8 - 89EF
S9E8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1206
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1206
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1206
test ebx,ebx
js short .ndivd1206
add edi,byte 4
.ndivd1206:
sub edi,byte 2
.ndivs1206:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1206
neg dx
.dsetloop1206:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1206
xor ebx,ebx
sub edi,130
jmp near execend
ov1206:
mov ax,1
sub edi,byte 24
jmp near execend
zex1206:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1207
call basefunction
ln1207:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 89F0 - 89F7
S9F0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1208
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1208
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1208
test ebx,ebx
js short .ndivd1208
add edi,byte 4
.ndivd1208:
sub edi,byte 2
.ndivs1208:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1208
neg dx
.dsetloop1208:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1208
xor ebx,ebx
sub edi,132
jmp near execend
ov1208:
mov ax,1
sub edi,byte 26
jmp near execend
zex1208:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1209
call basefunction
ln1209:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 89F8
S9F8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1210
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1210
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1210
test ebx,ebx
js short .ndivd1210
add edi,byte 4
.ndivd1210:
sub edi,byte 2
.ndivs1210:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1210
neg dx
.dsetloop1210:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1210
xor ebx,ebx
sub edi,130
jmp near execend
ov1210:
mov ax,1
sub edi,byte 24
jmp near execend
zex1210:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1211
call basefunction
ln1211:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 89F9
S9F9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1212
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1212
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1212
test ebx,ebx
js short .ndivd1212
add edi,byte 4
.ndivd1212:
sub edi,byte 2
.ndivs1212:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1212
neg dx
.dsetloop1212:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1212
xor ebx,ebx
sub edi,134
jmp near execend
ov1212:
mov ax,1
sub edi,byte 28
jmp near execend
zex1212:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1213
call basefunction
ln1213:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 89FA
S9FA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1214
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1214
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1214
test ebx,ebx
js short .ndivd1214
add edi,byte 4
.ndivd1214:
sub edi,byte 2
.ndivs1214:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1214
neg dx
.dsetloop1214:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1214
xor ebx,ebx
sub edi,130
jmp near execend
ov1214:
mov ax,1
sub edi,byte 24
jmp near execend
zex1214:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1215
call basefunction
ln1215:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 89FB
S9FB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1216
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1216
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1216
test ebx,ebx
js short .ndivd1216
add edi,byte 4
.ndivd1216:
sub edi,byte 2
.ndivs1216:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1216
neg dx
.dsetloop1216:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1216
xor ebx,ebx
sub edi,132
jmp near execend
ov1216:
mov ax,1
sub edi,byte 26
jmp near execend
zex1216:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1217
call basefunction
ln1217:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 89FC
S9FC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1218
mov eax,[__dreg+16]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1218
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+16],edx
pop ecx
test cx,cx
js short .ndivs1218
test ebx,ebx
js short .ndivd1218
add edi,byte 4
.ndivd1218:
sub edi,byte 2
.ndivs1218:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1218
neg dx
.dsetloop1218:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1218
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1218:
mov ax,1
sub edi,byte 20
jmp near execend
zex1218:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1219
call basefunction
ln1219:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8A00 - 8A07
SA00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8A10 - 8A17
SA10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A18 - 8A1F
SA18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A20 - 8A27
SA20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8A28 - 8A2F
SA28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8A30 - 8A37
SA30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8A38
SA38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8A39
SA39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 8A3A
SA3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8A3B
SA3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8A3C
SA3C:
mov cx,[esi]
add esi,byte 2
or [__dreg+20],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A40 - 8A47
SA40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8A50 - 8A57
SA50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A58 - 8A5F
SA58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A60 - 8A67
SA60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8A68 - 8A6F
SA68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8A70 - 8A77
SA70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8A78
SA78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8A79
SA79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 8A7A
SA7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8A7B
SA7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8A7C
SA7C:
mov cx,[esi]
add esi,byte 2
or [__dreg+20],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A80 - 8A87
SA80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8A90 - 8A97
SA90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8A98 - 8A9F
SA98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8AA0 - 8AA7
SAA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 8AA8 - 8AAF
SAA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 8AB0 - 8AB7
SAB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 8AB8
SAB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 8AB9
SAB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 8ABA
SABA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 8ABB
SABB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 8ABC
SABC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+20],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 8AC0 - 8AC7
SAC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1220
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1220
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1220:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1220
sub ebx,ecx
add edi,byte 2
.nsbhd1220:
dec al
jnz short .detloop1220
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov1220:
mov ax,1
sub edi,byte 10
jmp near execend
zex1220:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1221
call basefunction
ln1221:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 8AD0 - 8AD7
SAD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1222
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1222
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1222:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1222
sub ebx,ecx
add edi,byte 2
.nsbhd1222:
dec al
jnz short .detloop1222
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1222:
mov ax,1
sub edi,byte 14
jmp near execend
zex1222:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1223
call basefunction
ln1223:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8AD8 - 8ADF
SAD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1224
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1224
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1224:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1224
sub ebx,ecx
add edi,byte 2
.nsbhd1224:
dec al
jnz short .detloop1224
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1224:
mov ax,1
sub edi,byte 14
jmp near execend
zex1224:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1225
call basefunction
ln1225:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8AE0 - 8AE7
SAE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1226
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1226
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1226:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1226
sub ebx,ecx
add edi,byte 2
.nsbhd1226:
dec al
jnz short .detloop1226
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov1226:
mov ax,1
sub edi,byte 16
jmp near execend
zex1226:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1227
call basefunction
ln1227:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 8AE8 - 8AEF
SAE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1228
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1228
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1228:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1228
sub ebx,ecx
add edi,byte 2
.nsbhd1228:
dec al
jnz short .detloop1228
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1228:
mov ax,1
sub edi,byte 18
jmp near execend
zex1228:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1229
call basefunction
ln1229:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 8AF0 - 8AF7
SAF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1230
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1230
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1230:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1230
sub ebx,ecx
add edi,byte 2
.nsbhd1230:
dec al
jnz short .detloop1230
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1230:
mov ax,1
sub edi,byte 20
jmp near execend
zex1230:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1231
call basefunction
ln1231:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 8AF8
SAF8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1232
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1232
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1232:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1232
sub ebx,ecx
add edi,byte 2
.nsbhd1232:
dec al
jnz short .detloop1232
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1232:
mov ax,1
sub edi,byte 18
jmp near execend
zex1232:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1233
call basefunction
ln1233:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 8AF9
SAF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1234
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1234
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1234:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1234
sub ebx,ecx
add edi,byte 2
.nsbhd1234:
dec al
jnz short .detloop1234
xor ebx,ebx
sub edi,byte 88
jmp near execend
ov1234:
mov ax,1
sub edi,byte 22
jmp near execend
zex1234:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1235
call basefunction
ln1235:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 8AFA
SAFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1236
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1236
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1236:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1236
sub ebx,ecx
add edi,byte 2
.nsbhd1236:
dec al
jnz short .detloop1236
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1236:
mov ax,1
sub edi,byte 18
jmp near execend
zex1236:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1237
call basefunction
ln1237:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 8AFB
SAFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1238
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1238
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1238:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1238
sub ebx,ecx
add edi,byte 2
.nsbhd1238:
dec al
jnz short .detloop1238
xor ebx,ebx
sub edi,byte 86
jmp near execend
ov1238:
mov ax,1
sub edi,byte 20
jmp near execend
zex1238:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1239
call basefunction
ln1239:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 8AFC
SAFC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1240
mov eax,[__dreg+20]
shl ecx,16
cmp eax,ecx
jae short ov1240
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
mov al,15
pop ecx
shl ecx,16
.detloop1240:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1240
sub ebx,ecx
add edi,byte 2
.nsbhd1240:
dec al
jnz short .detloop1240
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1240:
mov ax,1
sub edi,byte 14
jmp near execend
zex1240:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1241
call basefunction
ln1241:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8B00 - 8B07
SB00:
and ebx,byte 7
mov ch,ah
shr byte[__xflag],1
mov eax,[__dreg+20]
sbb al,[__dreg+ebx*4]
mov cl,al
das
mov [__dreg+20],al
lahf
setc [__xflag]
jnz short ln1242
or ch,0BFh
and ah,ch
ln1242:
test al,al
jns short ln1243
xor al,al
jmp short ln1244
ln1243:
test cl,cl
sets al
ln1244:
sub edi,byte 6
jmp near execend
; Opcodes 8B08 - 8B0F
SB08:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
mov ebx,ecx
mov edx,[__areg+20]
dec edx
call readmemorybyte
xchg ecx,eax
shr byte[__xflag],1
sbb al,bl
mov cl,al
das
mov ebx,eax
lahf
setc [__xflag]
jnz short ln1245
or ch,0BFh
and ah,ch
ln1245:
test al,al
jns short ln1246
xor al,al
jmp short ln1247
ln1246:
test cl,cl
sets al
ln1247:
mov ecx,ebx
xor ebx,ebx
call writememorybyte
mov [__areg+20],edx
sub edi,byte 18
jmp near execend
; Opcodes 8B10 - 8B17
SB10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
sub edi,byte 12
jmp near execend
; Opcodes 8B18 - 8B1F
SB18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8B20 - 8B27
SB20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8B28 - 8B2F
SB28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcodes 8B30 - 8B37
SB30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
sub edi,byte 18
jmp near execend
; Opcode 8B38
SB38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
sub edi,byte 16
jmp near execend
; Opcode 8B39
SB39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or cl,[__dreg+20]
lahf
xor al,al
call writememorybyte
sub edi,byte 20
jmp near execend
; Opcodes 8B50 - 8B57
SB50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
sub edi,byte 12
jmp near execend
; Opcodes 8B58 - 8B5F
SB58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
add edx,byte 2
mov [__areg+ebx*4],edx
sub edi,byte 12
jmp near execend
; Opcodes 8B60 - 8B67
SB60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
mov [__areg+ebx*4],edx
sub edi,byte 14
jmp near execend
; Opcodes 8B68 - 8B6F
SB68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcodes 8B70 - 8B77
SB70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
sub edi,byte 18
jmp near execend
; Opcode 8B78
SB78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
sub edi,byte 16
jmp near execend
; Opcode 8B79
SB79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or cx,[__dreg+20]
lahf
xor al,al
call writememoryword
sub edi,byte 20
jmp near execend
; Opcodes 8B90 - 8B97
SB90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
sub edi,byte 20
jmp near execend
; Opcodes 8B98 - 8B9F
SB98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
add edx,byte 4
mov [__areg+ebx*4],edx
sub edi,byte 20
jmp near execend
; Opcodes 8BA0 - 8BA7
SBA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
mov [__areg+ebx*4],edx
sub edi,byte 22
jmp near execend
; Opcodes 8BA8 - 8BAF
SBA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcodes 8BB0 - 8BB7
SBB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
sub edi,byte 26
jmp near execend
; Opcode 8BB8
SBB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
sub edi,byte 24
jmp near execend
; Opcode 8BB9
SBB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or ecx,[__dreg+20]
lahf
xor al,al
call writememorydword
sub edi,byte 28
jmp near execend
; Opcodes 8BC0 - 8BC7
SBC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1248
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1248
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1248
test ebx,ebx
js short .ndivd1248
add edi,byte 4
.ndivd1248:
sub edi,byte 2
.ndivs1248:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1248
neg dx
.dsetloop1248:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1248
xor ebx,ebx
sub edi,byte 122
jmp near execend
ov1248:
mov ax,1
sub edi,byte 16
jmp near execend
zex1248:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1249
call basefunction
ln1249:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 8BD0 - 8BD7
SBD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1250
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1250
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1250
test ebx,ebx
js short .ndivd1250
add edi,byte 4
.ndivd1250:
sub edi,byte 2
.ndivs1250:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1250
neg dx
.dsetloop1250:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1250
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1250:
mov ax,1
sub edi,byte 20
jmp near execend
zex1250:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1251
call basefunction
ln1251:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8BD8 - 8BDF
SBD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1252
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1252
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1252
test ebx,ebx
js short .ndivd1252
add edi,byte 4
.ndivd1252:
sub edi,byte 2
.ndivs1252:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1252
neg dx
.dsetloop1252:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1252
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1252:
mov ax,1
sub edi,byte 20
jmp near execend
zex1252:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1253
call basefunction
ln1253:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8BE0 - 8BE7
SBE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1254
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1254
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1254
test ebx,ebx
js short .ndivd1254
add edi,byte 4
.ndivd1254:
sub edi,byte 2
.ndivs1254:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1254
neg dx
.dsetloop1254:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1254
xor ebx,ebx
sub edi,128
jmp near execend
ov1254:
mov ax,1
sub edi,byte 22
jmp near execend
zex1254:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1255
call basefunction
ln1255:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 8BE8 - 8BEF
SBE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1256
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1256
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1256
test ebx,ebx
js short .ndivd1256
add edi,byte 4
.ndivd1256:
sub edi,byte 2
.ndivs1256:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1256
neg dx
.dsetloop1256:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1256
xor ebx,ebx
sub edi,130
jmp near execend
ov1256:
mov ax,1
sub edi,byte 24
jmp near execend
zex1256:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1257
call basefunction
ln1257:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcodes 8BF0 - 8BF7
SBF0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1258
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1258
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1258
test ebx,ebx
js short .ndivd1258
add edi,byte 4
.ndivd1258:
sub edi,byte 2
.ndivs1258:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1258
neg dx
.dsetloop1258:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1258
xor ebx,ebx
sub edi,132
jmp near execend
ov1258:
mov ax,1
sub edi,byte 26
jmp near execend
zex1258:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1259
call basefunction
ln1259:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 8BF8
SBF8:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1260
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1260
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1260
test ebx,ebx
js short .ndivd1260
add edi,byte 4
.ndivd1260:
sub edi,byte 2
.ndivs1260:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1260
neg dx
.dsetloop1260:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1260
xor ebx,ebx
sub edi,130
jmp near execend
ov1260:
mov ax,1
sub edi,byte 24
jmp near execend
zex1260:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1261
call basefunction
ln1261:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 8BF9
SBF9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
test cx,cx
jz near zex1262
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1262
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1262
test ebx,ebx
js short .ndivd1262
add edi,byte 4
.ndivd1262:
sub edi,byte 2
.ndivs1262:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1262
neg dx
.dsetloop1262:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1262
xor ebx,ebx
sub edi,134
jmp near execend
ov1262:
mov ax,1
sub edi,byte 28
jmp near execend
zex1262:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1263
call basefunction
ln1263:
add esi,ebp
sub edi,byte 50
jmp near execend
; Opcode 8BFA
SBFA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
test cx,cx
jz near zex1264
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1264
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1264
test ebx,ebx
js short .ndivd1264
add edi,byte 4
.ndivd1264:
sub edi,byte 2
.ndivs1264:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1264
neg dx
.dsetloop1264:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1264
xor ebx,ebx
sub edi,130
jmp near execend
ov1264:
mov ax,1
sub edi,byte 24
jmp near execend
zex1264:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1265
call basefunction
ln1265:
add esi,ebp
sub edi,byte 46
jmp near execend
; Opcode 8BFB
SBFB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
test cx,cx
jz near zex1266
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1266
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1266
test ebx,ebx
js short .ndivd1266
add edi,byte 4
.ndivd1266:
sub edi,byte 2
.ndivs1266:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1266
neg dx
.dsetloop1266:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1266
xor ebx,ebx
sub edi,132
jmp near execend
ov1266:
mov ax,1
sub edi,byte 26
jmp near execend
zex1266:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1267
call basefunction
ln1267:
add esi,ebp
sub edi,byte 48
jmp near execend
; Opcode 8BFC
SBFC:
mov cx,[esi]
add esi,byte 2
test cx,cx
jz near zex1268
mov eax,[__dreg+20]
shl ecx,16
mov edx,ecx
cmp eax,edx
setbe bl
neg edx
cmp eax,edx
setbe bh
xor bl,bh
jnz short ov1268
sar ecx,16
cdq
xor ebx,ebx
test eax,eax
sets bl
shl bl,1
sub edi,ebx
push ecx
mov ebx,eax
idiv ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+20],edx
pop ecx
test cx,cx
js short .ndivs1268
test ebx,ebx
js short .ndivd1268
add edi,byte 4
.ndivd1268:
sub edi,byte 2
.ndivs1268:
mov al,15
test cx,cx
sets cl
test ebx,ebx
sets ch
xor ebx,ebx
xor cl,ch
jz short .dsetloop1268
neg dx
.dsetloop1268:
test dx,dx
setns bl
shl bl,1
sub edi,ebx
shl edx,1
dec al
jnz short .dsetloop1268
xor ebx,ebx
sub edi,byte 126
jmp near execend
ov1268:
mov ax,1
sub edi,byte 20
jmp near execend
zex1268:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1269
call basefunction
ln1269:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8C00 - 8C07
SC00:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8C10 - 8C17
SC10:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C18 - 8C1F
SC18:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorybyte
cmp bl,7
sbb edx,byte -2
mov [__areg+ebx*4],edx
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C20 - 8C27
SC20:
and ebx,byte 7
mov edx,[__areg+ebx*4]
cmp bl,7
adc edx,byte -2
call readmemorybyte
mov [__areg+ebx*4],edx
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8C28 - 8C2F
SC28:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8C30 - 8C37
SC30:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8C38
SC38:
movsx edx,word[esi]
add esi,byte 2
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8C39
SC39:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 8C3A
SC3A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8C3B
SC3B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorybyte
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8C3C
SC3C:
mov cx,[esi]
add esi,byte 2
or [__dreg+24],cl
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C40 - 8C47
SC40:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 4
jmp near execend
; Opcodes 8C50 - 8C57
SC50:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C58 - 8C5F
SC58:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C60 - 8C67
SC60:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 10
jmp near execend
; Opcodes 8C68 - 8C6F
SC68:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcodes 8C70 - 8C77
SC70:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8C78
SC78:
movsx edx,word[esi]
add esi,byte 2
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8C79
SC79:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcode 8C7A
SC7A:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 12
jmp near execend
; Opcode 8C7B
SC7B:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemoryword
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcode 8C7C
SC7C:
mov cx,[esi]
add esi,byte 2
or [__dreg+24],cx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C80 - 8C87
SC80:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 8
jmp near execend
; Opcodes 8C90 - 8C97
SC90:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8C98 - 8C9F
SC98:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemorydword
add edx,byte 4
mov [__areg+ebx*4],edx
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 14
jmp near execend
; Opcodes 8CA0 - 8CA7
SCA0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 4
call readmemorydword
mov [__areg+ebx*4],edx
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 8CA8 - 8CAF
SCA8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcodes 8CB0 - 8CB7
SCB0:
and ebx,byte 7
call decode_ext
add edx,[__areg+ebx*4]
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 8CB8
SCB8:
movsx edx,word[esi]
add esi,byte 2
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 8CB9
SCB9:
mov edx,[esi]
add esi,byte 4
rol edx,16
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 22
jmp near execend
; Opcode 8CBA
SCBA:
movsx edx,word[esi]
add edx,esi
sub edx,ebp
add esi,byte 2
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 18
jmp near execend
; Opcode 8CBB
SCBB:
call decode_ext
add edx,esi
sub edx,ebp
sub edx,byte 2
call readmemorydword
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 20
jmp near execend
; Opcode 8CBC
SCBC:
mov ecx,[esi]
add esi,byte 4
rol ecx,16
or [__dreg+24],ecx
lahf
xor al,al
sub edi,byte 16
jmp near execend
; Opcodes 8CC0 - 8CC7
SCC0:
and ebx,byte 7
mov ecx,[__dreg+ebx*4]
test cx,cx
jz near zex1270
mov eax,[__dreg+24]
shl ecx,16
cmp eax,ecx
jae short ov1270
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+24],edx
mov al,15
pop ecx
shl ecx,16
.detloop1270:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1270
sub ebx,ecx
add edi,byte 2
.nsbhd1270:
dec al
jnz short .detloop1270
xor ebx,ebx
sub edi,byte 76
jmp near execend
ov1270:
mov ax,1
sub edi,byte 10
jmp near execend
zex1270:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1271
call basefunction
ln1271:
add esi,ebp
sub edi,byte 38
jmp near execend
; Opcodes 8CD0 - 8CD7
SCD0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1272
mov eax,[__dreg+24]
shl ecx,16
cmp eax,ecx
jae short ov1272
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+24],edx
mov al,15
pop ecx
shl ecx,16
.detloop1272:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1272
sub ebx,ecx
add edi,byte 2
.nsbhd1272:
dec al
jnz short .detloop1272
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1272:
mov ax,1
sub edi,byte 14
jmp near execend
zex1272:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1273
call basefunction
ln1273:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8CD8 - 8CDF
SCD8:
and ebx,byte 7
mov edx,[__areg+ebx*4]
call readmemoryword
add edx,byte 2
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1274
mov eax,[__dreg+24]
shl ecx,16
cmp eax,ecx
jae short ov1274
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+24],edx
mov al,15
pop ecx
shl ecx,16
.detloop1274:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1274
sub ebx,ecx
add edi,byte 2
.nsbhd1274:
dec al
jnz short .detloop1274
xor ebx,ebx
sub edi,byte 80
jmp near execend
ov1274:
mov ax,1
sub edi,byte 14
jmp near execend
zex1274:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1275
call basefunction
ln1275:
add esi,ebp
sub edi,byte 42
jmp near execend
; Opcodes 8CE0 - 8CE7
SCE0:
and ebx,byte 7
mov edx,[__areg+ebx*4]
sub edx,byte 2
call readmemoryword
mov [__areg+ebx*4],edx
test cx,cx
jz near zex1276
mov eax,[__dreg+24]
shl ecx,16
cmp eax,ecx
jae short ov1276
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+24],edx
mov al,15
pop ecx
shl ecx,16
.detloop1276:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1276
sub ebx,ecx
add edi,byte 2
.nsbhd1276:
dec al
jnz short .detloop1276
xor ebx,ebx
sub edi,byte 82
jmp near execend
ov1276:
mov ax,1
sub edi,byte 16
jmp near execend
zex1276:
mov edx,14h
call group_2_exception
and esi,16777215
mov ecx,esi
shr ecx,12
cmp cx,word[__fetch_bank]
je short ln1277
call basefunction
ln1277:
add esi,ebp
sub edi,byte 44
jmp near execend
; Opcodes 8CE8 - 8CEF
SCE8:
and ebx,byte 7
movsx edx,word[esi]
add esi,byte 2
add edx,[__areg+ebx*4]
call readmemoryword
test cx,cx
jz near zex1278
mov eax,[__dreg+24]
shl ecx,16
cmp eax,ecx
jae short ov1278
shr ecx,16
xor edx,edx
push ecx
mov ebx,eax
div ecx
shl edx,16
mov dx,ax
test dx,dx
lahf
xor al,al
mov [__dreg+24],edx
mov al,15
pop ecx
shl ecx,16
.detloop1278:
shl ebx,1
sub edi,byte 4
cmp ebx,ecx
jb short .nsbhd1278
sub ebx,ecx
add edi,byte 2
.nsbhd1278:
dec al
jnz short .detloop1278
xor ebx,ebx
sub edi,byte 84
jmp near execend
ov1278:
mov ax,1
sub edi,byte 18
jmp near execend
zex1278: