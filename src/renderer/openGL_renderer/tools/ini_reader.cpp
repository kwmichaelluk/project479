//
//  ini_reader.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 11/8/2013.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "ini_reader.h"


ini_reader::ini_reader() {
    boost::property_tree::ini_parser::read_ini((const std::string)config::cfg_ini_path.c_str(), pt);
}

int ini_reader::getSize() {
    return pt.get<int>("Config.objects");
}