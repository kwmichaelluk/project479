//
//  cube.h
//  openGL_renderer
//
//  Created by Michael Luk on 2013-09-10.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__cube__
#define __openGL_renderer__cube__

#include <iostream>
#include "rigidbodies.h"

#include <GL/glew.h>
#include <GLUT/glut.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "../tools/camera.h"

class cube : public rigidbodies {
private:
    
public:
    cube(int size, GLint uniform_mvp) : rigidbodies(size, uniform_mvp) {};
    
    void init_buffers();
    

};

#endif /* defined(__openGL_renderer__cube__) */
