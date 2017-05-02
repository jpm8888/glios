attribute vec4 a_pos;
attribute vec2 a_tex;
uniform mat4 combined;

varying vec2 v_tex;
void main(void) {
    v_tex = a_tex;
    gl_Position = combined * a_pos;
}
