//
//  main.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-08.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "tools/shader_utils.h"
#include "tools/camera.h"
#include "bodies/cube.h"
#include "bodies/spheres.h"
#include "stage/stage.h"
#include "tools/memmap_reader.h"
#include "tools/ini_reader.h"

//#include "boost/filesystem.hpp"


int main()
{
    printf("Renderer Begin Process\n");
    //Prepare Config Data
    ini_reader iniread;
    int num_obj = iniread.getSize();
    
    //Prepare Memory Map
    memmap_reader memmap(num_obj);
    
    //Define Camera
    camera myCam(stage::screen_width,stage::screen_height);
    //myCam.setView(glm::vec3(0.0, 2.0, -25.0), glm::vec3(0.0, 0.0, -4.0), glm::vec3(0.0, 1.0, 0.0));
    myCam.setView(glm::vec3(-23.0, -18.0, 6.0), glm::vec3(0.0, 0.0, -2.0), glm::vec3(0.0, 0.0, 1.0));
    myCam.setProjection(45.0f, 0.1f, 50.0f);
    
    //Define Objects
    
    //cube ta(num_obj);
    spheres ta(num_obj);
    
    //Link Object Data
    for(int i=0;i<num_obj;i++) {
        ta.linkPosition(memmap.pos_data+(i*3), memmap.pos_data+(i*3+1), memmap.pos_data+(i*3+2), i);
        ta.linkSize(memmap.size_data, i);
        ta.linkRotation(memmap.rot_data+(i*3), memmap.rot_data+(i*3+1), memmap.rot_data+(i*3+2), i);
    }
    
    //Prepare Stage
    stage::setCamera(myCam);
    stage::addBody(ta);
    
    //Run OpenGL
    stage::run();
    
    memmap.dispose();
    
    printf("Renderer End Process\n");
    return 0;
}

