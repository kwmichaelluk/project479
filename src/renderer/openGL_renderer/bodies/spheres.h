//
//  spheres.h
//  openGL_renderer
//
//  Created by Michael Luk on 11/2/2013.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__spheres__
#define __openGL_renderer__spheres__

#include <iostream>
#include "rigidbodies.h"

#include <GL/glew.h>
//#include <GLUT/glut.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "../tools/camera.h"

#include "texture.hpp"
#include "objloader.hpp"

#include "../config/config.h"

class spheres : public rigidbodies {
private:
    
public:
    spheres(int size) : rigidbodies(size) {
        alphaChn = 0.0f;
    }
    
    void init_buffers();
    
    
};


#endif /* defined(__openGL_renderer__spheres__) */
