% Read the README_ASSIGN4.pdf to see what results you need to analyze here. 
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
        
        % final step time
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
    
    % Compute Inertia
    [m1, ~, m3, l1, ~, l3, ~] = set_parameters();  
    inertia_torso = m3*l3^2/4;
    inertia_legs = m1*l1^2/4;
    
    % Compute CoT
    cot = zeros(number_time_step,1);
    Etot = 0;
    lastEkin = 0;
    lastEpot = (pos_hip(j,2) - (l1/2) * cos(q(j,1))) * m1 * 9.81 + (pos_hip(j,2) - (l1/2) * cos(q(j,2))) * m1 * 9.81 + (pos_hip(j,2) + (l3/2) * cos(q(j,3))) * m3 * 9.81;
    for j=2: number_time_step      
        Ekin = dq(j,1)^2 * inertia_legs / 2 + dq(j,2)^2 * inertia_legs / 2 + dq(j,3)^2 * inertia_torso / 2;
        Epot = (pos_hip(j,2) - (l1/2) * cos(q(j,1))) * m1 * 9.81 + (pos_hip(j,2) - (l1/2) * cos(q(j,2))) * m1 * 9.81 + (pos_hip(j,2) + (l3/2) * cos(q(j,3))) * m3 * 9.81;
        dEkin = Ekin-lastEkin;
        dEpot = Epot-lastEpot;
        
        Etot = Etot + abs(dEkin-dEpot);
        lastEkin = Ekin;
        lastEpot = Epot;
    
        cot(j) = Etot / ((m1+m1+m3) * 9.81 * pos_hip(j,1));
    end
    
    % main plotting    
    plotQ(time, q_v2*180/pi);
    plotSpeed(time, sln.TE{1}, vel_hip, pos_hip);
    plotStepLength(step_vect, length_step);
    plotStepFrequency(time, step_vect, step_end_time);
    plot_u();
    plotQvsDQ(q_v2*180/pi, dq_v2*180/pi);
    plotCot(cot, step_vect);
    
    % additional plots
    plotStepVect(time, step_vect);
    plotDQ(time, dq_v2*180/pi);
    plotHipPos(time, pos_hip);

    % printf of general infos
    printResults(cot(end),pos_hip(end,1)/time(end));

end


function plotCot(cot, step_vect)
    
    cot_step = zeros(length(step_vect),1);
    for i=1: length(cot_step)
        cot_step(i) = cot(length(cot)/length(step_vect)*i);
    end

    % plot step length vs step number
    figure;
    plot(step_vect, cot_step); grid on;
    xlabel('Step number');
    ylabel('CoT');
    title('Cost of Transport');
end

function plot_u()
    
    % get the values from global variable
    global u_store
    
    % plot of u
    figure;
    subplot(2,1,1);
    plot(u_store(:,1), u_store(:,2));
    xlabel('Time [s]');
    ylabel('u_1 [Nm]');
    title('First actuator');
    subplot(2,1,2);
    plot(u_store(:,1), u_store(:,3));
    xlabel('Time [s]');
    ylabel('u_2 [Nm]');
    title('Second actuator');
end

function printResults(cot,speed)
    
    global desired_speed    
    global u_store
    error = abs(desired_speed-speed)/desired_speed*100;

    % display results in command window
    fprintf('\n');
    fprintf('Cost of transport      :   %.2f\n',cot);
    fprintf('Target speed (m/s)     :   %.1f\n',desired_speed);
    fprintf('Average speed (m/s)    :   %.2f\n', speed);
    fprintf('Speed error            :   %.2f%%\n',error);
    fprintf('Max torque on u1 (Nm)  :   %.1f\n',max(abs(u_store(:,2))));
    fprintf('Max torque on u2 (Nm)  :   %.1f\n',max(abs(u_store(:,3))));
    fprintf('\n');
    
end

function plotQvsDQ(q, dq)
    
    % plot of q against dq
    figure;
    subplot(3,1,1);
    plot(q(:,1), dq(:,1));
    xlabel('q [deg]');
    ylabel('dq [deg/s]');
    title('First leg');
    subplot(3,1,2);
    plot(q(:,2), dq(:,2));
    xlabel('q [deg]');
    ylabel('dq [deg/s]');
    title('Second leg');
    subplot(3,1,3);
    plot(q(:,3), dq(:,3));
    xlabel('q [deg]');
    ylabel('dq [deg/s]');
    title('Torso');
    
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

function plotHipPos(time, pos_hip)
   
    figure;
    subplot(2,1,1);
    plot(time, pos_hip(:,1));
    title('Hip horizontal position')
    xlabel('Time [s]')
    ylabel('Distance [m]')
    subplot(2,1,2);
    plot(time, pos_hip(:,2));
    title('Hip vertical position')
    xlabel('Time [s]')
    ylabel('Distance [m]')
    
end

function plotSpeed(time, time_start, vel_hip, pos_hip)
   
    mean_velocity = round(pos_hip(end,1)/time(end),2);

    figure;
    plot(time, vel_hip(:,1)); hold on;
    plot(time, vel_hip(:,2));
    plot(time(time>time_start), ...
         pos_hip(time>time_start,1)./time(time>time_start),'LineWidth',3);
    legend('Horizontal velocity', 'Vertical velocity',['Mean velocity: ',num2str(mean_velocity),' m/s'], 'Location','SouthEast');
    title('Hip velocity')
    xlabel('Time [s]')
    ylabel('Speed [m/s]')
        
end

function plotQ(time, q)
  
    % plot angles
    figure;
    subplot(3,1,1);
    plot(time, q(:,1));
    title('q_1');
    xlabel('Time [s]');
    ylabel('Angle [deg]');
    subplot(3,1,2);
    plot(time, q(:,2));
    title('q_2');
    xlabel('Time [s]');
    ylabel('Angle [deg]');
    subplot(3,1,3);
    plot(time, q(:,3));
    title('q_3');
    xlabel('Time [s]');
    ylabel('Angle [deg]');
end

function plotDQ(time, dq)
   
    % plot angular velocity
    figure;
    subplot(3,1,1);
    plot(time, dq(:,1));
    title('dq_1');
    xlabel('Time [s]');
    ylabel('Angle rate [deg/s]');
    subplot(3,1,2);
    plot(time, dq(:,2));
    title('dq_2');
    xlabel('Time [s]');
    ylabel('Angle rate [deg/s]');
    subplot(3,1,3);
    plot(time, dq(:,3));
    title('dq_3');
    xlabel('Time [s]');
    ylabel('Angle rate [deg/s]');
end

function plotStepVect(time, step_vect)
    
    figure;
    plot(time, step_vect);
    title('Step number');
    xlabel('Time [s]');
    ylabel('Step number');
end


