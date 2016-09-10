function varargout = phasediscgui(varargin)
% PHASEDISCGUI MATLAB code for phasediscgui.fig
%      PHASEDISCGUI, by itself, creates a new PHASEDISCGUI or raises the existing
%      singleton*.
%
%      H = PHASEDISCGUI returns the handle to a new PHASEDISCGUI or the handle to
%      the existing singleton*.
%
%      PHASEDISCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHASEDISCGUI.M with the given input arguments.
%
%      PHASEDISCGUI('Property','Value',...) creates a new PHASEDISCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before phasediscgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to phasediscgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help phasediscgui

% Last Modified by GUIDE v2.5 10-Sep-2016 08:42:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @phasediscgui_OpeningFcn, ...
                   'gui_OutputFcn',  @phasediscgui_OutputFcn, ...
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


% --- Executes just before phasediscgui is made visible.
function phasediscgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to phasediscgui (see VARARGIN)

% Choose default command line output for phasediscgui
handles.output = hObject;

% Add user gui state data that will be referenced by call backs
handles.disc_state = struct('fs', [], ...
                            'freq', [], ...
                            'tdur', [], ...
                            'segs1', [], ...
                            'segs2', []);
handles.signal1_time = [];
handles.signal2_time = [];
handles.time_array = [];
handles.signal1_freq = [];
handles.signal1_freqmag = [];
handles.signal1_freqphase = [];
handles.signal2_freq = [];
handles.signal2_freqmag = [];
handles.signal2_freqphase = [];
handles.freq_array = [];

% Initialize GUI elements and other data
handles.disc_state.fs = 44100;
handles.disc_state.freq = 500;
handles.disc_state.tdur = 5;
handles.disc_state.segs1 = 1;
handles.disc_state.segs2 = 1;

handles.textin_tdur.String = handles.disc_state.tdur;
handles.textin_freq.String = handles.disc_state.freq;
handles.textin_fs.String = handles.disc_state.fs
handles.textin_segs1.String = handles.disc_state.segs1;
handles.textin_segs2.String = handles.disc_state.segs2;




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes phasediscgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = phasediscgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%% Collect and store user selected parameters 
function textin_tdur_Callback(hObject, eventdata, handles)
    input = str2double(handles.textin_tdur.String);
    val = 0;
    
    if(isnan(input))
       val = handles.disc_state.tdur;
    elseif(input > 10)
        val = 10; 
    elseif(input < 0)
        val = 0;
    else
        val = input;
    end
    
    handles.textin_tdur.String = val;
    handles.disc_state.tdur = val;
    guidata(hObject, handles);
    
function textin_freq_Callback(hObject, eventdata, handles)
    input = str2double(handles.textin_freq.String);
    fs = str2double(handles.textin_fs.String);
    val = 0;
    
    if(isnan(input))
       val = handles.disc_state.freq;
    elseif(input > (fs/2))
        val = (fs/2); 
    elseif(input < 0)
        val = 0;
    else
        val = input;
    end
    
    handles.textin_freq.String = val;
    handles.disc_state.freq = val;
    guidata(hObject, handles);

function textin_fs_Callback(hObject, eventdata, handles)
    input = str2double(handles.textin_fs.String);
    input = round(input);
    val = 0;
    
    if(isnan(input))
       val = handles.disc_state.fs;
    elseif(input > 44100)
        val = 44100; 
    elseif(input < 1000)
        val = 1000;
    else
        val = input;
    end
    
    handles.textin_fs.String = val;
    handles.disc_state.fs = val;
    guidata(hObject, handles);
    
    % Update frequency parameter which is dependent on the sample rate
    textin_freq_Callback(hObject, eventdata, handles);
    
function textin_segs1_Callback(hObject, eventdata, handles)
    input = str2double(handles.textin_segs1.String);
    input = round(input);
    fs = handles.disc_state.fs;
    tdur = handles.disc_state.tdur;
    
    val = 0;    
    if(isnan(input))
       val = handles.disc_state.segs1;
    elseif(input > (fs*tdur-1))
        val = (fs*tdur-1); 
    elseif(input < 1)
        val = 1;
    else
        val = input;
    end
    
    handles.textin_segs1.String = val;
    handles.disc_state.segs1 = val;
    guidata(hObject, handles);

function textin_segs2_Callback(hObject, eventdata, handles)
    input = str2double(handles.textin_segs2.String);
    input = round(input);
    fs = handles.disc_state.fs;
    tdur = handles.disc_state.tdur;
    
    val = 0;    
    if(isnan(input))
       val = handles.disc_state.segs2;
    elseif(input > (fs*tdur-1))
        val = (fs*tdur-1); 
    elseif(input < 1)
        val = 1;
    else
        val = input;
    end
    
    handles.textin_segs2.String = val;
    handles.disc_state.segs2 = val;
    guidata(hObject, handles);

% --- Executes on button press in pb_calc.
function pb_calc_Callback(hObject, eventdata, handles)
tdur = handles.disc_state.tdur;
fs = handles.disc_state.fs;
tstep = 1/fs;
fstep = 1/tdur;

% genereate time domain signals
handles.signal1_time = buildSignal(handles.disc_state.fs, handles.disc_state.tdur, handles.disc_state.freq, handles.disc_state.segs1, window_type.Rect);
handles.signal2_time = buildSignal(handles.disc_state.fs, handles.disc_state.tdur, handles.disc_state.freq, handles.disc_state.segs2, window_type.Rect);
handles.time_array = 0:tstep:tdur;

% generate freq domain representations
handles.signal1_freq = fft(handles.signal1_time);
handles.signal1_freq = handles.signal1_freq(1:(fs*tdur/2));
handles.signal1_freqmag = abs(handles.signal1_freq);
handles.signal1_freqphase = angle(handles.signal1_freq);

handles.signal2_freq = fft(handles.signal2_time);
handles.signal2_freq = handles.signal2_freq(1:(fs*tdur/2));
handles.signal2_freqmag = abs(handles.signal2_freq);
handles.signal2_freqphase = angle(handles.signal2_freq);

handles.freq_array = 0:fstep:(handles.disc_state.fs)/2-fstep;

% plot freq domain representations as default display
axes(handles.mainaxes);
title('Frequency Domain');
plot(handles.freq_array, handles.signal1_freqmag);
hold
plot(handles.freq_array, handles.signal2_freqmag);





% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end









% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textin_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textin_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function textin_tdur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textin_tdur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_freq_time_toggle.
function pb_freq_time_toggle_Callback(hObject, eventdata, handles)
% hObject    handle to pb_freq_time_toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
