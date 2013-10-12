//
//  rigidbodies.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-09.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//
//  Base abstract class for OpenGL shapes

#ifndef __openGL_renderer__rigidbodies__
#define __openGL_renderer__rigidbodies__

#include <iostream>
#include <GL/glew.h>
#include <GLUT/glut.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "rigidbody.h"
#include "../tools/camera.h"


class rigidbodies {
protected:
    GLuint vao;
    
    //Holds all instances of the same rigid body
    GLuint vbo_vertices;
    GLuint vbo_colors;
    GLuint ibo_elements;
    
    
    rigidbody *myBodies;
    int size; //Number of bodies within vbo
    
private:
    //Helper methods
    
    //Call at end of constructor (REMOVE?!?!)
    double* def_val_x = new double(-3.0);
    double* def_val_y = new double(-3.0);
    double* def_val_z = new double(-8.0);
    
    void init_rigidBody(GLint &uniform_mvp) {
        for(int i=0;i<size;i++) {
            //(myBodies+i)->setUniformMvp(uniform_mvp);
            //(myBodies+i)->setPosition(i*2.5f, -3.0, -8.0);
            (myBodies+i)->setPosition(def_val_x, def_val_y, def_val_z);
        }
    }
    
public:
    rigidbodies(int size, GLint &uniform_mvp) {
        this->size = size;
        myBodies = new rigidbody[size];
        
        init_rigidBody(uniform_mvp);
    };
    
    //Initializes vbo, ibo buffers and vertices (shape)
    virtual void init_buffers() = 0;
    
    void updateMVP(glm::mat4 &view, glm::mat4 &projection) {
        //Update all MVP
        for(int i=0;i<size;i++) {
            (myBodies+i)->update(view, projection);
        }
    }
    
    void updateUniform(GLint &uniform_mvp) {
        for(int i=0;i<size;i++) {
            //glUniformMatrix4fv(uniform_mvp, 1, GL_FALSE, glm::value_ptr((myBodies+i)->mvp));
            (myBodies+i)->uniformUpdate(uniform_mvp);
        }
    }
    
    void initDrawBodies(GLint &attribute_coord3d, GLint &attribute_v_color, GLint &uniform_mvp) {
        for(int i=0; i<size; i++) {
            //Set Box To Draw
            //glUniformMatrix4fv(uniform_mvp, 1, GL_FALSE, glm::value_ptr((myBodies+i)->mvp));
            (myBodies+i)->uniformUpdate(uniform_mvp);
            
            glEnableVertexAttribArray(attribute_coord3d);
            // Describe our vertices array to OpenGL (it can't guess its format automatically)
            glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices);
            glVertexAttribPointer(
                                  attribute_coord3d, // attribute
                                  3,                 // number of elements per vertex, here (x,y,z)
                                  GL_FLOAT,          // the type of each element
                                  GL_FALSE,          // take our values as-is
                                  0,                 // no extra data between each position
                                  0                  // offset of first element
                                  );
            
            glEnableVertexAttribArray(attribute_v_color);
            glBindBuffer(GL_ARRAY_BUFFER, vbo_colors);
            glVertexAttribPointer(
                                  attribute_v_color, // attribute
                                  3,                 // number of elements per vertex, here (R,G,B)
                                  GL_FLOAT,          // the type of each element
                                  GL_FALSE,          // take our values as-is
                                  0,                 // no extra data between each position
                                  0                  // offset of first element
                                  );
            
            /* Push each element in buffer_vertices to the vertex shader */
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo_elements);
            int size;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &size);
            
            glBindVertexArray(vao);
            glDrawElements(GL_TRIANGLES, size/sizeof(GLushort), GL_UNSIGNED_SHORT, 0);
            
            //glDrawArrays(GL_TRIANGLES, 0, size/sizeof(GLushort));
        }
    };
    
    void free_resources() {
        glDeleteBuffers(1, &vbo_vertices);
        glDeleteBuffers(1, &vbo_colors);
        glDeleteBuffers(1, &ibo_elements);
    };  //Call on destroy
    
    /*void setPosition(glm::vec3 pos, int index) {
        if(index < size)
            (myBodies+index)->setPosition(pos.x, pos.y, pos.z);
    }*/
    
    void linkPosition(double *pos_x, double *pos_y, double *pos_z, int index) {
        if(index < size)
            (myBodies+index)->setPosition(pos_x, pos_y, pos_z);
    }
};
#endif /* defined(__openGL_renderer__rigidbodies__) */
