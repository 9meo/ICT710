function updateAlarmFcn(obj,evt)
    
global alarmArray;
global alarmObj;
global ser;
global dir;
inputs = {'7E' 'FF' '00' '00' '02' '03' '00' 'FF'};
% clearCom
% s = serial(comPort,'BaudRate',9600);
% set(s,'Timeout',0.05);
% fopen(s)
input = hex2dec(inputs);
a=0;
for i=1:length(alarmArray)
    input(2) = alarmArray(i);
    fwrite(ser,input);
    data = fread(ser,8,'uint8');
%     disp(data);
    if data(7)==1
%         disp(data(3));
%         disp('aaaa');
        a=1;
    end
end

if a==1
    AlarmImg = imread(fullfile(dir,'AlarmImage.png'));
%     AlarmImg = imread(fullfile(dir,'TrainYM1.png'));
    imshow(AlarmImg, 'parent',alarmObj);
%     set(alarmObj,'Backgroundcolor','r');
else
    AlarmImg = imread(fullfile(dir,'NotAlarmImage.png'));
    imshow(AlarmImg, 'parent',alarmObj);
%     set(alarmObj,'BackgroundColor','black');
end

% fclose(s);
end


