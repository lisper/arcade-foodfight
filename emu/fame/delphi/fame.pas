///////////////////////////////////////////////////////////////////////////////
// FAME Motorola 68000 Emulation Library - Pascal Implementation File
// Oscar Orallo Pelaez
// Version: 2.0a
// Date: 03-14-2006
///////////////////////////////////////////////////////////////////////////////

unit fame;

interface

    const   M68K_OK = 0;
            M68K_RUNNING = 1;
            M68K_NO_SUP_ADDR_SPACE = 2;
            M68K_DOUBLE_BUS_FAULT = -1;
            M68K_INV_REG = -1;

            // Hardware interrupt state
            M68K_IRQ_LEVEL_ERROR = -1;
            M68K_IRQ_INV_PARAMS = -2;

            // Consts to specify hardware interrupt type
            M68K_AUTOVECTORED_IRQ = -1;
            M68K_SPURIOUS_IRQ     = -2;

            // Defines to specify address space
            M68K_SUP_ADDR_SPACE  = 0;
            M68K_USER_ADDR_SPACE = 2;
            M68K_PROG_ADDR_SPACE = 0;
            M68K_DATA_ADDR_SPACE = 1;


// M68K registers
type m68k_register = (
      M68K_REG_D0=0,
      M68K_REG_D1,
      M68K_REG_D2,
      M68K_REG_D3,
      M68K_REG_D4,
      M68K_REG_D5,
      M68K_REG_D6,
      M68K_REG_D7,
      M68K_REG_A0,
      M68K_REG_A1,
      M68K_REG_A2,
      M68K_REG_A3,
      M68K_REG_A4,
      M68K_REG_A5,
      M68K_REG_A6,
      M68K_REG_A7,
      M68K_REG_PC,
      M68K_REG_SR,
      M68K_REG_SSP,
      M68K_REG_USP);

// The memory blocks must be in native (Motorola) format
type
 M68K_PROGRAM = RECORD
	            low_addr: longword;
	            high_addr: longword;
	            offset: longword;
                END;


// The memory blocks must be in native (Motorola) format
type
 M68K_DATA = RECORD
	         low_addr: longword;
	         high_addr: longword;
	         mem_handler: pointer;
	         data: pointer;
             END;


// Reset Procedure
type
    tResetProcedure = procedure;
    tIackProcedure = procedure;


// M68K CONTEXT
type
 M68K_CONTEXT = RECORD
			fetch: ^M68K_PROGRAM;
			read_byte: ^M68K_DATA;
			read_word: ^M68K_DATA;
			write_byte: ^M68K_DATA;
			write_word: ^M68K_DATA;
			sv_fetch: ^M68K_PROGRAM;
			sv_read_byte: ^M68K_DATA;
			sv_read_word: ^M68K_DATA;
			sv_write_byte: ^M68K_DATA;
			sv_write_word: ^M68K_DATA;
			user_fetch: ^M68K_PROGRAM;
			user_read_byte: ^M68K_DATA;
			user_read_word: ^M68K_DATA;
			user_write_byte: ^M68K_DATA;
			user_write_word: ^M68K_DATA;
			reset_handler: tResetProcedure;
			iack_handler: tIackProcedure;
			icust_handler: ^longword;
			dreg: array[0..7] of longword;
			areg: array[0..7] of longword;
			pc: longword;
			asp: longword;
			cycles_counter: longword;
			interrupts: array[0..7] of byte;
			sr: word;
			execinfo: word;
                END;


    // General Purpose Functions
    procedure m68k_init; cdecl; external 'fame.dll' name '_m68k_init';
    function m68k_reset: longword; cdecl; external 'fame.dll' name '_m68k_reset';
    procedure m68k_emulate (n: longint); cdecl; external 'fame.dll' name '_m68k_emulate';
    function m68k_get_pc: longword; cdecl; external 'fame.dll' name '_m68k_get_pc';
    function m68k_get_cpu_state: longword; cdecl; external 'fame.dll' name '_m68k_get_cpu_state';
    function m68k_fetch(address, memory_space: longword): longint; cdecl; external 'fame.dll' name '_m68k_fetch';

    // Hardware interrupt handling functions
    function m68k_raise_irq(level, vector: longint):longint; cdecl; external 'fame.dll' name '_m68k_raise_irq';
    function m68k_lower_irq(level: longint):longint; cdecl; external 'fame.dll' name '_m68k_lower_irq';
    function m68k_get_irq_vector(level: longint):longint; cdecl; external 'fame.dll' name '_m68k_get_irq_vector';
    function m68k_change_irq_vector(level, vector: longint):longint; cdecl; external 'fame.dll' name '_m68k_change_irq_vector';

    // CPU context handling functions
    function m68k_get_context_size: longint; cdecl; external 'fame.dll' name '_m68k_get_context_size';
    procedure m68k_get_context(context: pointer); cdecl; external 'fame.dll' name '_m68k_get_context';
    procedure m68k_set_context(context: pointer); cdecl; external 'fame.dll' name '_m68k_set_context';
    function m68k_get_register(reg: m68k_register):longint; cdecl; external 'fame.dll' name '_m68k_get_register';
    function m68k_set_register(reg: m68k_register; value: longword):longint; cdecl; external 'fame.dll' name '_m68k_set_register';

    // Timing functions
    function m68k_get_cycles_counter:longword; cdecl; external 'fame.dll' name '_m68k_get_cycles_counter';
    function m68k_trip_cycles_counter:longword; cdecl; external 'fame.dll' name '_m68k_trip_cycles_counter';
    function m68k_control_cycles_counter(n: longint): longword; cdecl; external 'fame.dll' name '_m68k_control_cycles_counter';
    procedure m68k_release_timeslice; cdecl; external 'fame.dll' name '_m68k_release_timeslice';
    procedure m68k_add_cycles(cycles: longint); cdecl; external 'fame.dll' name '_m68k_add_cycles';
    procedure m68k_release_cycles(cycles: longint); cdecl; external 'fame.dll' name '_m68k_release_cycles';

implementation

end.
