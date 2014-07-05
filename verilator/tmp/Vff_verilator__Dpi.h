// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to insure
// the C functions match the expectations of the DPI imports.

#ifdef __cplusplus
extern "C" {
#endif
    
    
    // DPI IMPORTS
    // DPI Import at ff_verilator.v:44
    extern void dpi_vga_display (int vsync_, int hsync_, int pixel_);
    // DPI Import at ff_verilator.v:41
    extern void dpi_vga_init (int h, int v);
    
#ifdef __cplusplus
}
#endif
