//
//  memmap_reader.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-22.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "memmap_reader.h"


memmap_reader::memmap_reader(int size) {
    /*FILE* in = fopen(config::pos_data_path.c_str(), "rb");
    
    data_size = size;
    pos_data = (double*)mmap(0, data_size * sizeof(double), PROT_READ, MAP_FILE | MAP_SHARED, fileno(in),0);
    
    fclose(in);*/
    
    data_size = size;

    //Memory Mapping
    file_mapping m_file("data/data_pos",read_only);
    m_region = mapped_region(m_file, read_only,0,data_size * sizeof(double));
    
    //Set Position Data
    pos_data = (double *)m_region.get_address();
    
}

void memmap_reader::dispose() {
    //munmap(pos_data, data_size * sizeof(double));
    //NOTHING HERE.
}