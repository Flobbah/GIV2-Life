#include "..\..\script_macros.hpp"
/*
    File: fn_clothingMenu.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    Opens and initializes the clothing store menu.
    Started clean, finished messy.
*/
params ["","","",["_shop","",[""]]];
if (_shop isEqualTo "") exitWith {};
if !(isNull objectParent player) exitWith {titleText[localize "STR_NOTF_ActionInVehicle","PLAIN"];};
/* License check & config validation */
if !(isClass(missionConfigFile >> "Clothing" >> _shop)) exitWith {}; //Bad config entry.
private _shopTitle = M_CONFIG(getText,"Clothing",_shop,"title");
private _shopSide = M_CONFIG(getText,"Clothing",_shop,"side");
private _conditions = M_CONFIG(getText,"Clothing",_shop,"conditions");
private _exit = false;
private "_flag";
if !(_shopSide isEqualTo "") then {
    _flag = switch (life_side) do {case west: {"cop"}; case independent: {"med"}; default {"civ"};};
    if !(_flag isEqualTo _shopSide) then {_exit = true;};
};
if (_exit) exitWith {};
_exit = [_conditions] call life_fnc_levelCheck;
if !(_exit) exitWith {[ localize "STR_Shop_Veh_NoLicense",true,"fast"] call life_fnc_notification_system;};
//Save old inventory
life_oldClothes = uniform player;
life_olduniformItems = uniformItems player;
life_oldBackpack = backpack player;
life_oldVest = vest player;
life_oldVestItems = vestItems player;
life_oldBackpackItems = backpackItems player;
life_oldGlasses = goggles player;
life_oldHat = headgear player;
/* Open up the menu */
createDialog "Life_Clothing";
disableSerialization;
ctrlSetText [3103,localize _shopTitle];
(findDisplay 3100) displaySetEventHandler ["KeyDown","if ((_this select 1) isEqualTo 1) then {closeDialog 0; [] call life_fnc_playerSkins;}"]; //Fix Custom Skin after ESC
sliderSetRange [3107, 0, 360];
//Cop / Civ Pre Check
if (_shop in ["bruce","dive","reb","kart"] && {!(life_side isEqualTo civilian)}) exitWith {[ localize "STR_Shop_NotaCiv",true,"fast"] call life_fnc_notification_system; closeDialog 0;};
if (_shop == "reb" && {!license_civ_rebel}) exitWith {[ localize "STR_Shop_NotaReb",true,"fast"] call life_fnc_notification_system; closeDialog 0;};
if (_shop == "cop" && {!(life_side isEqualTo west)}) exitWith {[ localize "STR_Shop_NotaCop",true,"fast"] call life_fnc_notification_system; closeDialog 0;};
if (_shop == "dive" && {!license_civ_dive}) exitWith {[ localize "STR_Shop_NotaDive",true,"fast"] call life_fnc_notification_system; closeDialog 0;};
private ["_pos","_oldPos","_oldDir","_oldBev","_testLogic","_nearVeh","_light"];
private ["_ut1","_ut2","_ut3","_ut4","_ut5"];
if (LIFE_SETTINGS(getNumber,"clothing_noTP") isEqualTo 1) then {
    _pos = getPosATL player;
} else {
    if (LIFE_SETTINGS(getNumber,"clothing_box") isEqualTo 1) then {
        _pos = [1000,1000,10000];
    } else {
        _pos = switch _shop do {
            case "reb": {[13590,12214.6,0.00141621]};
            case "cop": {[12817.5,16722.9,0.00151062]};
            case "kart": {[14120.5,16440.3,0.00139236]};
            default {[17088.2,11313.6,0.00136757]};
        };
    };
    _oldDir = getDir player;
    _oldPos = visiblePositionASL player;
    _oldBev = behaviour player;
    _testLogic = "Logic" createVehicleLocal _pos;
    _testLogic setPosATL _pos;
    _nearVeh = _testLogic nearEntities ["AllVehicles", 20];
    if (LIFE_SETTINGS(getNumber,"clothing_box") isEqualTo 1) then {
        _ut1 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [0,5,10]);
        _ut1 attachTo [_testLogic,[0,5,5]];
        _ut1 setDir 0;
        _ut2 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [5,0,10]);
        _ut2 attachTo [_testLogic,[5,0,5]];
        _ut2 setDir (getDir _testLogic) + 90;
        _ut3 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [-5,0,10]);
        _ut3 attachTo [_testLogic,[-5,0,5]];
        _ut3 setDir (getDir _testLogic) - 90;
        _ut4 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [0,-5,10]);
        _ut4 attachTo [_testLogic,[0,-5,5]];
        _ut4 setDir 180;
        _ut5 = "UserTexture10m_F" createVehicleLocal (_testLogic modelToWorld [0,0,10]);
        _ut5 attachTo [_testLogic,[0,0,0]];
        _ut5 setObjectTexture [0,"a3\map_data\gdt_concrete_co.paa"];
        detach _ut5;
        _ut5 setVectorDirAndUp [[0,0,-.33],[0,.33,0]];
    };
    _light = "#lightpoint" createVehicleLocal _pos;
    _light setLightBrightness 0.5;
    _light setLightColor [1,1,1];
    _light setLightAmbient [1,1,1];
    _light lightAttachObject [_testLogic, [0,0,0]];
    {
        if (_x != player) then {_x hideObject true;};
        true
    } count playableUnits;
    if (LIFE_SETTINGS(getNumber,"clothing_box") isEqualTo 0) then {
        {
            if (_x != player && _x != _light) then {_x hideObject true;};
            true
        } count _nearVeh;
    };
    if (LIFE_SETTINGS(getNumber,"clothing_box") isEqualTo 1) then {
        {
            _x setObjectTexture [0,"#(argb,8,8,3)color(0,0,0,1)"];
            true
        } count [_ut1,_ut2,_ut3,_ut4];
    };
    player setBehaviour "SAFE";
    if (_shop == "dive") then {
        player setPosATL [-1000, -1000, 10];
        sleep 0.0005;
    };
    player attachTo [_testLogic,[0,0,0]];
    player switchMove "";
    player setDir 360;
};
life_clothing_store = _shop;
/* Store license check */
if (isClass(missionConfigFile >> "Licenses" >> life_clothing_store)) then {
    _flag = M_CONFIG(getText,"Licenses",life_clothing_store,"side");
    _displayName = M_CONFIG(getText,"Licenses",life_clothing_store,"displayName");
    if !(LICENSE_VALUE(life_clothing_store,_flag)) exitWith {
        [ format [localize "STR_Shop_YouNeed",localize _displayName],true,"fast"] call life_fnc_notification_system;
        closeDialog 0;
    };
};
//initialize camera view
life_shop_cam = "CAMERA" camCreate getPos player;
showCinemaBorder false;
life_shop_cam cameraEffect ["Internal", "Back"];
life_shop_cam camSetTarget (player modelToWorld [0,0,1]);
life_shop_cam camSetPos (player modelToWorld [1,4,2]);
life_shop_cam camSetFOV .33;
life_shop_cam camSetFocus [50, 0];
life_shop_cam camCommit 0;
life_cMenu_lock = false;
if (isNull (findDisplay 3100)) exitWith {};
private _list = (findDisplay 3100) displayCtrl 3101;
private _filter = (findDisplay 3100) displayCtrl 3105;
lbClear _filter;
lbClear _list;
_filter lbAdd localize "STR_Shop_UI_Clothing";
_filter lbAdd localize "STR_Shop_UI_Hats";
_filter lbAdd localize "STR_Shop_UI_Glasses";
_filter lbAdd localize "STR_Shop_UI_Vests";
_filter lbAdd localize "STR_Shop_UI_Backpack";
_filter lbSetCurSel 0;
[] call life_fnc_playerSkins;
waitUntil {isNull (findDisplay 3100)};
if (LIFE_SETTINGS(getNumber,"clothing_noTP") isEqualTo 0) then {
    {
        if (_x != player) then {_x hideObject false;};
        true
    } count playableUnits;
    if (LIFE_SETTINGS(getNumber,"clothing_box") isEqualTo 0) then {
        {
            if (_x != player && _x != _light) then {_x hideObject false;};
            true
        } count _nearVeh;
    };
    detach player;
    player setBehaviour _oldBev;
    player setPosASL _oldPos;
    player setDir _oldDir;
    if (LIFE_SETTINGS(getNumber,"clothing_box") isEqualTo 1) then {
        {
            deleteVehicle _x;
        } count [_testLogic,_ut1,_ut2,_ut3,_ut4,_ut5,_light];
    } else {
        {
            deleteVehicle _x;
            true
        } count [_testLogic,_light];
    };
};
life_shop_cam cameraEffect ["TERMINATE","BACK"];
camDestroy life_shop_cam;
life_clothing_filter = 0;
//Beim Verlassen des Ladens:
//  - Was gekauft wurde, bleibt an.
//  - Jeder andere Platz kommt zurueck auf das, was vorher da war - samt Inhalt.
//Wichtig: erst ausziehen, dann anziehen. addUniform, addVest und addHeadgear tun naemlich nichts,
//solange noch etwas getragen wird. Genau daran lag es, dass man die Vorschau umsonst behielt und
//dass ein leer gelassener Platz ("Entferne Kleidung") das alte Stueck endgueltig gekostet hat.
private _bought = if (isNil "life_clothesPurchased") then {
    [false,false,false,false,false]
} else {
    life_clothing_purchase apply {!(_x isEqualTo -1)}
};
life_clothesPurchased = nil;
life_clothing_purchase = [-1,-1,-1,-1,-1];
private _refillUniform = false;
private _refillVest = false;
private _refillPack = false;

