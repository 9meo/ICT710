function destination = getOrigin(ip,trainRoute)
    url = strcat(ip,'/getlocation_',trainRoute,'?');
    distanceurl = num2str(trainRoute);
    url = strcat(url,distanceurl);
    try
        data = loadjson(webread(url));
        destination = data.start_station;
    catch ME        
    end
end