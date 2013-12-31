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
    file_mapping m_fileX((const char*)config::posX_data_path.string().c_str(),read_only);
    m_regionX = mapped_region(m_fileX, read_only,0,data_size * sizeof(double));
    file_mapping m_fileY((const char*)config::posY_data_path.string().c_str(),read_only);
    m_regionY = mapped_region(m_fileY, read_only,0,data_size * sizeof(double));
    file_mapping m_fileZ((const char*)config::posZ_data_path.string().c_str(),read_only);
    m_regionZ = mapped_region(m_fileZ, read_only,0,data_size * sizeof(double));
    
    //Set Position Data
    posX_data = (double *)m_regionX.get_address();
    posY_data = (double *)m_regionY.get_address();
    posZ_data = (double *)m_regionZ.get_address();
    
    //Size
    //Memory Mapping
    file_mapping m_file2((const char*)config::siz_data_path.string().c_str(),read_only);
    m_region2 = mapped_region(m_file2, read_only,0,data_size * sizeof(double));
    //Set Position Data
    size_data = (double *)m_region2.get_address();
    
    //Rotation
    //Memory Mapping
    file_mapping m_fileP((const char*)config::rotP_data_path.string().c_str(),read_only);
    m_regionP = mapped_region(m_fileP, read_only,0,data_size * sizeof(double));
    //Set Position Data
    rotP_data = (double *)m_regionP.get_address();
    
    file_mapping m_fileQ((const char*)config::rotQ_data_path.string().c_str(),read_only);
    m_regionQ = mapped_region(m_fileQ, read_only,0,data_size * sizeof(double));
    //Set Position Data
    rotQ_data = (double *)m_regionQ.get_address();
    
    file_mapping m_fileR((const char*)config::rotR_data_path.string().c_str(),read_only);
    m_regionR = mapped_region(m_fileR, read_only,0,data_size * sizeof(double));
    //Set Position Data
    rotR_data = (double *)m_regionR.get_address();
}

void memmap_reader::dispose() {
    //munmap(pos_data, data_size * sizeof(double));
    //NOTHING HERE.
}