//Uniform
if (!(_bought select 0) && {!((uniform player) isEqualTo life_oldClothes)}) then {
    if !(uniform player isEqualTo "") then {removeUniform player};
    if !(life_oldClothes isEqualTo "") then {
        //Ohne Lobby verteilt die Engine irgendeinen freien Slot - die Spielfigur kann also die
        //Klasse eines Polizisten oder Sanitaeters haben, auch wenn man als Zivilist spielt. Fuer
        //solche Klassen ist Zivilkleidung "nicht erlaubt", und addUniform tut dann stillschweigend
        //nichts: die Vorschau war aus, die eigene Uniform kam nicht zurueck, weg war sie.
        //forceAddUniform zieht sie unabhaengig von der Klasse an (genauso macht es fn_startLoadout).
        if (player isUniformAllowed life_oldClothes) then {
            player addUniform life_oldClothes;
        } else {
            player forceAddUniform life_oldClothes;
        };
        _refillUniform = true;
    };
};
//Kopfbedeckung
if (!(_bought select 1) && {!((headgear player) isEqualTo life_oldHat)}) then {
    if !(headgear player isEqualTo "") then {removeHeadgear player};
    if !(life_oldHat isEqualTo "") then {player addHeadgear life_oldHat};
};
//Brille
if (!(_bought select 2) && {!((goggles player) isEqualTo life_oldGlasses)}) then {
    if !(goggles player isEqualTo "") then {removeGoggles player};
    if !(life_oldGlasses isEqualTo "") then {player addGoggles life_oldGlasses};
};
//Weste
if (!(_bought select 3) && {!((vest player) isEqualTo life_oldVest)}) then {
    if !(vest player isEqualTo "") then {removeVest player};
    if !(life_oldVest isEqualTo "") then {
        player addVest life_oldVest;
        _refillVest = true;
    };
};
//Rucksack
if (!(_bought select 4) && {!((backpack player) isEqualTo life_oldBackpack)}) then {
    if !(backpack player isEqualTo "") then {removeBackpack player};
    if !(life_oldBackpack isEqualTo "") then {
        player addBackpack life_oldBackpack;
        clearAllItemsFromBackpack player;
        _refillPack = true;
    };
};
//Inhalte erst, wenn alle Behaelter wieder da sind - sonst sucht sich ein Gegenstand den falschen
if (_refillUniform) then {
    {[_x,true,false,false,true] call life_fnc_handleItem} forEach life_oldUniformItems;
};
if (_refillVest) then {
    {[_x,true,false,false,true] call life_fnc_handleItem} forEach life_oldVestItems;
};
if (_refillPack) then {
    {[_x,true,true] call life_fnc_handleItem} forEach life_oldBackpackItems;
};
//Eine Zeile ins Log, wenn man den Laden mit einer anderen Uniform verlaesst als man hereinkam -
//nach einem Kauf ist das richtig so, sonst steht hier der Grund fuer eine verschwundene Uniform.
if !((uniform player) isEqualTo life_oldClothes) then {
    diag_log format ["[CLOTHING] Uniform vorher %1, jetzt %2 (gekauft: %3, Spielfigur %4)",
        life_oldClothes, uniform player, _bought, typeOf player];
};
[] call life_fnc_playerSkins;
[] call life_fnc_saveGear;
