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
#include <glm/gtc/quaternion.hpp>  
#include <glm/gtx/quaternion.hpp>

<<<<<<< HEAD

=======
>>>>>>> link/ctrlr

class rigidbody {
private:
    double *pos_x;
    double *pos_y;
    double *pos_z;
    glm::vec3 position;
    
<<<<<<< HEAD
    float scaleSize;
=======
    double *scaleSize;
    
    double *pitch, *yaw, *roll;
    glm::quat myQuaternion;
>>>>>>> link/ctrlr
    
public:
    glm::mat4 model_matrix;
    glm::mat4 scale_matrix;
    glm::mat4 rotate_matrix;
    
public:
    rigidbody() {
<<<<<<< HEAD
        scaleSize=1.0;
        scale_matrix = glm::scale(glm::mat4(1.0f),glm::vec3(scaleSize));
=======
        scaleSize = new double;
        *scaleSize=1.0;
        scale_matrix = glm::scale(glm::mat4(1.0f),glm::vec3(*scaleSize));
        
        pitch = new double; roll = new double; yaw = new double;
>>>>>>> link/ctrlr
    };
    
    void setPosition(double *x, double *y, double *z) {
        pos_x=x; pos_y=y; pos_z=z;
    }
    
<<<<<<< HEAD
    void setSize(float size) {
        scaleSize = size;
        scale_matrix = glm::scale(glm::mat4(1.0f),glm::vec3(scaleSize));
=======
    void setAngles(double *pitch, double *yaw, double *roll) {
        this->pitch = pitch;
        this->yaw = yaw;
        this->roll = roll;
    }
    
    void setSize(double *size) {
        scaleSize = size;
        scale_matrix = glm::scale(glm::mat4(1.0f),glm::vec3(*scaleSize));
>>>>>>> link/ctrlr
    }
    
    //Update MVP and Position (Position no longer part of MVP)
    void update(glm::mat4 &view, glm::mat4 &projection) {
        //Update position data
        position.x = *pos_x;
        position.y = *pos_y;
        position.z = *pos_z;
        
<<<<<<< HEAD
        glm::vec3 rotate_axis(1.0, 0.0, 0.0);
        rotate_matrix = glm::rotate(glm::mat4(1.0f), 14.0f, rotate_axis);
=======
        //Update Euler Angles
        glm::vec3 eulerAngles(*pitch,*yaw,*roll);
        myQuaternion = glm::quat(eulerAngles);
        
        //glm::vec3 rotate_axis(1.0, 0.0, 0.0);
        //rotate_matrix = glm::rotate(glm::mat4(1.0f), 14.0f, rotate_axis);
        rotate_matrix = glm::toMat4(myQuaternion);
>>>>>>> link/ctrlr

        model_matrix = glm::translate(glm::mat4(1.0f), position) * rotate_matrix * scale_matrix;
    };

    
};

#endif /* defined(__openGL_renderer__rigidbody__) */
