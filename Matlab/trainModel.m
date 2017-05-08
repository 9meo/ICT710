function dy = trainModel(t,y,u)
% a0 = 1;
% a1 = 1;
% b0 = 1;
% dy = (b0*u -a0*y)/a1; 

% % mass of each boogy 38.9 t = 35289.49 kg
m = 3*(35289.49);   % around 105,870 in kg

a0=m/12; %need to assume this value
a1=m;
b0=3;

dy=(b0*u-a0*y)/a1;

