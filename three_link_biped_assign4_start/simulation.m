close all;
clear all;
clc

% Storage variable for controler u (DO NOT TOUCH)
global u_store
global desired_speed
global current_index 
global perturbation_value
global nb_step_begins
current_index = 2;

% BELOW HERE YOU CAN TOUCH ------------------------------------------------

% Set start parameters
q0 =  [0; 0; 0];
dq0 = [0; 0; 0];

% Set number of steps
num_steps = 50;

% Set desired speed, can choose in [0.4 0.6 0.8 1 1.2]
desired_speed = 0.6;

% Perturbations value
perturbation_value = 30;

% Step before switching controler
nb_step_begins = 5;

% Solve the system
sln = solve_eqns(q0, dq0, num_steps);

% Plot the animation
animate(sln);

% Analyse the simulation results
% analyze(sln);


