function varargout = angle_gui(varargin)
% ANGLE_GUI MATLAB code for angle_gui.fig
%      ANGLE_GUI, by itself, creates a new ANGLE_GUI or raises the existing
%      singleton*.
%
%      H = ANGLE_GUI returns the handle to a new ANGLE_GUI or the handle to
%      the existing singleton*.
%
%      ANGLE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANGLE_GUI.M with the given input arguments.
%
%      ANGLE_GUI('Property','Value',...) creates a new ANGLE_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before angle_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to angle_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help angle_gui

% Last Modified by GUIDE v2.5 04-Jan-2016 20:08:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @angle_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @angle_gui_OutputFcn, ...
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

% --- Executes just before angle_gui is made visible.
function angle_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to angle_gui (see VARARGIN)

% Choose default command line output for angle_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes angle_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = angle_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x1_Callback(hObject, eventdata, handles)
% hObject    handle to x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x1 as text
%        str2double(get(hObject,'String')) returns contents of x1 as a double
x1 = str2double(get(hObject, 'String'));
if isnan(x1)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new x1 value
handles.metricdata.x1 =x1;
guidata(hObject,handles);


function x2_Callback(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2 as text
%        str2double(get(hObject,'String')) returns contents of x2 as a double
x2 = str2double(get(hObject, 'String'));
if isnan(x2)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new x1 value
handles.metricdata.x2 =x2;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x3_Callback(hObject, eventdata, handles)
% hObject    handle to x3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x3 as text
%        str2double(get(hObject,'String')) returns contents of x3 as a double
x3 = str2double(get(hObject, 'String'));
if isnan(x3)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new x3 value
handles.metricdata.x3 =x3;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function x3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x4_Callback(hObject, eventdata, handles)
% hObject    handle to x4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x4 as text
%        str2double(get(hObject,'String')) returns contents of x4 as a double
x4 = str2double(get(hObject, 'String'));
guidata(hObject,handles)
if isnan(x4)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% Save the new x4 value
handles.metricdata.x4 =x4;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function x4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

handles.metricdata.x1 = 0;
handles.metricdata.x2  = 0;
handles.metricdata.x3  = 0;
handles.metricdata.x4  = 0;

set(handles.x1, 'String', handles.metricdata.x1);
set(handles.x2,  'String', handles.metricdata.x2);
set(handles.x3,  'String', handles.metricdata.x3);
set(handles.x4,  'String', handles.metricdata.x4);
set(handles.angle, 'String', 0);

%set(handles.unitgroup, 'SelectedObject', handles.english);


% Update handles structure
guidata(handles.figure1, handles);






function reset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=handles.metricdata.x1;
x2=handles.metricdata.x2;
x3=handles.metricdata.x3;
x4=handles.metricdata.x4;
X=[x1, x2, x3, x4]
y=fft(X);
[p,w]= pmusic(y,1);
plot(w,p);
[temp,iMax]=max(p);
angle=mod(w(iMax)+(3*pi)/4, 2*pi) *180/pi;
%angle=w(iMax);
set(handles.angle, 'String', angle);