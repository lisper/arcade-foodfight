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

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *STD_STANDARD;
char *WORK_P_1271854817;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000001937131451_2220189930_init();
    work_m_00000000003766888238_0450250084_init();
    work_m_00000000003984573679_0261923157_init();
    work_m_00000000004134447467_2073120511_init();
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_p_1271854817_init();
    work_a_0167124495_2372691052_init();
    work_a_0200341430_2372691052_init();
    work_a_1037839825_2372691052_init();
    work_a_2516461634_2372691052_init();
    work_a_2717836306_2372691052_init();
    work_a_3752162132_2372691052_init();
    work_a_0782015954_2372691052_init();
    work_a_2036855268_2372691052_init();
    work_a_4024454103_0632001823_init();
    work_a_2711938449_0632001823_init();


    xsi_register_tops("work_m_00000000003984573679_0261923157");
    xsi_register_tops("work_m_00000000004134447467_2073120511");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    WORK_P_1271854817 = xsi_get_engine_memory("work_p_1271854817");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");

    return xsi_run_simulation(argc, argv);

}
