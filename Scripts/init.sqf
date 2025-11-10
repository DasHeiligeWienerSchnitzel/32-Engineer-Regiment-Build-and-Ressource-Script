_ER32_Functions_scriptHandler = execVM "ER32_Functions.sqf";
waitUntil {scriptDone _ER32_Functions_scriptHandler};
_ER32_Classnames_scriptHandler =execVM "ER32_Classnames.sqf";
waitUntil {scriptDone _ER32_Classnames_scriptHandler};

if (isServer) then {
  execVM "ER32_CrateSpawner.sqf";
};


