//This code spawns the four different kinds of ressource crates.

_spawner = [ER32_fortify_spawn_crates];
_spawnpoints = [ER32_fortify_spawn_crates_pos];
_names = ["Concrete","Wood","Sand","Metal"];
_ressources = [500,500,500,500];
_crates = ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];

for "_i" from 0 to ((count _spawner) - 1) do {
	for "_j" from 0 to 3 do {
		(_spawner select _i) addAction
		[
			"Spawn Crate (" + _names select _j + ")" , // Title
			
			// Script
			{
				params ["_target", "_caller", "_actionID", "_arguments"];
				
				
				//Checks if a box is already inside the spawn area, otherwise will spawn the crate
				
				_nearbyCrates = (_spawnpoints select _i) nearEntities [_crates,2];
				if (count _nearbyCrates == 0) then {
					_ressource = _ressources;
					for "_k" from 0 to 3 do {
						if (_k != _j) do {
							_ressource set [_k, 0];
						};
					};
					
					//Spawn the crate and add it's ressource.
					
					_crate = createVehicle [_crates select _j, getPos (_spawnpoints select _i), [], 0, "CAN_COLLIDE"]; 
					_crate setVariable ["ER32_Fortify_Ressources", _ressource, true];
					
					//Removes and adds ace interactions.
					
					[_crate, -1] call ace_cargo_fnc_setSize;
					[_crate, -1] call ace_cargo_fnc_setSpace;
					[_ressource,_crate] call ER32_fnc_checkForRessources;
					[_crate] call ER32_fnc_loadOnFlatbed;
				};
			},
			nil,		// arguments
			1.5,		// priority
			true,		// showWindow
			true,		// hideOnUse
			"",			// shortcut
			"true",		// condition
			10,			// radius
			false,		// unconscious
			"",			// selection
			""			// memoryPoint
		];
	};
};
