// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vff_verilator__Syms.h"


//======================

void Vff_verilator::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vff_verilator* t=(Vff_verilator*)userthis;
    Vff_verilator__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis (vlSymsp, vcdp, code);
    }
}

//======================


void Vff_verilator::traceChgThis(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	if (VL_UNLIKELY((1 & (IData)(vlTOPp->__Vm_traceActivity)))) {
	    vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 2)))))) {
	    vlTOPp->traceChgThis__3(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 3)))))) {
	    vlTOPp->traceChgThis__4(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((((IData)(vlTOPp->__Vm_traceActivity) 
				   | (IData)((vlTOPp->__Vm_traceActivity 
					      >> 2))) 
				  | (IData)((vlTOPp->__Vm_traceActivity 
					     >> 4))) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 6))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 0xe))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x19))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x1a)))))) {
	    vlTOPp->traceChgThis__5(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 6)))))) {
	    vlTOPp->traceChgThis__6(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 7)))))) {
	    vlTOPp->traceChgThis__7(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((((IData)(vlTOPp->__Vm_traceActivity) 
				  | (IData)((vlTOPp->__Vm_traceActivity 
					     >> 2))) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 7))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 8))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x19)))))) {
	    vlTOPp->traceChgThis__8(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((IData)(vlTOPp->__Vm_traceActivity) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 2))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 7))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0xe)))))) {
	    vlTOPp->traceChgThis__9(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((IData)(vlTOPp->__Vm_traceActivity) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 2))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 7))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x19)))))) {
	    vlTOPp->traceChgThis__10(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((IData)(vlTOPp->__Vm_traceActivity) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 2))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 7))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x19)))))) {
	    vlTOPp->traceChgThis__11(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((IData)(vlTOPp->__Vm_traceActivity) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 2))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 7))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x20))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x29)))))) {
	    vlTOPp->traceChgThis__12(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 8)))))) {
	    vlTOPp->traceChgThis__13(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((IData)(vlTOPp->__Vm_traceActivity) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 2))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 9))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x20)))))) {
	    vlTOPp->traceChgThis__14(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((IData)(vlTOPp->__Vm_traceActivity) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 2))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 9))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x20))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x27)))))) {
	    vlTOPp->traceChgThis__15(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0xd)))))) {
	    vlTOPp->traceChgThis__16(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((IData)(vlTOPp->__Vm_traceActivity) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 2))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 0xd))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x1a)))))) {
	    vlTOPp->traceChgThis__17(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0xe)))))) {
	    vlTOPp->traceChgThis__18(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((IData)(vlTOPp->__Vm_traceActivity) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 2))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x19)))))) {
	    vlTOPp->traceChgThis__19(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((((IData)(vlTOPp->__Vm_traceActivity) 
				   | (IData)((vlTOPp->__Vm_traceActivity 
					      >> 2))) 
				  | (IData)((vlTOPp->__Vm_traceActivity 
					     >> 0xe))) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 0x19))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 0x1a))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x20))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x27)))))) {
	    vlTOPp->traceChgThis__20(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((((((IData)(vlTOPp->__Vm_traceActivity) 
				    | (IData)((vlTOPp->__Vm_traceActivity 
					       >> 2))) 
				   | (IData)((vlTOPp->__Vm_traceActivity 
					      >> 0xe))) 
				  | (IData)((vlTOPp->__Vm_traceActivity 
					     >> 0x19))) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 0x1a))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 0x20))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x27))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x28)))))) {
	    vlTOPp->traceChgThis__21(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((((IData)(vlTOPp->__Vm_traceActivity) 
				  | (IData)((vlTOPp->__Vm_traceActivity 
					     >> 2))) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 0xe))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 0x19))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x20))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x27)))))) {
	    vlTOPp->traceChgThis__22(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((IData)(vlTOPp->__Vm_traceActivity) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 2))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x10))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x19)))))) {
	    vlTOPp->traceChgThis__23(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x13)))))) {
	    vlTOPp->traceChgThis__24(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x19)))))) {
	    vlTOPp->traceChgThis__25(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((IData)(vlTOPp->__Vm_traceActivity) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 2))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x19))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x1a)))))) {
	    vlTOPp->traceChgThis__26(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x1d)))))) {
	    vlTOPp->traceChgThis__27(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 2))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x25)))))) {
	    vlTOPp->traceChgThis__28(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 3)))))) {
	    vlTOPp->traceChgThis__29(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 3))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x18)))))) {
	    vlTOPp->traceChgThis__30(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 4)))))) {
	    vlTOPp->traceChgThis__31(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((((IData)(vlTOPp->__Vm_traceActivity) 
				 | (IData)((vlTOPp->__Vm_traceActivity 
					    >> 6))) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 7))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 8))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x20)))))) {
	    vlTOPp->traceChgThis__32(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 7)))))) {
	    vlTOPp->traceChgThis__33(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 8)))))) {
	    vlTOPp->traceChgThis__34(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 8))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x19)))))) {
	    vlTOPp->traceChgThis__35(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 8))) | (IData)(
							    (vlTOPp->__Vm_traceActivity 
							     >> 0x1f)))))) {
	    vlTOPp->traceChgThis__36(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 9)))))) {
	    vlTOPp->traceChgThis__37(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((((IData)(vlTOPp->__Vm_traceActivity) 
				| (IData)((vlTOPp->__Vm_traceActivity 
					   >> 9))) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x20)))))) {
	    vlTOPp->traceChgThis__38(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0xd)))))) {
	    vlTOPp->traceChgThis__39(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0xe)))))) {
	    vlTOPp->traceChgThis__40(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0xe))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x27)))))) {
	    vlTOPp->traceChgThis__41(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0xf)))))) {
	    vlTOPp->traceChgThis__42(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x10)))))) {
	    vlTOPp->traceChgThis__43(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x11)))))) {
	    vlTOPp->traceChgThis__44(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)(vlTOPp->__Vm_traceActivity) 
			       | (IData)((vlTOPp->__Vm_traceActivity 
					  >> 0x11))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x21)))))) {
	    vlTOPp->traceChgThis__45(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x17)))))) {
	    vlTOPp->traceChgThis__46(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x18)))))) {
	    vlTOPp->traceChgThis__47(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x19)))))) {
	    vlTOPp->traceChgThis__48(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x1a)))))) {
	    vlTOPp->traceChgThis__49(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x1c)))))) {
	    vlTOPp->traceChgThis__50(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x1f)))))) {
	    vlTOPp->traceChgThis__51(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x20)))))) {
	    vlTOPp->traceChgThis__52(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x21)))))) {
	    vlTOPp->traceChgThis__53(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x22)))))) {
	    vlTOPp->traceChgThis__54(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x23)))))) {
	    vlTOPp->traceChgThis__55(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x26)))))) {
	    vlTOPp->traceChgThis__56(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x27)))))) {
	    vlTOPp->traceChgThis__57(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x28)))))) {
	    vlTOPp->traceChgThis__58(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)(vlTOPp->__Vm_traceActivity) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x29)))))) {
	    vlTOPp->traceChgThis__59(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 1))))) {
	    vlTOPp->traceChgThis__60(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 3))))) {
	    vlTOPp->traceChgThis__61(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 4))))) {
	    vlTOPp->traceChgThis__62(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 4)) | (IData)(
							(vlTOPp->__Vm_traceActivity 
							 >> 6)))))) {
	    vlTOPp->traceChgThis__63(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 4)) | (IData)(
							(vlTOPp->__Vm_traceActivity 
							 >> 0xa)))))) {
	    vlTOPp->traceChgThis__64(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)((vlTOPp->__Vm_traceActivity 
					>> 4)) | (IData)(
							 (vlTOPp->__Vm_traceActivity 
							  >> 0x1e))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0x25)))))) {
	    vlTOPp->traceChgThis__65(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 4)) | (IData)(
							(vlTOPp->__Vm_traceActivity 
							 >> 0x25)))))) {
	    vlTOPp->traceChgThis__66(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 5))))) {
	    vlTOPp->traceChgThis__67(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 6))))) {
	    vlTOPp->traceChgThis__68(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 7))))) {
	    vlTOPp->traceChgThis__69(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 8))))) {
	    vlTOPp->traceChgThis__70(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0xa))))) {
	    vlTOPp->traceChgThis__71(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0xb))))) {
	    vlTOPp->traceChgThis__72(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (((IData)((vlTOPp->__Vm_traceActivity 
					>> 0xb)) | (IData)(
							   (vlTOPp->__Vm_traceActivity 
							    >> 0xc))) 
			      | (IData)((vlTOPp->__Vm_traceActivity 
					 >> 0xd)))))) {
	    vlTOPp->traceChgThis__73(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0xc))))) {
	    vlTOPp->traceChgThis__74(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0xd))))) {
	    vlTOPp->traceChgThis__75(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 0xd)) | (IData)(
							  (vlTOPp->__Vm_traceActivity 
							   >> 0x1b)))))) {
	    vlTOPp->traceChgThis__76(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0xe))))) {
	    vlTOPp->traceChgThis__77(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x12))))) {
	    vlTOPp->traceChgThis__78(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x13))))) {
	    vlTOPp->traceChgThis__79(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x14))))) {
	    vlTOPp->traceChgThis__80(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x15))))) {
	    vlTOPp->traceChgThis__81(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x16))))) {
	    vlTOPp->traceChgThis__82(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 0x16)) | (IData)(
							   (vlTOPp->__Vm_traceActivity 
							    >> 0x19)))))) {
	    vlTOPp->traceChgThis__83(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x17))))) {
	    vlTOPp->traceChgThis__84(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 0x17)) | (IData)(
							   (vlTOPp->__Vm_traceActivity 
							    >> 0x25)))))) {
	    vlTOPp->traceChgThis__85(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x19))))) {
	    vlTOPp->traceChgThis__86(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x1a))))) {
	    vlTOPp->traceChgThis__87(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x1b))))) {
	    vlTOPp->traceChgThis__88(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((IData)((vlTOPp->__Vm_traceActivity 
				       >> 0x1b)) | (IData)(
							   (vlTOPp->__Vm_traceActivity 
							    >> 0x25)))))) {
	    vlTOPp->traceChgThis__89(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x1c))))) {
	    vlTOPp->traceChgThis__90(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x1d))))) {
	    vlTOPp->traceChgThis__91(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x1e))))) {
	    vlTOPp->traceChgThis__92(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x20))))) {
	    vlTOPp->traceChgThis__93(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x24))))) {
	    vlTOPp->traceChgThis__94(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (IData)((vlTOPp->__Vm_traceActivity 
				      >> 0x25))))) {
	    vlTOPp->traceChgThis__95(vlSymsp, vcdp, code);
	}
    }
    // Final
    vlTOPp->__Vm_traceActivity = VL_ULL(0);
}

void Vff_verilator::traceChgThis__2(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1,(vlTOPp->v__DOT__uut__DOT__ff__DOT__nvram__DOT__j),32);
	vcdp->chgBus  (c+2,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coderam_h__DOT__i),32);
	vcdp->chgBus  (c+3,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coderam_l__DOT__i),32);
	vcdp->chgBus  (c+4,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_3n_3m__DOT__i),32);
	vcdp->chgBus  (c+5,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_3l_3k__DOT__i),32);
	vcdp->chgBus  (c+6,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6c__DOT__j),32);
	vcdp->chgBus  (c+7,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6d__DOT__j),32);
	vcdp->chgBus  (c+8,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6e__DOT__j),32);
	vcdp->chgBus  (c+9,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_6f__DOT__j),32);
	vcdp->chgBus  (c+10,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_odd__DOT__j),32);
	vcdp->chgBus  (c+11,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_even__DOT__j),32);
	vcdp->chgBus  (c+12,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_7p__DOT__j),32);
	vcdp->chgBus  (c+13,(vlTOPp->v__DOT__uut__DOT__ff__DOT__chip_7n__DOT__j),32);
	vcdp->chgBus  (c+14,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__i),32);
	vcdp->chgBus  (c+15,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__i),32);
	vcdp->chgBus  (c+16,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__i),32);
    }
}

