class CarShops {
    /*
    *    ARRAY FORMAT:
    *        0: STRING (Classname)
    *        1: STRING (Condition)
    *    FORMAT:
    *        STRING (Conditions) - Must return boolean :
    *            String can contain any amount of conditions, aslong as the entire
    *            string returns a boolean. This allows you to check any levels, licenses etc,
    *            in any combination. For example:
    *                "call life_coplevel && license_civ_someLicense"
    *            This will also let you call any other function.
    *
    *   BLUFOR Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_WEST
    *   OPFOR Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_EAST
    *   Independent Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_GUER
    *   Civilian Vehicle classnames can be found here: https://community.bistudio.com/wiki/Arma_3_CfgVehicles_CIV
    */
    class civ_car {
        side = "civ";
        conditions = "";
        vehicles[] = {
			{ "d3s_oka", "" },
			{ "d3s_crown_98", "" },
			{ "d3s_beetle_04", "" },
			{ "d3s_roadrunner_71_340", "" },
			{ "d3s_roadrunner_71_440", "" },
			{ "d3s_e89_12_M", "" },
			{ "d3s_e89_12", "" },
			{ "d3s_challenger_15_SP", "" },
			{ "d3s_challenger_15_RT", "" },
			{ "d3s_challenger_15_392", "" },
			{ "d3s_challenger_15_DM", "" },
			{ "d3s_challenger_15_LW", "" },
			{ "d3s_challenger_15_WIDE", "" },
			{ "d3s_challenger_15_HELL", "" },
			{ "d3s_challenger_15", "" },
			{ "d3s_roadrunner_71_GTX", "" },
			{ "d3s_fseries_17", "" },
			{ "d3s_fseries_LTD_17", "" },
			{ "d3s_fseries_PLT_17", "" },
			{ "d3s_fseries_XLT_17", "" },
			{ "d3s_cayenne_s_16", "" },
			{ "d3s_cayenne_turbo_s_16", "" },
			{ "d3s_cayenne_turbo_16", "" },
			{ "d3s_cayenne_16", "" },
			{ "d3s_macan_s_16", "" },
			{ "d3s_macan_turbo_16", "" },
			{ "d3s_fiesta_16", "" },
			{ "d3s_fiesta_16_H", "" },
			{ "d3s_vesta_15_turbo", "" },
			{ "d3s_vesta_15", "" },
			{ "d3s_300C_12", "" },
			{ "d3s_300S_12", "" },
			{ "d3s_h2_02", "" },
			{ "d3s_macan_16", "" },
			{ "d3s_amazing_a45_16", "" },
			{ "d3s_amazing_a45_16_EX", "" },
			{ "d3s_amazing_a45_16_AMG", "" },
			{ "d3s_cla_15", "" },
			{ "d3s_cla_14", "" },
			{ "d3s_cla_220_15", "" },
			{ "d3s_cla_220_14", "" },
			{ "d3s_cla_250_15", "" },
			{ "d3s_cla_45amg_15", "" },
			{ "d3s_cla_15_SE", "" },
			{ "d3s_cla_45amg_14", "" },
			{ "d3s_cla_14_SE", "" },
			{ "d3s_C43_16", "" },
			{ "d3s_C63S_14", "" },
			{ "d3s_C180_14", "" },
			{ "d3s_C220_14", "" },
			{ "d3s_C250_14", "" },
			{ "d3s_C300_14", "" },
			{ "d3s_C350_14", "" },
			{ "d3s_C450_15", "" },
			{ "d3s_e220_16", "" },
			{ "d3s_e250_16", "" },
			{ "d3s_e350_16", "" },
			{ "d3s_e400_16", "" },
			{ "d3s_s600_17", "" },
			{ "d3s_s600_14", "" },
			{ "d3s_amgGTS_15", "" },
			{ "d3s_amgGT_15", "" },
			{ "d3s_g63amg_16", "" },
			{ "d3s_g63amg_18", "" },
			{ "d3s_g65amg_16", "" },
			{ "d3s_gle43amg_15", "" },
			{ "d3s_gle63amg_15", "" },
			{ "d3s_gle63amgS_15", "" },
			{ "d3s_gls63amg_17", "" },
			{ "d3s_g350d_15", "" },
			{ "d3s_g500_15", "" },
			{ "d3s_g500_18", "" },
			{ "d3s_eqc_20", "" },
			{ "d3s_eqc_20_4matic", "" },
			{ "d3s_eqc_20_400", "" },
			{ "d3s_teslaS_16_90", "" },
			{ "d3s_teslaS_16_85", "" },
			{ "d3s_teslaS_16_100", "" },
			{ "d3s_f87_17", "" },
			{ "d3s_f80_14", "" },
			{ "d3s_f90_18", "" },
			{ "d3s_f13_13", "" },
			{ "d3s_f85_15", "" },
			{ "d3s_f86_15", "" },
			{ "d3s_BMW_S_1000_RR", "" },
			{ "d3s_charger_15", "" },
			{ "d3s_durango_18", "" },
			{ "d3s_durango_18_SRT", "" },
			{ "d3s_skyline_02", "" },
			{ "d3s_skyline_02_V", "" },
			{ "d3s_wrx_sti_17", "" },
			{ "d3s_wrx_17", "" },
			{ "d3s_wrx_17_FnF8", "" },
			{ "d3s_amazing_f82_16", "" },
			{ "d3s_f80_14_GTS", "" },
			{ "d3s_f87_17_m", "" },
			{ "d3s_e38_98", "" },
			{ "d3s_f87_17_sport", "" },
			{ "d3s_srthellcat_15", "" },
			{ "d3s_giulia_quad_16", "" }
        };
    };
    class luxus_car {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "d3s_urus_18", "" },
            { "d3s_huracan_18", "" },
            { "d3s_veneno_13", "" },
            { "d3s_mclaren_18", "" },
            { "d3s_amgGT_19_43", "" },
            { "d3s_amgGT_19_53", "" },
            { "d3s_amgGT_19_63", "" },
            { "d3s_amgGT_19_63S", "" },
            { "d3s_tuatara_19", "" },
            { "d3s_s560_18", "" },
            { "d3s_s650_18", "" },
            { "d3s_vv222_18", "" },
            { "d3s_vv222_18_2", "" },
            { "d3s_QUA_Regalia_23", "" },
            { "d3s_ghost_18_EWB", "" },
            { "d3s_ghost_18_EWB_II", "" },
            { "d3s_cullinan_19_II", "" },
            { "d3s_novus_phantom_18", "" },
            { "d3s_donkervoort_17_BNC", "" },
            { "d3s_donkervoort_17", "" },
            { "d3s_rapide_10", "" },
            { "d3s_continentalGT_18", "" },
            { "d3s_camaro_ss_16", "" },
            { "d3s_LaFerrari_14", "" },
            { "d3s_veyron_12", "" },
            { "d3s_divo_19_P", "" },
            { "d3s_huracan_18_SPD_P", "" },
            { "d3s_asterion_15", "" },
            { "d3s_alfieri_14", "" }
        };
    };
    class admin_shop {
        side = "civ";
        conditions = "license_civ_tuning";
        vehicles[] = {
            { "d3s_boss_15_payback", "" },
			{ "d3s_boss_15", "" },
			{ "d3s_e60_09_ACS5", "" },
			{ "d3s_f87_17_ACH", "" },
			{ "d3s_f80_14_SE", "" },
			{ "d3s_f82_14_LB", "" },
			{ "d3s_f90_18_FE", "" },
			{ "d3s_f13_13_CE", "" },
			{ "d3s_malibu_18_Prem", "" },
			{ "d3s_focus_17_LB", "" },
			{ "d3s_q50_14_SE", "" },
			{ "d3s_xesv_17", "" },
			{ "d3s_xes_15_SE", "" },
			{ "d3s_kuruma_gtaV", "" },
			{ "d3s_is_16_SE", "" },
			{ "d3s_ghibli_esteso_14", "" },
			{ "d3s_ghibli_14_nerissimo", "" },
			{ "d3s_C63S_14_SE", "" },
			{ "d3s_cla_15_SE", "" },
			{ "d3s_cla_14_SE", "" },
			{ "d3s_vv222_18", "" },
			{ "d3s_clubman_11_50", "" },
			{ "d3s_coupeconcept_10", "" },
			{ "d3s_silvia_s15_02", "" },
			{ "d3s_ghost_18_EWB_III", "" },
			{ "d3s_novus_phantom_18_3", "" },
			{ "d3s_wrx_17_FnF8", "" },
			{ "d3s_vesta_15_EX", "" },
			{ "d3s_rapide_10_AMR", "" },
			{ "d3s_continentalGT_18_Black", "" },
			{ "d3s_continentalGT_18_FE", "" },
			{ "d3s_camaro_zl1_1le_18", "" },
			{ "d3s_asterion_15_DMC", "" },
			{ "d3s_amgGTR_15", "" },
			{ "d3s_survolt_10", "" },
			{ "d3s_raptor_SCR_17", "" },
			{ "d3s_qx56_13_SE", "" },
			{ "d3s_QX60_16_SE", "" },
			{ "d3s_lm002_90", "" },
			{ "d3s_lm002_LT", "" },
			{ "d3s_g63amg_18_e1", "" },
			{ "d3s_gl63amg_12_SE", "" },
			{ "d3s_cullinan_19_BB", "" },
			{ "d3s_cullinan_19_FE", "" },
			{ "d3s_Kawasaki_Ninja_H2R", "" },
			{ "d3s_Kawasaki_ZX7RR", "" },
			{ "d3s_Suzuki_GSX_R_1000", "" },
			{ "d3s_Suzuki_Hayabusa", "" }
        };
    };
    class kart_shop {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "C_Kart_01_Blu_F", "" },
            { "C_Kart_01_Fuel_F", "" },
            { "C_Kart_01_Red_F", "" },
            { "C_Kart_01_Vrana_F", "" }
        };
    };
    class civ_truck {
        side = "civ";
        conditions = "";
        vehicles[] = {
			{ "d3s_actros_14", "" },
			{ "d3s_actros_14_big", "" },
			{ "d3s_actros_14_giga", "" },
			{ "d3s_zil_130_05", "" },
			{ "d3s_zil_130_02", "" },
			{ "d3s_zil_130", "" },
			{ "d3s_zil_130_03", "" },
			{ "d3s_zil_130_01", "" },
			{ "d3s_zil_130_04", "" },
			{ "d3s_zil_130_06", "" },
			{ "d3s_zil_130_07", "" },
			{ "d3s_kamaz_2", "" },
			{ "d3s_kamaz_MAW_1", "" },
			{ "d3s_kamaz_bocha", "" },
			{ "d3s_kamaz_bocha_MAW_1", "" },
			{ "d3s_kamaz_tent_2", "" },
			{ "d3s_kamaz_4310_med", "" },
			{ "d3s_kamaz", "" },
			{ "d3s_kamaz_kung", "" },
			{ "d3s_kamaz_tent", "" },
			{ "d3s_kamaz_tent2", "" },
			{ "d3s_kamaz_4350", "" },
			{ "d3s_kamaz_4350_kung", "" },
			{ "d3s_kamaz_4350_tent", "" },
			{ "d3s_kamaz_4350_tent2", "" },
			{ "d3s_kamaz_5350", "" },
			{ "d3s_kamaz_5350_bocha", "" },
			{ "d3s_kamaz_5350_tent", "" },
            { "d3s_savana_VAN", "" }
        };
    };
    class civ_air {
        side = "civ";
        conditions = "license_civ_pilot";
        vehicles[] = {
            { "C_Heli_Light_01_civil_F", "" },
            { "B_Heli_Light_01_F", "" },
            { "O_Heli_Light_02_unarmed_F", "" },
            { "C_Plane_Civil_01_F", "" } //Apex DLC
        };
    };
     class civ_ship {
        side = "civ";
        conditions = "";
        vehicles[] = {
            { "C_Rubberboat", "" },
            { "C_Boat_Civil_01_F", "" },
            { "B_SDV_01_F", "" },
            { "C_Boat_Transport_02_F", "" }, //Apex DLC
            { "C_Scooter_Transport_01_F", "" } //Apex DLC
        };
    };
    class reb_car {
        side = "civ";
        conditions = "license_civ_rebel";
        vehicles[] = {
            { "d3s_willys", "" },
            { "d3s_QUA_Regalia_23_D", "" },
            { "Cardinal_Grinder", "" },
            { "Chevrolet_Advance_1953", "" },
            { "Ford_Mainline_1954", "" },
            { "Ford_Model_B_1932", "" },
            { "Holden_Coupe_Utility_1951", "" },
            { "Righteous_Spike", "" },
            { "d3s_insurgent_gtav", "" }
        };
    };
    class med_shop {
        side = "med";
        conditions = "";
        vehicles[] = {
			{ "d3s_charger_15_EMS", "" },
			{ "d3s_explorer_EMS_13", "" },
			{ "d3s_fpace_17_EMS", "" },
			{ "d3s_titan_17_TAR", "" },
			{ "d3s_vklasse_17_EMS", "" },
			{ "d3s_uaz_3165M_EMS", "" },
			{ "d3s_raptor_EMS_17", "" },
			{ "d3s_uaz_3162_EMS", "" }
        };
    };
    class amc_car_shop {
        side = "civ";
        conditions = "license_civ_amc";
        vehicles[] = {
			{ "d3s_fseries_17_TOW", "" }
        };
    };
    class med_air_hs {
        side = "med";
        conditions = "";
        vehicles[] = {
            { "B_Heli_Light_01_F", "" }
        };
    };
    class cop_car {
        side = "cop";
        conditions = "";
        vehicles[] = {
			{ "d3s_e400_16_COP", "" },
			{ "d3s_f90_18_PD", "" },
			{ "d3s_crown_98_PD", "" },
			{ "d3s_charger_15_CPP", "" },
			{ "d3s_FPIU_13", "" },
			{ "d3s_raptor_PRP_17", "" },
			{ "d3s_g63amg_16_Police", "" },
			{ "d3s_tahoe_PPV", "" },
			{ "d3s_fpace_17_COP", "" },
			{ "d3s_vklasse_17_COP", "" },
			{ "d3s_fseries_17_P3E", "license_cop_swat" },
			{ "d3s_g63amg_16_FSB", "license_cop_swat" },
			{ "d3s_raptor_UNM_17", "license_cop_swat" },
			{ "d3s_gl63amg_12_FSB", "license_cop_swat" },
			{ "d3s_200_16_FSB", "license_cop_swat" },
			{ "d3s_teslaS_16_Mark_42", "license_cop_fbi" },
			{ "d3s_ctsv_16_unm", "license_cop_fbi" },
			{ "d3s_taurus_UNM_10", "license_cop_fbi" },
			{ "d3s_f86_15_UNM", "license_cop_fbi" },
			{ "d3s_tahoe_UNM", "license_cop_fbi" },
			{ "d3s_malibu_18_UNM", "license_cop_fbi" },
			{ "d3s_explorer_UNM_13", "license_cop_fbi" },
			{ "d3s_durango_18_UNM", "license_cop_fbi" },
			{ "d3s_vklasse_17_UNM", "license_cop_fbi" },
			{ "d3s_urus_FSB_12", "license_cop_fbi" }
        };
    };
    class cop_air {
        side = "cop";
        conditions = "";
        vehicles[] = {
			{ "d3s_AS_365", "license_cop_fbi" },
            { "B_Heli_Light_01_F", "" }
        };
    };
    class cop_ship {
        side = "cop";
        conditions = "";
        vehicles[] = {
            { "B_Boat_Transport_01_F", "" },
            { "C_Boat_Civil_01_police_F", "" },
            { "C_Boat_Transport_02_F", "" }, //Apex DLC
            { "B_SDV_01_F", "" }
        };
    };
};
//Farben
class Colors {
	textures[] = {
		{ "Schwarz", "civ", {
			"#(argb,8,8,3)color(0,0,0,1.0,CO)"
		} },
		{ "Weiß", "civ", {
			"#(argb,8,8,3)color(1,1,1,1.0,CO)"
		} },
		{ "Grau", "civ", {
			"#(argb,8,8,3)color(0.521569,0.521569,0.521569,1.0,CO)"
		} },
		{ "Grau Blau", "civ", {
			"#(argb,8,8,3)color(0.537255,0.647059,0.811765,1.0,CO)"
		} },
		{ "Dunkelblaues Grau", "civ", {
			"#(argb,8,8,3)color(0.278431,0.427451,0.713725,1.0,CO)"
		} },
		{ "Hellblau", "civ", {
			"#(argb,8,8,3)color(0.192157,0.556863,0.968627,1.0,CO)"
		} },
		{ "Blau", "civ", {
			"#(argb,8,8,3)color(0.0352941,0.415686,0.882353,1.0,CO)"
		} },
		{ "Dunkelblau", "civ", {
			"#(argb,8,8,3)color(0.0235294,0.12549,0.592157,1.0,CO)"
		} },
		{ "Türkisblau", "civ", {
			"#(argb,8,8,3)color(0,0.717647,0.717647,1.0,CO)"
		} },
		{ "Hellrot", "civ", {
			"#(argb,8,8,3)color(0.992157,0.258824,0.258824,1.0,CO)"
		} },
		{ "Rot", "civ", {
			"#(argb,8,8,3)color(0.843137,0,0,1.0,CO)"
		} },
		{ "Dunkelrot", "civ", {
			"#(argb,8,8,3)color(0.466667,0,0,1.0,CO)"
		} },
		{ "Bordeauxrot", "civ", {
			"#(argb,8,8,3)color(0.517647,0.0156863,0.027451,1.0,CO)"
		} },
		{ "Hellgrün", "civ", {
			"#(argb,8,8,3)color(0.270588,0.862745,0.345098,1.0,CO)"
		} },
		{ "Grün", "civ", {
			"#(argb,8,8,3)color(0.105882,0.545098,0.156863,1.0,CO)"
		} },
		{ "Dunkelgrün", "civ", {
			"#(argb,8,8,3)color(0.0509804,0.266667,0.0784314,1.0,CO)"
		} },
		{ "Grüne Limette", "civ", {
			"#(argb,8,8,3)color(0.65098,0.996078,0.00392157,1.0,CO)"
		} },
		{ "Khaki", "civ", {
			"#(argb,8,8,3)color(0.392157,0.447059,0.180392,1.0,CO)"
		} },
		{ "Gelb", "civ", {
			"#(argb,8,8,3)color(0.917647,0.886275,0.356863,1.0,CO)"
		} },
		{ "Orange", "civ", {
			"#(argb,8,8,3)color(0.921569,0.435294,0.137255,1.0,CO)"
		} },
		{ "Ton", "civ", {
			"#(argb,8,8,3)color(0.788235,0.427451,0.380392,1.0,CO)"
		} },
		{ "Braun", "civ", {
			"#(argb,8,8,3)color(0.713725,0.517647,0.305882,1.0,CO)"
		} },
		{ "Dunkelbraun", "civ", {
			"#(argb,8,8,3)color(0.407843,0.290196,0.168627,1.0,CO)"
		} },
		{ "Pink", "civ", {
			"#(argb,8,8,3)color(0.972549,0.470588,0.756863,1.0,CO)"
		} },
		{ "Dunkelpink", "civ", {
			"#(argb,8,8,3)color(0.713725,0.32549,0.843137,1.0,CO)"
		} },
		{ "Lavendel", "civ", {
			"#(argb,8,8,3)color(0.717647,0.662745,0.960784,1.0,CO)"
		} },
		{ "Violett", "civ", {
			"#(argb,8,8,3)color(0.392157,0.0431373,0.67451,1.0,CO)"
		} },
		{ "AliceBlue", "civ", {
			"#(rgb,8,8,3)color(0.94,0.97,1.0,1.0,CO)"
		} },
		{ "BlueViolet", "civ", {
			"#(rgb,8,8,3)color(0.54,0.17,0.89,1.0,CO)"
		} },
		{ "CadetBlue", "civ", {
			"#(rgb,8,8,3)color(0.37,0.62,0.63,1.0,CO)"
		} },
		{ "CornflowerBlue", "civ", {
			"#(rgb,8,8,3)color(0.39,0.58,0.93,1.0,CO)"
		} },
		{ "DarkBlue", "civ", {
			"#(rgb,8,8,3)color(0.0,0.0,0.55,1.0,CO)"
		} },
		{ "DarkCyan", "civ", {
			"#(rgb,8,8,3)color(0.0,0.55,0.55,1.0,CO)"
		} },
		{ "DarkSlateBlue", "civ", {
			"#(rgb,8,8,3)color(0.28,0.24,0.55,1.0,CO)"
		} },
		{ "DarkTurquoise", "civ", {
			"#(rgb,8,8,3)color(0.0,0.81,0.82,1.0,CO)"
		} },
		{ "DeepSkyBlue", "civ", {
			"#(rgb,8,8,3)color(0.0,0.75,1.0,1.0,CO)"
		} },
		{ "DodgerBlue", "civ", {
			"#(rgb,8,8,3)color(0.12,0.56,1.0,1.0,CO)"
		} },
		{ "LightBlue", "civ", {
			"#(rgb,8,8,3)color(0.68,0.85,0.90,1.0,CO)"
		} },
		{ "LightCyan", "civ", {
			"#(rgb,8,8,3)color(0.88,1.0,1.0,1,CO)"
		} },
		{ "LightSkyBlue", "civ", {
			"#(rgb,8,8,3)color(0.53,0.81,0.98,1,CO)"
		} },
		{ "LightSlateBlue", "civ", {
			"#(rgb,8,8,3)color(0.52,0.44,1.0,1,CO)"
		} },
		{ "LightSteelBlue", "civ", {
			"#(rgb,8,8,3)color(0.69,0.77,0.87,1,CO)"
		} },
		{ "MediumAquamarine", "civ", {
			"#(rgb,8,8,3)color(0.40,0.80,0.67,1,CO)"
		} },
		{ "MediumBlue", "civ", {
			"#(rgb,8,8,3)color(0.0,0.0,0.80,1,CO)"
		} },
		{ "MediumSlateBlue", "civ", {
			"#(rgb,8,8,3)color(0.48,0.41,0.93,1,CO)"
		} },
		{ "MediumTurquoise", "civ", {
			"#(rgb,8,8,3)color(0.28,0.82,0.80,1,CO)"
		} },
		{ "MidnightBlue", "civ", {
			"#(rgb,8,8,3)color(0.10,0.10,0.44,1,CO)"
		} },
		{ "NavyBlue", "civ", {
			"#(rgb,8,8,3)color(0.0,0.0,0.50,1,CO)"
		} },
		{ "PaleTurquoise", "civ", {
			"#(rgb,8,8,3)color(0.69,0.93,0.93,1,CO)"
		} },
		{ "PowderBlue", "civ", {
			"#(rgb,8,8,3)color(0.69,0.88,0.90,1,CO)"
		} },
		{ "RoyalBlue", "civ", {
			"#(rgb,8,8,3)color(0.25,0.41,0.88,1,CO)"
		} },
		{ "SkyBlue", "civ", {
			"#(rgb,8,8,3)color(0.53,0.81,0.92,1,CO)"
		} },
		{ "SlateBlue", "civ", {
			"#(rgb,8,8,3)color(0.42,0.35,0.80,1,CO)"
		} },
		{ "SteelBlue", "civ", {
			"#(rgb,8,8,3)color(0.27,0.51,0.71,1,CO)"
		} },
		{ "Aquamarine", "civ", {
			"#(rgb,8,8,3)color(0.50,1.0,0.83,1,CO)"
		} },
		{ "Azure", "civ", {
			"#(rgb,8,8,3)color(0.94,1.0,1.0,1,CO)"
		} },
		{ "Blue", "civ", {
			"#(rgb,8,8,3)color(0.0,0.0,1.0,1,CO)"
		} },
		{ "Cyan", "civ", {
			"#(rgb,8,8,3)color(0.0,1.0,1.0,1,CO)"
		} },
		{ "Navy", "civ", {
			"#(rgb,8,8,3)color(0.0,0.0,0.50,1,CO)"
		} },
		{ "Turquoise", "civ", {
			"#(rgb,8,8,3)color(0.25,0.88,0.82,1,CO)"
		} },
		{ "RosyBrown", "civ", {
			"#(rgb,8,8,3)color(0.74,0.56,0.56,1,CO)"
		} },
		{ "SaddleBrown", "civ", {
			"#(rgb,8,8,3)color(0.55,0.27,0.07,1,CO)"
		} },
		{ "SandyBrown", "civ", {
			"#(rgb,8,8,3)color(0.96,0.64,0.38,1,CO)"
		} },
		{ "Beige", "civ", {
			"#(rgb,8,8,3)color(0.96,0.96,0.86,1,CO)"
		} },
		{ "Brown", "civ", {
			"#(rgb,8,8,3)color(0.65,0.16,0.16,1,CO)"
		} },
		{ "Burlywood", "civ", {
			"#(rgb,8,8,3)color(0.87,0.72,0.53,1,CO)"
		} },
		{ "Chocolate", "civ", {
			"#(rgb,8,8,3)color(0.55,0.27,0.07,1,CO)"
		} },
		{ "Peru", "civ", {
			"#(rgb,8,8,3)color(0.80,0.52,0.25,1,CO)"
		} },
		{ "Tan", "civ", {
			"#(rgb,8,8,3)color(0.82,0.71,0.55,1,CO)"
		} },
		{ "DarkSlateGray", "civ", {
			"#(rgb,8,8,3)color(0.18,0.31,0.31,1,CO)"
		} },
		{ "DimGray", "civ", {
			"#(rgb,8,8,3)color(0.41,0.41,0.41,1,CO)"
		} },
		{ "LightGray", "civ", {
			"#(rgb,8,8,3)color(0.83,0.83,0.83,1,CO)"
		} },
		{ "LightSlateGray", "civ", {
			"#(rgb,8,8,3)color(0.47,0.53,0.60,1,CO)"
		} },
		{ "Gray", "civ", {
			"#(rgb,8,8,3)color(0.75,0.75,0.75,1,CO)"
		} },
		{ "DarkGreen", "civ", {
			"#(rgb,8,8,3)color(0.0,0.39,0.0,1,CO)"
		} },
		{ "DarkKhaki", "civ", {
			"#(rgb,8,8,3)color(0.74,0.72,0.42,1,CO)"
		} },
		{ "DarkOliveGreen", "civ", {
			"#(rgb,8,8,3)color(0.33,0.42,0.18,1,CO)"
		} },
		{ "DarkSeaGreen", "civ", {
			"#(rgb,8,8,3)color(0.56,0.74,0.56,1,CO)"
		} },
		{ "ForestGreen", "civ", {
			"#(rgb,8,8,3)color(0.13,0.55,0.13,1,CO)"
		} },
		{ "GreenYellow", "civ", {
			"#(rgb,8,8,3)color(0.68,1.0,0.18,1,CO)"
		} },
		{ "LawnGreen", "civ", {
			"#(rgb,8,8,3)color(0.49,0.99,0.0,1,CO)"
		} },
		{ "LightGreen", "civ", {
			"#(rgb,8,8,3)color(0.56,0.93,0.56,1,CO)"
		} },
		{ "LightSeaGreen", "civ", {
			"#(rgb,8,8,3)color(0.13,0.70,0.67,1,CO)"
		} },
		{ "LimeGreen", "civ", {
			"#(rgb,8,8,3)color(0.20,0.80,0.20,1,CO)"
		} },
		{ "MediumSeaGreen", "civ", {
			"#(rgb,8,8,3)color(0.24,0.70,0.44,1,CO)"
		} },
		{ "MediumSpringGreen", "civ", {
			"#(rgb,8,8,3)color(0.0,0.98,0.60,1,CO)"
		} },
		{ "MintCream", "civ", {
			"#(rgb,8,8,3)color(0.96,1.0,0.98,1,CO)"
		} },
		{ "OliveDrab", "civ", {
			"#(rgb,8,8,3)color(0.42,0.56,0.14,1,CO)"
		} },
		{ "PaleGreen", "civ", {
			"#(rgb,8,8,3)color(0.60,0.98,0.60,1,CO)"
		} },
		{ "SeaGreen", "civ", {
			"#(rgb,8,8,3)color(0.18,0.55,0.34,1,CO)"
		} },
		{ "SpringGreen", "civ", {
			"#(rgb,8,8,3)color(0.0,1.0,0.50,1,CO)"
		} },
		{ "YellowGreen", "civ", {
			"#(rgb,8,8,3)color(0.60,0.80,0.20,1,CO)"
		} },
		{ "Chartreuse", "civ", {
			"#(rgb,8,8,3)color(0.50,1.0,0.0,1,CO)"
		} },
		{ "Green", "civ", {
			"#(rgb,8,8,3)color(0.0,1.0,0.0,1,CO)"
		} },
		{ "Khaki", "civ", {
			"#(rgb,8,8,3)color(0.55,0.53,0.31,1,CO)"
		} },
		{ "DarkOrange", "civ", {
			"#(rgb,8,8,3)color(1.0,0.55,0.0,1,CO)"
		} },
		{ "DarkSalmon", "civ", {
			"#(rgb,8,8,3)color(0.91,0.59,0.48,1,CO)"
		} },
		{ "LightCoral", "civ", {
			"#(rgb,8,8,3)color(0.94,0.50,0.50,1,CO)"
		} },
		{ "LightSalmon", "civ", {
			"#(rgb,8,8,3)color(1.0,0.63,0.48,1,CO)"
		} },
		{ "PeachPuff", "civ", {
			"#(rgb,8,8,3)color(1.0,0.85,0.73,1,CO)"
		} },
		{ "Bisque", "civ", {
			"#(rgb,8,8,3)color(1.0,0.89,0.77,1,CO)"
		} },
		{ "Coral", "civ", {
			"#(rgb,8,8,3)color(1.0,0.50,0.31,1,CO)"
		} },
		{ "Honeydew", "civ", {
			"#(rgb,8,8,3)color(0.94,1.0,0.94,1,CO)"
		} },
		{ "Orange", "civ", {
			"#(rgb,8,8,3)color(1.0,0.65,0.0,1,CO)"
		} },
		{ "Salmon", "civ", {
			"#(rgb,8,8,3)color(0.98,0.50,0.45,1,CO)"
		} },
		{ "Sienna", "civ", {
			"#(rgb,8,8,3)color(0.63,0.32,0.18,1,CO)"
		} },
		{ "DarkRed", "civ", {
			"#(rgb,8,8,3)color(0.55,0.0,0.0,1,CO)"
		} },
		{ "DeepPink", "civ", {
			"#(rgb,8,8,3)color(0.80,0.06,0.46,1,CO)"
		} },
		{ "HotPink", "civ", {
			"#(rgb,8,8,3)color(1.0,0.41,0.71,1,CO)"
		} },
		{ "IndianRed", "civ", {
			"#(rgb,8,8,3)color(0.80,0.36,0.36,1,CO)"
		} },
		{ "LightPink", "civ", {
			"#(rgb,8,8,3)color(1.0,0.71,0.76,1,CO)"
		} },
		{ "MediumVioletRed", "civ", {
			"#(rgb,8,8,3)color(0.78,0.08,0.52,1,CO)"
		} },
		{ "MistyRose", "civ", {
			"#(rgb,8,8,3)color(1.0,0.89,0.88,1,CO)"
		} },
		{ "OrangeRed", "civ", {
			"#(rgb,8,8,3)color(1.0,0.27,0.0,1,CO)"
		} },
		{ "PaleVioletRed", "civ", {
			"#(rgb,8,8,3)color(0.86,0.44,0.58,1,CO)"
		} },
		{ "VioletRed", "civ", {
			"#(rgb,8,8,3)color(0.82,0.13,0.56,1,CO)"
		} },
		{ "Firebrick", "civ", {
			"#(rgb,8,8,3)color(0.70,0.13,0.13,1,CO)"
		} },
		{ "Pink", "civ", {
			"#(rgb,8,8,3)color(1.0,0.75,0.80,1,CO)"
		} },
		{ "Red", "civ", {
			"#(rgb,8,8,3)color(1.0,0.0,0.0,1,CO)"
		} },
		{ "Tomato", "civ", {
			"#(rgb,8,8,3)color(1.0,0.39,0.28,1,CO)"
		} },
		{ "DarkMagenta", "civ", {
			"#(rgb,8,8,3)color(0.55,0.0,0.55,1,CO)"
		} },
		{ "DarkOrchid", "civ", {
			"#(rgb,8,8,3)color(0.60,0.20,0.80,1,CO)"
		} },
		{ "DarkViolet", "civ", {
			"#(rgb,8,8,3)color(0.58,0.0,0.83,1,CO)"
		} },
		{ "LavenderBlush", "civ", {
			"#(rgb,8,8,3)color(1.0,0.94,0.96,1,CO)"
		} },
		{ "MediumOrchid", "civ", {
			"#(rgb,8,8,3)color(0.73,0.33,0.83,1,CO)"
		} },
		{ "MediumPurple", "civ", {
			"#(rgb,8,8,3)color(0.58,0.44,0.86,1,CO)"
		} },
		{ "Lavender", "civ", {
			"#(rgb,8,8,3)color(0.90,0.90,0.98,1,CO)"
		} },
		{ "Magenta", "civ", {
			"#(rgb,8,8,3)color(1.0,0.0,1.0,1,CO)"
		} },
		{ "Maroon", "civ", {
			"#(rgb,8,8,3)color(0.69,0.19,0.38,1,CO)"
		} },
		{ "Orchid", "civ", {
			"#(rgb,8,8,3)color(0.85,0.44,0.84,1,CO)"
		} },
		{ "Plum", "civ", {
			"#(rgb,8,8,3)color(0.87,0.63,0.87,1,CO)"
		} },
		{ "Purple", "civ", {
			"#(rgb,8,8,3)color(0.63,0.13,0.94,1,CO)"
		} },
		{ "Thistle", "civ", {
			"#(rgb,8,8,3)color(0.85,0.75,0.85,1,CO)"
		} },
		{ "Violet", "civ", {
			"#(rgb,8,8,3)color(0.93,0.51,0.93,1,CO)"
		} },
		{ "AntiqueWhite", "civ", {
			"#(rgb,8,8,3)color(0.98,0.92,0.84,1,CO)"
		} },
		{ "Linen", "civ", {
			"#(rgb,8,8,3)color(0.98,0.94,0.90,1,CO)"
		} },
		{ "Snow", "civ", {
			"#(rgb,8,8,3)color(1.0,0.98,0.98,1,CO)"
		} },
		{ "White", "civ", {
			"#(rgb,8,8,3)color(1.0,1.0,1.0,1,CO)"
		} },
		{ "BlanchedAlmond", "civ", {
			"#(rgb,8,8,3)color(1.0,0.92,0.80,1,CO)"
		} },
		{ "DarkGoldenrod", "civ", {
			"#(rgb,8,8,3)color(0.72,0.53,0.04,1,CO)"
		} },
		{ "LemonChiffon", "civ", {
			"#(rgb,8,8,3)color(1.0,0.98,0.80,1,CO)"
		} },
		{ "LightGoldenrod", "civ", {
			"#(rgb,8,8,3)color(0.93,0.87,0.51,1,CO)"
		} },
		{ "LightGoldenrodYellow", "civ", {
			"#(rgb,8,8,3)color(0.98,0.98,0.82,1,CO)"
		} },
		{ "LightYellow", "civ", {
			"#(rgb,8,8,3)color(1.0,1.0,0.88,1,CO)"
		} },
		{ "PaleGoldenrod", "civ", {
			"#(rgb,8,8,3)color(0.93,0.91,0.67,1,CO)"
		} },
		{ "PapayaWhip", "civ", {
			"#(rgb,8,8,3)color(0.99,0.94,0.84,1,CO)"
		} },
		{ "Cornsilk", "civ", {
			"#(rgb,8,8,3)color(0.99,0.97,0.86,1,CO)"
		} },
		{ "Gold", "civ", {
			"#(rgb,8,8,3)color(1.0,0.84,0.0,1,CO)"
		} },
		{ "Goldenrod", "civ", {
			"#(rgb,8,8,3)color(0.85,0.65,0.13,1,CO)"
		} },
		{ "Moccasin", "civ", {
			"#(rgb,8,8,3)color(1.0,0.89,0.71,1,CO)"
		} },
		{ "Moccasin", "civ", {
			"#(rgb,8,8,3)color(1.0,1.0,0.0,1,CO)"
		} }
	};
};
//FarbenCOP
class Colorscop {
	textures[] = {
		{ "Schwarz", "cop", {
			"#(argb,8,8,3)color(0,0,0,1.0,CO)"
		} },
		{ "Weiß", "cop", {
			"#(argb,8,8,3)color(1,1,1,1.0,CO)"
		} },
		{ "Grau", "cop", {
			"#(argb,8,8,3)color(0.521569,0.521569,0.521569,1.0,CO)"
		} },
		{ "Grau Blau", "cop", {
			"#(argb,8,8,3)color(0.537255,0.647059,0.811765,1.0,CO)"
		} },
		{ "Dunkelblaues Grau", "cop", {
			"#(argb,8,8,3)color(0.278431,0.427451,0.713725,1.0,CO)"
		} },
		{ "Hellblau", "cop", {
			"#(argb,8,8,3)color(0.192157,0.556863,0.968627,1.0,CO)"
		} },
		{ "Blau", "cop", {
			"#(argb,8,8,3)color(0.0352941,0.415686,0.882353,1.0,CO)"
		} },
		{ "Dunkelblau", "cop", {
			"#(argb,8,8,3)color(0.0235294,0.12549,0.592157,1.0,CO)"
		} },
		{ "Türkisblau", "cop", {
			"#(argb,8,8,3)color(0,0.717647,0.717647,1.0,CO)"
		} },
		{ "Hellrot", "cop", {
			"#(argb,8,8,3)color(0.992157,0.258824,0.258824,1.0,CO)"
		} },
		{ "Rot", "cop", {
			"#(argb,8,8,3)color(0.843137,0,0,1.0,CO)"
		} },
		{ "Dunkelrot", "cop", {
			"#(argb,8,8,3)color(0.466667,0,0,1.0,CO)"
		} },
		{ "Bordeauxrot", "cop", {
			"#(argb,8,8,3)color(0.517647,0.0156863,0.027451,1.0,CO)"
		} },
		{ "Hellgrün", "cop", {
			"#(argb,8,8,3)color(0.270588,0.862745,0.345098,1.0,CO)"
		} },
		{ "Grün", "cop", {
			"#(argb,8,8,3)color(0.105882,0.545098,0.156863,1.0,CO)"
		} },
		{ "Dunkelgrün", "cop", {
			"#(argb,8,8,3)color(0.0509804,0.266667,0.0784314,1.0,CO)"
		} },
		{ "Grüne Limette", "cop", {
			"#(argb,8,8,3)color(0.65098,0.996078,0.00392157,1.0,CO)"
		} },
		{ "Khaki", "cop", {
			"#(argb,8,8,3)color(0.392157,0.447059,0.180392,1.0,CO)"
		} },
		{ "Gelb", "cop", {
			"#(argb,8,8,3)color(0.917647,0.886275,0.356863,1.0,CO)"
		} },
		{ "Orange", "cop", {
			"#(argb,8,8,3)color(0.921569,0.435294,0.137255,1.0,CO)"
		} },
		{ "Ton", "cop", {
			"#(argb,8,8,3)color(0.788235,0.427451,0.380392,1.0,CO)"
		} },
		{ "Braun", "cop", {
			"#(argb,8,8,3)color(0.713725,0.517647,0.305882,1.0,CO)"
		} },
		{ "Dunkelbraun", "cop", {
			"#(argb,8,8,3)color(0.407843,0.290196,0.168627,1.0,CO)"
		} },
		{ "Pink", "cop", {
			"#(argb,8,8,3)color(0.972549,0.470588,0.756863,1.0,CO)"
		} },
		{ "Dunkelpink", "cop", {
			"#(argb,8,8,3)color(0.713725,0.32549,0.843137,1.0,CO)"
		} },
		{ "Lavendel", "cop", {
			"#(argb,8,8,3)color(0.717647,0.662745,0.960784,1.0,CO)"
		} },
		{ "Violett", "cop", {
			"#(argb,8,8,3)color(0.392157,0.0431373,0.67451,1.0,CO)"
		} },
		{ "AliceBlue", "cop", {
			"#(rgb,8,8,3)color(0.94,0.97,1.0,1.0,CO)"
		} },
		{ "BlueViolet", "cop", {
			"#(rgb,8,8,3)color(0.54,0.17,0.89,1.0,CO)"
		} },
		{ "CadetBlue", "cop", {
			"#(rgb,8,8,3)color(0.37,0.62,0.63,1.0,CO)"
		} },
		{ "CornflowerBlue", "cop", {
			"#(rgb,8,8,3)color(0.39,0.58,0.93,1.0,CO)"
		} },
		{ "DarkBlue", "cop", {
			"#(rgb,8,8,3)color(0.0,0.0,0.55,1.0,CO)"
		} },
		{ "DarkCyan", "cop", {
			"#(rgb,8,8,3)color(0.0,0.55,0.55,1.0,CO)"
		} },
		{ "DarkSlateBlue", "cop", {
			"#(rgb,8,8,3)color(0.28,0.24,0.55,1.0,CO)"
		} },
		{ "DarkTurquoise", "cop", {
			"#(rgb,8,8,3)color(0.0,0.81,0.82,1.0,CO)"
		} },
		{ "DeepSkyBlue", "cop", {
			"#(rgb,8,8,3)color(0.0,0.75,1.0,1.0,CO)"
		} },
		{ "DodgerBlue", "cop", {
			"#(rgb,8,8,3)color(0.12,0.56,1.0,1.0,CO)"
		} },
		{ "LightBlue", "cop", {
			"#(rgb,8,8,3)color(0.68,0.85,0.90,1.0,CO)"
		} },
		{ "LightCyan", "cop", {
			"#(rgb,8,8,3)color(0.88,1.0,1.0,1,CO)"
		} },
		{ "LightSkyBlue", "cop", {
			"#(rgb,8,8,3)color(0.53,0.81,0.98,1,CO)"
		} },
		{ "LightSlateBlue", "cop", {
			"#(rgb,8,8,3)color(0.52,0.44,1.0,1,CO)"
		} },
		{ "LightSteelBlue", "cop", {
			"#(rgb,8,8,3)color(0.69,0.77,0.87,1,CO)"
		} },
		{ "MediumAquamarine", "cop", {
			"#(rgb,8,8,3)color(0.40,0.80,0.67,1,CO)"
		} },
		{ "MediumBlue", "cop", {
			"#(rgb,8,8,3)color(0.0,0.0,0.80,1,CO)"
		} },
		{ "MediumSlateBlue", "cop", {
			"#(rgb,8,8,3)color(0.48,0.41,0.93,1,CO)"
		} },
		{ "MediumTurquoise", "cop", {
			"#(rgb,8,8,3)color(0.28,0.82,0.80,1,CO)"
		} },
		{ "MidnightBlue", "cop", {
			"#(rgb,8,8,3)color(0.10,0.10,0.44,1,CO)"
		} },
		{ "NavyBlue", "cop", {
			"#(rgb,8,8,3)color(0.0,0.0,0.50,1,CO)"
		} },
		{ "PaleTurquoise", "cop", {
			"#(rgb,8,8,3)color(0.69,0.93,0.93,1,CO)"
		} },
		{ "PowderBlue", "cop", {
			"#(rgb,8,8,3)color(0.69,0.88,0.90,1,CO)"
		} },
		{ "RoyalBlue", "cop", {
			"#(rgb,8,8,3)color(0.25,0.41,0.88,1,CO)"
		} },
		{ "SkyBlue", "cop", {
			"#(rgb,8,8,3)color(0.53,0.81,0.92,1,CO)"
		} },
		{ "SlateBlue", "cop", {
			"#(rgb,8,8,3)color(0.42,0.35,0.80,1,CO)"
		} },
		{ "SteelBlue", "cop", {
			"#(rgb,8,8,3)color(0.27,0.51,0.71,1,CO)"
		} },
		{ "Aquamarine", "cop", {
			"#(rgb,8,8,3)color(0.50,1.0,0.83,1,CO)"
		} },
		{ "Azure", "cop", {
			"#(rgb,8,8,3)color(0.94,1.0,1.0,1,CO)"
		} },
		{ "Blue", "cop", {
			"#(rgb,8,8,3)color(0.0,0.0,1.0,1,CO)"
		} },
		{ "Cyan", "cop", {
			"#(rgb,8,8,3)color(0.0,1.0,1.0,1,CO)"
		} },
		{ "Navy", "cop", {
			"#(rgb,8,8,3)color(0.0,0.0,0.50,1,CO)"
		} },
		{ "Turquoise", "cop", {
			"#(rgb,8,8,3)color(0.25,0.88,0.82,1,CO)"
		} },
		{ "RosyBrown", "cop", {
			"#(rgb,8,8,3)color(0.74,0.56,0.56,1,CO)"
		} },
		{ "SaddleBrown", "cop", {
			"#(rgb,8,8,3)color(0.55,0.27,0.07,1,CO)"
		} },
		{ "SandyBrown", "cop", {
			"#(rgb,8,8,3)color(0.96,0.64,0.38,1,CO)"
		} },
		{ "Beige", "cop", {
			"#(rgb,8,8,3)color(0.96,0.96,0.86,1,CO)"
		} },
		{ "Brown", "cop", {
			"#(rgb,8,8,3)color(0.65,0.16,0.16,1,CO)"
		} },
		{ "Burlywood", "cop", {
			"#(rgb,8,8,3)color(0.87,0.72,0.53,1,CO)"
		} },
		{ "Chocolate", "cop", {
			"#(rgb,8,8,3)color(0.55,0.27,0.07,1,CO)"
		} },
		{ "Peru", "cop", {
			"#(rgb,8,8,3)color(0.80,0.52,0.25,1,CO)"
		} },
		{ "Tan", "cop", {
			"#(rgb,8,8,3)color(0.82,0.71,0.55,1,CO)"
		} },
		{ "DarkSlateGray", "cop", {
			"#(rgb,8,8,3)color(0.18,0.31,0.31,1,CO)"
		} },
		{ "DimGray", "cop", {
			"#(rgb,8,8,3)color(0.41,0.41,0.41,1,CO)"
		} },
		{ "LightGray", "cop", {
			"#(rgb,8,8,3)color(0.83,0.83,0.83,1,CO)"
		} },
		{ "LightSlateGray", "cop", {
			"#(rgb,8,8,3)color(0.47,0.53,0.60,1,CO)"
		} },
		{ "Gray", "cop", {
			"#(rgb,8,8,3)color(0.75,0.75,0.75,1,CO)"
		} },
		{ "DarkGreen", "cop", {
			"#(rgb,8,8,3)color(0.0,0.39,0.0,1,CO)"
		} },
		{ "DarkKhaki", "cop", {
			"#(rgb,8,8,3)color(0.74,0.72,0.42,1,CO)"
		} },
		{ "DarkOliveGreen", "cop", {
			"#(rgb,8,8,3)color(0.33,0.42,0.18,1,CO)"
		} },
		{ "DarkSeaGreen", "cop", {
			"#(rgb,8,8,3)color(0.56,0.74,0.56,1,CO)"
		} },
		{ "ForestGreen", "cop", {
			"#(rgb,8,8,3)color(0.13,0.55,0.13,1,CO)"
		} },
		{ "GreenYellow", "cop", {
			"#(rgb,8,8,3)color(0.68,1.0,0.18,1,CO)"
		} },
		{ "LawnGreen", "cop", {
			"#(rgb,8,8,3)color(0.49,0.99,0.0,1,CO)"
		} },
		{ "LightGreen", "cop", {
			"#(rgb,8,8,3)color(0.56,0.93,0.56,1,CO)"
		} },
		{ "LightSeaGreen", "cop", {
			"#(rgb,8,8,3)color(0.13,0.70,0.67,1,CO)"
		} },
		{ "LimeGreen", "cop", {
			"#(rgb,8,8,3)color(0.20,0.80,0.20,1,CO)"
		} },
		{ "MediumSeaGreen", "cop", {
			"#(rgb,8,8,3)color(0.24,0.70,0.44,1,CO)"
		} },
		{ "MediumSpringGreen", "cop", {
			"#(rgb,8,8,3)color(0.0,0.98,0.60,1,CO)"
		} },
		{ "MintCream", "cop", {
			"#(rgb,8,8,3)color(0.96,1.0,0.98,1,CO)"
		} },
		{ "OliveDrab", "cop", {
			"#(rgb,8,8,3)color(0.42,0.56,0.14,1,CO)"
		} },
		{ "PaleGreen", "cop", {
			"#(rgb,8,8,3)color(0.60,0.98,0.60,1,CO)"
		} },
		{ "SeaGreen", "cop", {
			"#(rgb,8,8,3)color(0.18,0.55,0.34,1,CO)"
		} },
		{ "SpringGreen", "cop", {
			"#(rgb,8,8,3)color(0.0,1.0,0.50,1,CO)"
		} },
		{ "YellowGreen", "cop", {
			"#(rgb,8,8,3)color(0.60,0.80,0.20,1,CO)"
		} },
		{ "Chartreuse", "cop", {
			"#(rgb,8,8,3)color(0.50,1.0,0.0,1,CO)"
		} },
		{ "Green", "cop", {
			"#(rgb,8,8,3)color(0.0,1.0,0.0,1,CO)"
		} },
		{ "Khaki", "cop", {
			"#(rgb,8,8,3)color(0.55,0.53,0.31,1,CO)"
		} },
		{ "DarkOrange", "cop", {
			"#(rgb,8,8,3)color(1.0,0.55,0.0,1,CO)"
		} },
		{ "DarkSalmon", "cop", {
			"#(rgb,8,8,3)color(0.91,0.59,0.48,1,CO)"
		} },
		{ "LightCoral", "cop", {
			"#(rgb,8,8,3)color(0.94,0.50,0.50,1,CO)"
		} },
		{ "LightSalmon", "cop", {
			"#(rgb,8,8,3)color(1.0,0.63,0.48,1,CO)"
		} },
		{ "PeachPuff", "cop", {
			"#(rgb,8,8,3)color(1.0,0.85,0.73,1,CO)"
		} },
		{ "Bisque", "cop", {
			"#(rgb,8,8,3)color(1.0,0.89,0.77,1,CO)"
		} },
		{ "Coral", "cop", {
			"#(rgb,8,8,3)color(1.0,0.50,0.31,1,CO)"
		} },
		{ "Honeydew", "cop", {
			"#(rgb,8,8,3)color(0.94,1.0,0.94,1,CO)"
		} },
		{ "Orange", "cop", {
			"#(rgb,8,8,3)color(1.0,0.65,0.0,1,CO)"
		} },
		{ "Salmon", "cop", {
			"#(rgb,8,8,3)color(0.98,0.50,0.45,1,CO)"
		} },
		{ "Sienna", "cop", {
			"#(rgb,8,8,3)color(0.63,0.32,0.18,1,CO)"
		} },
		{ "DarkRed", "cop", {
			"#(rgb,8,8,3)color(0.55,0.0,0.0,1,CO)"
		} },
		{ "DeepPink", "cop", {
			"#(rgb,8,8,3)color(0.80,0.06,0.46,1,CO)"
		} },
		{ "HotPink", "cop", {
			"#(rgb,8,8,3)color(1.0,0.41,0.71,1,CO)"
		} },
		{ "IndianRed", "cop", {
			"#(rgb,8,8,3)color(0.80,0.36,0.36,1,CO)"
		} },
		{ "LightPink", "cop", {
			"#(rgb,8,8,3)color(1.0,0.71,0.76,1,CO)"
		} },
		{ "MediumVioletRed", "cop", {
			"#(rgb,8,8,3)color(0.78,0.08,0.52,1,CO)"
		} },
		{ "MistyRose", "cop", {
			"#(rgb,8,8,3)color(1.0,0.89,0.88,1,CO)"
		} },
		{ "OrangeRed", "cop", {
			"#(rgb,8,8,3)color(1.0,0.27,0.0,1,CO)"
		} },
		{ "PaleVioletRed", "cop", {
			"#(rgb,8,8,3)color(0.86,0.44,0.58,1,CO)"
		} },
		{ "VioletRed", "cop", {
			"#(rgb,8,8,3)color(0.82,0.13,0.56,1,CO)"
		} },
		{ "Firebrick", "cop", {
			"#(rgb,8,8,3)color(0.70,0.13,0.13,1,CO)"
		} },
		{ "Pink", "cop", {
			"#(rgb,8,8,3)color(1.0,0.75,0.80,1,CO)"
		} },
		{ "Red", "cop", {
			"#(rgb,8,8,3)color(1.0,0.0,0.0,1,CO)"
		} },
		{ "Tomato", "cop", {
			"#(rgb,8,8,3)color(1.0,0.39,0.28,1,CO)"
		} },
		{ "DarkMagenta", "cop", {
			"#(rgb,8,8,3)color(0.55,0.0,0.55,1,CO)"
		} },
		{ "DarkOrchid", "cop", {
			"#(rgb,8,8,3)color(0.60,0.20,0.80,1,CO)"
		} },
		{ "DarkViolet", "cop", {
			"#(rgb,8,8,3)color(0.58,0.0,0.83,1,CO)"
		} },
		{ "LavenderBlush", "cop", {
			"#(rgb,8,8,3)color(1.0,0.94,0.96,1,CO)"
		} },
		{ "MediumOrchid", "cop", {
			"#(rgb,8,8,3)color(0.73,0.33,0.83,1,CO)"
		} },
		{ "MediumPurple", "cop", {
			"#(rgb,8,8,3)color(0.58,0.44,0.86,1,CO)"
		} },
		{ "Lavender", "cop", {
			"#(rgb,8,8,3)color(0.90,0.90,0.98,1,CO)"
		} },
		{ "Magenta", "cop", {
			"#(rgb,8,8,3)color(1.0,0.0,1.0,1,CO)"
		} },
		{ "Maroon", "cop", {
			"#(rgb,8,8,3)color(0.69,0.19,0.38,1,CO)"
		} },
		{ "Orchid", "cop", {
			"#(rgb,8,8,3)color(0.85,0.44,0.84,1,CO)"
		} },
		{ "Plum", "cop", {
			"#(rgb,8,8,3)color(0.87,0.63,0.87,1,CO)"
		} },
		{ "Purple", "cop", {
			"#(rgb,8,8,3)color(0.63,0.13,0.94,1,CO)"
		} },
		{ "Thistle", "cop", {
			"#(rgb,8,8,3)color(0.85,0.75,0.85,1,CO)"
		} },
		{ "Violet", "cop", {
			"#(rgb,8,8,3)color(0.93,0.51,0.93,1,CO)"
		} },
		{ "AntiqueWhite", "cop", {
			"#(rgb,8,8,3)color(0.98,0.92,0.84,1,CO)"
		} },
		{ "Linen", "cop", {
			"#(rgb,8,8,3)color(0.98,0.94,0.90,1,CO)"
		} },
		{ "Snow", "cop", {
			"#(rgb,8,8,3)color(1.0,0.98,0.98,1,CO)"
		} },
		{ "White", "cop", {
			"#(rgb,8,8,3)color(1.0,1.0,1.0,1,CO)"
		} },
		{ "BlanchedAlmond", "cop", {
			"#(rgb,8,8,3)color(1.0,0.92,0.80,1,CO)"
		} },
		{ "DarkGoldenrod", "cop", {
			"#(rgb,8,8,3)color(0.72,0.53,0.04,1,CO)"
		} },
		{ "LemonChiffon", "cop", {
			"#(rgb,8,8,3)color(1.0,0.98,0.80,1,CO)"
		} },
		{ "LightGoldenrod", "cop", {
			"#(rgb,8,8,3)color(0.93,0.87,0.51,1,CO)"
		} },
		{ "LightGoldenrodYellow", "cop", {
			"#(rgb,8,8,3)color(0.98,0.98,0.82,1,CO)"
		} },
		{ "LightYellow", "cop", {
			"#(rgb,8,8,3)color(1.0,1.0,0.88,1,CO)"
		} },
		{ "PaleGoldenrod", "cop", {
			"#(rgb,8,8,3)color(0.93,0.91,0.67,1,CO)"
		} },
		{ "PapayaWhip", "cop", {
			"#(rgb,8,8,3)color(0.99,0.94,0.84,1,CO)"
		} },
		{ "Cornsilk", "cop", {
			"#(rgb,8,8,3)color(0.99,0.97,0.86,1,CO)"
		} },
		{ "Gold", "cop", {
			"#(rgb,8,8,3)color(1.0,0.84,0.0,1,CO)"
		} },
		{ "Goldenrod", "cop", {
			"#(rgb,8,8,3)color(0.85,0.65,0.13,1,CO)"
		} },
		{ "Moccasin", "cop", {
			"#(rgb,8,8,3)color(1.0,0.89,0.71,1,CO)"
		} },
		{ "Moccasin", "cop", {
			"#(rgb,8,8,3)color(1.0,1.0,0.0,1,CO)"
		} }
	};
};//FarbenMED
class Colorsmed {
	textures[] = {
		{ "Gelb", "civ", {
			"#(argb,8,8,3)color(0.917647,0.886275,0.356863,1.0,CO)"
		} }
	};
};
class LifeCfgVehicles {
    /*
    *    Vehicle Configs (Contains textures and other stuff)
    *
    *    "price" is the price before any multipliers set in Master_Config are applied.
    *
    *    Default Multiplier Values & Calculations:
    *       Civilian [Purchase, Sell]: [1.0, 0.5]
    *       Cop [Purchase, Sell]: [0.5, 0.5]
    *       Medic [Purchase, Sell]: [0.75, 0.5]
    *       ChopShop: Payout = price * 0.25
    *       GarageSell: Payout = price * [0.5, 0.5, 0.5, -1]
    *       Cop Impound: Payout = price * 0.1
    *       Pull Vehicle from Garage: Cost = price * [1, 0.5, 0.75, -1] * [0.5, 0.5, 0.5, -1]
    *           -- Pull Vehicle & GarageSell Array Explanation = [civ,cop,medic,east]
    *
    *       1: STRING (Condition)
    *    Textures config follows { Texture Name, side, {texture(s)path}, Condition}
    *    Texture(s)path follows this format:
    *    INDEX 0: Texture Layer 0
    *    INDEX 1: Texture Layer 1
    *    INDEX 2: Texture Layer 2
    *    etc etc etc
    *
    */
    class Default {
        vItemSpace = 100;
        conditions = "";
        price = -1;
        textures[] = {};
    };
	//MEDIC
	class d3s_charger_15_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_fpace_17_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_titan_17_TAR {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_savana_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_uaz_3165M_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_raptor_EMS_17 {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_uaz_3162_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_fseries_17_TOW : Colorsmed {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
	};
	class d3s_tahoe_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_vklasse_17_EMS {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	class d3s_explorer_EMS_13 {
		vItemSpace = 100;
		conditions ="";
		price = 25000;
		textures[] = {};
	};
	//COPS
	class d3s_fseries_17_P3E {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
		textures[] = {};
	};
	class d3s_g63amg_16_FSB : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_raptor_UNM_17 : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_gl63amg_12_FSB : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_200_16_FSB : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_teslaS_16_Mark_42 : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_ctsv_16_unm : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_taurus_UNM_10 : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_f86_15_UNM : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_tahoe_UNM : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_malibu_18_UNM : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_explorer_UNM_13 : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_durango_18_UNM : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_vklasse_17_UNM : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_urus_FSB_12 : Colorscop {
		vItemSpace = 100;
		conditions ="";
		price = 60000;
	};
	class d3s_f90_18_PD {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_crown_98_PD {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_charger_15_CPP {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_FPIU_13 {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_raptor_PRP_17 {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_g63amg_16_Police {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_tahoe_PPV {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_fpace_17_COP {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_vklasse_17_COP {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	class d3s_e400_16_COP {
		vItemSpace = 100;
		conditions ="";
		price = 30000;
		textures[] = {};
	};
	//Zivilisten
	class d3s_giulia_quad_16 : Colors {
		vItemSpace = 48;
		conditions ="";
		price = 79000;
	};
	class d3s_crown_98 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 15000;
	};
	class d3s_oka : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 500;
	};
	class d3s_h2_02 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 59900;
	};
	class d3s_300C_12 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 56000;
	};
	class d3s_300S_12 : d3s_300C_12 {};
	class d3s_fiesta_16 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 22500;
	};
	class d3s_fiesta_16_H : d3s_fiesta_16 {};
	class d3s_vesta_15_turbo : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 31500;
	};
	class d3s_vesta_15 : d3s_vesta_15_turbo {};
	class d3s_amazing_a45_16 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 45000;
	};
	class d3s_amazing_a45_16_EX : d3s_amazing_a45_16 {};
	class d3s_amazing_a45_16_AMG : d3s_amazing_a45_16 {};
	class d3s_cla_15 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 55000;
	};
	class d3s_cla_14 : d3s_cla_15 {};
	class d3s_cla_220_15 : d3s_cla_15 {};
	class d3s_cla_220_14 : d3s_cla_15 {};
	class d3s_cla_250_15 : d3s_cla_15 {};
	class d3s_cla_45amg_15 : d3s_cla_15 {};
	class d3s_cla_15_SE : d3s_cla_15 {};
	class d3s_cla_45amg_14 : d3s_cla_15 {};
	class d3s_skyline_02 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 75000;
	};
	class d3s_skyline_02_V : d3s_skyline_02 {};
	class d3s_wrx_sti_17 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 65000;
	};
	class d3s_wrx_17 : d3s_wrx_sti_17 {};
	class d3s_amazing_f82_16 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 65000;
	};
	class d3s_f80_14_GTS : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 55000;
	};
	class d3s_f87_17_m : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 55000;
	};
	class d3s_e38_98 : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 55000;
	};
	class d3s_f87_17_sport : Colors {
		vItemSpace = 15;
		conditions ="";
		price = 55000;
	};
    // Apex DLC
    class C_Boat_Transport_02_F {
        vItemSpace = 100;
        conditions = "license_civ_boat || {!(life_side isEqualTo civilian)}";
        price = 2200;
        textures[] = {
            { "Civilian", "civ", {
                "\A3\Boat_F_Exp\Boat_Transport_02\Data\Boat_Transport_02_exterior_civilian_CO.paa"
            }, "" },
            { "Black", "cop", {
                "\A3\Boat_F_Exp\Boat_Transport_02\Data\Boat_Transport_02_exterior_CO.paa"
            }, "" }
        };
    };
    // Apex DLC
    class C_Plane_Civil_01_F {
        vItemSpace = 75;
        conditions = "license_civ_pilot || {!(life_side isEqualTo civilian)}";
        price = 25000;
        textures[] = {
            { "Racing (Tan Interior)", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_Racer_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_Racer_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_tan_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_tan_co.paa"
            }, "" },
            { "Racing", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_Racer_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_Racer_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_co.paa"
            }, "" },
            { "Red Line (Tan Interior)", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_RedLine_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_RedLine_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_tan_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_tan_co.paa"
            }, "" },
            { "Red Line", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_RedLine_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_RedLine_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_co.paa"
            }, "" },
            { "Tribal (Tan Interior)", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_Tribal_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_Tribal_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_tan_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_tan_co.paa"
            }, "" },
            { "Tribal", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_Tribal_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_Tribal_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_co.paa"
            }, "" },
            { "Blue Wave (Tan Interior)", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_Wave_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_Wave_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_tan_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_tan_co.paa"
            }, "" },
            { "Blue Wave", "civ", {
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_01_Wave_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_ext_02_Wave_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_01_co.paa",
                "A3\Air_F_Exp\Plane_Civil_01\Data\btt_int_02_co.paa"
            }, "" }
        };
    };
    // Apex DLC
    class C_Scooter_Transport_01_F {
        vItemSpace = 30;
        conditions = "license_civ_boat || {!(life_side isEqualTo civilian)}";
        price = 2500;
        textures[] = {
            { "Black", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_Black_CO.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_Black_CO.paa"
            }, "" },
            { "Blue", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_Blue_co.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_Blue_co.paa"
            }, "" },
            { "Grey", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_Grey_co.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_Grey_co.paa"
            }, "" },
            { "Green", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_Lime_co.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_Lime_co.paa"
            }, "" },
            { "Red", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_Red_CO.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_CO.paa"
            }, "" },
            { "White", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_CO.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_CO.paa"
            }, "" },
            { "Yellow", "civ", {
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_Yellow_CO.paa",
                "\A3\Boat_F_Exp\Scooter_Transport_01\Data\Scooter_Transport_01_VP_Yellow_CO.paa"
            }, "" }
        };
    };
    class C_Rubberboat {
        vItemSpace = 45;
        conditions = "license_civ_boat || {!(life_side isEqualTo civilian)}";
        price = 5000;
        textures[] = { };
    };
    class B_Heli_Transport_01_F {
        vItemSpace = 200;
        conditions = "license_cop_cAir || {!(life_side isEqualTo west)}";
        price = 20000;
        textures[] = {};
    };
    class MELB_MH6M {
        vItemSpace = 200;
        conditions = "license_cop_cAir || {!(life_side isEqualTo west)}";
        price = 100000;
        textures[] = {};
    };
    class B_Boat_Armed_01_minigun_F {
        vItemSpace = 175;
        conditions = "license_cop_cg || {!(life_side isEqualTo west)}";
        price = 7500;
        textures[] = { };
    };
    class B_Boat_Transport_01_F {
        vItemSpace = 45;
        conditions = "license_cop_cg || {!(life_side isEqualTo west)}";
        price = 3000;
        textures[] = { };
    };
    class Land_CargoBox_V1_F {
        vItemSpace = 5000;
        conditions = "";
        price = -1;
        textures[] = {};
    };
    class Box_IND_Grenades_F {
        vItemSpace = 350;
        conditions = "";
        price = -1;
        textures[] = {};
    };
    class B_supplyCrate_F {
        vItemSpace = 700;
        conditions = "";
        price = -1;
        textures[] = {};
    };
    class B_G_Offroad_01_armed_F {
        vItemSpace = 65;
        conditions = "license_civ_rebel || {!(life_side isEqualTo civilian)}";
        price = 75000;
        textures[] = { };
    };
    class C_Boat_Civil_01_F {
        vItemSpace = 85;
        conditions = "license_civ_boat || {!(life_side isEqualTo civilian)}";
        price = 10000;
        textures[] = { };
    };
    class C_Boat_Civil_01_police_F {
        vItemSpace = 85;
        conditions = "license_cop_cg || {!(life_side isEqualTo west)}";
        price = 20000;
        textures[] = { };
    };
    class C_Kart_01_Blu_F {
        vItemSpace = 20;
        conditions = "license_civ_driver || {!(life_side isEqualTo civilian)}";
        price = 15000;
        textures[] = {};
    };
	//AdminShop
	class d3s_boss_15_payback : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_boss_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_e60_09_ACS5 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_f87_17_ACH : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_f80_14_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_f82_14_LB : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_f90_18_FE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_f13_13_CE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_malibu_18_Prem : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_focus_17_LB : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_q50_14_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_xesv_17 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_xes_15_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_insurgent_gtav : Colors {
		vItemSpace = 250;
		conditions ="license_civ_rebel";
		price = 500000;
	};
	class d3s_willys : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class d3s_QUA_Regalia_23_D : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class Cardinal_Grinder : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class Chevrolet_Advance_1953 : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class Ford_Mainline_1954 : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class Ford_Model_B_1932 : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class Holden_Coupe_Utility_1951 : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class Righteous_Spike : d3s_insurgent_gtav { vItemSpace = 50; price = 45000; };
	class d3s_kuruma_gtaV : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_is_16_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_ghibli_esteso_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_ghibli_14_nerissimo : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_C63S_14_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_cla_14_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_clubman_11_50 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_coupeconcept_10 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_silvia_s15_02 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_ghost_18_EWB_III : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_novus_phantom_18_3 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_wrx_17_FnF8 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_vesta_15_EX : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_rapide_10_AMR : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_continentalGT_18_Black : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_continentalGT_18_FE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_camaro_zl1_1le_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_asterion_15_DMC : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_amgGTR_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_survolt_10 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_raptor_SCR_17 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_qx56_13_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_QX60_16_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_lm002_90 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_lm002_LT : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_g63amg_18_e1 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_gl63amg_12_SE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_cullinan_19_BB : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_cullinan_19_FE : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_Kawasaki_Ninja_H2R : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_Kawasaki_ZX7RR : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_Suzuki_GSX_R_1000 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_Suzuki_Hayabusa : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_srthellcat_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 72590;
	};
	class d3s_srthellcat_15_HELL : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 85000;
	};
	class d3s_f87_17 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 59500;
	};
	class d3s_f80_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 71500;
	};
	class d3s_f90_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 109000;
	};
	class d3s_f13_13 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 117500;
	};
	class d3s_charger_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 62300;
	};
	class d3s_BMW_S_1000_RR : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 20000;
	};
	class d3s_C43_16 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 61850;
	};
	class d3s_C63S_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 77588;
	};
	class d3s_C180_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 39500;
	};
	class d3s_C220_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 44500;
	};
	class d3s_C250_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 48900;
	};
	class d3s_C300_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 52000;
	};
	class d3s_C350_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 55000;
	};
	class d3s_C450_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 58000;
	};
	class d3s_e220_16 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 47000;
	};
	class d3s_e250_16 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 55000;
	};
	class d3s_e350_16 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 61000;
	};
	class d3s_e400_16 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 64800;
	};
	class d3s_s600_17 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 144000;
	};
	class d3s_s600_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 144000;
	};
	class d3s_beetle_04 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 15550;
	};
	class d3s_urus_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 360500;
	};
	class d3s_cullinan_19_II : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 514000;
	};
	class d3s_huracan_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 227000;
	};
	class d3s_veneno_13 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 1200000;
	};
	class d3s_mclaren_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 800000;
	};
	class d3s_amgGT_19_43 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 111500;
	};
	class d3s_amgGT_19_53 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 122500;
	};
	class d3s_amgGT_19_63 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 137500;
	};
	class d3s_amgGT_19_63S : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 157500;
	};
	class d3s_tuatara_19 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 960000;
	};
	class d3s_s560_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 175000;
	};
	class d3s_s650_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 200000;
	};
	class d3s_vv222_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 235500;
	};
	class d3s_vv222_18_2 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 253500;
	};
	class d3s_QUA_Regalia_23 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 253500;
	};
	class d3s_ghost_18_EWB : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 396500;
	};
	class d3s_ghost_18_EWB_II : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 432000;
	};
	class d3s_novus_phantom_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 636500;
	};
	class d3s_donkervoort_17_BNC : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 112500;
	};
	class d3s_donkervoort_17 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 100000;
	};
	class d3s_rapide_10 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 140000;
	};
	class d3s_camaro_ss_16 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 44700;
	};
	class d3s_continentalGT_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 153000;
	};
	class d3s_LaFerrari_14 : Colors {
		vItemSpace = 10;
		conditions ="";
		price = 494500;
	};
	class d3s_huracan_18_SPD_P : Colors {
		vItemSpace = 10;
		conditions ="";
		price = 494500;
	};
	class d3s_divo_19_P : Colors {
		vItemSpace = 10;
		conditions ="";
		price = 494500;
	};
	class d3s_veyron_12 : Colors {
		vItemSpace = 10;
		conditions ="";
		price = 494500;
	};
	class d3s_asterion_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 368000;
	};
	class d3s_alfieri_14 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 112500;
	};
	class d3s_amgGTS_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 127000;
	};
	class d3s_amgGT_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 112000;
	};
	class d3s_f85_15 : Colors {
		vItemSpace = 85;
		conditions ="";
		price = 110500;
	};
	class d3s_f86_15 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 118000;
	};
	class d3s_durango_18_SRT : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 98657;
	};
	class d3s_durango_18 : Colors {
		vItemSpace = 25;
		conditions ="";
		price = 53870;
	};
	class d3s_g63amg_16 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 129000;
	};
	class d3s_g63amg_18 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 129000;
	};
	class d3s_g65amg_16 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 188000;
	};
	class d3s_gle43amg_15 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 80000;
	};
	class d3s_gle63amg_15 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 115500;
	};
	class d3s_gle63amgS_15 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 120500;
	};
	class d3s_gls63amg_17 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 120000;
	};
	class d3s_g350d_15 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 103500;
	};
	class d3s_g500_15 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 163000;
	};
	class d3s_g500_18 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 163000;
	};
	class d3s_eqc_20 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 65000;
	};
	class d3s_eqc_20_4matic : d3s_eqc_20 {}; class d3s_eqc_20_400 : d3s_eqc_20 {};
	class d3s_teslaS_16_90 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 95000;
	};
	class d3s_teslaS_16_100 : d3s_teslaS_16_90 {}; class d3s_teslaS_16_85 : d3s_teslaS_16_90 {};
	class d3s_roadrunner_71_340 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 95000;
	};
	class d3s_roadrunner_71_440 : d3s_roadrunner_71_340 {}; class d3s_roadrunner_71_GTX : d3s_roadrunner_71_340 {};
	class d3s_e89_12 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 95000;
	};
	class d3s_e89_12_M : d3s_e89_12 {};
	class d3s_fseries_17 : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 95000;
	};
	class d3s_fseries_LTD_17 : d3s_fseries_17 {}; class d3s_fseries_PLT_17 : d3s_fseries_17 {}; class d3s_fseries_XLT_17 : d3s_fseries_17 {};
	class d3s_challenger_15_SP : Colors {
		vItemSpace = 50;
		conditions ="";
		price = 95000;
	};
	class d3s_challenger_15_RT : d3s_challenger_15_SP {}; class d3s_challenger_15_392 : d3s_challenger_15_SP {}; class d3s_challenger_15_DM : d3s_challenger_15_SP {}; class d3s_challenger_15_LW : d3s_challenger_15_SP {}; class d3s_challenger_15_WIDE : d3s_challenger_15_SP {}; class d3s_challenger_15_HELL : d3s_challenger_15_SP {}; class d3s_challenger_15 : d3s_challenger_15_SP {};
	class d3s_cayenne_s_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 91964;
	};
	class d3s_cayenne_turbo_s_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 126000;
	};
	class d3s_cayenne_turbo_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 119500;
	};
	class d3s_cayenne_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 74828;
	};
	class d3s_macan_s_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 58763;
	};
	class d3s_macan_turbo_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 80338;
	};
	class d3s_macan_16 : Colors {
		vItemSpace = 67;
		conditions ="";
		price = 58763;
	};
	//truck
	class d3s_savana_VAN : Colors {
		vItemSpace = 100;
		conditions ="";
		price = 15000;
	};
    class d3s_actros_14_big {
		vItemSpace = 600;
		conditions = "license_civ_trucking";
		price = 200000;
		textures[] = {};
	};
	class d3s_actros_14 {
		vItemSpace = 600;
		conditions = "license_civ_trucking";
		price = 200000;
		textures[] = { };
	};
	class d3s_actros_14_giga {
		vItemSpace = 600;
		conditions = "license_civ_trucking";
		price = 200000;
		textures[] = { };
	};
	class d3s_zil_130_05 {
		vItemSpace = 150;
		conditions = "license_civ_trucking";
		price = 40000;
		textures[] = { };
	};
	class d3s_zil_130_02 {
		vItemSpace = 200;
		conditions = "license_civ_trucking";
		price = 43000;
		textures[] = { };
	};
	class d3s_zil_130 {
		vItemSpace = 200;
		conditions = "license_civ_trucking";
		price = 40000;
		textures[] = { };
	};
	class d3s_zil_130_03 {
		vItemSpace = 200;
		conditions = "license_civ_trucking";
		price = 40000;
		textures[] = { };
	};
	class d3s_zil_130_01 {
		vItemSpace = 200;
		conditions = "license_civ_trucking";
		price = 40000;
		textures[] = { };
	};
	class d3s_zil_130_04 {
		vItemSpace = 170;
		conditions = "license_civ_trucking";
		price = 36000;
		textures[] = { };
	};
	class d3s_zil_130_06 {
		vItemSpace = 230;
		conditions = "license_civ_trucking";
		price = 45000;
		textures[] = { };
	};
	class d3s_zil_130_07 { vItemSpace = 230; conditions = "license_civ_trucking"; price = 45000;  textures[] = { }; };
	class d3s_kamaz_2 { vItemSpace = 350; conditions = "license_civ_trucking"; price = 68000;  textures[] = { }; };
	class d3s_kamaz_MAW_1 { vItemSpace = 350; conditions = "license_civ_trucking"; price = 68000;  textures[] = { }; };
	class d3s_kamaz_bocha { vItemSpace = 170; conditions = "license_civ_trucking"; price = 30000;  textures[] = { }; };
	class d3s_kamaz_bocha_MAW_1 { vItemSpace = 170; conditions = "license_civ_trucking"; price = 30000;  textures[] = { }; };
	class d3s_kamaz_tent_2 { vItemSpace = 420; conditions = "license_civ_trucking"; price = 70000;  textures[] = { }; };
	class d3s_kamaz_4310_med { vItemSpace = 420; conditions = "license_civ_trucking"; price = 70000;  textures[] = { }; };
	class d3s_kamaz { vItemSpace = 400; conditions = "license_civ_trucking"; price = 65000;  textures[] = { }; };
	class d3s_kamaz_kung { vItemSpace = 440; conditions = "license_civ_trucking"; price = 74000;  textures[] = { }; };
	class d3s_kamaz_tent { vItemSpace = 440; conditions = "license_civ_trucking"; price = 74000;  textures[] = { }; };
	class d3s_kamaz_tent2 { vItemSpace = 440; conditions = "license_civ_trucking"; price = 74000;  textures[] = { }; };
	class d3s_kamaz_4350 { vItemSpace = 400; conditions = "license_civ_trucking"; price = 63000;  textures[] = { }; };
	class d3s_kamaz_4350_kung { vItemSpace = 440; conditions = "license_civ_trucking"; price = 74000;  textures[] = { }; };
	class d3s_kamaz_4350_tent { vItemSpace = 440; conditions = "license_civ_trucking"; price = 76000;  textures[] = { }; };
	class d3s_kamaz_4350_tent2 { vItemSpace = 440; conditions = "license_civ_trucking"; price = 76000;  textures[] = { }; };
	class d3s_kamaz_5350 { vItemSpace = 460; conditions = "license_civ_trucking"; price = 80000;  textures[] = { }; };
	class d3s_kamaz_5350_bocha { vItemSpace = 170; conditions = "license_civ_trucking"; price = 30000;  textures[] = { }; };
	class d3s_kamaz_5350_tent { vItemSpace = 490; conditions = "license_civ_trucking"; price = 90000;  textures[] = { }; };
	class d3s_kamaz_6350 { vItemSpace = 580; conditions = "license_civ_trucking"; price = 150000;  textures[] = { }; };
	class d3s_nemises_kraz_6316 { vItemSpace = 600; conditions = "license_civ_trucking"; price = 170000;  textures[] = { }; };
	class d3s_nemises_next_tent { vItemSpace = 600; conditions = "license_civ_trucking"; price = 170000;  textures[] = { }; };
    class C_Kart_01_Fuel_F : C_Kart_01_Blu_F{}; // Get all information of C_Kart_01_Blu_F
    class C_Kart_01_Red_F : C_Kart_01_Blu_F{};
    class C_Kart_01_Vrana_F : C_Kart_01_Blu_F{};
    class B_Heli_Light_01_stripped_F {
        vItemSpace = 90;
        conditions = "license_civ_rebel || {!(life_side isEqualTo civilian)";
        price = 90000;
        textures[] = {
            { "Rebel Digital", "reb", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_digital_co.paa"
            }, "" }
        };
    };
    class B_Heli_Light_01_F {
        vItemSpace = 90;
        conditions = "license_civ_pilot || {license_cop_cAir} || {license_med_mAir}";
        price = 90000;
        textures[] = {
            { "Sheriff", "cop", {
                "\pi_asset\textures\hummingbird.paa"
            }, "" },
            { "Civ Blue", "civ", {
                "\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_blue_co.paa"
            }, "" },
            { "Civ Red", "civ", {
                "\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_co.paa"
            }, "" },
            { "Blueline", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_blueline_co.paa"
            }, "" },
            { "Elliptical", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_elliptical_co.paa"
            }, "" },
            { "Furious", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_furious_co.paa"
            }, "" },
            { "Jeans Blue", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_jeans_co.paa"
            }, "" },
            { "Speedy Redline", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_speedy_co.paa"
            }, "" },
            { "Sunset", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_sunset_co.paa"
            }, "" },
            { "Vrana", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_vrana_co.paa"
            }, "" },
            { "Waves Blue", "civ", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_wave_co.paa"
            }, "" },
            { "Rebel Digital", "reb", {
                "\a3\air_f\Heli_Light_01\Data\Skins\heli_light_01_ext_digital_co.paa"
            }, "" },
            { "Digi Green", "reb", {
                "\a3\air_f\Heli_Light_01\Data\heli_light_01_ext_indp_co.paa"
            }, "" },
            { "EMS White", "med", {
                "\pi_asset\skins\medic_hummingbird.paa"
            }, "" }
        };
    };
    class C_Heli_Light_01_civil_F : B_Heli_Light_01_F {
        vItemSpace = 75;
        price = 90000;
    };
    class O_Heli_Light_02_unarmed_F {
        vItemSpace = 210;
        conditions = "license_civ_pilot || {license_med_mAir} || {(life_side isEqualTo west)}";
        price = 150000;
        textures[] = {
            { "Black", "cop", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_co.paa"
            }, "" },
            { "White / Blue", "civ", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_civilian_co.paa"
            }, "" },
            { "Digi Green", "civ", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_indp_co.paa"
            }, "" },
            { "Desert Digi", "reb", {
                "\a3\air_f\Heli_Light_02\Data\heli_light_02_ext_opfor_co.paa"
            }, "" },
            { "EMS White", "med", {
                "#(argb,8,8,3)color(1,1,1,0.8)"
            }, "" }
        };
    };
    class B_SDV_01_F {
        vItemSpace = 50;
        conditions = "license_civ_boat || {license_cop_cg} || {(life_side isEqualTo independent)}";
        price = 15000;
        textures[] = {};
    };
};
