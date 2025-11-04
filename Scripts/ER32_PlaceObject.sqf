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
	
	//Collects the ressources of all crates nearby.
	
	{
		_ressourcesToAdd = _x getVariable ["ER32_Fortify_Ressources", [0,0,0,0]];
		for "_i" from 0 to ((count _ressources) - 1) do {
			_ressources set [_i, (_ressources select _i) + (_ressourcesToAdd select _i)];
		};
		
	}forEach _cratesNearby;
	
	//Now checks if the ressources are enough to cover the cost of the building.
	
	for "_i" from 0 to ((count _ressources) - 1) do {
		if ((_ressources select _i) < (_cost select _i)) then {
			_enoughRessources = false
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
		"Not enough ressources!\nRessources needed:\nConcrete: (%1/%2)\nWood: (%3/%4)\nSand: (%5/%6)\nMetall: (%7/%8)",
		_ressources select 0,_cost select 0,
		_ressources select 1,_cost select 1,
		_ressources select 2,_cost select 2,
		_ressources select 3,_cost select 3
	];
};

//Gets the relative position of the soon to be created object to the player.

_pos = [position _caller, 2.25, getDir _caller] call BIS_fnc_relPos; 

//Creates the object at the relativ position from the player.

_object = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"]; 

//Sets the direction of the object to the same direction the player is facing.

_object setDir getDir _caller; 

_posAdd = 0.0; 
_dirAdd = 0;
_placed = false;
_canceled = false;

/*
This loop will constantly update the position and rotation of the created object.
And check if any of the 4 combination, explained above, are fullfilled.
*/

while {(_placed == false) and (_canceled == false)} do {
	
	//Get a relative position infront of the caller.
	
	_pos = [position _caller, 2.25, getDir _caller] call BIS_fnc_relPos;
	
	/*
	Depending on the key input the preview object height or rotation will be changed.
	- prevAction shows if the mousewheel has been scrolled up.
	- nextAction shows if the mousewheel has been scrolled down.
	- curatorGroupMod shows if the Left Ctrl Button has been pressed.
	*/
	
	//Increases the height if scroll wheel goes up.
	if ((inputAction "prevAction" > 0) and (inputAction "curatorGroupMod" == 0)) then {
		_posAdd = _posAdd + 0.05;
	};
	
	//Decreases the height if scroll wheel goes down.
	if ((inputAction "nextAction" > 0) and (inputAction "curatorGroupMod" == 0)) then {
		_posAdd = _posAdd -0.05;
	};
	
	//Rotates clockwise if mousewheel scrolled up and Left Ctrl has been pressed.
	if ((inputAction "curatorGroupMod" > 0) and (inputAction "prevAction" > 0)) then {
		_dirAdd = _dirAdd + 1;
	};
	
	//Rotates counterclockwise if mousewheel scrolled down and Left Ctrl has been pressed.
	if ((inputAction "curatorGroupMod" > 0) and (inputAction "nextAction" > 0)) then {
		_dirAdd = _dirAdd - 1;
	};
	
	//Changes the position of the object accordingly.
	
	_pos set [2,(_pos select 2) + _posAdd];
	_object setPos _pos;
	_object setDir ((getDir _caller) + _dirAdd);
	
	sleep 0.001;
	
	/*
	Checks if the left/right mouse button has been pressed.
	On left mouse button press the object will be placed.
	On right mouse button press the placement will be canceled.
	*/
	
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
	[																				
		_time, //Time needed for the progress bar to complete
		[_object,_caller,_name,_time,_ressources,_cost,_sortedCrates], 	//Arguments
		{																			
			//Code that runs on completion
			
			params ["_params"];
			_params params ["_object","_caller","_name","_time","_ressources","_cost","_sortedCrates"];
			
			//Shows the object again and stops the animation.
			
			_object hideObjectGlobal false;
			_caller switchMove "Stand";
			
			
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
		}, 												
		{
			//Code on Failure
			params ["_params"];
			
			(_params select 1) switchMove "Stand"
		}, 												
		_name + " is being build."	//Shown Text on progress bar
	] call ace_common_fnc_progressBar;
};
