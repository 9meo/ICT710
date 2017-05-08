function updateTrainStatus(ip,trainRoute,DriverDoor,PassengerDoor,light1,light2,light3)
    url = strcat(ip,'/insertstatus_',trainRoute,'?');
    
    distanceurl = strcat('door_driver=',num2str(DriverDoor),'&door_passenger=',num2str(PassengerDoor),'&light_1=',num2str(light1),'&light_2=',num2str(light2),'&light_3=',num2str(light3));
    
    url = strcat(url,distanceurl);
    try
        webread(url);
    catch ME
    end
end
