
% Script to calcalate the equilibrium wall temperature at the nose tip, for a specified velocity and altitude
% Based off wiki article by Devansh Agarwal (2020), and report by Tauber and Menees (1987)
% Nathanael Jenkins 2021

% Link to proof coming soon

%% USER INPUT

M = 1.6;             % Mach number
rn = 0.001;          % Nose radius (m)
alt = 1000;          % Altitude (m)
eps = 0.92;          % Surface emmissivity
sig = 5.67*10^-12;   % Stefan-Boltzmann Constant (W m^-2 K^-4)

%% CALCUATIONS

[T, a, ~, rho] = atmosisa(alt);     % Altitude-based quantites (standard)
V = M*a;             % Velocity
T_0 = T*(1+0.2*M^2); % Stagnation temperature
A = ((1/sqrt(rn))*1.83*10^(-8))*(rho^0.5*V^3*eps^-1*sig^-1);    % Useful constant
B = A/T_0;           % Useful constant

T_w1 = + ( ( (sqrt(3*(2*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) + (sqrt(3*(2*(1+sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1-sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) ) + sign( (sign(-8*B) -0.5)*(sign(max( ((27*B^2)^2-4*(12*A)^3), min(0, -64*A))) -0.5) )*(sqrt(3*(2*(-1-sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1+sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3)))) )/12; % Calculate and compare for various p/m setups.
T_w2 = + ( ( (sqrt(3*(2*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) - (sqrt(3*(2*(1+sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1-sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) ) - sign( (sign(-8*B) -0.5)*(sign(max( ((27*B^2)^2-4*(12*A)^3), min(0, -64*A))) -0.5) )*(sqrt(3*(2*(-1-sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1+sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3)))) )/12; % Calculate and compare for various p/m setups.
T_w3 = - ( ( (sqrt(3*(2*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) + (sqrt(3*(2*(1+sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1-sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) ) + sign( (sign(-8*B) -0.5)*(sign(max( ((27*B^2)^2-4*(12*A)^3), min(0, -64*A))) -0.5) )*(sqrt(3*(2*(-1-sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1+sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3)))) )/12; % Calculate and compare for various p/m setups.
T_w4 = - ( ( (sqrt(3*(2*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) - (sqrt(3*(2*(1+sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1-sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3))) ) ) - sign( (sign(-8*B) -0.5)*(sign(max( ((27*B^2)^2-4*(12*A)^3), min(0, -64*A))) -0.5) )*(sqrt(3*(2*(-1-sqrt(-3))*(4 * (27*B^2 + sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3) + 2*(-1+sqrt(-3))*(4 * (27*B^2 - sqrt((27*B^2)^2 - 4*(12*A)^3)) )^(1/3)))) )/12; % Calculate and compare for various p/m setups.

disp(num2str(T_w1-273.15))
disp(num2str(T_w2-273.15))
disp(num2str(T_w3-273.15))
disp(num2str(T_w4-273.15))