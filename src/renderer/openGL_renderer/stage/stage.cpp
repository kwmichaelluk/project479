//
//  stage.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-11.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "stage.h"

//Initializing Static Values
int stage::screen_width = 800;
int stage::screen_height = 800;
int stage::numBodyTypes = 0;

GLuint stage::shader_program = 0;
GLint stage::attribute_coord3d = 0;
GLint stage::attribute_v_color = 1;
GLint stage::attribute_positions = 2;

GLint stage::uniform_view = 0;
GLint stage::uniform_proj = 0;
glm::mat4 stage::m_mvp;

camera* stage::myCamera = NULL;
std::vector<rigidbodies*> stage::myBodies;
GLFWwindow* stage::window = NULL;

void stage::setCamera(camera &cam) {
    myCamera = &cam;
}

void stage::addBody(rigidbodies &body) {
    //(myBodies+1) = &body;
    myBodies.push_back(&body);
    numBodyTypes++;
}

int stage::run() {
    //Initialize GLFW
    if(!glfwInit())
        throw std::runtime_error("glfwInit failed");
    
    //Create Window
    window = glfwCreateWindow(screen_width, screen_height, "Renderer", NULL, NULL);
    if (!window) {
        glfwTerminate();
        exit(EXIT_FAILURE);
    }
    glfwMakeContextCurrent(window);
    
    //Enable V-Sync
    glfwSwapInterval(1);
    
    //Initialize GLEW
    glewExperimental = GL_TRUE;
    GLenum glew_status = glewInit();
    if (glew_status != GLEW_OK) {
        fprintf(stderr, "Error: %s\n", glewGetErrorString(glew_status));
        return 1;
    }
    if (!GLEW_VERSION_2_0) {
        fprintf(stderr, "Error: your graphic card does not support OpenGL 2.0\n");
        return 1;
    }
    
    //Begin Process
    if(initResources()) {
        linkUniforms();
        
        init_glSettings();
        
        update_loop();
    }
    
    freeResources();
    glfwDestroyWindow(window);
    glfwTerminate();

    return 0;
}

bool stage::initShaders() {
    //Link Shaders
    GLint link_ok = GL_FALSE;
    
    GLuint vs, fs;
    if ((vs = create_shader(config::vert_shader_path.c_str(), GL_VERTEX_SHADER))   == 0) return 0;
    if ((fs = create_shader(config::frag_shader_path.c_str(), GL_FRAGMENT_SHADER)) == 0) return 0;
    
    shader_program = glCreateProgram();
    glAttachShader(shader_program, vs);
    glAttachShader(shader_program, fs);
    glLinkProgram(shader_program);
    glGetProgramiv(shader_program, GL_LINK_STATUS, &link_ok);
    if (!link_ok) {
        fprintf(stderr, "glLinkProgram:");
        print_log(shader_program);
        return 0;
    }
    
    const char* attribute_name;
    attribute_name = "coord3d";
    //attribute_coord3d = glGetAttribLocation(shader_program, attribute_name);
    glBindAttribLocation(shader_program, attribute_coord3d, attribute_name);
    if (glGetAttribLocation(shader_program,attribute_name) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", attribute_name);
        return 0;
    }
    attribute_name = "v_color";
    //attribute_v_color = glGetAttribLocation(shader_program, attribute_name);
    glBindAttribLocation(shader_program, attribute_v_color, attribute_name);
    if (glGetAttribLocation(shader_program,attribute_name) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", attribute_name);
        return 0;
    }
    if(config::instancing) {
        attribute_name = "m_pos";
        //attribute_v_color = glGetAttribLocation(shader_program, attribute_name);
        glBindAttribLocation(shader_program, attribute_positions, attribute_name);
        if (glGetAttribLocation(shader_program,attribute_name) == -1) {
            fprintf(stderr, "Could not bind attribute %s\n", attribute_name);
            return 0;
        }
    }
    
    const char* uniform_name;
    uniform_name = "view_matrix";
    uniform_view = glGetUniformLocation(shader_program, uniform_name);
    if (uniform_view == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", uniform_name);
        return 0;
    }
    uniform_name = "proj_matrix";
    uniform_proj = glGetUniformLocation(shader_program, uniform_name);
    if (uniform_proj == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", uniform_name);
        return 0;
    }
    
    return 1;
}

int stage::initResources() {
    //glGenVertexArrays(1, &vao);
    //glBindVertexArray(vao);
    
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->init_buffers();
        myBodies.at(i)->bind_buffers(attribute_coord3d,attribute_v_color, attribute_positions);
    }
    return initShaders();
}

void stage::linkUniforms() {
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->linkUniforms(uniform_view, uniform_proj);
    }
}

void stage::init_glSettings() {
    glEnable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

//Update Loop
void stage::update_loop() {
    while (!glfwWindowShouldClose(window)) {
        /* Render here */
        onIdle();
        
        /* Swap front and back buffers */
        glfwSwapBuffers(window);
        
        /* Poll for and process events */
        glfwPollEvents();
    }
}

void stage::onIdle() {
    //Update body positions
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->updateMVP(myCamera->view, myCamera->projection);
    }
    m_mvp = (myCamera->projection)*(myCamera->view);
    
    //Bind shader program
    glUseProgram(shader_program);
    
    /*for( int i=0; i<numBodyTypes; i++) {
        myBodies.at(i)->updateUniform(uniform_mvp);
    }*/
    
    //Draw Again
    updateDraw();
    
    //Unbind shader
    glUseProgram(0);
}

//Private method - used in onIdle()
void stage::updateDraw() {
    //Clear Screen
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
    //glUseProgram(program);
    
    //Draw Stuff Here - NOTE: Each "bodies" each has their own VAO
    for( int i=0; i<numBodyTypes; i++) {
        myBodies.at(i)->initDrawBodies(myCamera->view,myCamera->projection);
    }
    
    //glUseProgram(0);
    
    //glDisableVertexAttribArray(attribute_coord3d);
    //glDisableVertexAttribArray(attribute_v_color);
}

void stage::onReshape(int width, int height) {
    screen_width = width;
    screen_height = height;
    glViewport(0, 0, screen_width, screen_height);
}

void stage::freeResources() {
    glDeleteProgram(shader_program);
    
    for( int i=0; i<numBodyTypes; i++) {
        myBodies.at(i)->free_resources();
    }
}