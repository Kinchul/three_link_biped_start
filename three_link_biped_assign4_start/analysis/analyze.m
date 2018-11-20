%% Read the README_ASSIGN4.pdf to see what results you need to analyze here. 
function sln = analyze(sln)

    % creates and set the time and y vectors
    time = [];
    y = [];
    for i=1: length(sln.Y)
        time = [time; sln.T{i}];
        y = [y; sln.Y{i}];
    end

    % assign the angles and angles derivatives
    q = y(:,1:3);
    dq = y(:,4:6);

    % plotting
    plotQ(time, q);
    plotDQ(time, dq);

end


function plotQ(time, q)
    % plot angles
    figure;
    subplot(3,1,1);
    plot(time, q(:,1));
    legend('q1');
    xlabel('time');
    ylabel('angle');
    subplot(3,1,2);
    plot(time, q(:,2));
    legend('q2');
    xlabel('time');
    ylabel('angle');
    subplot(3,1,3);
    plot(time, q(:,3));
    legend('q3');
    xlabel('time');
    ylabel('angle');
end

function plotDQ(time, dq)
    % plot angles
    figure;
    subplot(3,1,1);
    plot(time, dq(:,1));
    legend('dq1');
    xlabel('time');
    ylabel('angular velocity');
    subplot(3,1,2);
    plot(time, dq(:,2));
    legend('dq2');
    xlabel('time');
    ylabel('angular velocity');
    subplot(3,1,3);
    plot(time, dq(:,3));
    legend('dq3');
    xlabel('time');
    ylabel('angular velocity');
end