/*
    Author: Deathman
	Edit: Flobbah
    File: Config_RobFuelStations.hpp
    Description: Hier kannst du alles nötige Einstellen
*/
#define false 0
#define true 1
class TankeRob_Master {
    DE100_Notifiactionssytsem = false; //Only switch to True if you have the DE100_Notifiactionssytsem
    Max_Money_Rob = 8000; //How much the player should get
    Max_Money_Rob_Random = 7000; //How much the player should get in addition (RANDOM!!)
    Max_Distance = 5; //How high the distance to the victim should be
    Max_Distance_Shop = 10.5; //How high the distance should be when the raid is in full swing
    Max_Police = 0; //How many police officers must be on duty
    CreatMarkerName = "Marker200"; //Marker name that is created
    MarkerColor = "ColorRed"; //What color it should be
    MarkerType = "mil_warning"; //How the marker text should be
    ATMuse = 120; //How many seconds he should wait until he is allowed to use an ATM
    RoberDelay = 900; //As the interval of seconds between the raids is 15 min = 900 sec.
};