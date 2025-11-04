#### Changelog

---

##### Version 1.2 - 04.11.2025

###### Added

* Hint after placement got canceled.
* Hint if space behind truck is blocked.
* Unloading now checks if there is already a crate placed down.

###### Fixed

* The cost of placing objects would not be correctly checked.
* Pressing right mouse button would not correctly end placement.
* Arguments were missing, breaking the whole "crateSpawner.sqf" script. Fixed it by adding the arguments back.
* Used "if () do {}" ... that of course does not work. Changed to "if () then {}" which will work. :)

###### Changed

*

###### Removed

* 

---

##### Version 1.1 - 01.11.2025

###### Added

* 

###### Fixed

* 

###### Changed

* Changed the ER32\_CrateSpawner.sqf to now be more flexible. Instead of hard coding all the possible ressource add actions, it now loops over customisable arrays.
* Making it more flexible and allowing to add more than one Spawner.
* Ressource Count, name and classname, now also can be changed more easily.

###### Removed

* 

---

##### Version 1.0 - 30.10.2025

###### Added

* Initial Release
* │ Scripts
* ├── ER32\_Classnames.sqf
* ├── ER32\_CrateSpawner.sqf
* ├── ER32\_Flatbed.sqf
* ├── ER32\_Functions.sqf
* ├── ER32\_PlaceObject.sqf
* ├── init.sqf
* └─ initPlayeLocal.sqf

###### Fixed

* 

###### Changed

* 

###### Removed

* 

