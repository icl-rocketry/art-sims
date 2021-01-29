function [q_dot,T_w] = FlatPlateHeating
%Function to calculate the equilibrium temperature and heat transfer rates of a flat plate 
%Done using the wiki article posted by Devansh Agarwal (2020), consolidating paper by Tauber (1987)
%Copyright Ishaan Alidina (2021)

%Housekeeping
clear
clc

%Initialising values

Mlam = 3.2; %Laminar constant for velocity
Nlam = 0.5; %Laminar constant for density
Mturb = 3.37; %Turbulent constant for velocity
Nturb = 0.8; %Turbulent constant for density

%For purposes of ease, let g_w = 0 initially 
end