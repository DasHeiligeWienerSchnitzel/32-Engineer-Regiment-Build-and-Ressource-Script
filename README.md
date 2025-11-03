# 32-Engineer-Regiment-Build-and-Ressource-Script
This project contains scripts for the ArmA 3 Unit: **32 Engineer Regiment**.

It enables players to build pre-determined structures (which can be freely edited through the **ER32\_Classnames.sqf** file).
These structures will cost ressources that can be obtained by building ressource crates.
The crates can then be transported using a designated flatbed vehicle.

---

###### How to install

1. Copy all files from the **script** folder into your mission folder.
2. Put **execVM "ER32\_CrateSpawner.sqf** in the init of the objects you want to be able to spawn ressource crates.
3. Name an object **ER32\_fortify\_spawn\_crates** this will now be able to spawn ressource crates.
4. Only the **UK3CB\_BAF\_MAN\_HX58\_Cargo\_Green\_A** vehicle can transport the ressource crates as of now.

---

###### How it works

* Adds the ability to build pre-selected structures via the ACE self-interaction menu.
* Structures require ressources to be build.
* Ressources are stored in four separate ressource crates that can be spawned at a designated building (See point 2 in "How to install").
* Each structure's **classname**, **display name**, **ressource cost**, **category** and **build time** can be configured in the **ER32\_Classnames.sqf**.

---

###### When building

* A **preview** of the structure will be shown.
* **Height** and **Rotation** can be adjusted before placement.
* Removing a placed structure refunds **half** of its build cost.

---

###### Players can

* View nearby ressources via ACE self interaction.
* Check ressource count directly on individual crates.
* **Transport** crates by loading/unloading them onto supported flatbed vehicles (See point 3 in "How to install").

---

###### File Overview

* "ER32\_Classnames.sqf"	Defines the structures the players will be able to build.
* "ER32\_CrateSpawner.sqf"	Creates Interaction of called object to spawn ressource crates.
* "ER32\_Flatbed.sqf"		Enables the loading/unloading of ressource crates.
* "ER32\_Functions.sqf"		Contains functions used in scripts.
* "ER32\_PlaceObject.sqf"	Enables the player to place the objects.
* "init.sqf"			Initializes "ER32\_Functions.sqf" and "ER32\_CrateSpawner.sqf"
* "initPlayerLocal.sqf"	Initializes "ER32\_Classnames.sqf" and adds the new ACE Self-interaction points onto the player.

---

###### License

This project is released under the MIT License.

Feel free to use, modify, and share with proper credit.

---

###### Credits

* 32 Engineer Regiment for testing and feedback.
* ACE3 and CBA\_A3 developers for their framework.
