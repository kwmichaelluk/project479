function varargout = gui2(varargin)
% GUI2 M-file for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 25-Sep-2013 18:34:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2 (see VARARGIN)

% Choose default command line output for gui2
handles.output = hObject;

%START USER CODE
tic;
set(handles.display_time,'String','0');
set(handles.simulation_time,'String','0');

set(handles.start,'Enable','off');
set(handles.pause_resume,'Enable','off');
set(handles.stop,'Enable','off');
set(handles.step,'Enable','off');
set(handles.next,'Enable','off');
set(handles.previous,'Enable','off');
set(handles.save_scene,'Enable','on');

%END USER CODE
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%START USER CODE
set(handles.status,'String','Running');

set(handles.pause_resume,'String','Pause');
set(handles.pause_resume,'Enable','on');
set(handles.stop,'Enable','on');
set(handles.step,'Enable','off');
set(handles.save_scene,'Enable','on');
set(handles.initialize_scene,'Enable','off');

%read the time data
simulation_time = str2double(get(handles.simulation_time,'String'));
max_time = handles.scene.max_time;
loop_time_data = handles.scene.loop_time;

%read solver choice
solver = get(handles.solver_choice,'UserData');
%Start simulation as long as the figure exists
%profile on -detail builtin
while ishandle(handles.axes1)
    
    %If the status changed since last iteration, stop or pause
    if strcmp(get(handles.status,'String'),'Stopped')
        %stopped 
        if get(handles.auto_save,'Value') == get(handles.auto_save,'Max')
            save_scene(handles.scene);
        end
        set(handles.save_scene,'Enable','on');
        set(handles.pause_resume,'Enable','off');
        set(handles.stop,'Enable','off');
        set(handles.step,'Enable','off');
        set(handles.initialize_scene,'Enable','on');
        set(handles.simulation_time,'String',num2str(0));
        %record stop time
        handles.scene.stop_time = simulation_time;
        handles.scene.previous_set = [];
        %profile viewer
        break
    elseif strcmp(get(handles.status,'String'),'Paused')
        %only update the display time if Paused
        display_time = str2double(get(handles.display_time,'String'));
        %and read the step flag
        if get(handles.step,'UserData')
            set(handles.status,'String','Running');
        end
    else
        % Simulating the next time frame
        simulation_time = simulation_time + 1;
        set(handles.time_slider,'Max',simulation_time);
        % update the display time
        display_time = simulation_time;
        set(handles.display_time,'String',num2str(display_time));
        set(handles.time_slider,'Value',display_time);

        %read the time since latest loop execution
        loop_time = toc;
        %execute the dynamics simulation for this loop
		%**************************************************************%
        handles.scene.dynamics(simulation_time,solver);
        %update (temporary) stop time
        handles.scene.stop_time = simulation_time;
        
        %plot loop_time
        loop_time = toc - loop_time;
        loop_time_data(simulation_time) = loop_time;
        plot(handles.axes2,loop_time_data);
        set(handles.simulation_time,'String',num2str(simulation_time));


        % read and act according to the step flag
        if get(handles.step,'UserData')
            set(handles.step,'UserData',0);
            set(handles.status,'String','Paused');
        end
        
        % stop if reach the max_time
        if simulation_time >= max_time
            set(handles.status,'String','Stopped');
        end
    end

    % Draw if Monitor Simulation is checked
    if get(handles.monitor_simulation,'UserData')
        draw_at_time(handles.scene,display_time);
    end
    drawnow;
end
%END USER CODE


% --- Executes on button press in pause_resume.
function pause_resume_Callback(hObject, eventdata, handles)
% hObject    handle to pause_resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.status,'String'),'Running')
    set(handles.status,'String','Paused');
    set(hObject,'String','Resume');
    set(handles.step,'Enable','on');
    set(handles.save_scene,'Enable','on');
elseif strcmp(get(handles.status,'String'),'Paused')
    set(handles.status,'String','Running');
    set(hObject,'String','Paused');
    set(handles.step,'Enable','off');
    set(handles.save_scene,'Enable','on');
end


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.status,'String','Stopped');
set(handles.initialize_scene,'Enable','on');



