/*
This script adds the new ace interaction points that enables the player to build pre determined structures 
through the Classnames List. Found in the ER32_Classnames.sqf file.
*/

params ["_classname_list","_maxHeight","_minHeight"];

//Creates first interaction point.

_ER32_buildAndRessources_mainCategory = [
	"ER32_buildAndRessources_buildCategory",
	"Build",
	"",
	{true},
	{
		("ACE_Fortify" in (items player)) and (player == vehicle player)
	}
] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _ER32_buildAndRessources_mainCategory] call ace_interact_menu_fnc_addActionToObject;

//Gets all the categories written in the "ER32_Classnames.sqf".

_categoryList = [];
{
	_categoryList pushBack (_x select 3);
}forEach _classname_list;

//Deletes all duplicates.

_categoryList = _categoryList arrayIntersect _categoryList;

//Creates the ACE Self Interaction Points based on the categories.

{
	_categories = ["ER32_buildAndRessources_categories" + _x, _x, "", {true}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","ER32_buildAndRessources_buildCategory"], _categories] call ace_interact_menu_fnc_addActionToObject;
}forEach _categoryList;

//Adds ACE Self Interaction to check nearby creates on ressource count.

_ER32_buildAndRessources_ressources = [
	"ER32_buildAndRessources_ressources",
	"Check for ressources",
	"",
	{
		
		params ["_target","_player","_params"];
		_crates = ER32_buildAndRessources_crates;
		_names = ER32_buildAndRessources_names;
		
		//Gets all the valid crates in a 50 meter radius around the player.
		
		_cratesNearby = _player nearEntities [_crates,50];
		
		//Goes through all the collected Crates and collects the ressources.
		
		_ressources = [0,0,0,0];
		{
			_ressourcesToAdd = _x getVariable ["ER32_buildAndRessources_ressources", [0,0,0,0]];
			for "_i" from 0 to ((count _ressources) - 1) do {
				_ressources set [_i, (_ressources select _i) + (_ressourcesToAdd select _i)];
			};
		}forEach _cratesNearby;
		
		//Tells the player how many ressources are nearby.
		
		hint format [
			"Ressources nearby:\n"+(_names select 0)+": %1\n"+(_names select 1)+": %2\n"+(_names select 2)+": %3\n"+(_names select 3)+": %4",
			_ressources select 0,
			_ressources select 1,
			_ressources select 2,
			_ressources select 3
		];
		
	},
	{true},
	{}
	] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions","ER32_buildAndRessources_buildCategory"], _ER32_buildAndRessources_ressources] call ace_interact_menu_fnc_addActionToObject;

/*
Creates an interaction point for each element in the corresponding list.
*/

{
	_class = _x select 0;
	_ressources = _x select 1;
	_name = (_x select 2) + " " + str(_ressources);
	_category = _x select 3;
	_time = _x select 4;
	
	_newCategory = [
		_name,
		_name,
		"",
		{
			params ["_target","_player","_params"];
			_params params ["_class","_ressources","_name","_time","_maxHeight","_minHeight"];
			[_class,_ressources,_name,_time,_player,_maxHeight,_minHeight] remoteExec ["ER32_fnc_buildAndRessources_placeObject",_player];
		},
		{true},
		{},
		[_class,_ressources,_name,_time,_maxHeight,_minHeight]
	] call ace_interact_menu_fnc_createAction;
		
	[
		player,
		1,
		["ACE_SelfActions","ER32_buildAndRessources_buildCategory","ER32_buildAndRessources_categories" + _category],
		_newCategory
	] call ace_interact_menu_fnc_addActionToObject;
} forEach _classname_list;
