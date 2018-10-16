%%
% Evaluate the Mass matrix given q
function M = eval_M(q)
[m1, m2, m3, l1, l2, l3, g] = set_parameters;

q1 = q(1); q2 = q(2); q3 = q(3);

t2 = q1-q2;
t3 = cos(t2);
t4 = l1.*l2.*m2.*t3.*(1.0./2.0);
t5 = q1-q3;
t6 = cos(t5);
t7 = l1.*l3.*m3.*t6.*(1.0./2.0);
M = reshape([l1.^2.*(m1.*(1.0./4.0)+m2+m3),t4,t7,t4,l2.^2.*m2.*(1.0./4.0),0.0,t7,0.0,l3.^2.*m3.*(1.0./4.0)],[3,3]);

end