function radius_Callback(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of radius as text
%        str2double(get(hObject,'String')) returns contents of radius as a double


% --- Executes during object creation, after setting all properties.
function radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function number_of_disks_Callback(hObject, eventdata, handles)
% hObject    handle to number_of_disks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number_of_disks as text
%        str2double(get(hObject,'String')) returns contents of number_of_disks as a double


% --- Executes during object creation, after setting all properties.
function number_of_disks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number_of_disks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function number_of_edges_Callback(hObject, eventdata, handles)
% hObject    handle to number_of_edges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number_of_edges as text
%        str2double(get(hObject,'String')) returns contents of number_of_edges as a double


% --- Executes during object creation, after setting all properties.
function number_of_edges_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number_of_edges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_Callback(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height as text
%        str2double(get(hObject,'String')) returns contents of height as a double


% --- Executes during object creation, after setting all properties.
function height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_Callback(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width as text
%        str2double(get(hObject,'String')) returns contents of width as a double


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_time_Callback(hObject, eventdata, handles)
% hObject    handle to max_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_time as text
%        str2double(get(hObject,'String')) returns contents of max_time as a double



% --- Executes during object creation, after setting all properties.
function max_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function step_size_Callback(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step_size as text
%        str2double(get(hObject,'String')) returns contents of step_size as a double


% --- Executes during object creation, after setting all properties.
function step_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in choose_file.
function choose_file_Callback(hObject, eventdata, handles)
% hObject    handle to choose_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_file contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_file

%START USER CODE
% read the file
str = get(hObject,'String');
val = get(hObject,'Value');
load(str{val});
handles.scene = S;
states = num2cell(1:S.stop_time)';
set(handles.states_list,'String',states,'Value',1);
guidata(hObject,handles)

%clear current scene viewer
cla(handles.axes1)
cla(handles.axes2)
%read data from file
set(handles.height,'String',num2str(S.height));
set(handles.width,'String',num2str(S.width));
set(handles.max_time,'String',num2str(S.max_time));
set(handles.radius,'String',num2str(mean(S.radius)));
set(handles.step_size,'String',num2str(S.step_size));
set(handles.number_of_edges,'String',num2str(S.number_of_edges));
set(handles.number_of_disks,'String',num2str(length(S.RigidBodies)));
%initialize the properties for the axes object
handles.scene.ax = handles.axes1;
handles.scene.lines = patch;
handles.scene.draw_scene;

set(handles.status,'String','Ready');
set(handles.start,'Enable','on');
set(handles.save_scene,'Enable','on');
%end_time from the simulation loaded
end_time = S.stop_time;
set(handles.simulation_time,'String',num2str(end_time));
set(handles.display_time,'String',num2str(end_time));
set(handles.time_slider,'Value',end_time);
set(handles.time_slider,'Max',end_time);
%END USER CODE



% --- Executes during object creation, after setting all properties.
function choose_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% START USER CODE
scenes = dir('scene_*.mat');
names =[];
for i = 1:numel(scenes)
    names = [names; scenes(i).name];
end
names = cellstr(names);
set(hObject,'String',names);
% END USER CODE


% --- Executes on selection change in states_list.
function states_list_Callback(hObject, eventdata, handles)
% hObject    handle to states_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns states_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from states_list
time = get(hObject,'Value');
set(handles.display_time,'String',num2str(time));
set(handles.simulation_time,'String',num2str(time));
if get(handles.monitor_simulation,'UserData')
    draw_at_time(handles.scene,time);
end
drawnow

% --- Executes during object creation, after setting all properties.
function states_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to states_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle status of save_data


% --- Executes on button press in step.
function step_Callback(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'UserData',1);



% --- Executes on button press in monitor_simulation.
function monitor_simulation_Callback(hObject, eventdata, handles)
% hObject    handle to monitor_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle status of monitor_simulation
if get(hObject,'Value') == get(hObject,'Max')
    % use UserData as the draw flag
    set(hObject,'UserData',1);
else
    set(hObject,'UserData',0);
end

% --- Executes on button press in show_constraints.
function show_constraints_Callback(hObject, eventdata, handles)
% hObject    handle to show_constraints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle status of show_constraints


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = str2double(get(handles.display_time,'String'));
bound = handles.scene.max_time;
time = time + 1;
if time == bound
    set(hObject,'Enable','off');
end

set(handles.previous,'Enable','on');
set(handles.time_slider,'Value',time);
set(handles.display_time,'String',num2str(time));
if get(handles.monitor_simulation,'UserData')
    draw_at_time(handles.scene,time);
end
drawnow



% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = str2double(get(handles.display_time,'String'));
time = time - 1;
%don't access time 0 since it's not a valid index
if time == 1
    set(hObject,'Enable','off');
end

set(handles.next,'Enable','on');
set(handles.time_slider,'Value',time);
set(handles.display_time,'String',num2str(time));
if get(handles.monitor_simulation,'UserData')
    draw_at_time(handles.scene,time);
end
drawnow

% --- Executes on slider movement.
function time_slider_Callback(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
time = floor(get(hObject,'Value'));
%don't access time 0 since it's not a valid index
if time <= 1
    time = 1;
    set(handles.previous,'Enable','off');
    set(handles.next,'Enable','on');
elseif time == handles.scene.max_time
    set(handles.next,'Enable','off');
    set(handles.previous,'Enable','on');
else
    set(handles.previous,'Enable','on');
    set(handles.next,'Enable','on');
end

set(handles.display_time,'String',num2str(time));
if get(handles.monitor_simulation,'UserData')
    draw_at_time(handles.scene,time);
end
drawnow


% --- Executes during object creation, after setting all properties.
function time_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in initial_v.
function initial_v_Callback(hObject, eventdata, handles)
% hObject    handle to initial_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns initial_v contents as cell array
%        contents{get(hObject,'Value')} returns selected item from initial_v


% --- Executes during object creation, after setting all properties.
function initial_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initial_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in initialize_scene.
function initialize_scene_Callback(hObject, eventdata, handles)
% hObject    handle to initialize_scene (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%START USER CODE

%clear current scene viewer
cla(handles.axes1)
cla(handles.axes2)
%read user input
H = str2double(get(handles.height,'String'));
W = str2double(get(handles.width,'String'));
max_time = str2double(get(handles.max_time,'String'));
R = str2double(get(handles.radius,'String'));
step_size = str2double(get(handles.step_size,'String'));
number_of_edges = str2double(get(handles.number_of_edges,'String'));
number_of_disks = str2double(get(handles.number_of_disks,'String'));

%create a handle to the new scene in the GUI data 
handles.scene = scene2(H,W,number_of_edges,handles.axes1,max_time,step_size);

%initialize the properties for the axes object
handles.scene.draw_scene;
%initialize the disks in the scene
handles.scene.initialize_configuration(R,number_of_disks)
handles.scene.jacobian_initialization();
%save the new scene to the GUI data
guidata(hObject,handles);

set(handles.status,'String','Ready');
set(handles.start,'Enable','on');
set(handles.save_scene,'Enable','on');
set(handles.simulation_time,'String',num2str(0));
set(handles.display_time,'String',num2str(0));
set(handles.time_slider,'Value',0);
set(handles.time_slider,'Max',0);

%END USER CODE

% --- Executes on button press in save_scene.
function save_scene_Callback(hObject, eventdata, handles)
% hObject    handle to save_scene (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%START USER CODE
S = handles.scene;
save_scene(S);
%END USER CODE

% --- Executes on button press in auto_save.
function auto_save_Callback(hObject, eventdata, handles)
% hObject    handle to auto_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle status of auto_save


% --- Executes during object creation, after setting all properties.
function auto_save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auto_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%create and save the save flag to the guidata
handles.save = 0;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function simulation_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simulation_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function monitor_simulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitor_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.draw = 0;
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%START USER CODE

%END USER CODE


% --- Executes on button press in reload.
function reload_Callback(hObject, eventdata, handles)
% hObject    handle to reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% START USER CODE
scenes = dir('scene_*.mat');
names =[];
for i = 1:numel(scenes)
    names = [names; scenes(i).name];
end
names = cellstr(names);
set(handles.choose_file,'String',names);
% END USER CODE


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in solver_choice.
function solver_choice_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in solver_choice 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') %Get Tag of the selected object.
    case 'direct'
        disp('direct')
        set(handles.solver_choice,'UserData',1);
    case 'iterative'
        disp('iterative')
        set(handles.solver_choice,'UserData',2);
    case 'schurpa'
        disp('schurpa')
        set(handles.solver_choice,'UserData',3);
    case 'schur'
        disp('schur')
        set(handles.solver_choice,'UserData',4);
    case 'schur_w_cg'
        disp('schur_w_cg')
        set(handles.solver_choice,'UserData',5);
    case 'schur_w_cf'
        disp('schur_w_cf')
        set(handles.solver_choice,'UserData',6);
    otherwise
        set(handles.solver_choice,'UserData',1); %using direct as default
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function solver_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solver_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'UserData',1);


% --- Executes during object creation, after setting all properties.
function start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
