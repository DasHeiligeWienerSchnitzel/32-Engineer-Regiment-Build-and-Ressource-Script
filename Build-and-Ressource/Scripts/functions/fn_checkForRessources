/*
Creates an ace interaction point to check for ressources inside the crate.
*/

params ["_crate"];

if (isNull _crate) exitWith {};

_ER32_ressources = [
	"ER32_Ressources",
	"Check for Ressource inside",
	"",
	{
		params ["_target","_player","_params"];
		private _ressource = (_params select 0) getVariable ["ER32_Fortify_Ressources",[0,0,0,0]];
		hint format [
			"Ressources inside:\nConcrete: %1\nWood: %2\nSand: %3\nMetall: %4",
			_ressource select 0,
			_ressource select 1,
			_ressource select 2,
			_ressource select 3
		];
	},
	{true},
	{},
	[_crate]
	] call ace_interact_menu_fnc_createAction;
[_crate, 0, ["ACE_MainActions"], _ER32_ressources] call ace_interact_menu_fnc_addActionToObject;