void Vff_verilator::traceChgThis__3(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+17,((vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
			      << 1)),24);
	vcdp->chgBit  (c+24,((1 & (~ ((((0x94 == (0xfc 
						  & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						     >> 0xf))) 
					& (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0xf))) 
				       & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0xe))) 
				      & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					    >> 0xd)))))));
	vcdp->chgBit  (c+26,(vlTOPp->v__DOT__uut__DOT__ff__DOT__digitalin_n));
	vcdp->chgBus  (c+28,(vlTOPp->v__DOT__uut__DOT__ff__DOT__nvram_out),4);
	vcdp->chgBus  (c+30,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_out),16);
	vcdp->chgBus  (c+31,(((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram0_n)) 
				    | (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram1_n))))
			       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_ram)
			       : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_rom))),16);
	vcdp->chgBus  (c+32,((0xfffe & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					<< 1))),16);
	vcdp->chgBit  (c+33,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_n) 
			      | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__uds_n))));
	vcdp->chgBit  (c+34,(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_l_n));
	vcdp->chgBit  (c+35,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_n)))));
	vcdp->chgBit  (c+36,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__as_n)))));
	vcdp->chgBit  (c+37,((1 & (~ ((~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					  >> 0x16)) 
				      | (0x90 == (0xfc 
						  & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						     >> 0xf))))))));
	vcdp->chgBit  (c+39,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_l_n) 
			      | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__digitalin_n))));
	vcdp->chgBit  (c+47,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram0_n));
	vcdp->chgBit  (c+48,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram1_n));
	vcdp->chgBit  (c+49,(vlTOPp->v__DOT__uut__DOT__ff__DOT__objram_n));
	vcdp->chgBit  (c+50,((1 & (~ ((((0x94 == (0xfc 
						  & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						     >> 0xf))) 
					& (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					   >> 0xf)) 
				       & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					  >> 0xe)) 
				      & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					    >> 0xd)))))));
	vcdp->chgBit  (c+51,((1 & (~ ((((0x94 == (0xfc 
						  & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						     >> 0xf))) 
					& (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					   >> 0xf)) 
				       & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0xe))) 
				      & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					 >> 0xd))))));
	vcdp->chgBit  (c+52,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloram_n));
	vcdp->chgBit  (c+53,((1 & (~ ((((0x94 == (0xfc 
						  & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						     >> 0xf))) 
					& (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					      >> 0xf))) 
				       & (~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0xe))) 
				      & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					 >> 0xd))))));
	vcdp->chgBit  (c+54,((0x94 != (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					       >> 0xf)))));
	vcdp->chgBit  (c+55,((0x80 != (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					       >> 0xf)))));
	vcdp->chgBit  (c+56,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h));
	vcdp->chgBit  (c+57,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_8h));
	vcdp->chgBus  (c+58,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_rom),16);
	vcdp->chgBus  (c+59,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mb_out_ram),16);
	vcdp->chgBit  (c+60,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_6mhz));
	vcdp->chgBit  (c+61,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_32h));
	vcdp->chgBit  (c+62,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h)))));
	vcdp->chgBit  (c+63,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_256h_n));
	vcdp->chgBus  (c+64,(vlTOPp->v__DOT__uut__DOT__ff__DOT__prom_2b_addr),8);
	vcdp->chgBus  (c+65,(vlTOPp->v__DOT__uut__DOT__ff__DOT__prom_out),4);
	vcdp->chgBit  (c+66,(vlTOPp->v__DOT__uut__DOT__ff__DOT__blank_n));
	vcdp->chgBus  (c+69,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_data),8);
	vcdp->chgBus  (c+70,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_rom_addr),13);
	vcdp->chgBit  (c+71,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_s0));
	vcdp->chgBus  (c+72,(vlTOPp->v__DOT__uut__DOT__ff__DOT__moram_addr),7);
	vcdp->chgBus  (c+73,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mod),16);
	vcdp->chgBus  (c+76,(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum),8);
	vcdp->chgBit  (c+77,((1 & (((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
				      >> 7) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
					       >> 6)) 
				    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
				       >> 5)) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__sum) 
						 >> 4)))));
	vcdp->chgBit  (c+78,(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddclk));
	vcdp->chgBit  (c+79,(vlTOPp->v__DOT__uut__DOT__ff__DOT__evencs_n));
	vcdp->chgBit  (c+80,(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddcs_n));
	vcdp->chgBit  (c+81,(vlTOPp->v__DOT__uut__DOT__ff__DOT__evenclk));
	vcdp->chgBit  (c+82,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hload_n));
	vcdp->chgBus  (c+84,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4e__d) 
			       << 8) | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4d__d))),16);
	vcdp->chgBus  (c+85,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s1s0),2);
	vcdp->chgBit  (c+86,(vlTOPp->v__DOT__uut__DOT__ff__DOT__regld));
	vcdp->chgBit  (c+87,(vlTOPp->v__DOT__uut__DOT__ff__DOT__stamp_active));
	vcdp->chgBus  (c+89,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb_cr_out),8);
	vcdp->chgBit  (c+91,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloram_n)))));
	vcdp->chgBus  (c+92,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr),23);
	vcdp->chgBit  (c+21,(vlTOPp->v__DOT__uut__DOT__ff__DOT__uds_n));
	vcdp->chgBit  (c+22,(vlTOPp->v__DOT__uut__DOT__ff__DOT__lds_n));
	vcdp->chgBus  (c+93,((0x7fffff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i 
					  >> 1))),23);
	vcdp->chgBus  (c+19,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out),16);
	vcdp->chgBus  (c+94,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_eff_i),32);
	vcdp->chgBus  (c+95,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i),32);
	vcdp->chgBus  (c+97,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s),32);
	vcdp->chgBus  (c+99,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_d_lo),32);
	vcdp->chgBus  (c+103,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__areg_data_in),32);
	vcdp->chgBit  (c+105,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__byten_word_i));
	vcdp->chgBus  (c+106,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_out_i),32);
	vcdp->chgBus  (c+110,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dreg_data_in_a),32);
	vcdp->chgBus  (c+111,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dreg_data_in_b),32);
	vcdp->chgBit  (c+113,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__hi_byte_en_i));
	vcdp->chgBit  (c+116,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__lo_byte_en_i));
	vcdp->chgBit  (c+120,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_init_irq));
	vcdp->chgBus  (c+122,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_dreg_b),32);
	vcdp->chgBus  (c+126,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__result_alu_hi),32);
	vcdp->chgBus  (c+127,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__result_alu_lo),32);
	vcdp->chgBus  (c+128,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__result_shft),32);
	vcdp->chgBus  (c+130,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__shft_op_in),32);
	vcdp->chgBus  (c+133,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sr_ccr_mux),16);
	vcdp->chgBit  (c+134,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ssp_dec_irq));
	vcdp->chgBit  (c+139,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__use_int_vect_i));
	vcdp->chgBus  (c+140,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_alu),5);
	vcdp->chgBus  (c+141,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__xnzvc_shft),5);
	vcdp->chgBus  (c+142,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__bit_pnt),5);
	vcdp->chgBus  (c+143,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__regsel_tmp),3);
	vcdp->chgBus  (c+144,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state),5);
	vcdp->chgBit  (c+145,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__sr_wr));
	vcdp->chgBit  (c+114,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__init_status_i));
	vcdp->chgBit  (c+112,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__exec_abort_i));
	vcdp->chgBit  (c+115,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__irq_save_i));
	vcdp->chgBus  (c+146,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__vect_tmp),2);
	vcdp->chgBus  (c+147,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__next_ex_state),5);
	vcdp->chgBit  (c+148,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__tmp_cpy));
	vcdp->chgBit  (c+149,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__inc_tmp_vector));
	vcdp->chgBit  (c+121,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__preset_irq_mask_i));
	vcdp->chgBit  (c+129,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i));
	vcdp->chgBit  (c+137,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__trap_priv_i));
	vcdp->chgBit  (c+138,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__usp_cpy_i));
	vcdp->chgBit  (c+101,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ar_wr_i));
	vcdp->chgBit  (c+96,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_tmp_inc_i));
	vcdp->chgBit  (c+100,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__ar_inc_i));
	vcdp->chgBit  (c+135,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ssp_init_i));
	vcdp->chgBit  (c+132,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sp_add_displ_i));
	vcdp->chgBit  (c+119,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i));
	vcdp->chgBit  (c+136,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__trap_aerr_i));
	vcdp->chgBus  (c+150,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_ext),32);
	vcdp->chgBus  (c+151,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__iwl_ida),2);
	vcdp->chgBus  (c+152,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_eff_tmp),32);
	vcdp->chgBus  (c+153,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__areg),32);
	vcdp->chgBus  (c+154,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__data_signed),32);
	vcdp->chgBus  (c+155,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_scaled),32);
	vcdp->chgBus  (c+156,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_eff_i),32);
	vcdp->chgBus  (c+157,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar_sel),32);
	vcdp->chgBit  (c+102,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ar_dr_exg_i));
	vcdp->chgBit  (c+109,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dr_wr_i));
	vcdp->chgBit  (c+108,((0xffff == (0xffff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_b))));
	vcdp->chgBus  (c+123,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_data_b),3);
	vcdp->chgBus  (c+124,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_data_c),3);
	vcdp->chgBus  (c+158,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_b),32);
	vcdp->chgBus  (c+98,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_dreg_c),32);
	vcdp->chgBit  (c+118,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i));
	vcdp->chgBit  (c+117,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_busy_i));
	vcdp->chgBit  (c+159,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__x_in_i));
	vcdp->chgBus  (c+160,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__temp0),5);
	vcdp->chgBus  (c+161,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__temp1),5);
	vcdp->chgBus  (c+162,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__z_0),4);
	vcdp->chgBus  (c+163,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__z_1),4);
	vcdp->chgBus  (c+164,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__s_0),4);
	vcdp->chgBus  (c+165,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__s_1),4);
	vcdp->chgBit  (c+166,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__z));
	vcdp->chgBit  (c+167,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__c_0));
	vcdp->chgBit  (c+168,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__c_1));
	vcdp->chgBit  (c+169,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__rm));
	vcdp->chgBit  (c+170,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__sm));
	vcdp->chgBit  (c+171,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__dm));
	vcdp->chgBus  (c+172,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__rm_sm_dm),3);
	vcdp->chgBus  (c+173,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__next_div_state),2);
	vcdp->chgBus  (c+174,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__op_in_s_sign),32);
	vcdp->chgBus  (c+175,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__op_in_d_sign_lo),32);
	vcdp->chgBus  (c+176,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_logop),32);
	vcdp->chgBus  (c+177,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_bcd),8);
	vcdp->chgBus  (c+178,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_intop),32);
	vcdp->chgBus  (c+179,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_special),32);
	vcdp->chgBus  (c+180,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_i_out),32);
	vcdp->chgQuad (c+181,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_ii_out),33);
	vcdp->chgBit  (c+183,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__cb_bcd));
	vcdp->chgBit  (c+184,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__op_div));
	vcdp->chgBus  (c+185,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_div_op_s),32);
	vcdp->chgBus  (c+186,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_op_d),32);
	vcdp->chgBit  (c+187,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_shift_en));
	vcdp->chgBit  (c+188,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__chk_cond));
	vcdp->chgBus  (c+189,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__i),32);
	vcdp->chgBit  (c+131,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__shifter_load_i));
	vcdp->chgBus  (c+190,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__bit_op),32);
	vcdp->chgBit  (c+38,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_6mhz)))));
	vcdp->chgBit  (c+125,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__reset_en_i));
	vcdp->chgBus  (c+18,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ud_in),16);
	vcdp->chgBit  (c+191,((1 & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_i)));
	vcdp->chgBit  (c+104,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i));
	vcdp->chgBit  (c+107,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i));
	vcdp->chgBus  (c+192,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice),3);
	vcdp->chgBus  (c+193,((0xff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr)),8);
	vcdp->chgBit  (c+23,(vlTOPp->v__DOT__uut__DOT__ff__DOT__as_n));
	vcdp->chgBus  (c+195,((0x3f & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
				       >> 0x11))),6);
	vcdp->chgBit  (c+27,((0x90 != (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					       >> 0xf)))));
	vcdp->chgBit  (c+42,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pal__DOT__vpa)))));
	vcdp->chgBit  (c+196,((0x90 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->chgBit  (c+197,((0x94 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->chgBit  (c+198,((0xac == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->chgBit  (c+199,((0x80 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->chgBit  (c+200,((0xa4 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->chgBit  (c+201,((0xa8 == (0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						>> 0xf)))));
	vcdp->chgBit  (c+202,((1 & ((~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					>> 0x16)) | 
				    (0x90 == (0xfc 
					      & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						 >> 0xf)))))));
	vcdp->chgBit  (c+203,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pal__DOT__vpa));
	vcdp->chgBus  (c+204,((0xfc & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
				       >> 0xf))),8);
	vcdp->chgBus  (c+206,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderom_h__out),8);
	vcdp->chgBus  (c+207,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderom_l__out),8);
	vcdp->chgBit  (c+43,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom0_n));
	vcdp->chgBit  (c+44,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom1_n));
	vcdp->chgBit  (c+45,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom2_n));
	vcdp->chgBit  (c+46,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom3_n));
	vcdp->chgBus  (c+208,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderam_h__out),8);
	vcdp->chgBus  (c+209,((0xff & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				       >> 8))),8);
	vcdp->chgBit  (c+210,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram0_n) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ram1_n))));
	vcdp->chgBus  (c+205,((0x1fff & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr)),13);
	vcdp->chgBus  (c+211,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__coderam_l__out),8);
	vcdp->chgBus  (c+213,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_3n_3m__out),8);
	vcdp->chgBus  (c+67,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfa),10);
	vcdp->chgBus  (c+214,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_3l_3k__out),8);
	vcdp->chgBit  (c+68,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfwr_n));
	vcdp->chgBus  (c+216,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				      >> 0xc))),4);
	vcdp->chgBus  (c+217,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6c__d),4);
	vcdp->chgBus  (c+218,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				      >> 8))),4);
	vcdp->chgBus  (c+219,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6d__d),4);
	vcdp->chgBit  (c+75,(vlTOPp->v__DOT__uut__DOT__ff__DOT__uwr_n));
	vcdp->chgBus  (c+220,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out) 
				      >> 4))),4);
	vcdp->chgBus  (c+221,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6e__d),4);
	vcdp->chgBus  (c+215,(vlTOPp->v__DOT__uut__DOT__ff__DOT__moram_addr),8);
	vcdp->chgBus  (c+222,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_6f__d),4);
	vcdp->chgBit  (c+74,(vlTOPp->v__DOT__uut__DOT__ff__DOT__lwr_n));
	vcdp->chgBus  (c+223,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4e__d),8);
	vcdp->chgBus  (c+83,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_addr),13);
	vcdp->chgBus  (c+224,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_4d__d),8);
	vcdp->chgBit  (c+225,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__evenclk)))));
	vcdp->chgBit  (c+226,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddclk)))));
	vcdp->chgBit  (c+227,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__oddcs_n)))));
	vcdp->chgBit  (c+228,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__evencs_n)))));
	vcdp->chgBus  (c+229,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_7p__d),4);
	vcdp->chgBit  (c+230,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloramwr_n)))));
	vcdp->chgBus  (c+88,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb_addr),8);
	vcdp->chgBus  (c+194,((0xf & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out))),4);
	vcdp->chgBus  (c+231,(vlTOPp->v__DOT__uut__DOT__ff__DOT____Vcellinp__chip_7n__d),4);
	vcdp->chgBit  (c+90,(vlTOPp->v__DOT__uut__DOT__ff__DOT__coloramwr_n));
	vcdp->chgBit  (c+40,(vlTOPp->v__DOT__uut__DOT__ff__DOT__audio2_n));
	vcdp->chgBus  (c+233,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__d_out),8);
	vcdp->chgBit  (c+234,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__stb));
	vcdp->chgBus  (c+236,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we),4);
	vcdp->chgBus  (c+237,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we),4);
	vcdp->chgBus  (c+238,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start),4);
	vcdp->chgBit  (c+239,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we))));
	vcdp->chgBit  (c+240,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start))));
	vcdp->chgBit  (c+241,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we) 
				    >> 1))));
	vcdp->chgBit  (c+242,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start) 
				    >> 1))));
	vcdp->chgBit  (c+243,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we) 
				    >> 2))));
	vcdp->chgBit  (c+244,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start) 
				    >> 2))));
	vcdp->chgBit  (c+245,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audf_we) 
				    >> 3))));
	vcdp->chgBit  (c+246,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start) 
				    >> 3))));
	vcdp->chgBit  (c+247,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we))));
	vcdp->chgBit  (c+248,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we) 
				    >> 1))));
	vcdp->chgBit  (c+249,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we) 
				    >> 2))));
	vcdp->chgBit  (c+235,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__start_timer));
	vcdp->chgBit  (c+250,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__audc_we) 
				    >> 3))));
	vcdp->chgBit  (c+41,(vlTOPp->v__DOT__uut__DOT__ff__DOT__audio1_n));
	vcdp->chgBus  (c+251,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__d_out),8);
	vcdp->chgBit  (c+252,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__stb));
	vcdp->chgBus  (c+254,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we),4);
	vcdp->chgBus  (c+255,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we),4);
	vcdp->chgBus  (c+256,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start),4);
	vcdp->chgBit  (c+257,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we))));
	vcdp->chgBit  (c+258,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start))));
	vcdp->chgBit  (c+259,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we) 
				    >> 1))));
	vcdp->chgBit  (c+260,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start) 
				    >> 1))));
	vcdp->chgBit  (c+261,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we) 
				    >> 2))));
	vcdp->chgBit  (c+262,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start) 
				    >> 2))));
	vcdp->chgBit  (c+263,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audf_we) 
				    >> 3))));
	vcdp->chgBit  (c+264,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start) 
				    >> 3))));
	vcdp->chgBit  (c+265,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we))));
	vcdp->chgBit  (c+266,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we) 
				    >> 1))));
	vcdp->chgBit  (c+267,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we) 
				    >> 2))));
	vcdp->chgBit  (c+253,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__start_timer));
	vcdp->chgBit  (c+268,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__audc_we) 
				    >> 3))));
	vcdp->chgBit  (c+25,(vlTOPp->v__DOT__uut__DOT__ff__DOT__audio0_n));
	vcdp->chgBus  (c+232,((0xf & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr)),4);
	vcdp->chgBit  (c+20,(vlTOPp->v__DOT__uut__DOT__ff__DOT__r_w_n));
	vcdp->chgBus  (c+29,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_out),8);
	vcdp->chgBit  (c+269,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__stb));
	vcdp->chgBus  (c+271,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we),4);
	vcdp->chgBus  (c+272,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we),4);
	vcdp->chgBus  (c+273,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start),4);
	vcdp->chgBit  (c+274,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we))));
	vcdp->chgBit  (c+275,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start))));
	vcdp->chgBit  (c+276,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we) 
				    >> 1))));
	vcdp->chgBit  (c+277,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start) 
				    >> 1))));
	vcdp->chgBit  (c+278,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we) 
				    >> 2))));
	vcdp->chgBit  (c+279,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start) 
				    >> 2))));
	vcdp->chgBit  (c+280,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audf_we) 
				    >> 3))));
	vcdp->chgBit  (c+281,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start) 
				    >> 3))));
	vcdp->chgBit  (c+282,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we))));
	vcdp->chgBit  (c+283,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we) 
				    >> 1))));
	vcdp->chgBit  (c+284,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we) 
				    >> 2))));
	vcdp->chgBit  (c+270,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__start_timer));
	vcdp->chgBus  (c+212,((0xff & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__data_out))),8);
	vcdp->chgBit  (c+285,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__audc_we) 
				    >> 3))));
    }
}

