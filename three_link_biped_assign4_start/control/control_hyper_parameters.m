% You can set any hyper parameters of the control function here; you may or
% may not want to use the step_number as the input of the function. 
function [Kp, Kd, qr] = control_hyper_parameters(step_number, desired_speed)

Kp = zeros(2,1);
Kd = zeros(2,1);
qr = zeros(2,1);

% if (step_number < 5)
%     
%     Kp(1) = 100;
%     Kd(1) = 50;
% 
%     Kp(2) = 30;
%     Kd(2) = 3;
% 
%     qr(1) = pi/12;
%     qr(2) = pi/6;
%     
% else    
%     Kp(1) = 100;
%     Kd(1) = 50;
% 
%     Kp(2) = 15; %8
%     Kd(2) = 1.2; %1.2
% 
%     qr(1) = pi/3;
%     qr(2) = pi/3;
% end

% starting the walk, not dependent of speed
if (step_number < 5)
    Kp(1) = 100;
    Kd(1) = 50;

    Kp(2) = 30;
    Kd(2) = 3;

    qr(1) = pi/12;
    qr(2) = pi/6;

% walking at fixed speed
else
    switch desired_speed
        case 0.5
            Kp(1) = 80;
            Kd(1) = 40;

            Kp(2) = 10; %8
            Kd(2) = 1; %1.2

            qr(1) = pi/20;
            qr(2) = pi/2;
            
        case 0.6
            Kp(1) = 100;
            Kd(1) = 50;

            Kp(2) = 10; %8
            Kd(2) = 1.2; %1.2

            qr(1) = pi/25;
            qr(2) = pi/3;
            
        case 0.8
            Kp(1) = 100;
            Kd(1) = 50;

            Kp(2) = 12; %8
            Kd(2) = 1.2; %1.2

            qr(1) = pi/10;
            qr(2) = pi/3;
            
        case 1
            Kp(1) = 100;
            Kd(1) = 50;

            Kp(2) = 30; %8
            Kd(2) = 1.2; %1.2

            qr(1) = pi/5;
            qr(2) = pi/4.5;
            
        case 1.2
            Kp(1) = 100;
            Kd(1) = 50;

            Kp(2) = 30; %8
            Kd(2) = 1.2; %1.2

            qr(1) = pi/3;
            qr(2) = pi/4.5;
        
        otherwise % default speed: 1m/s
            Kp(1) = 100;
            Kd(1) = 50;

            Kp(2) = 30; %8
            Kd(2) = 1.2; %1.2

            qr(1) = pi/5;
            qr(2) = pi/4.5;
    end

end
