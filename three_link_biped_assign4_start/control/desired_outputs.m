% If you are using the virtual constraints or trajectory based control
% methods, then you may cosider using a function such as this. 
function [hd, dhd] = desired_outputs(t, q, dq, q0, dq0, qr, step_number)

global nb_step_begins

hd  = zeros(1,2);
dhd = zeros(1,2);

% Set the first output: torso control
hd(1)  = q(3) - qr(1);
dhd(1) = dq(3);

% Set the second output: legs control
if (step_number < nb_step_begins)    
    hd(2) = q(2)  - q(1) + qr(2); 
    dhd(2) = dq(2) - dq(1);
else
% tries to match a sinusoid for smoothing
    hd(2)  = q(2)  - q(1)  + qr(2)/2 * cos((q(2) - q(1))/qr(2)*pi) + qr(2)/2;
    dhd(2) = dq(2) - dq(1) - qr(2)/2 * sin((q(2) - q(1))/qr(2)*pi) * ...
                                           (dq(2)-dq(1))/qr(2)*pi;
            
end

end