function scanFcn( )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
global scanIDArray;
global ser;
scanIDArray=[];
inputs = {
    {'7E' 'FF' '00' '00' '02' '00' '00' 'FF'}};
% clearCom
% s = serial(comPort,'BaudRate',9600);
% set(s,'Timeout',0.05);
% fopen(s);
input = hex2dec(inputs{1});
fwrite(ser,input);
data = fread(ser,96,'uint8');

for i=0:11
    offset = (8*i)+1;
    frame = data(offset:offset+7);
    scanIDArray = [scanIDArray, frame(3)];
    
end
% fprint('id:%d\n',[data(3)]);
% fclose(s);
end

