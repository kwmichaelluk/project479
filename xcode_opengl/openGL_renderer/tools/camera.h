//
//  camera.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-10.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__camera__
#define __openGL_renderer__camera__

#include <iostream>
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

class camera {
public:
    glm::mat4 view, projection;
    
    int screen_width, screen_height;
    
public:
    camera();
    camera(int screen_width, int screen_height);
    
    //Must call the two methods below to finish initializing camera.
    void setView(glm::vec3 eye, glm::vec3 centre, glm::vec3 up);
    void setProjection(float angle, float zNear, float zFar);
};

#endif /* defined(__openGL_renderer__camera__) */
