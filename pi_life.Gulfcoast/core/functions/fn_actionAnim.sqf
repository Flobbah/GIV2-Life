#include "..\..\script_macros.hpp"
/*
    File: fn_actionAnim.sqf
    Author: Flobbah (Immersive Update)
    Description:
    Zentrale Steuerung der Aktions-Animationen (Reparatur, Revive, Lockpick, Tanken, Bolzenschneider, ...).

    Aufrufe (immer per call aus einem gespawnten Script, weil kurz gewartet wird):
      ["start", <anim>]        Animation starten, einmal an Mitspieler syncen
      ["keep",  <anim>]        im Fortschritts-Loop: startet nur neu, wenn die Animation verlassen wurde (max. 1x pro Sekunde)
      ["stop"]                 Animation beenden (Ausstieg passend zur Familie)
      ["stop", <exitAnim>]     Animation ueber eine bestimmte Ausstiegs-Animation beenden

    Es werden nur noch zwei Animationsfamilien benutzt, beide aus der Kampagne (Campaign_Base):
      Acts_carFixingWheel        kniend am Objekt arbeiten, 20 s, bei laengeren Aktionen weicher Neustart
      Acts_TreatingWounded_*     kniend am Boden arbeiten/versorgen, echter Loop mit 6 Varianten,
                                 Einstieg ueber _in, Ausstieg NUR ueber _Out
    Warum nur diese: Beide haben eine eigene Actions-Klasse, deren Default die Animation selbst ist.
    Deshalb laesst die Engine den Spieler darin, auch mit Gewehr oder Pistole in der Hand.
    InBaseMoves_* und die Heil-Loops sind dagegen "ohne Waffe"-Haltungen: Spieler mit Waffe werden
    von der Engine sofort wieder in die Waffenhaltung gezogen (Dauerschleife Wegstecken/Ziehen).
    Alte Wuensche (InBaseMoves_*, Ainv*_medic) werden hier automatisch auf die zwei Familien abgebildet.

    SCHALTER: life_actionAnim_legacy (Standard: true)
      true  -> altes Verhalten wie vor dem Update (medic_1 mit switchMove-Neustart) fuer alle Aktionen,
               AUSNAHME Reparatur: Acts_carFixingWheel bleibt (hat sich im Test bewaehrt)
      false -> neue Animationen (Acts_carFixingWheel / Acts_TreatingWounded) fuer alle Aktionen
*/
params [["_mode","",[""]],["_anim","",[""]]];

if (isNil "life_actionAnim_legacy") then {life_actionAnim_legacy = true;}; //true = altes Verhalten (Standard), Ausnahme: Reparatur
if (isNil "life_actionAnim_last") then {life_actionAnim_last = 0;};
if (isNil "life_actionAnim_family") then {life_actionAnim_family = [];};
if (isNil "life_actionAnim_exit") then {life_actionAnim_exit = "";};
if (isNil "life_actionAnim_anim") then {life_actionAnim_anim = "";};

//---------------------------------------------------------------- altes Verhalten
//Gilt fuer alles ausser der Reparatur: Acts_carFixingWheel laeuft weiter ueber den neuen Weg unten.
if (life_actionAnim_legacy && {!((toLower _anim) isEqualTo "acts_carfixingwheel")} && {!(life_actionAnim_anim isEqualTo "Acts_carFixingWheel")}) exitWith {
    life_actionAnim_anim = "";
    private _old = "AinvPknlMstpSnonWnonDnon_medic_1";
    switch (toLower _mode) do {
        case "start";
        case "keep": {
            if (animationState player != _old) then {
                ["life_fnc_animSync",[player,_old,true],RCLIENT] call life_fnc_relaySend;
                player switchMove _old;
                player playMoveNow _old;
            };
        };
        case "stop": {
            player playActionNow "stop";
        };
    };
};

//---------------------------------------------------------------- Hilfsfunktionen
//Gewuenschte Animation auf die zwei stabilen Familien abbilden
private _fnc_resolve = {
    params ["_a"];
    private _l = toLower _a;
    if ((_l find "acts_treatingwounded") isEqualTo 0) exitWith {"Acts_TreatingWounded_loop"};
    if (_l isEqualTo "acts_carfixingwheel") exitWith {"Acts_carFixingWheel"};
    if (((_l find "inbasemoves_repairvehicle") isEqualTo 0) || {(_l find "ainvpknl") isEqualTo 0}) exitWith {"Acts_TreatingWounded_loop"};
    "Acts_carFixingWheel"
};

