%Code to generate a value for the maximum temperature reached by the stagnation point of the nosecone (i.e. the tip, where the flow will stop)
%Done using the wiki article posted by Devansh Agarwal (2020), consolidating paper by Tauber (1987)
%Copyright Ishaan Alidina (2021)
function [q_dot,T_w] = NoseconeTipTemp
%%Housekeeping
clear
clc

%%Initialisation of values
T_w(1) = 0; %K: Wall temp value
M = 3; %Constant for velocity
N = 0.5; %Constant for density
epsilon = 0.92; %Assuming common 3D printing material 
sigma = 5.67*10^-8; %Stefan-Boltzmann Constant (W m^-2 K^-4)
Ma = 1.15; %Max velocity Mach number
V = 390; %Max velocity actual speed (m/s)
T_0 = (1 + 0.2 * Ma^2) * 274.375; %Max velocity stagnation temperature
r_n = 23 / 1000; %Body Nose Radius (m)
Tol(1) = 1; %Initial tolerance
i = 1; %Index value 
Alt = 1950; %m : Max velocity altitude
rho = interp1([1500,2000],[1.058,1.007],Alt); %Air density calculation
%%While loop to convergence of tip temperature

while abs(Tol(end)) > 1*10^-5
  g_w(i) = 0 %T_w(i) / T_0; %Ratio of wall to total enthalpy
  C = 1.83*10^-8 * (r_n)^-0.5 * (1-g_w(i)); %Proportionality constant
  q_dot(i) = (100^2) * C * rho^N * V^M; %Convective heat flux per unit area (W/m^2)
  T_w(i+1) = (q_dot(i) / (epsilon * sigma))^0.25; %Iterative finding of wall temperature at equilibrium at tip (stagnation point)
  Tol(i+1) = T_w(i+1) - T_w(i); %Increasing index value in each iteration
  i = i + 1;
end
  
%%Printing results

disp('Equilibrium temperature at convergence:'),disp(num2str(T_w(end))),disp('K')
disp('Iterations required:'),disp(num2str(i-1))

