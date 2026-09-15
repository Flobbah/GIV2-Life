/*
    File: fn_adminTarget.sqf
    Description:
    Returns the player currently selected in the admin menu list (idc 2902) or objNull.
    The list stores an index into life_admin_playerList (filled by fn_adminMenu),
    so no "call compile" of object strings is needed.
    Returns:
    OBJECT
*/
private _index = lbCurSel 2902;
if (_index isEqualTo -1) exitWith {objNull};
private _units = missionNamespace getVariable ["life_admin_playerList",[]];
_units param [lbValue [2902,_index],objNull,[objNull]]
