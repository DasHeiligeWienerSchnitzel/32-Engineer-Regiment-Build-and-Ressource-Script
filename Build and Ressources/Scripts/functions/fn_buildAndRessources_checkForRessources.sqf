/*
Creates an ace interaction point to check for ressources inside the crate.
*/

params ["_crate","_names"];

if (isNull _crate) exitWith {};

_ER32_buildAndRessources_ressources = [
	"ER32_buildAndRessources_ressources",
	"Check for Ressource inside",
	"",
	{
		params ["_target","_player","_params"];
		private _ressource = (_params select 0) getVariable ["ER32_buildAndRessources_ressources",[0,0,0,0]];
		_names = _params select 1;
		hint format [
			"Ressources inside:\n"+(_names select 0)+": %1\n"+(_names select 1)+": %2\n"+(_names select 2)+": %3\n"+(_names select 3)+": %4",
			_ressource select 0,
			_ressource select 1,
			_ressource select 2,
			_ressource select 3
		];
	},
	{true},
	{},
	[_crate,_names]
	] call ace_interact_menu_fnc_createAction;
[_crate, 0, ["ACE_MainActions"], _ER32_buildAndRessources_ressources] call ace_interact_menu_fnc_addActionToObject;
