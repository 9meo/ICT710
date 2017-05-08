function DiffEqTrainModel(handles)    %,handles2 - for simulating in GUI2
global time;        %% the OUTPUT
global u;
global v_val;
global x_val;
global v0;          %% the OUTPUT
global x0;          %% the OUTPUT
global tspan;
global t;
global Totaltime;
global distance;
global p;
global pwrVar;
global ip;
global uni;

handles.NextStation.String = getDestination(ip,uni);

%% Loop
% if time <= length(u)
    % Get u
%     uval=u(time);                                                                   % in N
    uval = pwrVar*10000 + 4000;
%     disp(uval);
    % Solve for v
    v=ode45(@(t,v)trainModel(t,v,uval),tspan,v0);
    vval=v.y;                                                                       % in m/s
    
    for i=1:length(vval)

                %limit velocity
            if vval(i) < 0.5/3.6
                vval(i) = 0;
            elseif vval(i) > 130/3.6
                vval(i) = 130/3.6;
            end

        % Solve for x
        x=ode45(@(t,y) trainModeldx(t,y,vval(i)),v.x,x0);
        xval=x.y;                                                                   % in m
        xvalDivLgth=xval/length(vval);                                              % in m

        % Concatenate x
        x_val=[x_val,xvalDivLgth];

        % Update x0
        x0=xval(end);                                                               %%% show this value as the latest value in UI
    end

    % Concatenate v
    v_val=[v_val,vval];

    % Update v0
    v0=vval(end);                                                                   %%% show this value as the latest value in UI

%     Totaltime=length(u);                                         % in s
%     timev=0:    (Totaltime)/(length(v_val)-1):    Totaltime;     % in s
%     timex=0:    (Totaltime)/(length(x_val)-1):    Totaltime;     % in s

    %optional
    %     distance = mean(v_val)*acc_time ;                    % in m
    distance = distance + v0;                   %accumulated distance
    fprintf('Distance===>%s\n',[num2str(round(distance))]);
    global roundupdate;
    roundupdate = roundupdate+1;
    
%     if mod(roundupdate,2)==0
%         disp('Update');
        updateDistance(ip,uni,round(distance));
        
%          roundupdate=0;
%     end
    %Display value in GUI handles
    set(handles.AccelerationVal,'string',num2str(pwrVar));
    set(handles.VelocityVal,'string',num2str(v0*3.6));

    %     %%Plot v
    %     figure(1),subplot(1,2,1),plot(timev,v_val);
    %     ylabel('velocity(m/s)')
    % 
    %     %hold off;
    %     xlabel('time(s)')
    % 
    %     %%Plot x
    %     figure(1),subplot(1,2,2),plot(timex,x_val);
    %     xlabel('time(s)')
    %     ylabel('distance(m)')

    StatusTrainDisplay(handles)                             %display status train in GUI
%     SimulationTrain(handles,handles2,time);      %display simulation results in another GUI

     time = time +1; 
% elseif time < length(u) + 5   && time > length(u)
%     disp('The train has arrived station');
%     time = time +1;
% elseif time == length(u) + 5
%     time = 1;    
%     p = p+1;
%  end