# matlab-sw
Exporting geometries from MATLAB to SOLIDWORKS

## loft
Exports a series of cross sections at z coordinates to a solidworks part constructed using lofts.

To use:

1) open **loft.m** 
2) Create an array of the z coordinates of your cross sections - line 12
3) Import your cross sections. These must be as *polyshapes* - see the MATLAB documentation.
  For this, you can use **import_aerofoil.m** to import aerofoils from airfoiltools.com 
4) For variable cross sections, you can define the cross section to use by modifying the choose_xc function
5) Define your centre of transformation
6) Transformations of the cross section (enlargements and rotations) occur on line 57 - modify the parameters to those desired.
7) Set all file directories to those desired
8) Run the program
9) Open SOLIDWORKS, and create a new part
10) Go to Tools --> Macros --> New and create a new macro
11) Replace the code in the new macro with the code in the macro.txt file
12) Save and run the macro

**Note:** you cannot directly export a macro from MATLAB to SOLIDWORKS. You must create a new macro in SOLIDWORKS and copy and paste the code created by this program.

### Known Bugs
Some sections may not create a loft in between due to an unknown error, these can be created manually after the rest of the part has been created. The guide curves will still be present.
