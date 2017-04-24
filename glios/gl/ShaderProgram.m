//
//  ShaderProgram.m
//  GLKViewExample
//
//  Created by Jitu JPM on 2/20/17.
//  Copyright © 2017 Nexogen. All rights reserved.
//

#import "ShaderProgram.h"

@implementation ShaderProgram {
    GLuint program;
    
}
static ShaderProgram *defaultShader;

NSString *const POSITION_ATTRIBUTE = @"a_position";
NSString *const NORMAL_ATTRIBUTE = @"a_normal";
NSString *const COLOR_ATTRIBUTE = @"a_color";
NSString *const TEXCOORD_ATTRIBUTE = @"a_texCoord";
NSString *const TANGENT_ATTRIBUTE = @"a_tangent";
NSString *const BINORMAL_ATTRIBUTE = @"a_binormal";
NSString *const BONEWEIGHT_ATTRIBUTE = @"a_boneWeight";

GLuint NO_PROGRAM = 0;

-(instancetype) init : (NSString*) vShaderFileName : (NSString*) fShaderFileName : (NSString*) type{
    if (!self) self = [super init];
    NSString* vsh = [self getFileContents:vShaderFileName :type];
    NSString* fsh = [self getFileContents:fShaderFileName :type];
    program = [self createProgram:[vsh UTF8String] :[fsh UTF8String]];
    if (program != NO_PROGRAM){
        [GLUtil LOG:@"ShaderProgram" :[NSString stringWithFormat:@"Program created successfully with pid -> %d", program]];
    }
    return self;
}

-(instancetype) init : (NSString*) vshader : (NSString*) fshader{
    if (!self) self = [super init];
    program = [self createProgram:[vshader UTF8String] :[fshader UTF8String]];
    if (program != NO_PROGRAM){
        [GLUtil LOG:@"ShaderProgram" :[NSString stringWithFormat:@"Program created successfully with pid -> %d", program]];
    }
    return self;
}

+(ShaderProgram*) getDefaultShader{
    if (defaultShader) return defaultShader;
    NSString *defaultVertexShader = [NSString stringWithFormat:@"attribute vec4 a_pos; \n"
                                     "attribute vec2 a_tex;\n"
                                     "attribute vec4 a_color;\n"
                                     "uniform mat4 combined;\n"
                                     "varying vec2 v_tex;\n"
                                     "varying vec4 v_color;\n"
                                     "void main(void) {\n"
                                     "v_color = a_color;\n"
                                     "v_tex = a_tex;\n"
                                     "gl_Position = combined * a_pos;\n"
                                     "}\n" ];
    
    NSString *defaultFragmentShader = [NSString stringWithFormat:@"#ifdef GL_ES\n"
                                       "precision mediump float;\n"
                                       "#endif\n"
                                       "varying vec2 v_tex;\n"
                                       "varying vec4 v_color;\n"
                                       "uniform sampler2D u_texture;\n"
                                       "void main(void) {\n"
                                       "gl_FragColor =  v_color * texture2D(u_texture, v_tex);\n"
                                       "}\n"];
    
    defaultShader = [[ShaderProgram alloc] init:defaultVertexShader :defaultFragmentShader];
    NSLog(@"creating default shader");
    return defaultShader;
}

-(NSString *) getFileContents : (NSString*) fileName : (NSString*) type{
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        [GLUtil LOG:@"ShaderProgram" : [NSString stringWithFormat:@"Error loading shader: %@", error.localizedDescription]];
    }
    return shaderString;
}

-(GLuint) loadShader :(GLenum) shaderType :(const char*) pSource {
    GLuint shader = glCreateShader(shaderType);
    if (shader) {
        glShaderSource(shader, 1, &pSource, NULL);
        [GLUtil checkGlError:"ShaderProgram.loadShader() after glShaderSource()"];
        glCompileShader(shader);
        [GLUtil checkGlError:"ShaderProgram.loadShader() after glCompileShader()"];
        GLint compiled = 0;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
        [GLUtil checkGlError:"ShaderProgram.loadShader() after glGetShaderiv()"];
        if (!compiled) {
            GLint infoLen = 0;
            glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
            [GLUtil checkGlError:"ShaderProgram.loadShader() after glGetShaderiv()"];
            if (infoLen) {
                char* buf = (char*) malloc(infoLen);
                if (buf) {
                    glGetShaderInfoLog(shader, infoLen, NULL, buf);
                    [GLUtil checkGlError:"ShaderProgram.loadShader() after glGetShaderInfoLog()"];
                    [GLUtil LOG:@"ShaderProgram" :[NSString stringWithFormat:@"Could not compile shader %d:\n%s\n",shaderType,buf]];
                    free(buf);
                }
                glDeleteShader(shader);
                [GLUtil checkGlError:"ShaderProgram.loadShader() after glDeleteShader()"];
                shader = NO_PROGRAM;
            }
        }
    }
    return shader;
}


