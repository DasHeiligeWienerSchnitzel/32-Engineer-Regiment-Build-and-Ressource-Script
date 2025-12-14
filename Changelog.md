#### Changelog

---

##### Version 1.40 - 14.12.2025
###### Fixed
- Rotation button detection was using a zeus button, which only worked for zeuses (which didnt show up as a problem in testing). Now rotation works with displayEventHandler, tracking the needed buttons directly.
- Rotation was inconsistent between the three modes "preview", "building" and "placement". Now rotation will show up consistent in all phases.

###### Added
- The bulldozer from the Roadbuilder Script can now be, like the crates, be loaded onto the flatbed.
- Flushing an object to the ground is now possible by pressing the middle mouse button while in preview mode.
- The ressource cost, will now be shown in the name of the action. No more guessing how much something costs.
- Synchronization of rotation in preview mode is now possible.

###### Changed
- Changed the building system to no longer use setPos, but attachTo instead.

---

##### Version 1.33 - 01.12.2025
###### Fixed
- Distance from player for smaller objects was too little, resulting in the object pushing the player away. Fixed by increasing the minimal distance of an object to the player from 1 to 3 meters.
- Fixed an issue where the last object placed was deleted if trying to place another object.

---

##### Version 1.32 - 28.11.2025
###### Changed
- Changed classnames file to config file.

###### Added
- Added more configurables to config file.
- Minimal and Maximum Height for Objects.
- Load Distance and Max/Min Height can be changed in config now.
- Dynamic Range for objects, depending on the size of the spawned object.

###### Fixed
- Building inside a vehicle is no longer possible.
- You can no longer climb a ladder on a object you want to place --> no more space flight :(
- Stacking objects in preview is no longer possible, instead it will overwrite your last input.

---
##### Version 1.32 - 28.11.2025
###### Changed
- Changed classnames file to config file.

###### Added
- Added more configurables to config file.
- Minimal and Maximum Height for Objects.
- Load Distance and Max/Min Height can be changed in config now.
- Dynamic Range for objects, depending on the size of the spawned object.

###### Fixed
- Building inside a vehicle is no longer possible.
- You can no longer climb a ladder on a object you want to place --> no more space flight :(
- Stacking objects in preview is no longer possible, instead it will overwrite your last input.

---
##### Versionm 1.31 - 16.11.2025
MP Fixes

###### Added
- Support for the sand variant of the flatbed.

###### Changed
- Increased Detection Range for spawning and unloading Crates.
- Increased distance of object preview.

###### Fixed
- Detection for spawning and unloading crates now also includes players and other objects (like vehicles).
- Action for loading after unloading was missing.
- Pressing Escape while on progress bar now no longer instantly places the object down.

###### Known Issues
- Sandbags will not be properly shown for other players (All other objects work properly).

###### Future Goals
- Skip full trucks for loading cargo.
- Add limit on height change for objects.

---

##### Version 1.3 - 11.11.2025
The Multiplayer Compatibility Update.

###### Added
- New "ER32_addActions.sqf" file that now, instead of previously in "initPlayerLocal.sqf", manages the Actions.
- Multiplayer Compatibility. Means ressources and interactions can now properly be used in a multiplayer environment.

###### Changed
- "initPlayerLocal.sqf" now only redirects to other scripts, instead of holding code in itself.
- "init.sqf" --> "initServer.sqf" as only the server needs to run the code inside. 

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
* Fixed missing argument when trying to load an unloaded create back onto a flatbed.

---

##### Version 1.1 - 01.11.2025

###### Changed

* Changed the ER32\_CrateSpawner.sqf to now be more flexible. Instead of hard coding all the possible ressource add actions, it now loops over customisable arrays.
* Making it more flexible and allowing to add more than one Spawner.
* Ressource Count, name and classname, now also can be changed more easily.

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
