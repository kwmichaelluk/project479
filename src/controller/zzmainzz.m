%phys_engine_path = ['..',filesep,'physics_engine_v9_william_OCT_1'];
phys_engine_path = ['..',filesep,'phys_engine'];
addpath(phys_engine_path);

ax = axes;
max_time = 100;
world = world1(10,10,10, 20, ax, max_time, 0.01); 
world.draw_scene;

% world1.initialize_configuration(number_of_disks,R,number_of_boxes,l,w,h)
n_obj = 8;
world.initialize_configuration(n_obj,1,0,0,0,0);

% world1.jacobian_initialization();
world.jacobian_initialization();

% world1.dynamics(simulation_time,solver);
solver_choice = 2;

x = world.x_log(:,1);
y = world.y_log(:,1);
z = world.z_log(:,1);

phi = world.angle_phi_log(:,1);
sig = world.angle_sig_log(:,1);
psi = world.angle_psi_log(:,1);

sphere_size = world.radius(:);

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

num_of_objs = n_obj;
ini.SetValues('Config', 'objects', num_of_objs);
ini.WriteFile(cfg_ini);

%Initialize Data Size - needed for memmap
engine_pos = ones(num_of_objs,3);          
engine_size = ones(num_of_objs,1);
engine_rot  = ones(num_of_objs,3);
for i=1:num_of_objs
   engine_pos((1-1)*3+1) = x(1);
   engine_pos((1-1)*3+1+1) = y(1);
   engine_pos((1-1)*3+2+1) = z(1);
    
   engine_size(i) = sphere_size(i);
end

%Construct new mmap file. Dimension of mmap file is fixed on construction.
fileID = fopen(mmap_data_pos,'w');
fwrite(fileID,engine_pos,'double');
fclose(fileID);

fileID = fopen(mmap_data_siz,'w');
fwrite(fileID,engine_size,'double');
fclose(fileID);

fileID = fopen(mmap_data_rot,'w');
fwrite(fileID,engine_rot,'double');
fclose(fileID);


%Link controller values
ctrl_pos= open_mmap(mmap_data_pos);
ctrl_rot= open_mmap(mmap_data_rot); 


%Begin OpenGL Process
start_renderer();

for i = 1:max_time-1
    world.dynamics(i,solver_choice);
    
    x = world.x_log(:,i+1);
    y = world.y_log(:,i+1);
    z = world.z_log(:,i+1);
    
    phi = world.angle_phi_log(:,i+1);
    sig = world.angle_sig_log(:,i+1);
    psi = world.angle_psi_log(:,i+1);
    
    for j=1:num_of_objs
        ctrl_pos.Data((j-1)*3+1) = x(j);
        ctrl_pos.Data((j-1)*3+1+1) = y(j);
        ctrl_pos.Data((j-1)*3+2+1) = z(j);
        
        %ctrl_rot.Data((j-1)*3+1) = phi(j);
        %ctrl_rot.Data((j-1)*3+1+1) = sig(j);
        %ctrl_rot.Data((j-1)*3+2+1) = psi(j);
    end
    
end