void Vff_verilator::traceChgThis__4(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+286,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip_d) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__regld))));
	vcdp->chgBit  (c+287,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip_d)) 
				    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__regld)))));
    }
}

void Vff_verilator::traceChgThis__5(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+288,(((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
			       & ((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
				  & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
				     | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_n) 
					| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_p)))))));
    }
}

void Vff_verilator::traceChgThis__6(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+289,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip) 
			       ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h))));
    }
}

void Vff_verilator::traceChgThis__7(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+290,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i) 
			       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				  >> 0xf))));
	vcdp->chgBus  (c+291,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i),32);
    }
}

void Vff_verilator::traceChgThis__8(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+293,(((((0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				& (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				      >> 0xd))) | (
						   (~ 
						    ((0x54 
						      == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
						     & (7 
							== 
							(7 
							 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))))) 
						   & ((((0x11 
							 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
							& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
						       & (~ 
							  ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
							   >> 0xd))) 
						      | (((0x13 
							   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
							  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
							 & (~ 
							    ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
							     >> 0xd))))))));
	vcdp->chgBit  (c+292,(((((0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				   >> 0xd)) | ((~ (
						   (0x54 
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
    }
}

void Vff_verilator::traceChgThis__9(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+294,(((((0x14 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 & (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				   >> 0xd)) | (((0x15 
						 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						& (0x15 
						   == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
					       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
						  >> 0xd)))));
	vcdp->chgBit  (c+295,((((((0x14 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				    >> 0xd)) | (((0x15 
						  != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						 & (0x15 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
						& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
						   >> 0xd))) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ssp_dec_irq))));
	vcdp->chgBit  (c+296,(((((0x14 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				 & (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
				& (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				      >> 0xd))) | (
						   ((0x15 
						     != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
						    & (0x15 
						       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state))) 
						   & (~ 
						      ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
						       >> 0xd))))));
    }
}

void Vff_verilator::traceChgThis__10(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+297,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i) 
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
    }
}

void Vff_verilator::traceChgThis__11(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+299,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
				& (0x52 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
			       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i) 
				  >> 1))));
	vcdp->chgBit  (c+298,((((((0x1b == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				  & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_state))) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i)) 
				& (0 == vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s)) 
			       | ((((0x1a == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				    & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_state))) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_start_i)) 
				  & (0 == vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__alu_op_in_s)))));
	vcdp->chgBus  (c+300,(((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state))
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
    }
}

void Vff_verilator::traceChgThis__12(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+301,((((0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				& ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_i) 
				   | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__trap_aerr_i))) 
			       & (((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)) 
				   | (2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))) 
				  | (1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))))));
    }
}

