/*
The code below will create the called object and place it infront of the player.
The player now has 4 possibilities to interact with the object.
1.	Place the object as it is shown with 'Left Mouse Button'.
2.	Change the height of the shown object with 'Mouse Wheel Up/Down'.
3.	Change the rotation of the shown object with 'CTRL and Mouse Wheel 'Up/Down'.
4.	Cancel the construction by pressing 'ESC' or 'Right Mouse Button'. 
*/

params ["_class","_cost","_name","_time","_caller","_maxHeight","_minHeight"];

_crates = ER32_buildAndRessources_crates;

///////////////////
//RESSOURCE CHECK//
///////////////////



/*
First Checks for all eligible crates nearby.
And collects the collective ressources, stored inside.
Then these ressources will be compared with the needed cost of the wanted structure.
If enough the building will be build, otherwise the construction will not happen.
If successfull the ressources needed to build will be removed from the crates. 
*/

private _cratesNearby = _caller nearEntities [_crates,50]; //checks all crates nearby and puts them in an array.
private _sortedCrates = [_cratesNearby, [_caller], {_input0 distance _x}, "ASCEND"] call BIS_fnc_sortBy;
private _numberOfCratesNearby = count _cratesNearby; //counts the objects in the array.

/*
If atleast one crate exists, collects all the ressources and combines them in one array.
*/

private _ressources = [0,0,0,0];
private _names = ER32_buildAndRessources_names;
private _enoughRessources = false;

if (_numberOfCratesNearby > 0) then {
	
	//Collects the ressources of all crates nearby.
	
	{
		private _ressourcesToAdd = _x getVariable ["ER32_buildAndRessources_ressources", [0,0,0,0]];
		for "_i" from 0 to ((count _ressources) - 1) do {
			_ressources set [_i, (_ressources select _i) + (_ressourcesToAdd select _i)];
		};
	}forEach _cratesNearby;
	
	//Now checks if the ressources are enough to cover the cost of the building.
	
	_enoughRessources = true;
	for "_i" from 0 to ((count _ressources) - 1) do {
		if ((_ressources select _i) < (_cost select _i)) then {
			_enoughRessources = false;
		};
	};
};

//If not enough ressources are found the below block will trigger.

if (_enoughRessources == false) exitWith {
	
	//If no ressource crates are nearby then there are no ressources nearby.
	
	if (_numberOfCratesNearby == 0) then {
		_ressources = [0,0,0,0];
	};
	
	//Tells the player how many ressources are nearby and how many are needed for the building cost.
	
	hint format [
		"Not enough ressources!\nRessources needed:\n"+(_names select 0)+": (%1/%2)\n"+(_names select 1)+": (%3/%4)\n"+(_names select 2)+": (%5/%6)\n"+(_names select 3)+": (%7/%8)",
		_ressources select 0,_cost select 0,
		_ressources select 1,_cost select 1,
		_ressources select 2,_cost select 2,
		_ressources select 3,_cost select 3
	];
};



////////////////
//PREVIEW MODE//
////////////////



//Gets the relative position of the soon to be created object to the player.

_tempObject = createVehicle [_class, [0,0,-1000], [], 0, "CAN_COLLIDE"];

_sizeOfObject = sizeOf _class;
_distance = (_sizeOfObject) - 5;
_distance = _distance max 3;
_distance = _distance min 20;

deleteVehicle _tempObject;

_pos = [position _caller, _distance, getDir _caller] call BIS_fnc_relPos; 

//Creates the object at the relativ position from the player.

_selectedObject = _caller getVariable ["ER32_buildAndRessources_selectedObject",objNull];
if (!isNull _selectedObject) then {
	deleteVehicle _selectedObject
};

_object = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
_caller setVariable ["ER32_buildAndRessources_selectedObject",_object];

_object enableSimulationGlobal false;

_eventHandler = _caller addEventHandler ["AnimChanged", {
    params ["_unit", "_anim"];
    if (_anim find "ladder" > -1) then {
        _unit switchMove ""; // instantly cancel climbing
    };
}];


//Sets the direction of the object to the same direction the player is facing.

_object setDir getDir _caller; 

