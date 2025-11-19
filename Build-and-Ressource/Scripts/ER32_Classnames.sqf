/*
List of objects that will be added to the Build Ace Self Interaction.
1. 	STRING containing the classname of the object to be added.
2. 	ARRAY containing the cost of the object.
	With following ressources: [Concrete, Wood, Sand, Metall].
3. 	STRING with the name that will be shown.
4.	STRING with the category it will show up.
5.	NUMBER determines the time (in seconds) needed to construct the building.
*/

ER32_Classname_List = [
	["Land_BagFence_Long_F",		[0,0,20,0],	"Sandbag (Long)",	"Fortifications",	10],
	["Land_BagFence_Short_F",		[0,0,10,0],	"Sandbag (Short)",	"Fortifications",	7.5],
	["Land_BagFence_End_F",			[0,0,5,0],	"Sandbag (End)",	"Fortifications",	5],
	["Land_BagFence_Corner_F",		[0,0,5,0],	"Sandbag (Corner)",	"Fortifications",	5],
	["Land_BagFence_Round_F",		[0,0,20,0],	"Sandbag (Round)",	"Fortifications",	10],
	["WaterPump_01_forest_F",		[0,0,0,100],"Water Pump",		"Humanitarian",		30],	
	["Land_ConcreteWell_02_F",		[50,0,0,20],"Well Pump",		"Humanitarian",		20],
	["Land_ConcreteHedgehog_01_F",	[50,0,0,25],"Concrete Hedgehog","Barricade",		15]
];