void Vff_verilator::traceChgThis__13(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+302,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
			       & (0xa == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						 >> 0xc))))));
	vcdp->chgBit  (c+303,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
			       & (0xf == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
						 >> 0xc))))));
    }
}

void Vff_verilator::traceChgThis__14(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+304,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__hi_byte_en_i) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__lo_byte_en_i)) 
			       | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en)) 
				  & (((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				      | (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				     | (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)))))));
    }
}

void Vff_verilator::traceChgThis__15(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+305,((1 & ((~ ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i) 
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
	vcdp->chgBit  (c+306,((1 & ((~ ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i) 
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
    }
}

void Vff_verilator::traceChgThis__16(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+307,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hload_n))));
	vcdp->chgBit  (c+308,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx)) 
				    | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hload_n)))));
    }
}

void Vff_verilator::traceChgThis__17(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+309,(((((((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_in)) 
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
    }
}

void Vff_verilator::traceChgThis__18(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+311,((((1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)) 
			       | (((2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)) 
				  | ((3 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i))))));
	vcdp->chgBit  (c+310,((((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)) 
			       | ((5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_valid_i)))));
	vcdp->chgBit  (c+312,(((((1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
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
    }
}

void Vff_verilator::traceChgThis__19(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+313,((((((0x44 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				  & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				| ((((0x45 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				     & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				   | (((0x46 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				       & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				      & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)))) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_init_irq))));
	vcdp->chgBit  (c+314,(((((0x44 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				 & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
			       | ((((0x45 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				    & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i)) 
				  | (((0x46 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				      & (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i))))));
	vcdp->chgBit  (c+315,((((((8 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				  | (0x1e == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				 | (0x3c == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
			       | (((0x2c == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				  | (((0x45 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				      & (0x12 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_cyc_rdy_i))))));
    }
}

void Vff_verilator::traceChgThis__20(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+316,(((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
				   & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
			       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
				  | ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
					| (~ (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
					       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
					      & (0 
						 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))))));
    }
}

void Vff_verilator::traceChgThis__21(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+319,((1 & ((~ ((7 == (7 & 
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
	vcdp->chgBus  (c+318,((7 & (((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
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
	vcdp->chgBit  (c+317,((1 & (~ ((7 == (7 & (
						   ((~ 
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
				       & (0x3f == (0x3f 
						   & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						      >> 0x11))))))));
	vcdp->chgBit  (c+320,(((7 == (7 & (((~ ((0 
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
			       & (0x3f == (0x3f & (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
						   >> 0x11))))));
    }
}

void Vff_verilator::traceChgThis__22(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+321,(((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)) 
			       & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i) 
				  | (~ (((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i)) 
					 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i))) 
					& (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice))))))));
    }
}

void Vff_verilator::traceChgThis__23(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+322,(((((0xf == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				 | (0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
			       | ((((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__cond)) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				  | ((((0x19 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__cond))) 
				     & (0xffff != (0xffff 
						   & vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_b)))))));
    }
}

void Vff_verilator::traceChgThis__24(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+323,((1 & (~ (((~ (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					    >> 0x16)) 
					| (0x90 == 
					   (0xfc & 
					    (vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__adr 
					     >> 0xf)))) 
				       | (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_n_v_d)))))));
    }
}

void Vff_verilator::traceChgThis__25(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+330,((((((0xd == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
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
	vcdp->chgBit  (c+331,((((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				| (0x4d == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
			        ? ((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_mode_i)) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))
			        : (((((((((((((((((
						   ((((((((((((((((((((((((((((((0 
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
					  | (0x47 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					 | (0x4a == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
					| (0x4c == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				       | (0x4e == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				      | (0x4f == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				     | (0x50 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				    | (0x53 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)))));
	vcdp->chgBit  (c+332,(((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_mode_i)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))));
	vcdp->chgBit  (c+328,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
			       & (0x22 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))));
	vcdp->chgBit  (c+329,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__scan_traps_i) 
			       & (0x51 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))));
	vcdp->chgBit  (c+325,((((0x23 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				| (0x24 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))));
	vcdp->chgBit  (c+324,(((0x19 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
			       & (0x16 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__next_exec_state)))));
	vcdp->chgBit  (c+327,(((0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i))));
	vcdp->chgBit  (c+326,((((0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__op_end_i)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__chk_cond))));
    }
}

void Vff_verilator::traceChgThis__26(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+333,(((~ ((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__t_slice)) 
				   & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in)))) 
			       & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)))));
    }
}

void Vff_verilator::traceChgThis__27(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+334,(((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_v_n)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__uds_n))));
	vcdp->chgBit  (c+335,(((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_v_n)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__lds_n))));
    }
}

void Vff_verilator::traceChgThis__28(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+336,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_4h) 
			       ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip))));
    }
}

void Vff_verilator::traceChgThis__29(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+337,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y));
	vcdp->chgBit  (c+338,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y));
    }
}

void Vff_verilator::traceChgThis__30(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+339,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
				<< 1) | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
					 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y)))),2);
	vcdp->chgBus  (c+340,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
				<< 1) | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
					 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y)))),2);
	vcdp->chgBus  (c+341,(((0xfc & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__p) 
					<< 2)) | ((
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
						    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
						   << 1) 
						  | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0) 
						     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y))))),8);
	vcdp->chgBus  (c+342,(((0xfc & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__p) 
					<< 2)) | ((
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
						    & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_2y)) 
						   << 1) 
						  | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1) 
						     & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1y))))),8);
    }
}

void Vff_verilator::traceChgThis__31(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+343,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bgack_in));
	vcdp->chgBit  (c+344,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__br_in));
    }
}

void Vff_verilator::traceChgThis__32(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+345,((0xffff & ((5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
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
    }
}

void Vff_verilator::traceChgThis__33(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+347,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_en));
	vcdp->chgBit  (c+348,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_adn_i));
	vcdp->chgBit  (c+349,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_pi_corr));
	vcdp->chgBus  (c+346,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__pc_out),32);
	vcdp->chgBit  (c+350,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__shft_en));
    }
}

void Vff_verilator::traceChgThis__34(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+351,((0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1))),5);
	vcdp->chgBit  (c+355,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				    >> 5))));
	vcdp->chgBus  (c+358,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				    >> 9))),3);
	vcdp->chgBus  (c+360,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1))),3);
	vcdp->chgBus  (c+361,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1) 
				    >> 0xc))),3);
	vcdp->chgBit  (c+362,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				    >> 3))));
	vcdp->chgBus  (c+352,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i),16);
	vcdp->chgBus  (c+359,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))),3);
	vcdp->chgBus  (c+363,((0xf & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i))),4);
	vcdp->chgBus  (c+353,((0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				      >> 8))),4);
	vcdp->chgBus  (c+357,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1),16);
	vcdp->chgBus  (c+356,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
				    >> 6))),3);
	vcdp->chgBit  (c+354,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw_1) 
				    >> 0xa))));
    }
}

void Vff_verilator::traceChgThis__35(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+365,((((((7 == (7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
					      >> 3))) 
				  & (4 == (7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i)))) 
				 & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_size_i))) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en))
			        ? 2 : ((((7 == (7 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
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
					        : (
						   (((7 
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
	vcdp->chgBus  (c+364,(((((7 == (7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
					     >> 6))) 
				 & (1 == (7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
					       >> 9)))) 
				& (0x29 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
			        ? 2 : ((((7 == (7 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
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
					        : (
						   ((5 
						     == 
						     (7 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__biw_0_i) 
							 >> 6))) 
						    & (0x29 
						       == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))
						    ? 1
						    : 0))))),2);
    }
}

void Vff_verilator::traceChgThis__36(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+366,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__src_destn_i)
				     ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__exword_reg0) 
					>> 0xc) : ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__dest_exword_reg0) 
						   >> 0xc)))),3);
    }
}

void Vff_verilator::traceChgThis__37(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+367,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en));
	vcdp->chgBit  (c+368,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en));
	vcdp->chgBit  (c+369,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en));
	vcdp->chgBit  (c+370,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en));
	vcdp->chgBit  (c+371,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en));
    }
}

void Vff_verilator::traceChgThis__38(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+372,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en)) 
			       & (((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				   | (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
				  | (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))))));
    }
}

void Vff_verilator::traceChgThis__39(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+374,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_in));
	vcdp->chgBus  (c+375,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ipl_in),3);
	vcdp->chgBus  (c+376,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ipl_tmpn),3);
	vcdp->chgBus  (c+377,((7 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ipl_in)))),3);
	vcdp->chgBit  (c+373,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__avec_in));
    }
}

void Vff_verilator::traceChgThis__40(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+381,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__wr_bus_i));
	vcdp->chgBus  (c+378,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__iw_adr_i),2);
	vcdp->chgBit  (c+380,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__use_sp_adr_i));
	vcdp->chgBit  (c+379,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_b_lo_i));
    }
}

void Vff_verilator::traceChgThis__41(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+382,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__rd_bus_i) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__wr_bus_i))));
    }
}

void Vff_verilator::traceChgThis__42(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+383,(vlTOPp->v__DOT__uut__DOT__ff__DOT__bg));
    }
}

void Vff_verilator::traceChgThis__43(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+384,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__cond));
    }
}

void Vff_verilator::traceChgThis__44(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+385,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il4_n)))));
	vcdp->chgBit  (c+386,(vlTOPp->v__DOT__uut__DOT__ff__DOT__il4_n));
    }
}

void Vff_verilator::traceChgThis__45(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+387,((4 | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il4_n) 
				     << 1) | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il3_n)))),3);
    }
}

void Vff_verilator::traceChgThis__46(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+388,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_32v));
	vcdp->chgBit  (c+389,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_128v));
    }
}

void Vff_verilator::traceChgThis__47(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+390,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x1));
	vcdp->chgBit  (c+391,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_x0));
    }
}

void Vff_verilator::traceChgThis__48(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+393,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bitpos_im_i));
	vcdp->chgBus  (c+401,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_mode_i))),3);
	vcdp->chgBit  (c+396,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__mem_shft_i));
	vcdp->chgBit  (c+402,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__ext_en));
	vcdp->chgBit  (c+394,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__dr_i));
	vcdp->chgBit  (c+395,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__force_biw2_i));
	vcdp->chgBit  (c+400,(((((((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)) 
				   | (0xf == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				  | (0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				 | (0x19 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
				| (0x31 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i))) 
			       | (0x26 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i)))));
	vcdp->chgBus  (c+398,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__op_mode_i),5);
	vcdp->chgBus  (c+392,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__adr_mode_i),3);
	vcdp->chgBus  (c+397,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_i),7);
	vcdp->chgBus  (c+399,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__op_size_i),2);
    }
}

void Vff_verilator::traceChgThis__49(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+403,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__reset_in_in));
	vcdp->chgBit  (c+404,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__vpa_in));
    }
}

