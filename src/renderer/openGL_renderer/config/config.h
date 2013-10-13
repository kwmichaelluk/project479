//
//  config.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-22.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__config__
#define __openGL_renderer__config__

#include <iostream>

namespace config {

    static const std::string shader_dir = "shaders";
    static const std::string data_dir = "data";

    static const std::string frag_shader_file = "cube.frag";
    static const std::string vert_shader_file = "cube.vert";

    static const std::string pos_data_file = "data_pos";

    static const std::string frag_shader_path = shader_dir+"/"+frag_shader_file;
    static const std::string vert_shader_path = shader_dir+"/"+vert_shader_file;

    static const std::string pos_data_path = data_dir+"/"+pos_data_file;
    
    static const bool instancing = true;
    //NOTE: If not instancing, remove 'm_pos' from vertex shader

}

#endif /* defined(__openGL_renderer__config__) */
