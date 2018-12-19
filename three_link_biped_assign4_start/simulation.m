close all;
clear all;
clc

% Set start parameters
q0 =  [0; 0; 0];
dq0 = [0; 0; 0];
num_steps = 50;

% Set desired speed, can choose in [0.4 0.6 0.8 1 1.2]
global desired_speed
desired_speed = 0.6;

% Storage variable for controler u
global u_store
global current_index 
current_index = 2;

% Solve the system
sln = solve_eqns(q0, dq0, num_steps);

% Plot the animation
animate(sln);

% Analyse the simulation results
analyze(sln);


