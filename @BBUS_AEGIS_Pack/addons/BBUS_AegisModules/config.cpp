#include "BaseControls.hpp"
#include "ListUI.hpp"
class CfgPatches
{
	class BBUS_AegisModules
	{
		// Meta information for editor
		name = "Basipek's Aegis Security Mod Pack";
		author = "Basipek Bus";
		url = "http://kiloo.epizy.com";

		// Minimum compatible version. When the game's version is lower, pop-up warning will appear when launching the game. Note: was disabled on purpose some time late into Arma 2: OA.
		requiredVersion = 1.60; 
		// Required addons, used for setting load order.
		// When any of the addons is missing, pop-up warning will appear when launching the game.
		requiredAddons[] = {"ace_common"};
		// List of objects (CfgVehicles classes) contained in the addon. Important also for Zeus content (units and groups) unlocking.
		units[] = {};
		// List of weapons (CfgWeapons classes) contained in the addon.
		weapons[] = {"BBUS_FultonItem_Small","BBUS_FultonItem_Medium","BBUS_FultonItem_Large"};
	};
};

class CfgFunctions
{
	class BBUS
	{
		class AegisModules
		{
			file = "\BBUS_AegisModules";
			class aegisInit {postInit = 1;};
		};
	};
	
	class BBUS_vehiclearsenal {
		file = "\BBUS_AegisModules\functions";
		class vehiclearsenal{
			class addArsenalInit;
		};
	}
};

class CfgWeapons
{
	
	class ToolKit;
	class BBUS_FultonItem_Small: ToolKit
	{
		author = "Basipek";
		picture = "\BBUS_AegisModules\pictures\Kit.paa";
		displayName = "Fulton Device [Small]";
		descriptionShort = "ACE Self interaction deployable fulton recovery device. Use on cursorObject. Carries up to 5 tonnes; humans and crates.";
		class ItemInfo
		{
			mass = 10;
			uniformModel = "\A3\Weapons_F\Items\Toolkit";
			type = 620;
			allowedSlots[] = {801,701,901};
			scope = 0;
		};
	};
	class BBUS_FultonItem_Medium: ToolKit
	{
		author = "Basipek";
		picture = "\BBUS_AegisModules\pictures\Kit.paa";
		displayName = "Fulton Device [Medium]";
		descriptionShort = "ACE Self interaction deployable fulton recovery device. Use on cursorObject. Supports anything below 10 tonnes; cars and crates.";
		class ItemInfo
		{
			mass = 30;
			uniformModel = "\A3\Weapons_F\Items\Toolkit";
			type = 620;
			allowedSlots[] = {801,701,901};
			scope = 0;
		};
	};
	class BBUS_FultonItem_Large: ToolKit
	{
		author = "Basipek";
		picture = "\BBUS_AegisModules\pictures\Kit.paa";
		displayName = "Fulton Device [Large]";
		descriptionShort = "ACE Self interaction deployable fulton recovery device. Use on cursorObject. Supports everything; containers and tanks.";
		class ItemInfo
		{
			mass = 75;
			uniformModel = "\A3\Weapons_F\Items\Toolkit";
			type = 620;
			allowedSlots[] = {801,701,901};
			scope = 0;
		};
	};
	class BBUS_FultonItem_LZ: ToolKit
	{
		author = "Basipek";
		picture = "\BBUS_AegisModules\pictures\fultonlz.paa";
		displayName = "Fulton Landing Zone Device";
		descriptionShort = "ACE Self interaction deployable device for designating landing zones for Fulton Recovery. Only works without the realistic setting!";
		class ItemInfo
		{
			mass = 75;
			uniformModel = "\A3\Weapons_F\Items\Toolkit";
			type = 620;
			allowedSlots[] = {801,701,901};
			scope = 0;
		};
	};
	
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class BBUS_ModuleCategory: NO_CATEGORY
	{
		displayName = "Basipek Bus";
	};
};

class CfgVehicles
{	
	class Land_AirHorn_01_F;
	class BBUS_FultonObject_LZ : Land_AirHorn_01_F {
		scopeCurator = 2;
		displayName = "Fulton LZ Object";
		model = "\BBUS_AegisModules\lzobj\fultonlzdevice.p3d";
	};
};

class Extended_PreInit_EventHandlers
{
	class BBUS_AegisModules_PreInit
	{
		init="call compile preprocessFileLineNumbers 'BBUS_AegisModules\Bootstrap\XEH_preInit.sqf'";
	};
};


class CfgSounds
{
	sounds[] = {};
	class BBUS_AegisModules_items_fulton_fly
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Fly";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\items\fulton_fly.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_items_fulton_place
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Place";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\items\fulton_place.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_items_fulton_pop
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Pop";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\items\fulton_pop.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_items_fulton_flyover
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\items\fulton_flyover.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	
	
	class BBUS_AegisModules_vox_ene_fultonscream_01
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\fultonscream_01.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_fultonscream_02
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\fultonscream_02.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_fultonscream_03
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\fultonscream_03.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_fultonscream_04
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\fultonscream_04.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_grunt_01
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\grunt_01.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_helpme
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\helpme.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_panic_01
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\panic_01.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_panic_02
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\panic_02.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_wake_01
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\wake_01.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_vox_ene_wake_02
	{
		// how the sound is referred to in the editor (e.g. trigger effects)
		name = "Fulton Flyover";

		// filename, volume, pitch, distance (optional)
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\ene_generic\wake_02.wav", 2, 1, 300 };

		// subtitle delay in seconds, subtitle text
		titles[] = { 0, "" };
	};
	
	class BBUS_AegisModules_vox_miller_extract_failed
	{
		name = "Extract Failed";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\extract_failed.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_gonna_extract_him
	{
		name = "Gonna Extract Him";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\gonna_extract_him.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted1
	{
		name = "Target Extracted 1";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted1.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted2
	{
		name = "Target Extracted 2";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted2.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted3
	{
		name = "Target Extracted 3";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted3.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted4
	{
		name = "Target Extracted 4";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted4.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted5
	{
		name = "Target Extracted 5";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted5.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted6
	{
		name = "Target Extracted 6";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted6.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted7
	{
		name = "Target Extracted 7";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted7.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_extracted8
	{
		name = "Target Extracted 8";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted8.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};
	
	class BBUS_AegisModules_vox_miller_target_extracted9
	{
		name = "Target Extracted 9";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_extracted9.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};

	class BBUS_AegisModules_vox_miller_target_secured
	{
		name = "Target Secured";
		sound[] = { "BBUS_AegisModules\sound\mgsv\vox\miller\target_secured.wav", 2, 1, 300 };
		titles[] = { 0, "" };
	};
	
	
	class BBUS_AegisModules_mgsvportal01
	{
		name = "MGSV Portal 1";
		sound[] = { "BBUS_AegisModules\sound\mgsvportal-01.ogg", 2, 1, 300 };
		titles[] = { 0, "" };
	};
	class BBUS_AegisModules_mgsvportal02
	{
		name = "MGSV Portal 2";
		sound[] = { "BBUS_AegisModules\sound\mgsvportal-02.ogg", 2, 1, 300 };
		titles[] = { 0, "" };
	};
	
};
