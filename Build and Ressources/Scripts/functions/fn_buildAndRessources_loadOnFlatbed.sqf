/*
Creates an ace interaction point to put the crates onto the flatbed. 
More info the the "ER32_Flatbed.sqf".
*/

params ["_crate"];

_ER32_buildAndRessources_loadOnFlatbed = [
	"ER32_buildAndRessources_loadOnFlatbed",
	"Load on Flatbed",
	"",
	{
		params ["_target","_player","_params"];
		[_target] execVM "Scripts\ER32_buildAndRessources_flatbed.sqf";
	},
	{true},
	{}
] call ace_interact_menu_fnc_createAction;
[_crate, 0, ["ACE_MainActions"], _ER32_buildAndRessources_loadOnFlatbed] call ace_interact_menu_fnc_addActionToObject;
