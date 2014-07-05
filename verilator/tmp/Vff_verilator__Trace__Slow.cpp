// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vff_verilator__Syms.h"


//======================

void Vff_verilator::trace (VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback (&Vff_verilator::traceInit, &Vff_verilator::traceFull, &Vff_verilator::traceChg, this);
}
void Vff_verilator::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    Vff_verilator* t=(Vff_verilator*)userthis;
    Vff_verilator__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) vl_fatal(__FILE__,__LINE__,__FILE__,"Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    vcdp->scopeEscape(' ');
    t->traceInitThis (vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void Vff_verilator::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vff_verilator* t=(Vff_verilator*)userthis;
    Vff_verilator__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    t->traceFullThis (vlSymsp, vcdp, code);
}

//======================


void Vff_verilator::traceInitThis(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name()); // Setup signal names
    // Body
    {
	vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void Vff_verilator::traceFullThis(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = VL_ULL(0);
}

void Vff_verilator::traceInitThis__1(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->declBit  (c+1041,"v CLK",-1);
	vcdp->declBit  (c+1042,"v clk25",-1);
	vcdp->declBit  (c+1043,"v clk12",-1);
	vcdp->declBit  (c+1044,"v reset",-1);
	vcdp->declBit  (c+513,"v hsync",-1);
	vcdp->declBit  (c+660,"v vsync",-1);
	vcdp->declBus  (c+541,"v rgb",-1,7,0);
	vcdp->declBit  (c+1033,"v led1",-1);
	vcdp->declBit  (c+1034,"v led2",-1);
	vcdp->declBus  (c+1045,"v sw",-1,9,0);
	vcdp->declBus  (c+1046,"v sw1",-1,8,1);
	vcdp->declBit  (c+1043,"v pixclk",-1);
	vcdp->declBus  (c+542,"v pxd",-1,31,0);
	vcdp->declBus  (c+514,"v hs",-1,31,0);
	vcdp->declBus  (c+661,"v vs",-1,31,0);
	vcdp->declBus  (c+543,"v vgaBlue",-1,2,0);
	vcdp->declBus  (c+544,"v vgaGreen",-1,2,0);
	vcdp->declBus  (c+545,"v vgaRed",-1,2,0);
	vcdp->declBit  (c+1043,"v uut clk12m",-1);
	vcdp->declBit  (c+1044,"v uut reset",-1);
	vcdp->declBit  (c+1033,"v uut led1",-1);
	vcdp->declBit  (c+1034,"v uut led2",-1);
	vcdp->declBit  (c+513,"v uut hsync",-1);
	vcdp->declBit  (c+660,"v uut vsync",-1);
	vcdp->declBus  (c+541,"v uut rgb",-1,7,0);
	vcdp->declBus  (c+1045,"v uut sw",-1,9,0);
	vcdp->declBus  (c+1046,"v uut sw1",-1,8,1);
	vcdp->declBit  (c+1043,"v uut ff clk_12mhz",-1);
	vcdp->declBit  (c+1044,"v uut ff reset",-1);
	vcdp->declBit  (c+1047,"v uut ff test",-1);
	vcdp->declBit  (c+1048,"v uut ff throw2",-1);
	vcdp->declBit  (c+1049,"v uut ff throw1",-1);
	vcdp->declBit  (c+1050,"v uut ff coinaux",-1);
	vcdp->declBit  (c+1051,"v uut ff start2",-1);
	vcdp->declBit  (c+1052,"v uut ff start1",-1);
	vcdp->declBit  (c+1053,"v uut ff coin2",-1);
	vcdp->declBit  (c+1054,"v uut ff coin1",-1);
	vcdp->declBit  (c+1055,"v uut ff cntrr",-1);
	vcdp->declBit  (c+1056,"v uut ff cntrl",-1);
	vcdp->declBus  (c+1046,"v uut ff sw1",-1,8,1);
	vcdp->declBit  (c+1033,"v uut ff o_led1",-1);
	vcdp->declBit  (c+1034,"v uut ff o_led2",-1);
	vcdp->declBit  (c+513,"v uut ff o_hsync",-1);
	vcdp->declBit  (c+660,"v uut ff o_vsync",-1);
	vcdp->declBus  (c+541,"v uut ff o_rgb",-1,7,0);
	vcdp->declBit  (c+538,"v uut ff o_compsync",-1);
	vcdp->declBus  (c+17,"v uut ff a",-1,23,0);
	vcdp->declBus  (c+18,"v uut ff ud_in",-1,15,0);
	vcdp->declBus  (c+19,"v uut ff ud_out",-1,15,0);
	vcdp->declBit  (c+20,"v uut ff r_w_n",-1);
	vcdp->declBit  (c+21,"v uut ff uds_n",-1);
	vcdp->declBit  (c+22,"v uut ff lds_n",-1);
	vcdp->declBit  (c+23,"v uut ff as_n",-1);
	vcdp->declBit  (c+697,"v uut ff vma_n",-1);
	vcdp->declBit  (c+317,"v uut ff avec_n",-1);
	vcdp->declBus  (c+318,"v uut ff fc",-1,2,0);
	vcdp->declBit  (c+1057,"v uut ff halt_n",-1);
	vcdp->declBit  (c+1058,"v uut ff reset_n",-1);
	vcdp->declBit  (c+472,"v uut ff il3",-1);
	vcdp->declBit  (c+385,"v uut ff il4",-1);
	vcdp->declBit  (c+693,"v uut ff e",-1);
	vcdp->declBit  (c+546,"v uut ff membufen_n",-1);
	vcdp->declBit  (c+1015,"v uut ff u_n_v",-1);
	vcdp->declBit  (c+24,"v uut ff analogin_n",-1);
	vcdp->declBit  (c+25,"v uut ff audio0_n",-1);
	vcdp->declBit  (c+26,"v uut ff digitalin_n",-1);
	vcdp->declBit  (c+27,"v uut ff nvram_n",-1);
	vcdp->declBus  (c+28,"v uut ff nvram_out",-1,3,0);
	vcdp->declBus  (c+1059,"v uut ff digital_out",-1,7,0);
	vcdp->declBus  (c+29,"v uut ff pokey_out",-1,7,0);
	vcdp->declBus  (c+30,"v uut ff pf_out",-1,15,0);
	vcdp->declBus  (c+31,"v uut ff mb_out",-1,15,0);
	vcdp->declBus  (c+19,"v uut ff bd_out",-1,15,0);
	vcdp->declBus  (c+32,"v uut ff ba",-1,15,0);
	vcdp->declBit  (c+20,"v uut ff br_w_n",-1);
	vcdp->declBit  (c+33,"v uut ff r_w_u_n",-1);
	vcdp->declBit  (c+34,"v uut ff r_w_l_n",-1);
	vcdp->declBit  (c+35,"v uut ff r_n_w",-1);
	vcdp->declBit  (c+36,"v uut ff as",-1);
	vcdp->declBit  (c+323,"v uut ff mdtack_n",-1);
	vcdp->declBit  (c+473,"v uut ff il3_n",-1);
	vcdp->declBit  (c+386,"v uut ff il4_n",-1);
	vcdp->declBit  (c+37,"v uut ff dtack_n",-1);
	vcdp->declBit  (c+690,"v uut ff u_n_v_d",-1);
	vcdp->declBit  (c+38,"v uut ff mpuclk",-1);
	vcdp->declBit  (c+1035,"v uut ff int4rst_n",-1);
	vcdp->declBit  (c+662,"v uut ff vblank",-1);
	vcdp->declBit  (c+1036,"v uut ff int3rst_n",-1);
	vcdp->declBit  (c+388,"v uut ff s_32v",-1);
	vcdp->declBit  (c+1037,"v uut ff counterr",-1);
	vcdp->declBit  (c+1038,"v uut ff counterl",-1);
	vcdp->declBit  (c+1034,"v uut ff led2",-1);
	vcdp->declBit  (c+1033,"v uut ff led1",-1);
	vcdp->declBit  (c+1039,"v uut ff update",-1);
	vcdp->declBit  (c+1040,"v uut ff pfflip",-1);
	vcdp->declBit  (c+39,"v uut ff s_ctrl",-1);
	vcdp->declBit  (c+513,"v uut ff hsync_new",-1);
	vcdp->declBit  (c+660,"v uut ff vsync",-1);
	vcdp->declBit  (c+538,"v uut ff compsync",-1);
	vcdp->declBus  (c+541,"v uut ff rgb",-1,7,0);
	vcdp->declBit  (c+40,"v uut ff audio2_n",-1);
	vcdp->declBit  (c+41,"v uut ff audio1_n",-1);
	vcdp->declBit  (c+42,"v uut ff vpa_n",-1);
	vcdp->declBit  (c+43,"v uut ff rom0_n",-1);
	vcdp->declBit  (c+44,"v uut ff rom1_n",-1);
	vcdp->declBit  (c+45,"v uut ff rom2_n",-1);
	vcdp->declBit  (c+46,"v uut ff rom3_n",-1);
	vcdp->declBit  (c+47,"v uut ff ram0_n",-1);
	vcdp->declBit  (c+48,"v uut ff ram1_n",-1);
	vcdp->declBit  (c+49,"v uut ff objram_n",-1);
	vcdp->declBit  (c+50,"v uut ff watchdog_n",-1);
	vcdp->declBit  (c+51,"v uut ff recall_n",-1);
	vcdp->declBit  (c+52,"v uut ff coloram_n",-1);
	vcdp->declBit  (c+53,"v uut ff analogout_n",-1);
	vcdp->declBit  (c+54,"v uut ff i_o_n",-1);
	vcdp->declBit  (c+55,"v uut ff pf_n",-1);
	vcdp->declBit  (c+1016,"v uut ff u_v_n",-1);
	vcdp->declBit  (c+56,"v uut ff s_4h",-1);
	vcdp->declBit  (c+57,"v uut ff s_8h",-1);
	vcdp->declBus  (c+58,"v uut ff mb_out_rom",-1,15,0);
	vcdp->declBus  (c+59,"v uut ff mb_out_ram",-1,15,0);
	vcdp->declBus  (c+515,"v uut ff cnt_h",-1,11,0);
	vcdp->declBus  (c+712,"v uut ff counter_h",-1,11,0);
	vcdp->declBit  (c+516,"v uut ff counter_h_clr",-1);
	vcdp->declBit  (c+517,"v uut ff counter_h_counting",-1);
	vcdp->declBit  (c+518,"v uut ff hsync_new_on",-1);
	vcdp->declBit  (c+60,"v uut ff s_6mhz",-1);
	vcdp->declBit  (c+38,"v uut ff s_6m_n",-1);
	vcdp->declBit  (c+713,"v uut ff s_1h",-1);
	vcdp->declBit  (c+714,"v uut ff s_2h",-1);
	vcdp->declBit  (c+715,"v uut ff s_16h",-1);
	vcdp->declBit  (c+61,"v uut ff s_32h",-1);
	vcdp->declBit  (c+716,"v uut ff s_64h",-1);
	vcdp->declBit  (c+717,"v uut ff s_128h",-1);
	vcdp->declBit  (c+718,"v uut ff s_256h",-1);
	vcdp->declBit  (c+719,"v uut ff s_2h_n",-1);
	vcdp->declBit  (c+62,"v uut ff s_4h_n",-1);
	vcdp->declBus  (c+698,"v uut ff counter_v",-1,7,0);
	vcdp->declBit  (c+63,"v uut ff s_256h_n",-1);
	vcdp->declBit  (c+663,"v uut ff vpreset_n",-1);
	vcdp->declBit  (c+699,"v uut ff s_1v",-1);
	vcdp->declBit  (c+700,"v uut ff s_2v",-1);
	vcdp->declBit  (c+701,"v uut ff s_4v",-1);
	vcdp->declBit  (c+702,"v uut ff s_8v",-1);
	vcdp->declBit  (c+703,"v uut ff s_16v",-1);
	vcdp->declBit  (c+704,"v uut ff s_64v",-1);
	vcdp->declBit  (c+389,"v uut ff s_128v",-1);
	vcdp->declBus  (c+64,"v uut ff prom_2b_addr",-1,7,0);
	vcdp->declBus  (c+65,"v uut ff prom_out",-1,3,0);
	vcdp->declBit  (c+664,"v uut ff vblank_n",-1);
	vcdp->declBit  (c+665,"v uut ff vsync_n",-1);
	vcdp->declBit  (c+666,"v uut ff vpreset",-1);
	vcdp->declBit  (c+524,"v uut ff hsync",-1);
	vcdp->declBit  (c+688,"v uut ff hsync_clr_n",-1);
	vcdp->declBit  (c+689,"v uut ff hsync_clr",-1);
	vcdp->declBit  (c+66,"v uut ff blank_n",-1);
	vcdp->declBus  (c+67,"v uut ff pfa",-1,9,0);
	vcdp->declBit  (c+334,"v uut ff csu_n",-1);
	vcdp->declBit  (c+335,"v uut ff csl_n",-1);
	vcdp->declBit  (c+336,"v uut ff s_4hf",-1);
	vcdp->declBit  (c+705,"v uut ff s_4vf",-1);
	vcdp->declBit  (c+706,"v uut ff s_2vf",-1);
	vcdp->declBit  (c+707,"v uut ff s_1vf",-1);
	vcdp->declBit  (c+68,"v uut ff pfwr_n",-1);
	vcdp->declBus  (c+1017,"v uut ff pf_rom_a",-1,11,4);
	vcdp->declBus  (c+69,"v uut ff pf_data",-1,7,0);
	vcdp->declBus  (c+70,"v uut ff pf_rom_addr",-1,12,0);
	vcdp->declBus  (c+525,"v uut ff pf_shift",-1,7,0);
	vcdp->declBit  (c+71,"v uut ff pf_s0",-1);
	vcdp->declBit  (c+720,"v uut ff pf_s1",-1);
	vcdp->declBus  (c+540,"v uut ff pfv_lower",-1,1,0);
	vcdp->declBus  (c+1032,"v uut ff pf_out_h_hold",-1,7,0);
	vcdp->declBus  (c+1018,"v uut ff pfv_hold",-1,7,2);
	vcdp->declBus  (c+539,"v uut ff pfv",-1,7,0);
	vcdp->declBus  (c+72,"v uut ff moram_addr",-1,6,0);
	vcdp->declBus  (c+73,"v uut ff mod",-1,15,0);
	vcdp->declBit  (c+74,"v uut ff lwr_n",-1);
	vcdp->declBit  (c+75,"v uut ff uwr_n",-1);
	vcdp->declBus  (c+76,"v uut ff sum",-1,7,0);
	vcdp->declBit  (c+77,"v uut ff match_v",-1);
	vcdp->declBit  (c+670,"v uut ff s_1vx",-1);
	vcdp->declBit  (c+671,"v uut ff s_1vx_n",-1);
	vcdp->declBit  (c+1060,"v uut ff clk_1vx",-1);
	vcdp->declBus  (c+547,"v uut ff ol",-1,3,0);
	vcdp->declBus  (c+548,"v uut ff ol_hold",-1,3,0);
	vcdp->declBit  (c+549,"v uut ff match",-1);
	vcdp->declBit  (c+307,"v uut ff oddld_n",-1);
	vcdp->declBit  (c+673,"v uut ff oddclr_n",-1);
	vcdp->declBit  (c+674,"v uut ff evenclr_n",-1);
	vcdp->declBit  (c+308,"v uut ff evenld_n",-1);
	vcdp->declBit  (c+78,"v uut ff oddclk",-1);
	vcdp->declBit  (c+79,"v uut ff evencs_n",-1);
	vcdp->declBit  (c+80,"v uut ff oddcs_n",-1);
	vcdp->declBit  (c+81,"v uut ff evenclk",-1);
	vcdp->declBit  (c+550,"v uut ff vflip",-1);
	vcdp->declBit  (c+82,"v uut ff hload_n",-1);
	vcdp->declBit  (c+383,"v uut ff bg",-1);
	vcdp->declBus  (c+526,"v uut ff rom_addr_hold",-1,8,1);
	vcdp->declBus  (c+527,"v uut ff rom_addr_hold_d",-1,8,1);
	vcdp->declBus  (c+83,"v uut ff rom_addr",-1,12,0);
	vcdp->declBit  (c+289,"v uut ff rom_addr_4",-1);
	vcdp->declBus  (c+84,"v uut ff rom_data",-1,15,0);
	vcdp->declBus  (c+519,"v uut ff rom_shift",-1,15,0);
	vcdp->declBit  (c+551,"v uut ff hflip",-1);
	vcdp->declBus  (c+85,"v uut ff s1s0",-1,1,0);
	vcdp->declBit  (c+286,"v uut ff s_3y",-1);
	vcdp->declBit  (c+287,"v uut ff s_4y",-1);
	vcdp->declBus  (c+522,"v uut ff p",-1,7,0);
	vcdp->declBit  (c+523,"v uut ff hflip_d",-1);
	vcdp->declBit  (c+86,"v uut ff regld",-1);
	vcdp->declBit  (c+337,"v uut ff s_2y",-1);
	vcdp->declBit  (c+338,"v uut ff s_1y",-1);
	vcdp->declBit  (c+390,"v uut ff s_x1",-1);
	vcdp->declBit  (c+391,"v uut ff s_x0",-1);
	vcdp->declBus  (c+339,"v uut ff evd",-1,1,0);
	vcdp->declBus  (c+340,"v uut ff odd",-1,1,0);
	vcdp->declBit  (c+520,"v uut ff stamp_active_d",-1);
	vcdp->declBus  (c+521,"v uut ff stamp_active_cnt",-1,3,0);
	vcdp->declBit  (c+87,"v uut ff stamp_active",-1);
	vcdp->declBus  (c+552,"v uut ff mv_addr_hold",-1,15,8);
	vcdp->declBus  (c+692,"v uut ff mv_addr_even",-1,7,0);
	vcdp->declBus  (c+691,"v uut ff mv_addr_odd",-1,7,0);
	vcdp->declBus  (c+667,"v uut ff mv_odd",-1,7,0);
	vcdp->declBus  (c+669,"v uut ff mv_even",-1,7,0);
	vcdp->declBus  (c+668,"v uut ff mv",-1,7,0);
	vcdp->declBus  (c+528,"v uut ff ov",-1,7,0);
	vcdp->declBus  (c+88,"v uut ff rgb_addr",-1,7,0);
	vcdp->declBus  (c+89,"v uut ff rgb_cr_out",-1,7,0);
	vcdp->declBit  (c+90,"v uut ff coloramwr_n",-1);
	vcdp->declBit  (c+91,"v uut ff vcrsel_n",-1);
	vcdp->declBit  (c+447,"v uut ff vma",-1);
	vcdp->declBus  (c+1061,"v uut ff analog_out",-1,15,0);
	vcdp->declBit  (c+1062,"v uut ff pf_obj_n",-1);
	vcdp->declBit  (c+38,"v uut ff cpu clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu reset_n",-1);
	vcdp->declBus  (c+17,"v uut ff cpu a_out",-1,23,0);
	vcdp->declBus  (c+18,"v uut ff cpu d_in",-1,15,0);
	vcdp->declBus  (c+19,"v uut ff cpu d_out",-1,15,0);
	vcdp->declBus  (c+387,"v uut ff cpu ipl",-1,2,0);
	vcdp->declBit  (c+323,"v uut ff cpu dtack_n",-1);
	vcdp->declBit  (c+22,"v uut ff cpu lds_n",-1);
	vcdp->declBit  (c+21,"v uut ff cpu uds_n",-1);
	vcdp->declBit  (c+20,"v uut ff cpu r_w_n",-1);
	vcdp->declBit  (c+23,"v uut ff cpu as_n",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu halt_n",-1);
	vcdp->declBit  (c+42,"v uut ff cpu vpa_n",-1);
	vcdp->declBit  (c+697,"v uut ff cpu vma_n",-1);
	vcdp->declBit  (c+317,"v uut ff cpu avec_n",-1);
	vcdp->declBit  (c+693,"v uut ff cpu e",-1);
	vcdp->declBus  (c+318,"v uut ff cpu fc",-1,2,0);
	vcdp->declBit  (c+1057,"v uut ff cpu bgack_n",-1);
	vcdp->declBit  (c+708,"v uut ff cpu bg_n",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu br_n",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu berr_n",-1);
	vcdp->declBus  (c+92,"v uut ff cpu adr",-1,23,1);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top reset_coren",-1);
	vcdp->declBus  (c+92,"v uut ff cpu wf68k00ip_top adr",-1,23,1);
	vcdp->declBus  (c+18,"v uut ff cpu wf68k00ip_top datain",-1,15,0);
	vcdp->declBus  (c+19,"v uut ff cpu wf68k00ip_top dataout",-1,15,0);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top berrn",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top resetinn",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top haltinn",-1);
	vcdp->declBus  (c+318,"v uut ff cpu wf68k00ip_top fc",-1,2,0);
	vcdp->declBit  (c+317,"v uut ff cpu wf68k00ip_top avecn",-1);
	vcdp->declBus  (c+387,"v uut ff cpu wf68k00ip_top ipln",-1,2,0);
	vcdp->declBit  (c+323,"v uut ff cpu wf68k00ip_top dtackn",-1);
	vcdp->declBit  (c+23,"v uut ff cpu wf68k00ip_top asn",-1);
	vcdp->declBit  (c+20,"v uut ff cpu wf68k00ip_top rwn",-1);
	vcdp->declBit  (c+21,"v uut ff cpu wf68k00ip_top udsn",-1);
	vcdp->declBit  (c+22,"v uut ff cpu wf68k00ip_top ldsn",-1);
	vcdp->declBit  (c+693,"v uut ff cpu wf68k00ip_top e",-1);
	vcdp->declBit  (c+697,"v uut ff cpu wf68k00ip_top vman",-1);
	vcdp->declBit  (c+42,"v uut ff cpu wf68k00ip_top vpan",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top brn",-1);
	vcdp->declBit  (c+708,"v uut ff cpu wf68k00ip_top bgn",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top bgackn",-1);
	vcdp->declBit  (c+1063,"v uut ff cpu wf68k00ip_top resetoutn",-1);
	vcdp->declBit  (c+1064,"v uut ff cpu wf68k00ip_top haltoutn",-1);
	vcdp->declBit  (c+1019,"v uut ff cpu wf68k00ip_top reset_inn",-1);
	vcdp->declBit  (c+1020,"v uut ff cpu wf68k00ip_top reset_en",-1);
	vcdp->declBit  (c+1021,"v uut ff cpu wf68k00ip_top halt_en",-1);
	vcdp->declBit  (c+288,"v uut ff cpu wf68k00ip_top adr_en",-1);
	vcdp->declBus  (c+93,"v uut ff cpu wf68k00ip_top adr_out",-1,23,1);
	vcdp->declBit  (c+304,"v uut ff cpu wf68k00ip_top data_en",-1);
	vcdp->declBus  (c+18,"v uut ff cpu wf68k00ip_top data_in",-1,15,0);
	vcdp->declBus  (c+19,"v uut ff cpu wf68k00ip_top data_out",-1,15,0);
	vcdp->declBit  (c+316,"v uut ff cpu wf68k00ip_top fc_en",-1);
	vcdp->declBus  (c+511,"v uut ff cpu wf68k00ip_top fc_out",-1,2,0);
	vcdp->declBit  (c+536,"v uut ff cpu wf68k00ip_top as_outn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top as_en",-1);
	vcdp->declBit  (c+504,"v uut ff cpu wf68k00ip_top rwn_out",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top rw_en",-1);
	vcdp->declBit  (c+305,"v uut ff cpu wf68k00ip_top uds_outn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top uds_en",-1);
	vcdp->declBit  (c+306,"v uut ff cpu wf68k00ip_top lds_outn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top lds_en",-1);
	vcdp->declBus  (c+387,"v uut ff cpu wf68k00ip_top ipl_inn",-1,2,0);
	vcdp->declBit  (c+694,"v uut ff cpu wf68k00ip_top vma_outn",-1);
	vcdp->declBit  (c+709,"v uut ff cpu wf68k00ip_top vma_en",-1);
	vcdp->declBit  (c+319,"v uut ff cpu wf68k00ip_top avec_in",-1);
	vcdp->declBit  (c+1019,"v uut ff cpu wf68k00ip_top resetn",-1);
	vcdp->declBit  (c+1022,"v uut ff cpu wf68k00ip_top haltn",-1);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 reset_coren",-1);
	vcdp->declBus  (c+93,"v uut ff cpu wf68k00ip_top i_68k00 adr_out",-1,23,1);
	vcdp->declBit  (c+288,"v uut ff cpu wf68k00ip_top i_68k00 adr_en",-1);
	vcdp->declBus  (c+18,"v uut ff cpu wf68k00ip_top i_68k00 data_in",-1,15,0);
	vcdp->declBus  (c+19,"v uut ff cpu wf68k00ip_top i_68k00 data_out",-1,15,0);
	vcdp->declBit  (c+304,"v uut ff cpu wf68k00ip_top i_68k00 data_en",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top i_68k00 berrn",-1);
	vcdp->declBit  (c+1019,"v uut ff cpu wf68k00ip_top i_68k00 reset_inn",-1);
	vcdp->declBit  (c+1020,"v uut ff cpu wf68k00ip_top i_68k00 reset_out_en",-1);
	vcdp->declBit  (c+1022,"v uut ff cpu wf68k00ip_top i_68k00 halt_inn",-1);
	vcdp->declBit  (c+1021,"v uut ff cpu wf68k00ip_top i_68k00 halt_out_en",-1);
	vcdp->declBus  (c+511,"v uut ff cpu wf68k00ip_top i_68k00 fc_out",-1,2,0);
	vcdp->declBit  (c+316,"v uut ff cpu wf68k00ip_top i_68k00 fc_out_en",-1);
	vcdp->declBit  (c+319,"v uut ff cpu wf68k00ip_top i_68k00 avecn",-1);
	vcdp->declBus  (c+387,"v uut ff cpu wf68k00ip_top i_68k00 ipln",-1,2,0);
	vcdp->declBit  (c+323,"v uut ff cpu wf68k00ip_top i_68k00 dtackn",-1);
	vcdp->declBit  (c+536,"v uut ff cpu wf68k00ip_top i_68k00 as_outn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 as_out_en",-1);
	vcdp->declBit  (c+504,"v uut ff cpu wf68k00ip_top i_68k00 rwn_out",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 rw_out_en",-1);
	vcdp->declBit  (c+305,"v uut ff cpu wf68k00ip_top i_68k00 uds_outn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 uds_out_en",-1);
	vcdp->declBit  (c+306,"v uut ff cpu wf68k00ip_top i_68k00 lds_outn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 lds_out_en",-1);
	vcdp->declBit  (c+693,"v uut ff cpu wf68k00ip_top i_68k00 e",-1);
	vcdp->declBit  (c+694,"v uut ff cpu wf68k00ip_top i_68k00 vma_outn",-1);
	vcdp->declBit  (c+709,"v uut ff cpu wf68k00ip_top i_68k00 vma_out_en",-1);
	vcdp->declBit  (c+42,"v uut ff cpu wf68k00ip_top i_68k00 vpan",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top i_68k00 brn",-1);
	vcdp->declBit  (c+708,"v uut ff cpu wf68k00ip_top i_68k00 bgn",-1);
	vcdp->declBit  (c+1057,"v uut ff cpu wf68k00ip_top i_68k00 bgackn",-1);
	vcdp->declBus  (c+94,"v uut ff cpu wf68k00ip_top i_68k00 adr_eff_i",-1,31,0);
	vcdp->declBit  (c+288,"v uut ff cpu wf68k00ip_top i_68k00 adr_en_i",-1);
	vcdp->declBit  (c+1023,"v uut ff cpu wf68k00ip_top i_68k00 adr_en_vector_i",-1);
	vcdp->declBus  (c+95,"v uut ff cpu wf68k00ip_top i_68k00 adr_i",-1,31,0);
	vcdp->declBus  (c+392,"v uut ff cpu wf68k00ip_top i_68k00 adr_mode_i",-1,2,0);
	vcdp->declBit  (c+297,"v uut ff cpu wf68k00ip_top i_68k00 adr_tmp_clr_i",-1);
	vcdp->declBit  (c+96,"v uut ff cpu wf68k00ip_top i_68k00 adr_tmp_inc_i",-1);
	vcdp->declBus  (c+97,"v uut ff cpu wf68k00ip_top i_68k00 alu_op_in_s",-1,31,0);
	vcdp->declBus  (c+98,"v uut ff cpu wf68k00ip_top i_68k00 alu_op_in_d_hi",-1,31,0);
	vcdp->declBus  (c+99,"v uut ff cpu wf68k00ip_top i_68k00 alu_op_in_d_lo",-1,31,0);
	vcdp->declBit  (c+100,"v uut ff cpu wf68k00ip_top i_68k00 ar_inc_i",-1);
	vcdp->declBit  (c+566,"v uut ff cpu wf68k00ip_top i_68k00 ar_dec_i",-1);
	vcdp->declBit  (c+101,"v uut ff cpu wf68k00ip_top i_68k00 ar_wr_i",-1);
	vcdp->declBit  (c+102,"v uut ff cpu wf68k00ip_top i_68k00 ar_dr_exg_i",-1);
	vcdp->declBus  (c+103,"v uut ff cpu wf68k00ip_top i_68k00 areg_data_in",-1,31,0);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 as_en_i",-1);
	vcdp->declBit  (c+536,"v uut ff cpu wf68k00ip_top i_68k00 as_in",-1);
	vcdp->declBit  (c+373,"v uut ff cpu wf68k00ip_top i_68k00 avec_in",-1);
	vcdp->declBit  (c+374,"v uut ff cpu wf68k00ip_top i_68k00 berr_in",-1);
	vcdp->declBit  (c+512,"v uut ff cpu wf68k00ip_top i_68k00 berr_i",-1);
	vcdp->declBit  (c+343,"v uut ff cpu wf68k00ip_top i_68k00 bgack_in",-1);
	vcdp->declBus  (c+494,"v uut ff cpu wf68k00ip_top i_68k00 bit_pos_i",-1,4,0);
	vcdp->declBus  (c+351,"v uut ff cpu wf68k00ip_top i_68k00 bit_pos_op",-1,4,0);
	vcdp->declBit  (c+393,"v uut ff cpu wf68k00ip_top i_68k00 bitpos_im_i",-1);
	vcdp->declBus  (c+352,"v uut ff cpu wf68k00ip_top i_68k00 biw_0_i",-1,15,0);
	vcdp->declBit  (c+344,"v uut ff cpu wf68k00ip_top i_68k00 br_in",-1);
	vcdp->declBus  (c+649,"v uut ff cpu wf68k00ip_top i_68k00 bus_buffer_a",-1,31,0);
	vcdp->declBus  (c+650,"v uut ff cpu wf68k00ip_top i_68k00 bus_buffer_b",-1,31,0);
	vcdp->declBit  (c+104,"v uut ff cpu wf68k00ip_top i_68k00 bus_cyc_rdy_i",-1);
	vcdp->declBit  (c+105,"v uut ff cpu wf68k00ip_top i_68k00 byten_word_i",-1);
	vcdp->declBus  (c+353,"v uut ff cpu wf68k00ip_top i_68k00 c_code_i",-1,3,0);
	vcdp->declBit  (c+567,"v uut ff cpu wf68k00ip_top i_68k00 chk_adr_i",-1);
	vcdp->declBit  (c+568,"v uut ff cpu wf68k00ip_top i_68k00 chk_pc_i",-1);
	vcdp->declBus  (c+495,"v uut ff cpu wf68k00ip_top i_68k00 cnt_nr_i",-1,5,0);
	vcdp->declBit  (c+467,"v uut ff cpu wf68k00ip_top i_68k00 ctrl_en_i",-1);
	vcdp->declBit  (c+675,"v uut ff cpu wf68k00ip_top i_68k00 ctrl_rdy_i",-1);
	vcdp->declBus  (c+651,"v uut ff cpu wf68k00ip_top i_68k00 data_core",-1,15,0);
	vcdp->declBus  (c+474,"v uut ff cpu wf68k00ip_top i_68k00 data_immediate_i",-1,31,0);
	vcdp->declBus  (c+106,"v uut ff cpu wf68k00ip_top i_68k00 data_out_i",-1,31,0);
	vcdp->declBit  (c+107,"v uut ff cpu wf68k00ip_top i_68k00 data_valid_i",-1);
	vcdp->declBit  (c+108,"v uut ff cpu wf68k00ip_top i_68k00 dbcc_cond_i",-1);
	vcdp->declBus  (c+652,"v uut ff cpu wf68k00ip_top i_68k00 dest_exword0_i",-1,15,0);
	vcdp->declBus  (c+653,"v uut ff cpu wf68k00ip_top i_68k00 dest_exword1_i",-1,15,0);
	vcdp->declBus  (c+364,"v uut ff cpu wf68k00ip_top i_68k00 dest_ext_cnt_i",-1,1,0);
	vcdp->declBus  (c+475,"v uut ff cpu wf68k00ip_top i_68k00 displace_biw_i",-1,31,0);
	vcdp->declBit  (c+354,"v uut ff cpu wf68k00ip_top i_68k00 div_mul_32n64_i",-1);
	vcdp->declBit  (c+394,"v uut ff cpu wf68k00ip_top i_68k00 dr_i",-1);
	vcdp->declBit  (c+324,"v uut ff cpu wf68k00ip_top i_68k00 dr_dec_i",-1);
	vcdp->declBit  (c+109,"v uut ff cpu wf68k00ip_top i_68k00 dr_wr_i",-1);
	vcdp->declBus  (c+110,"v uut ff cpu wf68k00ip_top i_68k00 dreg_data_in_a",-1,31,0);
	vcdp->declBus  (c+111,"v uut ff cpu wf68k00ip_top i_68k00 dreg_data_in_b",-1,31,0);
	vcdp->declBit  (c+323,"v uut ff cpu wf68k00ip_top i_68k00 dtack_in",-1);
	vcdp->declBit  (c+310,"v uut ff cpu wf68k00ip_top i_68k00 ew_wr_i",-1);
	vcdp->declBit  (c+676,"v uut ff cpu wf68k00ip_top i_68k00 ew_adr_i",-1);
	vcdp->declBit  (c+112,"v uut ff cpu wf68k00ip_top i_68k00 exec_abort_i",-1);
	vcdp->declBit  (c+569,"v uut ff cpu wf68k00ip_top i_68k00 exec_resume_i",-1);
	vcdp->declBus  (c+365,"v uut ff cpu wf68k00ip_top i_68k00 ext_cnt_i",-1,1,0);
	vcdp->declBus  (c+448,"v uut ff cpu wf68k00ip_top i_68k00 ext_dsize_i",-1,1,0);
	vcdp->declBus  (c+654,"v uut ff cpu wf68k00ip_top i_68k00 exword0_i",-1,15,0);
	vcdp->declBus  (c+655,"v uut ff cpu wf68k00ip_top i_68k00 exword1_i",-1,15,0);
	vcdp->declBit  (c+382,"v uut ff cpu wf68k00ip_top i_68k00 fc_en_ctrl",-1);
	vcdp->declBit  (c+316,"v uut ff cpu wf68k00ip_top i_68k00 fc_en_i",-1);
	vcdp->declBit  (c+1024,"v uut ff cpu wf68k00ip_top i_68k00 fc_en_irq",-1);
	vcdp->declBus  (c+505,"v uut ff cpu wf68k00ip_top i_68k00 fc_out_ctrl",-1,2,0);
	vcdp->declBus  (c+511,"v uut ff cpu wf68k00ip_top i_68k00 fc_out_i",-1,2,0);
	vcdp->declBus  (c+1025,"v uut ff cpu wf68k00ip_top i_68k00 fc_out_irq",-1,2,0);
	vcdp->declBit  (c+395,"v uut ff cpu wf68k00ip_top i_68k00 force_biw2_i",-1);
	vcdp->declBit  (c+476,"v uut ff cpu wf68k00ip_top i_68k00 force_biw3_i",-1);
	vcdp->declBit  (c+711,"v uut ff cpu wf68k00ip_top i_68k00 halt_in",-1);
	vcdp->declBit  (c+113,"v uut ff cpu wf68k00ip_top i_68k00 hi_byte_en_i",-1);
	vcdp->declBit  (c+372,"v uut ff cpu wf68k00ip_top i_68k00 hi_word_en_i",-1);
	vcdp->declBus  (c+570,"v uut ff cpu wf68k00ip_top i_68k00 int_vect_i",-1,9,0);
	vcdp->declBit  (c+114,"v uut ff cpu wf68k00ip_top i_68k00 init_status_i",-1);
	vcdp->declBus  (c+375,"v uut ff cpu wf68k00ip_top i_68k00 ipl_in",-1,2,0);
	vcdp->declBus  (c+376,"v uut ff cpu wf68k00ip_top i_68k00 ipl_tmpn",-1,2,0);
	vcdp->declBit  (c+355,"v uut ff cpu wf68k00ip_top i_68k00 ir_i",-1);
	vcdp->declBit  (c+1026,"v uut ff cpu wf68k00ip_top i_68k00 irq_data_en",-1);
	vcdp->declBus  (c+345,"v uut ff cpu wf68k00ip_top i_68k00 irq_dout",-1,15,0);
	vcdp->declBus  (c+571,"v uut ff cpu wf68k00ip_top i_68k00 irq_exhdl",-1,2,0);
	vcdp->declBit  (c+115,"v uut ff cpu wf68k00ip_top i_68k00 irq_save_i",-1);
	vcdp->declBus  (c+378,"v uut ff cpu wf68k00ip_top i_68k00 iw_adr_i",-1,1,0);
	vcdp->declBit  (c+311,"v uut ff cpu wf68k00ip_top i_68k00 iw_wr_i",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 lds_en_i",-1);
	vcdp->declBit  (c+306,"v uut ff cpu wf68k00ip_top i_68k00 lds_in",-1);
	vcdp->declBit  (c+116,"v uut ff cpu wf68k00ip_top i_68k00 lo_byte_en_i",-1);
	vcdp->declBus  (c+356,"v uut ff cpu wf68k00ip_top i_68k00 move_d_am_i",-1,2,0);
	vcdp->declBit  (c+396,"v uut ff cpu wf68k00ip_top i_68k00 mem_shft_i",-1);
	vcdp->declBit  (c+572,"v uut ff cpu wf68k00ip_top i_68k00 movem_adn_i",-1);
	vcdp->declBus  (c+573,"v uut ff cpu wf68k00ip_top i_68k00 movem_regsel_i",-1,2,0);
	vcdp->declBit  (c+322,"v uut ff cpu wf68k00ip_top i_68k00 pc_add_displ_i",-1);
	vcdp->declBit  (c+117,"v uut ff cpu wf68k00ip_top i_68k00 op_busy_i",-1);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 op_i",-1,6,0);
	vcdp->declBus  (c+398,"v uut ff cpu wf68k00ip_top i_68k00 op_mode_i",-1,4,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 op_size_i",-1,1,0);
	vcdp->declBit  (c+118,"v uut ff cpu wf68k00ip_top i_68k00 op_start_i",-1);
	vcdp->declBit  (c+119,"v uut ff cpu wf68k00ip_top i_68k00 pc_inc_i",-1);
	vcdp->declBit  (c+313,"v uut ff cpu wf68k00ip_top i_68k00 pc_init_i",-1);
	vcdp->declBit  (c+314,"v uut ff cpu wf68k00ip_top i_68k00 pc_init_ctrl",-1);
	vcdp->declBit  (c+120,"v uut ff cpu wf68k00ip_top i_68k00 pc_init_irq",-1);
	vcdp->declBus  (c+346,"v uut ff cpu wf68k00ip_top i_68k00 pc_out",-1,31,0);
	vcdp->declBit  (c+675,"v uut ff cpu wf68k00ip_top i_68k00 pc_tmp_clr_i",-1);
	vcdp->declBit  (c+312,"v uut ff cpu wf68k00ip_top i_68k00 pc_tmp_inc_i",-1);
	vcdp->declBit  (c+325,"v uut ff cpu wf68k00ip_top i_68k00 pc_wr_i",-1);
	vcdp->declBit  (c+121,"v uut ff cpu wf68k00ip_top i_68k00 preset_irq_mask_i",-1);
	vcdp->declBus  (c+496,"v uut ff cpu wf68k00ip_top i_68k00 q_areg_a",-1,31,0);
	vcdp->declBus  (c+497,"v uut ff cpu wf68k00ip_top i_68k00 q_areg_b",-1,31,0);
	vcdp->declBus  (c+498,"v uut ff cpu wf68k00ip_top i_68k00 q_dreg_a",-1,31,0);
	vcdp->declBus  (c+122,"v uut ff cpu wf68k00ip_top i_68k00 q_dreg_b",-1,31,0);
	vcdp->declBus  (c+98,"v uut ff cpu wf68k00ip_top i_68k00 q_dreg_c",-1,31,0);
	vcdp->declBit  (c+506,"v uut ff cpu wf68k00ip_top i_68k00 rd_bus_ctrl",-1);
	vcdp->declBit  (c+1027,"v uut ff cpu wf68k00ip_top i_68k00 rd_bus_irq",-1);
	vcdp->declBit  (c+507,"v uut ff cpu wf68k00ip_top i_68k00 rd_bus_i",-1);
	vcdp->declBus  (c+357,"v uut ff cpu wf68k00ip_top i_68k00 reglistmask_i",-1,15,0);
	vcdp->declBus  (c+358,"v uut ff cpu wf68k00ip_top i_68k00 regsel_119_i",-1,2,0);
	vcdp->declBus  (c+359,"v uut ff cpu wf68k00ip_top i_68k00 regsel_20_i",-1,2,0);
	vcdp->declBus  (c+449,"v uut ff cpu wf68k00ip_top i_68k00 regsel_adr_a",-1,2,0);
	vcdp->declBus  (c+450,"v uut ff cpu wf68k00ip_top i_68k00 regsel_adr_b",-1,2,0);
	vcdp->declBus  (c+477,"v uut ff cpu wf68k00ip_top i_68k00 regsel_data_a",-1,2,0);
	vcdp->declBus  (c+123,"v uut ff cpu wf68k00ip_top i_68k00 regsel_data_b",-1,2,0);
	vcdp->declBus  (c+124,"v uut ff cpu wf68k00ip_top i_68k00 regsel_data_c",-1,2,0);
	vcdp->declBus  (c+360,"v uut ff cpu wf68k00ip_top i_68k00 regsel_dhr",-1,2,0);
	vcdp->declBus  (c+361,"v uut ff cpu wf68k00ip_top i_68k00 regsel_dlq",-1,2,0);
	vcdp->declBus  (c+366,"v uut ff cpu wf68k00ip_top i_68k00 regsel_index",-1,2,0);
	vcdp->declBit  (c+677,"v uut ff cpu wf68k00ip_top i_68k00 reset_cpu_in",-1);
	vcdp->declBit  (c+125,"v uut ff cpu wf68k00ip_top i_68k00 reset_en_i",-1);
	vcdp->declBit  (c+403,"v uut ff cpu wf68k00ip_top i_68k00 reset_in_in",-1);
	vcdp->declBit  (c+1028,"v uut ff cpu wf68k00ip_top i_68k00 reset_rdy_i",-1);
	vcdp->declBus  (c+126,"v uut ff cpu wf68k00ip_top i_68k00 result_alu_hi",-1,31,0);
	vcdp->declBus  (c+127,"v uut ff cpu wf68k00ip_top i_68k00 result_alu_lo",-1,31,0);
	vcdp->declBus  (c+128,"v uut ff cpu wf68k00ip_top i_68k00 result_shft",-1,31,0);
	vcdp->declBit  (c+362,"v uut ff cpu wf68k00ip_top i_68k00 rm_i",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 rw_en_i",-1);
	vcdp->declBit  (c+504,"v uut ff cpu wf68k00ip_top i_68k00 rwn_i",-1);
	vcdp->declBit  (c+574,"v uut ff cpu wf68k00ip_top i_68k00 sbit_i",-1);
	vcdp->declBit  (c+129,"v uut ff cpu wf68k00ip_top i_68k00 scan_traps_i",-1);
	vcdp->declBit  (c+384,"v uut ff cpu wf68k00ip_top i_68k00 scc_cond_i",-1);
	vcdp->declBit  (c+451,"v uut ff cpu wf68k00ip_top i_68k00 sel_a_lo",-1);
	vcdp->declBit  (c+452,"v uut ff cpu wf68k00ip_top i_68k00 sel_a_hi",-1);
	vcdp->declBit  (c+453,"v uut ff cpu wf68k00ip_top i_68k00 sel_a_midhi",-1);
	vcdp->declBit  (c+454,"v uut ff cpu wf68k00ip_top i_68k00 sel_a_midlo",-1);
	vcdp->declBit  (c+508,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_a_lo_i",-1);
	vcdp->declBit  (c+509,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_a_hi_i",-1);
	vcdp->declBit  (c+678,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_a_lo_ctrl_i",-1);
	vcdp->declBit  (c+679,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_a_hi_ctrl_i",-1);
	vcdp->declBit  (c+468,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_a_lo_irq_i",-1);
	vcdp->declBit  (c+469,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_a_hi_irq_i",-1);
	vcdp->declBit  (c+379,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_b_lo_i",-1);
	vcdp->declBit  (c+680,"v uut ff cpu wf68k00ip_top i_68k00 sel_buf_b_hi_i",-1);
	vcdp->declBit  (c+400,"v uut ff cpu wf68k00ip_top i_68k00 sel_displace_biw_i",-1);
	vcdp->declBit  (c+575,"v uut ff cpu wf68k00ip_top i_68k00 shft_busy_i",-1);
	vcdp->declBus  (c+130,"v uut ff cpu wf68k00ip_top i_68k00 shft_op_in",-1,31,0);
	vcdp->declBit  (c+131,"v uut ff cpu wf68k00ip_top i_68k00 shifter_load_i",-1);
	vcdp->declBit  (c+132,"v uut ff cpu wf68k00ip_top i_68k00 sp_add_displ_i",-1);
	vcdp->declBus  (c+133,"v uut ff cpu wf68k00ip_top i_68k00 sr_ccr_mux",-1,15,0);
	vcdp->declBit  (c+455,"v uut ff cpu wf68k00ip_top i_68k00 src_destn_i",-1);
	vcdp->declBit  (c+294,"v uut ff cpu wf68k00ip_top i_68k00 ssp_dec_ctrl",-1);
	vcdp->declBit  (c+295,"v uut ff cpu wf68k00ip_top i_68k00 ssp_dec_i",-1);
	vcdp->declBit  (c+134,"v uut ff cpu wf68k00ip_top i_68k00 ssp_dec_irq",-1);
	vcdp->declBit  (c+292,"v uut ff cpu wf68k00ip_top i_68k00 ssp_inc_i",-1);
	vcdp->declBit  (c+135,"v uut ff cpu wf68k00ip_top i_68k00 ssp_init_i",-1);
	vcdp->declBus  (c+576,"v uut ff cpu wf68k00ip_top i_68k00 ssp_out",-1,31,0);
	vcdp->declBus  (c+577,"v uut ff cpu wf68k00ip_top i_68k00 status_reg_i",-1,15,0);
	vcdp->declBit  (c+510,"v uut ff cpu wf68k00ip_top i_68k00 sys_init_i",-1);
	vcdp->declBit  (c+681,"v uut ff cpu wf68k00ip_top i_68k00 tas_lock_i",-1);
	vcdp->declBit  (c+302,"v uut ff cpu wf68k00ip_top i_68k00 trap_1010_i",-1);
	vcdp->declBit  (c+303,"v uut ff cpu wf68k00ip_top i_68k00 trap_1111_i",-1);
	vcdp->declBit  (c+136,"v uut ff cpu wf68k00ip_top i_68k00 trap_aerr_i",-1);
	vcdp->declBit  (c+326,"v uut ff cpu wf68k00ip_top i_68k00 trap_chk_i",-1);
	vcdp->declBit  (c+327,"v uut ff cpu wf68k00ip_top i_68k00 trap_chk_en_i",-1);
	vcdp->declBit  (c+298,"v uut ff cpu wf68k00ip_top i_68k00 trap_divzero_i",-1);
	vcdp->declBit  (c+328,"v uut ff cpu wf68k00ip_top i_68k00 trap_illegal_i",-1);
	vcdp->declBit  (c+329,"v uut ff cpu wf68k00ip_top i_68k00 trap_op_i",-1);
	vcdp->declBit  (c+137,"v uut ff cpu wf68k00ip_top i_68k00 trap_priv_i",-1);
	vcdp->declBit  (c+290,"v uut ff cpu wf68k00ip_top i_68k00 trap_trace_i",-1);
	vcdp->declBit  (c+299,"v uut ff cpu wf68k00ip_top i_68k00 trap_v_i",-1);
	vcdp->declBus  (c+363,"v uut ff cpu wf68k00ip_top i_68k00 trap_vector_i",-1,3,0);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 uds_en_i",-1);
	vcdp->declBit  (c+305,"v uut ff cpu wf68k00ip_top i_68k00 uds_in",-1);
	vcdp->declBit  (c+456,"v uut ff cpu wf68k00ip_top i_68k00 unlk_sp_an_i",-1);
	vcdp->declBit  (c+138,"v uut ff cpu wf68k00ip_top i_68k00 usp_cpy_i",-1);
	vcdp->declBit  (c+296,"v uut ff cpu wf68k00ip_top i_68k00 usp_dec_i",-1);
	vcdp->declBit  (c+293,"v uut ff cpu wf68k00ip_top i_68k00 usp_inc_i",-1);
	vcdp->declBit  (c+139,"v uut ff cpu wf68k00ip_top i_68k00 use_int_vect_i",-1);
	vcdp->declBus  (c+578,"v uut ff cpu wf68k00ip_top i_68k00 usp_out",-1,31,0);
	vcdp->declBit  (c+380,"v uut ff cpu wf68k00ip_top i_68k00 use_sp_adr_i",-1);
	vcdp->declBit  (c+470,"v uut ff cpu wf68k00ip_top i_68k00 use_ssp_adr_i",-1);
	vcdp->declBit  (c+709,"v uut ff cpu wf68k00ip_top i_68k00 vma_en_i",-1);
	vcdp->declBit  (c+694,"v uut ff cpu wf68k00ip_top i_68k00 vma_in",-1);
	vcdp->declBit  (c+404,"v uut ff cpu wf68k00ip_top i_68k00 vpa_in",-1);
	vcdp->declBit  (c+381,"v uut ff cpu wf68k00ip_top i_68k00 wr_bus_ctrl",-1);
	vcdp->declBit  (c+471,"v uut ff cpu wf68k00ip_top i_68k00 wr_bus_i",-1);
	vcdp->declBit  (c+1026,"v uut ff cpu wf68k00ip_top i_68k00 wr_bus_irq",-1);
	vcdp->declBit  (c+682,"v uut ff cpu wf68k00ip_top i_68k00 wr_hi_i",-1);
	vcdp->declBus  (c+140,"v uut ff cpu wf68k00ip_top i_68k00 xnzvc_alu",-1,4,0);
	vcdp->declBus  (c+330,"v uut ff cpu wf68k00ip_top i_68k00 xnzvc_i",-1,4,0);
	vcdp->declBus  (c+141,"v uut ff cpu wf68k00ip_top i_68k00 xnzvc_shft",-1,4,0);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl resetn",-1);
	vcdp->declBus  (c+353,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl c_code",-1,3,0);
	vcdp->declBus  (c+357,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl reglistmask",-1,15,0);
	vcdp->declBit  (c+467,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ctrl_en",-1);
	vcdp->declBit  (c+112,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl exec_abort",-1);
	vcdp->declBit  (c+107,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl data_valid",-1);
	vcdp->declBit  (c+104,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl bus_cyc_rdy",-1);
	vcdp->declBit  (c+675,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ctrl_rdy",-1);
	vcdp->declBit  (c+114,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl init_status",-1);
	vcdp->declBit  (c+121,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl preset_irq_mask",-1);
	vcdp->declBus  (c+133,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sr_ccr_in",-1,15,0);
	vcdp->declBus  (c+571,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl irq",-1,2,0);
	vcdp->declBit  (c+115,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl irq_save",-1);
	vcdp->declBus  (c+330,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl xnzvc_in",-1,4,0);
	vcdp->declBus  (c+577,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl status_reg_out",-1,15,0);
	vcdp->declBit  (c+395,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl force_biw2",-1);
	vcdp->declBit  (c+476,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl force_biw3",-1);
	vcdp->declBus  (c+365,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ext_cnt",-1,1,0);
	vcdp->declBus  (c+364,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl dest_ext_cnt",-1,1,0);
	vcdp->declBus  (c+359,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl regsel_20",-1,2,0);
	vcdp->declBus  (c+378,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl iw_adr",-1,1,0);
	vcdp->declBit  (c+311,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl iw_wr",-1);
	vcdp->declBit  (c+455,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl src_destn",-1);
	vcdp->declBit  (c+310,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ew_wr",-1);
	vcdp->declBit  (c+676,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ew_adr",-1);
	vcdp->declBit  (c+506,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl rd_bus",-1);
	vcdp->declBit  (c+381,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl wr_bus",-1);
	vcdp->declBit  (c+681,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl tas_lock",-1);
	vcdp->declBit  (c+682,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl wr_hi",-1);
	vcdp->declBit  (c+452,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_a_hi",-1);
	vcdp->declBit  (c+453,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_a_midhi",-1);
	vcdp->declBit  (c+454,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_a_midlo",-1);
	vcdp->declBit  (c+451,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_a_lo",-1);
	vcdp->declBit  (c+678,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_buff_a_lo",-1);
	vcdp->declBit  (c+679,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_buff_a_hi",-1);
	vcdp->declBit  (c+379,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_buff_b_lo",-1);
	vcdp->declBit  (c+680,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sel_buff_b_hi",-1);
	vcdp->declBus  (c+505,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl fc_out",-1,2,0);
	vcdp->declBit  (c+382,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl fc_en",-1);
	vcdp->declBit  (c+314,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl pc_init",-1);
	vcdp->declBit  (c+325,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl pc_wr",-1);
	vcdp->declBit  (c+119,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl pc_inc",-1);
	vcdp->declBit  (c+675,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl pc_tmp_clr",-1);
	vcdp->declBit  (c+312,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl pc_tmp_inc",-1);
	vcdp->declBit  (c+322,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl pc_add_displ",-1);
	vcdp->declBit  (c+293,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl usp_inc",-1);
	vcdp->declBit  (c+292,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ssp_inc",-1);
	vcdp->declBit  (c+296,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl usp_dec",-1);
	vcdp->declBit  (c+294,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ssp_dec",-1);
	vcdp->declBit  (c+138,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl usp_cpy",-1);
	vcdp->declBit  (c+132,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sp_add_displ",-1);
	vcdp->declBit  (c+297,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl adr_tmp_clr",-1);
	vcdp->declBit  (c+96,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl adr_tmp_inc",-1);
	vcdp->declBit  (c+100,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ar_inc",-1);
	vcdp->declBit  (c+566,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ar_dec",-1);
	vcdp->declBit  (c+101,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ar_wr",-1);
	vcdp->declBit  (c+102,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ar_dr_exg",-1);
	vcdp->declBit  (c+109,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl dr_wr",-1);
	vcdp->declBit  (c+324,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl dr_dec",-1);
	vcdp->declBit  (c+129,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl scan_traps",-1);
	vcdp->declBit  (c+137,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl trap_priv",-1);
	vcdp->declBit  (c+290,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl trap_trace",-1);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl op",-1,6,0);
	vcdp->declBus  (c+401,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl op_mode",-1,2,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl op_size",-1,1,0);
	vcdp->declBus  (c+392,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl adr_mode",-1,2,0);
	vcdp->declBus  (c+356,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl move_d_am",-1,2,0);
	vcdp->declBit  (c+1028,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl reset_rdy",-1);
	vcdp->declBit  (c+117,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl op_busy",-1);
	vcdp->declBit  (c+396,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl mem_shft",-1);
	vcdp->declBit  (c+575,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl shft_busy",-1);
	vcdp->declBit  (c+394,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl dr",-1);
	vcdp->declBit  (c+362,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl rm",-1);
	vcdp->declBit  (c+354,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl div_mul_32n64",-1);
	vcdp->declBit  (c+569,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl exec_resume",-1);
	vcdp->declBit  (c+108,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl dbcc_cond",-1);
	vcdp->declBit  (c+380,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl use_sp_adr",-1);
	vcdp->declBit  (c+118,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl op_start",-1);
	vcdp->declBit  (c+327,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl trap_chk_en",-1);
	vcdp->declBus  (c+573,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl movem_regsel",-1,2,0);
	vcdp->declBit  (c+572,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl movem_adn",-1);
	vcdp->declBit  (c+384,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl scc_cond",-1);
	vcdp->declBit  (c+131,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl shifter_load",-1);
	vcdp->declBit  (c+568,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl chk_pc",-1);
	vcdp->declBit  (c+567,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl chk_adr",-1);
	vcdp->declBit  (c+574,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sbit",-1);
	vcdp->declBit  (c+456,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl unlk_sp_an",-1);
	vcdp->declBit  (c+125,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl reset_en",-1);
	vcdp->declBit  (c+579,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl chk_adr_strb_lock",-1);
	vcdp->declBit  (c+580,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl predec_ctrl_lock",-1);
	vcdp->declBus  (c+581,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sreg_mem",-1,9,0);
	vcdp->declBus  (c+582,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sreg_mem_tmp",-1,9,0);
	vcdp->declBus  (c+583,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl bit_pnt_r",-1,4,0);
	vcdp->declBus  (c+584,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl regsel_tmp_r",-1,2,0);
	vcdp->declBus  (c+142,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl bit_pnt",-1,4,0);
	vcdp->declBus  (c+143,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl regsel_tmp",-1,2,0);
	vcdp->declBit  (c+683,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl exword_counter_lock",-1);
	vcdp->declBus  (c+684,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl src_tmp",-1,1,0);
	vcdp->declBus  (c+685,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl dest_tmp",-1,1,0);
	vcdp->declBus  (c+686,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl exec_state",-1,4,0);
	vcdp->declBus  (c+144,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl next_exec_state",-1,4,0);
	vcdp->declBus  (c+585,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl status_reg",-1,15,0);
	vcdp->declBit  (c+145,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sr_wr",-1);
	vcdp->declBit  (c+315,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ccr_wr",-1);
	vcdp->declBit  (c+331,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl cc_updt",-1);
	vcdp->declBit  (c+457,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl got_ext",-1);
	vcdp->declBit  (c+458,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl got_dest_ext",-1);
	vcdp->declBit  (c+347,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl movem_en",-1);
	vcdp->declBit  (c+459,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl movem_cpy",-1);
	vcdp->declBit  (c+348,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl movem_adn_i",-1);
	vcdp->declBit  (c+349,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl movem_pi_corr",-1);
	vcdp->declBit  (c+384,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl cond",-1);
	vcdp->declBit  (c+119,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl op_end_i",-1);
	vcdp->declBit  (c+506,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl rd_bus_i",-1);
	vcdp->declBit  (c+381,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl wr_bus_i",-1);
	vcdp->declBit  (c+100,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ar_inc_i",-1);
	vcdp->declBit  (c+566,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl ar_dec_i",-1);
	vcdp->declBit  (c+332,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl updt_cc",-1);
	vcdp->declBit  (c+574,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl sbit_i",-1);
	vcdp->declBit  (c+586,"v uut ff cpu wf68k00ip_top i_68k00 i_ctrl traplock",-1);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl resetn",-1);
	vcdp->declBit  (c+677,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl reset_cpun",-1);
	vcdp->declBit  (c+512,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl berr",-1);
	vcdp->declBit  (c+711,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl haltn",-1);
	vcdp->declBus  (c+95,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl adr_in",-1,31,0);
	vcdp->declBit  (c+470,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl use_ssp_adr",-1);
	vcdp->declBit  (c+1023,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl adr_en_vector",-1);
	vcdp->declBus  (c+656,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl data_in",-1,7,0);
	vcdp->declBus  (c+345,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl data_out",-1,15,0);
	vcdp->declBit  (c+1026,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl data_en",-1);
	vcdp->declBit  (c+504,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl rwn",-1);
	vcdp->declBit  (c+1027,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl rd_bus",-1);
	vcdp->declBit  (c+1026,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl wr_bus",-1);
	vcdp->declBit  (c+1021,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl halt_en",-1);
	vcdp->declBus  (c+511,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl fc_in",-1,2,0);
	vcdp->declBus  (c+1025,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl fc_out",-1,2,0);
	vcdp->declBit  (c+1024,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl fc_en",-1);
	vcdp->declBit  (c+468,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl sel_buff_a_lo",-1);
	vcdp->declBit  (c+469,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl sel_buff_a_hi",-1);
	vcdp->declBus  (c+577,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl status_reg_in",-1,15,0);
	vcdp->declBus  (c+346,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl pc",-1,31,0);
	vcdp->declBit  (c+114,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl init_status",-1);
	vcdp->declBit  (c+121,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl preset_irq_mask",-1);
	vcdp->declBit  (c+134,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ssp_dec",-1);
	vcdp->declBit  (c+135,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ssp_init",-1);
	vcdp->declBit  (c+120,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl pc_init",-1);
	vcdp->declBus  (c+352,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl biw_0",-1,15,0);
	vcdp->declBit  (c+104,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl bus_cyc_rdy",-1);
	vcdp->declBit  (c+675,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ctrl_rdy",-1);
	vcdp->declBit  (c+467,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ctrl_en",-1);
	vcdp->declBit  (c+112,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl exec_abort",-1);
	vcdp->declBit  (c+569,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl exec_resume",-1);
	vcdp->declBus  (c+375,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl irq_inn",-1,2,0);
	vcdp->declBus  (c+571,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl irq_out",-1,2,0);
	vcdp->declBit  (c+373,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl avecn",-1);
	vcdp->declBit  (c+115,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl irq_save",-1);
	vcdp->declBus  (c+570,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl int_vect",-1,9,0);
	vcdp->declBit  (c+139,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl use_int_vect",-1);
	vcdp->declBit  (c+136,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_aerr",-1);
	vcdp->declBit  (c+329,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_op",-1);
	vcdp->declBus  (c+363,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_vector",-1,3,0);
	vcdp->declBit  (c+299,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_v",-1);
	vcdp->declBit  (c+326,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_chk",-1);
	vcdp->declBit  (c+298,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_divzero",-1);
	vcdp->declBit  (c+328,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_illegal",-1);
	vcdp->declBit  (c+302,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_1010",-1);
	vcdp->declBit  (c+303,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_1111",-1);
	vcdp->declBit  (c+290,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_trace",-1);
	vcdp->declBit  (c+137,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl trap_priv",-1);
	vcdp->declBus  (c+553,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl sr_mem",-1,9,0);
	vcdp->declBus  (c+587,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl vector_no",-1,7,0);
	vcdp->declBus  (c+146,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl vect_tmp",-1,1,0);
	vcdp->declBus  (c+1029,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_state",-1,4,0);
	vcdp->declBus  (c+147,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl next_ex_state",-1,4,0);
	vcdp->declBus  (c+588,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl exception_q",-1,3,0);
	vcdp->declBit  (c+148,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl tmp_cpy",-1);
	vcdp->declBus  (c+554,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl status_reg_tmp",-1,15,0);
	vcdp->declBit  (c+555,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl rwn_tmp",-1);
	vcdp->declBus  (c+556,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl fc_tmp",-1,2,0);
	vcdp->declBus  (c+377,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl irq_in",-1,2,0);
	vcdp->declBit  (c+589,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl instrn",-1);
	vcdp->declBus  (c+557,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl adr_tmp",-1,31,0);
	vcdp->declBit  (c+149,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl inc_tmp_vector",-1);
	vcdp->declBit  (c+590,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_reset",-1);
	vcdp->declBit  (c+591,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_adr_err",-1);
	vcdp->declBit  (c+592,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_bus_err",-1);
	vcdp->declBit  (c+593,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_trace",-1);
	vcdp->declBit  (c+569,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_int",-1);
	vcdp->declBit  (c+594,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_illegal",-1);
	vcdp->declBit  (c+595,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_1010",-1);
	vcdp->declBit  (c+596,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_1111",-1);
	vcdp->declBit  (c+597,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_priv",-1);
	vcdp->declBit  (c+598,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_trap",-1);
	vcdp->declBit  (c+599,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_trapv",-1);
	vcdp->declBit  (c+600,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_chk",-1);
	vcdp->declBit  (c+601,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl ex_p_divzero",-1);
	vcdp->declBit  (c+301,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl force_halt",-1);
	vcdp->declBit  (c+121,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl preset_irq_mask_i",-1);
	vcdp->declBus  (c+602,"v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl vect_tmp_r",-1,1,0);
	// Tracing: v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl _irq_inn // Ignored: Inlined leading underscore at ../rtl/m68000.v:1036
	// Tracing: v uut ff cpu wf68k00ip_top i_68k00 i_irq_ctrl _sr // Ignored: Inlined leading underscore at ../rtl/m68000.v:1037
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode resetn",-1);
	vcdp->declBus  (c+18,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode data_in",-1,15,0);
	vcdp->declBit  (c+574,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode sbit",-1);
	vcdp->declBit  (c+603,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ov",-1);
	vcdp->declBus  (c+378,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode iw_adr",-1,1,0);
	vcdp->declBit  (c+311,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode iw_wr",-1);
	vcdp->declBit  (c+395,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode force_biw2",-1);
	vcdp->declBit  (c+476,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode force_biw3",-1);
	vcdp->declBus  (c+365,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ext_cnt",-1,1,0);
	vcdp->declBus  (c+364,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode dest_ext_cnt",-1,1,0);
	vcdp->declBit  (c+394,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode dr",-1);
	vcdp->declBit  (c+362,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode rm",-1);
	vcdp->declBit  (c+355,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ir",-1);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode op",-1,6,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode op_size",-1,1,0);
	vcdp->declBus  (c+398,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode op_mode",-1,4,0);
	vcdp->declBus  (c+352,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode biw_0",-1,15,0);
	vcdp->declBus  (c+359,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode regsel_20",-1,2,0);
	vcdp->declBus  (c+358,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode regsel_119",-1,2,0);
	vcdp->declBus  (c+366,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode regsel_index",-1,2,0);
	vcdp->declBus  (c+474,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode data_immediate",-1,31,0);
	vcdp->declBus  (c+363,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_vector",-1,3,0);
	vcdp->declBus  (c+353,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode c_code",-1,3,0);
	vcdp->declBit  (c+396,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode mem_shft",-1);
	vcdp->declBus  (c+357,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode reglistmask",-1,15,0);
	vcdp->declBit  (c+393,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode bitpos_im",-1);
	vcdp->declBus  (c+351,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode bit_pos",-1,4,0);
	vcdp->declBit  (c+354,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode div_mul_32n64",-1);
	vcdp->declBus  (c+361,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode reg_dlq",-1,2,0);
	vcdp->declBus  (c+360,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode reg_dhr",-1,2,0);
	vcdp->declBit  (c+129,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode scan_traps",-1);
	vcdp->declBit  (c+328,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_illegal",-1);
	vcdp->declBit  (c+302,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_1010",-1);
	vcdp->declBit  (c+303,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_1111",-1);
	vcdp->declBit  (c+137,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_priv",-1);
	vcdp->declBit  (c+329,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_op",-1);
	vcdp->declBit  (c+299,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode trap_v",-1);
	vcdp->declBit  (c+310,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ew_wr",-1);
	vcdp->declBit  (c+676,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ew_adr",-1);
	vcdp->declBit  (c+455,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode src_destn",-1);
	vcdp->declBus  (c+654,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode exword0",-1,15,0);
	vcdp->declBus  (c+655,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode exword1",-1,15,0);
	vcdp->declBus  (c+652,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode dest_exword0",-1,15,0);
	vcdp->declBus  (c+653,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode dest_exword1",-1,15,0);
	vcdp->declBus  (c+392,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode adr_mode",-1,2,0);
	vcdp->declBus  (c+356,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode move_d_am",-1,2,0);
	vcdp->declBus  (c+448,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ext_dsize",-1,1,0);
	vcdp->declBit  (c+400,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode sel_displace_biw",-1);
	vcdp->declBus  (c+475,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode displace_biw",-1,31,0);
	{int i; for (i=0; i<3; i++) {
		vcdp->declBus  (c+657+i*1,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode biw",(i+0),15,0);}}
	vcdp->declBit  (c+402,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode ext_en",-1);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode op_i",-1,6,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode op_size_i",-1,1,0);
	vcdp->declBus  (c+654,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode exword_reg0",-1,15,0);
	vcdp->declBus  (c+655,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode exword_reg1",-1,15,0);
	vcdp->declBus  (c+652,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode dest_exword_reg0",-1,15,0);
	vcdp->declBus  (c+653,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode dest_exword_reg1",-1,15,0);
	vcdp->declBus  (c+357,"v uut ff cpu wf68k00ip_top i_68k00 i_opcode biw_1",-1,15,0);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg resetn",-1);
	vcdp->declBus  (c+103,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adata_in",-1,31,0);
	vcdp->declBus  (c+450,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg regsel_b",-1,2,0);
	vcdp->declBus  (c+449,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg regsel_a",-1,2,0);
	vcdp->declBus  (c+497,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_reg_qb",-1,31,0);
	vcdp->declBus  (c+496,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_reg_qa",-1,31,0);
	vcdp->declBus  (c+578,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg usp_out",-1,31,0);
	vcdp->declBus  (c+576,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ssp_out",-1,31,0);
	vcdp->declBus  (c+346,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_out",-1,31,0);
	vcdp->declBus  (c+654,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg exword0",-1,15,0);
	vcdp->declBus  (c+655,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg exword1",-1,15,0);
	vcdp->declBus  (c+652,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg dest_exword0",-1,15,0);
	vcdp->declBus  (c+653,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg dest_exword1",-1,15,0);
	vcdp->declBit  (c+394,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg dr",-1);
	vcdp->declBit  (c+138,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg usp_cpy",-1);
	vcdp->declBit  (c+102,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_exg",-1);
	vcdp->declBit  (c+101,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_wr",-1);
	vcdp->declBit  (c+293,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg usp_inc",-1);
	vcdp->declBit  (c+296,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg usp_dec",-1);
	vcdp->declBit  (c+297,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_tmp_clr",-1);
	vcdp->declBit  (c+96,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_tmp_inc",-1);
	vcdp->declBit  (c+100,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_inc",-1);
	vcdp->declBit  (c+566,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_dec",-1);
	vcdp->declBit  (c+292,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ssp_inc",-1);
	vcdp->declBit  (c+295,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ssp_dec",-1);
	vcdp->declBit  (c+135,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ssp_init",-1);
	vcdp->declBit  (c+132,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg sp_add_displ",-1);
	vcdp->declBit  (c+380,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg use_sp_adr",-1);
	vcdp->declBit  (c+470,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg use_ssp_adr",-1);
	vcdp->declBit  (c+325,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_wr",-1);
	vcdp->declBit  (c+119,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_inc",-1);
	vcdp->declBit  (c+675,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_tmp_clr",-1);
	vcdp->declBit  (c+312,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_tmp_inc",-1);
	vcdp->declBit  (c+313,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_init",-1);
	vcdp->declBit  (c+322,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_add_displ",-1);
	vcdp->declBit  (c+455,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg src_destn",-1);
	vcdp->declBit  (c+574,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg sbit",-1);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg op",-1,6,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg op_size",-1,1,0);
	vcdp->declBus  (c+398,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg op_mode",-1,4,0);
	vcdp->declBit  (c+118,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg op_start",-1);
	vcdp->declBus  (c+392,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_mode",-1,2,0);
	vcdp->declBus  (c+356,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg move_d_am",-1,2,0);
	vcdp->declBit  (c+395,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg force_biw2",-1);
	vcdp->declBit  (c+476,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg force_biw3",-1);
	vcdp->declBus  (c+448,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ext_dsize",-1,1,0);
	vcdp->declBit  (c+400,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg sel_displace_biw",-1);
	vcdp->declBus  (c+475,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg displace_biw",-1,31,0);
	vcdp->declBus  (c+124,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg regsel_index",-1,2,0);
	vcdp->declBus  (c+98,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg index_d_in",-1,31,0);
	vcdp->declBit  (c+568,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg chk_pc",-1);
	vcdp->declBit  (c+567,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg chk_adr",-1);
	vcdp->declBit  (c+136,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg trap_aerr",-1);
	vcdp->declBus  (c+94,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_eff",-1,31,0);
	vcdp->declBus  (c+604,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg index_tmp",-1,31,0);
	vcdp->declBus  (c+150,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg index_ext",-1,31,0);
	vcdp->declBus  (c+151,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg iwl_ida",-1,1,0);
	vcdp->declBus  (c+605,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_tmpvar",-1,3,0);
	vcdp->declBus  (c+152,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_eff_tmp",-1,31,0);
	vcdp->declBus  (c+153,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg areg",-1,31,0);
	{int i; for (i=0; i<7; i++) {
		vcdp->declBus  (c+606+i*1,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar",(i+0),31,0);}}
	vcdp->declBus  (c+154,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg data_signed",-1,31,0);
	vcdp->declBus  (c+578,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg usp",-1,31,0);
	vcdp->declBus  (c+576,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ssp",-1,31,0);
	vcdp->declBus  (c+613,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc",-1,31,0);
	vcdp->declBus  (c+614,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg areg_tmp",-1,31,0);
	vcdp->declBus  (c+460,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_mode_i",-1,2,0);
	vcdp->declBus  (c+499,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg displace",-1,31,0);
	vcdp->declBus  (c+500,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg displ_ext",-1,31,0);
	vcdp->declBit  (c+461,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg i_d_a",-1);
	vcdp->declBit  (c+462,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg i_w_l",-1);
	vcdp->declBus  (c+463,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg i_scale",-1,1,0);
	vcdp->declBit  (c+1065,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg index_sign",-1);
	vcdp->declBus  (c+155,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg index_scaled",-1,31,0);
	vcdp->declBus  (c+501,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg abs_address",-1,31,0);
	vcdp->declBus  (c+449,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_nr_a",-1,2,0);
	vcdp->declBus  (c+450,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_nr_b",-1,2,0);
	vcdp->declBus  (c+124,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_nr_i",-1,2,0);
	vcdp->declBus  (c+156,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_eff_i",-1,31,0);
	vcdp->declBus  (c+615,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg adr_tmp",-1,5,0);
	vcdp->declBus  (c+616,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_tmp",-1,4,0);
	vcdp->declBus  (c+478,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg pc_offset",-1,3,0);
	vcdp->declBus  (c+502,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_step",-1,2,0);
	vcdp->declBus  (c+291,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg i",-1,31,0);
	vcdp->declBus  (c+157,"v uut ff cpu wf68k00ip_top i_68k00 i_adrreg ar_sel",-1,31,0);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg resetn",-1);
	vcdp->declBus  (c+110,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg data_in_a",-1,31,0);
	vcdp->declBus  (c+111,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg data_in_b",-1,31,0);
	vcdp->declBus  (c+477,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg regsel_a",-1,2,0);
	vcdp->declBus  (c+123,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg regsel_b",-1,2,0);
	vcdp->declBus  (c+124,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg regsel_c",-1,2,0);
	vcdp->declBit  (c+354,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg div_mul_32n64",-1);
	vcdp->declBus  (c+498,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg data_out_a",-1,31,0);
	vcdp->declBus  (c+122,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg data_out_b",-1,31,0);
	vcdp->declBus  (c+98,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg data_out_c",-1,31,0);
	vcdp->declBit  (c+102,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_exg",-1);
	vcdp->declBit  (c+324,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_dec",-1);
	vcdp->declBit  (c+109,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_wr",-1);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg op",-1,6,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg op_size",-1,1,0);
	vcdp->declBus  (c+398,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg op_mode",-1,4,0);
	vcdp->declBit  (c+108,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dbcc_cond",-1);
	{int i; for (i=0; i<8; i++) {
		vcdp->declBus  (c+617+i*1,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr",(i+0),31,0);}}
	vcdp->declBus  (c+477,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_nr_a",-1,2,0);
	vcdp->declBus  (c+123,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_nr_b",-1,2,0);
	vcdp->declBus  (c+124,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_nr_c",-1,2,0);
	vcdp->declBus  (c+503,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_sel_a",-1,31,0);
	vcdp->declBus  (c+158,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg dr_sel_b",-1,31,0);
	vcdp->declBus  (c+625,"v uut ff cpu wf68k00ip_top i_68k00 i_datareg i",-1,31,0);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_alu resetn",-1);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_alu clk",-1);
	vcdp->declBus  (c+392,"v uut ff cpu wf68k00ip_top i_68k00 i_alu adr_mode",-1,2,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_size",-1,1,0);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op",-1,6,0);
	vcdp->declBus  (c+626,"v uut ff cpu wf68k00ip_top i_68k00 i_alu xnzvc_in",-1,4,0);
	vcdp->declBus  (c+140,"v uut ff cpu wf68k00ip_top i_68k00 i_alu xnzvc_out",-1,4,0);
	vcdp->declBus  (c+97,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_in_s",-1,31,0);
	vcdp->declBus  (c+98,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_in_d_hi",-1,31,0);
	vcdp->declBus  (c+99,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_in_d_lo",-1,31,0);
	vcdp->declBus  (c+126,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_hi",-1,31,0);
	vcdp->declBus  (c+127,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_lo",-1,31,0);
	vcdp->declBit  (c+118,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_start",-1);
	vcdp->declBit  (c+327,"v uut ff cpu wf68k00ip_top i_68k00 i_alu trap_chk_en",-1);
	vcdp->declBit  (c+354,"v uut ff cpu wf68k00ip_top i_68k00 i_alu div_mul_32n64",-1);
	vcdp->declBit  (c+117,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_busy",-1);
	vcdp->declBit  (c+326,"v uut ff cpu wf68k00ip_top i_68k00 i_alu trap_chk",-1);
	vcdp->declBit  (c+298,"v uut ff cpu wf68k00ip_top i_68k00 i_alu trap_divzero",-1);
	vcdp->declBit  (c+159,"v uut ff cpu wf68k00ip_top i_68k00 i_alu x_in_i",-1);
	vcdp->declBus  (c+160,"v uut ff cpu wf68k00ip_top i_68k00 i_alu temp0",-1,4,0);
	vcdp->declBus  (c+161,"v uut ff cpu wf68k00ip_top i_68k00 i_alu temp1",-1,4,0);
	vcdp->declBus  (c+162,"v uut ff cpu wf68k00ip_top i_68k00 i_alu z_0",-1,3,0);
	vcdp->declBus  (c+163,"v uut ff cpu wf68k00ip_top i_68k00 i_alu z_1",-1,3,0);
	vcdp->declBus  (c+164,"v uut ff cpu wf68k00ip_top i_68k00 i_alu s_0",-1,3,0);
	vcdp->declBus  (c+165,"v uut ff cpu wf68k00ip_top i_68k00 i_alu s_1",-1,3,0);
	vcdp->declBit  (c+166,"v uut ff cpu wf68k00ip_top i_68k00 i_alu z",-1);
	vcdp->declBit  (c+167,"v uut ff cpu wf68k00ip_top i_68k00 i_alu c_0",-1);
	vcdp->declBit  (c+168,"v uut ff cpu wf68k00ip_top i_68k00 i_alu c_1",-1);
	vcdp->declBit  (c+169,"v uut ff cpu wf68k00ip_top i_68k00 i_alu rm",-1);
	vcdp->declBit  (c+170,"v uut ff cpu wf68k00ip_top i_68k00 i_alu sm",-1);
	vcdp->declBit  (c+171,"v uut ff cpu wf68k00ip_top i_68k00 i_alu dm",-1);
	vcdp->declBus  (c+172,"v uut ff cpu wf68k00ip_top i_68k00 i_alu rm_sm_dm",-1,2,0);
	vcdp->declQuad (c+627,"v uut ff cpu wf68k00ip_top i_68k00 i_alu div_result_var",-1,32,0);
	vcdp->declBus  (c+629,"v uut ff cpu wf68k00ip_top i_68k00 i_alu mul_state",-1,1,0);
	vcdp->declBus  (c+300,"v uut ff cpu wf68k00ip_top i_68k00 i_alu next_mul_state",-1,1,0);
	vcdp->declBus  (c+630,"v uut ff cpu wf68k00ip_top i_68k00 i_alu div_state",-1,1,0);
	vcdp->declBus  (c+173,"v uut ff cpu wf68k00ip_top i_68k00 i_alu next_div_state",-1,1,0);
	vcdp->declBus  (c+174,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_in_s_sign",-1,31,0);
	vcdp->declBus  (c+175,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_in_d_sign_lo",-1,31,0);
	vcdp->declBus  (c+176,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_logop",-1,31,0);
	vcdp->declBus  (c+177,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_bcd",-1,7,0);
	vcdp->declBus  (c+178,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_intop",-1,31,0);
	vcdp->declBus  (c+179,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_special",-1,31,0);
	vcdp->declBus  (c+180,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_i_out",-1,31,0);
	vcdp->declBus  (c+631,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_i",-1,31,0);
	vcdp->declQuad (c+181,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_ii_out",-1,32,0);
	vcdp->declQuad (c+632,"v uut ff cpu wf68k00ip_top i_68k00 i_alu result_ii",-1,32,0);
	vcdp->declQuad (c+634,"v uut ff cpu wf68k00ip_top i_68k00 i_alu divisor",-1,63,0);
	vcdp->declQuad (c+636,"v uut ff cpu wf68k00ip_top i_68k00 i_alu dividend",-1,63,0);
	vcdp->declBit  (c+183,"v uut ff cpu wf68k00ip_top i_68k00 i_alu cb_bcd",-1);
	vcdp->declBit  (c+638,"v uut ff cpu wf68k00ip_top i_68k00 i_alu ov_div_mul",-1);
	vcdp->declBus  (c+639,"v uut ff cpu wf68k00ip_top i_68k00 i_alu mul_cyc_cnt",-1,5,0);
	vcdp->declBit  (c+640,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_mul",-1);
	vcdp->declBit  (c+184,"v uut ff cpu wf68k00ip_top i_68k00 i_alu op_div",-1);
	vcdp->declBus  (c+185,"v uut ff cpu wf68k00ip_top i_68k00 i_alu mul_div_op_s",-1,31,0);
	vcdp->declBus  (c+186,"v uut ff cpu wf68k00ip_top i_68k00 i_alu mul_op_d",-1,31,0);
	vcdp->declBus  (c+641,"v uut ff cpu wf68k00ip_top i_68k00 i_alu div_var",-1,31,0);
	vcdp->declBit  (c+187,"v uut ff cpu wf68k00ip_top i_68k00 i_alu div_shift_en",-1);
	vcdp->declBit  (c+188,"v uut ff cpu wf68k00ip_top i_68k00 i_alu chk_cond",-1);
	vcdp->declBus  (c+189,"v uut ff cpu wf68k00ip_top i_68k00 i_alu i",-1,31,0);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_shft clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_shft resetn",-1);
	vcdp->declBus  (c+130,"v uut ff cpu wf68k00ip_top i_68k00 i_shft data_in",-1,31,0);
	vcdp->declBus  (c+128,"v uut ff cpu wf68k00ip_top i_68k00 i_shft data_out",-1,31,0);
	vcdp->declBus  (c+397,"v uut ff cpu wf68k00ip_top i_68k00 i_shft op",-1,6,0);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_shft op_size",-1,1,0);
	vcdp->declBus  (c+494,"v uut ff cpu wf68k00ip_top i_68k00 i_shft bit_pos",-1,4,0);
	vcdp->declBus  (c+495,"v uut ff cpu wf68k00ip_top i_68k00 i_shft cnt_nr",-1,5,0);
	vcdp->declBit  (c+131,"v uut ff cpu wf68k00ip_top i_68k00 i_shft shifter_load",-1);
	vcdp->declBit  (c+575,"v uut ff cpu wf68k00ip_top i_68k00 i_shft shft_busy",-1);
	vcdp->declBus  (c+626,"v uut ff cpu wf68k00ip_top i_68k00 i_shft xnzvc_in",-1,4,0);
	vcdp->declBus  (c+141,"v uut ff cpu wf68k00ip_top i_68k00 i_shft xnzvc_out",-1,4,0);
	vcdp->declBus  (c+642,"v uut ff cpu wf68k00ip_top i_68k00 i_shft bit_cnt",-1,5,0);
	vcdp->declBit  (c+464,"v uut ff cpu wf68k00ip_top i_68k00 i_shft n_flag",-1);
	vcdp->declBit  (c+465,"v uut ff cpu wf68k00ip_top i_68k00 i_shft z_flag",-1);
	vcdp->declBit  (c+643,"v uut ff cpu wf68k00ip_top i_68k00 i_shft v_flag",-1);
	vcdp->declBit  (c+644,"v uut ff cpu wf68k00ip_top i_68k00 i_shft c_flag",-1);
	vcdp->declBit  (c+645,"v uut ff cpu wf68k00ip_top i_68k00 i_shft shift_state",-1);
	vcdp->declBus  (c+190,"v uut ff cpu wf68k00ip_top i_68k00 i_shft bit_op",-1,31,0);
	vcdp->declBus  (c+646,"v uut ff cpu wf68k00ip_top i_68k00 i_shft shft_op",-1,31,0);
	vcdp->declBit  (c+350,"v uut ff cpu wf68k00ip_top i_68k00 i_shft shft_en",-1);
	vcdp->declBit  (c+647,"v uut ff cpu wf68k00ip_top i_68k00 i_shft x_flag",-1);
	vcdp->declBit  (c+38,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if clk",-1);
	vcdp->declBit  (c+1058,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if resetn",-1);
	vcdp->declBit  (c+403,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_inn",-1);
	vcdp->declBit  (c+1020,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_out_en",-1);
	vcdp->declBit  (c+677,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_cpun",-1);
	vcdp->declBit  (c+125,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_en",-1);
	vcdp->declBit  (c+1028,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_rdy",-1);
	vcdp->declBus  (c+18,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if data_in",-1,15,0);
	vcdp->declBit  (c+452,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_a_hi",-1);
	vcdp->declBit  (c+453,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_a_midhi",-1);
	vcdp->declBit  (c+454,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_a_midlo",-1);
	vcdp->declBit  (c+451,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_a_lo",-1);
	vcdp->declBit  (c+508,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_buff_a_lo",-1);
	vcdp->declBit  (c+509,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_buff_a_hi",-1);
	vcdp->declBit  (c+379,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_buff_b_lo",-1);
	vcdp->declBit  (c+680,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sel_buff_b_hi",-1);
	vcdp->declBit  (c+510,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if sys_init",-1);
	vcdp->declBus  (c+399,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if op_size",-1,1,0);
	vcdp->declBus  (c+649,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if buffer_a",-1,31,0);
	vcdp->declBus  (c+650,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if buffer_b",-1,31,0);
	vcdp->declBus  (c+651,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if data_core_out",-1,15,0);
	vcdp->declBit  (c+507,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if rd_bus",-1);
	vcdp->declBit  (c+471,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if wr_bus",-1);
	vcdp->declBit  (c+681,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if tas_lock",-1);
	vcdp->declBit  (c+191,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if a0",-1);
	vcdp->declBit  (c+105,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if byten_word",-1);
	vcdp->declBit  (c+104,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if bus_cyc_rdy",-1);
	vcdp->declBit  (c+107,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if data_valid",-1);
	vcdp->declBit  (c+323,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if dtackn",-1);
	vcdp->declBit  (c+374,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if berrn",-1);
	vcdp->declBit  (c+373,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if avecn",-1);
	vcdp->declBit  (c+711,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if haltn",-1);
	vcdp->declBit  (c+288,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if adr_en",-1);
	vcdp->declBit  (c+682,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if wr_hi",-1);
	vcdp->declBit  (c+372,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if hi_word_en",-1);
	vcdp->declBit  (c+113,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if hi_byte_en",-1);
	vcdp->declBit  (c+116,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lo_byte_en",-1);
	vcdp->declBit  (c+316,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if fc_en",-1);
	vcdp->declBit  (c+536,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if asn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if as_en",-1);
	vcdp->declBit  (c+305,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if udsn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_en",-1);
	vcdp->declBit  (c+306,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if ldsn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_en",-1);
	vcdp->declBit  (c+504,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if rwn",-1);
	vcdp->declBit  (c+333,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if rw_en",-1);
	vcdp->declBit  (c+404,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if vpan",-1);
	vcdp->declBit  (c+694,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if vman",-1);
	vcdp->declBit  (c+709,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if vma_en",-1);
	vcdp->declBit  (c+693,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if e",-1);
	vcdp->declBit  (c+344,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if brn",-1);
	vcdp->declBit  (c+343,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if bgackn",-1);
	vcdp->declBit  (c+708,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if bgn",-1);
	vcdp->declBus  (c+695,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if e_timer",-1,3,0);
	vcdp->declBus  (c+687,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_filter",-1,3,0);
	vcdp->declBus  (c+1030,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_timer",-1,6,0);
	vcdp->declBit  (c+1031,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_timer_lock",-1);
	vcdp->declBit  (c+1020,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_out_en_i",-1);
	vcdp->declBit  (c+677,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if reset_cpu_in",-1);
	vcdp->declBus  (c+710,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if arb_state",-1,1,0);
	vcdp->declBus  (c+466,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if next_arb_state",-1,1,0);
	vcdp->declBus  (c+192,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if t_slice",-1,2,0);
	vcdp->declBus  (c+648,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if slice_cnt",-1,1,0);
	vcdp->declBit  (c+309,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if berr",-1);
	vcdp->declBit  (c+321,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if fc_enab",-1);
	vcdp->declBit  (c+694,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if vma_in",-1);
	vcdp->declBit  (c+529,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_rd_en_n",-1);
	vcdp->declBit  (c+558,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_rd_en_p",-1);
	vcdp->declBit  (c+367,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_rd_en",-1);
	vcdp->declBit  (c+530,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_rd_en_n",-1);
	vcdp->declBit  (c+559,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_rd_en_p",-1);
	vcdp->declBit  (c+368,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_rd_en",-1);
	vcdp->declBit  (c+531,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_wr_en_n",-1);
	vcdp->declBit  (c+560,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_wr_en_p",-1);
	vcdp->declBit  (c+369,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if uds_wr_en",-1);
	vcdp->declBit  (c+532,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_wr_en_n",-1);
	vcdp->declBit  (c+561,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_wr_en_p",-1);
	vcdp->declBit  (c+370,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if lds_wr_en",-1);
	vcdp->declBit  (c+533,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if as_enab_n",-1);
	vcdp->declBit  (c+562,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if as_enab_p",-1);
	vcdp->declBit  (c+537,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if as_enab",-1);
	vcdp->declBit  (c+534,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if adr_en_n",-1);
	vcdp->declBit  (c+563,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if adr_en_p",-1);
	vcdp->declBit  (c+535,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if data_en_n",-1);
	vcdp->declBit  (c+564,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if data_en_p",-1);
	vcdp->declBit  (c+371,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if data_en",-1);
	vcdp->declBit  (c+565,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if wr_enab_p",-1);
	vcdp->declBit  (c+565,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if wr_enab",-1);
	vcdp->declBit  (c+672,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if waitstates",-1);
	vcdp->declBit  (c+696,"v uut ff cpu wf68k00ip_top i_68k00 i_bus_if syncn",-1);
	vcdp->declBus  (c+193,"v uut ff nvram a",-1,7,0);
	vcdp->declBus  (c+194,"v uut ff nvram i",-1,3,0);
	vcdp->declBus  (c+28,"v uut ff nvram o",-1,3,0);
	vcdp->declBit  (c+27,"v uut ff nvram ce_n",-1);
	vcdp->declBit  (c+20,"v uut ff nvram rw_n",-1);
	vcdp->declBit  (c+51,"v uut ff nvram recall_n",-1);
	vcdp->declBit  (c+1039,"v uut ff nvram update",-1);
	// Tracing: v uut ff nvram ram // Ignored: Wide memory > 32 ents at ../rtl/nvram.v:15
	vcdp->declBus  (c+1,"v uut ff nvram j",-1,31,0);
	vcdp->declBit  (c+23,"v uut ff pal as_n",-1);
	vcdp->declBus  (c+195,"v uut ff pal a",-1,23,18);
	vcdp->declBus  (c+318,"v uut ff pal fc",-1,2,0);
	vcdp->declBit  (c+27,"v uut ff pal nvram_n",-1);
	vcdp->declBit  (c+54,"v uut ff pal i_o_n",-1);
	vcdp->declBit  (c+40,"v uut ff pal audio2_n",-1);
	vcdp->declBit  (c+55,"v uut ff pal pf_n",-1);
	vcdp->declBit  (c+41,"v uut ff pal audio1_n",-1);
	vcdp->declBit  (c+25,"v uut ff pal audio0_n",-1);
	vcdp->declBit  (c+37,"v uut ff pal dtack_n",-1);
	vcdp->declBit  (c+42,"v uut ff pal vpa_n",-1);
	vcdp->declBit  (c+317,"v uut ff pal avec_n",-1);
	vcdp->declBit  (c+196,"v uut ff pal nvram",-1);
	vcdp->declBit  (c+197,"v uut ff pal i_o",-1);
	vcdp->declBit  (c+198,"v uut ff pal audio2",-1);
	vcdp->declBit  (c+199,"v uut ff pal pf",-1);
	vcdp->declBit  (c+200,"v uut ff pal audio1",-1);
	vcdp->declBit  (c+201,"v uut ff pal audio0",-1);
	vcdp->declBit  (c+202,"v uut ff pal dtack",-1);
	vcdp->declBit  (c+203,"v uut ff pal vpa",-1);
	vcdp->declBit  (c+320,"v uut ff pal avec",-1);
	vcdp->declBus  (c+204,"v uut ff pal addr",-1,23,16);
	vcdp->declBus  (c+205,"v uut ff coderom_h a",-1,12,0);
	vcdp->declBus  (c+206,"v uut ff coderom_h out",-1,7,0);
	vcdp->declBit  (c+43,"v uut ff coderom_h ce0",-1);
	vcdp->declBit  (c+44,"v uut ff coderom_h ce1",-1);
	vcdp->declBit  (c+45,"v uut ff coderom_h ce2",-1);
	vcdp->declBit  (c+46,"v uut ff coderom_h ce3",-1);
	// Tracing: v uut ff coderom_h rom0 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:16
	// Tracing: v uut ff coderom_h rom1 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:17
	// Tracing: v uut ff coderom_h rom2 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:18
	// Tracing: v uut ff coderom_h rom3 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:19
	vcdp->declBus  (c+205,"v uut ff coderom_l a",-1,12,0);
	vcdp->declBus  (c+207,"v uut ff coderom_l out",-1,7,0);
	vcdp->declBit  (c+43,"v uut ff coderom_l ce0",-1);
	vcdp->declBit  (c+44,"v uut ff coderom_l ce1",-1);
	vcdp->declBit  (c+45,"v uut ff coderom_l ce2",-1);
	vcdp->declBit  (c+46,"v uut ff coderom_l ce3",-1);
	// Tracing: v uut ff coderom_l rom0 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:16
	// Tracing: v uut ff coderom_l rom1 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:17
	// Tracing: v uut ff coderom_l rom2 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:18
	// Tracing: v uut ff coderom_l rom3 // Ignored: Wide memory > 32 ents at ../rtl/coderom.v:19
	vcdp->declBus  (c+205,"v uut ff coderam_h a",-1,12,0);
	vcdp->declBus  (c+208,"v uut ff coderam_h out",-1,7,0);
	vcdp->declBus  (c+209,"v uut ff coderam_h in",-1,7,0);
	vcdp->declBit  (c+210,"v uut ff coderam_h cs",-1);
	vcdp->declBit  (c+33,"v uut ff coderam_h we",-1);
	// Tracing: v uut ff coderam_h ram // Ignored: Wide memory > 32 ents at ../rtl/coderam.v:15
	vcdp->declBus  (c+2,"v uut ff coderam_h i",-1,31,0);
	vcdp->declBus  (c+205,"v uut ff coderam_l a",-1,12,0);
	vcdp->declBus  (c+211,"v uut ff coderam_l out",-1,7,0);
	vcdp->declBus  (c+212,"v uut ff coderam_l in",-1,7,0);
	vcdp->declBit  (c+210,"v uut ff coderam_l cs",-1);
	vcdp->declBit  (c+34,"v uut ff coderam_l we",-1);
	// Tracing: v uut ff coderam_l ram // Ignored: Wide memory > 32 ents at ../rtl/coderam.v:15
	vcdp->declBus  (c+3,"v uut ff coderam_l i",-1,31,0);
	vcdp->declBus  (c+64,"v uut ff prom_2b a",-1,7,0);
	vcdp->declBus  (c+65,"v uut ff prom_2b d",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff prom_2b e1",-1);
	vcdp->declBit  (c+1062,"v uut ff prom_2b e2",-1);
	vcdp->declBus  (c+67,"v uut ff chip_3n_3m a",-1,9,0);
	vcdp->declBus  (c+209,"v uut ff chip_3n_3m in",-1,7,0);
	vcdp->declBus  (c+213,"v uut ff chip_3n_3m out",-1,7,0);
	vcdp->declBit  (c+334,"v uut ff chip_3n_3m cs_n",-1);
	vcdp->declBit  (c+68,"v uut ff chip_3n_3m we_n",-1);
	// Tracing: v uut ff chip_3n_3m ram // Ignored: Wide memory > 32 ents at ../rtl/ram_907036.v:12
	vcdp->declBus  (c+4,"v uut ff chip_3n_3m i",-1,31,0);
	vcdp->declBus  (c+67,"v uut ff chip_3l_3k a",-1,9,0);
	vcdp->declBus  (c+212,"v uut ff chip_3l_3k in",-1,7,0);
	vcdp->declBus  (c+214,"v uut ff chip_3l_3k out",-1,7,0);
	vcdp->declBit  (c+335,"v uut ff chip_3l_3k cs_n",-1);
	vcdp->declBit  (c+68,"v uut ff chip_3l_3k we_n",-1);
	// Tracing: v uut ff chip_3l_3k ram // Ignored: Wide memory > 32 ents at ../rtl/ram_907036.v:12
	vcdp->declBus  (c+5,"v uut ff chip_3l_3k i",-1,31,0);
	vcdp->declBus  (c+70,"v uut ff rom_6lm a",-1,12,0);
	vcdp->declBus  (c+69,"v uut ff rom_6lm d",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff rom_6lm ce",-1);
	vcdp->declBit  (c+1062,"v uut ff rom_6lm oe",-1);
	// Tracing: v uut ff rom_6lm rom // Ignored: Wide memory > 32 ents at ../rtl/rom_6lm.v:18
	vcdp->declBus  (c+215,"v uut ff chip_6c a",-1,7,0);
	vcdp->declBus  (c+216,"v uut ff chip_6c i",-1,3,0);
	vcdp->declBus  (c+217,"v uut ff chip_6c d",-1,3,0);
	vcdp->declBit  (c+75,"v uut ff chip_6c w",-1);
	vcdp->declBit  (c+1057,"v uut ff chip_6c cs2",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6c cs1",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6c oe",-1);
	// Tracing: v uut ff chip_6c ram // Ignored: Wide memory > 32 ents at ../rtl/ram_137250.v:14
	vcdp->declBus  (c+6,"v uut ff chip_6c j",-1,31,0);
	vcdp->declBus  (c+215,"v uut ff chip_6d a",-1,7,0);
	vcdp->declBus  (c+218,"v uut ff chip_6d i",-1,3,0);
	vcdp->declBus  (c+219,"v uut ff chip_6d d",-1,3,0);
	vcdp->declBit  (c+75,"v uut ff chip_6d w",-1);
	vcdp->declBit  (c+1057,"v uut ff chip_6d cs2",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6d cs1",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6d oe",-1);
	// Tracing: v uut ff chip_6d ram // Ignored: Wide memory > 32 ents at ../rtl/ram_137250.v:14
	vcdp->declBus  (c+7,"v uut ff chip_6d j",-1,31,0);
	vcdp->declBus  (c+215,"v uut ff chip_6e a",-1,7,0);
	vcdp->declBus  (c+220,"v uut ff chip_6e i",-1,3,0);
	vcdp->declBus  (c+221,"v uut ff chip_6e d",-1,3,0);
	vcdp->declBit  (c+74,"v uut ff chip_6e w",-1);
	vcdp->declBit  (c+1057,"v uut ff chip_6e cs2",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6e cs1",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6e oe",-1);
	// Tracing: v uut ff chip_6e ram // Ignored: Wide memory > 32 ents at ../rtl/ram_137250.v:14
	vcdp->declBus  (c+8,"v uut ff chip_6e j",-1,31,0);
	vcdp->declBus  (c+215,"v uut ff chip_6f a",-1,7,0);
	vcdp->declBus  (c+194,"v uut ff chip_6f i",-1,3,0);
	vcdp->declBus  (c+222,"v uut ff chip_6f d",-1,3,0);
	vcdp->declBit  (c+74,"v uut ff chip_6f w",-1);
	vcdp->declBit  (c+1057,"v uut ff chip_6f cs2",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6f cs1",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_6f oe",-1);
	// Tracing: v uut ff chip_6f ram // Ignored: Wide memory > 32 ents at ../rtl/ram_137250.v:14
	vcdp->declBus  (c+9,"v uut ff chip_6f j",-1,31,0);
	vcdp->declBus  (c+83,"v uut ff chip_4e a",-1,12,0);
	vcdp->declBus  (c+223,"v uut ff chip_4e d",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff chip_4e ce",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_4e oe",-1);
	// Tracing: v uut ff chip_4e rom // Ignored: Wide memory > 32 ents at ../rtl/rom_136020.v:11
	vcdp->declBus  (c+83,"v uut ff chip_4d a",-1,12,0);
	vcdp->declBus  (c+224,"v uut ff chip_4d d",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff chip_4d ce",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_4d oe",-1);
	// Tracing: v uut ff chip_4d rom // Ignored: Wide memory > 32 ents at ../rtl/rom_136020.v:11
	vcdp->declBit  (c+225,"v uut ff line_ram_odd rclk",-1);
	vcdp->declBit  (c+226,"v uut ff line_ram_odd wclk",-1);
	vcdp->declBus  (c+691,"v uut ff line_ram_odd a",-1,7,0);
	vcdp->declBus  (c+341,"v uut ff line_ram_odd i",-1,7,0);
	vcdp->declBus  (c+667,"v uut ff line_ram_odd o",-1,7,0);
	vcdp->declBit  (c+670,"v uut ff line_ram_odd oe",-1);
	vcdp->declBit  (c+670,"v uut ff line_ram_odd r",-1);
	vcdp->declBit  (c+227,"v uut ff line_ram_odd w",-1);
	// Tracing: v uut ff line_ram_odd ram // Ignored: Wide memory > 32 ents at ../rtl/ram_dp256x8.v:11
	vcdp->declBus  (c+667,"v uut ff line_ram_odd d",-1,7,0);
	vcdp->declBus  (c+10,"v uut ff line_ram_odd j",-1,31,0);
	vcdp->declBit  (c+670,"v uut ff line_ram_odd ram_read",-1);
	vcdp->declBit  (c+227,"v uut ff line_ram_odd ram_write",-1);
	vcdp->declBit  (c+226,"v uut ff line_ram_even rclk",-1);
	vcdp->declBit  (c+225,"v uut ff line_ram_even wclk",-1);
	vcdp->declBus  (c+692,"v uut ff line_ram_even a",-1,7,0);
	vcdp->declBus  (c+342,"v uut ff line_ram_even i",-1,7,0);
	vcdp->declBus  (c+669,"v uut ff line_ram_even o",-1,7,0);
	vcdp->declBit  (c+671,"v uut ff line_ram_even oe",-1);
	vcdp->declBit  (c+671,"v uut ff line_ram_even r",-1);
	vcdp->declBit  (c+228,"v uut ff line_ram_even w",-1);
	// Tracing: v uut ff line_ram_even ram // Ignored: Wide memory > 32 ents at ../rtl/ram_dp256x8.v:11
	vcdp->declBus  (c+669,"v uut ff line_ram_even d",-1,7,0);
	vcdp->declBus  (c+11,"v uut ff line_ram_even j",-1,31,0);
	vcdp->declBit  (c+671,"v uut ff line_ram_even ram_read",-1);
	vcdp->declBit  (c+228,"v uut ff line_ram_even ram_write",-1);
	vcdp->declBus  (c+88,"v uut ff chip_7p a",-1,7,0);
	vcdp->declBus  (c+220,"v uut ff chip_7p i",-1,3,0);
	vcdp->declBus  (c+229,"v uut ff chip_7p d",-1,3,0);
	vcdp->declBit  (c+90,"v uut ff chip_7p w",-1);
	vcdp->declBit  (c+1057,"v uut ff chip_7p cs2",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_7p cs1",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_7p oe",-1);
	// Tracing: v uut ff chip_7p ram // Ignored: Wide memory > 32 ents at ../rtl/ram_93422.v:14
	vcdp->declBus  (c+12,"v uut ff chip_7p j",-1,31,0);
	vcdp->declBit  (c+230,"v uut ff chip_7p ram_write",-1);
	vcdp->declBus  (c+88,"v uut ff chip_7n a",-1,7,0);
	vcdp->declBus  (c+194,"v uut ff chip_7n i",-1,3,0);
	vcdp->declBus  (c+231,"v uut ff chip_7n d",-1,3,0);
	vcdp->declBit  (c+90,"v uut ff chip_7n w",-1);
	vcdp->declBit  (c+1057,"v uut ff chip_7n cs2",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_7n cs1",-1);
	vcdp->declBit  (c+1062,"v uut ff chip_7n oe",-1);
	// Tracing: v uut ff chip_7n ram // Ignored: Wide memory > 32 ents at ../rtl/ram_93422.v:14
	vcdp->declBus  (c+13,"v uut ff chip_7n j",-1,31,0);
	vcdp->declBit  (c+230,"v uut ff chip_7n ram_write",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 phi2",-1);
	vcdp->declBit  (c+1044,"v uut ff pokey_2 reset",-1);
	vcdp->declBit  (c+20,"v uut ff pokey_2 r_w_n",-1);
	vcdp->declBit  (c+447,"v uut ff pokey_2 cs0_n",-1);
	vcdp->declBit  (c+40,"v uut ff pokey_2 cs1_n",-1);
	vcdp->declBus  (c+232,"v uut ff pokey_2 a",-1,3,0);
	vcdp->declBus  (c+212,"v uut ff pokey_2 d_in",-1,7,0);
	vcdp->declBus  (c+233,"v uut ff pokey_2 d_out",-1,7,0);
	vcdp->declBus  (c+1066,"v uut ff pokey_2 p",-1,7,0);
	vcdp->declBit  (c+721,"v uut ff pokey_2 aud",-1);
	vcdp->declBit  (c+234,"v uut ff pokey_2 stb",-1);
	vcdp->declBus  (c+722,"v uut ff pokey_2 audout",-1,5,0);
	vcdp->declBit  (c+1044,"v uut ff pokey_2 pokey rst_i",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey clk_i",-1);
	vcdp->declBus  (c+232,"v uut ff pokey_2 pokey adr_i",-1,3,0);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey dat_i",-1,7,0);
	vcdp->declBit  (c+20,"v uut ff pokey_2 pokey we_i",-1);
	vcdp->declBit  (c+234,"v uut ff pokey_2 pokey stb_i",-1);
	vcdp->declBus  (c+1066,"v uut ff pokey_2 pokey p_i",-1,7,0);
	vcdp->declBus  (c+233,"v uut ff pokey_2 pokey dat_o",-1,7,0);
	vcdp->declBus  (c+722,"v uut ff pokey_2 pokey audout",-1,5,0);
	vcdp->declBus  (c+1067,"v uut ff pokey_2 pokey key_code",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey key_pressed",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey key_shift",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey key_break",-1);
	vcdp->declBit  (c+1068,"v uut ff pokey_2 pokey serout_ack_i",-1);
	vcdp->declBus  (c+1067,"v uut ff pokey_2 pokey serin",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey serin_rdy_i",-1);
	vcdp->declBit  (c+234,"v uut ff pokey_2 pokey ack_o",-1);
	vcdp->declBit  (c+405,"v uut ff pokey_2 pokey irq",-1);
	vcdp->declBus  (c+723,"v uut ff pokey_2 pokey serout",-1,7,0);
	vcdp->declBit  (c+724,"v uut ff pokey_2 pokey serout_rdy_o",-1);
	vcdp->declBit  (c+725,"v uut ff pokey_2 pokey serin_ack_o",-1);
	vcdp->declBit  (c+726,"v uut ff pokey_2 pokey last_key_pressed",-1);
	vcdp->declBit  (c+727,"v uut ff pokey_2 pokey last_key_break",-1);
	vcdp->declBit  (c+728,"v uut ff pokey_2 pokey last_serin_rdy_i",-1);
	vcdp->declBit  (c+729,"v uut ff pokey_2 pokey last_serout_ack_i",-1);
	vcdp->declBit  (c+730,"v uut ff pokey_2 pokey rst",-1);
	vcdp->declBit  (c+235,"v uut ff pokey_2 pokey start_timer",-1);
	vcdp->declBus  (c+731,"v uut ff pokey_2 pokey audout0",-1,3,0);
	vcdp->declBus  (c+732,"v uut ff pokey_2 pokey audout1",-1,3,0);
	vcdp->declBus  (c+733,"v uut ff pokey_2 pokey audout2",-1,3,0);
	vcdp->declBus  (c+734,"v uut ff pokey_2 pokey audout3",-1,3,0);
	vcdp->declBus  (c+735,"v uut ff pokey_2 pokey rst_bits",-1,1,0);
	vcdp->declBus  (c+736,"v uut ff pokey_2 pokey irqen",-1,7,0);
	vcdp->declBus  (c+737,"v uut ff pokey_2 pokey irqst",-1,7,0);
	vcdp->declBit  (c+738,"v uut ff pokey_2 pokey poly9",-1);
	vcdp->declBit  (c+739,"v uut ff pokey_2 pokey fast_ch0",-1);
	vcdp->declBit  (c+740,"v uut ff pokey_2 pokey fast_ch2",-1);
	vcdp->declBit  (c+741,"v uut ff pokey_2 pokey ch01",-1);
	vcdp->declBit  (c+742,"v uut ff pokey_2 pokey ch23",-1);
	vcdp->declBit  (c+743,"v uut ff pokey_2 pokey fi02",-1);
	vcdp->declBit  (c+744,"v uut ff pokey_2 pokey fi13",-1);
	vcdp->declBit  (c+745,"v uut ff pokey_2 pokey base15",-1);
	vcdp->declBus  (c+236,"v uut ff pokey_2 pokey audf_we",-1,3,0);
	vcdp->declBus  (c+237,"v uut ff pokey_2 pokey audc_we",-1,3,0);
	vcdp->declBus  (c+238,"v uut ff pokey_2 pokey start",-1,3,0);
	vcdp->declBus  (c+479,"v uut ff pokey_2 pokey cnt_en",-1,3,0);
	vcdp->declBus  (c+406,"v uut ff pokey_2 pokey ctr_out",-1,31,0);
	vcdp->declBus  (c+407,"v uut ff pokey_2 pokey borrow",-1,3,0);
	vcdp->declBit  (c+746,"v uut ff pokey_2 pokey poly4",-1);
	vcdp->declBit  (c+747,"v uut ff pokey_2 pokey poly5",-1);
	vcdp->declBit  (c+748,"v uut ff pokey_2 pokey poly17",-1);
	vcdp->declBus  (c+749,"v uut ff pokey_2 pokey poly4_shift",-1,3,1);
	vcdp->declBus  (c+750,"v uut ff pokey_2 pokey poly5_shift",-1,3,1);
	vcdp->declBus  (c+751,"v uut ff pokey_2 pokey poly17_shift",-1,3,1);
	vcdp->declBit  (c+408,"v uut ff pokey_2 pokey base",-1);
	vcdp->declBus  (c+14,"v uut ff pokey_2 pokey i",-1,31,0);
	vcdp->declBus  (c+1069,"v uut ff pokey_2 pokey irq_i",-1,31,0);
	vcdp->declBus  (c+752,"v uut ff pokey_2 pokey random",-1,7,0);
	vcdp->declBus  (c+409,"v uut ff pokey_2 pokey pot_done",-1,7,0);
	{int i; for (i=0; i<8; i++) {
		vcdp->declBus  (c+753+i*1,"v uut ff pokey_2 pokey pot_cntr",(i+0),7,0);}}
	vcdp->declBus  (c+761,"v uut ff pokey_2 pokey pot_count",-1,7,0);
	vcdp->declBit  (c+730,"v uut ff pokey_2 pokey u_base rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_base clk_i",-1);
	vcdp->declBit  (c+745,"v uut ff pokey_2 pokey u_base base15",-1);
	vcdp->declBit  (c+408,"v uut ff pokey_2 pokey u_base out",-1);
	vcdp->declBus  (c+762,"v uut ff pokey_2 pokey u_base div57",-1,5,0);
	vcdp->declBus  (c+763,"v uut ff pokey_2 pokey u_base div4",-1,1,0);
	vcdp->declBit  (c+730,"v uut ff pokey_2 pokey u_poly4 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_poly4 clk_i",-1);
	vcdp->declBit  (c+746,"v uut ff pokey_2 pokey u_poly4 out",-1);
	vcdp->declBus  (c+764,"v uut ff pokey_2 pokey u_poly4 shift",-1,3,0);
	vcdp->declBit  (c+730,"v uut ff pokey_2 pokey u_poly5 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_poly5 clk_i",-1);
	vcdp->declBit  (c+747,"v uut ff pokey_2 pokey u_poly5 out",-1);
	vcdp->declBus  (c+765,"v uut ff pokey_2 pokey u_poly5 shift",-1,4,0);
	vcdp->declBit  (c+730,"v uut ff pokey_2 pokey u_poly17 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_poly17 clk_i",-1);
	vcdp->declBit  (c+738,"v uut ff pokey_2 pokey u_poly17 short",-1);
	vcdp->declBit  (c+748,"v uut ff pokey_2 pokey u_poly17 out",-1);
	vcdp->declBus  (c+752,"v uut ff pokey_2 pokey u_poly17 random",-1,7,0);
	vcdp->declBus  (c+766,"v uut ff pokey_2 pokey u_poly17 shift",-1,16,0);
	vcdp->declBit  (c+410,"v uut ff pokey_2 pokey u_poly17 new_bit",-1);
	vcdp->declBit  (c+767,"v uut ff pokey_2 pokey u_poly17 last_short",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_ctr0 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_ctr0 dat_i",-1,7,0);
	vcdp->declBit  (c+239,"v uut ff pokey_2 pokey u_ctr0 freq_ld",-1);
	vcdp->declBit  (c+240,"v uut ff pokey_2 pokey u_ctr0 start",-1);
	vcdp->declBit  (c+480,"v uut ff pokey_2 pokey u_ctr0 cnt_en",-1);
	vcdp->declBus  (c+768,"v uut ff pokey_2 pokey u_ctr0 out",-1,7,0);
	vcdp->declBit  (c+769,"v uut ff pokey_2 pokey u_ctr0 borrow",-1);
	vcdp->declBus  (c+770,"v uut ff pokey_2 pokey u_ctr0 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_ctr1 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_ctr1 dat_i",-1,7,0);
	vcdp->declBit  (c+241,"v uut ff pokey_2 pokey u_ctr1 freq_ld",-1);
	vcdp->declBit  (c+242,"v uut ff pokey_2 pokey u_ctr1 start",-1);
	vcdp->declBit  (c+481,"v uut ff pokey_2 pokey u_ctr1 cnt_en",-1);
	vcdp->declBus  (c+771,"v uut ff pokey_2 pokey u_ctr1 out",-1,7,0);
	vcdp->declBit  (c+772,"v uut ff pokey_2 pokey u_ctr1 borrow",-1);
	vcdp->declBus  (c+773,"v uut ff pokey_2 pokey u_ctr1 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_ctr2 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_ctr2 dat_i",-1,7,0);
	vcdp->declBit  (c+243,"v uut ff pokey_2 pokey u_ctr2 freq_ld",-1);
	vcdp->declBit  (c+244,"v uut ff pokey_2 pokey u_ctr2 start",-1);
	vcdp->declBit  (c+482,"v uut ff pokey_2 pokey u_ctr2 cnt_en",-1);
	vcdp->declBus  (c+774,"v uut ff pokey_2 pokey u_ctr2 out",-1,7,0);
	vcdp->declBit  (c+775,"v uut ff pokey_2 pokey u_ctr2 borrow",-1);
	vcdp->declBus  (c+776,"v uut ff pokey_2 pokey u_ctr2 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_ctr3 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_ctr3 dat_i",-1,7,0);
	vcdp->declBit  (c+245,"v uut ff pokey_2 pokey u_ctr3 freq_ld",-1);
	vcdp->declBit  (c+246,"v uut ff pokey_2 pokey u_ctr3 start",-1);
	vcdp->declBit  (c+483,"v uut ff pokey_2 pokey u_ctr3 cnt_en",-1);
	vcdp->declBus  (c+777,"v uut ff pokey_2 pokey u_ctr3 out",-1,7,0);
	vcdp->declBit  (c+778,"v uut ff pokey_2 pokey u_ctr3 borrow",-1);
	vcdp->declBus  (c+779,"v uut ff pokey_2 pokey u_ctr3 freq",-1,7,0);
	vcdp->declBit  (c+235,"v uut ff pokey_2 pokey u_audout0 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_audout0 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_audout0 dat_i",-1,7,0);
	vcdp->declBit  (c+247,"v uut ff pokey_2 pokey u_audout0 audc_we",-1);
	vcdp->declBit  (c+746,"v uut ff pokey_2 pokey u_audout0 poly4",-1);
	vcdp->declBit  (c+747,"v uut ff pokey_2 pokey u_audout0 poly5",-1);
	vcdp->declBit  (c+748,"v uut ff pokey_2 pokey u_audout0 poly17",-1);
	vcdp->declBit  (c+411,"v uut ff pokey_2 pokey u_audout0 in",-1);
	vcdp->declBit  (c+743,"v uut ff pokey_2 pokey u_audout0 filter_en",-1);
	vcdp->declBit  (c+412,"v uut ff pokey_2 pokey u_audout0 filter_in",-1);
	vcdp->declBus  (c+731,"v uut ff pokey_2 pokey u_audout0 out",-1,3,0);
	vcdp->declBit  (c+780,"v uut ff pokey_2 pokey u_audout0 ch_out",-1);
	vcdp->declBit  (c+781,"v uut ff pokey_2 pokey u_audout0 vol_only",-1);
	vcdp->declBus  (c+782,"v uut ff pokey_2 pokey u_audout0 vol",-1,3,0);
	vcdp->declBit  (c+783,"v uut ff pokey_2 pokey u_audout0 no_poly5",-1);
	vcdp->declBit  (c+784,"v uut ff pokey_2 pokey u_audout0 poly4_sel",-1);
	vcdp->declBit  (c+785,"v uut ff pokey_2 pokey u_audout0 no_poly17_4",-1);
	vcdp->declBit  (c+786,"v uut ff pokey_2 pokey u_audout0 nf",-1);
	vcdp->declBit  (c+787,"v uut ff pokey_2 pokey u_audout0 filter_reg",-1);
	vcdp->declBit  (c+413,"v uut ff pokey_2 pokey u_audout0 change",-1);
	vcdp->declBit  (c+235,"v uut ff pokey_2 pokey u_audout1 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_audout1 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_audout1 dat_i",-1,7,0);
	vcdp->declBit  (c+248,"v uut ff pokey_2 pokey u_audout1 audc_we",-1);
	vcdp->declBit  (c+788,"v uut ff pokey_2 pokey u_audout1 poly4",-1);
	vcdp->declBit  (c+789,"v uut ff pokey_2 pokey u_audout1 poly5",-1);
	vcdp->declBit  (c+790,"v uut ff pokey_2 pokey u_audout1 poly17",-1);
	vcdp->declBit  (c+414,"v uut ff pokey_2 pokey u_audout1 in",-1);
	vcdp->declBit  (c+744,"v uut ff pokey_2 pokey u_audout1 filter_en",-1);
	vcdp->declBit  (c+415,"v uut ff pokey_2 pokey u_audout1 filter_in",-1);
	vcdp->declBus  (c+732,"v uut ff pokey_2 pokey u_audout1 out",-1,3,0);
	vcdp->declBit  (c+791,"v uut ff pokey_2 pokey u_audout1 ch_out",-1);
	vcdp->declBit  (c+792,"v uut ff pokey_2 pokey u_audout1 vol_only",-1);
	vcdp->declBus  (c+793,"v uut ff pokey_2 pokey u_audout1 vol",-1,3,0);
	vcdp->declBit  (c+794,"v uut ff pokey_2 pokey u_audout1 no_poly5",-1);
	vcdp->declBit  (c+795,"v uut ff pokey_2 pokey u_audout1 poly4_sel",-1);
	vcdp->declBit  (c+796,"v uut ff pokey_2 pokey u_audout1 no_poly17_4",-1);
	vcdp->declBit  (c+797,"v uut ff pokey_2 pokey u_audout1 nf",-1);
	vcdp->declBit  (c+798,"v uut ff pokey_2 pokey u_audout1 filter_reg",-1);
	vcdp->declBit  (c+416,"v uut ff pokey_2 pokey u_audout1 change",-1);
	vcdp->declBit  (c+235,"v uut ff pokey_2 pokey u_audout2 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_audout2 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_audout2 dat_i",-1,7,0);
	vcdp->declBit  (c+249,"v uut ff pokey_2 pokey u_audout2 audc_we",-1);
	vcdp->declBit  (c+799,"v uut ff pokey_2 pokey u_audout2 poly4",-1);
	vcdp->declBit  (c+800,"v uut ff pokey_2 pokey u_audout2 poly5",-1);
	vcdp->declBit  (c+801,"v uut ff pokey_2 pokey u_audout2 poly17",-1);
	vcdp->declBit  (c+412,"v uut ff pokey_2 pokey u_audout2 in",-1);
	vcdp->declBus  (c+733,"v uut ff pokey_2 pokey u_audout2 out",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey u_audout2 filter_en",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey u_audout2 filter_in",-1);
	vcdp->declBit  (c+802,"v uut ff pokey_2 pokey u_audout2 ch_out",-1);
	vcdp->declBit  (c+803,"v uut ff pokey_2 pokey u_audout2 vol_only",-1);
	vcdp->declBus  (c+804,"v uut ff pokey_2 pokey u_audout2 vol",-1,3,0);
	vcdp->declBit  (c+805,"v uut ff pokey_2 pokey u_audout2 no_poly5",-1);
	vcdp->declBit  (c+806,"v uut ff pokey_2 pokey u_audout2 poly4_sel",-1);
	vcdp->declBit  (c+807,"v uut ff pokey_2 pokey u_audout2 no_poly17_4",-1);
	vcdp->declBit  (c+802,"v uut ff pokey_2 pokey u_audout2 nf",-1);
	vcdp->declBit  (c+808,"v uut ff pokey_2 pokey u_audout2 filter_reg",-1);
	vcdp->declBit  (c+417,"v uut ff pokey_2 pokey u_audout2 change",-1);
	vcdp->declBit  (c+235,"v uut ff pokey_2 pokey u_audout3 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_2 pokey u_audout3 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_2 pokey u_audout3 dat_i",-1,7,0);
	vcdp->declBit  (c+250,"v uut ff pokey_2 pokey u_audout3 audc_we",-1);
	vcdp->declBit  (c+809,"v uut ff pokey_2 pokey u_audout3 poly4",-1);
	vcdp->declBit  (c+810,"v uut ff pokey_2 pokey u_audout3 poly5",-1);
	vcdp->declBit  (c+811,"v uut ff pokey_2 pokey u_audout3 poly17",-1);
	vcdp->declBit  (c+415,"v uut ff pokey_2 pokey u_audout3 in",-1);
	vcdp->declBus  (c+734,"v uut ff pokey_2 pokey u_audout3 out",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey u_audout3 filter_en",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_2 pokey u_audout3 filter_in",-1);
	vcdp->declBit  (c+812,"v uut ff pokey_2 pokey u_audout3 ch_out",-1);
	vcdp->declBit  (c+813,"v uut ff pokey_2 pokey u_audout3 vol_only",-1);
	vcdp->declBus  (c+814,"v uut ff pokey_2 pokey u_audout3 vol",-1,3,0);
	vcdp->declBit  (c+815,"v uut ff pokey_2 pokey u_audout3 no_poly5",-1);
	vcdp->declBit  (c+816,"v uut ff pokey_2 pokey u_audout3 poly4_sel",-1);
	vcdp->declBit  (c+817,"v uut ff pokey_2 pokey u_audout3 no_poly17_4",-1);
	vcdp->declBit  (c+812,"v uut ff pokey_2 pokey u_audout3 nf",-1);
	vcdp->declBit  (c+818,"v uut ff pokey_2 pokey u_audout3 filter_reg",-1);
	vcdp->declBit  (c+418,"v uut ff pokey_2 pokey u_audout3 change",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 phi2",-1);
	vcdp->declBit  (c+1044,"v uut ff pokey_1 reset",-1);
	vcdp->declBit  (c+20,"v uut ff pokey_1 r_w_n",-1);
	vcdp->declBit  (c+447,"v uut ff pokey_1 cs0_n",-1);
	vcdp->declBit  (c+41,"v uut ff pokey_1 cs1_n",-1);
	vcdp->declBus  (c+232,"v uut ff pokey_1 a",-1,3,0);
	vcdp->declBus  (c+212,"v uut ff pokey_1 d_in",-1,7,0);
	vcdp->declBus  (c+251,"v uut ff pokey_1 d_out",-1,7,0);
	vcdp->declBus  (c+1070,"v uut ff pokey_1 p",-1,7,0);
	vcdp->declBit  (c+819,"v uut ff pokey_1 aud",-1);
	vcdp->declBit  (c+252,"v uut ff pokey_1 stb",-1);
	vcdp->declBus  (c+820,"v uut ff pokey_1 audout",-1,5,0);
	vcdp->declBit  (c+1044,"v uut ff pokey_1 pokey rst_i",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey clk_i",-1);
	vcdp->declBus  (c+232,"v uut ff pokey_1 pokey adr_i",-1,3,0);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey dat_i",-1,7,0);
	vcdp->declBit  (c+20,"v uut ff pokey_1 pokey we_i",-1);
	vcdp->declBit  (c+252,"v uut ff pokey_1 pokey stb_i",-1);
	vcdp->declBus  (c+1070,"v uut ff pokey_1 pokey p_i",-1,7,0);
	vcdp->declBus  (c+251,"v uut ff pokey_1 pokey dat_o",-1,7,0);
	vcdp->declBus  (c+820,"v uut ff pokey_1 pokey audout",-1,5,0);
	vcdp->declBus  (c+1067,"v uut ff pokey_1 pokey key_code",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey key_pressed",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey key_shift",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey key_break",-1);
	vcdp->declBit  (c+1071,"v uut ff pokey_1 pokey serout_ack_i",-1);
	vcdp->declBus  (c+1067,"v uut ff pokey_1 pokey serin",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey serin_rdy_i",-1);
	vcdp->declBit  (c+252,"v uut ff pokey_1 pokey ack_o",-1);
	vcdp->declBit  (c+419,"v uut ff pokey_1 pokey irq",-1);
	vcdp->declBus  (c+821,"v uut ff pokey_1 pokey serout",-1,7,0);
	vcdp->declBit  (c+822,"v uut ff pokey_1 pokey serout_rdy_o",-1);
	vcdp->declBit  (c+823,"v uut ff pokey_1 pokey serin_ack_o",-1);
	vcdp->declBit  (c+824,"v uut ff pokey_1 pokey last_key_pressed",-1);
	vcdp->declBit  (c+825,"v uut ff pokey_1 pokey last_key_break",-1);
	vcdp->declBit  (c+826,"v uut ff pokey_1 pokey last_serin_rdy_i",-1);
	vcdp->declBit  (c+827,"v uut ff pokey_1 pokey last_serout_ack_i",-1);
	vcdp->declBit  (c+828,"v uut ff pokey_1 pokey rst",-1);
	vcdp->declBit  (c+253,"v uut ff pokey_1 pokey start_timer",-1);
	vcdp->declBus  (c+829,"v uut ff pokey_1 pokey audout0",-1,3,0);
	vcdp->declBus  (c+830,"v uut ff pokey_1 pokey audout1",-1,3,0);
	vcdp->declBus  (c+831,"v uut ff pokey_1 pokey audout2",-1,3,0);
	vcdp->declBus  (c+832,"v uut ff pokey_1 pokey audout3",-1,3,0);
	vcdp->declBus  (c+833,"v uut ff pokey_1 pokey rst_bits",-1,1,0);
	vcdp->declBus  (c+834,"v uut ff pokey_1 pokey irqen",-1,7,0);
	vcdp->declBus  (c+835,"v uut ff pokey_1 pokey irqst",-1,7,0);
	vcdp->declBit  (c+836,"v uut ff pokey_1 pokey poly9",-1);
	vcdp->declBit  (c+837,"v uut ff pokey_1 pokey fast_ch0",-1);
	vcdp->declBit  (c+838,"v uut ff pokey_1 pokey fast_ch2",-1);
	vcdp->declBit  (c+839,"v uut ff pokey_1 pokey ch01",-1);
	vcdp->declBit  (c+840,"v uut ff pokey_1 pokey ch23",-1);
	vcdp->declBit  (c+841,"v uut ff pokey_1 pokey fi02",-1);
	vcdp->declBit  (c+842,"v uut ff pokey_1 pokey fi13",-1);
	vcdp->declBit  (c+843,"v uut ff pokey_1 pokey base15",-1);
	vcdp->declBus  (c+254,"v uut ff pokey_1 pokey audf_we",-1,3,0);
	vcdp->declBus  (c+255,"v uut ff pokey_1 pokey audc_we",-1,3,0);
	vcdp->declBus  (c+256,"v uut ff pokey_1 pokey start",-1,3,0);
	vcdp->declBus  (c+484,"v uut ff pokey_1 pokey cnt_en",-1,3,0);
	vcdp->declBus  (c+420,"v uut ff pokey_1 pokey ctr_out",-1,31,0);
	vcdp->declBus  (c+421,"v uut ff pokey_1 pokey borrow",-1,3,0);
	vcdp->declBit  (c+844,"v uut ff pokey_1 pokey poly4",-1);
	vcdp->declBit  (c+845,"v uut ff pokey_1 pokey poly5",-1);
	vcdp->declBit  (c+846,"v uut ff pokey_1 pokey poly17",-1);
	vcdp->declBus  (c+847,"v uut ff pokey_1 pokey poly4_shift",-1,3,1);
	vcdp->declBus  (c+848,"v uut ff pokey_1 pokey poly5_shift",-1,3,1);
	vcdp->declBus  (c+849,"v uut ff pokey_1 pokey poly17_shift",-1,3,1);
	vcdp->declBit  (c+422,"v uut ff pokey_1 pokey base",-1);
	vcdp->declBus  (c+15,"v uut ff pokey_1 pokey i",-1,31,0);
	vcdp->declBus  (c+1072,"v uut ff pokey_1 pokey irq_i",-1,31,0);
	vcdp->declBus  (c+850,"v uut ff pokey_1 pokey random",-1,7,0);
	vcdp->declBus  (c+423,"v uut ff pokey_1 pokey pot_done",-1,7,0);
	{int i; for (i=0; i<8; i++) {
		vcdp->declBus  (c+851+i*1,"v uut ff pokey_1 pokey pot_cntr",(i+0),7,0);}}
	vcdp->declBus  (c+859,"v uut ff pokey_1 pokey pot_count",-1,7,0);
	vcdp->declBit  (c+828,"v uut ff pokey_1 pokey u_base rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_base clk_i",-1);
	vcdp->declBit  (c+843,"v uut ff pokey_1 pokey u_base base15",-1);
	vcdp->declBit  (c+422,"v uut ff pokey_1 pokey u_base out",-1);
	vcdp->declBus  (c+860,"v uut ff pokey_1 pokey u_base div57",-1,5,0);
	vcdp->declBus  (c+861,"v uut ff pokey_1 pokey u_base div4",-1,1,0);
	vcdp->declBit  (c+828,"v uut ff pokey_1 pokey u_poly4 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_poly4 clk_i",-1);
	vcdp->declBit  (c+844,"v uut ff pokey_1 pokey u_poly4 out",-1);
	vcdp->declBus  (c+862,"v uut ff pokey_1 pokey u_poly4 shift",-1,3,0);
	vcdp->declBit  (c+828,"v uut ff pokey_1 pokey u_poly5 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_poly5 clk_i",-1);
	vcdp->declBit  (c+845,"v uut ff pokey_1 pokey u_poly5 out",-1);
	vcdp->declBus  (c+863,"v uut ff pokey_1 pokey u_poly5 shift",-1,4,0);
	vcdp->declBit  (c+828,"v uut ff pokey_1 pokey u_poly17 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_poly17 clk_i",-1);
	vcdp->declBit  (c+836,"v uut ff pokey_1 pokey u_poly17 short",-1);
	vcdp->declBit  (c+846,"v uut ff pokey_1 pokey u_poly17 out",-1);
	vcdp->declBus  (c+850,"v uut ff pokey_1 pokey u_poly17 random",-1,7,0);
	vcdp->declBus  (c+864,"v uut ff pokey_1 pokey u_poly17 shift",-1,16,0);
	vcdp->declBit  (c+424,"v uut ff pokey_1 pokey u_poly17 new_bit",-1);
	vcdp->declBit  (c+865,"v uut ff pokey_1 pokey u_poly17 last_short",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_ctr0 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_ctr0 dat_i",-1,7,0);
	vcdp->declBit  (c+257,"v uut ff pokey_1 pokey u_ctr0 freq_ld",-1);
	vcdp->declBit  (c+258,"v uut ff pokey_1 pokey u_ctr0 start",-1);
	vcdp->declBit  (c+485,"v uut ff pokey_1 pokey u_ctr0 cnt_en",-1);
	vcdp->declBus  (c+866,"v uut ff pokey_1 pokey u_ctr0 out",-1,7,0);
	vcdp->declBit  (c+867,"v uut ff pokey_1 pokey u_ctr0 borrow",-1);
	vcdp->declBus  (c+868,"v uut ff pokey_1 pokey u_ctr0 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_ctr1 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_ctr1 dat_i",-1,7,0);
	vcdp->declBit  (c+259,"v uut ff pokey_1 pokey u_ctr1 freq_ld",-1);
	vcdp->declBit  (c+260,"v uut ff pokey_1 pokey u_ctr1 start",-1);
	vcdp->declBit  (c+486,"v uut ff pokey_1 pokey u_ctr1 cnt_en",-1);
	vcdp->declBus  (c+869,"v uut ff pokey_1 pokey u_ctr1 out",-1,7,0);
	vcdp->declBit  (c+870,"v uut ff pokey_1 pokey u_ctr1 borrow",-1);
	vcdp->declBus  (c+871,"v uut ff pokey_1 pokey u_ctr1 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_ctr2 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_ctr2 dat_i",-1,7,0);
	vcdp->declBit  (c+261,"v uut ff pokey_1 pokey u_ctr2 freq_ld",-1);
	vcdp->declBit  (c+262,"v uut ff pokey_1 pokey u_ctr2 start",-1);
	vcdp->declBit  (c+487,"v uut ff pokey_1 pokey u_ctr2 cnt_en",-1);
	vcdp->declBus  (c+872,"v uut ff pokey_1 pokey u_ctr2 out",-1,7,0);
	vcdp->declBit  (c+873,"v uut ff pokey_1 pokey u_ctr2 borrow",-1);
	vcdp->declBus  (c+874,"v uut ff pokey_1 pokey u_ctr2 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_ctr3 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_ctr3 dat_i",-1,7,0);
	vcdp->declBit  (c+263,"v uut ff pokey_1 pokey u_ctr3 freq_ld",-1);
	vcdp->declBit  (c+264,"v uut ff pokey_1 pokey u_ctr3 start",-1);
	vcdp->declBit  (c+488,"v uut ff pokey_1 pokey u_ctr3 cnt_en",-1);
	vcdp->declBus  (c+875,"v uut ff pokey_1 pokey u_ctr3 out",-1,7,0);
	vcdp->declBit  (c+876,"v uut ff pokey_1 pokey u_ctr3 borrow",-1);
	vcdp->declBus  (c+877,"v uut ff pokey_1 pokey u_ctr3 freq",-1,7,0);
	vcdp->declBit  (c+253,"v uut ff pokey_1 pokey u_audout0 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_audout0 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_audout0 dat_i",-1,7,0);
	vcdp->declBit  (c+265,"v uut ff pokey_1 pokey u_audout0 audc_we",-1);
	vcdp->declBit  (c+844,"v uut ff pokey_1 pokey u_audout0 poly4",-1);
	vcdp->declBit  (c+845,"v uut ff pokey_1 pokey u_audout0 poly5",-1);
	vcdp->declBit  (c+846,"v uut ff pokey_1 pokey u_audout0 poly17",-1);
	vcdp->declBit  (c+425,"v uut ff pokey_1 pokey u_audout0 in",-1);
	vcdp->declBit  (c+841,"v uut ff pokey_1 pokey u_audout0 filter_en",-1);
	vcdp->declBit  (c+426,"v uut ff pokey_1 pokey u_audout0 filter_in",-1);
	vcdp->declBus  (c+829,"v uut ff pokey_1 pokey u_audout0 out",-1,3,0);
	vcdp->declBit  (c+878,"v uut ff pokey_1 pokey u_audout0 ch_out",-1);
	vcdp->declBit  (c+879,"v uut ff pokey_1 pokey u_audout0 vol_only",-1);
	vcdp->declBus  (c+880,"v uut ff pokey_1 pokey u_audout0 vol",-1,3,0);
	vcdp->declBit  (c+881,"v uut ff pokey_1 pokey u_audout0 no_poly5",-1);
	vcdp->declBit  (c+882,"v uut ff pokey_1 pokey u_audout0 poly4_sel",-1);
	vcdp->declBit  (c+883,"v uut ff pokey_1 pokey u_audout0 no_poly17_4",-1);
	vcdp->declBit  (c+884,"v uut ff pokey_1 pokey u_audout0 nf",-1);
	vcdp->declBit  (c+885,"v uut ff pokey_1 pokey u_audout0 filter_reg",-1);
	vcdp->declBit  (c+427,"v uut ff pokey_1 pokey u_audout0 change",-1);
	vcdp->declBit  (c+253,"v uut ff pokey_1 pokey u_audout1 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_audout1 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_audout1 dat_i",-1,7,0);
	vcdp->declBit  (c+266,"v uut ff pokey_1 pokey u_audout1 audc_we",-1);
	vcdp->declBit  (c+886,"v uut ff pokey_1 pokey u_audout1 poly4",-1);
	vcdp->declBit  (c+887,"v uut ff pokey_1 pokey u_audout1 poly5",-1);
	vcdp->declBit  (c+888,"v uut ff pokey_1 pokey u_audout1 poly17",-1);
	vcdp->declBit  (c+428,"v uut ff pokey_1 pokey u_audout1 in",-1);
	vcdp->declBit  (c+842,"v uut ff pokey_1 pokey u_audout1 filter_en",-1);
	vcdp->declBit  (c+429,"v uut ff pokey_1 pokey u_audout1 filter_in",-1);
	vcdp->declBus  (c+830,"v uut ff pokey_1 pokey u_audout1 out",-1,3,0);
	vcdp->declBit  (c+889,"v uut ff pokey_1 pokey u_audout1 ch_out",-1);
	vcdp->declBit  (c+890,"v uut ff pokey_1 pokey u_audout1 vol_only",-1);
	vcdp->declBus  (c+891,"v uut ff pokey_1 pokey u_audout1 vol",-1,3,0);
	vcdp->declBit  (c+892,"v uut ff pokey_1 pokey u_audout1 no_poly5",-1);
	vcdp->declBit  (c+893,"v uut ff pokey_1 pokey u_audout1 poly4_sel",-1);
	vcdp->declBit  (c+894,"v uut ff pokey_1 pokey u_audout1 no_poly17_4",-1);
	vcdp->declBit  (c+895,"v uut ff pokey_1 pokey u_audout1 nf",-1);
	vcdp->declBit  (c+896,"v uut ff pokey_1 pokey u_audout1 filter_reg",-1);
	vcdp->declBit  (c+430,"v uut ff pokey_1 pokey u_audout1 change",-1);
	vcdp->declBit  (c+253,"v uut ff pokey_1 pokey u_audout2 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_audout2 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_audout2 dat_i",-1,7,0);
	vcdp->declBit  (c+267,"v uut ff pokey_1 pokey u_audout2 audc_we",-1);
	vcdp->declBit  (c+897,"v uut ff pokey_1 pokey u_audout2 poly4",-1);
	vcdp->declBit  (c+898,"v uut ff pokey_1 pokey u_audout2 poly5",-1);
	vcdp->declBit  (c+899,"v uut ff pokey_1 pokey u_audout2 poly17",-1);
	vcdp->declBit  (c+426,"v uut ff pokey_1 pokey u_audout2 in",-1);
	vcdp->declBus  (c+831,"v uut ff pokey_1 pokey u_audout2 out",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey u_audout2 filter_en",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey u_audout2 filter_in",-1);
	vcdp->declBit  (c+900,"v uut ff pokey_1 pokey u_audout2 ch_out",-1);
	vcdp->declBit  (c+901,"v uut ff pokey_1 pokey u_audout2 vol_only",-1);
	vcdp->declBus  (c+902,"v uut ff pokey_1 pokey u_audout2 vol",-1,3,0);
	vcdp->declBit  (c+903,"v uut ff pokey_1 pokey u_audout2 no_poly5",-1);
	vcdp->declBit  (c+904,"v uut ff pokey_1 pokey u_audout2 poly4_sel",-1);
	vcdp->declBit  (c+905,"v uut ff pokey_1 pokey u_audout2 no_poly17_4",-1);
	vcdp->declBit  (c+900,"v uut ff pokey_1 pokey u_audout2 nf",-1);
	vcdp->declBit  (c+906,"v uut ff pokey_1 pokey u_audout2 filter_reg",-1);
	vcdp->declBit  (c+431,"v uut ff pokey_1 pokey u_audout2 change",-1);
	vcdp->declBit  (c+253,"v uut ff pokey_1 pokey u_audout3 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_1 pokey u_audout3 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_1 pokey u_audout3 dat_i",-1,7,0);
	vcdp->declBit  (c+268,"v uut ff pokey_1 pokey u_audout3 audc_we",-1);
	vcdp->declBit  (c+907,"v uut ff pokey_1 pokey u_audout3 poly4",-1);
	vcdp->declBit  (c+908,"v uut ff pokey_1 pokey u_audout3 poly5",-1);
	vcdp->declBit  (c+909,"v uut ff pokey_1 pokey u_audout3 poly17",-1);
	vcdp->declBit  (c+429,"v uut ff pokey_1 pokey u_audout3 in",-1);
	vcdp->declBus  (c+832,"v uut ff pokey_1 pokey u_audout3 out",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey u_audout3 filter_en",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_1 pokey u_audout3 filter_in",-1);
	vcdp->declBit  (c+910,"v uut ff pokey_1 pokey u_audout3 ch_out",-1);
	vcdp->declBit  (c+911,"v uut ff pokey_1 pokey u_audout3 vol_only",-1);
	vcdp->declBus  (c+912,"v uut ff pokey_1 pokey u_audout3 vol",-1,3,0);
	vcdp->declBit  (c+913,"v uut ff pokey_1 pokey u_audout3 no_poly5",-1);
	vcdp->declBit  (c+914,"v uut ff pokey_1 pokey u_audout3 poly4_sel",-1);
	vcdp->declBit  (c+915,"v uut ff pokey_1 pokey u_audout3 no_poly17_4",-1);
	vcdp->declBit  (c+910,"v uut ff pokey_1 pokey u_audout3 nf",-1);
	vcdp->declBit  (c+916,"v uut ff pokey_1 pokey u_audout3 filter_reg",-1);
	vcdp->declBit  (c+432,"v uut ff pokey_1 pokey u_audout3 change",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 phi2",-1);
	vcdp->declBit  (c+1044,"v uut ff pokey_0 reset",-1);
	vcdp->declBit  (c+20,"v uut ff pokey_0 r_w_n",-1);
	vcdp->declBit  (c+447,"v uut ff pokey_0 cs0_n",-1);
	vcdp->declBit  (c+25,"v uut ff pokey_0 cs1_n",-1);
	vcdp->declBus  (c+232,"v uut ff pokey_0 a",-1,3,0);
	vcdp->declBus  (c+212,"v uut ff pokey_0 d_in",-1,7,0);
	vcdp->declBus  (c+29,"v uut ff pokey_0 d_out",-1,7,0);
	vcdp->declBus  (c+1046,"v uut ff pokey_0 p",-1,7,0);
	vcdp->declBit  (c+917,"v uut ff pokey_0 aud",-1);
	vcdp->declBit  (c+269,"v uut ff pokey_0 stb",-1);
	vcdp->declBus  (c+918,"v uut ff pokey_0 audout",-1,5,0);
	vcdp->declBit  (c+1044,"v uut ff pokey_0 pokey rst_i",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey clk_i",-1);
	vcdp->declBus  (c+232,"v uut ff pokey_0 pokey adr_i",-1,3,0);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey dat_i",-1,7,0);
	vcdp->declBit  (c+20,"v uut ff pokey_0 pokey we_i",-1);
	vcdp->declBit  (c+269,"v uut ff pokey_0 pokey stb_i",-1);
	vcdp->declBus  (c+1046,"v uut ff pokey_0 pokey p_i",-1,7,0);
	vcdp->declBus  (c+29,"v uut ff pokey_0 pokey dat_o",-1,7,0);
	vcdp->declBus  (c+918,"v uut ff pokey_0 pokey audout",-1,5,0);
	vcdp->declBus  (c+1067,"v uut ff pokey_0 pokey key_code",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey key_pressed",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey key_shift",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey key_break",-1);
	vcdp->declBit  (c+1073,"v uut ff pokey_0 pokey serout_ack_i",-1);
	vcdp->declBus  (c+1067,"v uut ff pokey_0 pokey serin",-1,7,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey serin_rdy_i",-1);
	vcdp->declBit  (c+269,"v uut ff pokey_0 pokey ack_o",-1);
	vcdp->declBit  (c+433,"v uut ff pokey_0 pokey irq",-1);
	vcdp->declBus  (c+919,"v uut ff pokey_0 pokey serout",-1,7,0);
	vcdp->declBit  (c+920,"v uut ff pokey_0 pokey serout_rdy_o",-1);
	vcdp->declBit  (c+921,"v uut ff pokey_0 pokey serin_ack_o",-1);
	vcdp->declBit  (c+922,"v uut ff pokey_0 pokey last_key_pressed",-1);
	vcdp->declBit  (c+923,"v uut ff pokey_0 pokey last_key_break",-1);
	vcdp->declBit  (c+924,"v uut ff pokey_0 pokey last_serin_rdy_i",-1);
	vcdp->declBit  (c+925,"v uut ff pokey_0 pokey last_serout_ack_i",-1);
	vcdp->declBit  (c+926,"v uut ff pokey_0 pokey rst",-1);
	vcdp->declBit  (c+270,"v uut ff pokey_0 pokey start_timer",-1);
	vcdp->declBus  (c+927,"v uut ff pokey_0 pokey audout0",-1,3,0);
	vcdp->declBus  (c+928,"v uut ff pokey_0 pokey audout1",-1,3,0);
	vcdp->declBus  (c+929,"v uut ff pokey_0 pokey audout2",-1,3,0);
	vcdp->declBus  (c+930,"v uut ff pokey_0 pokey audout3",-1,3,0);
	vcdp->declBus  (c+931,"v uut ff pokey_0 pokey rst_bits",-1,1,0);
	vcdp->declBus  (c+932,"v uut ff pokey_0 pokey irqen",-1,7,0);
	vcdp->declBus  (c+933,"v uut ff pokey_0 pokey irqst",-1,7,0);
	vcdp->declBit  (c+934,"v uut ff pokey_0 pokey poly9",-1);
	vcdp->declBit  (c+935,"v uut ff pokey_0 pokey fast_ch0",-1);
	vcdp->declBit  (c+936,"v uut ff pokey_0 pokey fast_ch2",-1);
	vcdp->declBit  (c+937,"v uut ff pokey_0 pokey ch01",-1);
	vcdp->declBit  (c+938,"v uut ff pokey_0 pokey ch23",-1);
	vcdp->declBit  (c+939,"v uut ff pokey_0 pokey fi02",-1);
	vcdp->declBit  (c+940,"v uut ff pokey_0 pokey fi13",-1);
	vcdp->declBit  (c+941,"v uut ff pokey_0 pokey base15",-1);
	vcdp->declBus  (c+271,"v uut ff pokey_0 pokey audf_we",-1,3,0);
	vcdp->declBus  (c+272,"v uut ff pokey_0 pokey audc_we",-1,3,0);
	vcdp->declBus  (c+273,"v uut ff pokey_0 pokey start",-1,3,0);
	vcdp->declBus  (c+489,"v uut ff pokey_0 pokey cnt_en",-1,3,0);
	vcdp->declBus  (c+434,"v uut ff pokey_0 pokey ctr_out",-1,31,0);
	vcdp->declBus  (c+435,"v uut ff pokey_0 pokey borrow",-1,3,0);
	vcdp->declBit  (c+942,"v uut ff pokey_0 pokey poly4",-1);
	vcdp->declBit  (c+943,"v uut ff pokey_0 pokey poly5",-1);
	vcdp->declBit  (c+944,"v uut ff pokey_0 pokey poly17",-1);
	vcdp->declBus  (c+945,"v uut ff pokey_0 pokey poly4_shift",-1,3,1);
	vcdp->declBus  (c+946,"v uut ff pokey_0 pokey poly5_shift",-1,3,1);
	vcdp->declBus  (c+947,"v uut ff pokey_0 pokey poly17_shift",-1,3,1);
	vcdp->declBit  (c+436,"v uut ff pokey_0 pokey base",-1);
	vcdp->declBus  (c+16,"v uut ff pokey_0 pokey i",-1,31,0);
	vcdp->declBus  (c+1074,"v uut ff pokey_0 pokey irq_i",-1,31,0);
	vcdp->declBus  (c+948,"v uut ff pokey_0 pokey random",-1,7,0);
	vcdp->declBus  (c+437,"v uut ff pokey_0 pokey pot_done",-1,7,0);
	{int i; for (i=0; i<8; i++) {
		vcdp->declBus  (c+949+i*1,"v uut ff pokey_0 pokey pot_cntr",(i+0),7,0);}}
	vcdp->declBus  (c+957,"v uut ff pokey_0 pokey pot_count",-1,7,0);
	vcdp->declBit  (c+926,"v uut ff pokey_0 pokey u_base rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_base clk_i",-1);
	vcdp->declBit  (c+941,"v uut ff pokey_0 pokey u_base base15",-1);
	vcdp->declBit  (c+436,"v uut ff pokey_0 pokey u_base out",-1);
	vcdp->declBus  (c+958,"v uut ff pokey_0 pokey u_base div57",-1,5,0);
	vcdp->declBus  (c+959,"v uut ff pokey_0 pokey u_base div4",-1,1,0);
	vcdp->declBit  (c+926,"v uut ff pokey_0 pokey u_poly4 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_poly4 clk_i",-1);
	vcdp->declBit  (c+942,"v uut ff pokey_0 pokey u_poly4 out",-1);
	vcdp->declBus  (c+960,"v uut ff pokey_0 pokey u_poly4 shift",-1,3,0);
	vcdp->declBit  (c+926,"v uut ff pokey_0 pokey u_poly5 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_poly5 clk_i",-1);
	vcdp->declBit  (c+943,"v uut ff pokey_0 pokey u_poly5 out",-1);
	vcdp->declBus  (c+961,"v uut ff pokey_0 pokey u_poly5 shift",-1,4,0);
	vcdp->declBit  (c+926,"v uut ff pokey_0 pokey u_poly17 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_poly17 clk_i",-1);
	vcdp->declBit  (c+934,"v uut ff pokey_0 pokey u_poly17 short",-1);
	vcdp->declBit  (c+944,"v uut ff pokey_0 pokey u_poly17 out",-1);
	vcdp->declBus  (c+948,"v uut ff pokey_0 pokey u_poly17 random",-1,7,0);
	vcdp->declBus  (c+962,"v uut ff pokey_0 pokey u_poly17 shift",-1,16,0);
	vcdp->declBit  (c+438,"v uut ff pokey_0 pokey u_poly17 new_bit",-1);
	vcdp->declBit  (c+963,"v uut ff pokey_0 pokey u_poly17 last_short",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_ctr0 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_ctr0 dat_i",-1,7,0);
	vcdp->declBit  (c+274,"v uut ff pokey_0 pokey u_ctr0 freq_ld",-1);
	vcdp->declBit  (c+275,"v uut ff pokey_0 pokey u_ctr0 start",-1);
	vcdp->declBit  (c+490,"v uut ff pokey_0 pokey u_ctr0 cnt_en",-1);
	vcdp->declBus  (c+964,"v uut ff pokey_0 pokey u_ctr0 out",-1,7,0);
	vcdp->declBit  (c+965,"v uut ff pokey_0 pokey u_ctr0 borrow",-1);
	vcdp->declBus  (c+966,"v uut ff pokey_0 pokey u_ctr0 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_ctr1 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_ctr1 dat_i",-1,7,0);
	vcdp->declBit  (c+276,"v uut ff pokey_0 pokey u_ctr1 freq_ld",-1);
	vcdp->declBit  (c+277,"v uut ff pokey_0 pokey u_ctr1 start",-1);
	vcdp->declBit  (c+491,"v uut ff pokey_0 pokey u_ctr1 cnt_en",-1);
	vcdp->declBus  (c+967,"v uut ff pokey_0 pokey u_ctr1 out",-1,7,0);
	vcdp->declBit  (c+968,"v uut ff pokey_0 pokey u_ctr1 borrow",-1);
	vcdp->declBus  (c+969,"v uut ff pokey_0 pokey u_ctr1 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_ctr2 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_ctr2 dat_i",-1,7,0);
	vcdp->declBit  (c+278,"v uut ff pokey_0 pokey u_ctr2 freq_ld",-1);
	vcdp->declBit  (c+279,"v uut ff pokey_0 pokey u_ctr2 start",-1);
	vcdp->declBit  (c+492,"v uut ff pokey_0 pokey u_ctr2 cnt_en",-1);
	vcdp->declBus  (c+970,"v uut ff pokey_0 pokey u_ctr2 out",-1,7,0);
	vcdp->declBit  (c+971,"v uut ff pokey_0 pokey u_ctr2 borrow",-1);
	vcdp->declBus  (c+972,"v uut ff pokey_0 pokey u_ctr2 freq",-1,7,0);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_ctr3 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_ctr3 dat_i",-1,7,0);
	vcdp->declBit  (c+280,"v uut ff pokey_0 pokey u_ctr3 freq_ld",-1);
	vcdp->declBit  (c+281,"v uut ff pokey_0 pokey u_ctr3 start",-1);
	vcdp->declBit  (c+493,"v uut ff pokey_0 pokey u_ctr3 cnt_en",-1);
	vcdp->declBus  (c+973,"v uut ff pokey_0 pokey u_ctr3 out",-1,7,0);
	vcdp->declBit  (c+974,"v uut ff pokey_0 pokey u_ctr3 borrow",-1);
	vcdp->declBus  (c+975,"v uut ff pokey_0 pokey u_ctr3 freq",-1,7,0);
	vcdp->declBit  (c+270,"v uut ff pokey_0 pokey u_audout0 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_audout0 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_audout0 dat_i",-1,7,0);
	vcdp->declBit  (c+282,"v uut ff pokey_0 pokey u_audout0 audc_we",-1);
	vcdp->declBit  (c+942,"v uut ff pokey_0 pokey u_audout0 poly4",-1);
	vcdp->declBit  (c+943,"v uut ff pokey_0 pokey u_audout0 poly5",-1);
	vcdp->declBit  (c+944,"v uut ff pokey_0 pokey u_audout0 poly17",-1);
	vcdp->declBit  (c+439,"v uut ff pokey_0 pokey u_audout0 in",-1);
	vcdp->declBit  (c+939,"v uut ff pokey_0 pokey u_audout0 filter_en",-1);
	vcdp->declBit  (c+440,"v uut ff pokey_0 pokey u_audout0 filter_in",-1);
	vcdp->declBus  (c+927,"v uut ff pokey_0 pokey u_audout0 out",-1,3,0);
	vcdp->declBit  (c+976,"v uut ff pokey_0 pokey u_audout0 ch_out",-1);
	vcdp->declBit  (c+977,"v uut ff pokey_0 pokey u_audout0 vol_only",-1);
	vcdp->declBus  (c+978,"v uut ff pokey_0 pokey u_audout0 vol",-1,3,0);
	vcdp->declBit  (c+979,"v uut ff pokey_0 pokey u_audout0 no_poly5",-1);
	vcdp->declBit  (c+980,"v uut ff pokey_0 pokey u_audout0 poly4_sel",-1);
	vcdp->declBit  (c+981,"v uut ff pokey_0 pokey u_audout0 no_poly17_4",-1);
	vcdp->declBit  (c+982,"v uut ff pokey_0 pokey u_audout0 nf",-1);
	vcdp->declBit  (c+983,"v uut ff pokey_0 pokey u_audout0 filter_reg",-1);
	vcdp->declBit  (c+441,"v uut ff pokey_0 pokey u_audout0 change",-1);
	vcdp->declBit  (c+270,"v uut ff pokey_0 pokey u_audout1 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_audout1 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_audout1 dat_i",-1,7,0);
	vcdp->declBit  (c+283,"v uut ff pokey_0 pokey u_audout1 audc_we",-1);
	vcdp->declBit  (c+984,"v uut ff pokey_0 pokey u_audout1 poly4",-1);
	vcdp->declBit  (c+985,"v uut ff pokey_0 pokey u_audout1 poly5",-1);
	vcdp->declBit  (c+986,"v uut ff pokey_0 pokey u_audout1 poly17",-1);
	vcdp->declBit  (c+442,"v uut ff pokey_0 pokey u_audout1 in",-1);
	vcdp->declBit  (c+940,"v uut ff pokey_0 pokey u_audout1 filter_en",-1);
	vcdp->declBit  (c+443,"v uut ff pokey_0 pokey u_audout1 filter_in",-1);
	vcdp->declBus  (c+928,"v uut ff pokey_0 pokey u_audout1 out",-1,3,0);
	vcdp->declBit  (c+987,"v uut ff pokey_0 pokey u_audout1 ch_out",-1);
	vcdp->declBit  (c+988,"v uut ff pokey_0 pokey u_audout1 vol_only",-1);
	vcdp->declBus  (c+989,"v uut ff pokey_0 pokey u_audout1 vol",-1,3,0);
	vcdp->declBit  (c+990,"v uut ff pokey_0 pokey u_audout1 no_poly5",-1);
	vcdp->declBit  (c+991,"v uut ff pokey_0 pokey u_audout1 poly4_sel",-1);
	vcdp->declBit  (c+992,"v uut ff pokey_0 pokey u_audout1 no_poly17_4",-1);
	vcdp->declBit  (c+993,"v uut ff pokey_0 pokey u_audout1 nf",-1);
	vcdp->declBit  (c+994,"v uut ff pokey_0 pokey u_audout1 filter_reg",-1);
	vcdp->declBit  (c+444,"v uut ff pokey_0 pokey u_audout1 change",-1);
	vcdp->declBit  (c+270,"v uut ff pokey_0 pokey u_audout2 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_audout2 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_audout2 dat_i",-1,7,0);
	vcdp->declBit  (c+284,"v uut ff pokey_0 pokey u_audout2 audc_we",-1);
	vcdp->declBit  (c+995,"v uut ff pokey_0 pokey u_audout2 poly4",-1);
	vcdp->declBit  (c+996,"v uut ff pokey_0 pokey u_audout2 poly5",-1);
	vcdp->declBit  (c+997,"v uut ff pokey_0 pokey u_audout2 poly17",-1);
	vcdp->declBit  (c+440,"v uut ff pokey_0 pokey u_audout2 in",-1);
	vcdp->declBus  (c+929,"v uut ff pokey_0 pokey u_audout2 out",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey u_audout2 filter_en",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey u_audout2 filter_in",-1);
	vcdp->declBit  (c+998,"v uut ff pokey_0 pokey u_audout2 ch_out",-1);
	vcdp->declBit  (c+999,"v uut ff pokey_0 pokey u_audout2 vol_only",-1);
	vcdp->declBus  (c+1000,"v uut ff pokey_0 pokey u_audout2 vol",-1,3,0);
	vcdp->declBit  (c+1001,"v uut ff pokey_0 pokey u_audout2 no_poly5",-1);
	vcdp->declBit  (c+1002,"v uut ff pokey_0 pokey u_audout2 poly4_sel",-1);
	vcdp->declBit  (c+1003,"v uut ff pokey_0 pokey u_audout2 no_poly17_4",-1);
	vcdp->declBit  (c+998,"v uut ff pokey_0 pokey u_audout2 nf",-1);
	vcdp->declBit  (c+1004,"v uut ff pokey_0 pokey u_audout2 filter_reg",-1);
	vcdp->declBit  (c+445,"v uut ff pokey_0 pokey u_audout2 change",-1);
	vcdp->declBit  (c+270,"v uut ff pokey_0 pokey u_audout3 rst",-1);
	vcdp->declBit  (c+693,"v uut ff pokey_0 pokey u_audout3 clk_i",-1);
	vcdp->declBus  (c+212,"v uut ff pokey_0 pokey u_audout3 dat_i",-1,7,0);
	vcdp->declBit  (c+285,"v uut ff pokey_0 pokey u_audout3 audc_we",-1);
	vcdp->declBit  (c+1005,"v uut ff pokey_0 pokey u_audout3 poly4",-1);
	vcdp->declBit  (c+1006,"v uut ff pokey_0 pokey u_audout3 poly5",-1);
	vcdp->declBit  (c+1007,"v uut ff pokey_0 pokey u_audout3 poly17",-1);
	vcdp->declBit  (c+443,"v uut ff pokey_0 pokey u_audout3 in",-1);
	vcdp->declBus  (c+930,"v uut ff pokey_0 pokey u_audout3 out",-1,3,0);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey u_audout3 filter_en",-1);
	vcdp->declBit  (c+1062,"v uut ff pokey_0 pokey u_audout3 filter_in",-1);
	vcdp->declBit  (c+1008,"v uut ff pokey_0 pokey u_audout3 ch_out",-1);
	vcdp->declBit  (c+1009,"v uut ff pokey_0 pokey u_audout3 vol_only",-1);
	vcdp->declBus  (c+1010,"v uut ff pokey_0 pokey u_audout3 vol",-1,3,0);
	vcdp->declBit  (c+1011,"v uut ff pokey_0 pokey u_audout3 no_poly5",-1);
	vcdp->declBit  (c+1012,"v uut ff pokey_0 pokey u_audout3 poly4_sel",-1);
	vcdp->declBit  (c+1013,"v uut ff pokey_0 pokey u_audout3 no_poly17_4",-1);
	vcdp->declBit  (c+1008,"v uut ff pokey_0 pokey u_audout3 nf",-1);
	vcdp->declBit  (c+1014,"v uut ff pokey_0 pokey u_audout3 filter_reg",-1);
	vcdp->declBit  (c+446,"v uut ff pokey_0 pokey u_audout3 change",-1);
    }
}

void Vff_verilator::traceFullThis__1(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->fullBus  (c+1,(vlTOPp->v__DOT__uut__DOT__ff__DOT__nvram__DOT__j),32);
	vcdp->fullBus  (c+2,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coderam_h__DOT__i),32);
	vcdp->fullBus  (c+3,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coderam_l__DOT__i),32);
	vcdp->fullBus  (c+4,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_3n_3m__DOT__i),32);
	vcdp->fullBus  (c+5,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_3l_3k__DOT__i),32);
	vcdp->fullBus  (c+6,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6c__DOT__j),32);
	vcdp->fullBus  (c+7,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6d__DOT__j),32);
	vcdp->fullBus  (c+8,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6e__DOT__j),32);
	vcdp->fullBus  (c+9,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6f__DOT__j),32);
	vcdp->fullBus  (c+10,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_odd__DOT__j),32);
	vcdp->fullBus  (c+11,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_even__DOT__j),32);
	vcdp->fullBus  (c+12,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_7p__DOT__j),32);
	vcdp->fullBus  (c+13,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_7n__DOT__j),32);
	vcdp->fullBus  (c+14,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__i),32);
	vcdp->fullBus  (c+15,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__i),32);
	vcdp->fullBus  (c+16,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__i),32);
	vcdp->fullBus  (c+17,((vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
			       << 1)),24);
	vcdp->fullBit  (c+24,((1 & (~ ((((0x94 == (0xfc 
						   & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						      >> 0xf))) 
					 & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					       >> 0xf))) 
					& (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0xe))) 
				       & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0xd)))))));
	vcdp->fullBit  (c+26,(vlTOPp->v__DOT__uut__DOT__ff__DOT__digitalin_n));
	vcdp->fullBus  (c+28,(vlTOPp->v__DOT__uut__DOT__ff__DOT__nvram_out),4);
	vcdp->fullBus  (c+30,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_out),16);
	vcdp->fullBus  (c+31,(((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram0_n)) 
				     | (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram1_n))))
			        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_ram)
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_rom))),16);
	vcdp->fullBus  (c+32,((0xfffe & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					 << 1))),16);
	vcdp->fullBit  (c+33,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_n) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__uds_n))));
	vcdp->fullBit  (c+34,(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_l_n));
	vcdp->fullBit  (c+35,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_n)))));
	vcdp->fullBit  (c+36,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__as_n)))));
	vcdp->fullBit  (c+37,((1 & (~ ((~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					   >> 0x16)) 
				       | (0x90 == (0xfc 
						   & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						      >> 0xf))))))));
	vcdp->fullBit  (c+39,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_l_n) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__digitalin_n))));
	vcdp->fullBit  (c+47,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram0_n));
	vcdp->fullBit  (c+48,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram1_n));
	vcdp->fullBit  (c+49,(vlTOPp->v__DOT__uut__DOT__ff__DOT__objram_n));
	vcdp->fullBit  (c+50,((1 & (~ ((((0x94 == (0xfc 
						   & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						      >> 0xf))) 
					 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					    >> 0xf)) 
					& (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					   >> 0xe)) 
				       & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0xd)))))));
	vcdp->fullBit  (c+51,((1 & (~ ((((0x94 == (0xfc 
						   & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						      >> 0xf))) 
					 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					    >> 0xf)) 
					& (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0xe))) 
				       & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					  >> 0xd))))));
	vcdp->fullBit  (c+52,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloram_n));
	vcdp->fullBit  (c+53,((1 & (~ ((((0x94 == (0xfc 
						   & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						      >> 0xf))) 
					 & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					       >> 0xf))) 
					& (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0xe))) 
				       & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					  >> 0xd))))));
	vcdp->fullBit  (c+54,((0x94 != (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->fullBit  (c+55,((0x80 != (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->fullBit  (c+56,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h));
	vcdp->fullBit  (c+57,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_8h));
	vcdp->fullBus  (c+58,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_rom),16);
	vcdp->fullBus  (c+59,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_ram),16);
	vcdp->fullBit  (c+60,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_6mhz));
	vcdp->fullBit  (c+61,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_32h));
	vcdp->fullBit  (c+62,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h)))));
	vcdp->fullBit  (c+63,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_256h_n));
	vcdp->fullBus  (c+64,(vlTOPp->v__DOT__uut__DOT__ff__DOT__prom_2b_addr),8);
	vcdp->fullBus  (c+65,(vlTOPp->v__DOT__uut__DOT__ff__DOT__prom_out),4);
	vcdp->fullBit  (c+66,(vlTOPp->v__DOT__uut__DOT__ff__DOT__blank_n));
	vcdp->fullBus  (c+69,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_data),8);
	vcdp->fullBus  (c+70,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_rom_addr),13);
	vcdp->fullBit  (c+71,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_s0));
	vcdp->fullBus  (c+72,(vlTOPp->v__DOT__uut__DOT__ff__DOT__moram_addr),7);
	vcdp->fullBus  (c+73,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mod),16);
	vcdp->fullBus  (c+76,(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum),8);
	vcdp->fullBit  (c+77,((1 & (((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
				       >> 7) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
						>> 6)) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
					>> 5)) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
						  >> 4)))));
	vcdp->fullBit  (c+78,(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddclk));
	vcdp->fullBit  (c+79,(vlTOPp->v__DOT__uut__DOT__ff__DOT__evencs_n));
	vcdp->fullBit  (c+80,(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddcs_n));
	vcdp->fullBit  (c+81,(vlTOPp->v__DOT__uut__DOT__ff__DOT__evenclk));
	vcdp->fullBit  (c+82,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hload_n));
	vcdp->fullBus  (c+84,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4e__d) 
				<< 8) | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4d__d))),16);
	vcdp->fullBus  (c+85,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s1s0),2);
	vcdp->fullBit  (c+86,(vlTOPp->v__DOT__uut__DOT__ff__DOT__regld));
	vcdp->fullBit  (c+87,(vlTOPp->v__DOT__uut__DOT__ff__DOT__stamp_active));
	vcdp->fullBus  (c+89,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb_cr_out),8);
	vcdp->fullBit  (c+91,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloram_n)))));
	vcdp->fullBus  (c+92,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr),23);
	vcdp->fullBit  (c+21,(vlTOPp->v__DOT__uut__DOT__ff__DOT__uds_n));
	vcdp->fullBit  (c+22,(vlTOPp->v__DOT__uut__DOT__ff__DOT__lds_n));
	vcdp->fullBus  (c+93,((0x7fffff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i 
					   >> 1))),23);
	vcdp->fullBus  (c+19,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out),16);
	vcdp->fullBus  (c+94,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_eff_i),32);
	vcdp->fullBus  (c+95,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i),32);
	vcdp->fullBus  (c+97,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s),32);
	vcdp->fullBus  (c+99,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_d_lo),32);
	vcdp->fullBus  (c+103,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__areg_data_in),32);
	vcdp->fullBit  (c+105,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i));
	vcdp->fullBus  (c+106,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_out_i),32);
	vcdp->fullBus  (c+110,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dreg_data_in_a),32);
	vcdp->fullBus  (c+111,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dreg_data_in_b),32);
	vcdp->fullBit  (c+113,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__hi_byte_en_i));
	vcdp->fullBit  (c+116,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__lo_byte_en_i));
	vcdp->fullBit  (c+120,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_init_irq));
	vcdp->fullBus  (c+122,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_dreg_b),32);
	vcdp->fullBus  (c+126,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__result_alu_hi),32);
	vcdp->fullBus  (c+127,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__result_alu_lo),32);
	vcdp->fullBus  (c+128,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__result_shft),32);
	vcdp->fullBus  (c+130,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__shft_op_in),32);
	vcdp->fullBus  (c+133,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sr_ccr_mux),16);
	vcdp->fullBit  (c+134,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ssp_dec_irq));
	vcdp->fullBit  (c+139,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__use_int_vect_i));
	vcdp->fullBus  (c+140,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_alu),5);
	vcdp->fullBus  (c+141,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_shft),5);
	vcdp->fullBus  (c+142,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__bit_pnt),5);
	vcdp->fullBus  (c+143,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__regsel_tmp),3);
	vcdp->fullBus  (c+144,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state),5);
	vcdp->fullBit  (c+145,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__sr_wr));
	vcdp->fullBit  (c+114,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__init_status_i));
	vcdp->fullBit  (c+112,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__exec_abort_i));
	vcdp->fullBit  (c+115,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__irq_save_i));
	vcdp->fullBus  (c+146,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__vect_tmp),2);
	vcdp->fullBus  (c+147,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__next_ex_state),5);
	vcdp->fullBit  (c+148,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__tmp_cpy));
	vcdp->fullBit  (c+149,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__inc_tmp_vector));
	vcdp->fullBit  (c+121,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__preset_irq_mask_i));
	vcdp->fullBit  (c+129,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i));
	vcdp->fullBit  (c+137,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__trap_priv_i));
	vcdp->fullBit  (c+138,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__usp_cpy_i));
	vcdp->fullBit  (c+101,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ar_wr_i));
	vcdp->fullBit  (c+96,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_tmp_inc_i));
	vcdp->fullBit  (c+100,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__ar_inc_i));
	vcdp->fullBit  (c+135,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ssp_init_i));
	vcdp->fullBit  (c+132,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sp_add_displ_i));
	vcdp->fullBit  (c+119,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i));
	vcdp->fullBit  (c+136,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__trap_aerr_i));
	vcdp->fullBus  (c+150,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_ext),32);
	vcdp->fullBus  (c+151,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__iwl_ida),2);
	vcdp->fullBus  (c+152,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_eff_tmp),32);
	vcdp->fullBus  (c+153,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__areg),32);
	vcdp->fullBus  (c+154,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__data_signed),32);
	vcdp->fullBus  (c+155,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_scaled),32);
	vcdp->fullBus  (c+156,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_eff_i),32);
	vcdp->fullBus  (c+157,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar_sel),32);
	vcdp->fullBit  (c+102,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ar_dr_exg_i));
	vcdp->fullBit  (c+109,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dr_wr_i));
	vcdp->fullBit  (c+108,((0xffff == (0xffff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_b))));
	vcdp->fullBus  (c+123,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_data_b),3);
	vcdp->fullBus  (c+124,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_data_c),3);
	vcdp->fullBus  (c+158,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_b),32);
	vcdp->fullBus  (c+98,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_dreg_c),32);
	vcdp->fullBit  (c+118,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i));
	vcdp->fullBit  (c+117,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_busy_i));
	vcdp->fullBit  (c+159,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__x_in_i));
	vcdp->fullBus  (c+160,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__temp0),5);
	vcdp->fullBus  (c+161,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__temp1),5);
	vcdp->fullBus  (c+162,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__z_0),4);
	vcdp->fullBus  (c+163,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__z_1),4);
	vcdp->fullBus  (c+164,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__s_0),4);
	vcdp->fullBus  (c+165,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__s_1),4);
	vcdp->fullBit  (c+166,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__z));
	vcdp->fullBit  (c+167,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__c_0));
	vcdp->fullBit  (c+168,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__c_1));
	vcdp->fullBit  (c+169,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__rm));
	vcdp->fullBit  (c+170,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__sm));
	vcdp->fullBit  (c+171,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__dm));
	vcdp->fullBus  (c+172,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__rm_sm_dm),3);
	vcdp->fullBus  (c+173,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__next_div_state),2);
	vcdp->fullBus  (c+174,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__op_in_s_sign),32);
	vcdp->fullBus  (c+175,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__op_in_d_sign_lo),32);
	vcdp->fullBus  (c+176,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_logop),32);
	vcdp->fullBus  (c+177,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_bcd),8);
	vcdp->fullBus  (c+178,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_intop),32);
	vcdp->fullBus  (c+179,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_special),32);
	vcdp->fullBus  (c+180,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_i_out),32);
	vcdp->fullQuad (c+181,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_ii_out),33);
	vcdp->fullBit  (c+183,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__cb_bcd));
	vcdp->fullBit  (c+184,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__op_div));
	vcdp->fullBus  (c+185,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_div_op_s),32);
	vcdp->fullBus  (c+186,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_op_d),32);
	vcdp->fullBit  (c+187,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_shift_en));
	vcdp->fullBit  (c+188,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__chk_cond));
	vcdp->fullBus  (c+189,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__i),32);
	vcdp->fullBit  (c+131,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__shifter_load_i));
	vcdp->fullBus  (c+190,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__bit_op),32);
	vcdp->fullBit  (c+38,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_6mhz)))));
	vcdp->fullBit  (c+125,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__reset_en_i));
	vcdp->fullBus  (c+18,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ud_in),16);
	vcdp->fullBit  (c+191,((1 & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i)));
	vcdp->fullBit  (c+104,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i));
	vcdp->fullBit  (c+107,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i));
	vcdp->fullBus  (c+192,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice),3);
	vcdp->fullBus  (c+193,((0xff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr)),8);
	vcdp->fullBit  (c+23,(vlTOPp->v__DOT__uut__DOT__ff__DOT__as_n));
	vcdp->fullBus  (c+195,((0x3f & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					>> 0x11))),6);
	vcdp->fullBit  (c+27,((0x90 != (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->fullBit  (c+42,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pal__DOT__vpa)))));
	vcdp->fullBit  (c+196,((0x90 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))));
	vcdp->fullBit  (c+197,((0x94 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))));
	vcdp->fullBit  (c+198,((0xac == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))));
	vcdp->fullBit  (c+199,((0x80 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))));
	vcdp->fullBit  (c+200,((0xa4 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))));
	vcdp->fullBit  (c+201,((0xa8 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))));
	vcdp->fullBit  (c+202,((1 & ((~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					 >> 0x16)) 
				     | (0x90 == (0xfc 
						 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						    >> 0xf)))))));
	vcdp->fullBit  (c+203,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pal__DOT__vpa));
	vcdp->fullBus  (c+204,((0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					>> 0xf))),8);
	vcdp->fullBus  (c+206,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderom_h__out),8);
	vcdp->fullBus  (c+207,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderom_l__out),8);
	vcdp->fullBit  (c+43,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom0_n));
	vcdp->fullBit  (c+44,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom1_n));
	vcdp->fullBit  (c+45,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom2_n));
	vcdp->fullBit  (c+46,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom3_n));
	vcdp->fullBus  (c+208,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderam_h__out),8);
	vcdp->fullBus  (c+209,((0xff & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
					>> 8))),8);
	vcdp->fullBit  (c+210,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram0_n) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram1_n))));
	vcdp->fullBus  (c+205,((0x1fff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr)),13);
	vcdp->fullBus  (c+211,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderam_l__out),8);
	vcdp->fullBus  (c+213,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_3n_3m__out),8);
	vcdp->fullBus  (c+67,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfa),10);
	vcdp->fullBus  (c+214,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_3l_3k__out),8);
	vcdp->fullBit  (c+68,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfwr_n));
	vcdp->fullBus  (c+216,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				       >> 0xc))),4);
	vcdp->fullBus  (c+217,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6c__d),4);
	vcdp->fullBus  (c+218,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				       >> 8))),4);
	vcdp->fullBus  (c+219,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6d__d),4);
	vcdp->fullBit  (c+75,(vlTOPp->v__DOT__uut__DOT__ff__DOT__uwr_n));
	vcdp->fullBus  (c+220,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				       >> 4))),4);
	vcdp->fullBus  (c+221,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6e__d),4);
	vcdp->fullBus  (c+215,(vlTOPp->v__DOT__uut__DOT__ff__DOT__moram_addr),8);
	vcdp->fullBus  (c+222,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6f__d),4);
	vcdp->fullBit  (c+74,(vlTOPp->v__DOT__uut__DOT__ff__DOT__lwr_n));
	vcdp->fullBus  (c+223,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4e__d),8);
	vcdp->fullBus  (c+83,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_addr),13);
	vcdp->fullBus  (c+224,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4d__d),8);
	vcdp->fullBit  (c+225,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__evenclk)))));
	vcdp->fullBit  (c+226,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddclk)))));
	vcdp->fullBit  (c+227,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddcs_n)))));
	vcdp->fullBit  (c+228,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__evencs_n)))));
	vcdp->fullBus  (c+229,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_7p__d),4);
	vcdp->fullBit  (c+230,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloramwr_n)))));
	vcdp->fullBus  (c+88,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb_addr),8);
	vcdp->fullBus  (c+194,((0xf & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out))),4);
	vcdp->fullBus  (c+231,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_7n__d),4);
	vcdp->fullBit  (c+90,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloramwr_n));
	vcdp->fullBit  (c+40,(vlTOPp->v__DOT__uut__DOT__ff__DOT__audio2_n));
	vcdp->fullBus  (c+233,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__d_out),8);
	vcdp->fullBit  (c+234,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__stb));
	vcdp->fullBus  (c+236,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we),4);
	vcdp->fullBus  (c+237,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we),4);
	vcdp->fullBus  (c+238,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start),4);
	vcdp->fullBit  (c+239,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we))));
	vcdp->fullBit  (c+240,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start))));
	vcdp->fullBit  (c+241,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we) 
				     >> 1))));
	vcdp->fullBit  (c+242,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start) 
				     >> 1))));
	vcdp->fullBit  (c+243,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we) 
				     >> 2))));
	vcdp->fullBit  (c+244,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start) 
				     >> 2))));
	vcdp->fullBit  (c+245,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we) 
				     >> 3))));
	vcdp->fullBit  (c+246,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start) 
				     >> 3))));
	vcdp->fullBit  (c+247,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we))));
	vcdp->fullBit  (c+248,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we) 
				     >> 1))));
	vcdp->fullBit  (c+249,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we) 
				     >> 2))));
	vcdp->fullBit  (c+235,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start_timer));
	vcdp->fullBit  (c+250,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we) 
				     >> 3))));
	vcdp->fullBit  (c+41,(vlTOPp->v__DOT__uut__DOT__ff__DOT__audio1_n));
	vcdp->fullBus  (c+251,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__d_out),8);
	vcdp->fullBit  (c+252,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__stb));
	vcdp->fullBus  (c+254,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we),4);
	vcdp->fullBus  (c+255,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we),4);
	vcdp->fullBus  (c+256,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start),4);
	vcdp->fullBit  (c+257,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we))));
	vcdp->fullBit  (c+258,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start))));
	vcdp->fullBit  (c+259,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we) 
				     >> 1))));
	vcdp->fullBit  (c+260,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start) 
				     >> 1))));
	vcdp->fullBit  (c+261,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we) 
				     >> 2))));
	vcdp->fullBit  (c+262,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start) 
				     >> 2))));
	vcdp->fullBit  (c+263,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we) 
				     >> 3))));
	vcdp->fullBit  (c+264,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start) 
				     >> 3))));
	vcdp->fullBit  (c+265,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we))));
	vcdp->fullBit  (c+266,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we) 
				     >> 1))));
	vcdp->fullBit  (c+267,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we) 
				     >> 2))));
	vcdp->fullBit  (c+253,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start_timer));
	vcdp->fullBit  (c+268,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we) 
				     >> 3))));
	vcdp->fullBit  (c+25,(vlTOPp->v__DOT__uut__DOT__ff__DOT__audio0_n));
	vcdp->fullBus  (c+232,((0xf & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr)),4);
	vcdp->fullBit  (c+20,(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_n));
	vcdp->fullBus  (c+29,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_out),8);
	vcdp->fullBit  (c+269,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__stb));
	vcdp->fullBus  (c+271,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we),4);
	vcdp->fullBus  (c+272,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we),4);
	vcdp->fullBus  (c+273,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start),4);
	vcdp->fullBit  (c+274,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we))));
	vcdp->fullBit  (c+275,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start))));
	vcdp->fullBit  (c+276,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we) 
				     >> 1))));
	vcdp->fullBit  (c+277,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start) 
				     >> 1))));
	vcdp->fullBit  (c+278,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we) 
				     >> 2))));
	vcdp->fullBit  (c+279,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start) 
				     >> 2))));
	vcdp->fullBit  (c+280,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we) 
				     >> 3))));
	vcdp->fullBit  (c+281,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start) 
				     >> 3))));
	vcdp->fullBit  (c+282,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we))));
	vcdp->fullBit  (c+283,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we) 
				     >> 1))));
	vcdp->fullBit  (c+284,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we) 
				     >> 2))));
	vcdp->fullBit  (c+270,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start_timer));
	vcdp->fullBus  (c+212,((0xff & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out))),8);
	vcdp->fullBit  (c+285,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we) 
				     >> 3))));
	vcdp->fullBit  (c+286,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip_d) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__regld))));
	vcdp->fullBit  (c+287,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip_d)) 
				     | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__regld)))));
	vcdp->fullBit  (c+288,(((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
				& ((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
				       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
				   & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
				      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_n) 
					 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_p)))))));
	vcdp->fullBit  (c+289,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip) 
				^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h))));
	vcdp->fullBit  (c+290,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				   >> 0xf))));
	vcdp->fullBus  (c+291,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i),32);
	vcdp->fullBit  (c+293,(((((0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				       >> 0xd))) | 
				((~ ((0x54 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				     & (7 == (7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))))) 
				 & ((((0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				     & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
					   >> 0xd))) 
				    | (((0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
					& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				       & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
					     >> 0xd))))))));
	vcdp->fullBit  (c+292,(((((0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				    >> 0xd)) | ((~ 
						 ((0x54 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
						  & (7 
						     == 
						     (7 
						      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))))) 
						& ((((0x11 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
						    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
						       >> 0xd)) 
						   | (((0x13 
							== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
							 >> 0xd)))))));
	vcdp->fullBit  (c+294,(((((0x14 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				    >> 0xd)) | (((0x15 
						  != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						 & (0x15 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
						& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
						   >> 0xd)))));
	vcdp->fullBit  (c+295,((((((0x14 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				   & (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				  & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				     >> 0xd)) | (((0x15 
						   != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						  & (0x15 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
						    >> 0xd))) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ssp_dec_irq))));
	vcdp->fullBit  (c+296,(((((0x14 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				       >> 0xd))) | 
				(((0x15 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (0x15 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				       >> 0xd))))));
	vcdp->fullBit  (c+297,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i) 
				  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__ar_inc_i)) 
				 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__ar_dec_i)) 
				| ((((0x30 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				     & (6 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				   | (((9 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				      | ((((0x30 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
					   & (7 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
					  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
					 | ((0xa == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
					    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i))))))));
	vcdp->fullBit  (c+299,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
				 & (0x52 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i) 
				   >> 1))));
	vcdp->fullBit  (c+298,((((((0x1b == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				   & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_state))) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i)) 
				 & (0 == vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s)) 
				| ((((0x1a == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				     & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_state))) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i)) 
				   & (0 == vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s)))));
	vcdp->fullBus  (c+300,(((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state))
				 ? ((((0x33 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				      | (0x34 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i))
				     ? 2 : 0) : ((2 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state))
						  ? 
						 (((0 
						    == vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_d_lo) 
						   | (0 
						      == vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s))
						   ? 0
						   : 
						  ((1 
						    & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_i)
						    ? 1
						    : 
						   ((0 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_cyc_cnt))
						     ? 0
						     : 2)))
						  : 
						 ((1 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state))
						   ? 2
						   : 0)))),2);
	vcdp->fullBit  (c+301,((((0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_i) 
				    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__trap_aerr_i))) 
				& (((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)) 
				    | (2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))) 
				   | (1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))))));
	vcdp->fullBit  (c+302,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
				& (0xa == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						  >> 0xc))))));
	vcdp->fullBit  (c+303,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
				& (0xf == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						  >> 0xc))))));
	vcdp->fullBit  (c+304,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__hi_byte_en_i) 
				 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__lo_byte_en_i)) 
				| (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en)) 
				   & (((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				       | (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				      | (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)))))));
	vcdp->fullBit  (c+305,((1 & ((~ ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i) 
					   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en)) 
					  & (~ vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i)) 
					 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i)))) 
				     & ((~ ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
					      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en)) 
					     & (~ vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i)) 
					    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i)))) 
					& ((~ (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i) 
						& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en)) 
					       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i))) 
					   & (~ (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
						  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en)) 
						 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i)))))))));
	vcdp->fullBit  (c+306,((1 & ((~ ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i) 
					   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en)) 
					  & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i) 
					 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i)))) 
				     & ((~ ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
					      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en)) 
					     & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i) 
					    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i)))) 
					& ((~ (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i) 
						& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en)) 
					       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i))) 
					   & (~ (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
						  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en)) 
						 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i)))))))));
	vcdp->fullBit  (c+307,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hload_n))));
	vcdp->fullBit  (c+308,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx)) 
				     | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hload_n)))));
	vcdp->fullBit  (c+309,(((((((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_in)) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)) 
				   & (0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))) 
				  & (1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))) 
				 & (2 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))) 
				| ((((((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_in)) 
				       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in))) 
				      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i)) 
				     & (0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))) 
				    & (1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))) 
				   & (2 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))));
	vcdp->fullBit  (c+311,((((1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)) 
				| (((2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)) 
				   | ((3 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i))))));
	vcdp->fullBit  (c+310,((((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)) 
				| ((5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)))));
	vcdp->fullBit  (c+312,(((((1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				 & (2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				| ((((1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				    & (4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				   | ((((1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
					& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				       & (5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				      | ((((2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
					   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
					  & (3 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
					 | ((((2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
					      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
					     & (4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
					    | ((((3 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
						& (4 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
					       | ((((4 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
						   & (4 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
						  | ((((4 
							== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
						      & (5 
							 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
						     | (((5 
							  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
							 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
							& (5 
							   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state)))))))))))));
	vcdp->fullBit  (c+313,((((((0x44 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				   & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				 | ((((0x45 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				      & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				    | (((0x46 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
					& (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)))) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_init_irq))));
	vcdp->fullBit  (c+314,(((((0x44 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				  & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				| ((((0x45 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				     & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				   | (((0x46 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				       & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i))))));
	vcdp->fullBit  (c+315,((((((8 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				   | (0x1e == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				  | (0x3c == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				| (((0x2c == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				   | (((0x45 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				       & (0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i))))));
	vcdp->fullBit  (c+316,(((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
				    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
				   | ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
				      & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
					 | (~ (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
						& (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
					       & (0 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))))));
	vcdp->fullBit  (c+319,((1 & ((~ ((7 == (7 & 
						(((~ 
						   ((0 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
						    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
						  & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
						     | ((0 
							 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
							   | (~ 
							      (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
								& (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
							       & (0 
								  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_i)
						  : 0))) 
					 & (0x3f == 
					    (0x3f & 
					     (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0x11))))) 
				     & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pal__DOT__vpa))))));
	vcdp->fullBus  (c+318,((7 & (((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
					  & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
				      & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
					 | ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
					    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
					       | (~ 
						  (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
						    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
						   & (0 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))))
				      ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_i)
				      : 0))),3);
	vcdp->fullBit  (c+317,((1 & (~ ((7 == (7 & 
					       (((~ 
						  ((0 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
						   & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
						    | ((0 
							== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
						       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
							  | (~ 
							     (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
							       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
							      & (0 
								 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))))
						 ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_i)
						 : 0))) 
					& (0x3f == 
					   (0x3f & 
					    (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0x11))))))));
	vcdp->fullBit  (c+320,(((7 == (7 & (((~ ((0 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
						 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
					     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
						| ((0 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
						   & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
						      | (~ 
							 (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
							   & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
							  & (0 
							     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))))
					     ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_i)
					     : 0))) 
				& (0x3f == (0x3f & 
					    (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0x11))))));
	vcdp->fullBit  (c+321,(((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
				   | (~ (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
					  & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
					 & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))));
	vcdp->fullBit  (c+322,(((((0xf == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				  | (0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				| ((((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__cond)) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				   | ((((0x19 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
					& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__cond))) 
				      & (0xffff != 
					 (0xffff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_b)))))));
	vcdp->fullBit  (c+323,((1 & (~ (((~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0x16)) 
					 | (0x90 == 
					    (0xfc & 
					     (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0xf)))) 
					| (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_n_v_d)))))));
	vcdp->fullBus  (c+330,((((((0xd == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				   | (0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				  | (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				 | (0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
				 ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_shft)
				 : (((((((((0xa == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
					   | (0xb == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					  | (0x27 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					 | (0x28 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					| (0x40 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				       | (0x41 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				      | (0x42 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				     | (0x43 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
				     ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_shft)
				     : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_alu)))),5);
	vcdp->fullBit  (c+331,((((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				 | (0x4d == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
				 ? ((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_mode_i)) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))
				 : ((((((((((((((((
						   (((((((((((((((((((((((((((((((0 
										== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
										| (1 
										== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
										| (3 
										== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									       | (5 
										== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									      | (6 
										== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									     | (7 
										== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									    | (0xa 
									       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									   | (0xb 
									      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									  | (0xd 
									     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									 | (0xe 
									    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
									| (0x10 
									   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								       | (0x12 
									  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								      | (0x13 
									 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								     | (0x14 
									== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								    | (0x15 
								       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								   | (0x16 
								      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								  | (0x17 
								     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								 | (0x18 
								    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
								| (0x1a 
								   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							       | (0x1b 
								  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							      | (0x1c 
								 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							     | (0x1d 
								== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							    | (0x21 
							       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							   | (0x27 
							      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							  | (0x28 
							     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							 | (0x29 
							    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
							| (0x32 
							   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						       | (0x33 
							  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						      | (0x34 
							 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						     | (0x35 
							== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						    | (0x36 
						       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						   | (0x37 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						  | (0x39 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						 | (0x3a 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
						| (0x3b 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					       | (0x40 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					      | (0x41 
						 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					     | (0x42 
						== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					    | (0x43 
					       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					   | (0x47 
					      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					  | (0x4a == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					 | (0x4c == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					| (0x4e == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				       | (0x4f == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				      | (0x50 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				     | (0x53 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)))));
	vcdp->fullBit  (c+332,(((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_mode_i)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))));
	vcdp->fullBit  (c+328,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
				& (0x22 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))));
	vcdp->fullBit  (c+329,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
				& (0x51 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))));
	vcdp->fullBit  (c+325,((((0x23 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				 | (0x24 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))));
	vcdp->fullBit  (c+324,(((0x19 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				& (0x16 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state)))));
	vcdp->fullBit  (c+327,(((0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))));
	vcdp->fullBit  (c+326,((((0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__chk_cond))));
	vcdp->fullBit  (c+333,(((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
				    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
				& (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)))));
	vcdp->fullBit  (c+334,(((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_v_n)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__uds_n))));
	vcdp->fullBit  (c+335,(((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_v_n)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__lds_n))));
	vcdp->fullBit  (c+336,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h) 
				^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip))));
	vcdp->fullBit  (c+337,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y));
	vcdp->fullBit  (c+338,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y));
	vcdp->fullBus  (c+339,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
				 << 1) | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
					  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y)))),2);
	vcdp->fullBus  (c+340,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
				 << 1) | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
					  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y)))),2);
	vcdp->fullBus  (c+341,(((0xfc & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__p) 
					 << 2)) | (
						   (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
						     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
						    << 1) 
						   | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
						      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y))))),8);
	vcdp->fullBus  (c+342,(((0xfc & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__p) 
					 << 2)) | (
						   (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
						     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
						    << 1) 
						   | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
						      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y))))),8);
	vcdp->fullBit  (c+343,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bgack_in));
	vcdp->fullBit  (c+344,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__br_in));
	vcdp->fullBus  (c+345,((0xffff & ((5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
					   ? (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__rwn_tmp) 
					       << 4) 
					      | (((((0 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)) 
						    | (2 
						       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))) 
						   | (1 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))) 
						  << 3) 
						 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__fc_tmp)))
					   : ((6 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
					       ? (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__adr_tmp 
						  >> 0x10)
					       : ((7 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
						   ? vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__adr_tmp
						   : 
						  ((8 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
						    ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)
						    : 
						   ((9 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
						     ? 
						    ((0x8000 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
							 << 6)) 
						     | ((0x2000 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
							    << 5)) 
							| ((0x700 
							    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
							       << 3)) 
							   | (0x1f 
							      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem)))))
						     : 
						    ((0xa 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
						      ? 
						     (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_out 
						      >> 0x10)
						      : 
						     ((0xb 
						       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
						       ? vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_out
						       : 0))))))))),16);
	vcdp->fullBit  (c+347,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_en));
	vcdp->fullBit  (c+348,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_adn_i));
	vcdp->fullBit  (c+349,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_pi_corr));
	vcdp->fullBus  (c+346,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_out),32);
	vcdp->fullBit  (c+350,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__shft_en));
	vcdp->fullBus  (c+351,((0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1))),5);
	vcdp->fullBit  (c+355,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				     >> 5))));
	vcdp->fullBus  (c+358,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				     >> 9))),3);
	vcdp->fullBus  (c+360,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1))),3);
	vcdp->fullBus  (c+361,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1) 
				     >> 0xc))),3);
	vcdp->fullBit  (c+362,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				     >> 3))));
	vcdp->fullBus  (c+352,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i),16);
	vcdp->fullBus  (c+359,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))),3);
	vcdp->fullBus  (c+363,((0xf & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))),4);
	vcdp->fullBus  (c+353,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				       >> 8))),4);
	vcdp->fullBus  (c+357,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1),16);
	vcdp->fullBus  (c+356,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				     >> 6))),3);
	vcdp->fullBit  (c+354,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1) 
				     >> 0xa))));
	vcdp->fullBus  (c+365,((((((7 == (7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
					       >> 3))) 
				   & (4 == (7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
				  & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_size_i))) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
				 ? 2 : ((((7 == (7 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						    >> 3))) 
					  & (1 == (7 
						   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
					 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
					 ? 2 : ((((7 
						   == 
						   (7 
						    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						       >> 3))) 
						  & (4 
						     == 
						     (7 
						      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
						 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
						 ? 1
						 : 
						((((7 
						    == 
						    (7 
						     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
							>> 3))) 
						   & (3 
						      == 
						      (7 
						       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
						  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
						  ? 1
						  : 
						 ((((7 
						     == 
						     (7 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
							 >> 3))) 
						    & (2 
						       == 
						       (7 
							& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
						   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
						   ? 1
						   : 
						  ((((7 
						      == 
						      (7 
						       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
							  >> 3))) 
						     & (0 
							== 
							(7 
							 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
						    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
						    ? 1
						    : 
						   (((6 
						      == 
						      (7 
						       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
							  >> 3))) 
						     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
						     ? 1
						     : 
						    (((5 
						       == 
						       (7 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
							   >> 3))) 
						      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
						      ? 1
						      : 0))))))))),2);
	vcdp->fullBus  (c+364,(((((7 == (7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
					      >> 6))) 
				  & (1 == (7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						>> 9)))) 
				 & (0x29 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
				 ? 2 : ((((7 == (7 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						    >> 6))) 
					  & (0 == (7 
						   & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						      >> 9)))) 
					 & (0x29 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
					 ? 1 : (((6 
						  == 
						  (7 
						   & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						      >> 6))) 
						 & (0x29 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
						 ? 1
						 : 
						(((5 
						   == 
						   (7 
						    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						       >> 6))) 
						  & (0x29 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
						  ? 1
						  : 0))))),2);
	vcdp->fullBus  (c+366,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__src_destn_i)
				      ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__exword_reg0) 
					 >> 0xc) : 
				     ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__dest_exword_reg0) 
				      >> 0xc)))),3);
	vcdp->fullBit  (c+367,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en));
	vcdp->fullBit  (c+368,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en));
	vcdp->fullBit  (c+369,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en));
	vcdp->fullBit  (c+370,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en));
	vcdp->fullBit  (c+371,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en));
	vcdp->fullBit  (c+372,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en)) 
				& (((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				    | (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				   | (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))))));
	vcdp->fullBit  (c+374,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_in));
	vcdp->fullBus  (c+375,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ipl_in),3);
	vcdp->fullBus  (c+376,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ipl_tmpn),3);
	vcdp->fullBus  (c+377,((7 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ipl_in)))),3);
	vcdp->fullBit  (c+373,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__avec_in));
	vcdp->fullBit  (c+381,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__wr_bus_i));
	vcdp->fullBus  (c+378,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__iw_adr_i),2);
	vcdp->fullBit  (c+380,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__use_sp_adr_i));
	vcdp->fullBit  (c+379,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_b_lo_i));
	vcdp->fullBit  (c+382,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__rd_bus_i) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__wr_bus_i))));
	vcdp->fullBit  (c+383,(vlTOPp->v__DOT__uut__DOT__ff__DOT__bg));
	vcdp->fullBit  (c+384,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__cond));
	vcdp->fullBit  (c+385,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il4_n)))));
	vcdp->fullBit  (c+386,(vlTOPp->v__DOT__uut__DOT__ff__DOT__il4_n));
	vcdp->fullBus  (c+387,((4 | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il4_n) 
				      << 1) | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il3_n)))),3);
	vcdp->fullBit  (c+388,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_32v));
	vcdp->fullBit  (c+389,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_128v));
	vcdp->fullBit  (c+390,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1));
	vcdp->fullBit  (c+391,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0));
	vcdp->fullBit  (c+393,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bitpos_im_i));
	vcdp->fullBus  (c+401,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_mode_i))),3);
	vcdp->fullBit  (c+396,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__mem_shft_i));
	vcdp->fullBit  (c+402,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en));
	vcdp->fullBit  (c+394,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dr_i));
	vcdp->fullBit  (c+395,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__force_biw2_i));
	vcdp->fullBit  (c+400,(((((((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				    | (0xf == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				   | (0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				  | (0x19 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				 | (0x31 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				| (0x26 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))));
	vcdp->fullBus  (c+398,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_mode_i),5);
	vcdp->fullBus  (c+392,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_mode_i),3);
	vcdp->fullBus  (c+397,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i),7);
	vcdp->fullBus  (c+399,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_size_i),2);
	vcdp->fullBit  (c+403,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__reset_in_in));
	vcdp->fullBit  (c+404,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__vpa_in));
	vcdp->fullBit  (c+405,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irq));
	vcdp->fullBus  (c+406,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__ctr_out),32);
	vcdp->fullBus  (c+407,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow),4);
	vcdp->fullBit  (c+408,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__base));
	vcdp->fullBus  (c+409,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_done),8);
	vcdp->fullBit  (c+410,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__new_bit));
	vcdp->fullBit  (c+411,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow))));
	vcdp->fullBit  (c+412,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     >> 2))));
	vcdp->fullBit  (c+413,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__no_poly5) 
					| ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly5__DOT__shift) 
					   >> 4))))));
	vcdp->fullBit  (c+414,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     >> 1))));
	vcdp->fullBit  (c+415,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     >> 3))));
	vcdp->fullBit  (c+416,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				      >> 1) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__no_poly5) 
					       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift))))));
	vcdp->fullBit  (c+417,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				      >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__no_poly5) 
					       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
						  >> 1))))));
	vcdp->fullBit  (c+418,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				      >> 3) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__no_poly5) 
					       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
						  >> 2))))));
	vcdp->fullBit  (c+419,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irq));
	vcdp->fullBus  (c+420,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__ctr_out),32);
	vcdp->fullBus  (c+421,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow),4);
	vcdp->fullBit  (c+422,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__base));
	vcdp->fullBus  (c+423,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_done),8);
	vcdp->fullBit  (c+424,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__new_bit));
	vcdp->fullBit  (c+425,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow))));
	vcdp->fullBit  (c+426,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     >> 2))));
	vcdp->fullBit  (c+427,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__no_poly5) 
					| ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly5__DOT__shift) 
					   >> 4))))));
	vcdp->fullBit  (c+428,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     >> 1))));
	vcdp->fullBit  (c+429,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     >> 3))));
	vcdp->fullBit  (c+430,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				      >> 1) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__no_poly5) 
					       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift))))));
	vcdp->fullBit  (c+431,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				      >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__no_poly5) 
					       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
						  >> 1))))));
	vcdp->fullBit  (c+432,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				      >> 3) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__no_poly5) 
					       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
						  >> 2))))));
	vcdp->fullBit  (c+433,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irq));
	vcdp->fullBus  (c+434,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__ctr_out),32);
	vcdp->fullBus  (c+435,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow),4);
	vcdp->fullBit  (c+436,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__base));
	vcdp->fullBus  (c+437,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_done),8);
	vcdp->fullBit  (c+438,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__new_bit));
	vcdp->fullBit  (c+439,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow))));
	vcdp->fullBit  (c+440,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     >> 2))));
	vcdp->fullBit  (c+441,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__no_poly5) 
					| ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly5__DOT__shift) 
					   >> 4))))));
	vcdp->fullBit  (c+442,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     >> 1))));
	vcdp->fullBit  (c+443,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     >> 3))));
	vcdp->fullBit  (c+444,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				      >> 1) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__no_poly5) 
					       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift))))));
	vcdp->fullBit  (c+445,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				      >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__no_poly5) 
					       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
						  >> 1))))));
	vcdp->fullBit  (c+446,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				      >> 3) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__no_poly5) 
					       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
						  >> 2))))));
	vcdp->fullBit  (c+456,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__unlk_sp_an_i));
	vcdp->fullBit  (c+457,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__got_ext));
	vcdp->fullBit  (c+458,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__got_dest_ext));
	vcdp->fullBit  (c+459,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_cpy));
	vcdp->fullBit  (c+455,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__src_destn_i));
	vcdp->fullBus  (c+448,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ext_dsize_i),2);
	vcdp->fullBus  (c+460,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_mode_i),3);
	vcdp->fullBit  (c+461,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i_d_a));
	vcdp->fullBit  (c+462,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i_w_l));
	vcdp->fullBus  (c+463,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i_scale),2);
	vcdp->fullBus  (c+449,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_adr_a),3);
	vcdp->fullBus  (c+450,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_adr_b),3);
	vcdp->fullBit  (c+464,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__n_flag));
	vcdp->fullBit  (c+465,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__z_flag));
	vcdp->fullBit  (c+452,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_hi));
	vcdp->fullBit  (c+453,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_midhi));
	vcdp->fullBit  (c+454,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_midlo));
	vcdp->fullBit  (c+451,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_lo));
	vcdp->fullBus  (c+466,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__next_arb_state),2);
	vcdp->fullBit  (c+447,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vma));
	vcdp->fullBit  (c+468,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_lo_irq_i));
	vcdp->fullBit  (c+469,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_hi_irq_i));
	vcdp->fullBit  (c+471,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i));
	vcdp->fullBit  (c+467,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ctrl_en_i));
	vcdp->fullBit  (c+470,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__use_ssp_adr_i));
	vcdp->fullBit  (c+472,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il3_n)))));
	vcdp->fullBit  (c+473,(vlTOPp->v__DOT__uut__DOT__ff__DOT__il3_n));
	vcdp->fullBus  (c+474,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_immediate_i),32);
	vcdp->fullBit  (c+476,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__force_biw3_i));
	vcdp->fullBus  (c+475,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__displace_biw_i),32);
	vcdp->fullBus  (c+478,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc_offset),4);
	vcdp->fullBus  (c+477,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_data_a),3);
	vcdp->fullBus  (c+479,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en),4);
	vcdp->fullBit  (c+480,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en))));
	vcdp->fullBit  (c+481,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en) 
				     >> 1))));
	vcdp->fullBit  (c+482,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en) 
				     >> 2))));
	vcdp->fullBit  (c+483,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en) 
				     >> 3))));
	vcdp->fullBus  (c+484,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en),4);
	vcdp->fullBit  (c+485,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en))));
	vcdp->fullBit  (c+486,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en) 
				     >> 1))));
	vcdp->fullBit  (c+487,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en) 
				     >> 2))));
	vcdp->fullBit  (c+488,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en) 
				     >> 3))));
	vcdp->fullBus  (c+489,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en),4);
	vcdp->fullBit  (c+490,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en))));
	vcdp->fullBit  (c+491,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en) 
				     >> 1))));
	vcdp->fullBit  (c+492,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en) 
				     >> 2))));
	vcdp->fullBit  (c+493,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en) 
				     >> 3))));
	vcdp->fullBus  (c+494,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bit_pos_i),5);
	vcdp->fullBus  (c+495,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__cnt_nr_i),6);
	vcdp->fullBus  (c+496,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_areg_a),32);
	vcdp->fullBus  (c+497,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_areg_b),32);
	vcdp->fullBus  (c+498,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_dreg_a),32);
	vcdp->fullBus  (c+499,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__displace),32);
	vcdp->fullBus  (c+500,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__displ_ext),32);
	vcdp->fullBus  (c+501,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__abs_address),32);
	vcdp->fullBus  (c+502,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar_step),3);
	vcdp->fullBus  (c+503,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_a),32);
	vcdp->fullBus  (c+505,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_ctrl),3);
	vcdp->fullBit  (c+507,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i));
	vcdp->fullBit  (c+508,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_lo_i));
	vcdp->fullBit  (c+509,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_hi_i));
	vcdp->fullBit  (c+510,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sys_init_i));
	vcdp->fullBit  (c+506,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__rd_bus_i));
	vcdp->fullBit  (c+504,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rwn_i));
	vcdp->fullBus  (c+511,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_i),3);
	vcdp->fullBit  (c+512,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_i));
	vcdp->fullBus  (c+514,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_new)))),32);
	vcdp->fullBit  (c+513,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_new));
	vcdp->fullBus  (c+515,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h),12);
	vcdp->fullBit  (c+516,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
				 < 0x100) | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
					     > 0x4ff))));
	vcdp->fullBit  (c+517,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
				 >= 0x100) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
					      <= 0x4ff))));
	vcdp->fullBit  (c+518,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
				 >= 0x40) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
					     <= 0x80))));
	vcdp->fullBus  (c+519,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_shift),16);
	vcdp->fullBit  (c+520,(vlTOPp->v__DOT__uut__DOT__ff__DOT__stamp_active_d));
	vcdp->fullBus  (c+521,(vlTOPp->v__DOT__uut__DOT__ff__DOT__stamp_active_cnt),4);
	vcdp->fullBus  (c+522,(vlTOPp->v__DOT__uut__DOT__ff__DOT__p),8);
	vcdp->fullBit  (c+523,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip_d));
	vcdp->fullBit  (c+524,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync));
	vcdp->fullBus  (c+525,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift),8);
	vcdp->fullBus  (c+526,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_addr_hold),8);
	vcdp->fullBus  (c+527,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_addr_hold_d),8);
	vcdp->fullBus  (c+528,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ov),8);
	vcdp->fullBit  (c+529,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en_n));
	vcdp->fullBit  (c+530,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en_n));
	vcdp->fullBit  (c+531,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en_n));
	vcdp->fullBit  (c+532,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en_n));
	vcdp->fullBit  (c+533,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_n));
	vcdp->fullBit  (c+534,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_n));
	vcdp->fullBit  (c+535,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en_n));
	vcdp->fullBit  (c+536,((1 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_n) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_p))))));
	vcdp->fullBit  (c+537,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_n) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_p))));
	vcdp->fullBit  (c+538,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync) 
				^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync))));
	vcdp->fullBus  (c+539,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfv_hold) 
				 << 2) | ((2 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift)
						  : 
						 ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
						  >> 3)) 
						<< 1)) 
					  | (1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)
						   ? 
						  ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
						   >> 4)
						   : 
						  ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
						   >> 7)))))),8);
	vcdp->fullBus  (c+540,(((2 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift)
				        : ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
					   >> 3)) << 1)) 
				| (1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
					    >> 4) : 
					((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
					 >> 7))))),2);
	vcdp->fullBus  (c+542,(((0xc0 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb)) 
				| ((0x18 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb) 
					    >> 1)) 
				   | (7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb))))),32);
	vcdp->fullBus  (c+543,((6 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb) 
				     >> 5))),3);
	vcdp->fullBus  (c+544,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb) 
				     >> 3))),3);
	vcdp->fullBus  (c+545,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb))),3);
	vcdp->fullBus  (c+541,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb),8);
	vcdp->fullBit  (c+546,(vlTOPp->v__DOT__uut__DOT__ff__DOT__membufen_n));
	vcdp->fullBus  (c+547,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip) 
				  << 3) | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip) 
					    << 2) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip) 
					     << 1) 
					    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip)))) 
				^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ol_hold))),4);
	vcdp->fullBus  (c+548,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ol_hold),4);
	vcdp->fullBit  (c+549,(vlTOPp->v__DOT__uut__DOT__ff__DOT__match));
	vcdp->fullBit  (c+550,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip));
	vcdp->fullBit  (c+551,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip));
	vcdp->fullBus  (c+552,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mv_addr_hold),8);
	vcdp->fullBus  (c+553,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem),10);
	vcdp->fullBus  (c+554,(((0x8000 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
					   << 6)) | 
				((0x2000 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
					    << 5)) 
				 | ((0x700 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
					      << 3)) 
				    | (0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem)))))),16);
	vcdp->fullBit  (c+555,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__rwn_tmp));
	vcdp->fullBus  (c+556,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__fc_tmp),3);
	vcdp->fullBus  (c+557,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__adr_tmp),32);
	vcdp->fullBit  (c+558,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en_p));
	vcdp->fullBit  (c+559,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en_p));
	vcdp->fullBit  (c+560,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en_p));
	vcdp->fullBit  (c+561,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en_p));
	vcdp->fullBit  (c+562,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_p));
	vcdp->fullBit  (c+563,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_p));
	vcdp->fullBit  (c+564,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en_p));
	vcdp->fullBit  (c+565,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__wr_enab_p));
	vcdp->fullBus  (c+570,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__int_vect_i),10);
	vcdp->fullBit  (c+572,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__movem_adn_i));
	vcdp->fullBus  (c+573,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__movem_regsel_i),3);
	vcdp->fullBit  (c+579,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__chk_adr_strb_lock));
	vcdp->fullBit  (c+580,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__predec_ctrl_lock));
	vcdp->fullBus  (c+581,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__sreg_mem),10);
	vcdp->fullBus  (c+582,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__sreg_mem_tmp),10);
	vcdp->fullBus  (c+583,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__bit_pnt_r),5);
	vcdp->fullBus  (c+584,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__regsel_tmp_r),3);
	vcdp->fullBus  (c+585,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg),16);
	vcdp->fullBit  (c+586,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__traplock));
	vcdp->fullBus  (c+577,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i),16);
	vcdp->fullBus  (c+571,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__irq_exhdl),3);
	vcdp->fullBus  (c+587,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__vector_no),8);
	vcdp->fullBus  (c+588,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q),4);
	vcdp->fullBit  (c+589,((((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)) 
				 | (2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))) 
				| (1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)))));
	vcdp->fullBit  (c+590,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_reset));
	vcdp->fullBit  (c+591,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_adr_err));
	vcdp->fullBit  (c+592,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_bus_err));
	vcdp->fullBit  (c+593,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_trace));
	vcdp->fullBit  (c+569,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_int));
	vcdp->fullBit  (c+594,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_illegal));
	vcdp->fullBit  (c+595,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_1010));
	vcdp->fullBit  (c+596,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_1111));
	vcdp->fullBit  (c+597,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_priv));
	vcdp->fullBit  (c+598,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_trap));
	vcdp->fullBit  (c+599,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_trapv));
	vcdp->fullBit  (c+600,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_chk));
	vcdp->fullBit  (c+601,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_divzero));
	vcdp->fullBus  (c+602,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__vect_tmp_r),2);
	vcdp->fullBit  (c+603,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i) 
				     >> 1))));
	vcdp->fullBit  (c+566,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__ar_dec_i));
	vcdp->fullBit  (c+574,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				     >> 0xd))));
	vcdp->fullBit  (c+568,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__chk_pc_i));
	vcdp->fullBit  (c+567,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__chk_adr_i));
	vcdp->fullBus  (c+604,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_tmp),32);
	vcdp->fullBus  (c+605,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc_tmpvar),4);
	vcdp->fullBus  (c+606,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[0]),32);
	vcdp->fullBus  (c+607,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[1]),32);
	vcdp->fullBus  (c+608,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[2]),32);
	vcdp->fullBus  (c+609,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[3]),32);
	vcdp->fullBus  (c+610,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[4]),32);
	vcdp->fullBus  (c+611,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[5]),32);
	vcdp->fullBus  (c+612,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[6]),32);
	vcdp->fullBus  (c+578,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__usp),32);
	vcdp->fullBus  (c+576,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ssp),32);
	vcdp->fullBus  (c+613,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc),32);
	vcdp->fullBus  (c+614,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__areg_tmp),32);
	vcdp->fullBus  (c+615,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_tmp),6);
	vcdp->fullBus  (c+616,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc_tmpvar) 
				<< 1)),5);
	vcdp->fullBus  (c+617,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[0]),32);
	vcdp->fullBus  (c+618,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[1]),32);
	vcdp->fullBus  (c+619,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[2]),32);
	vcdp->fullBus  (c+620,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[3]),32);
	vcdp->fullBus  (c+621,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[4]),32);
	vcdp->fullBus  (c+622,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[5]),32);
	vcdp->fullBus  (c+623,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[6]),32);
	vcdp->fullBus  (c+624,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[7]),32);
	vcdp->fullBus  (c+625,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__i),32);
	vcdp->fullBus  (c+626,((0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i))),5);
	vcdp->fullQuad (c+627,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_result_var),33);
	vcdp->fullBus  (c+629,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state),2);
	vcdp->fullBus  (c+630,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_state),2);
	vcdp->fullBus  (c+631,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_i),32);
	vcdp->fullQuad (c+632,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_ii),33);
	vcdp->fullQuad (c+634,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__divisor),64);
	vcdp->fullQuad (c+636,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__dividend),64);
	vcdp->fullBit  (c+638,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__ov_div_mul));
	vcdp->fullBus  (c+639,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_cyc_cnt),6);
	vcdp->fullBit  (c+640,(((0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_cyc_cnt)) 
				| (0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state)))));
	vcdp->fullBus  (c+641,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_var),32);
	vcdp->fullBit  (c+575,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__shft_busy_i));
	vcdp->fullBus  (c+642,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__bit_cnt),6);
	vcdp->fullBit  (c+643,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__v_flag));
	vcdp->fullBit  (c+644,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__c_flag));
	vcdp->fullBit  (c+645,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__shift_state));
	vcdp->fullBus  (c+646,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__shft_op),32);
	vcdp->fullBit  (c+647,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__x_flag));
	vcdp->fullBus  (c+648,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__slice_cnt),2);
	vcdp->fullBus  (c+649,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_buffer_a),32);
	vcdp->fullBus  (c+650,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_buffer_b),32);
	vcdp->fullBus  (c+651,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_core),16);
	vcdp->fullBus  (c+656,((0xff & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_core))),8);
	vcdp->fullBus  (c+657,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw[0]),16);
	vcdp->fullBus  (c+658,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw[1]),16);
	vcdp->fullBus  (c+659,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw[2]),16);
	vcdp->fullBus  (c+654,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__exword_reg0),16);
	vcdp->fullBus  (c+655,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__exword_reg1),16);
	vcdp->fullBus  (c+652,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__dest_exword_reg0),16);
	vcdp->fullBus  (c+653,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__dest_exword_reg1),16);
	vcdp->fullBus  (c+661,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync)))),32);
	vcdp->fullBit  (c+662,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vblank));
	vcdp->fullBit  (c+660,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync));
	vcdp->fullBit  (c+663,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vpreset_n));
	vcdp->fullBit  (c+664,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vblank_n));
	vcdp->fullBit  (c+665,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync_n));
	vcdp->fullBit  (c+666,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vpreset));
	vcdp->fullBus  (c+667,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_odd__DOT__d),8);
	vcdp->fullBus  (c+668,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx_n)
				 ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_even__DOT__d)
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_odd__DOT__d))),8);
	vcdp->fullBus  (c+669,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_even__DOT__d),8);
	vcdp->fullBit  (c+672,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__waitstates));
	vcdp->fullBit  (c+670,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx));
	vcdp->fullBit  (c+671,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx_n));
	vcdp->fullBit  (c+673,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx)) 
				     | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
					>> 9)))));
	vcdp->fullBit  (c+674,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx) 
				     | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
					>> 9)))));
	vcdp->fullBit  (c+678,(((6 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				| ((7 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				   | (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))))));
	vcdp->fullBit  (c+679,(((8 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				| (0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)))));
	vcdp->fullBit  (c+683,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exword_counter_lock));
	vcdp->fullBus  (c+684,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__src_tmp),2);
	vcdp->fullBus  (c+685,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__dest_tmp),2);
	vcdp->fullBus  (c+686,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state),5);
	vcdp->fullBit  (c+676,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ew_adr_i));
	vcdp->fullBit  (c+675,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))));
	vcdp->fullBit  (c+680,((0xb == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))));
	vcdp->fullBit  (c+681,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i));
	vcdp->fullBit  (c+682,((((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 | (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				| (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)))));
	vcdp->fullBus  (c+687,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_filter),4);
	vcdp->fullBit  (c+677,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_cpu_in));
	vcdp->fullBit  (c+688,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_clr_n));
	vcdp->fullBit  (c+689,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_clr_n)))));
	vcdp->fullBit  (c+690,(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_n_v_d));
	vcdp->fullBus  (c+691,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mv_addr_odd),8);
	vcdp->fullBus  (c+692,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mv_addr_even),8);
	vcdp->fullBus  (c+695,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__e_timer),4);
	vcdp->fullBit  (c+694,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__vma_in));
	vcdp->fullBit  (c+696,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__syncn));
	vcdp->fullBit  (c+693,(vlTOPp->v__DOT__uut__DOT__ff__DOT__e));
	vcdp->fullBit  (c+697,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__vma_in) 
				      & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)))
				      ? 1 : 0))));
	vcdp->fullBus  (c+698,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v),8);
	vcdp->fullBit  (c+699,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v))));
	vcdp->fullBit  (c+700,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 1))));
	vcdp->fullBit  (c+701,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 2))));
	vcdp->fullBit  (c+702,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 3))));
	vcdp->fullBit  (c+703,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 4))));
	vcdp->fullBit  (c+704,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 6))));
	vcdp->fullBit  (c+705,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				      >> 2) ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)))));
	vcdp->fullBit  (c+706,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				      >> 1) ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)))));
	vcdp->fullBit  (c+707,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)))));
	vcdp->fullBit  (c+709,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state))));
	vcdp->fullBit  (c+708,((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state))));
	vcdp->fullBus  (c+710,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state),2);
	vcdp->fullBit  (c+711,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in));
	vcdp->fullBus  (c+712,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h),12);
	vcdp->fullBit  (c+713,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				     >> 1))));
	vcdp->fullBit  (c+714,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				     >> 2))));
	vcdp->fullBit  (c+715,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				     >> 5))));
	vcdp->fullBit  (c+716,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				     >> 7))));
	vcdp->fullBit  (c+717,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				     >> 8))));
	vcdp->fullBit  (c+718,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				     >> 9))));
	vcdp->fullBit  (c+719,((1 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
					>> 2)))));
	vcdp->fullBit  (c+720,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)) 
				     | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
					 >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
						  >> 1))))));
	vcdp->fullBit  (c+721,((1 & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
						  ? 
						 ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						  ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
						  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol)
					        : 0)) 
				       + (0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
						    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))
						    : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf)) 
						  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol_only))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol)
						  : 0))) 
				      + (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__nf) 
						 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol_only))
						 ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol)
						 : 0))) 
				     + (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__nf) 
						| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol_only))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol)
					        : 0))))));
	vcdp->fullBus  (c+722,((0x3f & ((((0xf & ((
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
						     ? 
						    ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
						     : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only))
						   ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol)
						   : 0)) 
					  + (0xf & 
					     ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
						 ? 
						((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
						 ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))
						 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf)) 
					       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol_only))
					       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol)
					       : 0))) 
					 + (0xf & (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__nf) 
						    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol_only))
						    ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol)
						    : 0))) 
					+ (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__nf) 
						   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol_only))
						   ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol)
						   : 0))))),6);
	vcdp->fullBus  (c+723,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serout),8);
	vcdp->fullBit  (c+724,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serout_rdy_o));
	vcdp->fullBit  (c+725,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serin_ack_o));
	vcdp->fullBit  (c+726,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_key_pressed));
	vcdp->fullBit  (c+727,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_key_break));
	vcdp->fullBit  (c+728,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_serin_rdy_i));
	vcdp->fullBit  (c+729,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_serout_ack_i));
	vcdp->fullBus  (c+731,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
					     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
					  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf)) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+732,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
					     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))
					  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf)) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+733,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__nf) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+734,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__nf) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+735,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__rst_bits),2);
	vcdp->fullBus  (c+736,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irqen),8);
	vcdp->fullBus  (c+737,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irqst),8);
	vcdp->fullBit  (c+738,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly9));
	vcdp->fullBit  (c+739,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fast_ch0));
	vcdp->fullBit  (c+740,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fast_ch2));
	vcdp->fullBit  (c+741,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__ch01));
	vcdp->fullBit  (c+742,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__ch23));
	vcdp->fullBit  (c+743,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02));
	vcdp->fullBit  (c+744,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13));
	vcdp->fullBit  (c+745,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__base15));
	vcdp->fullBus  (c+749,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift),3);
	vcdp->fullBus  (c+750,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift),3);
	vcdp->fullBus  (c+751,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift),3);
	vcdp->fullBus  (c+752,((0xff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__shift 
					>> 9))),8);
	vcdp->fullBus  (c+753,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[0]),8);
	vcdp->fullBus  (c+754,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[1]),8);
	vcdp->fullBus  (c+755,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[2]),8);
	vcdp->fullBus  (c+756,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[3]),8);
	vcdp->fullBus  (c+757,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[4]),8);
	vcdp->fullBus  (c+758,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[5]),8);
	vcdp->fullBus  (c+759,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[6]),8);
	vcdp->fullBus  (c+760,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[7]),8);
	vcdp->fullBus  (c+761,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_count),8);
	vcdp->fullBus  (c+762,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_base__DOT__div57),6);
	vcdp->fullBus  (c+763,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_base__DOT__div4),2);
	vcdp->fullBus  (c+764,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly4__DOT__shift),4);
	vcdp->fullBus  (c+765,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly5__DOT__shift),5);
	vcdp->fullBit  (c+730,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__rst_bits))));
	vcdp->fullBus  (c+766,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__shift),17);
	vcdp->fullBit  (c+767,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__last_short));
	vcdp->fullBus  (c+768,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6),8);
	vcdp->fullBit  (c+769,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6))));
	vcdp->fullBus  (c+770,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr0__DOT__freq),8);
	vcdp->fullBus  (c+771,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6),8);
	vcdp->fullBit  (c+772,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6))));
	vcdp->fullBus  (c+773,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr1__DOT__freq),8);
	vcdp->fullBus  (c+774,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6),8);
	vcdp->fullBit  (c+775,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6))));
	vcdp->fullBus  (c+776,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr2__DOT__freq),8);
	vcdp->fullBus  (c+777,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6),8);
	vcdp->fullBit  (c+778,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6))));
	vcdp->fullBus  (c+779,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr3__DOT__freq),8);
	vcdp->fullBit  (c+746,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly4__DOT__shift) 
				     >> 3))));
	vcdp->fullBit  (c+747,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly5__DOT__shift) 
				     >> 4))));
	vcdp->fullBit  (c+748,((1 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__shift 
				     >> 0x10))));
	vcdp->fullBit  (c+780,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
				 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))));
	vcdp->fullBit  (c+781,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only));
	vcdp->fullBus  (c+782,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol),4);
	vcdp->fullBit  (c+783,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__no_poly5));
	vcdp->fullBit  (c+784,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__poly4_sel));
	vcdp->fullBit  (c+785,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__no_poly17_4));
	vcdp->fullBit  (c+786,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf));
	vcdp->fullBit  (c+787,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg));
	vcdp->fullBit  (c+788,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift))));
	vcdp->fullBit  (c+789,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift))));
	vcdp->fullBit  (c+790,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift))));
	vcdp->fullBit  (c+791,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
				 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))));
	vcdp->fullBit  (c+792,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol_only));
	vcdp->fullBus  (c+793,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol),4);
	vcdp->fullBit  (c+794,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__no_poly5));
	vcdp->fullBit  (c+795,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__poly4_sel));
	vcdp->fullBit  (c+796,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__no_poly17_4));
	vcdp->fullBit  (c+797,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf));
	vcdp->fullBit  (c+798,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg));
	vcdp->fullBit  (c+799,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift) 
				     >> 1))));
	vcdp->fullBit  (c+800,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
				     >> 1))));
	vcdp->fullBit  (c+801,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift) 
				     >> 1))));
	vcdp->fullBit  (c+802,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__nf));
	vcdp->fullBit  (c+803,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol_only));
	vcdp->fullBus  (c+804,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol),4);
	vcdp->fullBit  (c+805,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__no_poly5));
	vcdp->fullBit  (c+806,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__poly4_sel));
	vcdp->fullBit  (c+807,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__no_poly17_4));
	vcdp->fullBit  (c+808,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__filter_reg));
	vcdp->fullBit  (c+809,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift) 
				     >> 2))));
	vcdp->fullBit  (c+810,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
				     >> 2))));
	vcdp->fullBit  (c+811,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift) 
				     >> 2))));
	vcdp->fullBit  (c+812,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__nf));
	vcdp->fullBit  (c+813,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol_only));
	vcdp->fullBus  (c+814,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol),4);
	vcdp->fullBit  (c+815,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__no_poly5));
	vcdp->fullBit  (c+816,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__poly4_sel));
	vcdp->fullBit  (c+817,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__no_poly17_4));
	vcdp->fullBit  (c+818,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__filter_reg));
	vcdp->fullBit  (c+819,((1 & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
						  ? 
						 ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						  ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
						  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol)
					        : 0)) 
				       + (0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
						    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))
						    : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf)) 
						  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol_only))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol)
						  : 0))) 
				      + (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__nf) 
						 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol_only))
						 ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol)
						 : 0))) 
				     + (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__nf) 
						| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol_only))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol)
					        : 0))))));
	vcdp->fullBus  (c+820,((0x3f & ((((0xf & ((
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
						     ? 
						    ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
						     : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only))
						   ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol)
						   : 0)) 
					  + (0xf & 
					     ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
						 ? 
						((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
						 ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))
						 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf)) 
					       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol_only))
					       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol)
					       : 0))) 
					 + (0xf & (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__nf) 
						    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol_only))
						    ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol)
						    : 0))) 
					+ (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__nf) 
						   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol_only))
						   ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol)
						   : 0))))),6);
	vcdp->fullBus  (c+821,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serout),8);
	vcdp->fullBit  (c+822,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serout_rdy_o));
	vcdp->fullBit  (c+823,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serin_ack_o));
	vcdp->fullBit  (c+824,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_key_pressed));
	vcdp->fullBit  (c+825,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_key_break));
	vcdp->fullBit  (c+826,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_serin_rdy_i));
	vcdp->fullBit  (c+827,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_serout_ack_i));
	vcdp->fullBus  (c+829,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
					     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
					  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf)) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+830,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
					     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))
					  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf)) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+831,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__nf) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+832,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__nf) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+833,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__rst_bits),2);
	vcdp->fullBus  (c+834,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irqen),8);
	vcdp->fullBus  (c+835,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irqst),8);
	vcdp->fullBit  (c+836,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly9));
	vcdp->fullBit  (c+837,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fast_ch0));
	vcdp->fullBit  (c+838,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fast_ch2));
	vcdp->fullBit  (c+839,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__ch01));
	vcdp->fullBit  (c+840,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__ch23));
	vcdp->fullBit  (c+841,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02));
	vcdp->fullBit  (c+842,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13));
	vcdp->fullBit  (c+843,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__base15));
	vcdp->fullBus  (c+847,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift),3);
	vcdp->fullBus  (c+848,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift),3);
	vcdp->fullBus  (c+849,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift),3);
	vcdp->fullBus  (c+850,((0xff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__shift 
					>> 9))),8);
	vcdp->fullBus  (c+851,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[0]),8);
	vcdp->fullBus  (c+852,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[1]),8);
	vcdp->fullBus  (c+853,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[2]),8);
	vcdp->fullBus  (c+854,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[3]),8);
	vcdp->fullBus  (c+855,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[4]),8);
	vcdp->fullBus  (c+856,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[5]),8);
	vcdp->fullBus  (c+857,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[6]),8);
	vcdp->fullBus  (c+858,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[7]),8);
	vcdp->fullBus  (c+859,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_count),8);
	vcdp->fullBus  (c+860,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_base__DOT__div57),6);
	vcdp->fullBus  (c+861,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_base__DOT__div4),2);
	vcdp->fullBus  (c+862,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly4__DOT__shift),4);
	vcdp->fullBus  (c+863,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly5__DOT__shift),5);
	vcdp->fullBit  (c+828,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__rst_bits))));
	vcdp->fullBus  (c+864,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__shift),17);
	vcdp->fullBit  (c+865,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__last_short));
	vcdp->fullBus  (c+866,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6),8);
	vcdp->fullBit  (c+867,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6))));
	vcdp->fullBus  (c+868,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr0__DOT__freq),8);
	vcdp->fullBus  (c+869,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6),8);
	vcdp->fullBit  (c+870,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6))));
	vcdp->fullBus  (c+871,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr1__DOT__freq),8);
	vcdp->fullBus  (c+872,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6),8);
	vcdp->fullBit  (c+873,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6))));
	vcdp->fullBus  (c+874,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr2__DOT__freq),8);
	vcdp->fullBus  (c+875,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6),8);
	vcdp->fullBit  (c+876,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6))));
	vcdp->fullBus  (c+877,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr3__DOT__freq),8);
	vcdp->fullBit  (c+844,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly4__DOT__shift) 
				     >> 3))));
	vcdp->fullBit  (c+845,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly5__DOT__shift) 
				     >> 4))));
	vcdp->fullBit  (c+846,((1 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__shift 
				     >> 0x10))));
	vcdp->fullBit  (c+878,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
				 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))));
	vcdp->fullBit  (c+879,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only));
	vcdp->fullBus  (c+880,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol),4);
	vcdp->fullBit  (c+881,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__no_poly5));
	vcdp->fullBit  (c+882,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__poly4_sel));
	vcdp->fullBit  (c+883,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__no_poly17_4));
	vcdp->fullBit  (c+884,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf));
	vcdp->fullBit  (c+885,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg));
	vcdp->fullBit  (c+886,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift))));
	vcdp->fullBit  (c+887,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift))));
	vcdp->fullBit  (c+888,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift))));
	vcdp->fullBit  (c+889,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
				 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))));
	vcdp->fullBit  (c+890,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol_only));
	vcdp->fullBus  (c+891,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol),4);
	vcdp->fullBit  (c+892,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__no_poly5));
	vcdp->fullBit  (c+893,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__poly4_sel));
	vcdp->fullBit  (c+894,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__no_poly17_4));
	vcdp->fullBit  (c+895,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf));
	vcdp->fullBit  (c+896,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg));
	vcdp->fullBit  (c+897,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift) 
				     >> 1))));
	vcdp->fullBit  (c+898,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
				     >> 1))));
	vcdp->fullBit  (c+899,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift) 
				     >> 1))));
	vcdp->fullBit  (c+900,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__nf));
	vcdp->fullBit  (c+901,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol_only));
	vcdp->fullBus  (c+902,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol),4);
	vcdp->fullBit  (c+903,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__no_poly5));
	vcdp->fullBit  (c+904,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__poly4_sel));
	vcdp->fullBit  (c+905,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__no_poly17_4));
	vcdp->fullBit  (c+906,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__filter_reg));
	vcdp->fullBit  (c+907,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift) 
				     >> 2))));
	vcdp->fullBit  (c+908,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
				     >> 2))));
	vcdp->fullBit  (c+909,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift) 
				     >> 2))));
	vcdp->fullBit  (c+910,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__nf));
	vcdp->fullBit  (c+911,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol_only));
	vcdp->fullBus  (c+912,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol),4);
	vcdp->fullBit  (c+913,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__no_poly5));
	vcdp->fullBit  (c+914,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__poly4_sel));
	vcdp->fullBit  (c+915,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__no_poly17_4));
	vcdp->fullBit  (c+916,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__filter_reg));
	vcdp->fullBit  (c+917,((1 & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
						  ? 
						 ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						  ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
						  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol)
					        : 0)) 
				       + (0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
						    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))
						    : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf)) 
						  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol_only))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol)
						  : 0))) 
				      + (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__nf) 
						 | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol_only))
						 ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol)
						 : 0))) 
				     + (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__nf) 
						| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol_only))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol)
					        : 0))))));
	vcdp->fullBus  (c+918,((0x3f & ((((0xf & ((
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
						     ? 
						    ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
						     : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only))
						   ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol)
						   : 0)) 
					  + (0xf & 
					     ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
						 ? 
						((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
						 ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))
						 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf)) 
					       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol_only))
					       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol)
					       : 0))) 
					 + (0xf & (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__nf) 
						    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol_only))
						    ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol)
						    : 0))) 
					+ (0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__nf) 
						   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol_only))
						   ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol)
						   : 0))))),6);
	vcdp->fullBus  (c+919,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serout),8);
	vcdp->fullBit  (c+920,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serout_rdy_o));
	vcdp->fullBit  (c+921,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serin_ack_o));
	vcdp->fullBit  (c+922,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_key_pressed));
	vcdp->fullBit  (c+923,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_key_break));
	vcdp->fullBit  (c+924,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_serin_rdy_i));
	vcdp->fullBit  (c+925,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_serout_ack_i));
	vcdp->fullBus  (c+927,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
					     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
					  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf)) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+928,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
					     ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))
					  : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf)) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+929,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__nf) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+930,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__nf) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol_only))
				        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol)
				        : 0))),4);
	vcdp->fullBus  (c+931,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__rst_bits),2);
	vcdp->fullBus  (c+932,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irqen),8);
	vcdp->fullBus  (c+933,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irqst),8);
	vcdp->fullBit  (c+934,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly9));
	vcdp->fullBit  (c+935,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fast_ch0));
	vcdp->fullBit  (c+936,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fast_ch2));
	vcdp->fullBit  (c+937,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__ch01));
	vcdp->fullBit  (c+938,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__ch23));
	vcdp->fullBit  (c+939,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02));
	vcdp->fullBit  (c+940,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13));
	vcdp->fullBit  (c+941,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__base15));
	vcdp->fullBus  (c+945,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift),3);
	vcdp->fullBus  (c+946,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift),3);
	vcdp->fullBus  (c+947,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift),3);
	vcdp->fullBus  (c+948,((0xff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift 
					>> 9))),8);
	vcdp->fullBus  (c+949,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[0]),8);
	vcdp->fullBus  (c+950,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[1]),8);
	vcdp->fullBus  (c+951,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[2]),8);
	vcdp->fullBus  (c+952,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[3]),8);
	vcdp->fullBus  (c+953,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[4]),8);
	vcdp->fullBus  (c+954,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[5]),8);
	vcdp->fullBus  (c+955,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[6]),8);
	vcdp->fullBus  (c+956,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[7]),8);
	vcdp->fullBus  (c+957,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_count),8);
	vcdp->fullBus  (c+958,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_base__DOT__div57),6);
	vcdp->fullBus  (c+959,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_base__DOT__div4),2);
	vcdp->fullBus  (c+960,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly4__DOT__shift),4);
	vcdp->fullBus  (c+961,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly5__DOT__shift),5);
	vcdp->fullBit  (c+926,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__rst_bits))));
	vcdp->fullBus  (c+962,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift),17);
	vcdp->fullBit  (c+963,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__last_short));
	vcdp->fullBus  (c+964,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6),8);
	vcdp->fullBit  (c+965,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6))));
	vcdp->fullBus  (c+966,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr0__DOT__freq),8);
	vcdp->fullBus  (c+967,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6),8);
	vcdp->fullBit  (c+968,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6))));
	vcdp->fullBus  (c+969,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr1__DOT__freq),8);
	vcdp->fullBus  (c+970,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6),8);
	vcdp->fullBit  (c+971,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6))));
	vcdp->fullBus  (c+972,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr2__DOT__freq),8);
	vcdp->fullBus  (c+973,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6),8);
	vcdp->fullBit  (c+974,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6))));
	vcdp->fullBus  (c+975,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr3__DOT__freq),8);
	vcdp->fullBit  (c+942,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly4__DOT__shift) 
				     >> 3))));
	vcdp->fullBit  (c+943,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly5__DOT__shift) 
				     >> 4))));
	vcdp->fullBit  (c+944,((1 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift 
				     >> 0x10))));
	vcdp->fullBit  (c+976,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
				 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))));
	vcdp->fullBit  (c+977,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only));
	vcdp->fullBus  (c+978,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol),4);
	vcdp->fullBit  (c+979,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__no_poly5));
	vcdp->fullBit  (c+980,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__poly4_sel));
	vcdp->fullBit  (c+981,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__no_poly17_4));
	vcdp->fullBit  (c+982,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf));
	vcdp->fullBit  (c+983,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg));
	vcdp->fullBit  (c+984,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift))));
	vcdp->fullBit  (c+985,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift))));
	vcdp->fullBit  (c+986,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift))));
	vcdp->fullBit  (c+987,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
				 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))
				 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))));
	vcdp->fullBit  (c+988,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol_only));
	vcdp->fullBus  (c+989,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol),4);
	vcdp->fullBit  (c+990,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__no_poly5));
	vcdp->fullBit  (c+991,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__poly4_sel));
	vcdp->fullBit  (c+992,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__no_poly17_4));
	vcdp->fullBit  (c+993,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf));
	vcdp->fullBit  (c+994,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg));
	vcdp->fullBit  (c+995,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift) 
				     >> 1))));
	vcdp->fullBit  (c+996,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
				     >> 1))));
	vcdp->fullBit  (c+997,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift) 
				     >> 1))));
	vcdp->fullBit  (c+998,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__nf));
	vcdp->fullBit  (c+999,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol_only));
	vcdp->fullBus  (c+1000,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol),4);
	vcdp->fullBit  (c+1001,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__no_poly5));
	vcdp->fullBit  (c+1002,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__poly4_sel));
	vcdp->fullBit  (c+1003,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__no_poly17_4));
	vcdp->fullBit  (c+1004,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__filter_reg));
	vcdp->fullBit  (c+1005,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift) 
				      >> 2))));
	vcdp->fullBit  (c+1006,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
				      >> 2))));
	vcdp->fullBit  (c+1007,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift) 
				      >> 2))));
	vcdp->fullBit  (c+1008,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__nf));
	vcdp->fullBit  (c+1009,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol_only));
	vcdp->fullBus  (c+1010,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol),4);
	vcdp->fullBit  (c+1011,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__no_poly5));
	vcdp->fullBit  (c+1012,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__poly4_sel));
	vcdp->fullBit  (c+1013,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__no_poly17_4));
	vcdp->fullBit  (c+1014,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__filter_reg));
	vcdp->fullBit  (c+1015,(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_n_v));
	vcdp->fullBit  (c+1016,(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_v_n));
	vcdp->fullBus  (c+1017,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_rom_a),8);
	vcdp->fullBus  (c+1018,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfv_hold),6);
	vcdp->fullBit  (c+1022,((1 & ((0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
				       ? 0 : 1))));
	vcdp->fullBit  (c+1019,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_out_en_i)
				       ? 0 : 1))));
	vcdp->fullBit  (c+1023,((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))));
	vcdp->fullBit  (c+1024,(((0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				 & ((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				    & ((2 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				       & (3 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)))))));
	vcdp->fullBus  (c+1025,(((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
				  ? 7 : (((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					  | (0xd == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)))
					  ? 6 : (((0xe 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
						  | (0xf 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)))
						  ? 6
						  : 5)))),3);
	vcdp->fullBit  (c+1027,(((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				 | ((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				    | ((0xd == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				       | ((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					  | (0xf == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))))))));
	vcdp->fullBit  (c+1026,(((5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				 | ((6 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				    | ((7 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				       | ((8 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					  | ((9 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					     | ((0xa 
						 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
						| (0xb 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))))))))));
	vcdp->fullBit  (c+1021,((0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))));
	vcdp->fullBus  (c+1029,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state),5);
	vcdp->fullBit  (c+1028,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__reset_rdy_i));
	vcdp->fullBus  (c+1030,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_timer),7);
	vcdp->fullBit  (c+1031,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_timer_lock));
	vcdp->fullBit  (c+1020,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_out_en_i));
	vcdp->fullBus  (c+1032,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_out_h_hold),8);
	vcdp->fullBit  (c+1035,(vlTOPp->v__DOT__uut__DOT__ff__DOT__int4rst_n));
	vcdp->fullBit  (c+1036,(vlTOPp->v__DOT__uut__DOT__ff__DOT__int3rst_n));
	vcdp->fullBit  (c+1037,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counterr));
	vcdp->fullBit  (c+1038,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counterl));
	vcdp->fullBit  (c+1034,(vlTOPp->v__DOT__uut__DOT__ff__DOT__led2));
	vcdp->fullBit  (c+1033,(vlTOPp->v__DOT__uut__DOT__ff__DOT__led1));
	vcdp->fullBit  (c+1039,(vlTOPp->v__DOT__uut__DOT__ff__DOT__update));
	vcdp->fullBit  (c+1040,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip));
	vcdp->fullBit  (c+1041,(vlTOPp->v__DOT__CLK));
	vcdp->fullBit  (c+1042,(vlTOPp->v__DOT__clk25));
	vcdp->fullBus  (c+1045,(vlTOPp->v__DOT__sw),10);
	vcdp->fullBit  (c+1043,(vlTOPp->v__DOT__clk12));
	vcdp->fullBit  (c+1047,((1 & (IData)(vlTOPp->v__DOT__sw))));
	vcdp->fullBit  (c+1048,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 1))));
	vcdp->fullBit  (c+1049,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 2))));
	vcdp->fullBit  (c+1050,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 3))));
	vcdp->fullBit  (c+1051,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 4))));
	vcdp->fullBit  (c+1052,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 5))));
	vcdp->fullBit  (c+1053,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 6))));
	vcdp->fullBit  (c+1054,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 7))));
	vcdp->fullBit  (c+1055,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 8))));
	vcdp->fullBit  (c+1056,((1 & ((IData)(vlTOPp->v__DOT__sw) 
				      >> 9))));
	vcdp->fullBus  (c+1059,(((0x80 & ((IData)(vlTOPp->v__DOT__sw) 
					  << 7)) | 
				 ((0x40 & ((IData)(vlTOPp->v__DOT__sw) 
					   << 5)) | 
				  ((0x20 & ((IData)(vlTOPp->v__DOT__sw) 
					    << 3)) 
				   | ((0x10 & ((IData)(vlTOPp->v__DOT__sw) 
					       << 1)) 
				      | ((8 & ((IData)(vlTOPp->v__DOT__sw) 
					       >> 1)) 
					 | ((4 & ((IData)(vlTOPp->v__DOT__sw) 
						  >> 3)) 
					    | ((2 & 
						((IData)(vlTOPp->v__DOT__sw) 
						 >> 5)) 
					       | (1 
						  & ((IData)(vlTOPp->v__DOT__sw) 
						     >> 7)))))))))),8);
	vcdp->fullBit  (c+1060,(vlTOPp->v__DOT__uut__DOT__ff__DOT__clk_1vx));
	vcdp->fullBus  (c+1061,(0),16);
	vcdp->fullBit  (c+1063,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__resetoutn));
	vcdp->fullBit  (c+1064,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__haltoutn));
	vcdp->fullBit  (c+1065,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_sign));
	vcdp->fullBit  (c+1058,((1 & (~ (IData)(vlTOPp->v__DOT__reset)))));
	vcdp->fullBit  (c+1057,(1));
	vcdp->fullBus  (c+1066,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__p),8);
	vcdp->fullBit  (c+1068,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serout_ack_i));
	vcdp->fullBus  (c+1069,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irq_i),32);
	vcdp->fullBus  (c+1070,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__p),8);
	vcdp->fullBit  (c+1071,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serout_ack_i));
	vcdp->fullBus  (c+1072,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irq_i),32);
	vcdp->fullBit  (c+1044,(vlTOPp->v__DOT__reset));
	vcdp->fullBus  (c+1046,(vlTOPp->v__DOT__sw1),8);
	vcdp->fullBit  (c+1073,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serout_ack_i));
	vcdp->fullBus  (c+1067,(0),8);
	vcdp->fullBus  (c+1074,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irq_i),32);
	vcdp->fullBit  (c+1062,(0));
    }
}
