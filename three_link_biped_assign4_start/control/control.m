function u = control(t, q, dq, q0, dq0, step_number)
% You may call control_hyper_parameters and desired_outputs in this
% function
% you don't necessarily need to use all the inputs to this control function

u = zeros(2,1);

% Get the speed-dependent control parameters and gains
[Kp, Kd, qr] = control_hyper_parameters(step_number);

% Obtain the desired output
[hd, dhd] = desired_outputs(t, q, dq, q0, dq0, qr, step_number);

% Control law
u(1) =  Kp(1) * hd(1) + Kd(1) * dhd(1); 
u(2) = -Kp(2) * hd(2) - Kd(2) * dhd(2); 

end