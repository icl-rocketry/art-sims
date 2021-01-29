%Code to generate a value for the maximum temperature reached by the stagnation point of the nosecone (i.e. the tip, where the flow will stop)
%Done using the wiki article posted by Devansh Agarwal (2020), consolidating paper by Tauber (1987)
%Copyright Ishaan Alidina (2021)
%Idea for working by finding the constant C rather than T_w in loop given by Nathanael Jenkins (2021) 

%function [q_dot,T_w] = NoseconeTipTemp

%%Housekeeping
clear
clc

%%Initialisation of values
M = 3; %Constant for velocity
N = 0.5; %Constant for density
tol = 1; %Initialising tolerance
epsilon = 0.92; %Assuming common 3D printing material 
sigma = 5.67*10^-8; %Stefan-Boltzmann Constant (W m^-2 K^-4)
Ma = 1.15; %Max velocity Mach number
V = 390; %Max velocity actual speed (m/s)
T_0 = (1 + (0.2 * Ma*Ma)) * 274.375; %Max velocity stagnation temperature
r_n = 23 / 1000; %Body Nose Radius (m)
Alt = 1950; %m : Max velocity altitude
i = 0; %Starting index value
rho = interp1([1500,2000],[1.058,1.007],Alt); %Air density calculation
const1 = (1.83*10^-8) / sqrt(r_n); %Constant used in loop
const2 = (((rho^N) * (V^M) * (100*100)) / (epsilon * sigma)); %Constant used in loop 
C1 = 0;

while tol > 1E-1
  C2 = ((((-C1/const1)+1)*T_0)^4)/const2; %Equation to find C
  tol = abs(((const2*C2)^0.25)-((const2*C1)^0.25)); %Finding Tolerance
  C2 = C1; %Updating value
  i = i + 1; %Logging iteration number
  T_w = (const2 .* C2)^0.25; %Temperature log
end

T_w = (const2 .* C2)^0.25
%%Printing results

disp('Equilibrium temperature at convergence:'),disp(num2str(T_w(end))),disp('K')
disp('Iteration number'),disp(num2str(i));