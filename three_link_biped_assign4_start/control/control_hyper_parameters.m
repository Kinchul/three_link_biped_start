% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 
function [Kp, Kd, qr] = control_hyper_parameters(step_number)

Kp = zeros(2,1);
Kd = zeros(2,1);
qr = zeros(2,1);

if (step_number < 3)
    
    Kp(1) = 30;
    Kd(1) = 40;

    Kp(2) = 300;
    Kd(2) = 50;

    qr(1) = pi/12;
    qr(2) = pi/4;
    
else    
    Kp(1) = 100;
    Kd(1) = 80;

    Kp(2) = 400;
    Kd(2) = 50;

    qr(1) = pi/12;
    qr(2) = pi/4;
end

end
