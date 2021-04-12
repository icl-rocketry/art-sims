
# Body heating calculations

Various heating calculation scripts.

**These have not been verified. Approach with caution**

**Do not use for low-mach calculations**

## Tip Heating Calculations

![Calculations](/Calculations.jpg)

Using equations 1, 2, 3, and 4 (which can be found in the ICLR heating calculations wiki page), an iterative equation can be developed to solve for constant C, which can the be substituted back into equation 4 to find the equlibrium wall temperature.
This should apple to flows above and below mach 1, although investigation into the accuracy of these calculations is ongoing.
