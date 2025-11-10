execVM "ER32_Functions.sqf";
execVM "ER32_Classnames.sqf";

if (isServer) then {
  execVM "ER32_CrateSpawner.sqf";
};