-(GLuint) createProgram :(const char*) pVertexSource :(const char*) pFragmentSource {
    GLuint vertexShader = [self loadShader :GL_VERTEX_SHADER :pVertexSource];
    if (!vertexShader) {
        [GLUtil LOG :@"ShaderProgram" :@"Error in VertexShader"];
        return 0;
    }
    
    GLuint pixelShader = [self loadShader :GL_FRAGMENT_SHADER :pFragmentSource];
    if (!pixelShader) {
        [GLUtil LOG:@"ShaderProgram" :@"Error in FragmentShader"];
        return 0;
    }
    
    program = glCreateProgram();
    if (program) {
        glAttachShader(program, vertexShader);
        [GLUtil checkGlError:"ShaderProgram.createProgram() after glAttachShader"];
        glAttachShader(program, pixelShader);
        [GLUtil checkGlError:"ShaderProgram.createProgram() after glAttachShader"];
        
        glLinkProgram(program);
        [GLUtil checkGlError:"ShaderProgram.createProgram() after glLinkProgram"];

        GLint linkStatus = GL_FALSE;
        glGetProgramiv(program, GL_LINK_STATUS, &linkStatus);
        [GLUtil checkGlError:"ShaderProgram.createProgram() after glGetProgramiv"];
        
        if (linkStatus != GL_TRUE) {
            GLint bufLength = 0;
            glGetProgramiv(program, GL_INFO_LOG_LENGTH, &bufLength);
            [GLUtil checkGlError:"ShaderProgram.createProgram() after glGetProgramiv"];

            if (bufLength) {
                char* buf = (char*) malloc(bufLength);
                if (buf) {
                    glGetProgramInfoLog(program, bufLength, NULL, buf);
                    [GLUtil checkGlError:"ShaderProgram.createProgram() after glGetProgramInfoLog"];

                    [GLUtil LOG:@"ShaderProgram" :[NSString stringWithFormat:@"Could not link program:\n%s\n", buf]];
                    free(buf);
                }
            }
            glDeleteProgram(program);
            [GLUtil checkGlError:"ShaderProgram.createProgram() after glDeleteProgram"];

            program = 0;
        }
    }
    return program;
}


-(void) begin{
    glUseProgram(program);
    [GLUtil checkGlError:"ShaderProgram.begin() after glUseProgram"];
}

-(void) end{
    glUseProgram(NO_PROGRAM);
    [GLUtil checkGlError:"ShaderProgram.end() after glUseProgram"];

}

-(void) dispose{
    glUseProgram(NO_PROGRAM);
    [GLUtil checkGlError:"ShaderProgram.dispose() after glUseProgram"];
    glDeleteProgram(program);
    [GLUtil checkGlError:"ShaderProgram.dispose() after glDeleteProgram"];
}

/**
 * enables blending for transparent textures
 */
-(void) enableBlending{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); //for texture transparency
}

/**
 * Disable blending
 */
-(void) disableBlending{
    glDisable(GL_BLEND);
}


-(void) checkError :(GLint) location :(const char*) name {
    if (location == -1){
        [GLUtil LOG:@"ShaderProgram" :[NSString stringWithFormat:@"Error fetching %s", name]];
    }
}

-(GLint) fetchAttributeLocation : (const char*) name{
    GLint location =  glGetAttribLocation(program, name);
    [self checkError :location :name];
    return location;
}

