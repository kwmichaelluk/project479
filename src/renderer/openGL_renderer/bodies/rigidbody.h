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
#include <GLUT/glut.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "config.h"

class rigidbody {
private:
    double *pos_x;
    double *pos_y;
    double *pos_z;
    
public:
    glm::vec3 position;
    glm::mat4 model_matrix;
    //glm::mat4 mvp;
    
    
    
public:
    rigidbody() {};
    
    void setPosition(double *x, double *y, double *z) {
        pos_x=x; pos_y=y; pos_z=z;
    }
    
    //Update MVP and Position (Position no longer part of MVP)
    void update(glm::mat4 &view, glm::mat4 &projection) {
        //Update position data
        position.x = *pos_x;
        position.y = *pos_y;
        position.z = *pos_z;
        
        model_matrix = glm::translate(glm::mat4(1.0f), position);
        
        //Keep model constant for instancing...
        /*if(config::instancing)
            model = glm::translate(glm::mat4(1.0f), glm::vec3(0,0,0));
        else
            model = glm::translate(glm::mat4(1.0f), position);*/
        
        //mvp = projection * view; //* model;
    };
    
    //Call after glUseProgram in onIdle in rigidbodies
    /*void uniformUpdate(GLint &uniform_mvp) {
        glUniformMatrix4fv(uniform_mvp, 1, GL_FALSE, glm::value_ptr(mvp));
    };*/
    
    //glm::mat4 getMVP() { return mvp; };
    
};

#endif /* defined(__openGL_renderer__rigidbody__) */
