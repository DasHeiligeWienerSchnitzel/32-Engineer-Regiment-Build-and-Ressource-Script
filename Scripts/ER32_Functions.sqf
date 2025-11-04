/*
Contains all the functions that are used.
*/

ER32_fnc_checkForRessources = {

	/*
	Creates an ace interaction point to check for ressources inside the crate.
	*/
	
	params ["_ressource","_crate"];
	
	_ER32_ressources = [
		"ER32_Ressources",
		"Check for Ressource inside",
		"",
		{
			params ["_target","_player","_params"];
			_ressource = _params select 0;
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
		[_ressource]
		] call ace_interact_menu_fnc_createAction;
	[_crate, 0, ["ACE_MainActions"], _ER32_ressources] call ace_interact_menu_fnc_addActionToObject;	
};

ER32_fnc_loadOnFlatbed = {

	/*
	Creates an ace interaction point to put the crates onto the flatbed. 
	More info the the "ER32_Flatbed.sqf".
	*/
	
	params ["_crate"];
	
	_ER32_loadOnFlatbed = [
		"ER32_LoadOnFlatbed",
		"Load on Flatbed",
		"",
		{
			params ["_target","_player","_params"];
			[_target] execVM "ER32_Flatbed.sqf"
		},
		{true}
	] call ace_interact_menu_fnc_createAction;
	[_crate, 0, ["ACE_MainActions"], _ER32_loadOnFlatbed] call ace_interact_menu_fnc_addActionToObject;
};
