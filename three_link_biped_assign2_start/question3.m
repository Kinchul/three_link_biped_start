alpha = 0:0.01:pi/4;
dq_m = [1, 0.2, 0];

loss = zeros(1,size(alpha,2));

for i = 1:size(alpha,2)    
    
    q_m = [alpha(i), -alpha(i), 0];    
    [T1, ~] = eval_energy(q_m, dq_m);
    [q_p, dq_p] = impact(q_m, dq_m);
    [T2, ~] = eval_energy(q_p, dq_p);
    
    loss(i) = (1 - T2/T1)*100;    
    
end

plot(alpha, loss)
legend("Kinetic Energy Loss")
xlabel("Angle \alpha")
ylabel("Energy Loss (%)")
