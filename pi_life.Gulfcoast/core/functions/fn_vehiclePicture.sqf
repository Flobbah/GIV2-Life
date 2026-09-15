/*
    File: fn_vehiclePicture.sqf
    Description:
    Liefert ein gueltiges Vorschaubild fuer eine Fahrzeugklasse. Viele Mod-Fahrzeuge (z. B. D3S)
    tragen in CfgVehicles nur den Arma-Platzhalter "pictureThing" oder gar kein Bild; ein Listen-
    oder Bildsteuerelement mit so einem Pfad loest die Fehlermeldung "Picture picturething not found"
    aus. In dem Fall wird ein Standard-Symbol nach Fahrzeugart zurueckgegeben.
    Parameter:
        0: STRING - Klassenname aus CfgVehicles
    Rueckgabe:
        STRING - Pfad des Bildes ("" nur, wenn die Klasse nicht existiert)
*/
params [["_class","",[""]]];
if (_class isEqualTo "") exitWith {""};
private _cfg = configFile >> "CfgVehicles" >> _class;
if (!isClass _cfg) exitWith {""};
private _pic = getText (_cfg >> "picture");
if (!(_pic isEqualTo "") && {!((toLower _pic) in ["picturething","picturestaticobject"])}) exitWith {_pic};
private _base = "\A3\ui_f\data\map\vehicleicons\";
switch (true) do {
    case (_class isKindOf "Helicopter"): {_base + "iconHelicopter_ca.paa"};
    case (_class isKindOf "Plane"): {_base + "iconPlane_ca.paa"};
    case (_class isKindOf "Ship"): {_base + "iconShip_ca.paa"};
    case (_class isKindOf "Truck_F"): {_base + "iconTruck_ca.paa"};
    case (_class isKindOf "Motorcycle"): {_base + "iconMotorcycle_ca.paa"};
    case (_class isKindOf "Car"): {_base + "iconCar_ca.paa"};
    default {_base + "iconVehicle_ca.paa"};
}
