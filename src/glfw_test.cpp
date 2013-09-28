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
    
    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
        /* Render here */
        
        /* Swap front and back buffers */
        glfwSwapBuffers(window);
        
        /* Poll for and process events */
        glfwPollEvents();
    }
    
    glfwTerminate();
    
    glm::vec4 Position = glm::vec4(glm::vec3(0.0), 1.0); glm::mat4 Model = glm::mat4(1.0);
    Model[3] = glm::vec4(1.0, 1.0, 0.0, 1.0);
    glm::vec4 Transformed = Model * Position;
    
    GLenum err = glewInit();
    
    return 0;
}