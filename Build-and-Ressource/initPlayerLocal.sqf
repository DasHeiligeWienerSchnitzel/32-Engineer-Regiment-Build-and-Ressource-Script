_ER32_Classnames_scriptHandler = execVM "Scripts\ER32_Classnames.sqf";
waitUntil {scriptDone _ER32_Classnames_scriptHandler};
_ER32_crateSpawner_scriptHandler = execVM "Scripts\ER32_CrateSpawner.sqf";
waitUntil {scriptDone _ER32_crateSpawner_scriptHandler};
execVM "Scripts\ER32_addActions.sqf";


