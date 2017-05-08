function resetFcn()

global ser;
inputs = {
    {'7E' 'FF' '00' '00' '02' '04' '00' 'FF'}};

input = hex2dec(inputs{1});
fwrite(ser,input);
data = fread(ser,96,'uint8');

end

