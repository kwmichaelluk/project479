//
//  spheres.cpp
//  openGL_renderer
//
//  Created by Michael Luk on 11/2/2013.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#include "spheres.h"

void spheres::init_buffers() {
    rigidbodies::init_buffers();
    
    std::vector<glm::vec3> vertices;
	std::vector<glm::vec2> uvs;
	std::vector<glm::vec3> normals;
	
    loadOBJ((const char*)config::sphere_obj_path.string().c_str(), vertices, uvs, normals);
    
    //Load Texture
    myTexture = loadBMP_custom((const char*)config::sphere_texture_path.string().c_str());
    
    //Bind Vertex Data
	std::cout<<vertices.size()<<"\n";
    glGenBuffers(1, &vbo_vertices);
	glBindBuffer(GL_ARRAY_BUFFER, vbo_vertices);
	glBufferData(GL_ARRAY_BUFFER, vertices.size() * sizeof(glm::vec3), &vertices[0], GL_STATIC_DRAW);
    
	std::cout<<uvs.size()<<"\n";
    //Bind UV Data
    glGenBuffers(1, &vbo_uv);
    glBindBuffer(GL_ARRAY_BUFFER, vbo_uv);
    glBufferData(GL_ARRAY_BUFFER, uvs.size() * sizeof(glm::vec2), &uvs[0], GL_STATIC_DRAW);
    
	std::cout<<normals.size()<<"\n";
    //Bind Normals
    glGenBuffers(1, &vbo_normals);
	glBindBuffer(GL_ARRAY_BUFFER, vbo_normals);
	glBufferData(GL_ARRAY_BUFFER, normals.size() * sizeof(glm::vec3), &normals[0], GL_STATIC_DRAW);
}