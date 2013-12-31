//layout(location=0) in vec3 coord3d;
attribute vec3 coord3d;
attribute vec3 v_color;

attribute vec3 m_pos;

uniform mat4 mvp;
varying vec3 f_color;

void main(void) {
  gl_Position = mvp * vec4(coord3d+m_pos*2.0, 1.0);
  f_color = v_color;
}