_posAdd = 0.0; 
_dirAdd = 0;
_surfaceNormal = [0,0,0];
_caller setVariable ["ER32_surfaceNormal",_surfaceNormal];
_caller setVariable ["ER32_build_done", false];
_caller setVariable ["ER32_build_canceled", false];


_object attachTo [_caller, [0, _distance, _posAdd]];


/*
This loop will constantly update the position and rotation of the created object.
And check if any of the 4 combination, explained above, are fullfilled.
*/

_keyDownHandler = (findDisplay 46) displayAddEventHandler ["KeyDown", {
    params ["_display","_key","_shift","_ctrl","_alt"];

    if (_key == 29) then {    // 29 = DIK_LCONTROL
        _display setVariable ["ER_ctrlDown", true];
    };
}];

_keyUpHandler = (findDisplay 46) displayAddEventHandler ["KeyUp", {
    params ["_display","_key","_shift","_ctrl","_alt"];

    if (_key == 29) then {    // 29 = DIK_LCONTROL
        _display setVariable ["ER_ctrlDown", false];
    };
}];

_mouseWheelChangeHandler = (findDisplay 46) displayAddEventHandler ["MouseZChanged", {
    params ["_display", "_scroll"];

    private _ctrl = _display getVariable ["ER_ctrlDown", false];
	
	_caller = _display getVariable ["ER32_caller",objNull];
	_minHeight = _display getVariable ["ER32_minHeight",0];
	_maxHeight = _display getVariable ["ER32_maxHeight",0];

	_posAdd = _caller getVariable ["ER32_posAdd",0];
	_dirAdd = _caller getVariable ["ER32_dirAdd",0];

    if (_ctrl) then {
        // ROTATION
        if (_scroll > 0) then { _dirAdd = _dirAdd + 1; };
        if (_scroll < 0) then { _dirAdd = _dirAdd - 1; };
    } else {
        // HEIGHT
        if (_scroll > 0) then { _posAdd = _posAdd + 0.05;_posAdd = _posAdd min _maxHeight};
        if (_scroll < 0) then { _posAdd = _posAdd - 0.05;_posAdd = _posAdd max _minHeight;};
    };
	_caller setVariable ["ER32_posAdd", _posAdd, true];
	_caller setVariable ["ER32_dirAdd", _dirAdd, true];
}];

