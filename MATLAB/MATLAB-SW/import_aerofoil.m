function aerofoil = import_aerofoil(filename, show)
% IMPORT_AEROFOIL  get normalised x, y data from an aerofil
%   aerofoil must be in a Selig format dat file - see airfoiltools.com
%   output as a polyshape
%   set show as true to display imported geometry

    if nargin == 1
        show = false;
    end
    
    %imported = importdata(filename);
    aerofoil = polyshape(imported.data(:, 1), imported.data(:, 2));
    
    if show
        
        figure
        plot(aerofoil);
        title ('Imported Geometry');
        xlabel ('x');
        ylabel ('y');
        axis equal        
    end
        
end
