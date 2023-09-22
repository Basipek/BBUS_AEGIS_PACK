#include "\a3\ui_f\hpp\defineDIKCodes.inc"
["Basipek's Aegis Additions", "BBUS_Aegis_addDotKey", "Create Map Dot On Pos", {
	if !(BBUS_AllowMapDotKeybind) exitWith {};
	_marker = createMarker ["_USER_DEFINED" + (str (getPosATL player)), player, 0, player];
	_marker setMarkerSize [1.6, 1.6];
	_marker setMarkerType "Contact_dot1";
}, "", [0, [false, false, false]]] call CBA_fnc_addKeybind;
["BBUS_AllowMapDotKeybind", "CHECKBOX", ["Allow Map Dot Keybind",""], ["Basipek's Aegis Additions", "Map"], true, 1, {}, false] call CBA_fnc_addSetting;
["BBUS_Fulton_Complex", "CHECKBOX", ["Realistic Fulton Recovery","Instead of teleporting or deleting the payload, let aircraft pick it up like in real life."], ["Basipek's Aegis Additions", "Fulton Recovery"], false, 1, {}, false] call CBA_fnc_addSetting;
["BBUS_Fulton_Portal", "CHECKBOX", ["[ARCADE ONLY] Instant Fulton Recovery","Instead of using a balloon for ARCADE Fultoning, use a wormhole."], ["Basipek's Aegis Additions", "Fulton Recovery"], false, 1, {}, false] call CBA_fnc_addSetting;
["BBUS_Fulton_ArcadeSelfEnabled", "CHECKBOX", ["[ARCADE ONLY] Self-Fulton","Allows people to fulton themselves while using Arcade setting."], ["Basipek's Aegis Additions", "Fulton Recovery"], true, 1, {}, false] call CBA_fnc_addSetting;