void Vff_verilator::traceChgThis__50(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+405,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irq));
	vcdp->chgBus  (c+406,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__ctr_out),32);
	vcdp->chgBus  (c+407,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow),4);
	vcdp->chgBit  (c+408,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__base));
	vcdp->chgBus  (c+409,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_done),8);
	vcdp->chgBit  (c+410,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__new_bit));
	vcdp->chgBit  (c+411,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow))));
	vcdp->chgBit  (c+412,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				    >> 2))));
	vcdp->chgBit  (c+413,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__no_poly5) 
				       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly5__DOT__shift) 
					  >> 4))))));
	vcdp->chgBit  (c+414,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				    >> 1))));
	vcdp->chgBit  (c+415,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				    >> 3))));
	vcdp->chgBit  (c+416,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     >> 1) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__no_poly5) 
					      | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift))))));
	vcdp->chgBit  (c+417,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__no_poly5) 
					      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
						 >> 1))))));
	vcdp->chgBit  (c+418,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__borrow) 
				     >> 3) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__no_poly5) 
					      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
						 >> 2))))));
	vcdp->chgBit  (c+419,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irq));
	vcdp->chgBus  (c+420,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__ctr_out),32);
	vcdp->chgBus  (c+421,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow),4);
	vcdp->chgBit  (c+422,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__base));
	vcdp->chgBus  (c+423,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_done),8);
	vcdp->chgBit  (c+424,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__new_bit));
	vcdp->chgBit  (c+425,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow))));
	vcdp->chgBit  (c+426,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				    >> 2))));
	vcdp->chgBit  (c+427,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__no_poly5) 
				       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly5__DOT__shift) 
					  >> 4))))));
	vcdp->chgBit  (c+428,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				    >> 1))));
	vcdp->chgBit  (c+429,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				    >> 3))));
	vcdp->chgBit  (c+430,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     >> 1) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__no_poly5) 
					      | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift))))));
	vcdp->chgBit  (c+431,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__no_poly5) 
					      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
						 >> 1))))));
	vcdp->chgBit  (c+432,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__borrow) 
				     >> 3) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__no_poly5) 
					      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
						 >> 2))))));
	vcdp->chgBit  (c+433,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irq));
	vcdp->chgBus  (c+434,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__ctr_out),32);
	vcdp->chgBus  (c+435,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow),4);
	vcdp->chgBit  (c+436,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__base));
	vcdp->chgBus  (c+437,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_done),8);
	vcdp->chgBit  (c+438,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__new_bit));
	vcdp->chgBit  (c+439,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow))));
	vcdp->chgBit  (c+440,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				    >> 2))));
	vcdp->chgBit  (c+441,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				    & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__no_poly5) 
				       | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly5__DOT__shift) 
					  >> 4))))));
	vcdp->chgBit  (c+442,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				    >> 1))));
	vcdp->chgBit  (c+443,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				    >> 3))));
	vcdp->chgBit  (c+444,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     >> 1) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__no_poly5) 
					      | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift))))));
	vcdp->chgBit  (c+445,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     >> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__no_poly5) 
					      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
						 >> 1))))));
	vcdp->chgBit  (c+446,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__borrow) 
				     >> 3) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__no_poly5) 
					      | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
						 >> 2))))));
    }
}

void Vff_verilator::traceChgThis__51(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+456,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__unlk_sp_an_i));
	vcdp->chgBit  (c+457,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__got_ext));
	vcdp->chgBit  (c+458,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__got_dest_ext));
	vcdp->chgBit  (c+459,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__movem_cpy));
	vcdp->chgBit  (c+455,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__src_destn_i));
	vcdp->chgBus  (c+448,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ext_dsize_i),2);
	vcdp->chgBus  (c+460,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_mode_i),3);
	vcdp->chgBit  (c+461,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i_d_a));
	vcdp->chgBit  (c+462,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i_w_l));
	vcdp->chgBus  (c+463,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__i_scale),2);
	vcdp->chgBus  (c+449,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_adr_a),3);
	vcdp->chgBus  (c+450,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_adr_b),3);
	vcdp->chgBit  (c+464,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__n_flag));
	vcdp->chgBit  (c+465,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__z_flag));
	vcdp->chgBit  (c+452,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_hi));
	vcdp->chgBit  (c+453,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_midhi));
	vcdp->chgBit  (c+454,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_midlo));
	vcdp->chgBit  (c+451,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_a_lo));
	vcdp->chgBus  (c+466,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__next_arb_state),2);
	vcdp->chgBit  (c+447,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vma));
    }
}

void Vff_verilator::traceChgThis__52(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+468,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_lo_irq_i));
	vcdp->chgBit  (c+469,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_hi_irq_i));
	vcdp->chgBit  (c+471,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__wr_bus_i));
	vcdp->chgBit  (c+467,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ctrl_en_i));
	vcdp->chgBit  (c+470,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__use_ssp_adr_i));
    }
}

void Vff_verilator::traceChgThis__53(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+472,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__il3_n)))));
	vcdp->chgBit  (c+473,(vlTOPp->v__DOT__uut__DOT__ff__DOT__il3_n));
    }
}

void Vff_verilator::traceChgThis__54(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+474,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_immediate_i),32);
	vcdp->chgBit  (c+476,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__force_biw3_i));
	vcdp->chgBus  (c+475,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__displace_biw_i),32);
	vcdp->chgBus  (c+478,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc_offset),4);
	vcdp->chgBus  (c+477,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__regsel_data_a),3);
    }
}

void Vff_verilator::traceChgThis__55(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+479,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en),4);
	vcdp->chgBit  (c+480,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en))));
	vcdp->chgBit  (c+481,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en) 
				    >> 1))));
	vcdp->chgBit  (c+482,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en) 
				    >> 2))));
	vcdp->chgBit  (c+483,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__cnt_en) 
				    >> 3))));
	vcdp->chgBus  (c+484,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en),4);
	vcdp->chgBit  (c+485,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en))));
	vcdp->chgBit  (c+486,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en) 
				    >> 1))));
	vcdp->chgBit  (c+487,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en) 
				    >> 2))));
	vcdp->chgBit  (c+488,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__cnt_en) 
				    >> 3))));
	vcdp->chgBus  (c+489,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en),4);
	vcdp->chgBit  (c+490,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en))));
	vcdp->chgBit  (c+491,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en) 
				    >> 1))));
	vcdp->chgBit  (c+492,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en) 
				    >> 2))));
	vcdp->chgBit  (c+493,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__cnt_en) 
				    >> 3))));
    }
}

void Vff_verilator::traceChgThis__56(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+494,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bit_pos_i),5);
	vcdp->chgBus  (c+495,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__cnt_nr_i),6);
	vcdp->chgBus  (c+496,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_areg_a),32);
	vcdp->chgBus  (c+497,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_areg_b),32);
	vcdp->chgBus  (c+498,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__q_dreg_a),32);
	vcdp->chgBus  (c+499,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__displace),32);
	vcdp->chgBus  (c+500,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__displ_ext),32);
	vcdp->chgBus  (c+501,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__abs_address),32);
	vcdp->chgBus  (c+502,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar_step),3);
	vcdp->chgBus  (c+503,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr_sel_a),32);
    }
}

void Vff_verilator::traceChgThis__57(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+505,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_ctrl),3);
	vcdp->chgBit  (c+507,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rd_bus_i));
	vcdp->chgBit  (c+508,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_lo_i));
	vcdp->chgBit  (c+509,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sel_buf_a_hi_i));
	vcdp->chgBit  (c+510,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__sys_init_i));
	vcdp->chgBit  (c+506,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__rd_bus_i));
	vcdp->chgBit  (c+504,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__rwn_i));
    }
}

void Vff_verilator::traceChgThis__58(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+511,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__fc_out_i),3);
    }
}

void Vff_verilator::traceChgThis__59(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+512,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__berr_i));
    }
}

void Vff_verilator::traceChgThis__60(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+514,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_new)))),32);
	vcdp->chgBit  (c+513,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_new));
	vcdp->chgBus  (c+515,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h),12);
	vcdp->chgBit  (c+516,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
				< 0x100) | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
					    > 0x4ff))));
	vcdp->chgBit  (c+517,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
				>= 0x100) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
					     <= 0x4ff))));
	vcdp->chgBit  (c+518,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
				>= 0x40) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cnt_h) 
					    <= 0x80))));
	vcdp->chgBus  (c+519,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_shift),16);
	vcdp->chgBit  (c+520,(vlTOPp->v__DOT__uut__DOT__ff__DOT__stamp_active_d));
	vcdp->chgBus  (c+521,(vlTOPp->v__DOT__uut__DOT__ff__DOT__stamp_active_cnt),4);
    }
}

void Vff_verilator::traceChgThis__61(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+522,(vlTOPp->v__DOT__uut__DOT__ff__DOT__p),8);
	vcdp->chgBit  (c+523,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip_d));
    }
}

void Vff_verilator::traceChgThis__62(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+524,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync));
	vcdp->chgBus  (c+525,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift),8);
	vcdp->chgBus  (c+526,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_addr_hold),8);
	vcdp->chgBus  (c+527,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rom_addr_hold_d),8);
	vcdp->chgBus  (c+528,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ov),8);
	vcdp->chgBit  (c+529,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en_n));
	vcdp->chgBit  (c+530,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en_n));
	vcdp->chgBit  (c+531,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en_n));
	vcdp->chgBit  (c+532,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en_n));
	vcdp->chgBit  (c+533,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_n));
	vcdp->chgBit  (c+534,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_n));
	vcdp->chgBit  (c+535,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en_n));
    }
}

void Vff_verilator::traceChgThis__63(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+536,((1 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_n) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_p))))));
	vcdp->chgBit  (c+537,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_n) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_p))));
    }
}

void Vff_verilator::traceChgThis__64(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+538,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync) 
			       ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync))));
    }
}

void Vff_verilator::traceChgThis__65(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+539,((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfv_hold) 
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
    }
}

void Vff_verilator::traceChgThis__66(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+540,(((2 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift)
				       : ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
					  >> 3)) << 1)) 
			       | (1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)
				        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
					   >> 4) : 
				       ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_shift) 
					>> 7))))),2);
    }
}

void Vff_verilator::traceChgThis__67(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+542,(((0xc0 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb)) 
			       | ((0x18 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb) 
					   >> 1)) | 
				  (7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb))))),32);
	vcdp->chgBus  (c+543,((6 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb) 
				    >> 5))),3);
	vcdp->chgBus  (c+544,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb) 
				    >> 3))),3);
	vcdp->chgBus  (c+545,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb))),3);
	vcdp->chgBus  (c+541,(vlTOPp->v__DOT__uut__DOT__ff__DOT__rgb),8);
    }
}

void Vff_verilator::traceChgThis__68(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+546,(vlTOPp->v__DOT__uut__DOT__ff__DOT__membufen_n));
	vcdp->chgBus  (c+547,(((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip) 
				 << 3) | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip) 
					   << 2) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip) 
					    << 1) | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip)))) 
			       ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__ol_hold))),4);
	vcdp->chgBus  (c+548,(vlTOPp->v__DOT__uut__DOT__ff__DOT__ol_hold),4);
	vcdp->chgBit  (c+549,(vlTOPp->v__DOT__uut__DOT__ff__DOT__match));
	vcdp->chgBit  (c+550,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vflip));
	vcdp->chgBit  (c+551,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hflip));
	vcdp->chgBus  (c+552,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mv_addr_hold),8);
	vcdp->chgBus  (c+553,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem),10);
	vcdp->chgBus  (c+554,(((0x8000 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
					  << 6)) | 
			       ((0x2000 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
					   << 5)) | 
				((0x700 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem) 
					   << 3)) | 
				 (0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__sr_mem)))))),16);
	vcdp->chgBit  (c+555,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__rwn_tmp));
	vcdp->chgBus  (c+556,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__fc_tmp),3);
	vcdp->chgBus  (c+557,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__adr_tmp),32);
	vcdp->chgBit  (c+558,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_rd_en_p));
	vcdp->chgBit  (c+559,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_rd_en_p));
	vcdp->chgBit  (c+560,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__uds_wr_en_p));
	vcdp->chgBit  (c+561,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__lds_wr_en_p));
	vcdp->chgBit  (c+562,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__as_enab_p));
	vcdp->chgBit  (c+563,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__adr_en_p));
	vcdp->chgBit  (c+564,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__data_en_p));
	vcdp->chgBit  (c+565,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__wr_enab_p));
    }
}

