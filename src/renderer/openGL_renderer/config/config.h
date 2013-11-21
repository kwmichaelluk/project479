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
    static const std::string posX_data_file = "dataX_pos";
    static const std::string posY_data_file = "dataY_pos";
    static const std::string posZ_data_file = "dataZ_pos";
    
    static const std::string siz_data_file = "data_siz";
    
    static const std::string rotP_data_file = "dataP_rot";
    static const std::string rotQ_data_file = "dataQ_rot";
    static const std::string rotR_data_file = "dataR_rot";
    
    static const std::string cfg_ini_file = "cfg.ini";

    //File Paths - boost::filesystem
    static const boost::filesystem::path frag_shader_path(shader_dir+"/"+frag_shader_file);
    static const boost::filesystem::path vert_shader_path(shader_dir+"/"+vert_shader_file);
    
    static const boost::filesystem::path posX_data_path(data_dir+"/"+posX_data_file);
    static const boost::filesystem::path posY_data_path(data_dir+"/"+posY_data_file);
    static const boost::filesystem::path posZ_data_path(data_dir+"/"+posZ_data_file);
    
    static const boost::filesystem::path cfg_ini_path(data_dir+"/"+cfg_ini_file);
    static const boost::filesystem::path siz_data_path(data_dir+"/"+siz_data_file);
    
    static const boost::filesystem::path rotP_data_path(data_dir+"/"+rotP_data_file);
    static const boost::filesystem::path rotQ_data_path(data_dir+"/"+rotQ_data_file);
    static const boost::filesystem::path rotR_data_path(data_dir+"/"+rotR_data_file);
    
    //Attribute Names
    static const std::string coord3d = "coord3d";
    static const std::string v_color = "v_color";
    static const std::string vertex_uv = "vertex_uv";
    static const std::string vertex_normal = "vertex_normal";
    static const std::string model_matrix = "model_matrix";
    
    //Uniform Names
    static const std::string view_matrix = "view_matrix";
    static const std::string proj_matrix = "proj_matrix";
    static const std::string texture_sampler = "myTextureSampler";
    static const std::string light_pos = "LightPosition_worldspace";
    static const std::string alpha_chn = "Alpha_chn";

}

#endif /* defined(__openGL_renderer__config__) */
