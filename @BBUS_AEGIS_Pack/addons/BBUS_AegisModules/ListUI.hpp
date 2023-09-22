class BBUS_vehiclearsenaldisplay
{
	onLoad = "BBUS_vehiclearsenalexport=[];";
	idd = 1919;
	class Controls {
		class RscListbox_1500: RscListbox
		{
			onLoad = "params ['_ctrl']; {_ctrl lbAdd (getText (configFile >> 'CfgVehicles' >> _x >> 'displayName')); _ctrl lbSetTooltip [_forEachIndex, _x]; _ctrl lbSetPicture [_forEachIndex, (getText (configFile >> 'CfgVehicles' >> _x >> 'editorPreview'))]; _ctrl lbSetData [_forEachIndex, _x];} forEach (((configfile >> 'CfgVehicles') call BIS_fnc_getCfgSubClasses) select {((getNumber (configFile >> 'CfgVehicles' >> _x >> 'isbackpack'))==0 && getNumber (configFile >> 'CfgVehicles'>>_x>>'scope') >=2 ) && (([ (configFile >> 'CfgVehicles'>>_x), true ] call BIS_fnc_returnParents) findIf {_x in ['Car','Tank','LandVehicle','Air','Boat','Ship','Water']}>-1 && getNumber (configFile >> 'CfgVehicles'>>_x>>'scope') >=2 && ((getNumber (configFile >> 'CfgVehicles'>>_x>>'hasDriver'))+ (getNumber (configFile >> 'CfgVehicles'>>_x>>'hasGunner')) + (getNumber (configFile >> 'CfgVehicles'>>_x>>'hasCommander'))+(getNumber (configFile >> 'CfgVehicles'>>_x>>'transportSoldier'))) >= 1 )}); _ctrl lbSortBy ['VALUE', false, false];";
			onLBSelChanged = "params ['_control', '_lbCurSel', '_lbSelection']; if ((_control lbData _lbCurSel) in BBUS_vehiclearsenalexport) then {_control lbSetColor [_lbCurSel,[0.5,1,0.5,1]];} else {_control lbSetColor [_lbCurSel,[1,1,1,1]];};";
			onKeyDown = "params ['_displayOrControl', '_key', '_shift', '_ctrl', '_alt']; if (_key == 28) exitWith {if ((_displayOrControl lbColor (lbCurSel _displayOrControl)) isEqualTo [1,1,1,1]) then { params ['_ctrl']; BBUS_vehiclearsenalexport pushBackUnique (_displayOrControl lbData (lbCurSel _displayOrControl)); _displayOrControl lbSetColor [(lbCurSel _displayOrControl),[0.5,1,0.5,1]]; true;} else {params ['_ctrl']; BBUS_vehiclearsenalexport deleteAt (BBUS_vehiclearsenalexport find (lbData [1500,lbCurSel 1500])); _displayOrControl lbSetColor [(lbCurSel _displayOrControl),[1,1,1,1]];true;};}; false;";
			idc = 1500;
			text = "Vehicles"; //--- ToDo: Localize;
			x = 3 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 15 * GUI_GRID_W;
			h = 18 * GUI_GRID_H;
		};
		class RscButton_1600: RscButton
		{
			onButtonClick = "params ['_ctrl']; BBUS_vehiclearsenalexport pushBackUnique (lbData [1500,lbCurSel 1500]); lbSetColor [1500,(lbCurSel 1500),[0.5,1,0.5,1]]; true;";
			idc = 1600;
			tooltip = "You can press ENTER instead, it'll toggle.";
			text = "+"; //--- ToDo: Localize;
			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
		};
		class RscButton_1601: RscButton
		{
			onButtonClick = "params ['_ctrl']; BBUS_vehiclearsenalexport deleteAt (BBUS_vehiclearsenalexport find (lbData [1500,lbCurSel 1500])); lbSetColor [1500,(lbCurSel 1500),[1,1,1,1]]; true;";
			idc = 1601;
			tooltip = "You can press ENTER instead, it'll toggle.";
			text = "-"; //--- ToDo: Localize;
			x = 18 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
		};
		class RscEdit_1400: RscEdit
		{
			tooltip = "This is the output for the module, it's an array of the classnames we just selected. CTRL+A then CTRL+C works!";
			idc = 1400;
			x = 19 * GUI_GRID_W + GUI_GRID_X;
			y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class RscEdit_1401: RscEdit
		{
			tooltip="You can put this box's text into the init field of an 3DEN object to make it an arsenal!";
			idc = 1401;
			x = 19 * GUI_GRID_W + GUI_GRID_X;
			y = 15 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class RscEdit_1402: RscEdit
		{
			tooltip = "Enter name to search. Press ENTER to apply search.";
			onKeyDown = "params ['_control', '_key']; hint str time; if (_key == 28) then { lbClear 1500; {lbAdd [1500,(getText (configFile >> 'CfgVehicles' >> _x >> 'displayName'))]; lbSetTooltip [1500,_forEachIndex, _x]; lbSetPicture [1500,_forEachIndex, (getText (configFile >> 'CfgVehicles' >> _x >> 'editorPreview'))]; lbSetData [1500,_forEachIndex, _x];} forEach (((configfile >> 'CfgVehicles') call BIS_fnc_getCfgSubClasses) select { ( ( (toLower (getText (configFile >> 'CfgVehicles' >> _x >> 'displayName'))) find (toLower (ctrlText _control))) > -1 ) && ((getNumber (configFile >> 'CfgVehicles' >> _x >> 'isbackpack'))==0 && getNumber (configFile >> 'CfgVehicles'>>_x>>'scope') >=2 ) && (([ (configFile >> 'CfgVehicles'>>_x), true ] call BIS_fnc_returnParents) findIf {_x in ['Car','Tank','LandVehicle','Air','Boat','Ship','Water']}>-1 && getNumber (configFile >> 'CfgVehicles'>>_x>>'scope') >=2 && ((getNumber (configFile >> 'CfgVehicles'>>_x>>'hasDriver'))+ (getNumber (configFile >> 'CfgVehicles'>>_x>>'hasGunner')) + (getNumber (configFile >> 'CfgVehicles'>>_x>>'hasCommander'))+(getNumber (configFile >> 'CfgVehicles'>>_x>>'transportSoldier'))) >= 1 )}); 1500 lbSortBy ['VALUE', false, false];};";
			idc = 1402;
			x = 3 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class RscButton_1602: RscButton
		{
			onButtonClick = "params ['_ctrl']; ctrlSetText [1400, str BBUS_vehiclearsenalexport]; ctrlSetText [1401, '[this,'+(str BBUS_vehiclearsenalexport)+'] call BBUS_vehiclearsenal_fnc_addArsenalInit;'];";
			idc = 1602;
			text = "Export"; //--- ToDo: Localize;
			x = 19 * GUI_GRID_W + GUI_GRID_X;
			y = 17.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class RscButton_1603: RscButton
		{
			onButtonClick = "params ['_ctrl']; BBUS_vehiclearsenalexport = call (compile (ctrlText 1400)); for '_i' from 1 to (lbSize 1500) do {if (lbData [1500,_i-1] in BBUS_vehiclearsenalexport) then {lbSetColor [1500,_i-1,[0.5,1,0.5,1]]; true;} else {lbSetColor [1500,_i-1,[1,1,1,1]];true;};};";
			idc = 1603;
			text = "Import"; //--- ToDo: Localize;
			x = 27 * GUI_GRID_W + GUI_GRID_X;
			y = 17.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
	};
};
