/*
Contains all the functions that are used.
*/

ER32_fnc_checkForRessources = {

	/*
	Creates an ace interaction point to check for ressources inside the crate.
	*/
	
	params ["_crate"];
	
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
};

ER32_fnc_loadOnFlatbed = {
	
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
	
};

ER32_fnc_unloadFromFlatbed = {
	
	params ["_nearestFlatbed","_crates"];
	
	/*
	Only if the first object is loaded onto the flatbed the interaction to unload crates will be added onto the flatbed.
	Will be later removed if no more crates are on the flatbed.
	*/
			
	_ER32_Flatbed_Unload = [
		"ER32_Flatbed_Unload",
		"Unload Crate",
		"",
		{
			params ["_target","_player","_params"];
			_nearestFlatbed = _params select 0;
			_crates = _params select 1;
			
			//Gets all the objects loaded onto the flatbed.
			
			_objectsLoaded = _nearestFlatbed getVariable ["ER32_objectsLoaded",[]];
			
			if (count _objectsLoaded > 0) then {
				
				private _pos = [position _nearestFlatbed, 4, (getDir _nearestFlatbed) - 180] call BIS_fnc_relPos;
				
				private _nearbyCrates = _pos nearEntities [_crates,2];
				if (count _nearbyCrates == 0) then {
				
					//Gets the last added object and detaches it from the flatbed.
					
					_lastObject = _objectsLoaded select -1;
					_lastObject enableSimulationGlobal false;
					detach _lastObject;
					
					//Now teleports it behind the flatbed.
					
					
					_lastObject setPos [_pos select 0,_pos select 1,_pos select 2];
					
					//Adds back the interaction to load it back onto the flatbed.
					
					[_crate,_crates] remoteExecCall ["ER32_fnc_loadOnFlatbed",0,true];
					
					//Deletes the now unloaded object from the object list.
					
					_objectsLoaded deleteAt [-1]; 
					_nearestFlatbed setVariable ["ER32_objectsLoaded", _objectsLoaded, true];
					
					//If now no longer any crates are on the flatbed the interaction to unload crates will be removed.
					
					if (count _objectsLoaded == 0) then {
						[_nearestFlatbed, 0, ["ACE_MainActions","ER32_Flatbed_Unload"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",0,true];
					};
				}else{
					hint "Unload not possible.";
				};
			};
		},
		{true},
		{},
		[_nearestFlatbed,_crates]
		] call ace_interact_menu_fnc_createAction;
	[_nearestFlatbed, 0, ["ACE_MainActions"], _ER32_Flatbed_Unload] call ace_interact_menu_fnc_addActionToObject;
};

ER32_fnc_deleteObject = {
	
	params ["_time","_name","_sortedCrates","_cost"];
	
	_ER32_ObjectDelete = [
		"ER32_ObjectDelete",
		"Remove",
		"",
		{														
			//On activation
			
			params ["_target","_player","_params"];
			_params params ["_time","_name","_sortedCrates","_cost"];
			
			//Play animation
			
			_player playMove "Acts_carFixingWheel";
			
			//Progress bar
			
			[															
				_time/2, //Time needed
				[_target,_player,_sortedCrates,_cost],
				{														
					//On completion
					
					params ["_params"];
					_params params ["_target","_player","_sortedCrates","_cost"];
					
					//Deletes the object again and removes animation.
					
					deleteVehicle _target;
					hint "Deconstruction completed.";
					_player switchMove "Stand";
					
					{
						//Copies the current object to be used in the findIf code block.
						
						_forEachItem = _x;
						
						//Finds the first index of the nearest Crate having the same type as the four classnames in the forEach-loop.
						
						_firstEntryIndex = _sortedCrates findIf {typeOf _x == _forEachItem}; 
						
						//Now selects the first crate that has the same type as the current classname in the forEach-loop.
						
						_firstEntry = (_sortedCrates select _firstEntryIndex);
						
						//Gets the ressource that crates has.
						
						_firstEntryRessource =  _firstEntry getVariable ["ER32_Fortify_Ressources",[0,0,0,0]];
						
						//Sets the new ressource of the crate.
						
						_firstEntryRessource set [_forEachIndex, (_firstEntryRessource select _forEachIndex) + (_cost select _forEachIndex)/2];
						
						//Saves the new ressource of the crate.
						
						_firstEntry setVariable ["ER32_Fortify_Ressources",_firstEntryRessource, true];
						
					}forEach ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];	
				},
				{														
					//On failure
					params ["_params"];
					
					_player = _params select 1;
					hint "Deconstruction cancelled.";
					_player switchMove "Stand";
				},
				_name + " is being destructed."
			] call ace_common_fnc_progressBar;
		},
		{true},
		{},
		[_time,_name,_sortedCrates,_cost]	//Arguments
		] call ace_interact_menu_fnc_createAction;
	[_object, 0, ["ACE_MainActions"], _ER32_ObjectDelete] call ace_interact_menu_fnc_addActionToObject;
};

ER32_fnc_updateRessources = {
	
	params ["_sortedCrates","_cost"];
	
	{
		//Copies the current object to be used in the findIf code block.
		
		_forEachItem = _x;
		
		//Finds the first index of the nearest Crate having the same type as the four classnames in the forEach-loop.
		
		_firstEntryIndex = _sortedCrates findIf {typeOf _x == _forEachItem}; 
		
		//Now selects the first crate that has the same type as the current classname in the forEach-loop.
		
		_firstEntry = (_sortedCrates select _firstEntryIndex);
		
		//Gets the ressource that crates has.
		
		_firstEntryRessource =  _firstEntry getVariable ["ER32_Fortify_Ressources",[0,0,0,0]];
		
		//Sets the new ressource of the crate.
		
		_firstEntryRessource set [_forEachIndex, (_firstEntryRessource select _forEachIndex) - (_cost select _forEachIndex)];
		
		//Saves the new ressource of the crate.
		
		_firstEntry setVariable ["ER32_Fortify_Ressources",_firstEntryRessource, true];
		
	}forEach ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];
};
