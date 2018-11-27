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
        pos_hip(j,:) = [x_h; z_h];
        vel_hip(j,:) = [dx_h; dz_h];
    end
    
    
    % plotting
%     plotQ(time, q*180/pi);
%     plotDQ(time, dq*180/pi);
    plotStepVect(time, step_vect);
%     plotQ_v2(time, q*180/pi, step_vect);
%     plotDQ_v2(time, dq*180/pi, step_vect);
    plotHipPos(time, pos_hip, step_vect, length_step);      % for now doesn't work...
    
end

function plotHipPos(time, pos_hip, step_vect, length_step)

    skip = 10; % plots only one in skip
    length_step = [0, length_step];

    % plots the position of the hip
    figure;
    for i=1: skip: length(time)
        current_step = step_vect(i);
        increment = length_step(current_step);
        pos_hip(i,1) = pos_hip(i,1) + increment;
        plot(pos_hip(i,1), pos_hip(i,2), '-o'); hold on;
    end
    title('hip position');
    xlabel('x');
    ylabel('z');
    
    figure;
    plot(time, pos_hip(:,1)); hold on;
    plot(time, pos_hip(:,2));
    legend('x', 'z');
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

function plotQ_v2(time, q, step_vect)

    % creates continuous q
    q1_v2 = zeros(length(time),1);
    q2_v2 = zeros(length(time),1);
    for i=1: length(time)
        if step_vect(i) == 1 || step_vect(i) == 3 || step_vect(i) == 5
            q1_v2(i) = q(i,1);
            q2_v2(i) = q(i,2);
        else
            q1_v2(i) = q(i,2);
            q2_v2(i) = q(i,1);
        end
    end
    
    % plot angles
    figure;
    subplot(3,1,1);
    plot(time, q1_v2);
    legend('q1 mod');
    xlabel('time');
    ylabel('angle [deg]');
    subplot(3,1,2);
    plot(time, q2_v2);
    legend('q2 mod');
    xlabel('time');
    ylabel('angle [deg]');
    subplot(3,1,3);
    plot(time, q(:,3));
    legend('q3');
    xlabel('time');
    ylabel('angle [deg]');
end

function plotDQ(time, dq)
   
    % plot angles
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

function plotDQ_v2(time, dq, step_vect)

    % creates continuous q
    dq1_v2 = zeros(length(time),1);
    dq2_v2 = zeros(length(time),1);
    for i=1: length(time)
        if step_vect(i) == 1 || step_vect(i) == 3 || step_vect(i) == 5
            dq1_v2(i) = dq(i,1);
            dq2_v2(i) = dq(i,2);
        else
            dq1_v2(i) = dq(i,2);
            dq2_v2(i) = dq(i,1);
        end
    end
    
    % plot angles
    figure;
    subplot(3,1,1);
    plot(time, dq1_v2);
    legend('dq1 mod');
    xlabel('time');
    ylabel('angular velocity [deg/s]');
    subplot(3,1,2);
    plot(time, dq2_v2);
    legend('dq2 mod');
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