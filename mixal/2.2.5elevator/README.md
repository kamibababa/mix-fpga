## The elevator simulator

Let's run the elevator simulator (TAOCP 2.2.5). First we add a routine for user input which reads from terminal U19 in the format "FTAAANNNN" where

* F = (0..4) floor from
* T = (0..4) floor to
* AAA = (000-999) time in tenth of seconds after which user goes by foot
* NNNN = (0000-9999) time in tenth of seconds after which a new user enters the system. 

We will run the simulation `elevator.mixal` on MIX. Then we will input `elevator.in` so MIX will process the user input by the simulation.

``` 
$ cd 2.2.5elevator
$ make clean
$ make
```

The output `elevator.out` shows the result of simulation, after processing the user input `elevator.in`


```
 0000  2    N                    U1                                                                                     
 0035  2    D                    E8                                                                                     
 0038  1    D                    U1                                                                                     
 0096  1    D                    E8                                                                                     
 0136  0    D                    U1                                                                                     
 0141  0    D                    U1                                                                                     
 0152  0    D                    U4                                                                                     
 0180  0    D                    E2                                                                                     
 0180  0    N                    E3                                                                                     
 0256  0    N         X    X     E5                                                                                     
 0291  0    U         X          U1                                                                                     
 0291  0    U         X          E7                                                                                     
 0342  1    U         X          E7                                                                                     
 0364  2    U         X          U1                                                                                     
 0393  2    U         X          E7                                                                                     
 0444  3    U         X          E7                                                                                     
 0509  4    U         X          E2                                                                                     
 0509  4    N         X          E3                                                                                     
 0529  4    N    X    X          U5                                                                                     
 0540  4    D    X    X          U4                                                                                     
 0554  4    D         X    X     E5                                                                                     
 0589  4    D         X          E8                                                                                     
 0602  3    D         X          U1                                                                                     
 0673  3    D         X          E2                                                                                     
 0673  3    D         X          E3                                                                                     
 0693  3    D    X    X          U5                                                                                     
 0749  3    D         X    X     E5                                                                                     
 0784  3    D         X          E8                                                                                     
 0827  2    D         X          U1                                                                                     
 0868  2    D         X          E2                                                                                     
 0868  2    D         X          E3                                                                                     
 0876  2    D    X    X          U1                                                                                     
 0888  2    D    X    X          U5                                                                                     
 0913  2    D    X    X          U5                                                                                     
 0944  2    D         X    X     E5                                                                                     
 0979  2    D         X          E8                                                                                     
 1048  1    D         X          U1                                                                                     
 1063  1    D         X          E2                                                                                     
 1063  1    D         X          E3                                                                                     
 1139  1    D    X    X          E5                                                                                     
 1179  1    D    X    X          E5                                                                                     
 1183  1    D    X    X          U5                                                                                     
 1208  1    D    X    X          U5                                                                                     
 1219  1    D    X    X          E5                                                                                     
 1233  1    D    X    X          U5                                                                                     
 1259  1    D         X    X     E5                                                                                     
 1294  1    D         X          E8                                                                                     
 1378  0    D         X          E2                                                                                     
 1378  0    U         X          E3                                                                                     
 1423  0    U    X    X          U5                                                                                     
 1454  0    U         X    X     E5                                                                                     
 1489  0    U         X          E7                                                                                     
 1554  1    U         X          E2                                                                                     
 1554  1    U         X          E3                                                                                     
 1630  1    U         X    X     E5                                                                                     
 1665  1    U         X          E7                                                                                     
 1730  2    U         X          E2                                                                                     
 1730  2    U         X          E3                                                                                     
 1806  2    U         X    X     E5                                                                                     
 1841  2    U         X          E7                                                                                     
 1906  3    U         X          E2                                                                                     
 1906  3    U         X          E3                                                                                     
 1982  3    U         X    X     E5                                                                                     
 2017  3    U         X          E7                                                                                     
 2082  4    U         X          E2                                                                                     
 2082  4    N         X          E3                                                                                     
 2158  4    N         X    X     E5                                                                                     
 2193  4    D         X          E8                                                                                     
 2254  3    D         X          E8                                                                                     
 2338  2    D         X          E2                                                                                     
 2338  2    N         X          E3                                                                                     
 2414  2    N         X    X     E5                                                                                     
 5047  2    N                    U1                                                                                     
```
