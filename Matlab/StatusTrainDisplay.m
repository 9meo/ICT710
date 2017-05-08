function StatusTrainDisplay(handles)
global u;
global time;
global distance;
global v0;
global p;
global Station;
global ip;
global blinking;
global Door1Status;
global Lamp1Status;
global uni;
% global remainBlocks;
%Tracking status 
set(handles.Status,'BackgroundColor','green');
% set(handles.Track2,'BackgroundColor','green');
% set(handles.Track3,'BackgroundColor','green');

%Lamp/Air/Door status
% clc;
% disp(sprintf('TestUpdate : %d \n',time));
% disp(sprintf('Lamp Status = %s | %s | %s \n',handles.Lamp1Button.String,handles.Lamp2Button.String,handles.Lamp3Button.String));
% disp(sprintf('Air Status     = %s | %s | %s \n',handles.Air1Button.String,handles.Air2Button.String,handles.Air3Button.String));
% disp(sprintf('Door Status  = %s | %s | %s \n',handles.Door1Button.String,handles.PassengerDoorButton.String,handles.PassengerDoorButton.String));
% disp(sprintf('=> Accumulated distance : %d m',round(distance)));
% disp(sprintf('=> Distance in 1 sec. = %d',round(v0)));
% disp(sprintf('=> Acceleration level : %d || velocity = %d km/hr ',u(time)/10000,round(v0*3.6)));

     remainBlocks = getBlock(ip,uni);

% remainBlocks=0
    
    
    set(handles.RemainBlocks,'string',num2str(remainBlocks));    
    %set(handles.NextStation,'string',Station{p+1});
    light = getTraffic(ip,uni);
    
%yellow2
if strcmp(light,'yellow2')==1;
    set(handles.TrafficLight1,'BackgroundColor','yellow');
    set(handles.TrafficLight2,'BackgroundColor','black');
    set(handles.TrafficLight3,'BackgroundColor','yellow');
    set(handles.TrafficLight4,'BackgroundColor','black');  
%yellow1    
elseif strcmp(light,'yellow1')==1
    set(handles.TrafficLight1,'BackgroundColor','black');
    set(handles.TrafficLight2,'BackgroundColor','black');
    set(handles.TrafficLight3,'BackgroundColor','yellow');
    set(handles.TrafficLight4,'BackgroundColor','black'); 
%red
elseif strcmp(light,'red')==1;
    
    %StationSound = audioread('StaionSound1.wav');
    %player = audioplayer(StationSound,22050);
    
    set(handles.DoorButton,'string',' Door','BackgroundColor','green');
    set(handles.DoorStatus,'string','Open','BackgroundColor','green');
    doorFcn(0);    
    updateTrainStatus(ip,uni,Door1Status,Door1Status,Lamp1Status,Lamp1Status,Lamp1Status);
    set(handles.TrafficLight1,'BackgroundColor','black');
    set(handles.TrafficLight2,'BackgroundColor','black');
    set(handles.TrafficLight3,'BackgroundColor','black');
    set(handles.TrafficLight4,'BackgroundColor','red'); 
%green
elseif strcmp(light,'green')==1  
    set(handles.DoorButton,'string','Door','BackgroundColor','red');
    set(handles.DoorStatus,'string','Closed','BackgroundColor','red');
    doorFcn(1);
    updateTrainStatus(ip,uni,Door1Status,Door1Status,Lamp1Status,Lamp1Status,Lamp1Status);
    set(handles.TrafficLight1,'BackgroundColor','black');
    set(handles.TrafficLight2,'BackgroundColor','black');
    set(handles.TrafficLight3,'BackgroundColor','black');
    set(handles.TrafficLight4,'BackgroundColor','green'); 
%binking Light
elseif strcmp(light,'blink')==1
    if blinking == 0
        set(handles.TrafficLight1,'BackgroundColor','black');
        set(handles.TrafficLight2,'BackgroundColor','black');
        set(handles.TrafficLight3,'BackgroundColor','black');
        set(handles.TrafficLight4,'BackgroundColor','black'); 
        blinking = 1;
    elseif blinking == 1
        set(handles.TrafficLight1,'BackgroundColor','black');
        set(handles.TrafficLight2,'BackgroundColor','black');
        set(handles.TrafficLight3,'BackgroundColor','black');
        set(handles.TrafficLight4,'BackgroundColor','red'); 
        blinking = 0;
    end
end   
% if time > 18   
%     if remainBlocks < 300 && remainBlocks >= 200
%         set(handles.TrafficLight1,'BackgroundColor','yellow');
%         set(handles.TrafficLight2,'BackgroundColor','black');
%         set(handles.TrafficLight3,'BackgroundColor','yellow');
%         set(handles.TrafficLight4,'BackgroundColor','black');
%     elseif remainBlocks < 200 && remainBlocks >= 50
%         set(handles.TrafficLight1,'BackgroundColor','black');
%         set(handles.TrafficLight2,'BackgroundColor','black');
%         set(handles.TrafficLight3,'BackgroundColor','yellow');
%         set(handles.TrafficLight4,'BackgroundColor','black')
%     elseif remainBlocks < 50
%         set(handles.TrafficLight1,'BackgroundColor','black');
%         set(handles.TrafficLight2,'BackgroundColor','black');
%         set(handles.TrafficLight3,'BackgroundColor','black');
%         set(handles.TrafficLight4,'BackgroundColor','red');
%     else
%         set(handles.TrafficLight1,'BackgroundColor','black');
%         set(handles.TrafficLight2,'BackgroundColor','green');
%         set(handles.TrafficLight3,'BackgroundColor','black');
%         set(handles.TrafficLight4,'BackgroundColor','black');
%     end
% elseif time > 15 && time <= 18
%         set(handles.TrafficLight1,'BackgroundColor','black');
%         set(handles.TrafficLight2,'BackgroundColor','green');
%         set(handles.TrafficLight3,'BackgroundColor','black');
%         set(handles.TrafficLight4,'BackgroundColor','black');
% elseif time <= 15
%     if mod(time,2) == 0  
%         set(handles.TrafficLight1,'BackgroundColor','black');
%         set(handles.TrafficLight2,'BackgroundColor','black');
%         set(handles.TrafficLight3,'BackgroundColor','black');
%         set(handles.TrafficLight4,'BackgroundColor','red');
%     else
%         set(handles.TrafficLight1,'BackgroundColor','black');
%         set(handles.TrafficLight2,'BackgroundColor','black');
%         set(handles.TrafficLight3,'BackgroundColor','black');
%         set(handles.TrafficLight4,'BackgroundColor','black');
%     end
% end
    

    