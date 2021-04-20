
% Script to calcalate the equilibrium wall temperature at the nose tip, for a specified velocity and altitude
% Based off wiki article by Devansh Agarwal (2020), and report by Tauber and Menees (1987)
% Nathanael Jenkins 2021

% Link to proof coming soon

%% USER INPUT

M = 0.28;             % Mach number
rn = 0.0001;          % Nose radius (m)
alt = 0;          % Altitude (m)
eps = 0.92;          % Surface emmissivity
sig = 5.67*10^-12;   % Stefan-Boltzmann Constant (W m^-2 K^-4)

%% CALCUATIONS

[T, a, ~, rho] = atmosisa(alt);     % Altitude-based quantites (standard)
V = M*a;             % Velocity
T_0 = T*(1+0.2*M^2); % Stagnation temperature
A = ((1/sqrt(rn))*1.83*10^(-8))*(rho^0.5*V^3/(eps*sig));    % Useful constant
B = A/T_0;           % Useful constant

syms x
T_w = solve(x^4/A+x^2/T_0-1==0, x, 'MaxDegree', 4);
%pretty(T_w)
double(T_w)

T_w = solve(x^4==(A*(1-x/T_0)), x, 'MaxDegree', 4);
%pretty(T_w)
double(T_w)

T_w = solve(x==(A*(1-xx/T_0))^0.25, x, 'MaxDegree', 4);
%pretty(T_w)
double(T_w)
%%
fplot(x^4+B*x^2-A)
xlim([-700 700])
hold on
fplot(x^4/A+x^2/T_0-1)
fplot(x, 'k-')
plot([T_0, T_0], [-1000, 100000], 'k-')
hold off
%%
fplot(x^4)
hold on
fplot(A*(1-x/T_0))
xlim([-700 700])
hold off