/*
    File: settings.hpp
    Description:
    Einstellungen-App im Telefonrahmen (siehe phone.hpp). IDCs unveraendert (2901-2973).
*/
class SettingsMenu {
    idd = 2900;
    name = "SettingsMenu";
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "[_this select 0] call life_fnc_phoneStatus;";
    class controlsBackground {
        PHONE_FRAME
    };
    class controls {
        PHONE_APPBAR(-1,"$STR_SM_Title","closeDialog 0;")
        /* Sichtweiten */
        class VDonFoot : Life_RscPhoneLabel {
            text = "$STR_SM_onFoot";
            y = PH_Y(2.8);
        };
        class VD_onfoot_slider : life_RscXSliderH {
            idc = 2901;
            text = "";
            onSliderPosChanged = "[0,_this select 1] call life_fnc_s_onSliderChange;";
            tooltip = "$STR_SM_ToolTip1";
            x = PH_X(0.6);
            y = PH_Y(3.7);
            w = PH_W(6.5);
            h = PH_H(0.9);
        };
        class VD_onfoot_value : Life_RscPhoneEdit {
            idc = 2902;
            text = "";
            onChar = "[_this select 0, _this select 1,'ground',false] call life_fnc_s_onChar;";
            onKeyUp = "[_this select 0, _this select 1,'ground',true] call life_fnc_s_onChar;";
            x = PH_X(7.4);
            y = PH_Y(3.7);
            w = PH_W(2.5);
        };
        class VDinCar : Life_RscPhoneLabel {
            text = "$STR_SM_inCar";
            y = PH_Y(5.0);
        };
        class VD_car_slider : life_RscXSliderH {
            idc = 2911;
            text = "";
            onSliderPosChanged = "[1,_this select 1] call life_fnc_s_onSliderChange;";
            tooltip = "$STR_SM_ToolTip2";
            x = PH_X(0.6);
            y = PH_Y(5.9);
            w = PH_W(6.5);
            h = PH_H(0.9);
        };
        class VD_car_value : Life_RscPhoneEdit {
            idc = 2912;
            text = "";
            onChar = "[_this select 0, _this select 1,'vehicle',false] call life_fnc_s_onChar;";
            onKeyUp = "[_this select 0, _this select 1,'vehicle',true] call life_fnc_s_onChar;";
            x = PH_X(7.4);
            y = PH_Y(5.9);
            w = PH_W(2.5);
        };
        class VDinAir : Life_RscPhoneLabel {
            text = "$STR_SM_inAir";
            y = PH_Y(7.2);
        };
        class VD_air_slider : life_RscXSliderH {
            idc = 2921;
            text = "";
            onSliderPosChanged = "[2,_this select 1] call life_fnc_s_onSliderChange;";
            tooltip = "$STR_SM_ToolTip3";
            x = PH_X(0.6);
            y = PH_Y(8.1);
            w = PH_W(6.5);
            h = PH_H(0.9);
        };
        class VD_air_value : Life_RscPhoneEdit {
            idc = 2922;
            text = "";
            onChar = "[_this select 0, _this select 1,'air',false] call life_fnc_s_onChar;";
            onKeyUp = "[_this select 0, _this select 1,'air',true] call life_fnc_s_onChar;";
            x = PH_X(7.4);
            y = PH_Y(8.1);
            w = PH_W(2.5);
        };
        /* Schalter */
        class PlayerTagsRow : Life_RscPhoneCard {
            y = PH_Y(9.9);
            h = PH_H(1.0);
        };
        class PlayerTagsHeader : Life_RscPhoneLabel {
            text = "$STR_SM_PlayerTags";
            x = PH_X(0.9);
            y = PH_Y(9.9);
            w = PH_W(7.6);
            h = PH_H(1.0);
            colorText[] = {0.95, 0.95, 0.95, 1};
        };
        class PlayerTagsONOFF : Life_Checkbox {
            idc = 2970;
            tooltip = "$STR_GUI_PlayTags";
            onCheckedChanged = "['tags',_this select 1] call life_fnc_s_onCheckedChange;";
            x = PH_X(8.7);
            y = PH_Y(9.95);
            w = PH_W(0.9);
            h = PH_H(0.9);
        };
        class SideChatRow : PlayerTagsRow {
            y = PH_Y(11.1);
        };
        class SideChatHeader : PlayerTagsHeader {
            text = "$STR_SM_SC";
            y = PH_Y(11.1);
        };
        class SideChatONOFF : PlayerTagsONOFF {
            idc = 2971;
            tooltip = "$STR_GUI_SideSwitch";
            onCheckedChanged = "['sidechat',_this select 1] call life_fnc_s_onCheckedChange;";
            y = PH_Y(11.15);
        };
        class RevealRow : PlayerTagsRow {
            y = PH_Y(12.3);
        };
        class RevealNearestHeader : PlayerTagsHeader {
            text = "$STR_SM_RNObj";
            y = PH_Y(12.3);
        };
        class RevealONOFF : PlayerTagsONOFF {
            idc = 2972;
            tooltip = "$STR_GUI_PlayerReveal";
            onCheckedChanged = "['objects',_this select 1] call life_fnc_s_onCheckedChange;";
            y = PH_Y(12.35);
        };
        class BroadcastRow : PlayerTagsRow {
            y = PH_Y(13.5);
        };
        class BroacastHeader : PlayerTagsHeader {
            text = "$STR_SM_BCSW";
            y = PH_Y(13.5);
        };
        class BroadcastONOFF : PlayerTagsONOFF {
            idc = 2973;
            tooltip = "$STR_GUI_BroadcastSwitch";
            onCheckedChanged = "['broadcast',_this select 1] call life_fnc_s_onCheckedChange;";
            y = PH_Y(13.55);
        };
    };
};
