%Define mmap file names
mmap_data_pos = ['data',filesep,'data_pos'];

%Receive data from engine
engine_num_of_obj = 1;             %Number of rigid bodies
engine_pos = [-4 2 -8 
              2 -1 -5
              3 3 -5
              -1 1 -4]';       %Fake data for now

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
t = 0;
while ctrl_pos.Data(2) > -5
    deltaT = toc;
    t = t + deltaT;
    if deltaT > 0.003
        ctrl_pos.Data(1) = 4*sin(1*t);
        ctrl_pos.Data(2) = ctrl_pos.Data(2) - 0.008;
        ctrl_pos.Data(3) = 4*cos(1*t)-8;
        tic;
    end
end