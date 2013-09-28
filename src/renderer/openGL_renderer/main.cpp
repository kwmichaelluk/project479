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
//#include <GLUT/glut.h>

#include <GLFW/glfw3.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
#include "tools/shader_utils.h"
#include "tools/camera.h"
#include "bodies/cube.h"
#include "stage/stage.h"
#include "tools/memmap_reader.h"

using namespace std;

int main()
{
    printf("RUN START\n");
    
    //Prepare Memory Map
    memmap_reader memmap(4);
    
    //Set Camera
    camera myCam(stage::screen_width,stage::screen_height);
    myCam.setView(glm::vec3(0.0, 2.0, 0.0), glm::vec3(0.0, 0.0, -4.0), glm::vec3(0.0, 1.0, 0.0));
    myCam.setProjection(80.0f, 0.1f, 20.0f);
    
    //Set Objects
    cube ta(1, stage::uniform_mvp);
    
    //Link Object Data
    ta.setPosition(memmap.pos_data+0, memmap.pos_data+1, memmap.pos_data+2, 0);
    
    //Prepare Stage
    stage::setCamera(myCam);
    stage::addBody(ta);
    
    //Run OpenGL
    stage::run();
    
    memmap.dispose();
    
    printf("RUN END\n");
    return 0;
}

