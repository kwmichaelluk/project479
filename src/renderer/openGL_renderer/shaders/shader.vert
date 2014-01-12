#version 120

//layout(location=0) in vec3 coord3d;
attribute vec3 coord3d;
attribute vec2 vertex_uv;
attribute vec3 vertex_normal;
attribute mat4 model_matrix;



uniform mat4 view_matrix;
uniform mat4 proj_matrix;

uniform vec3 LightPosition_worldspace;

varying vec3 Position_worldspace;
varying vec3 Normal_cameraspace;
varying vec3 EyeDirection_cameraspace;
varying vec3 LightDirection_cameraspace;

varying vec2 UV;

void main(void) {
    gl_Position = proj_matrix * view_matrix * model_matrix * vec4(coord3d, 1.0) ;
    
    Position_worldspace = (model_matrix * vec4(coord3d,1)).xyz;
    
    vec3 vertexPosition_cameraspace = ( view_matrix * model_matrix * vec4(coord3d,1)).xyz;
	EyeDirection_cameraspace = vec3(0,0,0) - vertexPosition_cameraspace;
    
    
    vec3 LightPosition_cameraspace = ( view_matrix * vec4(LightPosition_worldspace,1)).xyz;
	LightDirection_cameraspace = LightPosition_cameraspace + EyeDirection_cameraspace;
    
    // Only correct if ModelMatrix does not scale the model ! Use its inverse transpose if not.
    Normal_cameraspace = ( view_matrix * model_matrix * vec4(vertex_normal,0)).xyz;
    
    UV = vertex_uv;
}
