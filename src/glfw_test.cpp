//
//  glfw_test.cpp
//  
//
//  Created by NANCY CHEN on 13-09-27.
//  Copyright (c) 2013 University of British Columbia. All rights reserved.
//

#include <iostream>

#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include <glm/glm.hpp>

#include <common/load_compute_shader.h>


#ifdef  __APPLE__
#define SYSTEM  "APPLE"
#else
#define SYSTEM  "NON-APPLE"
#endif

int main(void)
{
    GLFWwindow* window;
    
    /* Initialize the library */
    if (!glfwInit())
        return -1;
    
    /* Create a windowed mode window and its OpenGL context */
    window = glfwCreateWindow(640, 480, "Hello World", NULL, NULL);
    if (!window)
    {
        glfwTerminate();
        return -1;
    }
    
    /* Make the window's context current */
    glfwMakeContextCurrent(window);
    
    
    GLenum err = glewInit();
    
    // Program, vao, vbo
    GLuint render_prog;
    GLuint render_vao;
    GLuint render_vbo;
    GLuint vs;
    GLuint fs;
    
    if (SYSTEM == "APPLE") {
        render_prog = glCreateProgram();
        static const char * render_vs = 
        "#version 120\n"
        "attribute vec3 vertexPosition_modelspace;\n"
        "uniform mat4 MVP;\n"
        "void main(){\n"
        "gl_Position =  MVP * vec4(vertexPosition_modelspace,1);\n"
        "}\n";
        static const char * render_fs =
        "#version 120\n"
        "void main()\n"
        "{\n"
        "gl_FragColor = vec4(1,0,0, 1);\n"
        "}\n";
        
        vs = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vs, 1, &render_vs, NULL);
        glCompileShader(vs);
        glAttachShader(render_prog,vs);
        glDeleteShader(vs);
        
        fs = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fs, 1, &render_fs, NULL);
        glCompileShader(vs);
        glAttachShader(render_prog,fs);
        glDeleteShader(fs);
        
        printf("hey hey");
        
    }
    
    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
        /* Render here */
        
        /* Swap front and back buffers */
        glfwSwapBuffers(window);
        
        /* Poll for and process events */
        glfwPollEvents();
    }
    
    //glDeleteProgram(render_prog);
    glfwTerminate();
    
    
    glm::vec4 Position = glm::vec4(glm::vec3(0.0), 1.0); glm::mat4 Model = glm::mat4(1.0);
    Model[3] = glm::vec4(1.0, 1.0, 0.0, 1.0);
    glm::vec4 Transformed = Model * Position;
    
    
    
    
    return 0;
}