% Set start parameters
q0 = [pi/6; -pi/3; 0];
dq0 = [0;0;8];
num_steps = 10;

% Solve the system
sln = solve_eqns(q0, dq0, num_steps);

% Plot the animation
animate(sln);