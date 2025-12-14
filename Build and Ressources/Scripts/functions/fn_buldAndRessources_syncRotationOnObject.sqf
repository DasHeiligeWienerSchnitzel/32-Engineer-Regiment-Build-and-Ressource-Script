params ["_object"];

_rotationHandler = [
	{
		params ["_args","_pfhId"];
		_args params ["_object"];
		
		private _object = _args select 0;
		private _dirAdd = _object getVariable ["ER32_directionChangeOnObject",0];
		_object setVectorDirAndUp [
			[
				sin (_dirAdd),
				cos (_dirAdd),
				0
			],
			[0,0,1]
		];
		if ((_object getVariable ["ER32_build_done",false] == true) or (_object getVariable ["ER32_build_canceled",false] == true)) then
		{
			_pfhId call CBA_fnc_removePerFrameHandler;
		};
	},
	0,
	[_object]
] call CBA_fnc_addPerFrameHandler;
