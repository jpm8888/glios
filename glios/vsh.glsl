attribute vec4 a_pos;
attribute vec4 a_color;
attribute vec2 a_tex;

uniform mat4 combined;

varying vec4 v_color;
varying vec2 v_tex;
void main(void) {
    v_color = a_color;
    v_tex = a_tex;
    gl_Position = combined * a_pos;
}
