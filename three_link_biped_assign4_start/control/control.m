function u = control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

u = zeros(2,1);

% compute first controller %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Kd1 = 80;
Kp1 = 200;

qr1 = pi/12;

y1  = q(3) - qr1;
dy1 = dq(3);

% compute second controller %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Kd2 = 6;
Kp2 = 30;

% y2 = q(2) - q(1) + qr2; 
% dy2 = dq(2) - dq(1);

% - The angle between the two legs: x = q2 - q1
% - we want y(x) to be a positive sinusoid function between 0 and 2pi/3 
%   (max total angle between the two legs): x = [0 ... 2pi/3]
% - with: y(0) = 2pi/3; y(2pi/3) = 0; => use cos^2(x/(max)*pi/2)

w = 1.5;
max_ang = 2*pi/3;

x = q(2) - q(1);
dx = dq(2) - dq(1);
y2  = x  + max_ang * cos((w*x/2 + pi/4)/max_ang)^2;
dy2 = dx - max_ang * sin((w*x/2 + pi/4)/max_ang)*2 * w * dx / max_ang;

% compute control signals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u(1) =   Kp1 * y1 + Kd1 * dy1;   
u(2) = - Kp2 * y2 - Kd2 * dy2; 

end