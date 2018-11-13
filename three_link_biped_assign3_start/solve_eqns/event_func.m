%% 
% This function defines the event function.
% In the three link biped, the event occurs when the swing foot hits the
% ground.
%%
function [value,isterminal,direction] = event_func(t, y)

q = y(1:3);
dq = y(4:6);
[~, z_swf, ~, dz_swf] = kin_swf(q, dq);

% you may want to use kin_swf to set the 'value'
value = z_swf;
isterminal = 1;
direction = sign(dz_swf);

end
