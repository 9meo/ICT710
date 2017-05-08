function destination = getDestination(ip,trainRoute)
    url = strcat(ip,'/getlocation_',trainRoute,'?');
    %distanceurl = strcat('train_no=',num2str(trainRoute));
    %url = strcat(url,distanceurl);
    
    try
        data = loadjson(webread(url));
        
        destination = data.next_station;
    catch ME        
    end
end