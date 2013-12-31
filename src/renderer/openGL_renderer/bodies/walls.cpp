//
//  walls.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 11/20/2013.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "walls.h"

void walls::init_buffers() {
    rigidbodies::init_buffers();
    
    
    GLfloat my_vertices[] = {
        -1.0f,-1.0f, 0.0f,
        -1.0f, 1.0f, 0.0f,
         1.0f, 1.0f, 0.0f,
        -1.0f,-1.0f, 0.0f,
         1.0f, 1.0f, 0.0f,
         1.0f,-1.0f, 0.0f,
    };
    
    GLfloat my_uv[] = {
        0.0,  1.0,
        1.0,  0.0,
        0.0,  1.0,
        1.0,  0.0,
        0.0,  1.0,
        1.0,  0.0,
    };
    
    GLfloat my_normal[] = {
        0.0, -1.0,  0.0,
        0.0, -1.0,  0.0,
        0.0, -1.0,  0.0,
        0.0, -1.0,  0.0,
        0.0, -1.0,  0.0,
        0.0, -1.0,  0.0,
    };

    //std::vector<glm::vec3> vertices;
	//std::vector<glm::vec2> uvs;
	//std::vector<glm::vec3> normals;
	
    //loadOBJ("sphere.obj", vertices, uvs, normals);
    
    //Load Texture
    myTexture = loadBMP_custom((const char*)config::sphere_texture_path.c_str());
    
    //Bind Vertex Data
    glGenBuffers(1, &vbo_vertices);
	glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices);
	glBufferData(GL_ARRAY_BUFFER, sizeof(my_vertices), my_vertices, GL_STATIC_DRAW);
    
    //Bind UV Data
    glGenBuffers(1, &vbo_uv);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_uv);
    glBufferData(GL_ARRAY_BUFFER, sizeof(my_uv), my_uv, GL_STATIC_DRAW);
    
    //Bind Normals
    glGenBuffers(1, &vbo_normals);
	glBindBuffer(GL_ARRAY_BUFFER, vbo_normals);
	glBufferData(GL_ARRAY_BUFFER, sizeof(my_normal), my_normal, GL_STATIC_DRAW);
}