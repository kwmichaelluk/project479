function [mmap] = open_mmap()
    mmap_filename = 'data/data_pos';
    
    mmap = memmapfile(mmap_filename,'Format','double');
    mmap.Writable = true;
end

