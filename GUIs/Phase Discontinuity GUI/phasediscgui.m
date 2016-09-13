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

% Last Modified by GUIDE v2.5 11-Sep-2016 12:24:17

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
handles.timeIsDisplayed = 0;
handles.windowtype1 = 'Rectangle';
handles.windowtype2 = 'Rectangle';

% Initialize GUI elements and other data
handles.disc_state.fs = 44100;
handles.disc_state.freq = 500;
handles.disc_state.tdur = 5;
handles.disc_state.segs1 = 1;
handles.disc_state.segs2 = 1;

handles.textin_tdur.String = handles.disc_state.tdur;
handles.textin_freq.String = handles.disc_state.freq;
handles.textin_fs.String = handles.disc_state.fs;
handles.textin_segs1.String = handles.disc_state.segs1;
handles.textin_segs2.String = handles.disc_state.segs2;

% Initialize Plot Titles/Labels
plotInit(handles);

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETER SELECT CALLBACKS - Functions that select/configure parameters
% before the phase discontinuity calculations are called. These functions
% are called by interaction with the GUI.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROL CALLBACKS - Functions used for controlling the phase disctonuity
% calculations and displays. These functions are called interaction with
% the GUI.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
function pb_calc_Callback(hObject, eventdata, handles)
    tdur = handles.disc_state.tdur;
    fs = handles.disc_state.fs;
    tstep = 1/fs;
    fstep = 1/tdur;

    % genereate time domain signals
    handles.signal1_time = buildSignal(handles.disc_state.fs, handles.disc_state.tdur, handles.disc_state.freq, handles.disc_state.segs1, handles.windowtype1);
    handles.signal2_time = buildSignal(handles.disc_state.fs, handles.disc_state.tdur, handles.disc_state.freq, handles.disc_state.segs2, handles.windowtype2);
    handles.time_array = linspace(0, tdur, length(handles.signal1_time));

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
    
    guidata(hObject, handles);

% plot freq domain representations as default display
if(handles.timeIsDisplayed == 0)
    plotFreq(handles);
else
    plotTime(handles);
end

guidata(hObject, handles);

function pb_playsignal1_Callback(hObject, eventdata, handles)
    sound(handles.signal1_time, handles.disc_state.fs);

function pb_playsignal2_Callback(hObject, eventdata, handles)
    sound(handles.signal2_time, handles.disc_state.fs);

function pb_freq_time_toggle_Callback(hObject, eventdata, handles)
    if(handles.timeIsDisplayed == 0)
        plotTime(handles);
        handles.timeIsDisplayed = 1;
    else
        plotFreq(handles);
        handles.timeIsDisplayed = 0;
    end

guidata(hObject, handles);

function rb_displayphase_Callback(hObject, eventdata, handles)
    if(handles.timeIsDisplayed == 0)
        plotFreq(handles);
    end
    
function rb_displaysignal1_Callback(hObject, eventdata, handles)
    if(handles.timeIsDisplayed)
       plotTime(handles);
    else
       plotFreq(handles);
    end

function rb_displaysignal2_Callback(hObject, eventdata, handles)
    if(handles.timeIsDisplayed)
       plotTime(handles); 
    else
       plotFreq(handles);
    end
    
function popupmenu1_Callback(hObject, eventdata, handles)
   value = handles.popupmenu1.Value;
   type = updateWindow(value);
   handles.windowtype1 = type;
   
   guidata(hObject, handles);
   
function popupmenu2_Callback(hObject, eventdata, handles)
   value = handles.popupmenu2.Value;
   type = updateWindow(value);
   handles.windowtype2 = type;
   
   guidata(hObject, handles);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRIVATE FUNCTIONS - CALLED ONLY BY THIS SCRIPT FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% TODO - Find an alternative method, this is very 'shift by one' error
