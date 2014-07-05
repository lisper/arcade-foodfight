/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/files/code/foodfight/m68k-vhdl/m68k_tb.v";
static unsigned int ng1[] = {0U, 0U};
static unsigned int ng2[] = {2U, 0U};
static unsigned int ng3[] = {8192U, 0U};
static unsigned int ng4[] = {4U, 0U};
static unsigned int ng5[] = {6U, 0U};
static unsigned int ng6[] = {4096U, 0U};
static unsigned int ng7[] = {12344U, 0U};
static unsigned int ng8[] = {4098U, 0U};
static unsigned int ng9[] = {4100U, 0U};
static unsigned int ng10[] = {53368U, 0U};
static unsigned int ng11[] = {4102U, 0U};
static unsigned int ng12[] = {8194U, 0U};
static unsigned int ng13[] = {4104U, 0U};
static unsigned int ng14[] = {4106U, 0U};
static unsigned int ng15[] = {8196U, 0U};
static unsigned int ng16[] = {4108U, 0U};
static unsigned int ng17[] = {36988U, 0U};
static unsigned int ng18[] = {4110U, 0U};
static unsigned int ng19[] = {496U, 0U};
static unsigned int ng20[] = {4112U, 0U};
static unsigned int ng21[] = {12736U, 0U};
static unsigned int ng22[] = {4114U, 0U};
static unsigned int ng23[] = {8198U, 0U};
static unsigned int ng24[] = {4116U, 0U};
static unsigned int ng25[] = {20082U, 0U};
static unsigned int ng26[] = {4118U, 0U};
static unsigned int ng27[] = {9984U, 0U};
static int ng28[] = {0, 0};
static const char *ng29 = "rom: %x -> %x";



static void Always_6_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    int t6;
    char *t7;
    char *t8;

LAB0:    t1 = (t0 + 1340U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(6, ng0);
    t2 = (t0 + 1520);
    *((int *)t2) = 1;
    t3 = (t0 + 1364);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(7, ng0);

LAB5:    xsi_set_current_line(8, ng0);
    t4 = (t0 + 600U);
    t5 = *((char **)t4);

LAB6:    t4 = ((char*)((ng1)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t4, 24);
    if (t6 == 1)
        goto LAB7;

LAB8:    t2 = ((char*)((ng2)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB9;

LAB10:    t2 = ((char*)((ng4)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB11;

LAB12:    t2 = ((char*)((ng5)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB13;

LAB14:    t2 = ((char*)((ng6)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB15;

LAB16:    t2 = ((char*)((ng8)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB17;

LAB18:    t2 = ((char*)((ng9)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB19;

LAB20:    t2 = ((char*)((ng11)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB21;

LAB22:    t2 = ((char*)((ng13)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB23;

LAB24:    t2 = ((char*)((ng14)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB25;

LAB26:    t2 = ((char*)((ng16)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB27;

LAB28:    t2 = ((char*)((ng18)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB29;

LAB30:    t2 = ((char*)((ng20)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB31;

LAB32:    t2 = ((char*)((ng22)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB33;

LAB34:    t2 = ((char*)((ng24)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB35;

LAB36:    t2 = ((char*)((ng26)));
    t6 = xsi_vlog_unsigned_case_compare(t5, 24, t2, 24);
    if (t6 == 1)
        goto LAB37;

LAB38:
LAB40:
LAB39:    xsi_set_current_line(25, ng0);
    t2 = ((char*)((ng28)));
    t3 = (t0 + 828);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);

LAB41:    xsi_set_current_line(28, ng0);
    t2 = (t0 + 600U);
    t3 = *((char **)t2);
    t2 = (t0 + 828);
    t4 = (t2 + 36U);
    t7 = *((char **)t4);
    xsi_vlogfile_write(1, 0, 0, ng29, 3, t0, (char)118, t3, 24, (char)118, t7, 16);
    goto LAB2;

LAB7:    xsi_set_current_line(9, ng0);
    t7 = ((char*)((ng1)));
    t8 = (t0 + 828);
    xsi_vlogvar_assign_value(t8, t7, 0, 0, 16);
    goto LAB41;

LAB9:    xsi_set_current_line(10, ng0);
    t3 = ((char*)((ng3)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB11:    xsi_set_current_line(11, ng0);
    t3 = ((char*)((ng1)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB13:    xsi_set_current_line(12, ng0);
    t3 = ((char*)((ng6)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB15:    xsi_set_current_line(13, ng0);
    t3 = ((char*)((ng7)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB17:    xsi_set_current_line(14, ng0);
    t3 = ((char*)((ng3)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB19:    xsi_set_current_line(15, ng0);
    t3 = ((char*)((ng10)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB21:    xsi_set_current_line(16, ng0);
    t3 = ((char*)((ng12)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB23:    xsi_set_current_line(17, ng0);
    t3 = ((char*)((ng10)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB25:    xsi_set_current_line(18, ng0);
    t3 = ((char*)((ng15)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB27:    xsi_set_current_line(19, ng0);
    t3 = ((char*)((ng17)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB29:    xsi_set_current_line(20, ng0);
    t3 = ((char*)((ng19)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB31:    xsi_set_current_line(21, ng0);
    t3 = ((char*)((ng21)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB33:    xsi_set_current_line(22, ng0);
    t3 = ((char*)((ng23)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB35:    xsi_set_current_line(23, ng0);
    t3 = ((char*)((ng25)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

LAB37:    xsi_set_current_line(24, ng0);
    t3 = ((char*)((ng27)));
    t4 = (t0 + 828);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 16);
    goto LAB41;

}


extern void work_m_00000000001937131451_2220189930_init()
{
	static char *pe[] = {(void *)Always_6_0};
	xsi_register_didat("work_m_00000000001937131451_2220189930", "isim/m68k_tb_isim_beh.exe.sim/work/m_00000000001937131451_2220189930.didat");
	xsi_register_executes(pe);
}
