/*
    File: Config_Community.hpp
    Description:
    Name der Community an EINER Stelle. Nur die beiden Werte unten aendern:
      COMMUNITY_NAME          - Kurzname der Community, fuer Texte in Skripten
      COMMUNITY_MISSION_NAME  - Name der Mission in Lobby, Serverliste und Ladebildschirm
    Verwendung:
      description.ext  : onLoadName / briefingName = COMMUNITY_MISSION_NAME;
      Skripte          : COMMUNITY_NAME_TEXT bzw. COMMUNITY_MISSION_NAME_TEXT (script_macros.hpp)
      Stringtable      : Platzhalter %1 im Text und per format mit COMMUNITY_NAME_TEXT fuellen
    Bewusst keine Stringtable-Schluessel: Lobby und Serverliste zeigen den Namen, bevor die Mission
    beim Spieler geladen ist, dort wuerde ein $STR_-Schluessel nicht aufgeloest.
*/
#define COMMUNITY_NAME "PiGaming"
#define COMMUNITY_MISSION_NAME "PiGaming Gulf Coast Life"

class CfgCommunity {
    name = COMMUNITY_NAME;
    missionName = COMMUNITY_MISSION_NAME;
};
