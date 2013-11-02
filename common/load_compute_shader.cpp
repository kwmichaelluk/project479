//
//  load_compute_shader.cpp
//  glfw_test
//
//  Created by NANCY CHEN on 13-10-11.
//  Copyright (c) 2013 University of British Columbia. All rights reserved.
//


#include <stdio.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <algorithm>
using namespace std;

#include <stdlib.h>
#include <string.h>

#include <GL/glew.h>

#include "load_compute_shader.h"

GLuint LoadComputeProgram(const char * compute_file_path)
