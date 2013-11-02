#version 120

//varying vec3 f_color;
varying vec2 UV;

uniform sampler2D myTextureSampler;

void main(void) {
    //gl_FragColor = vec4(f_color.x, f_color.y, f_color.z, 1.0);
    gl_FragColor = vec4( texture2D( myTextureSampler, UV ).rgb, 1.0);
}
