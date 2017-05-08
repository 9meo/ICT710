function varargout = TrainUI(varargin)
% TRAINUI MATLAB code for TrainUI.fig
%      TRAINUI, by itself, creates a new TRAINUI or raises the existing
%      singleton*.
%
%      H = TRAINUI returns the handle to a new TRAINUI or the handle to
%      the existing singleton*.
%
%      TRAINUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINUI.M with the given input arguments.
%
%      TRAINUI('Property','Value',...) creates a new TRAINUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrainUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrainUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrainUI

% Last Modified by GUIDE v2.5 05-May-2017 07:50:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrainUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrainUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TrainUI is made visible.
function TrainUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrainUI (see VARARGIN)

% Choose default command line output for TrainUI

handles.output = hObject;

global dir;
dir='GUI_image';
global ip;
global alarmObj;
global comPort;
global ser;
global roundupdate;
global uni;

[keynames,values]=textread('config.txt','%s=%s');
myStruct = cell2struct(values, keynames);

% uni = 'siit';
uni = myStruct.uni;
roundupdate=0;
clearCom;
% comPort='COM4';
comPort=myStruct.comport;

% ip = 'http://192.168.137.90:8080';
% ip = 'http://sansarn.com/final_project/';
ip=myStruct.ip;

%ip = 'https://sw-final-project.appspot.com';
ser = serial(comPort,'BaudRate',9600);
set(ser,'Timeout',0.05);
fopen(ser);
talarm= timer;
talarm.Period =1;
talarm.TimerFcn = @updateAlarmFcn;
talarm.ExecutionMode = 'fixedRate';
handles.talarm = talarm;

tpower = timer;
tpower.Period =1;
tpower.TimerFcn = @powerFcn;
tpower.ExecutionMode = 'fixedRate';
handles.tpower = tpower;

tbrake = timer;
tbrake.Period =1;
tbrake.TimerFcn = @brakeFcn;
tbrake.ExecutionMode = 'fixedRate';
handles.tbrake = tbrake;
alarmObj = handles.AlarmImage;

global Lamp1Status;
global Door1Status;
Door1Status='0';
Lamp1Status='0';
updateTrainStatus(ip,uni,Door1Status,Door1Status,Lamp1Status,Lamp1Status,Lamp1Status);
updateDistance(ip,uni,0);

%BG Image
if strcmp('ku',uni);
    BGImage = imread(fullfile(dir,'YAMANOTELINE.jpg'));     %For KU
    trainimg1 = imread(fullfile(dir,'TrainYM1.png'));       %For KU 
    set(handles.TrainName,'string','Train : Yamanote Line');   
else
	BGImage = imread(fullfile(dir,'Narita.jpg'));              %For SIIT
    trainimg1 = imread(fullfile(dir,'TrainNR1.png'));          % For SIIT
    set(handles.TrainName,'string','Train : Narita Line');   
end
axes(handles.BGImage); 
imshow(BGImage); 

%Train Name 

axes(handles.Train1Image); 
imshow(trainimg1); 
TrafficLight = imread(fullfile(dir,'TrafficLightImage.png'));
axes(handles.TrafficLightImage); 
imshow(TrafficLight);

%defalt text at buttons
set(handles.LampButton,'string','Lamp','enable','on','BackgroundColor',[0.94 0.94 0.94]);
set(handles.LampStatus,'string','OFF','enable','on','BackgroundColor',[0.86 0.86 0.86]);
set(handles.AirButton,'string','Air','enable','on','BackgroundColor',[0.94 0.94 0.94]);
set(handles.AirStatus,'string','OFF','enable','on','BackgroundColor',[0.86 0.86 0.86]);
set(handles.DoorButton,'string','Door','BackgroundColor',[0.94 0.94 0.94]);
set(handles.DoorStatus,'string','Closed','enable','on','BackgroundColor',[0.86 0.86 0.86]);
%defalt start toggle button
set(handles.StartButton,'string',' Start','enable','on','BackgroundColor',[0.94 0.94 0.94]);
%defalt alarm 
AlarmImage = imread(fullfile(dir,'NotAlarmImage.png'));
axes(handles.AlarmImage); 
imshow(AlarmImage);

%defalt rail traffic light
set(handles.TrafficLight1,'BackgroundColor','black');
set(handles.TrafficLight2,'BackgroundColor','black');
set(handles.TrafficLight3,'BackgroundColor','black');
set(handles.TrafficLight4,'BackgroundColor','red');

global StartStatus;
StartStatus = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrainUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrainUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StartButton
global StartStatus;
global t;
global TestUpdate;    
TestUpdate = 0;

