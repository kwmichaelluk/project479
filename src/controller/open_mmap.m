function [mmap] = open_mmap(mmap_filename)
    %mmap_filename = ['data',filesep,'data_pos'];
    
    mmap = memmapfile(mmap_filename,'Format','double');
    mmap.Writable = true;
end