//Praefixe (klein), die fuer eine Familie als "laeuft" gelten
private _fnc_family = {
    params ["_a"];
    private _l = toLower _a;
    if ((_l find "acts_treatingwounded") isEqualTo 0) exitWith {["acts_treatingwounded"]};
    [_l]
};

//Zustaende, die zur Familie gehoeren, aber schon der Ausstieg sind
private _leaving = ["acts_treatingwounded_out"];

//Ausstieg je Familie ("" = playActionNow "stop")
private _fnc_exit = {
    params ["_a"];
    if (((toLower _a) find "acts_treatingwounded") isEqualTo 0) exitWith {"Acts_TreatingWounded_Out"};
    ""
};

//true, wenn der aktuelle Animationszustand zu einer der Familien gehoert
private _fnc_inFamily = {
    params ["_family"];
    private _state = toLower (animationState player);
    private _in = false;
    {
        if ((_state find _x) isEqualTo 0) exitWith {_in = true;};
    } forEach _family;
    _in
};

//Animation starten. carFixingWheel hat aus Stand/Knien einen InterpolateTo-Eintrag (weiche Einblendung),
//TreatingWounded nicht -> direkt switchMove. Fallback auf switchMove, falls playMoveNow nichts bewirkt hat.
private _fnc_play = {
    params ["_a","_family"];
    if (((toLower _a) find "acts_treatingwounded") isEqualTo 0) exitWith {
        player switchMove _a;
        life_actionAnim_last = time;
    };
    player playMoveNow _a;
    life_actionAnim_last = time;
    uiSleep 0.15;
    if !([_family] call _fnc_inFamily) then {
        player switchMove _a;
        life_actionAnim_last = time;
    };
};

//---------------------------------------------------------------- Modi
switch (toLower _mode) do {
    case "start": {
        if (_anim isEqualTo "") exitWith {};
        private _resolved = [_anim] call _fnc_resolve;
        life_actionAnim_anim = _resolved;
        life_actionAnim_family = [_resolved] call _fnc_family;
        life_actionAnim_exit = [_resolved] call _fnc_exit;
        //TreatingWounded ueber die Einstiegs-Animation starten, sie verbindet von selbst in den Loop
        private _toPlay = if (_resolved isEqualTo "Acts_TreatingWounded_loop") then {"Acts_TreatingWounded_in"} else {_resolved};
        ["life_fnc_animSync",[player,_toPlay,true],RCLIENT] call life_fnc_relaySend;
        [_toPlay,life_actionAnim_family] call _fnc_play;
    };

    case "keep": {
        if ((time - life_actionAnim_last) < 1) exitWith {};
        private _a = if (life_actionAnim_anim isEqualTo "") then {[_anim] call _fnc_resolve} else {life_actionAnim_anim};
        if (_a isEqualTo "") exitWith {};
        private _family = [_a] call _fnc_family;
        if !([_family] call _fnc_inFamily) then {
            [_a,_family] call _fnc_play;
        };
    };

    case "stop": {
        private _family = +life_actionAnim_family;
        life_actionAnim_family = [];
        life_actionAnim_anim = "";
        if (_anim isEqualTo "") then {_anim = life_actionAnim_exit;};
        life_actionAnim_exit = "";
        if (_anim isEqualTo "") then {
            player playActionNow "stop";
        } else {
            player playMoveNow _anim;
        };
        //Nachlauf: sicherstellen, dass die Animation verlassen wird
        [_family,_anim,_fnc_inFamily,_leaving] spawn {
            params ["_family","_exitAnim","_fnc_inFamily","_leaving"];
            private _exit = toLower _exitAnim;
            private _t0 = time;
            private _forced = false;
            for "_i" from 1 to 70 do { //max. 7 s (Acts_TreatingWounded_Out dauert 3.9 s)
                if (!alive player) exitWith {};
                private _state = toLower (animationState player);
                private _inFamily = [_family] call _fnc_inFamily;
                private _isLeaving = false;
                {
                    if ((_state find _x) isEqualTo 0) exitWith {_isLeaving = true;};
                } forEach _leaving;
                private _busy = _inFamily || {!(_exit isEqualTo "") && {_state isEqualTo _exit}};
                if (!_busy) exitWith {};
                if (_inFamily && {!_isLeaving} && {!_forced}) then {
                    if (_exit isEqualTo "" && {(time - _t0) > 0.6}) then {
                        player switchMove ""; //Notbremse wie bei BIS_fnc_ambientAnim
                        _forced = true;
                    };
                    if (!(_exit isEqualTo "") && {(time - _t0) > 1}) then {
                        player switchMove _exitAnim; //Ausstiegs-Animation direkt erzwingen
                        _forced = true;
                    };
                };
                uiSleep 0.1;
            };
        };
    };
};
