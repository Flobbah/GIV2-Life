/*
    File: Config_Relay.hpp
    Description:
    Sicherheitsphase 0.1b: Aktionen zwischen Spielern laufen ueber den Server.
    Clients rufen andere Clients nicht mehr direkt auf, sondern ueber life_fnc_relaySend. Der Server
    (TON_fnc_relay) kennt den echten Absender, prueft die Regel der Funktion und leitet weiter.
    Die Empfaenger nehmen Remote-Aufrufe dann nur noch vom Server oder vom eigenen Client an
    (RELAY_ONLY_REMOTE in script_macros.hpp).

    Abgelehnte Aufrufe stehen als [SECURITY] im Server-RPT. Ob sie blockiert oder nur protokolliert
    werden, regelt CfgServer >> CallerCheckMode in description.ext. Funktionen ohne Regel und
    Absender ueber dem Ratenlimit werden immer blockiert.

    Felder je Funktion (alle optional):
        scheduled  = 1 -> remoteExec (Funktion darf sleep/waitUntil nutzen), 0 -> remoteExecCall
        sender     = "any" | "cop" | "medic" | "civ" | "killed" (Absender wurde in den letzten 60 s
                     vom Ziel getoetet)
        adminLevel = Mindest-Adminlevel des Absenders laut Datenbank (0 = keine Pruefung)
        target     = "any" (alles ausser dem Server) | "player" | "cop" | "unit" (auch tote Koerper)
                     | "object" (Ziel ist das Objekt aus objectArg, das Client-Ziel wird ignoriert)
        distance   = maximaler Abstand in Metern vom Absender (oder seinem Koerper kurz nach dem Tod)
                     zum Ziel-Objekt und zu objectArg, 0 = keine Pruefung
        objectArg  = Index eines Arguments (Objekt oder Position), das in Reichweite liegen muss
        senderArg / nameArg / uidArg / sideArg = Index eines Arguments, das der Server durch die
                     Einheit / den Namen / die UID / die Fraktion des echten Absenders ersetzt
        condition  = zusaetzliche SQF-Bedingung, muss true liefern. Verfuegbar: _args, _target,
                     _unit, _uid, _side, _name, _adminLevel (darf erhoeht werden)
*/
class CfgRelay {
    enabled = 1;            // 1 = Aktionen zwischen Spielern ueber den Server, 0 = direkt wie in Altis Life 5.0 (Notschalter)
    rateLimit[] = {60, 10}; // hoechstens 60 weitergeleitete Aktionen je Spieler in 10 Sekunden

    class Functions {
        /* Admin */
        class life_fnc_adminCompReceive { adminLevel = 2; target = "player"; nameArg = 2; };
        class life_fnc_adminHealed { adminLevel = 2; target = "player"; senderArg = 0; };
        class life_fnc_adminQueryReply { scheduled = 1; adminLevel = 1; target = "player"; senderArg = 0; };
        class life_fnc_adminInfo { scheduled = 1; target = "player"; senderArg = 3; nameArg = 4; uidArg = 5; sideArg = 6; };
        class life_fnc_freezePlayer { scheduled = 1; adminLevel = 4; target = "player"; senderArg = 0; };

        /* Polizei */
        class life_fnc_restrain { scheduled = 1; sender = "cop"; target = "player"; distance = 15; senderArg = 0; };
        class life_fnc_searchClient { scheduled = 1; sender = "cop"; target = "player"; distance = 15; senderArg = 0; };
        class life_fnc_seizeClient { scheduled = 1; sender = "cop"; target = "player"; distance = 15; senderArg = 0; };
        class life_fnc_jail { sender = "cop"; target = "player"; distance = 25; condition = "(_args param [0, objNull, [objNull]]) isEqualTo _target"; };
        class life_fnc_moveIn { sender = "cop"; target = "player"; distance = 25; objectArg = 0; };
        class life_fnc_pulloutVeh { sender = "cop"; target = "player"; distance = 25; };
        class life_fnc_licenseCheck { sender = "cop"; target = "player"; distance = 20; senderArg = 0; };
        class life_fnc_licensesRead { target = "cop"; distance = 30; nameArg = 0; };
        class life_fnc_copSearch { scheduled = 1; target = "cop"; distance = 30; senderArg = 0; };
        class life_fnc_ticketPrompt { scheduled = 1; sender = "cop"; target = "player"; distance = 20; senderArg = 0; };
        class life_fnc_ticketPaid { target = "cop"; senderArg = 1; condition = "(_args param [2, objNull, [objNull]]) isEqualTo _target"; };

