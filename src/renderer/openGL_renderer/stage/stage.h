//
//  stage.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-11.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

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

class stage {
private:
    //static const char *vert_shader_path;
    //static const char *frag_shader_path;

public:
    //Screen Size
    static int screen_width;
    static int screen_height;
    
private:
    //For Rendering
    static camera *myCamera;
    //static rigidbodies* myBodies;
    static std::vector<rigidbodies*> myBodies;
    static int numBodyTypes;
    static GLFWwindow* window;
    
public:
    //Declare Shader Variables
    static GLuint program;
    static GLint attribute_coord3d;
    static GLint attribute_v_color;
    static GLint uniform_mvp;
    
public:
    static void initStage();
    
    static void setCamera(camera &cam);
    static void addBody(rigidbodies &body);
    
    //Call after all initializations complete
    static int run();
    
private:
    //Below methods are used in run()
    static bool initShaders(); //Called in initResources()
    static int initResources();
    
    //Update loop
    static void update();
    
    static void onIdle();
    
    static void updateDraw();
    
    static void onReshape(int width, int height);
    
    static void freeResources();
};

#endif /* defined(__openGL_renderer__stage__) */
