//
//  ini_reader.h
//  openGL_renderer
//
//  Created by Michael Luk on 11/8/2013.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__ini_reader__
#define __openGL_renderer__ini_reader__

#include <iostream>
#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/ini_parser.hpp>
#include "../config/config.h"

class ini_reader {
private:
    boost::property_tree::ptree pt;
public:
    ini_reader();
    
    int getSize();
};

#endif /* defined(__openGL_renderer__ini_reader__) */
