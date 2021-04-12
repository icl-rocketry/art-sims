%Code to generate a value for the maximum temperature reached by the stagnation point of the nosecone (i.e. the tip, where the flow will stop)
%Done using the wiki article posted by Devansh Agarwal (2020), consolidating paper by Tauber (1987)
%Copyright Ishaan Alidina (2021)
%Idea for working by finding the constant C rather than T_w in loop given by Nathanael Jenkins (2021) 

function [q_dot,T_w] = NoseconeTipTemp

%%Housekeeping
clear
clc

%%Initialisation of values
M = 1; %Constant for velocity
N = 1.16; %Constant for density
tol = 1; %Initialising tolerance
epsilon = 0.92; %Assuming common 3D printing material 
sigma = 5.67*10^-12; %Stefan-Boltzmann Constant (W m^-2 K^-4)
Ma = 0.28; %Max velocity Mach number
V = 87.7; %Max velocity actual speed (m/s)
T_0 = (1 + (0.2 * Ma*Ma)) * 274.375; %Max velocity stagnation temperature
r_n = 23 / 1000; %Body Nose Radius (m)
Alt = 1950; %m : Max velocity altitude
i = 0; %Starting index value
rho = interp1([1500,2000],[1.058,1.007],Alt); %Air density calculation
const1 = (1.83*10^-8) / sqrt(r_n); %Constant used in loop
const2 = (((rho^N) * (V^M)) / (epsilon * sigma)); %Constant used in loop 
C(1)= 1.83*10^-8 / sqrt(r_n); %Initialising C

while tol > 1E-1
  C(i+2) = ((((-C(i+1)/const1)+1)*T_0)^4)/const2; %Equation to find C
  tol = abs(((const2*C(i+2))^0.25)-((const2*C(i+1))^0.25)) %Finding Tolerance
  i = i + 1; %Logging iteration number
end

T_w = (const2 .* C(length(C)))^0.25;
%%Printing results

disp('Equilibrium temperature at convergence:'),disp(num2str(T_w)),disp('K')
disp('Iteration number'),disp(num2str(i));
end
