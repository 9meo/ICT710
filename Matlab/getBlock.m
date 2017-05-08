function block = getBlock(ip,trainRoute)
    url = strcat(ip,'/getlocation_',trainRoute,'?');
%    distanceurl = strcat('train_no=',num2str(trainRoute));
    
%     url = strcat(url,distanceurl);
%     disp(url);
try
    data = loadjson(webread(url));
    block = data.distance_track;
    block = round(block);
catch ME
    block = 0;
end
%     block = data.distance_track - data.distance_matlab;
    
end