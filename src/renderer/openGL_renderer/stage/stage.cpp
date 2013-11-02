 //
//  stage.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-11.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "stage.h"

//File Paths
//const char* stage::vert_shader_path = "shaders/cube.vert";
//const char* stage::frag_shader_path = "shaders/cube.frag";

//Initializing Static Values
int stage::screen_width = 800;
int stage::screen_height = 800;
int stage::numBodyTypes = 0;

GLuint stage::program = 0;
GLint stage::attribute_coord3d = 0;
GLint stage::attribute_v_color = 0;
GLint stage::uniform_mvp = 0;

camera* stage::myCamera = NULL;
std::vector<rigidbodies*> stage::myBodies;

void stage::setCamera(camera &cam) {
    myCamera = &cam;
}

void stage::addBody(rigidbodies &body) {
    //(myBodies+1) = &body;
    myBodies.push_back(&body);
    numBodyTypes++;
}

int stage::run() {
    
    char fakeParam[] = "fake";
    char *fakeargv[] = { fakeParam, NULL };
    int fakeargc = 1;
    
    glutInit(&fakeargc, fakeargv);
    glutInitDisplayMode(GLUT_RGBA|GLUT_ALPHA|GLUT_DOUBLE|GLUT_DEPTH);
    glutInitWindowSize(screen_width, screen_height);
    glutCreateWindow("Rendering Engine");
    
    GLenum glew_status = glewInit();
    if (glew_status != GLEW_OK) {
        fprintf(stderr, "Error: %s\n", glewGetErrorString(glew_status));
        return 1;
    }
    
    if (!GLEW_VERSION_2_0) {
        fprintf(stderr, "Error: your graphic card does not support OpenGL 2.0\n");
        return 1;
    }
    
    if (initResources()) {
        glutDisplayFunc(onDisplay);
        glutReshapeFunc(onReshape);
        glutIdleFunc(onIdle);
        glEnable(GL_BLEND);
        glEnable(GL_DEPTH_TEST);
        //glDepthFunc(GL_LESS);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        glutMainLoop();
    }
    
    freeResources();
    return 0;
}

//
bool stage::initShaders() {
    //Link Shaders
    GLint link_ok = GL_FALSE;
    
    GLuint vs, fs;
    if ((vs = create_shader(config::vert_shader_path.c_str(), GL_VERTEX_SHADER))   == 0) return 0;
    if ((fs = create_shader(config::frag_shader_path.c_str(), GL_FRAGMENT_SHADER)) == 0) return 0;
    
    program = glCreateProgram();
    glAttachShader(program, vs);
    glAttachShader(program, fs);
    glLinkProgram(program);
    glGetProgramiv(program, GL_LINK_STATUS, &link_ok);
    if (!link_ok) {
        fprintf(stderr, "glLinkProgram:");
        print_log(program);
        return 0;
    }
    
    const char* attribute_name;
    attribute_name = "coord3d";
    attribute_coord3d = glGetAttribLocation(program, attribute_name);
    if (attribute_coord3d == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", attribute_name);
        return 0;
    }
    attribute_name = "v_color";
    attribute_v_color = glGetAttribLocation(program, attribute_name);
    if (attribute_v_color == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", attribute_name);
        return 0;
    }
    const char* uniform_name;
    uniform_name = "mvp";
    uniform_mvp = glGetUniformLocation(program, uniform_name);
    if (uniform_mvp == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", uniform_name);
        return 0;
    }
    
    return 1;
}

int stage::initResources() {
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->init_buffers();
    }
    return initShaders();
}

void stage::onIdle() {
    for(int i=0;i<numBodyTypes;i++) {

        myBodies.at(i)->updateMVP(myCamera->view
                                 , myCamera->projection);
    }
    
    glUseProgram(program);
    
    for( int i=0; i<numBodyTypes; i++) {

        myBodies.at(i)->updateUniform(uniform_mvp);
    }
    
    glutPostRedisplay();
}

void stage::onDisplay() {
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(program);
    
    //Draw Stuff Here
    for( int i=0; i<numBodyTypes; i++) {   
        myBodies.at(i)->initDrawBodies(attribute_coord3d,attribute_v_color,uniform_mvp);
    }
    
    glDisableVertexAttribArray(attribute_coord3d);
    glDisableVertexAttribArray(attribute_v_color);
    
    glutSwapBuffers();
}

void stage::onReshape(int width, int height) {
    screen_width = width;
    screen_height = height;
    glViewport(0, 0, screen_width, screen_height);
}

void stage::freeResources() {
    glDeleteProgram(program);
    
    for( int i=0; i<numBodyTypes; i++) {
        myBodies.at(i)->free_resources();
    }
}