//
//  memmap_reader.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-22.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__memmap_reader__
#define __openGL_renderer__memmap_reader__

#include <iostream>
#include <sys/mman.h>

#include "../config/config.h"

class memmap_reader {
private:
    //const char *file_name = "data/data_pos";
    
    //Number of data points, size of array
    int data_size;
public:
    memmap_reader(int size);

    void dispose();
    
    //Data Pointers
    double *pos_data;
};

#endif /* defined(__openGL_renderer__memmap_reader__) */