-(GLint) fetchUniformLocation : (const char*) name{
    GLint location =  glGetUniformLocation(program, name);
    [self checkError :location :name];
    return location;
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value the value */
-(void) setUniformiWithName :(const char*) name value:(GLint) value{
    GLint location = [self fetchUniformLocation :name];
    glUniform1i(location, value);
}

-(void) setUniformiWithLocation :(GLint) location value:(GLint) value{
    glUniform1i(location, value);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value1 the first value
 * @param value2 the second value */
-(void) setUniformiWithName :(const char*) name value1:(GLint) value1 value2:(GLint) value2{
    GLint location = [self fetchUniformLocation :name];
    glUniform2i(location, value1, value2);
}

-(void) setUniformiWithLocation :(GLint) location value1:(GLint) value1 value2:(GLint) value2{
    glUniform2i(location, value1, value2);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value1 the first value
 * @param value2 the second value
 * @param value3 the third value */
-(void) setUniformiWithName :(const char*) name value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3{
    GLint location = [self fetchUniformLocation :name];
    glUniform3i(location, value1, value2, value3);
}

-(void) setUniformiWithLocation :(GLint) location value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3
{
    glUniform3i(location, value1, value2, value3);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value1 the first value
 * @param value2 the second value
 * @param value3 the third value
 * @param value4 the fourth value */
-(void) setUniformiWithName :(const char*) name value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3 value4:(GLint) value4{
    GLint location = [self fetchUniformLocation :name];
    glUniform4i(location, value1, value2, value3, value4);
}

-(void) setUniformiWithLocation :(GLint) location value1:(GLint) value1 value2:(GLint) value2 value3:(GLint) value3 value4:(GLint) value4{
    glUniform4i(location, value1, value2, value3, value4);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value the value */
-(void) setUniformfWithName :(const char*) name value:(GLfloat) value{
    GLint location = [self fetchUniformLocation :name];
    glUniform1f(location, value);
}

-(void) setUniformfWithLocation :(GLint) location value:(GLfloat) value
{
    glUniform1f(location, value);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value1 the first value
 * @param value2 the second value */
-(void) setUniformfWithName:(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2
{
    GLint location = [self fetchUniformLocation :name];
    glUniform2f(location, value1, value2);
}

-(void) setUniformfWithLocation :(GLint) location value1:(GLfloat) value1 value2:(GLfloat) value2
{
    glUniform2f(location, value1, value2);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value1 the first value
 * @param value2 the second value
 * @param value3 the third value */
-(void) setUniformfWithName :(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3
{
    GLint location = [self fetchUniformLocation :name];
    glUniform3f(location, value1, value2, value3);
}

-(void) setUniformfWithLocation :(GLint) location value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3
{
    glUniform3f(location, value1, value2, value3);
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param value1 the first value
 * @param value2 the second value
 * @param value3 the third value
 * @param value4 the fourth value */
-(void) setUniformfWithName :(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3 value4:(GLfloat) value4
{
    GLint location = [self fetchUniformLocation :name];
    glUniform4f(location, value1, value2, value3, value4);
}

-(void) setUniformfWithLocation :(GLint) location value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3 value4:(GLfloat) value4
{
    glUniform4f(location, value1, value2, value3, value4);
}

-(void) setUniform1fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length
{
    GLint location = [self fetchUniformLocation :name];
    glUniform1fv(location, length,values);
}

-(void) setUniform1fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length
{
    glUniform1fv(location, length, values);
}

-(void) setUniform2fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length
{
    GLint location = [self fetchUniformLocation :name];
    glUniform2fv(location, length/2, values);
}

-(void) setUniform2fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length
{
    glUniform2fv(location, length/2, values);
}

-(void) setUniform3fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length
{
    GLint location = [self fetchUniformLocation :name];
    glUniform3fv(location, length / 3, values);
}

-(void) setUniform3fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length
{
    glUniform3fv(location, length / 3, values);
}

-(void) setUniform4fvWithName :(const char*) name values:(GLfloat*) values length:(GLint) length
{
    GLint location = [self fetchUniformLocation :name];
    glUniform4fv(location, length / 4, values);
}

-(void) setUniform4fvWithLocation :(GLint) location values:(GLfloat*) values length:(GLint) length
{
    glUniform4fv(location, length / 4, values);
}





/** Sets the uniform matrix with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param matrix the matrix
 * @param transpose whether the matrix shouls be transposed */
-(void) setUniformMatrixWithName :(const char*) name withMatrix4:(GLKMatrix4) value transpose:(GLboolean) transpose
{
    GLint location = [self fetchUniformLocation :name];
//    glUniformMatrix4fv(location, 1, transpose, matrix.get());
    glUniformMatrix4fv(location, 1, transpose, value.m);
    [GLUtil checkGlError :"error in uniform matrix"];
}


-(void) setUniformMatrixWithLocation :(GLint) location withMatrix4:(GLKMatrix4) value
{
    glUniformMatrix4fv(location, 1, GL_FALSE, value.m);
}


/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param values x and y as the first and second values respectively */

-(void) setUniformfWithName :(const char*) name withVector2:(GLKVector2) value
{
    [self setUniformfWithName :name value1:value.x value2:value.y];
}

-(void) setUniformfWithLocation :(GLint) location withVector2:(GLKVector2) value
{
    [self setUniformfWithLocation :location value1:value.x value2:value.y];
}

/** Sets the uniform with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the name of the uniform
 * @param values x, y and z as the first, second and third values respectively */
-(void) setUniformfWithName :(const char*) name withVector3:(GLKVector3) value
{
    [self setUniformfWithName :name value1:value.x value2:value.y value3:value.z];
}

-(void) setUniformfWithLocation :(GLint) location withVector3:(GLKVector3) value
{
    [self setUniformfWithLocation :location value1:value.x value2:value.y value3:value.z];
}



/** Sets the vertex attribute with the given name. Throws an IllegalArgumentException in case it is not called in between a
 * {@link #begin()}/{@link #end()} block.
 *
 * @param name the attribute name
 * @param size the number of components, must be >= 1 and <= 4
 * @param type the type, must be one of GL20.GL_BYTE, GL20.GL_UNSIGNED_BYTE, GL20.GL_SHORT,
 * GL20.GL_UNSIGNED_SHORT,GL20.GL_FIXED, or GL20.GL_FLOAT. GL_FIXED will not work on the desktop
 * @param normalize whether fixed point data should be normalized. Will not work on the desktop
 * @param stride the stride in bytes between successive attributes
 * @param buffer the buffer containing the vertex attributes. */
-(void) setVertexAttributeWithName :(const char*) name size:(GLint) size type:(GLint) type normalize:(GLboolean) normalize stride:(GLint) stride data:(GLvoid*) data{
    GLint location = [self fetchAttributeLocation :name];
    if (location == -1){
        [GLUtil LOG:@"ShaderProgram" :[NSString stringWithFormat:@"EMPTY shader Loc--> %s", name]];
        return;
    }
    glVertexAttribPointer(location, size, type, normalize, stride, data);
    [GLUtil checkGlError:"ShaderProgram.setVertexAttributeWithName() after glVertexAttribPointer"];
}

-(void) setVertexAttributeWithLocation :(GLint) location size:(GLint) size type:(GLint) type normalize:(GLboolean) normalize stride:(GLint) stride data:(GLvoid*) data{
    glVertexAttribPointer(location ,size, type, normalize, stride, data);
    [GLUtil checkGlError:"ShaderProgram.setVertexAttributeWithLocation() after glVertexAttribPointer"];
}


/** Disables the vertex attribute with the given name
 *
 * @param name the vertex attribute name */
-(void) disableVertexAttributeWithName :(const char*) name
{
    GLint location = [self fetchAttributeLocation :name];
    if (location == -1) return;
    glDisableVertexAttribArray(location);
}

-(void) disableVertexAttributeWithLocation :(GLint) location
{
    glDisableVertexAttribArray(location);
}

/** Enables the vertex attribute with the given name
 *
* @param name the vertex attribute name */
-(void) enableVertexAttributeWithName :(const char*) name
{
    GLint location = [self fetchAttributeLocation :name];
    if (location == -1) return;
    glEnableVertexAttribArray(location);
}

-(void) enableVertexAttributeWithLocation :(GLint) location
{
    glEnableVertexAttribArray(location);
}

/** Sets the given attribute
 *
 * @param name the name of the attribute
 * @param value1 the first value
 * @param value2 the second value
 * @param value3 the third value
 * @param value4 the fourth value */
-(void) setAttributefWithName :(const char*) name value1:(GLfloat) value1 value2:(GLfloat) value2 value3:(GLfloat) value3 value4:(GLfloat) value4
{
    GLint location = [self fetchAttributeLocation :name];
    glVertexAttrib4f(location, value1, value2, value3, value4);
}

@end
