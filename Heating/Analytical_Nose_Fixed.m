
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
A = ((1/sqrt(rn))*1.83*10^(-8))*(rho^0.5*V^3/(eps*sig));    % Useful constant
B = A/T_0;           % Useful constant

syms x
T_w = solve(x^4+B*x^2-A==0, x, 'MaxDegree', 4);
pretty(T_w)
