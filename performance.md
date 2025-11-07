Performance is tested by the following code:

```
  private _start = diag_tickTime;
  
  ... Code ...
  
  private _end = diag_tickTime;
  private _time = ((_end - _start) * 1000) - 1000;
  waitUntil { !isNull player && alive player };
  sleep 1;
  hint format ["Code runned for %1 ms", _time];
  copyToClipboard (str _time);

```

The following table shows the performance tested on the different script parts.

**Time shown in ms.**

| ER32_CrateSpawner.sqf  | Spawn Crate Action | ER32_addActions.sqf | ER32_PlaceObject.sqf |
| ---------------------  | ------------------ | ------------------- | -------------------- |
| 1.007                  | 2.014              | 36.990              | 5.9                  |
| 1.038                  | 25.024             | 54.930              | 6.1                  |
| 0.977                  | 1.953              | 57.010              | 4.88                 |
| 1.038                  | 0.977              | 50.049              | 6.1                  |
| 0.977                  | 0.977              | 51.025              | 7.08                 |
| 1.038                  | 1.099              | 57.007              | 2.2                  |
|  **Average: 1.012**    | 0.977              | 61.035              | 6.1                  |
|                        | 0.977              | 166.016             | 2                    |
|                        | 0.977              | 53.955              | **Average: 5.045**   |
|                        | **Average: 3.886** | 57.007              |                      |
|                        |                    | **Average: 64.502** |                      |

"Check for ressources" actions and "ER32_Flatbed.sqf" didnt bring any reasonable results with showing either just 0 ms or always 0.976 ms. 

In terms of performance, it seems that most of the script is not particularly demanding. Ignoring the initialisation, which takes around 64.502 ms, that only happens once at the start of the game. 
As expected, the 'ER32_PlaceObject.sqf' script is the most performance-heavy, with an average time of 5.045 ms. In terms of performance, this is still good.

