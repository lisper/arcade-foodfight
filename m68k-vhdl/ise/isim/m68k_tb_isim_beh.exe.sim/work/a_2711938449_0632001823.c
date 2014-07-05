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
static const char *ng0 = "/files/code/foodfight/m68k-vhdl/68K00/wf68k00ip_top.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1594292773_503743352(char *, unsigned char , unsigned char );


static void work_a_2711938449_0632001823_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(164, ng0);
    t1 = (t0 + 2800U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t10 = xsi_get_transient_memory(23U);
    memset(t10, 0, 23U);
    t11 = t10;
    memset(t11, (unsigned char)4, 23U);
    t12 = (t0 + 6964);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t10, 23U);
    xsi_driver_first_trans_fast_port(t12);

LAB2:    t17 = (t0 + 6824);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 2892U);
    t5 = *((char **)t1);
    t1 = (t0 + 6964);
    t6 = (t1 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    memcpy(t9, t5, 23U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_1(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(165, ng0);
    t1 = (t0 + 2984U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t10 = xsi_get_transient_memory(16U);
    memset(t10, 0, 16U);
    t11 = t10;
    memset(t11, (unsigned char)4, 16U);
    t12 = (t0 + 7000);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t10, 16U);
    xsi_driver_first_trans_fast_port(t12);

LAB2:    t17 = (t0 + 6832);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 3076U);
    t5 = *((char **)t1);
    t1 = (t0 + 7000);
    t6 = (t1 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    memcpy(t9, t5, 16U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_2(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    xsi_set_current_line(168, ng0);

LAB3:    t1 = (t0 + 1052U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = ieee_p_2592010699_sub_1594292773_503743352(IEEE_P_2592010699, t3, (unsigned char)0);
    t1 = (t0 + 7036);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = t4;
    xsi_driver_first_trans_fast(t1);

LAB2:    t9 = (t0 + 6840);
    *((int *)t9) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(170, ng0);

LAB3:    t1 = (t0 + 1420U);
    t2 = *((char **)t1);
    t1 = (t0 + 7072);
    t3 = (t1 + 32U);
    t4 = *((char **)t3);
    t5 = (t4 + 32U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 3U);
    xsi_driver_first_trans_fast(t1);

LAB2:    t7 = (t0 + 6848);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_4(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    char *t5;
    unsigned char t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;

LAB0:    xsi_set_current_line(171, ng0);

LAB3:    t2 = (t0 + 1328U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    if (t4 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    t2 = (t0 + 7108);
    t7 = (t2 + 32U);
    t8 = *((char **)t7);
    t9 = (t8 + 32U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = t1;
    xsi_driver_first_trans_fast(t2);

LAB2:    t11 = (t0 + 6856);
    *((int *)t11) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    t2 = (t0 + 2156U);
    t5 = *((char **)t2);
    t6 = *((unsigned char *)t5);
    t1 = t6;
    goto LAB7;

}

static void work_a_2711938449_0632001823_p_5(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(174, ng0);
    t1 = (t0 + 2616U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t9 = (t0 + 7144);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t9);

LAB2:    t14 = (t0 + 6864);
    *((int *)t14) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 7144);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_6(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;

LAB0:    xsi_set_current_line(175, ng0);
    t1 = (t0 + 2708U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t9 = (t0 + 7180);
    t10 = (t9 + 32U);
    t11 = *((char **)t10);
    t12 = (t11 + 32U);
    t13 = *((char **)t12);
    *((unsigned char *)t13) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t9);

LAB2:    t14 = (t0 + 6872);
    *((int *)t14) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 7180);
    t5 = (t1 + 32U);
    t6 = *((char **)t5);
    t7 = (t6 + 32U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_7(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;

LAB0:    xsi_set_current_line(178, ng0);
    t2 = (t0 + 3352U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)1);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:    t14 = (t0 + 3352U);
    t15 = *((char **)t14);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)0);
    if (t17 == 1)
        goto LAB10;

LAB11:    t13 = (unsigned char)0;

LAB12:    if (t13 != 0)
        goto LAB8;

LAB9:
LAB13:    t25 = (t0 + 7216);
    t26 = (t25 + 32U);
    t27 = *((char **)t26);
    t28 = (t27 + 32U);
    t29 = *((char **)t28);
    *((unsigned char *)t29) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t25);

LAB2:    t30 = (t0 + 6880);
    *((int *)t30) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 7216);
    t9 = (t2 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB2;

LAB5:    t2 = (t0 + 3444U);
    t6 = *((char **)t2);
    t7 = *((unsigned char *)t6);
    t8 = (t7 == (unsigned char)1);
    t1 = t8;
    goto LAB7;

LAB8:    t14 = (t0 + 7216);
    t21 = (t14 + 32U);
    t22 = *((char **)t21);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB10:    t14 = (t0 + 3444U);
    t18 = *((char **)t14);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)1);
    t13 = t20;
    goto LAB12;

LAB14:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_8(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;

LAB0:    xsi_set_current_line(180, ng0);
    t2 = (t0 + 3720U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)1);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:    t14 = (t0 + 3720U);
    t15 = *((char **)t14);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)0);
    if (t17 == 1)
        goto LAB10;

LAB11:    t13 = (unsigned char)0;

LAB12:    if (t13 != 0)
        goto LAB8;

LAB9:
LAB13:    t25 = (t0 + 7252);
    t26 = (t25 + 32U);
    t27 = *((char **)t26);
    t28 = (t27 + 32U);
    t29 = *((char **)t28);
    *((unsigned char *)t29) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t25);

LAB2:    t30 = (t0 + 6888);
    *((int *)t30) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 7252);
    t9 = (t2 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB2;

LAB5:    t2 = (t0 + 3812U);
    t6 = *((char **)t2);
    t7 = *((unsigned char *)t6);
    t8 = (t7 == (unsigned char)1);
    t1 = t8;
    goto LAB7;

LAB8:    t14 = (t0 + 7252);
    t21 = (t14 + 32U);
    t22 = *((char **)t21);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB10:    t14 = (t0 + 3812U);
    t18 = *((char **)t14);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)1);
    t13 = t20;
    goto LAB12;

