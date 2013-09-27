//
//  camera.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-10.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "camera.h"

camera::camera(int screen_width, int screen_height) {
    this->screen_width = screen_width;
    this->screen_height = screen_height;
}

void camera::setView(glm::vec3 eye, glm::vec3 centre, glm::vec3 up) {
    view = glm::lookAt(eye, centre, up);
}

void camera::setProjection(float angle, float zNear, float zFar) {
    projection = glm::perspective(angle, 1.0f*screen_width/screen_height, zNear, zFar);
}