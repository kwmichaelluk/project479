%Define mmap file names
mmap_data_pos = ['data',filesep,'data_pos'];

%Receive data from engine
engine_num_of_obj = 1;             %Number of rigid bodies
engine_pos = [-4 2 -8
              5 -3 -5]';       %Fake data for now

%Construct new mmap file. Dimension of mmap file is fixed on construction.
fileID = fopen(mmap_data_pos,'w');
fwrite(fileID,engine_pos,'double');
fclose(fileID);

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