q0 = [pi/6; -pi/3; 0];
dq0 = [0;0;10];
num_steps = 10;

sln = solve_eqns(q0, dq0, num_steps);

animate(sln);