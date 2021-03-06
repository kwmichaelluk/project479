//
//  memmap_reader.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-22.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__memmap_reader__
#define __openGL_renderer__memmap_reader__

//#include <boost/iostreams/device/mapped_file.hpp>
#include <boost/interprocess/file_mapping.hpp>
#include <boost/interprocess/mapped_region.hpp>
//#include "boost/filesystem.hpp"

#include <iostream>
//#include <sys/mman.h>

#include "../config/config.h"

using namespace boost::interprocess;

class memmap_reader {
private:
    //const char *file_name = "data/data_pos";
    
    //Number of data points, size of array
    int data_size;
    
    mapped_region m_regionX, m_regionY, m_regionZ;
    mapped_region m_region2; //size
    mapped_region m_regionP, m_regionQ, m_regionR; //rotation
    
public:
    memmap_reader(int size);

    void dispose();
    
    //Data Pointers
    //double *cfg_data;
    double *posX_data; double *posY_data; double *posZ_data;
    double *size_data;
    double *rotP_data; double *rotQ_data; double *rotR_data;
};

#endif /* defined(__openGL_renderer__memmap_reader__) */
