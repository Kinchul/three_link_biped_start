close all;
clear all;

% Set start parameters
q0  = [0; 0; 0];
dq0 = [0.1; 0; 0];
num_steps = 50;

% Solve the system
sln = solve_eqns(q0, dq0, num_steps);

% Plot the animation
animate(sln);

% Analyse the animation
analyze(sln);



