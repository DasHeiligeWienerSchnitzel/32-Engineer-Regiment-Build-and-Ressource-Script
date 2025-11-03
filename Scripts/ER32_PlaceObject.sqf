/*
The code below will create the called object and place it infront of the player.
The player now has 4 possibilities to interact with the object.
1.	Place the object as it is shown with 'Left Mouse Button'.
2.	Change the height of the shown object with 'Mouse Wheel Up/Down'.
3.	Change the rotation of the shown object with 'CTRL and Mouse Wheel 'Up/Down'.
4.	Cancel the construction by pressing 'ESC' or 'Right Mouse Button'. 
*/

params ["_class","_cost","_name","_time","_caller"];

/*
First Checks for all eligible crates nearby.
And collects the collective ressources, stored inside.
Then these ressources will be compared with the needed cost of the wanted structure.
If enough the building will be build, otherwise the construction will not happen.
If successfull the ressources needed to build will be removed from the crates. 
*/

_cratesNearby = _caller nearEntities [["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"],50]; //checks all crates nearby and puts them in an array.
_sortedCrates = [_cratesNearby, [_caller], {_input0 distance _x}, "ASCEND"] call BIS_fnc_sortBy;
_numberOfCratesNearby = count _cratesNearby; //counts the objects in the array.

/*
If atleast one crate exists, collects all the ressources and combines them in one array.
*/
_ressources = [0,0,0,0];
_enoughRessources = true;
if (_numberOfCratesNearby > 0) then {
	{
		_ressourcesToAdd = _x getVariable ["ER32_Fortify_Ressources", [0,0,0,0]];
		for "_i" from 0 to ((count _ressources) - 1) do {
			_ressources set [_i, (_ressources select _i) + (_ressourcesToAdd select _i)];
		};
	}forEach _cratesNearby;
	//Now checks if enough ressources are to cover the cost.
	for "_i" from 0 to ((count _ressources) - 1) do {
		if ((_ressources select _i) < (_cost select _i)) then {
			_enoughRessources = false
		};
	};
};

if (_enoughRessources == false) exitWith {
	if (_numberOfCratesNearby == 0) then {
		_ressources = [0,0,0,0];
		hint "test";
	};
	hint format [
		"Not enough ressources!\nRessources needed:\nConcrete: (%1/%2)\nWood: (%3/%4)\nSand: (%5/%6)\nMetall: (%7/%8)",
		_ressources select 0,_cost select 0,
		_ressources select 1,_cost select 1,
		_ressources select 2,_cost select 2,
		_ressources select 3,_cost select 3
	];
};

_pos = [position _caller, 2.25, getDir _caller] call BIS_fnc_relPos; //Gets the relative position of the soon to be created object to the player.
_object = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"]; //Creates the object at the relativ position from the player.
_object setDir getDir _caller; //Sets the direction of the object to the same direction the player is facing.

_posAdd = 0.0; 
_dirAdd = 0;
_placed = false;
_canceled = false;

/*
This loop will constantly update the position and rotation of the created object.
And check if any of the 4 combination, explained above, are fullfilled.
*/

while {(_placed == false) and (_canceled == false)} do {
	_pos = [position _caller, 2.25, getDir _caller] call BIS_fnc_relPos;
	if ((inputAction "prevAction" > 0) and (inputAction "curatorGroupMod" == 0)) then {
		_posAdd = _posAdd + 0.05;
	};
	if ((inputAction "nextAction" > 0) and (inputAction "curatorGroupMod" == 0)) then {
		_posAdd = _posAdd -0.05;
	};
	if ((inputAction "curatorGroupMod" > 0) and (inputAction "prevAction" > 0)) then {
		_dirAdd = _dirAdd + 1;
	};
	if ((inputAction "curatorGroupMod" > 0) and (inputAction "nextAction" > 0)) then {
		_dirAdd = _dirAdd - 1;
	};
	_pos set [2,(_pos select 2) + _posAdd];
	_object setPos _pos;
	_object setDir ((getDir _caller) + _dirAdd);
	sleep 0.001;
	if (inputMouse 0 == 1) then {
		_placed = true;
		_object hideObjectGlobal true;
	}else{
		if (inputMouse 1 == 1) then {
			_canceled = true;
			deleteVehicle _object;
		};
	};
};
/*
After 'placing' the object. It will first vanish/hide and a progress bar will be shown.
Showing the duration till the object will be sucessfully build. 
*/
_caller playMove "Acts_carFixingWheel";
if (_placed == true) then {
	[																				//Progress bar
		_time, 																		//Time
		[_object,_caller,_name,_time,_ressources,_cost,_sortedCrates], 				//Arguments
		{																			//On completion
			params ["_params"];
			_object = _params select 0;
			_caller = _params select 1;
			_name = _params select 2;
			_time = _params select 3;
			_ressources = _params select 4;
			_cost = _params select 5;
			_sortedCrates = _params select 6;
			
			_object hideObjectGlobal false;
			_caller switchMove "Stand";
			
			{
				_forEachItem = _x;
				_firstEntryIndex = _sortedCrates findIf {typeOf _x == _forEachItem}; 
				_firstEntry = (_sortedCrates select _firstEntryIndex);
				_firstEntryRessource =  _firstEntry getVariable ["ER32_Fortify_Ressources",[0,0,0,0]];
				_firstEntryRessource set [_forEachIndex, (_firstEntryRessource select _forEachIndex) - (_cost select _forEachIndex)];
				_firstEntry setVariable ["ER32_Fortify_Ressources",_firstEntryRessource, true];
			}forEach ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];		
			
			_ER32_ObjectDelete = [										//Ace Interaction
				"ER32_ObjectDelete",
				"Remove",
				"",
				{														//On activation
					params ["_target","_player","_params"];
					_time = _params select 0;
					_name = _params select 1;
					_sortedCrates = _params select 2;
					_cost = _params select 3;
					
					_player playMove "Acts_carFixingWheel";
					[															//Progress bar
						_time/2,
						[_target,_player,_sortedCrates,_cost],
						{														//On completion
							params ["_params"];
							_target = _params select 0;
							_player = _params select 1;
							_sortedCrates = _params select 2;
							_cost = _params select 3;
							
							deleteVehicle _target;
							hint "Deconstruction completed.";
							_player switchMove "Stand";
							
							{
								_forEachItem = _x;
								_firstEntryIndex = _sortedCrates findIf {typeOf _x == _forEachItem}; 
								_firstEntry = (_sortedCrates select _firstEntryIndex);
								_firstEntryRessource =  _firstEntry getVariable ["ER32_Fortify_Ressources",[0,0,0,0]];
								_firstEntryRessource set [_forEachIndex, (_firstEntryRessource select _forEachIndex) + (_cost select _forEachIndex)/2];
								_firstEntry setVariable ["ER32_Fortify_Ressources",_firstEntryRessource, true];
							}forEach ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];	
						},
						{														//On failure
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
		}, 												//Code on Finished
		{
			params ["_params"];
			(_params select 1) switchMove "Stand"
		}, 												//Code on Failure
		_name + " is being build."						//Shown Text on progress bar
	] call ace_common_fnc_progressBar;
};


