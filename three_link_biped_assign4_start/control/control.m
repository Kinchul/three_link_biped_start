function u = control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

% can choose speed in [0.5 0.6 0.8 1 1.2]
desired_speed = 1.2; % m/s

u = zeros(2,1);

[Kp, Kd, qr] = control_hyper_parameters(step_number, desired_speed);

[hd, dhd] = desired_outputs(t, q, dq, q0, dq0, qr, step_number);

u(1) =  Kp(1) * hd(1) + Kd(1) * dhd(1); 
u(2) = -Kp(2) * hd(2) - Kd(2) * dhd(2); 

end