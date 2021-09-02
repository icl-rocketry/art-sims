Merge "NEW.iges";
//+
Physical Volume("fluid", 28) = {1};
//+
Physical Surface("farfield", 29) = {8, 11, 10};
//+
Physical Surface("inlet", 30) = {7};
//+
Physical Surface("outlet", 31) = {9};
//+
Physical Surface("symm", 32) = {12};
//+
Physical Surface("wall", 33) = {6, 1, 2, 3, 4, 5};
//+
Transfinite Curve {5, 7, 11, 13} = 100 Using Progression 1;
//+
Transfinite Curve {1, 15, 4, 2, 6, 9} = 25 Using Progression 1;
