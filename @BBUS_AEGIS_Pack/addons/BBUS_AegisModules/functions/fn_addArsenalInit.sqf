/*
	Author: Basipek Bus

	Description:
		Adds a ZEN dialogue scroll-menu-action for spawning and customizing a list of vehicles.

	Parameter(s):
		0: Object - the "garage"
		1: Array - The list of vehicle classes that we can choose.




	Returns:
		Nothing

	Examples:
		[this,["O_Heli_Light_02_dynamicLoadout_F","B_APC_Tracked_01_rcws_F","C_Boat_Civil_01_F","C_Offroad_01_F","I_G_Offroad_01_AT_F"]] call BBUS_vehiclearsenal_fnc_addArsenalInit;
*/
params ["_obj","_list"]; _this = [_obj,_list]; if ( ( { ( (_obj actionParams _x)#0 ) == "Use Vehicle Arsenal" } count (actionIDs _obj) ) != 0) then {_obj removeAction ( (actionIDs _obj) findIf { ( (_obj actionParams _x)#0 ) == "Use Vehicle Arsenal" })}; 
	_obj addAction ["Use Vehicle Arsenal",{
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
	},_this,1.5,true,true,"","true",5];