_mouseButtonDownHandler = (findDisplay 46) displayAddEventHandler ["MouseButtonDown", {
	params ["_displayOrControl", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"]; 
	
	_caller = _displayOrControl getVariable ["ER32_caller",objNull];
	_object = _displayOrControl getVariable ["ER32_object",objNull];
	
	if (_button == 2) then {
		_posObject = getPos _object;
		_groundZ = getTerrainHeightASL [_posObject select 0, _posObject select 1];
		_surfaceNormal = (surfaceNormal getPosASL _object);
		_caller setVariable ["ER32_surfaceNormal",_surfaceNormal];
	};
}];

(findDisplay 46) setVariable ["ER32_object", _object];
(findDisplay 46) setVariable ["ER32_caller", _caller];
(findDisplay 46) setVariable ["ER32_minHeight", _minHeight];
(findDisplay 46) setVariable ["ER32_maxHeight", _maxHeight];

[_object] remoteExec ["ER32_fnc_buildAndRessources_syncRotationOnObject",0];

_previewHandler = [
	{
		params ["_args", "_pfhId"];
		_args params ["_caller","_distance","_posAdd","_maxHeight","_minHeight","_dirAdd","_object","_eventHandler","_surfaceNormal"];
		
		/*
		Depending on the key input the preview object height or rotation will be changed.
		- prevAction shows if the mousewheel has been scrolled up.
		- nextAction shows if the mousewheel has been scrolled down.
		- curatorGroupMod shows if the Left Ctrl Button has been pressed.
		*/
		
		_posAdd = _caller getVariable ["ER32_posAdd",0];
		_dirAdd = _caller getVariable ["ER32_dirAdd",0];
		_surfaceNormal = _caller getVariable ["ER32_surfaceNormal",[0,0,0]];
		
		_object setVariable ["ER32_directionChangeOnObject",_dirAdd, true];
		_object setVectorUp _surfaceNormal;
		_object attachTo [_caller, [0, _distance, _posAdd]];
		
		_object setVectorUp _surfaceNormal;
		
		_args set [2, _posAdd];
		_args set [5, _dirAdd];
		_args set [8, _surfaceNormal]; 
		
		/*
		Checks if the left/right mouse button has been pressed.
		On left mouse button press the object will be placed.
		On right mouse button press the placement will be canceled.
		*/
		
		_dirTest = _object getVariable ["ER32_directionChangeOnObject",0];
		if (inputMouse 0 == 1) then {
			_object setVariable ["ER32_build_done", true];
			_object setVariable ["ER32_dirAdd",getDir _object];
			detach _object;
			_dir = _object getVariable ["ER32_dirAdd",0];	
			_object setDir _dir;
		}else{
			if (inputMouse 1 == 1) then {
				_object setVariable ["ER32_build_canceled", true];
				deleteVehicle _object;
				_caller setVariable ["ER32_buildAndRessources_selectedObject",objNull];
				_caller removeEventHandler ["AnimChanged",_eventHandler];
			};
		};	
		if ((_object getVariable ["ER32_build_done",false] == true) or (_object getVariable ["ER32_build_canceled",false] == true)) then
		{
			_pfhId call CBA_fnc_removePerFrameHandler;
		};
	},
	0,
	[_caller,_distance,_posAdd,_maxHeight,_minHeight,_dirAdd,_object,_eventHandler,_surfaceNormal]
] call CBA_fnc_addPerFrameHandler;

waitUntil {_object getVariable ["ER32_build_done",false] or _object getVariable ["ER32_build_canceled",false]};



//////////////////////////
//PLACEMENT/CANCELLATION//
//////////////////////////



findDisplay 46 displayRemoveEventHandler ["keyDown",_keyDownHandler];
findDisplay 46 displayRemoveEventHandler ["keyUp",_keyUpHandler];
findDisplay 46 displayRemoveEventHandler ["MouseZChanged",_mouseWheelChangeHandler];
findDisplay 46 displayRemoveEventHandler ["MouseButtonDown",_mouseButtonDownHandler];

_placed = _object getVariable ["ER32_build_done",false];
_canceled = _object getVariable ["ER32_build_canceled",false];

_dir = _object getVariable ["ER32_dirAdd",0];	
_object setDir _dir;

/*
After 'placing' the object. It will first vanish/hide and a progress bar will be shown.
Showing the duration till the object will be sucessfully build. 
*/

if (_canceled == true) exitWith {
	hint "Placement canceled.";
};

_caller playMove "Acts_carFixingWheel";
if (_placed == true) then {
	[																				
		_time, //Time needed for the progress bar to complete
		[_object,_caller,_name,_time,_ressources,_cost,_sortedCrates,_eventHandler], 	//Arguments
		{																			
			//Code that runs on completion
			
			params ["_params"];
			_params params ["_object","_caller","_name","_time","_ressources","_cost","_sortedCrates","_eventHandler"];
			
			//Shows the object again and stops the animation.
			_object enableSimulationGlobal true;
			_dir = _object getVariable ["ER32_dirAdd",0];	
			_object setDir _dir;
			_caller switchMove "Stand";
			_addOrRemove = "remove";
			
			[_sortedCrates,_cost,_addOrRemove] remoteExecCall ["ER32_fnc_buildAndRessources_updateRessources",2];
			_caller setVariable ["ER32_buildAndRessources_selectedObject",objNull];
			
			if (!isNil "ER32_fnc_persistency_saveObject") then {
				[[_object]] remoteExecCall ["ER32_fnc_persistency_saveObject",2];
			};
			
			[_object,_time,_name,_sortedCrates,_cost] remoteExecCall ["ER32_fnc_buildAndRessources_deleteObject",0,true];
			
			_caller removeEventHandler ["AnimChanged",_eventHandler];
			
		}, 												
		{
			//Code on Failure
			params ["_params"];
			_params params ["_object","_caller","_name","_time","_ressources","_cost","_sortedCrates","_eventHandler"];
			
			_caller switchMove "Stand";
			deleteVehicle _object;
			_caller setVariable ["ER32_buildAndRessources_selectedObject",objNull];
			_caller removeEventHandler ["AnimChanged",_eventHandler];
		}, 												
		_name + " is being build."	//Shown Text on progress bar
	] call ace_common_fnc_progressBar;
};