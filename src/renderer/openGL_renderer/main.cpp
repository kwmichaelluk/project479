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
#include "bodies/walls.h"
#include "bodies/spheres.h"
#include "stage/stage.h"
#include "tools/memmap_reader.h"
#include "tools/ini_reader.h"

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
    myCam.setView(glm::vec3(-23.0, -18.0, 6.0), glm::vec3(0.0, 0.0, -2.0), glm::vec3(0.0, 0.0, 1.0));
    myCam.setProjection(45.0f, 0.1f, 50.0f);
    
    //Define Objects
    spheres ta(num_obj);
    
    //Link Object Data
    for(int i=0;i<num_obj;i++) {
        ta.linkPosition(memmap.posX_data+i, memmap.posY_data+i, memmap.posZ_data+i, i);
        ta.linkSize(memmap.size_data+i, i);
        ta.linkRotation(memmap.rotP_data+i, memmap.rotQ_data+i, memmap.rotR_data+i, i);
    }
    
    //Walls - Hard code wall properties for now
    walls myWalls(1);
    double wall_x=0, wall_y=0, wall_z=-5;
    double wall_size=10;
    double wall_p=0, wall_q=0, wall_r=0;
    myWalls.linkPosition(&wall_x, &wall_y, &wall_z, 0);
    myWalls.linkSize(&wall_size, 0);
    myWalls.linkRotation(&wall_p, &wall_q, &wall_r, 0);
    
    //Prepare Stage
    stage::setCamera(myCam);

    //Must add Walls AFTER Balls for transparency to work
    stage::addBody(ta);
    stage::addBody(myWalls);

    //Run OpenGL
    stage::run();
    
    memmap.dispose();
    
    printf("Renderer End Process\n");
    return 0;
}

