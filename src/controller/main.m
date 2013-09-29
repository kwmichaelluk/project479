%Define mmap file names
mmap_data_pos = ['data',filesep,'data_pos'];

%Receive data from engine
engine_num_of_obj = 1;             %Number of rigid bodies
engine_pos = [-4 2 -8]';       %Fake data for now

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
while ctrl_pos.Data(1) < 4
    deltaT = toc;
    if deltaT > 0.03
        ctrl_pos.Data(1) = ctrl_pos.Data(1) + 0.07;
        %ctrl_pos.Data(2) = ctrl_pos.Data(2) - 0.03;
        %ctrl_pos.Data(3) = ctrl_pos.Data(3) + 0.005;
        tic;
    end
end