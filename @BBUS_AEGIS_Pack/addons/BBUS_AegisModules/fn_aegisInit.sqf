//GARRISON
	_factionsFound = [];

	{
		// Get all factions but ignore story and virtual groups.
		if !(getText (configFile >> "CfgEditorSubcategories" >> (getText (_x >> "editorSubcategory")) >> "displayName") in ["Men (Story)","Men (Virtual Reality)"]) then {
			_factionsFound pushBackUnique [
				getNumber (_x >> "side"),
				getText (configFile >> "CfgFactionClasses" >> (getText (_x >> "faction")) >> "displayName"),
				getText (configFile >> "CfgEditorSubcategories" >> (getText (_x >> "editorSubcategory")) >> "displayName"),
				getText (_x >> "faction"),
				getText (_x >> "editorSubcategory")
			];
		};
	} forEach ("(configName _x iskindOf 'CAManBase') && (getNumber (_x >> 'side') in [0, 1, 2]) && getNumber(_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles"));

	_factionsFound sort TRUE;
	_factionIndex = 0;
	_factions = _factionsFound;
	_factionspretty=[];
	{
		_x params ["_side", "_factName", "_catName", "_factClass", "_catClass"];
		_factionspretty pushBack [_catName,_factName,"",switch (_side) do {case 0: {[255,0,0,255]}; case 1: {[0,0,255,255]}; case 2: {[0,255,0,255]}; case 3: {[255,0,255,255]}; default {[0,0,0,255]};}];
	} forEach _factionsFound;

	BBUS_Garrison_factions = [_factions,_factionspretty];

	["Basipek Bus", "Garrison Area", 
	{
		params ["_modulePosASL","_attachedObject"];

		private _onConfirm = {
			_this spawn {
				_dialogReturn = _this select 0;
				_dialogReturn params ["_faction","_radius","_dynamicsim","_leaveWhenNear","_amount"];
				
				private _arguments = _this select 1; //passed arguments from zen_dialog_fnc_create
				_arguments params ["_modulePosASL", "_attachedObject"];

				ZEI_UiLastBuilding = objNull;

				// Find nearest building
				private _nearArr = ((screenToWorld getMousePosition) nearObjects _radius) select { count (_x buildingPos -1) > 0 };
				if (count _nearArr <= 0) exitWith { ["No valid buildings within radius", "ERROR"] call ZEI_fnc_misc_logMsg };
				_nearArr = _nearArr call BIS_fnc_arrayShuffle;
				_total=0;
				{
					if (_total>_amount) exitWith {};
					ZEI_UiLastBuilding = _x;
					_poss=[_x] call BIS_fnc_buildingPositions;
					_spawningamount = random [1 min (count _poss),(_amount/(count _nearArr)) min (count _poss),(count _poss)];
					[
						format["%1#%2", _faction#3, _faction#4],
						_spawningamount,
						_dynamicsim,
						_leaveWhenNear
					] call ZEI_fnc_ui_garrisonBuilding;
					_total = _total + _spawningamount;
				} forEach _nearArr;
			};
		};
		
		BBUS_Garrison_factions params ["_factions","_factionspretty"];
		
		[
			"Garrison In Area", 
			[
				["COMBO",["Faction", ""],[_factions,_factionspretty,0]],
				["SLIDER:RADIUS",["Radius", ""],[25,1000,100,0,ASLToAGL _modulePosASL,[1,1,1,1]]],
				["CHECKBOX",["Dynamic Simulation", "Dynamically simulate the spawned AI?"],[false]],
				["CHECKBOX",["Leave When Near", "Let the AI move when the players are nearby?"],[false]],
				["SLIDER",["Max Units", "Will stop filling buildings when past this by at least one."],[4,500,100,0]]
			],
			_onConfirm,
			{},
			[_modulePosASL, _attachedObject]
		] call zen_dialog_fnc_create;

	},"\BBUS_AegisModules\pictures\Garrison.paa"] call zen_custom_modules_fnc_register;
	
	
	["Basipek Bus", "Defense Op Generator", 
	{
		params ["_modulePosASL","_attachedObject"];

		private _onConfirm = {
			_this spawn {
				_dialogReturn = _this select 0;
				_dialogReturn params ["_faction","_radius","_rush","_interval"];
				
				private _arguments = _this select 1; //passed arguments from zen_dialog_fnc_create
				_arguments params ["_modulePosASL", "_attachedObject"];

				
			_bld= createVehicle ["Land_Icebox_F",ASLTOATL _modulePosASL, [],0,"CAN_COLLIDE"];
			_bld hideObjectGlobal true;
			{_x addCuratorEditableObjects [[_bld], true]} forEach allCurators;
			hint "Defense Op ends when the ICEBOX PROP is NO LONGER ALIVE.";
				[
					format["%1#%2", _faction#3, _faction#4],
					_radius,
					_rush,
					_interval,
					_bld
				] call {
					//CODE FROM ZEI_fnc_ui_garrisonBuilding					
					params [
							["_gType", ""],
							["_radius", 100],
							["_rush", true],
							["_interval", 30],
							["_bld",objNull]
						];

					// Split out the faction and category classes
					(_gType splitString "#") params [["_factClass", ""], ["_catClass", ""]];

					// Get all units with a weapon and non-parachute backpack.
					private _tempList = "getText (_x >> 'faction') == _factClass && getText (_x >> 'editorSubcategory') == _catClass && (configName _x) isKindoF 'CAManBase' && getNumber(_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles");

					// Filter out and invalid unit types matching strings.
					_fnc_notInString = {
						params ["_type"];
						
						private _notInString = true;
						{
							if (toLower _type find _x >= 0) exitWith { _notInString = FALSE };
						} forEach [ "_story", "_vr", "competitor", "ghillie", "miller", "survivor", "crew", "diver", "pilot", "rangemaster", "uav", "unarmed", "officer" ];
						
						_notInString
					};

					// Attempt to clear up the units list - Include units with at least one weapon and a non-parachute backpack.
					private _menList = _tempList select { ((configName _x) call _fnc_notInString) && (count getArray(_x >> "weapons") > 2) && (toLower getText (_x >> "backpack") find "para" < 0) };

					// If no units remain, use the original list.
					if (count _menList == 0) then { _menList = _tempList };

					// No units exist at all!
					if (count _menList == 0) exitWith {};

					private _bldPos = getPosATL _bld;

					waitUntil {
						private _grp = switch (getNumber (configFile >> "CfgFactionClasses" >> _factClass >> "side")) do { 
							case 0: { createGroup [EAST, TRUE] };
							case 1: { createGroup [WEST, TRUE] };
							default { createGroup [INDEPENDENT, TRUE] };
						};

						_rndPos = [[[_bldPos, _radius+200]], [[_bldPos,_radius]]] call BIS_fnc_randomPos;
						for "_i" from 1 to 8 do {
							sleep diag_deltaTime;
							_grp createUnit [configName (selectRandom _menList), _rndPos, [], 0, "NONE"];
						};
						if (_rush) then {
							[_grp, _radius,15,[],_bldPos,true] spawn lambs_wp_fnc_taskRush;
						}else{
							_wp = _grp addWaypoint [_bldPos,-1];
							_wp setWaypointType "SAD";
						};
						sleep _interval;
						!alive _bld;
					};
				};
				
			};
		};
		
		BBUS_Garrison_factions params ["_factions","_factionspretty"];
		
		[
			"Defense Op Generator", 
			[
				["COMBO",["Faction", ""],[_factions,_factionspretty,0]],
				["SLIDER:RADIUS",["Radius", "AI will spawn somewhere outside this range."],[25,2000,100,0,ASLToAGL _modulePosASL,[1,1,1,1]]],
				["CHECKBOX",["LAMBS Rush", "Use LAMBS RUSH? Otherwise uses seek and destroy waypoints."],[false]],
				["SLIDER",["Spawn Interval", "Will spawn one squad each this many seconds have passed."],[4,500,30,0]]
			],
			_onConfirm,
			{},
			[_modulePosASL, _attachedObject]
		] call zen_dialog_fnc_create;

	},"\BBUS_AegisModules\pictures\DOG.paa"] call zen_custom_modules_fnc_register;
	
	
	["Basipek Bus", "Squad Generator", 
	{
		params ["_modulePosASL","_attachedObject"];

		private _onConfirm = {
			_this spawn {
				_dialogReturn = _this select 0;
				_dialogReturn params ["_faction","_radius","_amount","_lifetime"];
				
				private _arguments = _this select 1; //passed arguments from zen_dialog_fnc_create
				_arguments params ["_modulePosASL", "_attachedObject"];

				
			_bld= createVehicle ["Land_TentSolar_01_olive_F",ASLTOATL _modulePosASL, [],0,"CAN_COLLIDE"];
			_bld hideObjectGlobal true;
			{_x addCuratorEditableObjects [[_bld], true]} forEach allCurators;
			hint "Unit spawning ends when the TENT PROP is NO LONGER ALIVE.";
				[
					format["%1#%2", _faction#3, _faction#4],
					_radius,
					_amount,
					_lifetime,
					_bld
				] call {
					//CODE FROM ZEI_fnc_ui_garrisonBuilding					
					params [
							["_gType", ""],
							["_radius", 100],
							["_amount", 8],
							["_lifetime", 30],
							["_bld",objNull]
						];

					// Split out the faction and category classes
					(_gType splitString "#") params [["_factClass", ""], ["_catClass", ""]];

					// Get all units with a weapon and non-parachute backpack.
					private _tempList = "getText (_x >> 'faction') == _factClass && getText (_x >> 'editorSubcategory') == _catClass && (configName _x) isKindoF 'CAManBase' && getNumber(_x >> 'scope') == 2" configClasses (configFile >> "CfgVehicles");

					// Filter out and invalid unit types matching strings.
					_fnc_notInString = {
						params ["_type"];
						
						private _notInString = true;
						{
							if (toLower _type find _x >= 0) exitWith { _notInString = FALSE };
						} forEach [ "_story", "_vr", "competitor", "ghillie", "miller", "survivor", "crew", "diver", "pilot", "rangemaster", "uav", "unarmed", "officer" ];
						
						_notInString
					};

					// Attempt to clear up the units list - Include units with at least one weapon and a non-parachute backpack.
					private _menList = _tempList select { ((configName _x) call _fnc_notInString) && (count getArray(_x >> "weapons") > 2) && (toLower getText (_x >> "backpack") find "para" < 0) };

					// If no units remain, use the original list.
					if (count _menList == 0) then { _menList = _tempList };

					// No units exist at all!
					if (count _menList == 0) exitWith {};

					private _bldPos = getPosATL _bld;

					for "_i" from 1 to _amount do {
						private _grp = switch (getNumber (configFile >> "CfgFactionClasses" >> _factClass >> "side")) do { 
							case 0: { createGroup [EAST, TRUE] };
							case 1: { createGroup [WEST, TRUE] };
							default { createGroup [INDEPENDENT, TRUE] };
						};

						_rndPos = _bldPos findEmptyPosition [2, _radius];
						for "_i" from 1 to 8 do {
							sleep diag_deltaTime;
							_grp createUnit [configName (selectRandom _menList), _rndPos, [], 0, "NONE"];
						};
						
						_wp = _grp addWaypoint [getPosATL (selectRandom ((allMissionObjects "Land_AirHorn_01_F") select {alive _x && _x getVariable ["BBUS_Aegis_SquadSpawnerRally",false]})),-1];
						_wp setWaypointType "MOVE";
						
						sleep (random [(_lifetime/_amount) min 1,_lifetime/_amount,60 max (_lifetime/_amount)]);
						if (!alive _bld) exitWith {};
					};
				};
				
			};
		};
		
		BBUS_Garrison_factions params ["_factions","_factionspretty"];
		
		[
			"Squad Generator", 
			[
				["COMBO",["Faction", ""],[_factions,_factionspretty,0]],
				["SLIDER:RADIUS",["Radius", "AI will spawn somewhere outside this range."],[25,1000,100,0,ASLToAGL _modulePosASL,[1,1,1,1]]],
				["SLIDER",["Amount", "How many squads should we spawn in total?"],[4,500,2,0]],
				["SLIDER",["Lifetime", "Will spawn the amount of squads somewhat distributed along this lifetime, then stop."],[4,1000,30,0]]
			],
			_onConfirm,
			{},
			[_modulePosASL, _attachedObject]
		] call zen_dialog_fnc_create;

	},"\BBUS_AegisModules\pictures\SG.paa"] call zen_custom_modules_fnc_register;
	
	["Basipek Bus", "Squad Generator Rally", 
		{
			params ["_modulePosASL","_attachedObject"];
				
				if (isNull _attachedObject) then {
					_attachedObject = createVehicle ["Land_AirHorn_01_F",ASLToATL _modulePosASL,[],0,"NONE"];
					_attachedObject hideObjectGlobal true;
					_attachedObject setVariable ["BBUS_Aegis_SquadSpawnerRally",true,true];
				}else {
					_pos = getPosATL _attachedObject;
					_attachedObject = createVehicle ["Land_AirHorn_01_F",_pos,[],0,"NONE"];
					_attachedObject hideObjectGlobal true;
					_attachedObject setVariable ["BBUS_Aegis_SquadSpawnerRally",true,true];
				};
				
				{_x addCuratorEditableObjects [[_attachedObject], true]} forEach allCurators;
				
			
		},"\BBUS_AegisModules\pictures\lzicon.paa"] call zen_custom_modules_fnc_register;
//VEHICLE ARSENAL

	BBUS_vehiclearsenal_fnc_addArsenal = {params ["_obj","_list"]; _this = [_obj,call (compile _list)]; if ( ( { ( (_obj actionParams _x)#0 ) == "Use Vehicle Arsenal" } count (actionIDs _obj) ) != 0) then {_obj removeAction ( (actionIDs _obj) findIf { ( (_obj actionParams _x)#0 ) == "Use Vehicle Arsenal" })}; 
		[_obj,["Use Vehicle Arsenal",{
			params ["_target", "_caller", "_actionId", "_arguments"];
			_arguments params ["_obj","_list"];
			_listdisplay = [];
			{
				_listdisplay pushBack [(getText (configfile >> "CfgVehicles" >> _x >> "displayName")),_x,(getText (configfile >> "CfgVehicles" >> _x >> "editorPreview"))];
			}forEach _list;
			[
				"Spawn Vehicle", 
				[
					["LIST",["Vehicle", "Choose a vehicle to spawn nearby! You'll be able to customize it once it spawns."],[_list,_listdisplay,0]],
					["CHECKBOX",["Customize Livery?", "Choose if you want to change the looks. The menu will open!"],[true]],
					["CHECKBOX",["Customize Pylons?", "Choose if you want to change the Pylons. The menu will open!"],[true]]
				],
				{
					_this spawn {
						_dialogReturn = _this select 0;
						_dialogReturn params ["_vic","_tick","_tickpylon"];
						
						private _arguments = _this select 1;
						_arguments params ["_obj"];
						
						_spawned=createVehicle [_vic,(((getPosATL _obj) findEmptyPosition [0.5, 100, _vic]) vectorAdd [0,0,0.5]),[],0,"NONE"];
						_spawned allowDamage false;
						player setDir ((getDir player) + (player getRelDir _spawned));
						waitUntil {!dialog};
						sleep 1;
						if (_tick) then {
							_camos = [];
							{
								if (typeName _x == "STRING") then {
									_camos pushBack _x;
								};
							} forEach ((configfile >> "CfgVehicles" >> typeOf _spawned >> "textureSources") call BIS_fnc_getCfgSubClasses);
							_anims = ([_spawned,_vic] call BIS_fnc_getVehicleCustomization) # 1;
							_options = [["COMBO","Camouflage", [_camos]]];
							{
								if (typeName _x == "STRING") then {
									_options pushBack ["CHECKBOX",[_x,"Animation/Attachment"],[if (_anims#(_forEachIndex+1) == 1) then {true} else {false}]];
								};
							} forEach _anims;
							[
								"Vehicle Customization", 
								_options,
								{
									params ["_values","_params"];
									_spawned=_params;
									_camos=[];
									{
										if (typeName _x == "STRING" && (_values # 0) isEqualTo _x) then {
											_camos pushBack _x;
											_camos pushBack 1;
										};
									} forEach ((configfile >> "CfgVehicles" >> typeOf _spawned >> "textureSources") call BIS_fnc_getCfgSubClasses);
									
									_anims = [];
									{
										if (typeName _x == "STRING") then {
											_anims pushBack _x;
											_anims pushBack (if ((_values#(_forEachIndex/2+1))) then {1} else {0});
										};
									} forEach (([_spawned] call BIS_fnc_getVehicleCustomization) # 1);
									[_spawned, _camos, _anims] spawn BIS_fnc_initVehicle;
									
								},
								{},
								_spawned
							] call zen_dialog_fnc_create;
						};
						sleep 1;
						waitUntil {!dialog};
						if (_tickpylon) then {
							[_spawned] call zen_pylons_fnc_configure;
						};
						_spawned allowDamage true;
					};
				},
				{},
				[_obj]
			] call zen_dialog_fnc_create;
		},_this,1.5,true,true,"","true",5]] remoteExec ["addAction",0,_obj];
	};
	
	//BBUS_vehiclearsenal_fnc_addArsenalInit is now in config.cpp for initialization order.
	
	//BBUS_vehiclearsenal_cache=(((configfile >> 'CfgVehicles') call BIS_fnc_getCfgSubClasses) select {((getNumber (configFile >> 'CfgVehicles' >> _x >> 'isbackpack'))==0 && getNumber (configFile >> 'CfgVehicles'>>_x>>'scope') >=2 ) && (([ (configFile >> 'CfgVehicles'>>_x), true ] call BIS_fnc_returnParents) findIf {_x in ['Car','Tank','LandVehicle','Air','Boat','Ship','Water']}>-1 && getNumber (configFile >> 'CfgVehicles'>>_x>>'scope') >=2 && ((getNumber (configFile >> 'CfgVehicles'>>_x>>'hasDriver'))+ (getNumber (configFile >> 'CfgVehicles'>>_x>>'hasGunner')) + (getNumber (configFile >> 'CfgVehicles'>>_x>>'hasCommander'))+(getNumber (configFile >> 'CfgVehicles'>>_x>>'transportSoldier'))) >= 1 )});
	//BBUS_vehiclearsenal_cache=[BBUS_vehiclearsenal_cache, [], { (getNumber (configFile >> 'CfgVehicles' >> _x >> 'displayName')) }, "DESCEND"] call BIS_fnc_sortBy;
	["Basipek Bus", "Vehicle Arsenal Whitelist Creator", 
	{
		params ["_modulePosASL","_attachedObject"];

		createDialog "BBUS_vehiclearsenaldisplay";

	},"\BBUS_AegisModules\pictures\vehiclearsenalwhitelist.paa"] call zen_custom_modules_fnc_register;
	
	
	["Basipek Bus", "Vehicle Arsenal Add", 
	{
		params ["_modulePosASL","_attachedObject"];

		private _onConfirm = {
			_this spawn {
				_dialogReturn = _this select 0;
				_dialogReturn params ["_whitelist"];
				
				private _arguments = _this select 1; 
				_arguments params ["_modulePosASL", "_attachedObject"];

				[_attachedObject,_whitelist] call BBUS_vehiclearsenal_fnc_addArsenal;
			};
		};
		
		[
			"Add Vehicle Arsenal To Object", 
			[
				["EDIT",["Whitelist", "Put the list of vehicles you want to have here. Gotten from the Whitelist Creator Module"],["",{},0]]
			],
			_onConfirm,
			{},
			[_modulePosASL, _attachedObject]
		] call zen_dialog_fnc_create;

	},"\BBUS_AegisModules\pictures\vehiclearsenal.paa"] call zen_custom_modules_fnc_register;
	
//ADD WEAPON TURRET

	//modded people have a lot of weapons so we cache them at start
	BBUS_weaponturret_allweapons=[]; 
	{ 
		if ((getNumber (configfile >> "CfgWeapons" >> _x >> "Type") == 65536) && (count (getArray (configfile >> "CfgWeapons" >> _x >> "magazines")) !=0 ) && (getNumber (configfile >> "CfgWeapons" >> _x >> "scope") != 0)) then { 
			(BBUS_weaponturret_allweapons pushBackUnique [_x,(getText (configfile >> "CfgWeapons" >> _x >> "displayName"))])};
		 
	}forEach ((configfile >> "CfgWeapons") call BIS_fnc_getCfgSubClasses); 	
	
	BBUS_weaponturret_allweaponsdisplay=[]; 
	{
		BBUS_weaponturret_allweaponsdisplay pushBackUnique [_x#1,_x#0];
	}forEach BBUS_weaponturret_allweapons;
	
	
	//add
	["Basipek Bus", "Vehicle Weapon Add", 
	{
		params ["_modulePosASL","_attachedObject"];

		private _onConfirm = {
			_this spawn {
				_dialogReturn = _this select 0;
				_dialogReturn params ["_weapon","_slot"];
				
				private _arguments = _this select 1; //passed arguments from zen_dialog_fnc_create
				_arguments params ["_modulePosASL", "_attachedObject"];
				
				_attachedObject addWeaponTurret [_weapon#0,[0]];
				_attachedObject addMagazineTurret [selectRandom (getArray (configfile >> "CfgWeapons" >> (_weapon#0) >> "magazines")),[0]];
				
				[_attachedObject] call zen_loadout_fnc_configure;
			};
		};
		
		_slots = [[-1]] + (allTurrets [_attachedObject, false]);
		_slotsdisplay = ["Driver/Pilot"];
		
		[
			"Add Vehicle Weapon", 
			[
				["COMBO",["Weapon", "Weapon to add."],[BBUS_weaponturret_allweapons,BBUS_weaponturret_allweaponsdisplay,0]],
				["COMBO",["Slot", "Slot to add the weapon to."],[_slots,_slotsdisplay,0]]
			],
			_onConfirm,
			{},
			[_modulePosASL, _attachedObject]
		] call zen_dialog_fnc_create;

	},"\BBUS_AegisModules\pictures\weaponadd.paa"] call zen_custom_modules_fnc_register;
	
	//remove
	["Basipek Bus", "Vehicle Weapon Remove", 
	{
		params ["_modulePosASL","_attachedObject"];
		
		_slots = [[-1]] + (allTurrets [_attachedObject, false]);
		_slotsdisplay = ["Driver/Pilot"];
		//choose slot first
		[
			"Remove Vehicle Weapon", 
			[
				["COMBO",["Slot", "Slot to remove a weapon from."],[_slots,_slotsdisplay,0]]
			],
			{
				_dialogReturn = _this select 0;
				_dialogReturn params ["_slot"];
				
				private _arguments = _this select 1; //passed arguments from zen_dialog_fnc_create
				_arguments params ["_modulePosASL", "_attachedObject"];
				
				private _onConfirm = {
					_this spawn {
						_dialogReturn = _this select 0;
						_dialogReturn params ["_weapon"];
						
						private _arguments = _this select 1; //passed arguments from zen_dialog_fnc_create
						_arguments params ["_modulePosASL", "_attachedObject","_slot"];
						
						_attachedObject removeWeaponTurret [_weapon,_slot];
					};
				};
				
				//get all weapons from slot and use their display names
				_weapons = _attachedObject weaponsTurret _slot;
				_weaponsdisplay = [];
				{
					_weaponsdisplay pushBackUnique [_x,(getText (configfile >> "CfgWeapons" >> _x >> "displayName"))];
				}forEach _weapons;
				
				//remove weapon from the slot now
				[
					"Remove Vehicle Weapon", 
					[
						["COMBO",["Weapon", "Weapon to remove."],[_weapons,_weaponsdisplay,0]]
					],
					_onConfirm,
					{},
					[_modulePosASL, _attachedObject,_slot]
				] call zen_dialog_fnc_create;
			},
			{},
			[_modulePosASL, _attachedObject]
		] call zen_dialog_fnc_create;

	},"\BBUS_AegisModules\pictures\weaponremove.paa"] call zen_custom_modules_fnc_register;

//FULTON RECOVERY
	
	["Basipek Bus", "[ARCADE] Create Fulton LZ", 
		{
			params ["_modulePosASL","_attachedObject"];

			private _onConfirm = {
				_dialogReturn = _this select 0;
				_dialogReturn params ["_text"];
				
				private _arguments = _this select 1;
				_arguments params ["_modulePosASL", "_attachedObject"];
				
				if (_text=="") exitWith {
					["EMPTY NAME", "LZ name cannot be empty.", 5] call BIS_fnc_curatorHint;
				};
				
				if (isNull _attachedObject) then {
					_attachedObject = createVehicle ["BBUS_FultonObject_LZ",ASLToATL _modulePosASL,[],0,"NONE"];
					_attachedObject setVariable ["BBUS_Fulton_LZName",_text,true];
				}else {
					_pos = getPosATL _attachedObject;
					_attachedObject = createVehicle ["BBUS_FultonObject_LZ",_pos,[],0,"NONE"];
					_attachedObject setVariable ["BBUS_Fulton_LZName",_text,true];
				};
				
				{_x addCuratorEditableObjects [[_attachedObject], true]} forEach allCurators;
				
			};

			[
				"FULTON LZ", 
				[
				["EDIT",["Name of LZ", "Name that'll be shown in the lists."],["",{}]]
				],
				_onConfirm,
				{},
				[_modulePosASL, _attachedObject]
			] call zen_dialog_fnc_create;
		},"\BBUS_AegisModules\pictures\lzicon.paa"] call zen_custom_modules_fnc_register;

 	_action=["BBUS_FultonAction_Group","Fulton","\BBUS_AegisModules\pictures\Large.paa",{},{
			(!isNull (_player getVariable ["BBUS_Fulton_Attached",objNull]))||([_player,'BBUS_FultonItem_Small'] call ace_common_fnc_hasItem)||([_player,'BBUS_FultonItem_LZ'] call ace_common_fnc_hasItem)||
			([_player,'BBUS_FultonItem_Large'] call ace_common_fnc_hasItem)||([_player,'BBUS_FultonItem_Medium'] call ace_common_fnc_hasItem)
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment"],_action,true] call ace_interact_menu_fnc_addActionToClass;  

	_action=["BBUS_FultonAction_CancelSelf","Detach Fulton From Self","",{
				_player addItem (_player getVariable ["BBUS_Fulton_AttachedType","BBUS_FultonItem_Small"]);
				deleteVehicle (_player getVariable ["BBUS_Fulton_Attached",objNull]);
		},{
			!isNull (_player getVariable ["BBUS_Fulton_Attached",objNull])
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass; 
		
	_action=["BBUS_FultonAction_Cancel","Detach Fulton","",{
				_player addItem (cursorObject getVariable ["BBUS_Fulton_AttachedType","BBUS_FultonItem_Small"]);
				deleteVehicle (cursorObject getVariable ["BBUS_Fulton_Attached",objNull]);
		},{
			!isNull (cursorObject getVariable ["BBUS_Fulton_Attached",objNull])
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass;  
		
	_action=["BBUS_FultonAction_SmallSelf","Attach Fulton To Self","",{
				_player removeItem 'BBUS_FultonItem_Small';
				_player call BBUS_fnc_attachFulton;
		},{
			([_player,'BBUS_FultonItem_Small'] call ace_common_fnc_hasItem) && ((BBUS_Fulton_Complex) || ((!BBUS_Fulton_Complex) && BBUS_Fulton_ArcadeSelfEnabled) )
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass;  
	
	_action=["BBUS_FultonAction_LZ","Plant Fulton LZ","",{
		
				private _onConfirm = {
					_dialogReturn = _this select 0;
					_dialogReturn params ["_text","_setrespawn"];
					
					if (_text=="") exitWith {
						["EMPTY NAME", "LZ name cannot be empty.", 5] call BIS_fnc_curatorHint;
					};
					player removeItem 'BBUS_FultonItem_LZ';
					_obj = createVehicle ['BBUS_FultonObject_LZ',(getPosATL player), [], 0, 'CAN_COLLIDE'];
					[_obj, true] call ace_dragging_fnc_setCarryable;
					_obj setVariable ["BBUS_Fulton_LZName",_text,true];
					[player, _obj] call ace_dragging_fnc_carryObject;
					
					if (_setrespawn) then {
						_respawnid=[side player, _obj, _text] call BIS_fnc_addRespawnPosition;
						[_obj,_respawnid] spawn {
							params ["_obj","_respawnid"];
							waitUntil {!alive _obj};
							_respawnid call BIS_fnc_removeRespawnPosition;
						}
					};
				};

				[
					"FULTON LZ", 
					[
					["EDIT",["Name of LZ", "Name that'll be shown in the lists."],["",{}]],
					["CHECKBOX",["Set Respawn","Set the LZ as a respawn point for your side."],[false]]
					],
					_onConfirm,
					{},
					[]
				] call zen_dialog_fnc_create;
		},{
			([_player,'BBUS_FultonItem_LZ'] call ace_common_fnc_hasItem) && !(BBUS_Fulton_Complex)
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass; 
	
	_action=["BBUS_FultonAction_LZ_PickUp","Grab Fulton LZ","",{_player addItem 'BBUS_FultonItem_LZ'; deleteVehicle _target;},{_player canAdd "BBUS_FultonItem_LZ";},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction;
	["BBUS_FultonObject_LZ", 0, ["ACE_MainActions"],_action,false] call ace_interact_menu_fnc_addActionToClass;
		
	_action=["BBUS_FultonAction_Small","Attach Fulton [Small]","\BBUS_AegisModules\pictures\Person.paa",{
			if (_player distance cursorObject > 10) exitWith {systemChat "You need to get closer!";};
			if (!alive cursorObject || (cursorObject isKindOf "Static") || (!BBUS_Fulton_Complex && ({alive _x} count crew cursorObject != 0) && !(cursorObject isKindOf "CAManBase") ) || (!BBUS_Fulton_Complex && (cursorObject isKindOf "CAManBase") && (vehicle cursorObject != cursorObject) ) ) exitWith {systemChat "You can't extract that!";};
			if (getMass cursorObject <= 1000) then {
				cursorObject setVariable ["BBUS_Fulton_AttachedType","BBUS_FultonItem_Small",true];
				_player removeItem 'BBUS_FultonItem_Small';
				cursorObject call BBUS_fnc_attachFulton;
			}else {
				systemChat "You need a bigger device for that!";
			};
		},{
			[_player,'BBUS_FultonItem_Small'] call ace_common_fnc_hasItem
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction; 
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass;  

	_action=["BBUS_FultonAction_Medium","Attach Fulton [Medium]","\BBUS_AegisModules\pictures\Car.paa",{
			if (_player distance cursorObject > 10) exitWith {systemChat "You need to get closer!";};
			if (!alive cursorObject || (cursorObject isKindOf "Static") || (!BBUS_Fulton_Complex && ({alive _x} count crew cursorObject != 0) && !(cursorObject isKindOf "CAManBase") ) || (!BBUS_Fulton_Complex && (cursorObject isKindOf "CAManBase") && (vehicle cursorObject != cursorObject) ) ) exitWith {systemChat "You can't extract that!";};
			if (getMass cursorObject <= 10000) then {
				cursorObject setVariable ["BBUS_Fulton_AttachedType","BBUS_FultonItem_Medium",true];
				_player removeItem 'BBUS_FultonItem_Medium';
				cursorObject call BBUS_fnc_attachFulton;
			}else {
				systemChat "You need a bigger device for that!";
			};
		},{
			[_player,'BBUS_FultonItem_Medium'] call ace_common_fnc_hasItem
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction; 
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass;  

	_action=["BBUS_FultonAction_Large","Attach Fulton [Large]","\BBUS_AegisModules\pictures\Large.paa",{
			if (_player distance cursorObject > 10) exitWith {systemChat "You need to get closer!";};
			if (!alive cursorObject || (cursorObject isKindOf "Static") || (!BBUS_Fulton_Complex && ({alive _x} count crew cursorObject != 0) && !(cursorObject isKindOf "CAManBase") ) || (!BBUS_Fulton_Complex && (cursorObject isKindOf "CAManBase") && (vehicle cursorObject != cursorObject) ) ) exitWith {systemChat "You can't extract that!";};
			if (true) then {
				cursorObject setVariable ["BBUS_Fulton_AttachedType","BBUS_FultonItem_Large",true];
				_player removeItem 'BBUS_FultonItem_Large';
				cursorObject call BBUS_fnc_attachFulton;
			};
		},{
			[_player,'BBUS_FultonItem_Large'] call ace_common_fnc_hasItem
		},{},[], [0,0,0], 100] call ace_interact_menu_fnc_createAction; 
	["CAManBase", 1, ["ACE_SelfActions","ACE_Equipment","BBUS_FultonAction_Group"],_action,true] call ace_interact_menu_fnc_addActionToClass;  


	BBUS_fnc_attachFulton = {
		_target = _this;
		if !(BBUS_Fulton_Complex) then {
			_shopoptions=[objNull]+((allMissionObjects "Land_AirHorn_01_F") select {(typeName (_x getVariable ["BBUS_Fulton_LZName",objNull])) == "STRING"});
			_shopoptionsnames=["NO LZ"];
			{
			 if !(isNull _x) then {
			  _shopoptionsnames pushBack [(_x getVariable ["BBUS_Fulton_LZName",objNull]),"",""];
			 };
			} forEach _shopoptions;
			 ["CHOOSE LZ FOR FULTON", 
			 [ 
			  ["LIST", ["LZ","Choose which LZ to Fulton this to."], [_shopoptions,_shopoptionsnames,0]] 
			 ], 
			 BBUS_fnc_fultonCode,
			 {player addItem ((_this#1) getVariable ["BBUS_Fulton_AttachedType","BBUS_FultonItem_Small"]);}, 
			 _target
			] call zen_dialog_fnc_create;
		}else{[[objNull],_target] call BBUS_fnc_fultonCode;};
	};
	
	BBUS_fnc_fultonCode={
		params["_values","_target"];
		_values params ["_lz"];
		
		if (BBUS_Fulton_Portal && !BBUS_Fulton_Complex) exitWith {
			[_target,["BBUS_AegisModules_items_fulton_place",1000]] remoteExec ["say3D",0];
			_boundingbox=boundingBox _target;
			private ["_xmin", "_ymin", "_zmin","_xmax", "_zmax", "_zmax","_mins", "_maxes", "_boundingSphereDiameter"];
			_boundingbox params ["_mins", "_maxes", "_boundingSphereDiameter"];
			_mins params ["_xmin", "_ymin", "_zmin"];
			_maxes params ["_xmax", "_ymax", "_zmax"];
			_portal = createVehicle ["UserTexture1m_F",getPosATL _target vectorAdd [0,0,(_zmax-_zmin)*1.5],[],0,"CAN_COLLIDE"];
			[_portal,90,0] call BIS_fnc_setPitchBank;
			[[_zmax,_zmin,_xmax,_xmin,_ymax,_ymin,_target,_portal],{
				params ["_zmax","_zmin","_xmax","_xmin","_ymax","_ymin","_target","_portal"];
				_ps1 = "#particlesource" createVehicleLocal ((getPosATL _target) vectorAdd [0,0,(_zmax-_zmin)*1.5]);
				_ps1 setPosATL ((getPosATL _portal) vectorAdd [0,0,0.1]);
				_ps1 setParticleParams [ 
				 ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 7, 1], "", "Billboard", 
				 1, 1, [0, 0, 0], [0, 0, 0], 0, 1.25, 1, 0, [(((_ymax-_ymin)+(_xmax-_xmin))*0.3),0.5], 
				 [[1,0.3,0.15,0.5], [0.95,0.5,0.1,0.5], [0.5,0,0,1]], 
				 [0.25,1], 0, 0, "", "", _ps1]; 
				_ps1 setParticleRandom [0, [0.5, 0.5, 0.25], [0, 0.125, 0], 0.2, 0.5, [0.5, 0, 0, 0.5], 0, 0]; 
				_ps1 setDropInterval ((0.001) max (0.01-(0.001*(((_ymax-_ymin)+(_xmax-_xmin))*0.75))));
				_ps1 setParticleCircle [(((_ymax-_ymin)+(_xmax-_xmin))*0.4), [-1,-(((_ymax-_ymin)+(_xmax-_xmin))*0.4),0]];
				waitUntil {!alive _portal || !alive _ps1}; deleteVehicle _ps1; deleteVehicle _portal;
			}] remoteExec ["spawn",0,_portal];
			[_target,_portal,_lz,_zmax,_zmin] spawn {
				params ["_target","_portal","_lz","_zmax","_zmin"];
				sleep 0.1;
				[_portal,[("BBUS_AegisModules_mgsvportal0"+(selectRandom ["1","2"])),250]] remoteExec ["say3D",0];
				if (_target iskindOf "CAManBase") then {
					_speech = "BBUS_AegisModules_vox_ene_panic_0" + selectRandom ["1","2"];
					[_target,[_speech,1000]] remoteExec ["say3D",0];
				};
				private _initpos = (getPosWorld _target);
				waitUntil {
					sleep 0.1;
					
					if (_target iskindOf "CAManBase") then {
						[_target, "AswmPercMstpSnonWnonDnon_godown"] remoteExec ["playMoveNow", 0];
						_target setVelocity [0,0,1];
					}else {
						_target enableSimulationGlobal false;
					};
					_target setPosWorld ((getPosWorld _target) vectorAdd ((_initpos vectorDiff ((getPosWorld _portal) vectorAdd [0,0,1])) vectorMultiply (-1/30)));
					
					((!alive _target) || (((getPosATL _target) # 2)>((getPosATL _portal) # 2)))
				};
				if (alive _target) then {
					_target enableSimulationGlobal true;
					if !(isNull _lz) then {
						_target setVelocity [0,0,0];
						_target setPos ((getPosATL _lz) findEmptyPosition [5, 100, typeOf _target]);
					}else{
						if (!isPlayer _target) then {
							deleteVehicle _target;
						};
					};
					_speech = "BBUS_AegisModules_vox_miller_target_extracted" + selectRandom ["1","2","3","4","5","6","7","8","9"];
					playSound _speech;
				};
				sleep 0.2;
				deleteVehicle _portal;
			};
		};
		
		_parachute = createVehicle ["B_Parachute_02_F",getPosATL _target vectorAdd [0,0,2],[],0,"NONE"];
		
		private _chemlight = "Land_TentLamp_01_suspended_red_F" createVehicle (position _parachute);
		_chemlight attachTo [_parachute, [0,0,4]];
		
		[_chemlight,_parachute] spawn {
			params ["_chemlight","_parachute"];
			waitUntil {!alive _chemlight||!alive _parachute};
			deleteVehicle _chemlight;
		};
		
		_target setVariable ["BBUS_Fulton_Attached",_parachute,true];
		_parachute hideObjectGlobal true;
		_balloonrope = ropeCreate [_parachute, [0,0,-2], _target, [0,-.125,1.5], 20];
		_posmodelASL = [0,0,1000];
		_balloon = createSimpleObject ["a3\structures_f_mark\items\sport\balloon_01_air_f.p3d", _posmodelASL];
		[_balloon,_parachute] spawn {
			params ["_balloon","_parachute"];
			sleep 1;
			_balloon attachTo [_parachute, [0,0,0]];
			_balloon setObjectScale 1;
			while {getObjectScale _balloon <= 15 && alive _balloon} do {
				_balloon setObjectScale ((getObjectScale _balloon) + .01);
			};
		};



		_terminator=[_balloon,_balloonrope,_target,_parachute] spawn {
			params ["_balloon","_balloonrope","_target","_parachute"];
			waitUntil {(!alive _balloon)||(!alive _balloonrope)||(!alive _target) || (count (ropesAttachedTo _target))<1 ||(!alive _parachute)};
			deleteVehicle _balloon;
			deleteVehicle _parachute;
			ropeDestroy _balloonrope;
		};

		[_parachute,_terminator,_target,_balloon,_balloonrope,_lz] spawn {
			params ["_parachute","_terminator","_target","_balloon","_balloonrope","_lz"];
			if (_target isKindOf "CAManBase" && !(isPlayer _target)) then {
				_speech = "BBUS_AegisModules_vox_ene_wake_0" + selectRandom ["1","2"];
				[_target,[_speech,1000]] remoteExec ["say3D",0];
			};
			[_parachute,["BBUS_AegisModules_items_fulton_place",1000]] remoteExec ["say3D",0];
			while {sleep 0.1; alive _parachute} do {
				if (((getPosATL _parachute) # 2) <= 100) then {
					_parachute setVelocity [0,0,5];
					_parachute setDir 0;
				}else{
					if !(lineIntersectsSurfaces [getPosWorld _target vectorAdd [0,0,1], getPosWorld _target vectorAdd [0, 0, 5], _target, _balloon, true, 1, "GEOM", "NONE"] isEqualTo []) then {
						deleteVehicle _balloon;
						_speech = "BBUS_AegisModules_vox_miller_extract_failed";
						playSound _speech;
					};
					if (!isNil "BBUS_Fulton_Complex") then {
						if (!(BBUS_Fulton_Complex) && (((getPosATL _parachute) # 2) > 100)) then {
							_parachute setVelocity [0,0,50];
						};
					};
				};
				_objects = (nearestObjects [_parachute, ["plane","helicopter"], 30]) select {!(_x isKindOf "ParachuteBase")};
				if (!isNil "BBUS_Fulton_Complex") then {
					if (!(BBUS_Fulton_Complex) && (alive _parachute)) exitWith {
						sleep 0.1;
						terminate _terminator;
						
						if (_target isKindOf "CAManBase" && !(isPlayer _target)) then {
							_speech = "BBUS_AegisModules_vox_ene_panic_0" + selectRandom ["1","2"];
							[_target,[_speech,1000]] remoteExec ["say3D",0];
						};
						[_parachute,_target] spawn {waitUntil {!alive (_this#0) || (((getPosATL (_this#0)) # 2) >= 100)}; [_this#0,["BBUS_AegisModules_items_fulton_fly",1000]] remoteExec ["say3D",0];
							if ((_this#1) isKindOf "CAManBase" && !(isPlayer (_this#1)) && alive (_this#0)) then {
								_speech = "BBUS_AegisModules_vox_ene_fultonscream_0" + selectRandom ["1","2","3","4"];
								[(_this#1),[_speech,1000]] remoteExec ["say3D",0];
								[(_this#1), "Acts_HeliCargo_in"] remoteExec ["switchMove", 0];
							};
						};
						_v = 15;
						waitUntil {
							if (((getPosATL _parachute) # 2) <= 100) then {
								_parachute setVelocity [0,0,10];
							}else{
								_v=_v+1;
								_parachute setVelocity [0,0,_v];
							};
							
							if (lineIntersectsSurfaces [getPosWorld _target vectorAdd [0,0,1], getPosWorld _target vectorAdd [0, 0, 5], _target, _balloon, true, 1, "GEOM", "NONE"] isEqualTo []) then {
								[_target, [0,0,0], [0,0,-1]] ropeAttachTo _balloonrope;
							};
							
							(((getPosATL _target) # 2) > 200) || !(alive _target) || (count (ropesAttachedTo _target))<1};
						
						if !(alive _target && (count (ropesAttachedTo _target))>=1) then {
							_speech = "BBUS_AegisModules_vox_miller_extract_failed";
							playSound _speech;
							[_target, ""] remoteExec ["switchMove", 0];
						}else {
							if (isNull _lz) then {
								if (alive _parachute && (count (ropeAttachedObjects _parachute))>=1) then {
									_speech = "BBUS_AegisModules_vox_miller_target_extracted" + selectRandom ["1","2","3","4","5","6","7","8","9"];
									playSound _speech;
								};
								if !(_target isKindOf "CAManBase") then {
									{deleteVehicle _x;} forEach (crew _target);
								};
								if (!isPlayer _target) then {
									deleteVehicle _target;
								};
							} else {
								if (alive _parachute && (count (ropeAttachedObjects _parachute))>=1) then {
									_speech = "BBUS_AegisModules_vox_miller_target_extracted" + selectRandom ["1","2","3","4","5","6","7","8","9"];
									playSound _speech;
								};
								[_target, ""] remoteExec ["switchMove", 0];
								_target setVelocity [0,0,0];
								_target setPos (((getPosATL _lz) findEmptyPosition [5, 100, typeOf _target]) vectorAdd [0,0,1]);
							};
						};
						
						deleteVehicle _balloon;
						deleteVehicle _parachute;
						ropeDestroy _balloonrope;
						
					};
				};
				
				if (count _objects > 0) then {
					
					if (_target isKindOf "CAManBase" && !(isPlayer _target)) then {
						_speech = "BBUS_AegisModules_vox_ene_grunt_01";
						[_target,[_speech,1000]] remoteExec ["say3D",0];
					};
					terminate _terminator;
					waitUntil {scriptDone _terminator};
					_craft = _objects # 0;
					_craft enableRopeAttach true;
					_target enableRopeAttach true;
					[_craft,["BBUS_AegisModules_items_fulton_fly",1000]] remoteExec ["say3D",0];
					
					_parachute ropeDetach _balloonrope;
					deleteVehicle _balloon;
					deleteVehicle _parachute;
					ropeDestroy _balloonrope;
					
					_balloonrope = ropeCreate [_craft, [0,0,0], _target, [0,-.125,1.5], 100];
					
					ropeUnwind [_balloonrope, 10, 1, false];
					[_craft, [0,0,0], [0,0,-1]] ropeAttachTo _balloonrope;
					_craft disableCollisionWith _target;
					[_target, "Acts_HeliCargo_in"] remoteExec ["switchMove", 0];
					
					sleep 1;
					if (_target isKindOf "CAManBase" && !(isPlayer _target)) then {
						_speech = "BBUS_AegisModules_vox_ene_fultonscream_0" + selectRandom ["1","2","3","4"];
						[_target,[_speech,1000]] remoteExec ["say3D",0];
					};
					waitUntil {sleep 0.1; [_target, [0,0,0], [0,0,-1]] ropeAttachTo _balloonrope; ((_target distance _craft) <= 15) || !(alive _balloonrope) || !(alive _target) || (count (ropesAttachedTo _target))<1};
					
					
					if (vehicle _target == _target) then {
						[_target, ""] remoteExec ["switchMove", 0];
					};
					if (!alive _target || (count (ropesAttachedTo _target))<1) exitWith {deleteVehicle _parachute; ropeDestroy _balloonrope;};
					
					if (_target isKindOf "CAManBase") then {
						ropeDestroy _balloonrope;
						_target moveInAny _craft;
					}else{
						if ((_craft canVehicleCargo _target)#0) then {
							ropeUnwind [_balloonrope, 5, 10];
							ropeDestroy _balloonrope;
							_craft setVehicleCargo _target;
						}else {
							if !([_target, _craft] call ace_cargo_fnc_loadItem) then {
								if (_craft canSlingLoad _target) then {
									ropeUnwind [_balloonrope, 5, 10];
									_target ropeDetach _balloonrope;
									ropeDestroy _balloonrope;
									_craft setSlingLoad _target;
								}else {
									ropeUnwind [_balloonrope, 5, 30];
									[_target,_balloonrope,_craft] spawn {
										params ["_target","_balloonrope","_craft"];
										waitUntil {!alive _target || !alive _balloonrope || !alive _craft || (getPosATL _target)#2 < 5};
										ropeDestroy _balloonrope;
									};
								};
							};
						};
					};
					
				};
			};
		};

		ropeUnwind [_balloonrope, 20, 110];
	};