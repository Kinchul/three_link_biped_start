%% Read the README_ASSIGN4.pdf to see what results you need to analyze here. 
function sln = analyze(sln)

    % sets the numbers for counters
    number_steps = length(sln.Y);
    number_time_step = 0;     % will be set later
    
    
    % creates and set the time, q and dq vectors
    time = [sln.T{1}(1)];
    q = [sln.Y{1}(1,1:3)];
    dq = [sln.Y{1}(1,4:6)];
    step_vect = [1];
    length_step = zeros(number_time_step, 1);
    for i=1: number_steps      % for each step
        
        % fills the vectors
        time = [time; sln.T{i}(2:end)];
        q = [q; sln.Y{i}(2:end,1:3)];
        dq = [dq; sln.Y{i}(2:end,4:6)];
        step_vect = [step_vect; i*ones(length(sln.T{i})-1,1)];
        
        % compute step length
        q_end = sln.YE{i}(1:3);
        length_step(i) = kin_swf(q_end);
        
        % fils step time
        step_end_time(i) = sln.TE{i};
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
    for j = 2 : number_time_step            % for each time point
        for limb = 1 : 3                    % for leg1, leg2 and torso
            dt = time(j)-time(j-1);
            torque(j,limb) = (dq_v2(j,limb) - dq_v2(j-1,limb))/dt;
%             if(abs(torque(j,limb)-torque(j-1,limb))>500)   % removes spike
%                 torque(j,limb) = torque(j-1,limb)
%             end
        end
    end    
    [m1, ~, m3, l1, ~, l3, ~] = set_parameters();
    inertia_torso = m3*l3^2/4;
    inertia_legs = m1*l1^2/4;
    torque(:,3) = torque(:,3) * inertia_torso;
    torque(:,1:2) = torque(:,1:2) * inertia_legs;
    
    torqueU = zeros(number_time_step, 2);
    torqueU(:,1) = torque(:,3) - torque(:,2);
    torqueU(:,2) = torque(:,3) + torque(:,1);  
    
    % Compute CoT
    Etot = 0;
    lastEkin = 0;
    lastEpot = pos_hip(j,2) - (l1/2) * cos(q(j,1)) * m1 * 9.81 + pos_hip(j,2) - (l1/2) * cos(q(j,2)) * m1 * 9.81 + pos_hip(j,2) + (l3/2) * cos(q(j,3)) * m3 * 9.81;
    for j=2: number_time_step      
        Ekin = dq(j,1)^2 * inertia_legs / 2 + dq(j,2)^2 * inertia_legs / 2 +  dq(j,3)^2 * inertia_torso / 2;
        Epot = pos_hip(j,2) - (l1/2) * cos(q(j,1)) * m1 * 9.81 + pos_hip(j,2) - (l1/2) * cos(q(j,2)) * m1 * 9.81 + pos_hip(j,2) + (l3/2) * cos(q(j,3)) * m3 * 9.81;
        dEkin = Ekin-lastEkin;
        dEpot = Epot-lastEpot;
        
        Etot = Etot + abs(dEkin-dEpot);
        lastEkin = Ekin;
        lastEpot = Epot;
        
    end
    cot = Etot / ((m1+m1+m3) * 9.81 * pos_hip(number_time_step,2))
    
    % plotting
%     plotStepVect(time, step_vect);
%     plotStepLength(step_vect, length_step);
%     plotStepFrequency(time, step_vect, step_end_time);
%     plotQ(time, q_v2*180/pi);
%     plotDQ(time, dq_v2*180/pi);
    plotHipPos(time, pos_hip);
    plotSpeed(time, sln.TE{1}, vel_hip, pos_hip);
    [idx,~] = find(time == cell2mat(sln.TE));
    plotTorque(cell2mat(sln.TE)', torqueU(idx,:));
    plotTorque(time, torqueU);
%     plotQvsDQ(q_v2*180/pi, dq_v2*180/pi);
    plotCOT(time);

end

function plotCOT(time)
    %%TODO
end

function plotQvsDQ(q, dq)
    
    % plot of q against dq
    figure;
    subplot(3,1,1);
    plot(q(:,1), dq(:,1));
    legend('Leg 1');
    xlabel('q [deg]');
    ylabel('dq [deg/s]');
    subplot(3,1,2);
    plot(q(:,2), dq(:,2));
    legend('Leg 2');
    xlabel('q [deg]');
    ylabel('dq [deg/s]');
    subplot(3,1,3);
    plot(q(:,3), dq(:,3));
    legend('Torso');
    xlabel('q [deg]');
    ylabel('dq [deg/s]');
    
end

function plotStepFrequency(time, step_vect, step_end_time)
    
    step_frequency = zeros(length(step_end_time),1);
    step_frequency(1) = 1/step_end_time(1);
    for i=2: length(step_end_time)
        step_frequency(i) = 1/(step_end_time(i)-step_end_time(i-1));
    end
    
    % plot step frequency vs step number
    figure;
    plot(1:length(step_frequency), step_frequency); grid on;
    xlabel('Step number');
    ylabel('Step frequency [Hz]');
    title('Step frequency vs step number');
    
end

function plotStepLength(step_vect, length_step)
    
    length_step_long = zeros(length(step_vect),1);
    for i=1: length(length_step_long)
        length_step_long(i) = length_step(step_vect(i));
    end

    % plot step length vs step number
    figure;
    plot(step_vect, length_step_long); grid on;
    xlabel('Step number');
    ylabel('Step length [m]');
    title('Step length vs step number');
    
end

function plotTorque(time, torque)
    
    % plot torques
    figure;
    subplot(2,1,1);
    plot(time, torque(:,1));
    legend('Actuator u1');
    xlabel('Time');
    ylabel('Torque [Nm]');
    subplot(2,1,2);
    plot(time, torque(:,2));
    legend('Actuator u2');
    xlabel('Time');
    ylabel('Torque [Nm]');
end

function plotHipPos(time, pos_hip)
   
    figure;
    subplot(2,1,1);
    plot(time, pos_hip(:,1));
    legend('x','Location','NorthWest');
    title('Hip horizontal position')
    xlabel('Time [s]')
    ylabel('Distance [m]')
    subplot(2,1,2);
    plot(time, pos_hip(:,2));
    legend('z','Location','NorthWest');
    title('Hip vertical position')
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