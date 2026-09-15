////////////////////////////////////////////////////////
// Authors: Kureo & Zalac                             //
// Credit: Danny									  //
////////////////////////////////////////////////////////
class new_HUD {
	idd = 20099;
	duration = 1e+1000;
	movingEnable = 0;
	fadein = 0;
	fadeout = 0;
	name = "playerHUD";
	onLoad = "uiNamespace setVariable ['playerHUD',_this select 0]";
	objects[] = {};
	class controlsBackground {
		// HUD Dx
		
		class BarraSfondoVita: Life_RscText {
			colorBackground[] = {0.06,0.06,0.06,0.8};
			idc = -1;
			text = "";
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.749 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class BarraSfondoFame: Life_RscText {
			colorBackground[] = {0.06,0.06,0.06,0.8};
			idc = -1;
			text = "";
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.813624 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class BarraSfondoSete: Life_RscText {
			colorBackground[] = {0.06,0.06,0.06,0.8};
			idc = -1;
			text = "";
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.88081 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class Vita_HUD: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\health.paa";
			x = 0.883312 * safezoneW + safezoneX;
			y = 0.737 * safezoneH + safezoneY;
			w = 0.02751 * safezoneW;
			h = 0.049 * safezoneH;
		};
		class Fame_HUD: Life_RscPicture {
			idc = -1;
			text = "pi_data\hud\food.paa";
			x = 0.883312 * safezoneW + safezoneX;
			y = 0.803 * safezoneH + safezoneY;
			w = 0.02751 * safezoneW;
			h = 0.049 * safezoneH;
		};
		class Sete_HUD: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\water.paa";
			x = 0.883312 * safezoneW + safezoneX;
			y = 0.869 * safezoneH + safezoneY;
			w = 0.02751 * safezoneW;
			h = 0.049 * safezoneH;
		};
		class Info_Progress_Salute: Life_RscProgress {
			idc = 1;
			onLoad = "(_this select 0) progressSetPosition 1";
			colorBar[] = {1,0,0,1};
			colorFrame[] = {0,0,0,1};
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.749 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class Info_Progress_Fame: Life_RscProgress {
			idc = 2;
			onLoad = "(_this select 0) progressSetPosition 1";
			colorBar[] = {1,0.4,0,1};
			colorFrame[] = {0,0,0,1};
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.813624 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class Info_Progress_Sete: Life_RscProgress {
			idc = 3;
			onLoad = "(_this select 0) progressSetPosition 1";
			colorBar[] = {0.6,0.8,0.9,1};
			colorFrame[] = {0,0,0,1};
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.88081 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
	};
	class controls {
		class Nav_Hud: Life_RscStructuredText {
			idc = 30;
			text = "";
			x = 0.34 * safezoneW + safezoneX;
			y = 0.955 * safezoneH + safezoneY;
			w = 0.32 * safezoneW;
			h = 0.035 * safezoneH;
			colorBackground[] = {0, 0, 0, 0};
		};
		class Info_Salute: Life_RscText {
			colorBackground[] = {0.06,0.06,0.06,0};
			idc = 4;
			text = "100%";
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.749 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class Info_Fame: Life_RscText {
			colorBackground[] = {0.06,0.06,0.06,0};
			idc = 5;
			text = "100%";
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.813624 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		class Info_Sete: Life_RscText {
			colorBackground[] = {0.06,0.06,0.06,0};
			idc = 6;
			text = "100%";
			x = 0.912312 * safezoneW + safezoneX;
			y = 0.88081 * safezoneH + safezoneY;
			w = 0.0864 * safezoneW;
			h = 0.0275 * safezoneH;
		};
		// HUD Sx
		class Banca_Icon: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\bank.paa";
		    x = 0.85699097 * safezoneW + safezoneX;
		    y = 0.932 * safezoneH + safezoneY;
			w = 0.01796 * safezoneW;
			h = 0.032 * safezoneH;
		};
		class Banca_Hud: Life_RscText {
			idc = 7;
			text = ""; 
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.06,0.06,0.06,0.8};
			x = 0.87607012 * safezoneW + safezoneX;
			y = 0.938 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Cash_Icon: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\cash.paa";
			x = 0.928813 * safezoneW + safezoneX;
			y = 0.932 * safezoneH + safezoneY;
			w = 0.01796 * safezoneW;
			h = 0.032 * safezoneH;
		};
		class Cash_Hud: Life_RscText {
			idc = 8;
			text = ""; 
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.06,0.06,0.06,0.8};
			x = 0.947281 * safezoneW + safezoneX;
			y = 0.938 * safezoneH + safezoneY;
			w = 0.0515625 * safezoneW;
			h = 0.022 * safezoneH;
		};
		class Polizia_Icon: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\cop.paa";
			x = 0.84499997 * safezoneW + safezoneX;
			y = 0.97 * safezoneH + safezoneY;
			w = 0.01459 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class Polizia_Hud: Life_RscText {
			idc = 9;
			text = "7";
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.06,0.06,0.06,0.8};
			x = 0.8593125 * safezoneW + safezoneX;
			y = 0.973 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class Medici_Icon: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\med.paa";
			x = 0.8965625 * safezoneW + safezoneX;
			y = 0.97 * safezoneH + safezoneY;
			w = 0.01459 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class Medici_Hud: Life_RscText {
			idc = 10;
			text = "5";
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.06,0.06,0.06,0.8}; 
			x = 0.911875 * safezoneW + safezoneX;
			y = 0.973 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.02 * safezoneH;
		};
		class Civili_Icon: Life_RscPicture {
			colorBackground[] = {0.02,0.06,0.06,1};
			idc = -1;
			text = "pi_data\hud\civ.paa";
			x = 0.948125 * safezoneW + safezoneX;
			y = 0.97 * safezoneH + safezoneY;
			w = 0.01459 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class Civili_Hud: Life_RscText {
			idc = 11;
			text = "24";
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.06,0.06,0.06,0.8}; 
			x = 0.96337 * safezoneW + safezoneX;
			y = 0.973 * safezoneH + safezoneY;
			w = 0.0360937 * safezoneW;
			h = 0.02 * safezoneH;
		};
	};
};
