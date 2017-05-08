function lightingFcn(arg)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
global ser;
if nargin < 1
    arg =  0
end
global lightArray;
inputs = {
    {'7E' 'FF' '00' '00' '02' '03' '01' 'FF'}};
% clearCom
% s = serial('COM4','BaudRate',9600);
% set(s,'Timeout',0.05);
% fopen(s)
input = hex2dec(inputs{1});
for i=1:length(lightArray)
    input(2) = lightArray(i);
    input(7) = arg;
    fwrite(ser,input);
    data = dec2hex(fread(ser,8,'uint8'));
end
% fclose(s);
end