void Vff_verilator::traceChgThis__69(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+570,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__int_vect_i),10);
	vcdp->chgBit  (c+572,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__movem_adn_i));
	vcdp->chgBus  (c+573,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__movem_regsel_i),3);
	vcdp->chgBit  (c+579,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__chk_adr_strb_lock));
	vcdp->chgBit  (c+580,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__predec_ctrl_lock));
	vcdp->chgBus  (c+581,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__sreg_mem),10);
	vcdp->chgBus  (c+582,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__sreg_mem_tmp),10);
	vcdp->chgBus  (c+583,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__bit_pnt_r),5);
	vcdp->chgBus  (c+584,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__regsel_tmp_r),3);
	vcdp->chgBus  (c+585,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg),16);
	vcdp->chgBit  (c+586,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__traplock));
	vcdp->chgBus  (c+577,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i),16);
	vcdp->chgBus  (c+571,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__irq_exhdl),3);
	vcdp->chgBus  (c+587,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__vector_no),8);
	vcdp->chgBus  (c+588,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q),4);
	vcdp->chgBit  (c+589,((((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)) 
				| (2 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q))) 
			       | (1 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__exception_q)))));
	vcdp->chgBit  (c+590,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_reset));
	vcdp->chgBit  (c+591,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_adr_err));
	vcdp->chgBit  (c+592,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_bus_err));
	vcdp->chgBit  (c+593,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_trace));
	vcdp->chgBit  (c+569,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_int));
	vcdp->chgBit  (c+594,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_illegal));
	vcdp->chgBit  (c+595,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_1010));
	vcdp->chgBit  (c+596,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_1111));
	vcdp->chgBit  (c+597,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_priv));
	vcdp->chgBit  (c+598,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_trap));
	vcdp->chgBit  (c+599,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_trapv));
	vcdp->chgBit  (c+600,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_chk));
	vcdp->chgBit  (c+601,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_p_divzero));
	vcdp->chgBus  (c+602,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__vect_tmp_r),2);
	vcdp->chgBit  (c+603,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i) 
				    >> 1))));
	vcdp->chgBit  (c+566,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__ar_dec_i));
	vcdp->chgBit  (c+574,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__status_reg) 
				    >> 0xd))));
	vcdp->chgBit  (c+568,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__chk_pc_i));
	vcdp->chgBit  (c+567,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__chk_adr_i));
	vcdp->chgBus  (c+604,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__index_tmp),32);
	vcdp->chgBus  (c+605,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc_tmpvar),4);
	vcdp->chgBus  (c+606,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[0]),32);
	vcdp->chgBus  (c+607,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[1]),32);
	vcdp->chgBus  (c+608,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[2]),32);
	vcdp->chgBus  (c+609,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[3]),32);
	vcdp->chgBus  (c+610,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[4]),32);
	vcdp->chgBus  (c+611,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[5]),32);
	vcdp->chgBus  (c+612,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ar[6]),32);
	vcdp->chgBus  (c+578,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__usp),32);
	vcdp->chgBus  (c+576,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__ssp),32);
	vcdp->chgBus  (c+613,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc),32);
	vcdp->chgBus  (c+614,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__areg_tmp),32);
	vcdp->chgBus  (c+615,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__adr_tmp),6);
	vcdp->chgBus  (c+616,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_adrreg__DOT__pc_tmpvar) 
			       << 1)),5);
	vcdp->chgBus  (c+617,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[0]),32);
	vcdp->chgBus  (c+618,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[1]),32);
	vcdp->chgBus  (c+619,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[2]),32);
	vcdp->chgBus  (c+620,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[3]),32);
	vcdp->chgBus  (c+621,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[4]),32);
	vcdp->chgBus  (c+622,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[5]),32);
	vcdp->chgBus  (c+623,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[6]),32);
	vcdp->chgBus  (c+624,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__dr[7]),32);
	vcdp->chgBus  (c+625,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_datareg__DOT__i),32);
	vcdp->chgBus  (c+626,((0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__status_reg_i))),5);
	vcdp->chgQuad (c+627,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_result_var),33);
	vcdp->chgBus  (c+629,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state),2);
	vcdp->chgBus  (c+630,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_state),2);
	vcdp->chgBus  (c+631,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_i),32);
	vcdp->chgQuad (c+632,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__result_ii),33);
	vcdp->chgQuad (c+634,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__divisor),64);
	vcdp->chgQuad (c+636,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__dividend),64);
	vcdp->chgBit  (c+638,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__ov_div_mul));
	vcdp->chgBus  (c+639,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_cyc_cnt),6);
	vcdp->chgBit  (c+640,(((0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_cyc_cnt)) 
			       | (0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__mul_state)))));
	vcdp->chgBus  (c+641,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_alu__DOT__div_var),32);
	vcdp->chgBit  (c+575,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__shft_busy_i));
	vcdp->chgBus  (c+642,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__bit_cnt),6);
	vcdp->chgBit  (c+643,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__v_flag));
	vcdp->chgBit  (c+644,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__c_flag));
	vcdp->chgBit  (c+645,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__shift_state));
	vcdp->chgBus  (c+646,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__shft_op),32);
	vcdp->chgBit  (c+647,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_shft__DOT__x_flag));
	vcdp->chgBus  (c+648,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__slice_cnt),2);
    }
}

void Vff_verilator::traceChgThis__70(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+649,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_buffer_a),32);
	vcdp->chgBus  (c+650,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__bus_buffer_b),32);
	vcdp->chgBus  (c+651,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_core),16);
	vcdp->chgBus  (c+656,((0xff & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__data_core))),8);
	vcdp->chgBus  (c+657,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw[0]),16);
	vcdp->chgBus  (c+658,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw[1]),16);
	vcdp->chgBus  (c+659,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__biw[2]),16);
	vcdp->chgBus  (c+654,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__exword_reg0),16);
	vcdp->chgBus  (c+655,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__exword_reg1),16);
	vcdp->chgBus  (c+652,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__dest_exword_reg0),16);
	vcdp->chgBus  (c+653,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_opcode__DOT__dest_exword_reg1),16);
    }
}

void Vff_verilator::traceChgThis__71(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+661,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync)))),32);
	vcdp->chgBit  (c+662,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vblank));
	vcdp->chgBit  (c+660,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync));
	vcdp->chgBit  (c+663,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vpreset_n));
	vcdp->chgBit  (c+664,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vblank_n));
	vcdp->chgBit  (c+665,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vsync_n));
	vcdp->chgBit  (c+666,(vlTOPp->v__DOT__uut__DOT__ff__DOT__vpreset));
    }
}

void Vff_verilator::traceChgThis__72(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+667,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_odd__DOT__d),8);
    }
}

void Vff_verilator::traceChgThis__73(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+668,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx_n)
			        ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_even__DOT__d)
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_odd__DOT__d))),8);
    }
}

void Vff_verilator::traceChgThis__74(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+669,(vlTOPp->v__DOT__uut__DOT__ff__DOT__line_ram_even__DOT__d),8);
    }
}

void Vff_verilator::traceChgThis__75(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+672,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__waitstates));
	vcdp->chgBit  (c+670,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx));
	vcdp->chgBit  (c+671,(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx_n));
    }
}

void Vff_verilator::traceChgThis__76(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+673,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx)) 
				    | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				       >> 9)))));
	vcdp->chgBit  (c+674,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__s_1vx) 
				    | ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				       >> 9)))));
    }
}

void Vff_verilator::traceChgThis__77(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+678,(((6 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
			       | ((7 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				  | (0x13 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))))));
	vcdp->chgBit  (c+679,(((8 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
			       | (0x11 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)))));
	vcdp->chgBit  (c+683,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exword_counter_lock));
	vcdp->chgBus  (c+684,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__src_tmp),2);
	vcdp->chgBus  (c+685,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__dest_tmp),2);
	vcdp->chgBus  (c+686,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state),5);
	vcdp->chgBit  (c+676,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__ew_adr_i));
	vcdp->chgBit  (c+675,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))));
	vcdp->chgBit  (c+680,((0xb == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))));
	vcdp->chgBit  (c+681,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__tas_lock_i));
	vcdp->chgBit  (c+682,((((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)) 
				| (0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state))) 
			       | (0x14 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_ctrl__DOT__exec_state)))));
	vcdp->chgBus  (c+687,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_filter),4);
	vcdp->chgBit  (c+677,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_cpu_in));
    }
}

void Vff_verilator::traceChgThis__78(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+688,(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_clr_n));
	vcdp->chgBit  (c+689,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__hsync_clr_n)))));
    }
}

void Vff_verilator::traceChgThis__79(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+690,(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_n_v_d));
    }
}

void Vff_verilator::traceChgThis__80(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+691,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mv_addr_odd),8);
    }
}

void Vff_verilator::traceChgThis__81(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+692,(vlTOPp->v__DOT__uut__DOT__ff__DOT__mv_addr_even),8);
    }
}

void Vff_verilator::traceChgThis__82(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+695,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__e_timer),4);
	vcdp->chgBit  (c+694,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__vma_in));
	vcdp->chgBit  (c+696,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__syncn));
	vcdp->chgBit  (c+693,(vlTOPp->v__DOT__uut__DOT__ff__DOT__e));
    }
}

void Vff_verilator::traceChgThis__83(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+697,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__vma_in) 
				     & (0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state)))
				     ? 1 : 0))));
    }
}

void Vff_verilator::traceChgThis__84(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+698,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v),8);
	vcdp->chgBit  (c+699,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v))));
	vcdp->chgBit  (c+700,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				    >> 1))));
	vcdp->chgBit  (c+701,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				    >> 2))));
	vcdp->chgBit  (c+702,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				    >> 3))));
	vcdp->chgBit  (c+703,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				    >> 4))));
	vcdp->chgBit  (c+704,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				    >> 6))));
    }
}

void Vff_verilator::traceChgThis__85(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+705,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 2) ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)))));
	vcdp->chgBit  (c+706,((1 & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				     >> 1) ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)))));
	vcdp->chgBit  (c+707,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_v) 
				    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)))));
    }
}

void Vff_verilator::traceChgThis__86(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+709,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state))));
	vcdp->chgBit  (c+708,((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state))));
	vcdp->chgBus  (c+710,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__arb_state),2);
    }
}

void Vff_verilator::traceChgThis__87(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+711,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__halt_in));
    }
}

void Vff_verilator::traceChgThis__88(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+712,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h),12);
	vcdp->chgBit  (c+713,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				    >> 1))));
	vcdp->chgBit  (c+714,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				    >> 2))));
	vcdp->chgBit  (c+715,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				    >> 5))));
	vcdp->chgBit  (c+716,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				    >> 7))));
	vcdp->chgBit  (c+717,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				    >> 8))));
	vcdp->chgBit  (c+718,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				    >> 9))));
	vcdp->chgBit  (c+719,((1 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
				       >> 2)))));
    }
}

