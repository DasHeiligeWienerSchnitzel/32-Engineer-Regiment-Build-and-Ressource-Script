/*
Creates an ace interaction point to put the crates onto the flatbed. 
More info the the "ER32_Flatbed.sqf".
*/

params ["_crate","_crates"];

_ER32_loadOnFlatbed = [
	"ER32_LoadOnFlatbed",
	"Load on Flatbed",
	"",
	{
		params ["_target","_player","_params"];
		_crates = _params select 0;
		[_target,_crates] execVM "ER32_Flatbed.sqf";
	},
	{true},
	{},
	[_crates]
] call ace_interact_menu_fnc_createAction;
[_crate, 0, ["ACE_MainActions"], _ER32_loadOnFlatbed] call ace_interact_menu_fnc_addActionToObject;
