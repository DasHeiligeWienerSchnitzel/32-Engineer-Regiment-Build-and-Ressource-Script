execVM "ER32_Functions.sqf";

if (isServer) then {
  [] execVM "ER32_CrateSpawner.sqf";
};