void Vff_verilator::traceChgThis__89(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+720,((1 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip)) 
				    | (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
					>> 2) & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__counter_h) 
						 >> 1))))));
    }
}

void Vff_verilator::traceChgThis__90(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+721,((1 & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
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
	vcdp->chgBus  (c+722,((0x3f & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
						    : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol)
						  : 0)) 
					 + (0xf & (
						   (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
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
						  : 0))))),6);
	vcdp->chgBus  (c+723,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serout),8);
	vcdp->chgBit  (c+724,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serout_rdy_o));
	vcdp->chgBit  (c+725,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__serin_ack_o));
	vcdp->chgBit  (c+726,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_key_pressed));
	vcdp->chgBit  (c+727,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_key_break));
	vcdp->chgBit  (c+728,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_serin_rdy_i));
	vcdp->chgBit  (c+729,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__last_serout_ack_i));
	vcdp->chgBus  (c+731,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
					    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
					 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf)) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+732,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
					    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))
					 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf)) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+733,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__nf) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+734,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__nf) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+735,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__rst_bits),2);
	vcdp->chgBus  (c+736,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irqen),8);
	vcdp->chgBus  (c+737,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__irqst),8);
	vcdp->chgBit  (c+738,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly9));
	vcdp->chgBit  (c+739,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fast_ch0));
	vcdp->chgBit  (c+740,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fast_ch2));
	vcdp->chgBit  (c+741,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__ch01));
	vcdp->chgBit  (c+742,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__ch23));
	vcdp->chgBit  (c+743,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02));
	vcdp->chgBit  (c+744,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13));
	vcdp->chgBit  (c+745,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__base15));
	vcdp->chgBus  (c+749,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift),3);
	vcdp->chgBus  (c+750,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift),3);
	vcdp->chgBus  (c+751,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift),3);
	vcdp->chgBus  (c+752,((0xff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__shift 
				       >> 9))),8);
	vcdp->chgBus  (c+753,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[0]),8);
	vcdp->chgBus  (c+754,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[1]),8);
	vcdp->chgBus  (c+755,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[2]),8);
	vcdp->chgBus  (c+756,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[3]),8);
	vcdp->chgBus  (c+757,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[4]),8);
	vcdp->chgBus  (c+758,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[5]),8);
	vcdp->chgBus  (c+759,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[6]),8);
	vcdp->chgBus  (c+760,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_cntr[7]),8);
	vcdp->chgBus  (c+761,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__pot_count),8);
	vcdp->chgBus  (c+762,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_base__DOT__div57),6);
	vcdp->chgBus  (c+763,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_base__DOT__div4),2);
	vcdp->chgBus  (c+764,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly4__DOT__shift),4);
	vcdp->chgBus  (c+765,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly5__DOT__shift),5);
	vcdp->chgBit  (c+730,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__rst_bits))));
	vcdp->chgBus  (c+766,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__shift),17);
	vcdp->chgBit  (c+767,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__last_short));
	vcdp->chgBus  (c+768,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6),8);
	vcdp->chgBit  (c+769,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6))));
	vcdp->chgBus  (c+770,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr0__DOT__freq),8);
	vcdp->chgBus  (c+771,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6),8);
	vcdp->chgBit  (c+772,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6))));
	vcdp->chgBus  (c+773,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr1__DOT__freq),8);
	vcdp->chgBus  (c+774,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6),8);
	vcdp->chgBit  (c+775,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6))));
	vcdp->chgBus  (c+776,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr2__DOT__freq),8);
	vcdp->chgBus  (c+777,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6),8);
	vcdp->chgBit  (c+778,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6))));
	vcdp->chgBus  (c+779,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_ctr3__DOT__freq),8);
	vcdp->chgBit  (c+746,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly4__DOT__shift) 
				    >> 3))));
	vcdp->chgBit  (c+747,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly5__DOT__shift) 
				    >> 4))));
	vcdp->chgBit  (c+748,((1 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_poly17__DOT__shift 
				    >> 0x10))));
	vcdp->chgBit  (c+780,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi02)
			        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
				   ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf))));
	vcdp->chgBit  (c+781,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol_only));
	vcdp->chgBus  (c+782,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__vol),4);
	vcdp->chgBit  (c+783,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__no_poly5));
	vcdp->chgBit  (c+784,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__poly4_sel));
	vcdp->chgBit  (c+785,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__no_poly17_4));
	vcdp->chgBit  (c+786,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__nf));
	vcdp->chgBit  (c+787,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout0__DOT__filter_reg));
	vcdp->chgBit  (c+788,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift))));
	vcdp->chgBit  (c+789,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift))));
	vcdp->chgBit  (c+790,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift))));
	vcdp->chgBit  (c+791,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__fi13)
			        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
				   ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf))));
	vcdp->chgBit  (c+792,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol_only));
	vcdp->chgBus  (c+793,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__vol),4);
	vcdp->chgBit  (c+794,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__no_poly5));
	vcdp->chgBit  (c+795,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__poly4_sel));
	vcdp->chgBit  (c+796,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__no_poly17_4));
	vcdp->chgBit  (c+797,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__nf));
	vcdp->chgBit  (c+798,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout1__DOT__filter_reg));
	vcdp->chgBit  (c+799,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift) 
				    >> 1))));
	vcdp->chgBit  (c+800,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
				    >> 1))));
	vcdp->chgBit  (c+801,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift) 
				    >> 1))));
	vcdp->chgBit  (c+802,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__nf));
	vcdp->chgBit  (c+803,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol_only));
	vcdp->chgBus  (c+804,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__vol),4);
	vcdp->chgBit  (c+805,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__no_poly5));
	vcdp->chgBit  (c+806,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__poly4_sel));
	vcdp->chgBit  (c+807,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__no_poly17_4));
	vcdp->chgBit  (c+808,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout2__DOT__filter_reg));
	vcdp->chgBit  (c+809,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly4_shift) 
				    >> 2))));
	vcdp->chgBit  (c+810,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly5_shift) 
				    >> 2))));
	vcdp->chgBit  (c+811,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__poly17_shift) 
				    >> 2))));
	vcdp->chgBit  (c+812,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__nf));
	vcdp->chgBit  (c+813,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol_only));
	vcdp->chgBus  (c+814,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__vol),4);
	vcdp->chgBit  (c+815,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__no_poly5));
	vcdp->chgBit  (c+816,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__poly4_sel));
	vcdp->chgBit  (c+817,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__no_poly17_4));
	vcdp->chgBit  (c+818,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_2__DOT__pokey__DOT__u_audout3__DOT__filter_reg));
	vcdp->chgBit  (c+819,((1 & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
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
	vcdp->chgBus  (c+820,((0x3f & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
						    : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol)
						  : 0)) 
					 + (0xf & (
						   (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
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
						  : 0))))),6);
	vcdp->chgBus  (c+821,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serout),8);
	vcdp->chgBit  (c+822,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serout_rdy_o));
	vcdp->chgBit  (c+823,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__serin_ack_o));
	vcdp->chgBit  (c+824,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_key_pressed));
	vcdp->chgBit  (c+825,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_key_break));
	vcdp->chgBit  (c+826,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_serin_rdy_i));
	vcdp->chgBit  (c+827,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__last_serout_ack_i));
	vcdp->chgBus  (c+829,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
					    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
					 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf)) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+830,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
					    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))
					 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf)) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+831,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__nf) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+832,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__nf) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+833,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__rst_bits),2);
	vcdp->chgBus  (c+834,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irqen),8);
	vcdp->chgBus  (c+835,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__irqst),8);
	vcdp->chgBit  (c+836,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly9));
	vcdp->chgBit  (c+837,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fast_ch0));
	vcdp->chgBit  (c+838,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fast_ch2));
	vcdp->chgBit  (c+839,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__ch01));
	vcdp->chgBit  (c+840,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__ch23));
	vcdp->chgBit  (c+841,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02));
	vcdp->chgBit  (c+842,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13));
	vcdp->chgBit  (c+843,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__base15));
	vcdp->chgBus  (c+847,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift),3);
	vcdp->chgBus  (c+848,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift),3);
	vcdp->chgBus  (c+849,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift),3);
	vcdp->chgBus  (c+850,((0xff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__shift 
				       >> 9))),8);
	vcdp->chgBus  (c+851,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[0]),8);
	vcdp->chgBus  (c+852,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[1]),8);
	vcdp->chgBus  (c+853,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[2]),8);
	vcdp->chgBus  (c+854,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[3]),8);
	vcdp->chgBus  (c+855,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[4]),8);
	vcdp->chgBus  (c+856,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[5]),8);
	vcdp->chgBus  (c+857,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[6]),8);
	vcdp->chgBus  (c+858,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_cntr[7]),8);
	vcdp->chgBus  (c+859,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__pot_count),8);
	vcdp->chgBus  (c+860,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_base__DOT__div57),6);
	vcdp->chgBus  (c+861,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_base__DOT__div4),2);
	vcdp->chgBus  (c+862,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly4__DOT__shift),4);
	vcdp->chgBus  (c+863,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly5__DOT__shift),5);
	vcdp->chgBit  (c+828,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__rst_bits))));
	vcdp->chgBus  (c+864,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__shift),17);
	vcdp->chgBit  (c+865,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__last_short));
	vcdp->chgBus  (c+866,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6),8);
	vcdp->chgBit  (c+867,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6))));
	vcdp->chgBus  (c+868,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr0__DOT__freq),8);
	vcdp->chgBus  (c+869,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6),8);
	vcdp->chgBit  (c+870,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6))));
	vcdp->chgBus  (c+871,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr1__DOT__freq),8);
	vcdp->chgBus  (c+872,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6),8);
	vcdp->chgBit  (c+873,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6))));
	vcdp->chgBus  (c+874,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr2__DOT__freq),8);
	vcdp->chgBus  (c+875,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6),8);
	vcdp->chgBit  (c+876,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6))));
	vcdp->chgBus  (c+877,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_ctr3__DOT__freq),8);
	vcdp->chgBit  (c+844,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly4__DOT__shift) 
				    >> 3))));
	vcdp->chgBit  (c+845,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly5__DOT__shift) 
				    >> 4))));
	vcdp->chgBit  (c+846,((1 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_poly17__DOT__shift 
				    >> 0x10))));
	vcdp->chgBit  (c+878,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi02)
			        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
				   ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf))));
	vcdp->chgBit  (c+879,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol_only));
	vcdp->chgBus  (c+880,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__vol),4);
	vcdp->chgBit  (c+881,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__no_poly5));
	vcdp->chgBit  (c+882,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__poly4_sel));
	vcdp->chgBit  (c+883,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__no_poly17_4));
	vcdp->chgBit  (c+884,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__nf));
	vcdp->chgBit  (c+885,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout0__DOT__filter_reg));
	vcdp->chgBit  (c+886,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift))));
	vcdp->chgBit  (c+887,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift))));
	vcdp->chgBit  (c+888,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift))));
	vcdp->chgBit  (c+889,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__fi13)
			        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
				   ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf))));
	vcdp->chgBit  (c+890,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol_only));
	vcdp->chgBus  (c+891,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__vol),4);
	vcdp->chgBit  (c+892,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__no_poly5));
	vcdp->chgBit  (c+893,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__poly4_sel));
	vcdp->chgBit  (c+894,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__no_poly17_4));
	vcdp->chgBit  (c+895,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__nf));
	vcdp->chgBit  (c+896,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout1__DOT__filter_reg));
	vcdp->chgBit  (c+897,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift) 
				    >> 1))));
	vcdp->chgBit  (c+898,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
				    >> 1))));
	vcdp->chgBit  (c+899,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift) 
				    >> 1))));
	vcdp->chgBit  (c+900,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__nf));
	vcdp->chgBit  (c+901,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol_only));
	vcdp->chgBus  (c+902,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__vol),4);
	vcdp->chgBit  (c+903,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__no_poly5));
	vcdp->chgBit  (c+904,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__poly4_sel));
	vcdp->chgBit  (c+905,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__no_poly17_4));
	vcdp->chgBit  (c+906,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout2__DOT__filter_reg));
	vcdp->chgBit  (c+907,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly4_shift) 
				    >> 2))));
	vcdp->chgBit  (c+908,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly5_shift) 
				    >> 2))));
	vcdp->chgBit  (c+909,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__poly17_shift) 
				    >> 2))));
	vcdp->chgBit  (c+910,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__nf));
	vcdp->chgBit  (c+911,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol_only));
	vcdp->chgBus  (c+912,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__vol),4);
	vcdp->chgBit  (c+913,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__no_poly5));
	vcdp->chgBit  (c+914,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__poly4_sel));
	vcdp->chgBit  (c+915,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__no_poly17_4));
	vcdp->chgBit  (c+916,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_1__DOT__pokey__DOT__u_audout3__DOT__filter_reg));
	vcdp->chgBit  (c+917,((1 & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
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
	vcdp->chgBus  (c+918,((0x3f & ((((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
						    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
						    : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf)) 
						  | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only))
						  ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol)
						  : 0)) 
					 + (0xf & (
						   (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
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
						  : 0))))),6);
	vcdp->chgBus  (c+919,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serout),8);
	vcdp->chgBit  (c+920,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serout_rdy_o));
	vcdp->chgBit  (c+921,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__serin_ack_o));
	vcdp->chgBit  (c+922,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_key_pressed));
	vcdp->chgBit  (c+923,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_key_break));
	vcdp->chgBit  (c+924,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_serin_rdy_i));
	vcdp->chgBit  (c+925,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__last_serout_ack_i));
	vcdp->chgBus  (c+927,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
					    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
					 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf)) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+928,((0xf & ((((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
					 ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
					    ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))
					 : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf)) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+929,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__nf) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+930,((0xf & (((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__nf) 
				       | (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol_only))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol)
				       : 0))),4);
	vcdp->chgBus  (c+931,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__rst_bits),2);
	vcdp->chgBus  (c+932,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irqen),8);
	vcdp->chgBus  (c+933,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irqst),8);
	vcdp->chgBit  (c+934,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly9));
	vcdp->chgBit  (c+935,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fast_ch0));
	vcdp->chgBit  (c+936,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fast_ch2));
	vcdp->chgBit  (c+937,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__ch01));
	vcdp->chgBit  (c+938,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__ch23));
	vcdp->chgBit  (c+939,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02));
	vcdp->chgBit  (c+940,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13));
	vcdp->chgBit  (c+941,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__base15));
	vcdp->chgBus  (c+945,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift),3);
	vcdp->chgBus  (c+946,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift),3);
	vcdp->chgBus  (c+947,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift),3);
	vcdp->chgBus  (c+948,((0xff & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift 
				       >> 9))),8);
	vcdp->chgBus  (c+949,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[0]),8);
	vcdp->chgBus  (c+950,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[1]),8);
	vcdp->chgBus  (c+951,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[2]),8);
	vcdp->chgBus  (c+952,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[3]),8);
	vcdp->chgBus  (c+953,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[4]),8);
	vcdp->chgBus  (c+954,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[5]),8);
	vcdp->chgBus  (c+955,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[6]),8);
	vcdp->chgBus  (c+956,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr[7]),8);
	vcdp->chgBus  (c+957,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_count),8);
	vcdp->chgBus  (c+958,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_base__DOT__div57),6);
	vcdp->chgBus  (c+959,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_base__DOT__div4),2);
	vcdp->chgBus  (c+960,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly4__DOT__shift),4);
	vcdp->chgBus  (c+961,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly5__DOT__shift),5);
	vcdp->chgBit  (c+926,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__rst_bits))));
	vcdp->chgBus  (c+962,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift),17);
	vcdp->chgBit  (c+963,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__last_short));
	vcdp->chgBus  (c+964,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6),8);
	vcdp->chgBit  (c+965,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr0____pinNumber6))));
	vcdp->chgBus  (c+966,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr0__DOT__freq),8);
	vcdp->chgBus  (c+967,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6),8);
	vcdp->chgBit  (c+968,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr1____pinNumber6))));
	vcdp->chgBus  (c+969,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr1__DOT__freq),8);
	vcdp->chgBus  (c+970,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6),8);
	vcdp->chgBit  (c+971,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr2____pinNumber6))));
	vcdp->chgBus  (c+972,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr2__DOT__freq),8);
	vcdp->chgBus  (c+973,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6),8);
	vcdp->chgBit  (c+974,((0 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT____Vcellinp__u_ctr3____pinNumber6))));
	vcdp->chgBus  (c+975,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_ctr3__DOT__freq),8);
	vcdp->chgBit  (c+942,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly4__DOT__shift) 
				    >> 3))));
	vcdp->chgBit  (c+943,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly5__DOT__shift) 
				    >> 4))));
	vcdp->chgBit  (c+944,((1 & (vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift 
				    >> 0x10))));
	vcdp->chgBit  (c+976,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi02)
			        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg) 
				   ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf))));
	vcdp->chgBit  (c+977,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol_only));
	vcdp->chgBus  (c+978,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__vol),4);
	vcdp->chgBit  (c+979,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__no_poly5));
	vcdp->chgBit  (c+980,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__poly4_sel));
	vcdp->chgBit  (c+981,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__no_poly17_4));
	vcdp->chgBit  (c+982,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__nf));
	vcdp->chgBit  (c+983,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout0__DOT__filter_reg));
	vcdp->chgBit  (c+984,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift))));
	vcdp->chgBit  (c+985,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift))));
	vcdp->chgBit  (c+986,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift))));
	vcdp->chgBit  (c+987,(((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__fi13)
			        ? ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg) 
				   ^ (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))
			        : (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf))));
	vcdp->chgBit  (c+988,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol_only));
	vcdp->chgBus  (c+989,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__vol),4);
	vcdp->chgBit  (c+990,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__no_poly5));
	vcdp->chgBit  (c+991,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__poly4_sel));
	vcdp->chgBit  (c+992,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__no_poly17_4));
	vcdp->chgBit  (c+993,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__nf));
	vcdp->chgBit  (c+994,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout1__DOT__filter_reg));
	vcdp->chgBit  (c+995,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift) 
				    >> 1))));
	vcdp->chgBit  (c+996,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
				    >> 1))));
	vcdp->chgBit  (c+997,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift) 
				    >> 1))));
	vcdp->chgBit  (c+998,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__nf));
	vcdp->chgBit  (c+999,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol_only));
	vcdp->chgBus  (c+1000,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__vol),4);
	vcdp->chgBit  (c+1001,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__no_poly5));
	vcdp->chgBit  (c+1002,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__poly4_sel));
	vcdp->chgBit  (c+1003,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__no_poly17_4));
	vcdp->chgBit  (c+1004,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout2__DOT__filter_reg));
	vcdp->chgBit  (c+1005,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly4_shift) 
				     >> 2))));
	vcdp->chgBit  (c+1006,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly5_shift) 
				     >> 2))));
	vcdp->chgBit  (c+1007,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__poly17_shift) 
				     >> 2))));
	vcdp->chgBit  (c+1008,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__nf));
	vcdp->chgBit  (c+1009,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol_only));
	vcdp->chgBus  (c+1010,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__vol),4);
	vcdp->chgBit  (c+1011,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__no_poly5));
	vcdp->chgBit  (c+1012,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__poly4_sel));
	vcdp->chgBit  (c+1013,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__no_poly17_4));
	vcdp->chgBit  (c+1014,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_audout3__DOT__filter_reg));
    }
}

