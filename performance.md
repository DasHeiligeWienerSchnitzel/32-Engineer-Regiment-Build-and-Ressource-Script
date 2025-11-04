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

| ER32_CrateSpawner.sqf  | Spawn Crate Action | ER32_addActions.sqf |
| ---------------------  | ------------------ | ------------------- |
| 1.007                  | 2.014              | 36.990              |
| 1.038                  | 25.024             | 54.930              |
| 0.977                  | 1.953              | 57.010              |
| 1.038                  | 0.977              | 50.049              |
| 0.977                  | 0.977              | 51.025              |
| 1.038                  | 1.099              | 57.007              |
|  **Average: 1.012**    | 0.977              | 61.035              |
|                        | 0.977              | 166.016             |
|                        | 0.977              | 53.955              |
|                        | **Average: 3.886** | 57.007              |
|                        |                    | **Average: 64.502** |

