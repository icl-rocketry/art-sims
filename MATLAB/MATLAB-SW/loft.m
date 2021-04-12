clear

unit_system = 'MMGS';

% add other cases here to support other unit systems
switch unit_system
    case 'MMGS'
        unit_conversion = 1000;        
end

% array of z coordinates
z = 0:0.02:0.5;

% all cross sections must be polyshapes
% using aerofoils here to demonstrate
cross_sections = {};
cross_sections{1} = import_aerofoil('examples/e216.dat');
cross_sections{2} = import_aerofoil('examples/lwk80100.dat');

% centre of transformation for aerofoils is at quarter chord
centre = [0.25 0];
% example chord and twist
chord = 1;
theta = 0;

% begin export

figure
hold on

progress = waitbar(0, 'Plotting');

macro = fopen('examples/macro.txt', 'w');

fprintf(macro, 'Dim swApp As Object\nDim longstatus As Long, longwarnings As Long\n');
fprintf(macro, 'Sub main()\n');
fprintf(macro, "Dim swApp As Object\nDim Part As Object\nDim boolstatus As Boolean\n");
fprintf(macro, "Set swApp = Application.SldWorks\nSet Part = swApp.ActiveDoc\n");   
fprintf(macro, 'Dim myModelView As Object\nSet myModelView = Part.ActiveView\n');
fprintf(macro, 'myModelView.FrameState = swWindowState_e.swWindowMaximized\n');

cdir = pwd;
base = 'boolstatus = Part.InsertCurveFile("';
ending = '")';

selectcostart = 'boolstatus = Part.Extension.SelectByID2("Curve';
selectcoend = '", "REFERENCECURVES", 0, 0, 0, True, 1, Nothing, 0)';
loftcommand = ['Part.FeatureManager.InsertProtrusionBlend False, True, False, ' ...
    '1, 0, 0, 1, 1, True, True, False, 0, 0, 0, True, True, True\nPart.ClearSelection2 True\n'];

for i = 1:1:length(z)
    
    p = i/length(z);
    waitbar(p, progress, sprintf('Plotting element %.d of %.d', i, length(z)))
    xc = cross_sections{choose_xc(z(i))};
    
    transformed = transform(xc, chord, theta, centre);
    
    [x, y] = boundary(transformed);
    z_out = z(i)*ones(length(x), 1);
    
    plot3(x, y, z_out, '.');
    
    fname = sprintf("examples/sections/section_%.d.sldcrv", i);
    crv = fopen(fname, 'w');
    
    for j = 1:1:length(x) 
        X = x(j)*unit_conversion;
        Y = y(j)*unit_conversion;
        Z = z_out(j)*unit_conversion;
        
        fprintf(crv, '%.4f %.4f %.4f\n', X, Y, Z);
    end
    
    fclose(crv);
    
    % replace \ with / if not using windows
    fname = sprintf('\\examples\\sections\\section_%.d.sldcrv', i);
    
    fprintf(macro, "%s%s%s%s\n", base, cdir, fname, ending);
    
    % random change to chord and twist to demonstrate transformation
    % replace or remove if necessary 
    chord = chord - 0.03;
    theta = theta + 2;
end

for i = length(z):-1:2
    
    fprintf(macro, '%s%d%s\n', selectcostart, (i-1), selectcoend);
    fprintf(macro, '%s%d%s\n', selectcostart, i, selectcoend);
    fprintf(macro, loftcommand);

    
end

fprintf(macro, 'Set swApp = Application.SldWorks\nEnd Sub');
fclose(macro);

open examples/macro.txt

close(progress);
title('Visualistion');
xlabel('x');
ylabel('y');
zlabel('z');

grid ON;
view(3)
axis equal

function index = choose_xc(z)
% allows different cross sections to be chosen along the length of the part

    if z < 0.3
        index = 1;
    else
        index = 1;
    end
end