% prone
function type = updateWindow(value)
   switch value
       case 1
           type = window_type.Rectangle;
       case 2
           type = window_type.Triangle;
       case 3
           type = window_type.Parzen;
       case 4
           type = window_type.Welch;
       case 5
           type = window_type.Hanning;
       case 6
           type = window_type.Hamming;           
       case 7
           type = window_type.Blackman;       
       case 8
           type = window_type.Nuttall;      
       case 9
           type = window_type.BlackmanNuttall;      
       case 10
           type = window_type.BlackmanHarris;      
       case 11
           type = window_type.FlatTop;         
       case 12
           type = window_type.Cosine;           
       case 13
           type = window_type.Gaussian;                     
       case 14
           type = window_type.GeneralNormal; 
       case 15
           type = window_type.Tukey;   
       case 16
           type = window_type.PlankTaper;    
       case 17
           type = window_type.Slepian;    
       case 18
           type = window_type.Kaiser;    
       case 19
           type = window_type.DolphChebyshev;    
       case 20
           type = window_type.UltraSpherical;    
       case 21
           type = window_type.Poisson;    
       case 22
           type = window_type.BartlettHann;    
       case 23
           type = window_type.PlankBessel;    
       case 24
           type = window_type.HannPoisson;    
       case 25
           type = window_type.Lanczos;    
       otherwise
           type = window_type.Rectangle;
   end

% Plot Functions
function plotInit(handles)
    cla(handles.mainaxes, 'reset');
    axes(handles.mainaxes);
    title('Time Domain');
    ylabel('Magnitude');
    xlabel('Time (sec)')
    
function plotFreq(handles)
    cla(handles.mainaxes, 'reset');
    axes(handles.mainaxes);
    hold on
    
    if(handles.rb_displaysignal1.Value)
        yyaxis left
        plot(handles.freq_array, handles.signal1_freqmag, 'red');
        if(handles.rb_displayphase.Value)
            yyaxis right
            plot(handles.freq_array, handles.signal1_freqphase, '--red');
        end 
    end
    
    if(handles.rb_displaysignal2.Value)
        yyaxis left
        plot(handles.freq_array, handles.signal2_freqmag, 'blue');
        if(handles.rb_displayphase.Value)
            yyaxis right
            plot(handles.freq_array, handles.signal2_freqphase, '--blue');
        end       
    end
  
    title('Frequency Domain');
    yyaxis left
    ylabel('Magnitude');
    yyaxis right
    ylabel('Phase (rads)');
    xlabel('Analog Frequency (Hz)')

    % Legend logic - the legend is dependent on what the user has selected
    % to display..
    if(handles.rb_displayphase.Value)
       if(handles.rb_displaysignal1.Value && handles.rb_displaysignal2.Value)
           legend('Signal 1 Magnitude', 'Signal 1 Phase','Signal 2 Magnitude', 'Signal 2 Phase')     
       elseif(handles.rb_displaysignal1.Value && ~handles.rb_displaysignal2.Value)
           legend('Signal 1 Magnitude', 'Signal 1 Phase')  
       elseif(~handles.rb_displaysignal1.Value && handles.rb_displaysignal2.Value)
           legend('Signal 2 Magnitude', 'Signal 2 Phase')    
       end
    else
        if(handles.rb_displaysignal1.Value && handles.rb_displaysignal2.Value)
           legend('Signal 1 Magnitude', 'Signal 2 Magnitude')     
       elseif(handles.rb_displaysignal1.Value && ~handles.rb_displaysignal2.Value)
           legend('Signal 1 Magnitude')  
       elseif(~handles.rb_displaysignal1.Value && handles.rb_displaysignal2.Value)
           legend('Signal 2 Magnitude')    
       end       
    end
    
    hold off

function plotTime(handles)

    cla(handles.mainaxes, 'reset');
    axes(handles.mainaxes);
    
    hold on
    
    if(handles.rb_displaysignal1.Value)
        plot(handles.time_array, handles.signal1_time, 'red');    
    end
    
    if(handles.rb_displaysignal2.Value)
        plot(handles.time_array, handles.signal2_time, 'blue');    
    end
    
    title('Time Domain');
    ylabel('Magnitude');
    xlabel('Time (sec)')
    
    if(handles.rb_displaysignal1.Value && handles.rb_displaysignal2.Value)
        legend('Signal 1', 'Signal 2');    
    elseif(~handles.rb_displaysignal1.Value && handles.rb_displaysignal2.Value)
        legend('Signal 2');    
    elseif(handles.rb_displaysignal1.Value && ~handles.rb_displaysignal2.Value)
        legend('Signal 1'); 
    end
    
    hold off 
    
