class CfgPatches
{
	class BBUS_AegisAdditions
	{
		// Meta information for editor
		name = "Basipek's Aegis Security Mod Pack - Aegis Additions";
		author = "Basipek Bus";
		url = "http://kiloo.epizy.com";

		// Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game. Note: was disabled on purpose some time late into Arma 2: OA.
		requiredVersion = 1.60;
		// Required addons, used for setting load order.
		// When any of the addons is missing, pop-up warning will appear when launching the game.
		requiredAddons[] = {"ace_common","rhsusf_c_weapons"};
		// List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups) unlocking.
		units[] = {"BBUS_Aegis_FlagPole"};
		// List of weapons (CfgWeapons classes) contained in the addon.
		weapons[] = {};
	};
};

class CfgVehicles
{	
	class FlagPole_F;
	class BBUS_Aegis_FlagPole : FlagPole_F {
		scope = 2;
		displayName = "Flag (Aegis Security)";
		class EventHandlers
		{
			init = "(_this select 0) setFlagTexture '\BBUS_AegisAdditions\pictures\aegisflag.paa'";
		};
	};
	
	//LR BACKPACKS
		class RN_AAF_Jetpack;
			class RN_AAF_Jetpack: RN_AAF_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_Ahex_Jetpack;
			class RN_Ahex_Jetpack: RN_Ahex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_Bhex_Jetpack;
			class RN_Bhex_Jetpack: RN_Bhex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class SC_Jumppack_RO_Black;
			class SC_Jumppack_RO_Black: SC_Jumppack_RO_Black
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_CYFlat_Jetpack;
			class RN_CYFlat_Jetpack: RN_CYFlat_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_DHex_Jetpack;
			class RN_DHex_Jetpack: RN_DHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_GHex_Jetpack;
			class RN_GHex_Jetpack: RN_GHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class SC_Jumppack_RO_Green;
			class SC_Jumppack_RO_Green: SC_Jumppack_RO_Green
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_LDF_Jetpack;
			class RN_LDF_Jetpack: RN_LDF_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_MHex_Jetpack;
			class RN_MHex_Jetpack: RN_MHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_MFlat_Jetpack;
			class RN_MFlat_Jetpack: RN_MFlat_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_NHex_Jetpack;
			class RN_NHex_Jetpack: RN_NHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_NFlat_Jetpack;
			class RN_NFlat_Jetpack: RN_NFlat_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_SHex_Jetpack;
			class RN_SHex_Jetpack: RN_SHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_S2Hex_Jetpack;
			class RN_S2Hex_Jetpack: RN_S2Hex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_TNFlat_Jetpack;
			class RN_TNFlat_Jetpack: RN_TNFlat_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_UCamo_Jetpack;
			class RN_UCamo_Jetpack: RN_UCamo_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_UHex_Jetpack;
			class RN_UHex_Jetpack: RN_UHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_SFlat_Jetpack;
			class RN_SFlat_Jetpack: RN_SFlat_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};
			
		class RN_WHex_Jetpack;
			class RN_WHex_Jetpack: RN_WHex_Jetpack
			{
				tf_dialog = "rt1523g_radio_dialog";
				tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
				tf_encryptionCode = "tf_west_radio_code";
				tf_hasLRradio = 1;
				tf_range = 20000;
				tf_subtype = "digital_lr";
			};

};

class CfgMarkers {
	class BBUS_AegisAdditions_AegisFlagMarker
	{
	  scope = 1;
	  name = "Aegis Security";
	  icon = "\BBUS_AegisAdditions\pictures\aegislogo.paa";
	  texture = "\BBUS_AegisAdditions\pictures\aegislogo.paa";
	  color[] = {1,1,1,1};
	  shadow = 0;
	  markerClass = "Flags";
	  side = 1;
	  size = 32;
	  showEditorMarkerColor = 1;
	};
};

class CfgAmmo {
	class rhs_ammo_doomsday_buckshot;
	class rhs_ammo_12g_00buckshot_pellet;
	class rhs_ammo_12g_00buckshot;
	class BBUS_rhsdoomsday_buckshot : rhs_ammo_doomsday_buckshot {
		displayName = "Basi's Doomsday Buckshot";
		hit=27;
		indirectHit = 0;
		caliber=0.6;
	};
	
	class BBUS_12g_00buckshot_pellet : rhs_ammo_12g_00buckshot_pellet {
		caliber = 1.1;
		hit = 4;
	};
	
	class BBUS_12g_00buckshot : rhs_ammo_12g_00buckshot {
		submunitionAmmo = "BBUS_12g_00buckshot_pellet";
	};
};

class CfgMagazines {
	class rhsusf_8Rnd_doomsday_Buck;
	class rhsusf_8Rnd_00Buck;
	class rhsusf_5Rnd_doomsday_Buck;
	class rhsusf_5Rnd_00Buck;
	class BBUS_8Rnd_rhsdoomsday_buckshot_mag : rhsusf_8Rnd_doomsday_Buck {
		scope = 2;
		access = 2;
		displayName = "8rnd Doomsday Buckshot APers";
		ammo = "BBUS_rhsdoomsday_buckshot";
	};
	class BBUS_8Rnd_00buckshot_mag : rhsusf_8Rnd_00Buck {
		scope = 2;
		scopeArsenal = 2;
		access = 2;
		displayName = "8Rnd Buckshot AP";
		ammo = "BBUS_12g_00buckshot";
	};
	class BBUS_5Rnd_rhsdoomsday_buckshot_mag : rhsusf_5Rnd_doomsday_Buck {
		scope = 2;
		access = 2;
		displayName = "5rnd Doomsday Buckshot APers";
		ammo = "BBUS_rhsdoomsday_buckshot";
	};
	class BBUS_5Rnd_00buckshot_mag : rhsusf_5Rnd_00Buck {
		scope = 2;
		scopeArsenal = 2;
		access = 2;
		displayName = "5Rnd Buckshot AP";
		ammo = "BBUS_12g_00buckshot";
	};
	
};

class CfgWeapons
{
	
	class rhs_weap_M590_8RD {
		
		magazines[] += {"BBUS_8Rnd_rhsdoomsday_buckshot_mag","BBUS_8Rnd_00buckshot_mag"};
		
	};
	class rhs_weap_M590_5RD {
		
		magazines[] += {"BBUS_5Rnd_rhsdoomsday_buckshot_mag","BBUS_5Rnd_00buckshot_mag"};
		
	};
	
};

class CfgMagazineWells {
	class CBA_12g_5rnds
	{
		BBUS_AEGIS_Magazines[]=
		{
			"BBUS_5Rnd_00buckshot_mag",
			"BBUS_5Rnd_rhsdoomsday_buckshot_mag"
		};
	};
	class CBA_12g_6rnds
	{
	};
	class CBA_12g_7rnds
	{
	};
	class CBA_12g_8rnds
	{
		BBUS_AEGIS_Magazines[]=
		{
			"BBUS_8Rnd_00buckshot_mag",
			"BBUS_8Rnd_rhsdoomsday_buckshot_mag"
		};
	};
};

/*
class Extended_PreInit_EventHandlers
{
	class BBUS_AegisAdditions_PreInit
	{
		init="call compile preprocessFileLineNumbers 'BBUS_AegisAdditions\Bootstrap\XEH_preInit.sqf'";
	};
};
*/