        /* Geld und Gegenstaende */
        class life_fnc_receiveMoney { target = "player"; distance = 25; senderArg = 2; };
        class life_fnc_receiveItem { target = "player"; distance = 25; senderArg = 3; condition = "(_args param [0, objNull, [objNull]]) isEqualTo _target"; };
        class life_fnc_giveDiff { target = "player"; distance = 25; senderArg = 3; condition = "(_args param [0, objNull, [objNull]]) isEqualTo _target"; };
        class life_fnc_wireTransfer { target = "player"; nameArg = 1; };
        class life_fnc_robPerson { sender = "civ"; target = "player"; distance = 15; senderArg = 0; };
        class life_fnc_robReceive { target = "player"; distance = 15; senderArg = 1; condition = "(_args param [2, objNull, [objNull]]) isEqualTo _target"; };
        class TON_fnc_clientGetKey { target = "player"; distance = 30; nameArg = 2; condition = "(_args param [1, objNull, [objNull]]) isEqualTo _target"; };

        /* Kampf und Medizin */
        class life_fnc_knockedOut { scheduled = 1; sender = "civ"; target = "player"; distance = 15; nameArg = 1; condition = "(_args param [0, objNull, [objNull]]) isEqualTo _target"; };
        class life_fnc_revived { target = "unit"; distance = 15; nameArg = 0; };
        class life_fnc_removeLicenses { sender = "killed"; condition = "(_args param [0, -1, [0]]) in [2, 3]"; };
        class life_fnc_medicRequest { nameArg = 1; condition = "_target in [independent, west]"; };
        class life_fnc_corpse { distance = 50; objectArg = 0; condition = "private _c = _args param [0, objNull, [objNull]]; !isNull _c && {!alive _c} && {_c isKindOf ""CAManBase""}"; };
        class life_fnc_flashbang { scheduled = 1; distance = 100; objectArg = 0; };
        class life_fnc_demoChargeTimer { scheduled = 1; condition = "(_unit distance2D fed_bank) < 150"; };

        /* Fahrzeuge, Objekte, Effekte */
        class life_fnc_lockVehicle { target = "object"; objectArg = 0; distance = 30; condition = "[_args param [0, objNull, [objNull]], _uid] call TON_fnc_hasKey"; };
        class life_fnc_setFuel { target = "object"; objectArg = 0; distance = 50; };
        class life_fnc_simDisable { distance = 30; objectArg = 0; condition = "private _o = _args param [0, objNull, [objNull]]; !isNull _o && {!(_o isKindOf ""AllVehicles"")}"; };
        class life_fnc_lightHouse { distance = 60; objectArg = 0; condition = "(_args param [0, objNull, [objNull]]) isKindOf ""House_F"""; };
        class life_fnc_soundDevice { scheduled = 1; distance = 50; objectArg = 0; };
        class life_fnc_say3D { distance = 60; objectArg = 0; };
        class life_fnc_animSync { senderArg = 0; };
        class life_fnc_broadcast {};

        /* Gangs */
        class life_fnc_gangInvite { scheduled = 1; sender = "civ"; target = "player"; nameArg = 0; condition = "(group _unit) isEqualTo (_args param [1, grpNull, [grpNull]])"; };
        class TON_fnc_clientGangKick { scheduled = 1; target = "player"; condition = "((_args param [1, grpNull, [grpNull]]) getVariable [""gang_owner"", """"]) isEqualTo _uid"; };
        class TON_fnc_clientGangLeader { scheduled = 1; condition = "((_args param [1, grpNull, [grpNull]]) getVariable [""gang_owner"", """"]) in [_uid, getPlayerUID (_args param [0, objNull, [objNull]])]"; };

        /* Telefon: Typ 0 privat, 1 Polizei, 2 an Admins, 3/4 von Admins (Adminlevel 1), 5 Rettungsdienst */
        class TON_fnc_clientMessage { nameArg = 1; senderArg = 4; condition = "private _t = _args param [2, -1, [0]]; if (_t in [3, 4]) then {_adminLevel = 1}; if ((count _args) > 3 && {!isNull _unit}) then {_args set [3, mapGridPosition _unit]}; _t in [0, 1, 2, 3, 4, 5]"; };
    };
};
