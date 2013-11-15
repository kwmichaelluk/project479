<<<<<<< HEAD
%Define mmap file names
mmap_data_cfg = ['data',filesep,'data_cfg'];
mmap_data_pos = ['data',filesep,'data_pos'];
mmap_data_siz = ['data',filesep,'data_siz'];

%Receive data from engine
engine_cfg = [4 1 1 1]';       %config data [size ? ? ?]
engine_pos = [-4 2 -8
              5 -3 -5]';       %Fake data for now
engine_size = ones(engine_cfg(1),1);
for i=1:engine_cfg(1)
   engine_size(i) = 1+engine_cfg(1)*0.5;
end

%Construct new mmap file. Dimension of mmap file is fixed on construction.
fileID = fopen(mmap_data_cfg,'w');
fwrite(fileID,engine_cfg,'double');
fclose(fileID);

=======
%MATLAB folder search path
addpath('iniconfig');

%Define mmap file names
cfg_ini = ['data',filesep,'cfg.ini'];
mmap_data_pos = ['data',filesep,'data_pos'];
mmap_data_siz = ['data',filesep,'data_siz'];
mmap_data_rot = ['data',filesep,'data_rot'];

%Config Data
ini = IniConfig();
ini.ReadFile(cfg_ini);

num_of_objs = 5;
ini.SetValues('Config', 'objects', num_of_objs);
ini.WriteFile(cfg_ini);

%Receive data from engine
engine_pos = [-4 2 -8
              5 -3 -5]';       %Fake data for now
engine_size = ones(num_of_objs,1);
engine_rot  = ones(num_of_objs,1);
for i=1:num_of_objs
   engine_size(i) = 1+(i-1)*0.5;
   engine_rot(i) = 0 + 13*(i-1);
end

%Construct new mmap file. Dimension of mmap file is fixed on construction.
>>>>>>> link/ctrlr
fileID = fopen(mmap_data_pos,'w');
fwrite(fileID,engine_pos,'double');
fclose(fileID);

fileID = fopen(mmap_data_siz,'w');
fwrite(fileID,engine_size,'double');
fclose(fileID);

<<<<<<< HEAD
=======
fileID = fopen(mmap_data_rot,'w');
fwrite(fileID,engine_rot,'double');
fclose(fileID);

>>>>>>> link/ctrlr

%Link controller values
ctrl_pos= open_mmap(mmap_data_pos);

%Begin OpenGL Process
start_renderer();

%Pseudo Physics Engine - Testing movement
tic;
total_t=0;
while ctrl_pos.Data(2) > -8
    deltaT = toc;
    total_t = total_t + deltaT;
    if deltaT > 0.003
        ctrl_pos.Data(1) = 2*sin(total_t);
        ctrl_pos.Data(2) = ctrl_pos.Data(2) - 0.006;
        ctrl_pos.Data(3) = 2*cos(total_t)-7;
        
        ctrl_pos.Data(4) = 2*sin(total_t*2);
        ctrl_pos.Data(5) = 2*cos(total_t);
        ctrl_pos.Data(6) = 3*sin(total_t/2)-7;
        tic;
    end
end