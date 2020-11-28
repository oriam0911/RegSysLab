% Parameterdatei Dreitank
% Uebung Regelungssysteme
%
% Erstellt:  19.10.2010 T. Utz
% Geaendert: 14.7.2011 F. Koenigseder
%            06.11.2014 S. Flixeder
% --------------------------------------
%

clc
close all;
clear;

% Parameter des Systems
parSys.Atank     = 1.539e-2;      % Grundfl�che Tank
parSys.rho       = 998;           % Dichte Wasser
parSys.eta       = 8.9e-4;        % Dynamische Viskosit�t Wasser
parSys.g         = 9.81;          % Gravitationskonstante
parSys.alphaA1   = 0.0583;        % Kontraktionskoeffizient AV1
parSys.DA1       = 15e-3;         % Durchmesser AV1
parSys.alphaA2   = 0.1039;        % Kontraktionskoeffizient AV2
parSys.A2        = 1.0429e-4;     % Querschnittsflaeche AV2
parSys.alphaA3   = 0.0600;        % Kontraktionskoeffizient AV3
parSys.DA3       = 15e-3;         % Durchmesser AV3
parSys.alpha12_0 = 0.3038;        % Kontraktionskoeffizient ZV12
parSys.A12       = 5.5531e-5;     % Querschnittsflaeche ZV12
parSys.Dh12      = 7.7e-3;        % hydraulischer Durchmesser
parSys.lambdac12 = 24000;         % kritische Fliesszahl ZV12
parSys.alpha23_0 = 0.1344;        % Kontraktionskoeffizient ZV23
parSys.D23       = 15e-3;         % Durchmesser ZV23
parSys.lambdac23 = 29600;         % Kritische Fliesszahl ZV23
parSys.hmin      = 0.05;          % Minimale Fuellhoehe
parSys.hmax      = 0.55;          % Maximale Fuellhoehe

% Abtastzeit
parSys.Ta = 0.2;                

% Anfangsbedingung
parSys.h1_0 = 0.1801527441e0;
parSys.h2_0 = 0.1;
parSys.h3_0 = 0.0;

% Maximale Zufluesse
parSys.qZ1max = 4.5e-3/60;        % Maximaler Zufluss Z1
parSys.qZ3max = 4.5e-3/60;        % Maximaler Zufluss Z3
parSys.qZ1min = 0;                % Minimaler Zufluss Z1
parSys.qZ3min = 0;                % Minimaler Zufluss Z3

% Sollwertfilter
s = tf('s');

% Pole weit links bedeutet bessere Ann�herung (schneller) an den
% Eingangsverlauf
% a = -0.06; % ohne Stellgr��enbeschr�nkung
a = -0.02;
a = poly(a*ones(1,3));

a0 = a(4);
a1 = a(3);
a2 = a(2);

A = [0,1,0;0,0,1;-a0,-a1,-a2];
B = [0;0;a0];
C = [1,0,0;0,1,0;0,0,1];
D = [0];

sys = ss(A,B,C,D);

Ts = parSys.Ta;
sysd = c2d(sys,Ts,'zoh');

% Parameter des Sollwertfilters
parSollFilt.A = sysd.A;
parSollFilt.B = sysd.B;
parSollFilt.C = sysd.C;
parSollFilt.D = sysd.D;

parSollFilt.yd0 = parSys.h2_0;

% Parameters des Reglers
parReg.delta_h_min = 0.001;

% Pole sehr weit links bedeutet schnelleres abklingen der Fehlerdynamik
% Sehr weit links f�hrt zu starkem Ripple
% pReg = -1; % Ohne Stellgr��enbeschr�nkung
pReg = -4;
aReg = poly(ones(2,1)*pReg);

parReg.a0 = aReg(3);
parReg.a1 = aReg(2);