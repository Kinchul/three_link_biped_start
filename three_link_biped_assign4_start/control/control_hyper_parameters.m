% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 
function [Kp, Kd, qr] = control_hyper_parameters(step_number)

Kp = zeros(2,1);
Kd = zeros(2,1);
qr = zeros(2,1);

if (step_number < 0) %not used
    
    Kp(1) = 100;
    Kd(1) = 50;

    Kp(2) = 30;
    Kd(2) = 3;

    qr(1) = pi/12;
    qr(2) = pi/6;
    
else    
    Kp(1) = 80;
    Kd(1) = 25;

    Kp(2) = 30;
    Kd(2) = 3;

    qr(1) = pi/10;
    qr(2) = pi/6;
end

end