LAB14:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_9(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;

LAB0:    xsi_set_current_line(182, ng0);
    t2 = (t0 + 3904U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)1);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:    t14 = (t0 + 3904U);
    t15 = *((char **)t14);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)0);
    if (t17 == 1)
        goto LAB10;

LAB11:    t13 = (unsigned char)0;

LAB12:    if (t13 != 0)
        goto LAB8;

LAB9:
LAB13:    t25 = (t0 + 7288);
    t26 = (t25 + 32U);
    t27 = *((char **)t26);
    t28 = (t27 + 32U);
    t29 = *((char **)t28);
    *((unsigned char *)t29) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t25);

LAB2:    t30 = (t0 + 6896);
    *((int *)t30) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 7288);
    t9 = (t2 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB2;

LAB5:    t2 = (t0 + 3996U);
    t6 = *((char **)t2);
    t7 = *((unsigned char *)t6);
    t8 = (t7 == (unsigned char)1);
    t1 = t8;
    goto LAB7;

LAB8:    t14 = (t0 + 7288);
    t21 = (t14 + 32U);
    t22 = *((char **)t21);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB10:    t14 = (t0 + 3996U);
    t18 = *((char **)t14);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)1);
    t13 = t20;
    goto LAB12;

LAB14:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_10(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;

LAB0:    xsi_set_current_line(184, ng0);
    t2 = (t0 + 3536U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)1);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:    t14 = (t0 + 3536U);
    t15 = *((char **)t14);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)0);
    if (t17 == 1)
        goto LAB10;

LAB11:    t13 = (unsigned char)0;

LAB12:    if (t13 != 0)
        goto LAB8;

LAB9:
LAB13:    t25 = (t0 + 7324);
    t26 = (t25 + 32U);
    t27 = *((char **)t26);
    t28 = (t27 + 32U);
    t29 = *((char **)t28);
    *((unsigned char *)t29) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t25);

LAB2:    t30 = (t0 + 6904);
    *((int *)t30) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 7324);
    t9 = (t2 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB2;

LAB5:    t2 = (t0 + 3628U);
    t6 = *((char **)t2);
    t7 = *((unsigned char *)t6);
    t8 = (t7 == (unsigned char)1);
    t1 = t8;
    goto LAB7;

LAB8:    t14 = (t0 + 7324);
    t21 = (t14 + 32U);
    t22 = *((char **)t21);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB10:    t14 = (t0 + 3628U);
    t18 = *((char **)t14);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)1);
    t13 = t20;
    goto LAB12;

