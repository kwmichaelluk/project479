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
#include <vector>

class rigidbodies {
protected:
    GLuint vao;
    
    //Holds all instances of the same rigid body
    GLuint vbo_vertices;
    GLuint vbo_colors;
    GLuint ibo_elements;
    
    //FOr instancing
//    GLuint vbo_positions;
    GLuint vbo_models;
    
    rigidbody *myBodies;
    int size; //Number of bodies within vbo
    
    //Holds position data
//    std::vector<glm::vec3> positions;
    
    //MVP
    //glm::mat4 m_mvp;
    
    GLint *uniform_view;
    GLint *uniform_proj;
private:
    //Helper methods
    
    //Call at end of constructor (REMOVE?!?!)
    double* def_val_x = new double(-3.0);
    double* def_val_y = new double(-3.0);
    double* def_val_z = new double(-8.0);
    
    void init_rigidBody() {
        for(int i=0;i<size;i++) {
            //(myBodies+i)->setUniformMvp(uniform_mvp);
            //(myBodies+i)->setPosition(i*2.5f, -3.0, -8.0);
            (myBodies+i)->setPosition(def_val_x, def_val_y, def_val_z);
        }
    }
    
    void drawBodies(glm::mat4 &view,glm::mat4 &proj) {

        if(config::instancing)
            drawBodiesInstanced(view,proj);

    }
    
    void drawBodiesInstanced(glm::mat4 &view,glm::mat4 &proj) {
        glBindBuffer(GL_ARRAY_BUFFER, vbo_models);
        
        glm::mat4 * modelmap = (glm::mat4 *)glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);
        for (int n = 0; n < size; n++)
        {
            modelmap[n] = (myBodies+n)->model_matrix;
        }
        
        glUnmapBuffer(GL_ARRAY_BUFFER);
        
        glUniformMatrix4fv(*uniform_view, 1, GL_FALSE, glm::value_ptr(view));
        glUniformMatrix4fv(*uniform_proj, 1, GL_FALSE, glm::value_ptr(proj));
        
        /*for( int c = 0; c < size; c++ ) {
            positions[c] = glm::vec3(0,0,0);
        }*/
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo_elements);
        int isize;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &isize);
        
        //glBindBuffer( GL_ARRAY_BUFFER, vbo_positions );
        //glBufferData( GL_ARRAY_BUFFER, sizeof( glm::vec4 ) * size, &positions[0][0], GL_DYNAMIC_DRAW );
        
        glDrawElementsInstanced(GL_TRIANGLES, isize/sizeof(GLushort), GL_UNSIGNED_SHORT, 0, size);
    }
    
    
public:
    rigidbodies(int size) {
        this->size = size;
        myBodies = new rigidbody[size];
        
        //positions.resize(size);
        
        init_rigidBody();
        
    };
    
    //Initializes vbo, ibo buffers and vertices (shape)
    virtual void init_buffers() {
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);
    }
    
    void bind_buffers(GLint &attribute_coord3d, GLint &attribute_v_color, GLint &attribute_model) {
        glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices);
        glEnableVertexAttribArray(attribute_coord3d);
        // Describe our vertices array to OpenGL (it can't guess its format automatically)
        glVertexAttribPointer(
                              attribute_coord3d, // attribute
                              3,                 // number of elements per vertex, here (x,y,z)
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              0,                 // no extra data between each position
                              0                  // offset of first element
                              );
        
        glBindBuffer(GL_ARRAY_BUFFER, vbo_colors);
        glEnableVertexAttribArray(attribute_v_color);
        glVertexAttribPointer(
                              attribute_v_color, // attribute
                              3,                 // number of elements per vertex, here (R,G,B)
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              0,                 // no extra data between each position
                              0                  // offset of first element
                              );
        
        //Instanced Position...
        /*glGenBuffers( 1, &vbo_positions );
        glBindBuffer( GL_ARRAY_BUFFER, vbo_positions );

        glEnableVertexAttribArray( attribute_positions );
        glVertexAttribPointer(
                              attribute_positions, // attribute
                              3,
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              sizeof(glm::vec3),
                              0                  // offset of first element
                              );
        glVertexAttribDivisor(attribute_positions,1);*/
        
        
        
        glGenBuffers( 1, &vbo_models );
        glBindBuffer( GL_ARRAY_BUFFER, vbo_models );
        glBufferData(GL_ARRAY_BUFFER, size * sizeof(glm::mat4), NULL, GL_DYNAMIC_DRAW);
        char* pp=0;
        GLsizei ss = sizeof(glm::mat4);
        for(int i=0;i<4;i++) {
            glEnableVertexAttribArray( attribute_model+i );
            glVertexAttribPointer(
                                  attribute_model+i, // attribute
                                  4,
                                  GL_FLOAT,          // the type of each element
                                  GL_FALSE,          // take our values as-is
                                  ss,
                                  pp+(i*sizeof(glm::vec4))                // offset of first element
                                  );
            glVertexAttribDivisor(attribute_model+i,1);
        }
        
    }
    
    void linkUniforms(GLint &uniform_view, GLint &uniform_proj) {
        this->uniform_view = &uniform_view;
        this->uniform_proj = &uniform_proj;
    }
    
    void updateMVP(glm::mat4 &view, glm::mat4 &projection) {
        //Update all MVP
        for(int i=0;i<size;i++) {
            (myBodies+i)->update(view, projection);
        }
        //m_mvp = projection*view;
    }
    
    void updateUniform(GLint &uniform_mvp) {
        /*for(int i=0;i<size;i++) {
            //glUniformMatrix4fv(uniform_mvp, 1, GL_FALSE, glm::value_ptr((myBodies+i)->mvp));
            (myBodies+i)->uniformUpdate(uniform_mvp);
        }*/
        
    }
    
    void initDrawBodies(glm::mat4 &view,glm::mat4 &proj) {
        glBindVertexArray(vao); //Bind VAO
        
        drawBodies(view,proj);
        
        glBindVertexArray(0); //Unbind VAO
    };
    
    void free_resources() {
        glDeleteBuffers(1, &vbo_vertices);
        glDeleteBuffers(1, &vbo_colors);
        glDeleteBuffers(1, &ibo_elements);
        //glDeleteBuffers(1, &vbo_positions);
        glDeleteBuffers(1, &vbo_models);
    };  //Call on destroy
    
    //Link the position of a specific object at INDEX
    void linkPosition(double *pos_x, double *pos_y, double *pos_z, int index) {
        if(index < size) {
            (myBodies+index)->setPosition(pos_x, pos_y, pos_z);
            //positions[index] = glm::vec4(*pos_x,*pos_y,*pos_z,0);
        }
    }
    
};
#endif /* defined(__openGL_renderer__rigidbodies__) */
