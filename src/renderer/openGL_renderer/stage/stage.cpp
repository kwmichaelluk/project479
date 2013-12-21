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

//Attribute Locations
GLint stage::attribute_coord3d = 0;
//GLint stage::attribute_v_color = 1;
GLint stage::attribute_vertex_uv = 1;
GLint stage::attribute_vertex_normal = 2;

GLint stage::attribute_model = 3;

GLint stage::uniform_view = 0;
GLint stage::uniform_proj = 0;
GLint stage::uniform_texture = 0;
GLint stage::uniform_lightPos = 0;
GLint stage::uniform_alpha = 0;
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
    if ((vs = create_shader((const char*)config::vert_shader_path.string().c_str(), GL_VERTEX_SHADER))   == 0) return 0;
    if ((fs = create_shader((const char*)config::frag_shader_path.string().c_str(), GL_FRAGMENT_SHADER)) == 0) return 0;
    
    //Create Program and Attach Shaders
    shader_program = glCreateProgram();
    glAttachShader(shader_program, vs);
    glAttachShader(shader_program, fs);

    //Bind Attributes
	//std::cout<<config::coord3d.c_str()<<'\n';
    glBindAttribLocation(shader_program, attribute_coord3d, config::coord3d.c_str());
    //glBindAttribLocation(shader_program, attribute_v_color, config::v_color.c_str());
    glBindAttribLocation(shader_program, attribute_vertex_uv, config::vertex_uv.c_str());
    glBindAttribLocation(shader_program, attribute_vertex_normal, config::vertex_normal.c_str());
    glBindAttribLocation(shader_program, attribute_model, config::model_matrix.c_str());

    
    //Link Shader
    glLinkProgram(shader_program);
    glGetProgramiv(shader_program, GL_LINK_STATUS, &link_ok);
    if (!link_ok) {
        fprintf(stderr, "glLinkProgram:");
        print_log(shader_program);
        return 0;
    }
    
    //Check Attributes
    if (glGetAttribLocation(shader_program,config::coord3d.c_str()) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", config::coord3d.c_str());
        return 0;
    }
    /*if (glGetAttribLocation(shader_program,config::v_color.c_str()) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", config::v_color.c_str());
        return 0;
    }*/
    if (glGetAttribLocation(shader_program,config::vertex_uv.c_str()) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", config::vertex_uv.c_str());
        return 0;
    }
    if (glGetAttribLocation(shader_program,config::vertex_normal.c_str()) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", config::vertex_normal.c_str());
        return 0;
    }
    if (glGetAttribLocation(shader_program,config::model_matrix.c_str()) == -1) {
        fprintf(stderr, "Could not bind attribute %s\n", config::model_matrix.c_str());
        return 0;
    }
    
    //Get Uniform Locations
    uniform_view = glGetUniformLocation(shader_program, config::view_matrix.c_str());
    if (uniform_view == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", config::view_matrix.c_str());
        return 0;
    }

    uniform_proj = glGetUniformLocation(shader_program, config::proj_matrix.c_str());
    if (uniform_proj == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", config::proj_matrix.c_str());
        return 0;
    }
    
    uniform_texture = glGetUniformLocation(shader_program, config::texture_sampler.c_str());
    if (uniform_texture == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", config::texture_sampler.c_str());
        return 0;
    }
    
    uniform_lightPos = glGetUniformLocation(shader_program, config::light_pos.c_str());
    if (uniform_lightPos == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", config::light_pos.c_str());
        return 0;
    }
    
    uniform_alpha = glGetUniformLocation(shader_program, config::alpha_chn.c_str());
    if (uniform_alpha == -1) {
        fprintf(stderr, "Could not bind uniform %s\n", config::alpha_chn.c_str());
        return 0;
    }
    
    return 1;
}

int stage::initResources() {
    //glGenVertexArrays(1, &vao);
    //glBindVertexArray(vao);
    
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->init_buffers();
        myBodies.at(i)->bind_buffers(attribute_coord3d,attribute_vertex_uv,attribute_vertex_normal, attribute_model);
    }
    return initShaders();
}

void stage::linkUniforms() {
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->linkUniforms(uniform_view, uniform_proj, uniform_texture, uniform_lightPos, uniform_alpha);
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
        update_step();
    }
}

void stage::update_step() {
    /* Render here */
    onIdle();
    
    /* Swap front and back buffers */
    glfwSwapBuffers(window);
    
    /* Poll for and process events */
    glfwPollEvents();
}

void stage::onIdle() {
    //Update body positions
    for(int i=0;i<numBodyTypes;i++) {
        myBodies.at(i)->updateMVP(myCamera->view, myCamera->projection);
    }
    m_mvp = (myCamera->projection)*(myCamera->view);
    
    //Bind shader program
    glUseProgram(shader_program);
    
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
        myBodies.at(i)->bind_buffers(attribute_coord3d,attribute_vertex_uv,attribute_vertex_normal, attribute_model);
        
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