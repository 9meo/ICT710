function updateDistance(ip,trainRoute,distance)
    url = strcat(ip,'/insertdistance_',trainRoute,'?');
%     distanceurl = strcat('train_no=',num2str(trainRoute-1),'&','distance=',num2str(distance));
    distanceurl = strcat('distance=',num2str(distance));
    url = strcat(url,distanceurl);
    try
        webread(url);
    catch ME
    end
end
