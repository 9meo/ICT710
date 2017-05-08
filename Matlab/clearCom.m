allCom = instrfind;
for i = 1:length(allCom)
    if strcmp(allCom(i).Status,'open')
        fclose(allCom(i));
        
    end
    delete(allCom(i));
end