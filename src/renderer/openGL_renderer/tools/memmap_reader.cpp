//
//  memmap_reader.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-22.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "memmap_reader.h"


memmap_reader::memmap_reader(int size) {
    data_size = size;

    //Position
    //Memory Mapping
    file_mapping m_file(config::pos_data_path.c_str(),read_only);
    m_region = mapped_region(m_file, read_only,0,data_size * sizeof(double));
    //Set Position Data
    pos_data = (double *)m_region.get_address();
    
    //Size
    //Memory Mapping
    file_mapping m_file2(config::siz_data_path.c_str(),read_only);
    m_region2 = mapped_region(m_file2, read_only,0,data_size * sizeof(double));
    //Set Position Data
    size_data = (double *)m_region2.get_address();
    
    //Rotation
    //Memory Mapping
    file_mapping m_file3(config::siz_data_path.c_str(),read_only);
    m_region3 = mapped_region(m_file3, read_only,0,data_size * sizeof(double));
    //Set Position Data
    rot_data = (double *)m_region3.get_address();
}

void memmap_reader::dispose() {
    //munmap(pos_data, data_size * sizeof(double));
    //NOTHING HERE.
}