class DefaultEventhandlers;
class CfgPatches {
    class life_server {
        units[] = {"C_man_1"};
        weapons[] = {};
        requiredAddons[] = {"A3_Data_F","A3_Soft_F","A3_Soft_F_Offroad_01","A3_Characters_F"};
        fileName = "life_server.pbo";
        author = "Tonic";
    };
};
class CfgFunctions {
    class MySQL_Database {
        tag = "DB";
        class MySQL
        {
            file = "\life_server\Functions\MySQL";
            class numberSafe {};
            class mresArray {};
            class customCall {};
            class sqlCustomTest {};
            class queryRequest{};
            class asyncCall{};
            class insertRequest{};
            class updateRequest{};
            class mresToArray {};
            class insertVehicle {};
            class bool {};
            class mresString {};
            class updatePartial {};
        };
    };
    class Life_System {
        tag = "life";
        class Wanted_Sys {
            file = "\life_server\Functions\WantedSystem";
            class wantedFetch {};
            class wantedPerson {};
            class wantedBounty {};
            class wantedRemove {};
            class wantedAdd {};
            class wantedCrimes {};
            class wantedProfUpdate {};
        };
        class Jail_Sys {
            file = "\life_server\Functions\Jail";
            class jailSys {};
        };
        class Client_Code {
            file = "\life_server\Functions\Client";
        };
    };
    class TON_System {
        tag = "TON";
        class Economy {
            file = "\life_server\Functions\Economy";
            class econInit {};
            class walletLoad {};
            class walletEnsure {};
            class walletPush {};
            class walletSync {};
            class walletShadow {};
            class moneyChange {};
            class moneyLog {};
            class moneyTransfer {};
            class econBank {};
            class econPlayer {};
            class econPaycheck {};
            class econJustice {};
            class econFee {};
            class econShop {};
            class econVehiclePrice {};
            class gangMoney {};
            class gangMemberId {};
            class econCash {};
            class publishProtected {};
            class econRobbery {};
            class econEarnCheck {};
            class econIncome {};
            class econResync {};
            class econReport {};
        };
        class Ownership {
            file = "\life_server\Functions\Ownership";
            class ownershipInit {};
            class assetOwn {};
            class assetRelease {};
            class assetOwners {};
            class assetOwned {};
        };
        class Inventory {
            file = "\life_server\Functions\Inventory";
            class invInit {};
            class invSync {};
            class invTrack {};
            class invReport {};
            class invWarn {};
            class invGet {};
            class invChange {};
            class invPush {};
            class invGather {};
            class invProcess {};
            class invGive {};
            class invAccept {};
            class invDrop {};
            class invDropped {};
            class invLoad {};
            class invHarvest {};
            class invTrunk {};
            class invConvert {};
            class trunkGet {};
            class trunkSet {};
            class trunkWeight {};
            class trunkSpace {};
            class trunkMine {};
            class invZone {};
        };
        class Systems {
            file = "\life_server\Functions\Systems";
            class adminManageAuth {};
            class callerInfo {};
            class checkCaller {};
            class denyCaller {};
            class relay {};
            class serverGet {};
            class serverSet {};
            class clientLog {};
            class adminManageQuery {};
            class adminManageAction {};
            class adminMoneyQuery {};
            class skillsLoad {};
            class skillsSave {};
            class dutyInfo {};
            class dutySwitch {};
            class managesc {};
            class cleanup {};
            class hasKey {};
            class vehicleKeys {};
            class vehicleKeysSet {};
            class custody {};
            class custodySet {};
            class custodyWatch {};
            class fedSafe {};
            class huntingZone {};
            class getID {};
            class vehicleCreate {};
            class spawnVehicle {};
            class getVehicles {};
            class vehicleStore {};
            class vehicleDelete {};
            class spikeStrip {};
            class transferOwnership {};
            class federalUpdate {};
            class chopShopSell {};
            class clientDisconnect {};
            class entityRespawned {};
            class cleanupRequest {};
            class keyManagement {};
            class vehicleUpdate {};
            class recupkeyforHC {};
            class handleBlastingCharge {};
            class terrainSort {};
        };
        class Housing {
            file = "\life_server\Functions\Housing";
            class addHouse {};
            class addContainer {};
            class deleteDBContainer {};
            class fetchPlayerHouses {};
            class initHouses {};
            class sellHouse {};
            class sellHouseContainer {};
            class updateHouseContainers {};
            class updateHouseTrunk {};
            class houseCleanup {};
            class houseGarage {};
        };
        class Gangs {
            file = "\life_server\Functions\Gangs";
            class insertGang {};
            class queryPlayerGang {};
            class removeGang {};
            class updateGang {};
        };
        class Actions {
            file = "\life_server\Functions\Actions";
            class pickupAction {};
        };
        class PlayTime {
            file = "\life_server\Functions\PlayTime";
            class setPlayTime {};
            class getPlayTime {};
        };
    };
};
class CfgVehicles {
    class Car_F;
    class CAManBase;
    class Civilian;
    class Civilian_F : Civilian {
        class EventHandlers;
    };
    class C_man_1 : Civilian_F {
        class EventHandlers: EventHandlers {
            init = "(_this select 0) execVM ""\life_server\fix_headgear.sqf""";
        };
    };
};
