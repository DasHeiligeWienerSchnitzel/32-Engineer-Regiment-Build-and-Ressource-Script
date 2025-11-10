//Creates first interaction point.

_ER32_MainCategory = ["ER32_BuildCategory","Build","",{true},{"ACE_Fortify" in (items player)}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _ER32_MainCategory] call ace_interact_menu_fnc_addActionToObject;

//Gets all the categories written in the "ER32_Classnames.sqf".

_ER32_categoryList = [];
{
	_ER32_categoryList pushBack (_x select 3);
}forEach ER32_Classname_List;

//Deletes all duplicates.

_ER32_categoryList = _ER32_categoryList arrayIntersect _ER32_categoryList;

//Creates the ACE Self Interaction Points based on the categories.

{
	_ER32_Categories = ["ER32_Categories" + _x, _x, "", {true}, {true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions","ER32_BuildCategory"], _ER32_Categories] call ace_interact_menu_fnc_addActionToObject;
}forEach _ER32_categoryList;

//Adds ACE Self Interaction to check nearby creates on ressource count.

_ER32_Ressources = [
	"ER32_Ressources",
	"Check for ressources",
	"",
	{
		params ["_target","_player","_params"];
		
		//Gets all the valid crates in a 50 meter radius around the player.
		
		_cratesNearby = _player nearEntities [["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"],50];
		
		//Goes through all the collected Crates and collects the ressources.
		
		_ressources = [0,0,0,0];
		{
			_ressourcesToAdd = _x getVariable ["ER32_Fortify_Ressources", [0,0,0,0]];
			for "_i" from 0 to ((count _ressources) - 1) do {
				_ressources set [_i, (_ressources select _i) + (_ressourcesToAdd select _i)];
			};
		}forEach _cratesNearby;
		
		//Tells the player how many ressources are nearby.
		
		hint format [
			"Ressources nearby:\nConcrete: %1\nWood: %2\nSand: %3\nMetall: %4",
			_ressources select 0,
			_ressources select 1,
			_ressources select 2,
			_ressources select 3
		];
	},
	{true}
	] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions","ER32_BuildCategory"], _ER32_Ressources] call ace_interact_menu_fnc_addActionToObject;

/*
Creates an interaction point for each element in the corresponding list.
*/

{
	_class = _x select 0;
	_ressources = _x select 1;
	_name = _x select 2;
	_category = _x select 3;
	_time = _x select 4;
	
	_newCategory = [
		_name,
		_name,
		"",
		{
			params ["_target","_player","_params"];
			[_params select 0, _params select 1, _params select 2, _params select 3, _player] execVM "ER32_PlaceObject.sqf"
		},
		{true},
		{},
		[_class,_ressources,_name,_time]
	] call ace_interact_menu_fnc_createAction;
		
	[
		player,
		1,
		["ACE_SelfActions","ER32_BuildCategory","ER32_Categories" + _category],
		_newCategory
	] call ace_interact_menu_fnc_addActionToObject;
} forEach ER32_Classname_List;

