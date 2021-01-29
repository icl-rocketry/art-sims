%Script to calcalate the temperatures of fin LEs at a specified velocity and altitude
%Based off wiki article by Devansh Agarwal (2020), and report by Tauber and Menees (1987)
%Copyright Ishaan Alidina (2021)

%Housekeeping
clear
clc

%%Calculating stagnation heating

[q_dot0,T_w0] = NoseconeTipTemp;

%%Calculating flat-plate heating


