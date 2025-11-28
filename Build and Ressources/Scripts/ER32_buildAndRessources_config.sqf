/*
List of objects that will be added to the Build Ace Self Interaction.
1. 	STRING containing the classname of the object to be added.
2. 	ARRAY containing the cost of the object.
	With following ressources: [Concrete, Wood, Sand, Metall].
3. 	STRING with the name that will be shown.
4.	STRING with the category it will show up.
5.	NUMBER determines the time (in seconds) needed to construct the building.
*/

private _classname_list = [
	["Land_BagFence_Long_F",		[0,0,20,0],	"Sandbag (Long)",	"Fortifications",	10],
	["Land_BagFence_Short_F",		[0,0,10,0],	"Sandbag (Short)",	"Fortifications",	7.5],
	["Land_BagFence_End_F",			[0,0,5,0],	"Sandbag (End)",	"Fortifications",	5],
	["Land_BagFence_Corner_F",		[0,0,5,0],	"Sandbag (Corner)",	"Fortifications",	5],
	["Land_BagFence_Round_F",		[0,0,20,0],	"Sandbag (Round)",	"Fortifications",	10],
	["WaterPump_01_forest_F",		[0,0,0,100],"Water Pump",		"Humanitarian",		30],	
	["Land_ConcreteWell_02_F",		[50,0,0,20],"Well Pump",		"Humanitarian",		20],
	["Land_dp_smallTank_F",			[0,0,0,0],	"Test",				"Test",				5],
	["Land_Radar_Small_F",			[0,0,0,0],	"Radar (Small)",	"Test",				5],
	["Land_i_Barracks_V2_F",		[0,0,0,0],	"Barracks",			"Test",				5],
	["Land_LifeguardTower_01_F",	[0,0,0,0],	"CamoNet",			"Test",				5],
	["Land_Cargo_Tower_V1_No5_F",	[0,0,0,0],	"Cargo Tower",		"Test",				5],
	["Land_ConcreteHedgehog_01_F",	[50,0,0,25],"Concrete Hedgehog","Barricade",		15]
];

/*
You can place an unlimited number of spawners and spawnpoints, but every spawner needs a spawnpoint.
For now please don't change the number of names, ressources and crates.
Maybe later you will be able to add unlimited amount of ressources, but for now it is restricted to 4. 
No more, no less.
You are able to change the name,ressource and crate name, number, class.
*/

private _spawner = [ER32_fortify_spawn_crates];
private _spawnpoints = [ER32_fortify_spawn_crates_pos];
private _names = ["Concrete","Wood","Sand","Metal"];
private _ressources = [500,500,500,500];
private _crates = ["Land_Cargo10_white_F","Land_Cargo10_orange_F","Land_Cargo10_sand_F","Land_Cargo10_grey_F"];

private _loadDistance = 15;

private _maxHeight = 10;
private _minHeight = -10;

[_classname_list,_spawner,_spawnpoints,_names,_ressources,_crates,_loadDistance,_maxHeight,_minHeight] execVM "Scripts\ER32_buildAndRessources_crateSpawner.sqf";