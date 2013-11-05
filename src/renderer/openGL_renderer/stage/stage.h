//
//  stage.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-11.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//
//  STAGE is for controlling OpenGL Rendering of Rigid Bodies, and controlling GLFW and initializing GLEW

#ifndef __openGL_renderer__stage__
#define __openGL_renderer__stage__

#include <iostream>

#include "../tools/camera.h"
#include "../tools/shader_utils.h"
#include "../bodies/rigidbodies.h"

#include <GL/glew.h>
//#include <GLUT/glut.h>
#include <GLFW/glfw3.h>

#include <vector>
#include "../config/config.h"

#include "../bodies/texture.hpp"
#include "../bodies/objloader.hpp"

class stage {
public:
    //Screen Size
    static int screen_width;
    static int screen_height;
    
private:
    //For Rendering
    static camera *myCamera;
    static std::vector<rigidbodies*> myBodies;
    static int numBodyTypes;
    static GLFWwindow* window;
    
public:
    //Declare Shader Variables
    static GLuint shader_program;
    static GLint attribute_coord3d;
    static GLint attribute_v_color;
    static GLint attribute_vertex_uv;

    static GLint attribute_model;
    
    static GLint uniform_view, uniform_proj, uniform_texture;
    static glm::mat4 m_mvp;
    //static GLuint vao;
    
public:
    static void initStage();
    
    static void setCamera(camera &cam);
    static void addBody(rigidbodies &body);
    
    //Call after all initializations complete
    static int run();
    
private:
    //Below methods are used in run()
    static bool initShaders(); //Called in initResources()

    
    //Update loop
    static void update_loop();
    
    
    static void onIdle();
    static void updateDraw(); //Called in onIdle
    
    static void onReshape(int width, int height); //TODO: Implement on Window resize
    

    
public:
    static int initResources();
    
    static void linkUniforms();
    
    static void init_glSettings();
    
    static void update_step();
    static void freeResources();
};

#endif /* defined(__openGL_renderer__stage__) */
