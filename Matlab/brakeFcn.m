function brakeFcn(obj,evt)
input={'7E' '02' '00' '00' '02' '03' '00' 'FF'};
global pwrVar;
global ser;

fwrite(ser,hex2dec(input));
data = fread(ser,8,'uint8');
% if length(data) == 8
pwrVar=pwrVar-data(7);
% end
% disp(pwrVar);

%get break value;


end

