function setID( )
global scanIDArray;
global allIDArray;

global ser;
allIDArray=[];
inputs = {'7E' '21' '00' '01' '02' '01' '01' 'FF'};
% clearCom
% s = serial(comPort,'BaudRate',9600);
% set(s,'Timeout',0.05);
% fopen(s);

for i=1:length(scanIDArray)
    input = hex2dec(inputs);
    input(2) = scanIDArray(i);
    input(7) = i;
%     fprintf('source:%d , new id:%d\n',[input(2),input(7)]);
    fwrite(ser,input);
    allIDArray = [allIDArray,i];
    data = dec2hex(fread(ser,8,'uint8'));
end
end

