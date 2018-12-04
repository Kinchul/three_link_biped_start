%% Read the README_ASSIGN4.pdf to see what results you need to analyze here. 
function sln = analyze(sln)

    % sets the numbers for counters
    number_steps = length(sln.Y);
    number_time_step = 0;     % will be set later
    
    
    % creates and set the time, q and dq vectors
    time = [];
    q = [];
    dq = [];
    step_vect = [];
    length_step = zeros(number_time_step, 1);
    for i=1: number_steps      % for each step
        
        % fills the vectors
        time = [time; sln.T{i}];
        q = [q; sln.Y{i}(:,1:3)];
        dq = [dq; sln.Y{i}(:,4:6)];
        step_vect = [step_vect; i*ones(length(sln.T{i}),1)];
        
        % compute step length
        q_end = sln.YE{i}(1:3);
        length_step(i) = kin_swf(q_end);
    end
    number_time_step = length(time);
    
    
    % obtain pos and vel of hip joint
    pos_hip = zeros(number_time_step, 2);
    vel_hip = zeros(number_time_step, 2);
    for j=1: number_time_step       % for each time point
        [x_h, z_h, dx_h, dz_h] = kin_hip(q(j,:), dq(j,:));
        pos_hip(j,:) = [x_h + sum(length_step(1:step_vect(j))); z_h];
        vel_hip(j,:) = [dx_h; dz_h];
    end
    
    % creates continuous q
    q1_v2 = zeros(length(time),1);
    q2_v2 = zeros(length(time),1);
    for i=1: length(time)
        if mod(step_vect(i),2) == 1
            q1_v2(i) = q(i,1);
            q2_v2(i) = q(i,2);
        else
            q1_v2(i) = q(i,2);
            q2_v2(i) = q(i,1);
        end
    end
    q_v2 = [q1_v2 q2_v2 q(:,3)];
    
    % creates continuous dq
    dq1_v2 = zeros(length(time),1);
    dq2_v2 = zeros(length(time),1);
    for i=1: length(time)
        if mod(step_vect(i),2) == 1
            dq1_v2(i) = dq(i,1);
            dq2_v2(i) = dq(i,2);
        else
            dq1_v2(i) = dq(i,2);
            dq2_v2(i) = dq(i,1);
        end
    end
    dq_v2 = [dq1_v2 dq2_v2 dq(:,3)];
    
    % obtain torque
    torque = zeros(number_time_step, 3);    % in order, leg1, leg2, torso
    for j=2: number_time_step       % for each time point
        for limb=1: 3               % for leg1, leg2 and torso
            torque(j,limb) = (dq_v2(j,limb) - dq_v2(j-1,limb))/(time(j)-time(j-1));
            if(abs(torque(j,limb)-torque(j-1,limb))>500)   % removes spike
                torque(j,limb) = torque(j-1,limb);
            end
        end
    end
    [m1, ~, m3, l1, ~, l3, ~] = set_parameters();
    inertia_torso = m3*l3^2/4;
    inertia_legs = m1*l1^2/4;
    torque(:,3) = torque(:,3) * inertia_torso;
    torque(:,1:2) = torque(:,1:2) * inertia_legs;
    
    
    % plotting
%     plotStepVect(time, step_vect);
%     plotQ(time, q_v2*180/pi);
%     plotDQ(time, dq_v2*180/pi);
%     plotHipPos(time, pos_hip);
%     plotSpeed(time, sln.TE{1}, vel_hip, pos_hip);
    plotTorque(time, torque);

end

function plotTorque(time, torque)
    
    % plot torques
    figure;
    subplot(3,1,1);
    plot(time, torque(:,1));
    legend('Leg 1');
    xlabel('Time');
    ylabel('Torque [Nm]');
    subplot(3,1,2);
    plot(time, torque(:,2));
    legend('Leg 2');
    xlabel('Time');
    ylabel('Torque [Nm]');
    subplot(3,1,3);
    plot(time, torque(:,3));
    legend('Torso');
    xlabel('Time');
    ylabel('Torque [Nm]');
end

function plotHipPos(time, pos_hip)
   
    figure;
    plot(time, pos_hip(:,1)); hold on;
    plot(time, pos_hip(:,2));
    legend('x', 'z','Location','NorthWest');
    title('Hip position')
    xlabel('Time [s]')
    ylabel('Distance [m]')
    
end


function plotSpeed(time, time_start, vel_hip, pos_hip)
   
    mean_velocity = round(pos_hip(end,1)/time(end),1);

    figure;
    plot(time, vel_hip(:,1)); hold on;
    plot(time, vel_hip(:,2));
    plot(time(time>time_start), ...
         pos_hip(time>time_start,1)./time(time>time_start),'LineWidth',3);
    legend('x', 'z',['Mean velocity: ',num2str(mean_velocity),' m/s'], ...
           'Location','SouthEast');
    title('Hip velocity')
    xlabel('Time [s]')
    ylabel('Speed [m/s]')
        
end

function plotQ(time, q)
  
    % plot angles
    figure;
    subplot(3,1,1);
    plot(time, q(:,1));
    legend('q1');
    xlabel('time');
    ylabel('angle [deg]');
    subplot(3,1,2);
    plot(time, q(:,2));
    legend('q2');
    xlabel('time');
    ylabel('angle [deg]');
    subplot(3,1,3);
    plot(time, q(:,3));
    legend('q3');
    xlabel('time');
    ylabel('angle [deg]');
end

function plotDQ(time, dq)
   
    % plot angular velocity
    figure;
    subplot(3,1,1);
    plot(time, dq(:,1));
    legend('dq1');
    xlabel('time');
    ylabel('angular velocity [deg/s]');
    subplot(3,1,2);
    plot(time, dq(:,2));
    legend('dq2');
    xlabel('time');
    ylabel('angular velocity [deg/s]');
    subplot(3,1,3);
    plot(time, dq(:,3));
    legend('dq3');
    xlabel('time');
    ylabel('angular velocity [deg/s]');
end

function plotStepVect(time, step_vect)
    
    figure;
    plot(time, step_vect);
    title('step number');
end