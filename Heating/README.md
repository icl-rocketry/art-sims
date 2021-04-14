
# Body heating calculations

**Do not use. (See issue #2)**

## Tip Heating Calculations

![Calculations](./Calculations.jpg)

Using equations 1, 2, 3, and 4 (which can be found in the ICLR heating calculations wiki page), an iterative equation (5) can be developed to solve for equlibrium wall temperature. Alternatively, equation 6 can be solved using MATLAB, although it is important to initialise properly in order to solve for the correct root. Development is ongoing.

Something is up with these equations, as lower speed simulations are failing to resolve a velocity above T_0
