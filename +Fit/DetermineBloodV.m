function [vblood] = DetermineBloodV(bodylength,bodymass)
%This functions contains a formula to calculate the blood volume of a
%person based on the person's length, bodymass and sex (always male in our
%case). This formula is constructed by Nadler, Hidalgo and Bloch.

%Input and output arguments:
    %bloodvolume (output) in liters (l)
    %bodylength (input) in meters (m)
    %bodymass (input) in kilograms (kg)

%Parameters in formula
k1 = 0.3669;
k2 = 0.03219;
k3 = 0.6041;

%Formula's and correction for [l] -> [ml]
vblood = k1*(bodylength)^3 + k2*bodymass + k3;
vblood = vblood*1000;