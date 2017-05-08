function askFunctionFcn()
global allIDArray;
inputs ={'7E' '01' '00' '00' '02' '02' '00' 'FF'};
global alarmArray;
global lightArray;
global doorArray;
global airArray;
global ser;
doorArray=[];
airArray=[];
alarmArray=[];
lightArray=[];

% clearCom
% s = serial(comPort,'BaudRate',9600);
% set(s,'Timeout',0.05);
% fopen(s);

for i=1:length(allIDArray)
    input = hex2dec(inputs);
    input(2) = allIDArray(i);
    fwrite(ser,input);
    train_f = fread(ser,8,'uint8');
%     disp(hex2dec(inputs{i}))
%     disp(data(7))
%     fprintf('function : %x%x\n',[train_f(6),train_f(7)]);
    if (train_f(6)==0 && train_f(7)==4) || (train_f(6)==4 && train_f(7)==0)
        alarmArray = [alarmArray, train_f(3)];
    elseif (train_f(6)==1 && train_f(7)==0)
        lightArray = [lightArray, train_f(3)];
    elseif (train_f(6)==2 && train_f(7)==0)
        airArray = [airArray, train_f(3)];
    elseif (train_f(6)==3 && train_f(7)==0)
        doorArray = [doorArray, train_f(3)];
    end
end
% fclose(s);

end

