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
//#include <GLUT/glut.h>

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
    GLuint vbo_uv;
    GLuint vbo_normals;
    
    GLuint vbo_models;
    
    GLuint myTexture;
    
    rigidbody *myBodies;
    int instance_size; //Number of bodies within vbo
    
    GLint *uniform_view;
    GLint *uniform_proj;
    GLint *uniform_texture;
    GLint *uniform_lightPos;
    
    glm::vec3 lightPos;
private:
    //Helper methods
    
    //Call at end of constructor (REMOVE?!?!)
    //double* def_val_x = new double(-3.0);
    //double* def_val_y = new double(-3.0);
    //double* def_val_z = new double(-8.0);
    
    void init_rigidBody() {
        for(int i=0;i<instance_size;i++) {
            //(myBodies+i) = new rigidbody();
            
        }
    }
    
    void drawBodies(glm::mat4 &view,glm::mat4 &proj) {
        drawBodiesInstanced(view,proj);
    }
    
    void drawBodiesInstanced(glm::mat4 &view,glm::mat4 &proj) {
        glBindBuffer(GL_ARRAY_BUFFER, vbo_models);
        glm::mat4 * modelmap = (glm::mat4 *)glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);
        for (int n = 0; n < instance_size; n++)
        {
            modelmap[n] = (myBodies+n)->model_matrix;
        }
        
        glUnmapBuffer(GL_ARRAY_BUFFER);
        
        glUniformMatrix4fv(*uniform_view, 1, GL_FALSE, glm::value_ptr(view));
        glUniformMatrix4fv(*uniform_proj, 1, GL_FALSE, glm::value_ptr(proj));
        
        //Lighting
        
		glUniform3f(*uniform_lightPos, lightPos.x, lightPos.y, lightPos.z);
        
        //Texture
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, myTexture);
        glUniform1i(*uniform_texture, 0);
        
        
        //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo_elements);
        //int isize;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &isize);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vbo_vertices);
        int isize;  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, &isize);
        
        //glDrawElementsInstanced(GL_TRIANGLES, isize/sizeof(GLushort), GL_UNSIGNED_SHORT, 0, instance_size);
        glDrawArraysInstanced(GL_TRIANGLES, 0, isize/sizeof(GLushort), instance_size);
    }
    
    
public:
    rigidbodies(int size) {
        this->instance_size = size;
        myBodies = new rigidbody[instance_size];
        
        init_rigidBody();
<<<<<<< HEAD
        setLighting(4,4,-14);
=======
        setLighting(-9,-7,0);
>>>>>>> link/ctrlr
    };
    
    //Initializes vbo, ibo buffers and vertices (shape)
    virtual void init_buffers() {
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);
    }
    
    void bind_buffers(GLint &attribute_coord3d, GLint &attribute_vertex_uv, GLint &attribute_vertex_normal, GLint &attribute_model) {
        glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices);
        glEnableVertexAttribArray(attribute_coord3d);
        // Describe our vertices array to OpenGL (it can't guess its format automatically)
        glVertexAttribPointer(
                              attribute_coord3d, // attribute
                              3,                 // number of elements per vertex, here (x,y,z)
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              3*sizeof(GLfloat),         
                              0                  // offset of first element
                              );
        
        glBindBuffer(GL_ARRAY_BUFFER, vbo_uv);
        glEnableVertexAttribArray(attribute_vertex_uv);
<<<<<<< HEAD
        glVertexAttribPointer(
                              attribute_vertex_uv, // attribute
                              2,                 // number of elements per vertex, here (R,G,B)
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              2*sizeof(GLfloat),
                              0                  // offset of first element
                              );
        
        glBindBuffer(GL_ARRAY_BUFFER, vbo_normals);
        glEnableVertexAttribArray(attribute_vertex_normal);
        glVertexAttribPointer(
=======
        glVertexAttribPointer(
                              attribute_vertex_uv, // attribute
                              2,                 // number of elements per vertex, here (R,G,B)
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              2*sizeof(GLfloat),
                              0                  // offset of first element
                              );
        
        glBindBuffer(GL_ARRAY_BUFFER, vbo_normals);
        glEnableVertexAttribArray(attribute_vertex_normal);
        glVertexAttribPointer(
>>>>>>> link/ctrlr
                              attribute_vertex_normal, // attribute
                              3,                 // number of elements per vertex, here (R,G,B)
                              GL_FLOAT,          // the type of each element
                              GL_FALSE,          // take our values as-is
                              3*sizeof(GLfloat),
                              0                  // offset of first element
                              );
        
        
        
        //Instanced Model Matrix...
        glGenBuffers( 1, &vbo_models );
        glBindBuffer( GL_ARRAY_BUFFER, vbo_models );
        glBufferData(GL_ARRAY_BUFFER, instance_size * sizeof(glm::mat4), NULL, GL_DYNAMIC_DRAW);
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
    
    void linkUniforms(GLint &uniform_view, GLint &uniform_proj, GLint &uniform_texture, GLint &uniform_lightPos) {
        this->uniform_view = &uniform_view;
        this->uniform_proj = &uniform_proj;
        this->uniform_texture = &uniform_texture;
        this->uniform_lightPos = &uniform_lightPos;
    }
    
    void updateMVP(glm::mat4 &view, glm::mat4 &projection) {
        //Update all MVP
        for(int i=0;i<instance_size;i++) {
            (myBodies+i)->update(view, projection);
        }
        //m_mvp = projection*view;
    }
    
    void initDrawBodies(glm::mat4 &view,glm::mat4 &proj) {
        glBindVertexArray(vao); //Bind VAO
        
        drawBodies(view,proj);
        
        glBindVertexArray(0); //Unbind VAO
    };
    
    void free_resources() {
        glDeleteBuffers(1, &vbo_vertices);
        //glDeleteBuffers(1, &vbo_colors);
        //glDeleteBuffers(1, &ibo_elements);
        glDeleteBuffers(1, &vbo_uv);
        glDeleteBuffers(1, &vbo_models);
    };  //Call on destroy
    
    void setLighting(float x, float y, float z) {
        lightPos = glm::vec3(x,y,z);
    }
    
    //Link the position of a specific object at INDEX
    void linkPosition(double *pos_x, double *pos_y, double *pos_z, int index) {
        if(index < instance_size) {
            (myBodies+index)->setPosition(pos_x, pos_y, pos_z);
        }
    }
    
<<<<<<< HEAD
=======
    void linkSize(double *size, int index) {
        if(index < instance_size) {
            (myBodies+index)->setSize(size);
        }
    }
    
    void linkRotation(double *roll, double *pitch, double *yaw, int index) {
        if(index < instance_size) {
            (myBodies+index)->setAngles(pitch, yaw, roll);
        }
    }
    
>>>>>>> link/ctrlr

};
#endif /* defined(__openGL_renderer__rigidbodies__) */