StartStatus = get(hObject,'Value');
if StartStatus == 1
    scanFcn;
    %         pause(0.1);
    %         handles.scnTxt.Enable = 'on';
    setID;
    %         pause(0.1);
    %         handles.setIDTxt.Enable = 'on';
    askFunctionFcn;
    %         pause(0.3);
    start(handles.talarm);
    start(handles.tpower);
    start(handles.tbrake);
    disp('Narita Line');

    UpdateValTest(handles);   
      
    set(handles.StartButton,'string',' Stop','enable','on','BackgroundColor','green');
else
    resetFcn();
    stop(handles.talarm);
    stop(handles.tpower);
    stop(handles.tbrake);
    stop(t);
    set(handles.StartButton,'string',' Start','enable','on','BackgroundColor',[0.94 0.94 0.94]);
end


% --- Executes on button press in LampButton.
function LampButton_Callback(hObject, eventdata, handles)
% hObject    handle to LampButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LampButton
global StartStatus;
global Lamp1Status;
global Door1Status;
global ip;
global uni;
Lamp1Status = get(hObject,'Value'); 
updateTrainStatus(ip,uni,Door1Status,Door1Status,Lamp1Status,Lamp1Status,Lamp1Status);
if StartStatus == 1
    if Lamp1Status == 1 
        lightingFcn(1);
        set(handles.LampButton,'string',' Lamp','enable','on','BackgroundColor','green');
        set(handles.LampStatus,'string',' ON','BackgroundColor','green');  
    elseif Lamp1Status == 0 
        lightingFcn(0);
        set(handles.LampButton,'string','Lamp','enable','on','BackgroundColor',[0.94 0.94 0.94]);
        set(handles.LampStatus,'string','OFF','BackgroundColor',[0.86 0.86 0.86]);  
    end
else
    msgbox(sprintf('Please choose train and press start'),'ERROR','ERROR');
end

% --- Executes on button press in AirButton.
function AirButton_Callback(hObject, eventdata, handles)
% hObject    handle to AirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AirButton
global StartStatus;
Air1Status = get(hObject,'Value'); 

if StartStatus == 1
    if Air1Status == 1
        airFcn(1);
        set(handles.AirButton,'string',' Air','enable','on','BackgroundColor','green');
        set(handles.AirStatus,'string','ON','BackgroundColor','green');  
    elseif Air1Status == 0 
        airFcn(0);
        set(handles.AirButton,'string','Air','enable','on','BackgroundColor',[0.94 0.94 0.94]);
        set(handles.AirStatus,'string','OFF','BackgroundColor',[0.86 0.86 0.86]);
    end
else
    msgbox(sprintf('Please choose train and press start'),'ERROR','ERROR');
end

% --- Executes on button press in DoorButton.
function DoorButton_Callback(hObject, eventdata, handles)
% hObject    handle to DoorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global StartStatus;
% global Lamp1Status;
% global Door1Status;
% global ip;
% global uni;
% 
% % Door1Status = get(hObject,'Value'); 
% updateTrainStatus(ip,uni,Door1Status,Door1Status,Lamp1Status,Lamp1Status,Lamp1Status);
% 
% if StartStatus == 1
%     if Door1Status == 1 
%         doorFcn(0);
%         set(handles.Door1Button,'string',' Door Open','enable','on','BackgroundColor','green');
%         set(handles.Door2Button,'string','Open','enable','on','BackgroundColor','green');
%     elseif Door1Status == 0 
%         doorFcn(1);
%         set(handles.Door1Button,'string','Door Closed','enable','on','BackgroundColor',[0.94 0.94 0.94]);
%         set(handles.Door2Button,'string','Closed','enable','on','BackgroundColor',[0.86 0.86 0.86]);
%     end
% else
    msgbox(sprintf('Door cannot be opened at this time'),'ERROR','ERROR');
% end


% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%defalt text at buttons
global dir;
set(handles.LampButton,'string','Lamp','enable','on','BackgroundColor',[0.94 0.94 0.94]);
set(handles.LampStatus,'string','OFF','enable','on','BackgroundColor',[0.86 0.86 0.86]);
set(handles.AirButton,'string','Air','enable','on','BackgroundColor',[0.94 0.94 0.94]);
set(handles.AirStatus,'string','OFF','enable','on','BackgroundColor',[0.86 0.86 0.86]);
set(handles.DoorButton,'string','Door','BackgroundColor',[0.94 0.94 0.94]);
set(handles.DoorStatus,'string','Closed','enable','on','BackgroundColor',[0.86 0.86 0.86]);
%defalt start toggle button
set(handles.StartButton,'string',' Start','enable','on','BackgroundColor',[0.94 0.94 0.94]);
%defalt alarm 
AlarmImage = imread(fullfile(dir,'NotAlarmImage.png'));
axes(handles.AlarmImage); 
imshow(AlarmImage);
%defalt status 
set(handles.Status,'BackgroundColor','red');
