function UpdateValTest(handles)   %,handles2 - for simulating in GUI2
global t;
global v_val;
global x_val;
global a_val;
global v0;
global x0;
global tspan;
global time;
global uval;
global u;
global distance;
global Station;
global p;
global blinking;
%initialize value of Train model
tspan = linspace(0,1,100);
v0 = 0;
x0 = 0;
v_val = [];
x_val = [];
a_val = [];
uval = 0;
% u=[(0:0.1:1),0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,(0.8:-0.2:0)]*100000;
u = [(0:0.1:1),0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.8,0.7,0.7,0.7,0.6,0.6,0.5,0.5,0.3,0.3,0.3,0.3,0.3,0.3,0.2,0.2,0.2,0.1,0.1,0.1,0.1,0,0,0,0,0,0,0,-0.2,-0.2,-0.2,-0.2,-0.2,-0.2,-0.2,-0.3]*100000;
time = 1;
distance = 0;
p = 1;
blinking = 0;
Station{1} = 'Shibuya';
Station{2} = 'Harajuku';
Station{3} = 'Shinjuku';

t = timer;
% t.TimerFcn = @(~,evt) DisplayValTest(handles,handles2);

t.TimerFcn = @(~,evt) DiffEqTrainModel(handles);       %,handles2 - for simulating in GUI2
t.Period = 1;
t.ExecutionMode = 'fixedRate';
start(t)