LAB14:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_11(char *t0)
{
    unsigned char t1;
    char *t2;
    char *t3;
    unsigned char t4;
    unsigned char t5;
    char *t6;
    unsigned char t7;
    unsigned char t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned char t13;
    char *t14;
    char *t15;
    unsigned char t16;
    unsigned char t17;
    char *t18;
    unsigned char t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;

LAB0:    xsi_set_current_line(186, ng0);
    t2 = (t0 + 4180U);
    t3 = *((char **)t2);
    t4 = *((unsigned char *)t3);
    t5 = (t4 == (unsigned char)1);
    if (t5 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB3;

LAB4:    t14 = (t0 + 4180U);
    t15 = *((char **)t14);
    t16 = *((unsigned char *)t15);
    t17 = (t16 == (unsigned char)0);
    if (t17 == 1)
        goto LAB10;

LAB11:    t13 = (unsigned char)0;

LAB12:    if (t13 != 0)
        goto LAB8;

LAB9:
LAB13:    t25 = (t0 + 7360);
    t26 = (t25 + 32U);
    t27 = *((char **)t26);
    t28 = (t27 + 32U);
    t29 = *((char **)t28);
    *((unsigned char *)t29) = (unsigned char)4;
    xsi_driver_first_trans_fast_port(t25);

LAB2:    t30 = (t0 + 6912);
    *((int *)t30) = 1;

LAB1:    return;
LAB3:    t2 = (t0 + 7360);
    t9 = (t2 + 32U);
    t10 = *((char **)t9);
    t11 = (t10 + 32U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    goto LAB2;

LAB5:    t2 = (t0 + 4272U);
    t6 = *((char **)t2);
    t7 = *((unsigned char *)t6);
    t8 = (t7 == (unsigned char)1);
    t1 = t8;
    goto LAB7;

LAB8:    t14 = (t0 + 7360);
    t21 = (t14 + 32U);
    t22 = *((char **)t21);
    t23 = (t22 + 32U);
    t24 = *((char **)t23);
    *((unsigned char *)t24) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t14);
    goto LAB2;

LAB10:    t14 = (t0 + 4272U);
    t18 = *((char **)t14);
    t19 = *((unsigned char *)t18);
    t20 = (t19 == (unsigned char)1);
    t13 = t20;
    goto LAB12;

LAB14:    goto LAB2;

}

static void work_a_2711938449_0632001823_p_12(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;
    char *t17;

LAB0:    xsi_set_current_line(190, ng0);
    t1 = (t0 + 3168U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB3;

LAB4:
LAB5:    t10 = xsi_get_transient_memory(3U);
    memset(t10, 0, 3U);
    t11 = t10;
    memset(t11, (unsigned char)4, 3U);
    t12 = (t0 + 7396);
    t13 = (t12 + 32U);
    t14 = *((char **)t13);
    t15 = (t14 + 32U);
    t16 = *((char **)t15);
    memcpy(t16, t10, 3U);
    xsi_driver_first_trans_fast_port(t12);

LAB2:    t17 = (t0 + 6920);
    *((int *)t17) = 1;

LAB1:    return;
LAB3:    t1 = (t0 + 3260U);
    t5 = *((char **)t1);
    t1 = (t0 + 7396);
    t6 = (t1 + 32U);
    t7 = *((char **)t6);
    t8 = (t7 + 32U);
    t9 = *((char **)t8);
    memcpy(t9, t5, 3U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB2;

LAB6:    goto LAB2;

}


extern void work_a_2711938449_0632001823_init()
{
	static char *pe[] = {(void *)work_a_2711938449_0632001823_p_0,(void *)work_a_2711938449_0632001823_p_1,(void *)work_a_2711938449_0632001823_p_2,(void *)work_a_2711938449_0632001823_p_3,(void *)work_a_2711938449_0632001823_p_4,(void *)work_a_2711938449_0632001823_p_5,(void *)work_a_2711938449_0632001823_p_6,(void *)work_a_2711938449_0632001823_p_7,(void *)work_a_2711938449_0632001823_p_8,(void *)work_a_2711938449_0632001823_p_9,(void *)work_a_2711938449_0632001823_p_10,(void *)work_a_2711938449_0632001823_p_11,(void *)work_a_2711938449_0632001823_p_12};
	xsi_register_didat("work_a_2711938449_0632001823", "isim/m68k_tb_isim_beh.exe.sim/work/a_2711938449_0632001823.didat");
	xsi_register_executes(pe);
}
