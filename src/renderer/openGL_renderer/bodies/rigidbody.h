//
//  rigidbody.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-10.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__rigidbody__
#define __openGL_renderer__rigidbody__

#include <iostream>

#include <GL/glew.h>
//#include <GLUT/glut.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "config.h"

class rigidbody {
private:
    double *pos_x;
    double *pos_y;
    double *pos_z;
    glm::vec3 position;
    
    float scaleSize=1.0;
    
public:
    glm::mat4 model_matrix;
    glm::mat4 scale_matrix;
    glm::mat4 rotate_matrix;
    
public:
    rigidbody() {
        scale_matrix = glm::scale(glm::mat4(1.0f),glm::vec3(scaleSize));
    };
    
    void setPosition(double *x, double *y, double *z) {
        pos_x=x; pos_y=y; pos_z=z;
    }
    
    void setSize(float size) {
        scaleSize = size;
        scale_matrix = glm::scale(glm::mat4(1.0f),glm::vec3(scaleSize));
    }
    
    //Update MVP and Position (Position no longer part of MVP)
    void update(glm::mat4 &view, glm::mat4 &projection) {
        //Update position data
        position.x = *pos_x;
        position.y = *pos_y;
        position.z = *pos_z;
        
        glm::vec3 rotate_axis(1.0, 0.0, 0.0);
        rotate_matrix = glm::rotate(glm::mat4(1.0f), 14.0f, rotate_axis);

        model_matrix = glm::translate(glm::mat4(1.0f), position) * rotate_matrix * scale_matrix;
    };

    
};

#endif /* defined(__openGL_renderer__rigidbody__) */
