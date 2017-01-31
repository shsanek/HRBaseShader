//
//  HRBase
//  HRBase
//
//  Created by HRBase on 1/23/17.
//  Copyright (c) 2014 HRBase. All rights reserved.
//

#version 300 es

precision highp float;

//uniform
uniform vec2 uResolution;
uniform sampler2D uTexture;

uniform vec2 uTextureSize;
uniform vec3 uLightParameters[16];
uniform float uNumberOfLight;

const float kPI = 3.14159265358979323846264338327950288;
const float k2PI = 6.28318530718;
const float kPI_2 = 1.57079632679489661923132169163975144;
//varying

out vec4 outColor;

void main(void) {
    int index = int(gl_FragCoord.y );    
    if (float(index) < uNumberOfLight){
        float alpha = gl_FragCoord.x / uResolution.x * k2PI;
        vec2 speed = normalize(vec2(cos(alpha),
                                    sin(alpha))) / 4.;
        vec2 position = uLightParameters[index].xy;
        
        vec2 texturePosition = position / uTextureSize;
        vec2 textureSpeed =  speed / uTextureSize;
        textureSpeed = -textureSpeed;
//        texturePosition.y = 1. - texturePosition.y;
//        
        float len = 0.;
        float vspeed = length(speed);
        float maxLength = uLightParameters[index].z;
        
        while (len < maxLength &&
               texture(uTexture,texturePosition).y > 0.5) {
            len += vspeed;
            texturePosition += textureSpeed;
        }
        len += vspeed;
        gl_FragDepth = len / 512. ;
    }else {
        gl_FragDepth = 0.0;
    }
}
