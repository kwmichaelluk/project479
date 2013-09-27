//
//  memmap_reader.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-22.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "memmap_reader.h"

memmap_reader::memmap_reader(int size) {
    FILE* in = fopen(config::pos_data_path.c_str(), "rb");
    
    data_size = size;
    pos_data = (double*)mmap(0, data_size * sizeof(double), PROT_READ, MAP_FILE | MAP_SHARED, fileno(in),0);
    
    fclose(in);

}

void memmap_reader::dispose() {
    munmap(pos_data, data_size * sizeof(double));
}