void Vff_verilator::traceChgThis__91(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+1015,(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_n_v));
	vcdp->chgBit  (c+1016,(vlTOPp->v__DOT__uut__DOT__ff__DOT__u_v_n));
	vcdp->chgBus  (c+1017,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_rom_a),8);
    }
}

void Vff_verilator::traceChgThis__92(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1018,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfv_hold),6);
    }
}

void Vff_verilator::traceChgThis__93(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+1022,((1 & ((0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
				      ? 0 : 1))));
	vcdp->chgBit  (c+1019,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_out_en_i)
				      ? 0 : 1))));
	vcdp->chgBit  (c+1023,((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))));
	vcdp->chgBit  (c+1024,(((0 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				& ((1 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				   & ((2 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				      & (3 != (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)))))));
	vcdp->chgBus  (c+1025,(((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))
				 ? 7 : (((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					 | (0xd == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)))
					 ? 6 : (((0xe 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
						 | (0xf 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)))
						 ? 6
						 : 5)))),3);
	vcdp->chgBit  (c+1027,(((4 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				| ((0xc == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				   | ((0xd == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				      | ((0xe == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					 | (0xf == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))))))));
	vcdp->chgBit  (c+1026,(((5 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				| ((6 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				   | ((7 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
				      | ((8 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					 | ((9 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					    | ((0xa 
						== (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state)) 
					       | (0xb 
						  == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))))))))));
	vcdp->chgBit  (c+1021,((0x10 == (IData)(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state))));
	vcdp->chgBus  (c+1029,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_irq_ctrl__DOT__ex_state),5);
	vcdp->chgBit  (c+1028,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__reset_rdy_i));
	vcdp->chgBus  (c+1030,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_timer),7);
	vcdp->chgBit  (c+1031,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_timer_lock));
	vcdp->chgBit  (c+1020,(vlTOPp->v__DOT__uut__DOT__ff__DOT__cpu__DOT__wf68k00ip_top__DOT__i_68k00__DOT__i_bus_if__DOT__reset_out_en_i));
    }
}

void Vff_verilator::traceChgThis__94(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1032,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pf_out_h_hold),8);
    }
}

void Vff_verilator::traceChgThis__95(Vff_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vff_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+1035,(vlTOPp->v__DOT__uut__DOT__ff__DOT__int4rst_n));
	vcdp->chgBit  (c+1036,(vlTOPp->v__DOT__uut__DOT__ff__DOT__int3rst_n));
	vcdp->chgBit  (c+1037,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counterr));
	vcdp->chgBit  (c+1038,(vlTOPp->v__DOT__uut__DOT__ff__DOT__counterl));
	vcdp->chgBit  (c+1034,(vlTOPp->v__DOT__uut__DOT__ff__DOT__led2));
	vcdp->chgBit  (c+1033,(vlTOPp->v__DOT__uut__DOT__ff__DOT__led1));
	vcdp->chgBit  (c+1039,(vlTOPp->v__DOT__uut__DOT__ff__DOT__update));
	vcdp->chgBit  (c+1040,(vlTOPp->v__DOT__uut__DOT__ff__DOT__pfflip));
    }
}
