onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /ff_top_tb/clk
add wave -noupdate -format Logic /ff_top_tb/reset
add wave -noupdate -format Literal /ff_top_tb/sw
add wave -noupdate -format Logic /ff_top_tb/led1
add wave -noupdate -format Logic /ff_top_tb/led2
add wave -noupdate -format Literal -radix hexadecimal /ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/pc_out
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[0]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[1]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[2]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[3]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[4]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[5]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[6]}
add wave -noupdate -format Literal -radix hexadecimal {/ff_top_tb/uut/ff/cpu/wf68k00ip_top/i_68k00/i_datareg/dr[7]}
add wave -noupdate -format Literal /ff_top_tb/uut/ff/ud_in
add wave -noupdate -format Literal /ff_top_tb/uut/ff/ud_out
add wave -noupdate -format Logic /ff_top_tb/uut/ff/uds_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/lds_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/as_n
add wave -noupdate -format Literal /ff_top_tb/uut/ff/a
add wave -noupdate -format Literal /ff_top_tb/uut/ff/fc
add wave -noupdate -format Logic /ff_top_tb/uut/ff/membufen_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/u_n_v
add wave -noupdate -format Logic /ff_top_tb/uut/ff/analogin_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/audio0_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/audio1_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/audio2_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/digitalin_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/nvram_n
add wave -noupdate -divider <NULL>
add wave -noupdate -format Logic /ff_top_tb/uut/ff/analogout_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/coloram_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/recall_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/watchdog_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/objram_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/rom0_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/rom1_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/rom2_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/rom3_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/ram0_n
add wave -noupdate -format Logic /ff_top_tb/uut/ff/ram1_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {77889611 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {77889526 ns} {77890030 ns}
