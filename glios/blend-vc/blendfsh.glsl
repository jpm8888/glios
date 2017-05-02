#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
varying vec2 v_tex;
uniform sampler2D bTexture;
uniform sampler2D mTexture;

void main(void) {
    vec4 bPixel = texture2D(bTexture , v_tex);
    vec4 mPixel = texture2D(mTexture , v_tex);
    
    vec4 result = bPixel * mPixel;
    gl_FragColor = result;
}
