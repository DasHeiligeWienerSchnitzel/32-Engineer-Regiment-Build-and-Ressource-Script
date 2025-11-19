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
			
			
			private _nearbyCrates = _pos nearEntities 2.5;
			if (count _nearbyCrates == 0) then {
			
				//Gets the last added object and detaches it from the flatbed.
				
				_lastObject = _objectsLoaded select -1;
				_lastObject enableSimulationGlobal false;
				detach _lastObject;
				
				//Now teleports it behind the flatbed.
				
				
				_lastObject setPos [_pos select 0,_pos select 1,_pos select 2];
				
				//Adds back the interaction to load it back onto the flatbed.
				
				[_lastObject,_crates] remoteExecCall ["ER32_fnc_loadOnFlatbed",0,true];
				
				//Deletes the now unloaded object from the object list.
				
				_objectsLoaded deleteAt [-1]; 
				_nearestFlatbed setVariable ["ER32_objectsLoaded", _objectsLoaded, true];
				
				_lastObject enableSimulationGlobal true;
				
				//If now no longer any crates are on the flatbed the interaction to unload crates will be removed.
				
				if (count _objectsLoaded == 0) then {
					[_nearestFlatbed, 0, ["ACE_MainActions","ER32_Flatbed_Unload"]] remoteExecCall ["ace_interact_menu_fnc_removeActionFromObject",0,true];
				};
			}else{
				hint "Unloading obstructed";
			};
		};
	},
	{true},
	{},
	[_nearestFlatbed,_crates]
	] call ace_interact_menu_fnc_createAction;
[_nearestFlatbed, 0, ["ACE_MainActions"], _ER32_Flatbed_Unload] call ace_interact_menu_fnc_addActionToObject;
