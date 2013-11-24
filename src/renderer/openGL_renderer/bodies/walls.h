//
//  walls.h
//  openGL_renderer
//
//  Created by Michael Luk on 11/20/2013.
//  Copyright (c) 2013 Michael Luk. All rights reserved.
//

#ifndef __openGL_renderer__walls__
#define __openGL_renderer__walls__

#include <iostream>
#include "rigidbodies.h"

#include <GL/glew.h>

#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>

#include "../tools/camera.h"

#include "texture.hpp"
#include "objloader.hpp"

#include "../config/config.h"

class walls : public rigidbodies {
private:
    
public:
    walls(int size) : rigidbodies(size) {
        alphaChn = 0.4f;
    }
    
    void init_buffers();
};

#endif /* defined(__openGL_renderer__walls__) */
