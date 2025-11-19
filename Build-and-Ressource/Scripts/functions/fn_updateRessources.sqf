params ["_sortedCrates","_cost","_addOrRemove"];

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
	
	switch (_addOrRemove) do {
		case "add": {_firstEntryRessource set [_forEachIndex, (_firstEntryRessource select _forEachIndex) + (_cost select _forEachIndex)/2]};
		case "remove": {_firstEntryRessource set [_forEachIndex, (_firstEntryRessource select _forEachIndex) - (_cost select _forEachIndex)]}:
		default {hint "How did we got here?"};
	};
	
	//Saves the new ressource of the crate.
	
	_firstEntry setVariable ["ER32_Fortify_Ressources",_firstEntryRessource, true];
	
}forEach ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];
