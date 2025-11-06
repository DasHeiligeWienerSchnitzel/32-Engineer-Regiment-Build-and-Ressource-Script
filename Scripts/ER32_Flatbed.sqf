//In this script the whole interaction with the crates and the flatbed is done.

params ["_object","_crates"];

/*
Get nearest Flatbed that has the needed classname.
The positions for the crates are dependent on the used flatbed. 
If you want to use another vehicle, you first need to find suitable positions points for your crates.
*/

_nearestFlatbed = nearestObject [_object,"UK3CB_BAF_MAN_HX58_Cargo_Green_A"]; 

/*
Gets the array of all the objects that are already loaded onto the flatbed.
Normally its [], but later on there will be objects stored inside.
*/

_objectsLoaded = _nearestFlatbed getVariable ["ER32_objectsLoaded",[]]; 

/*
Script will only fire if the distance between crate and flatbed is less then 15 meters.
*/

if (_object distance _nearestFlatbed < 15) then {
	
	/*
	Counts how many objects are on the flatbed and depending on how many there are,
	it will either put the crate in the first place, second place or will tell the player that
	there is no more space onto the flatbed.
	*/
	
	switch (count _objectsLoaded) do {
		case 0: {
			
			//Object will be stored in the list, containing all the objects on the flatbed.
			
			_objectsLoaded pushBack _object; 
			_nearestFlatbed setVariable ["ER32_objectsLoaded",_objectsLoaded, true];
			
			//Object will be attached to the first position on the flatbed.
			
			_object attachTo [_nearestFlatbed, [0,3.8,0.15]];
			_object setDir ((_nearestFlatbed getRelDir _object) - 90);
			
			/*
			The interaction on the object to store it onto a flatbed will be removed, because it is already on an flatbed.
			Will be later added if the object is removed again from the flatbed.
			*/
			
			[_object, 0, ["ACE_MainActions","ER32_LoadOnFlatbed"]] call ace_interact_menu_fnc_removeActionFromObject;
			
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
							
							[_lastObject,_crates] call ER32_fnc_loadOnFlatbed;
							
							//Deletes the now unloaded object from the object list.
							
							_objectsLoaded deleteAt [-1]; 
							_nearestFlatbed setVariable ["ER32_objectsLoaded", _objectsLoaded, true];
							
							//If now no longer any crates are on the flatbed the interaction to unload crates will be removed.
							
							if (count _objectsLoaded == 0) then {
								[_nearestFlatbed, 0, ["ACE_MainActions","ER32_Flatbed_Unload"]] call ace_interact_menu_fnc_removeActionFromObject;
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
		case 1: {
			_objectsLoaded pushBack _object;
			_nearestFlatbed setVariable ["ER32_objectsLoaded",_objectsLoaded, true];
			_object attachTo [_nearestFlatbed, [0,0.6,0.15]];
			_object setDir ((_nearestFlatbed getRelDir _object) - 90);
			[_object, 0, ["ACE_MainActions","ER32_LoadOnFlatbed"]] call ace_interact_menu_fnc_removeActionFromObject;
		};
		default {hint "Flatbed already full!"};
	};
}else{hint "No viable vehicle nearby!"};

