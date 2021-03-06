function dy = eqns(t, y)
% n this is the dimension of the ODE, note that n is 2*DOF, why? 
% y1 = q1, y2 = q2, y3 = q3, y4 = dq1, y5 = dq2, y6 = dq3

q = [y(1) y(2) y(3)];
dq = [y(4) y(5) y(6)];

u = control(q, dq); % for the moment we set the control outputs to zero

n = 6;   
dy = zeros(n, 1);

M = eval_M(q);
C = eval_C(q, dq);
G = eval_G(q);
B = eval_B();


dy(1) = y(4);
dy(2) = y(5);
dy(3) = y(6);
% dy(4) = (B-C*y(4)-G*y(1))\M;
% dy(5) = (B-C*y(5)-G*y(2))\M;
% dy(6) = (B-C*y(6)-G*y(3))\M;

dy(4:6) = M\(B*u-C*y(4:6)-G);
% dy(4) = dy_456(1);
% dy(5) = dy_456(2);
% dy(6) = dy_456(3);

end