function light = getTraffic(ip,trainRoute)
    url = strcat(ip,'/get_traffic_',trainRoute,'?');
    %distanceurl = strcat('train_no=',num2str(trainRoute));
    %url = strcat(url,distanceurl);
    try
        data = loadjson(webread(url));
        light = data.light;
    catch ME
        light = 'red';
    end
end