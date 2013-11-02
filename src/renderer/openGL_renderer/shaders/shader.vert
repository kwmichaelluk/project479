#version 120

//layout(location=0) in vec3 coord3d;
attribute vec3 coord3d;
//attribute vec3 v_color;
attribute vec2 vertex_uv;
attribute mat4 model_matrix;



uniform mat4 view_matrix;
uniform mat4 proj_matrix;

//varying vec3 f_color;
varying vec2 UV;

void main(void) {
    gl_Position = proj_matrix * view_matrix * model_matrix * vec4(coord3d, 1.0) ;
    //f_color = v_color;
    
    UV = vertex_uv;
}
