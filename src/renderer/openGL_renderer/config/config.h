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
#include <string>
#include <boost/filesystem.hpp>


namespace config {
    //Folders
    static const std::string shader_dir = "shaders";
    static const std::string data_dir = "data";

    //Files
    static const std::string frag_shader_file = "shader.frag";
    static const std::string vert_shader_file = "shader.vert";
    static const std::string pos_data_file = "data_pos";

    //File Paths - boost::filesystem
    static const boost::filesystem::path frag_shader_path(shader_dir+"/"+frag_shader_file);
    static const boost::filesystem::path vert_shader_path(shader_dir+"/"+vert_shader_file);
    static const boost::filesystem::path pos_data_path(data_dir+"/"+pos_data_file);
    
    //Attribute Names
    static const std::string coord3d = "coord3d";
    static const std::string v_color = "v_color";
    static const std::string vertex_uv = "vertex_uv";
    static const std::string model_matrix = "model_matrix";
    
    //Uniform Names
    static const std::string view_matrix = "view_matrix";
    static const std::string proj_matrix = "proj_matrix";
    static const std::string texture_sampler = "myTextureSampler";

}

#endif /* defined(__openGL_renderer__config__) */
