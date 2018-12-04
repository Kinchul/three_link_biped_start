function u = control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

u = zeros(2,1);

Kd1 = 80;
Kp1 = 200;

Kd2 = 5;
Kp2 = 30;

qr1 = pi/12;
qr2 = pi/7;

y1  = q(3)- qr1;
dy1 = dq(3);

% y2 = q(2) - q(1) + qr2; 
% dy2 = dq(2) - dq(1);

w = 2;
max_ang = pi/2;
y2  = q(2) - q(1) + max_ang * cos(w*(q(2) - q(1))) + pi/7;
dy2 = dq(2) - dq(1) - max_ang * sin(w*q(2) - q(1)) * w * (dq(2) - dq(1));  

u(1) = Kp1 * y1 + Kd1 * dy1;   
u(2) = -Kp2 * y2  - Kd2 * dy2; 
end