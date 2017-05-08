function powerFcn(obj,evt)
input={'7E' '01' '00' '00' '02' '03' '00' 'FF'};
global pwrVar;
global ser;

fwrite(ser,hex2dec(input));
data = fread(ser,8,'uint8');
% if length(data) == 8
   pwrVar=data(7);
% fprintf('power=======> %5d',[pwrVar]);
% end
% disp(pwrVar);

%get break value;


end

