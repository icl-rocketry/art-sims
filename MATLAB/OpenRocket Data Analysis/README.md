
# OpenRocket Data Analysis
MATLAB-based analysis of OpenRocket results.

To use:

1) Run OpenRocket simulation
2) Export all OpenRocket data as .csv (**do not** include event labels)
3) Change 'filename' to the correct file in MATLAB livescript
4) Set rocket name, max body radius, leading edge fin sweep, and distance from nose to fin tips (only the first section of code should need changing)
5) Run MATLAB script

Generates:

- 3D flight path
- Stability plot (**not** using Barrowman method)
- Velocity & acceleration profile
- Data summary, including heating effects

### Issues
Still under development, there are currently no plot legends.
Stability calculations have not been verified, as OpenRocket uses a different method to calculate stability in simulations; be wary of under-predictions.
Heating calculations have not been verified, and may perform poorly in low-mach flight.
