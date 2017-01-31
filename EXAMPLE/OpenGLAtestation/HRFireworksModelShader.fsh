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
uniform float uTime;
uniform float uDeltaTime;
uniform int uIsTap;
uniform int uIsPan;
uniform vec2 uStartPanPosition;
uniform vec2 uCurrentPosition;

uniform int uNumberOfFireworks;
uniform int uNumberOfPointInFirework;
uniform int uIndexNewFirework;

// CONSTANT
const float kG = 10.;
const float kDelta = 0.;
const float kStartSpeed = 20.;
const float kDeltaStartSpeed = 40.;
const float kTimeLife = 1.;
const float kDeltaTimeLife = 1.;
const float kNumberOfItemForPartical = 4.;

const float kPI = 3.14159265358979323846264338327950288;
const float k2PI = 6.28318530718;
const float kPI_2 = 1.57079632679489661923132169163975144;
//varying


out vec4 outColor;

vec4 textureWithIndex(sampler2D tex,vec2 index) {
    vec2 pos = vec2((index.x + 0.5) / uResolution.x,
                    (uResolution.y - index.y + 0.5) / uResolution.y);
    return texture(tex, pos);
}

float randPos(vec2 pos,float p){
    return fract(sin(dot(pos.xy ,vec2(12.9898,78.233))) * 43758.5453 * (1. + uTime) * p);
}


float rand(float p){
    return fract(sin(dot(gl_FragCoord.xy ,vec2(12.9898,78.233))) * 43758.5453 * uTime * p);
}


 float encode32( float value) {
    return (value + 2000.) / 4000.;
}

 float decode32( vec4 value) {
    return value.x * 4000. - 2000.;
}



void main(void) {
    vec2 delta = 1. / uResolution;

    vec2 position = (gl_FragCoord.xy) / uResolution;
    int row = int((gl_FragCoord.y )/kNumberOfItemForPartical);

    vec2 movx = vec2(delta.x,0.);
    vec2 movy = vec2(0.,delta.y);
    
    float index = (gl_FragCoord.x )  + float(row) * floor(uResolution.x);
    
    int indexFirework = int(floor(mod(index,float(uNumberOfFireworks))));
    vec2 realPosition = vec2(gl_FragCoord.x,float(row)  *  kNumberOfItemForPartical);
    row = int(mod((gl_FragCoord.y ),kNumberOfItemForPartical));
    
    
    if (row == 0) {
        float x = 0.;
        if (indexFirework == uIndexNewFirework && uIsTap != 0) {
            x = uCurrentPosition.x;
        } else {
            x = decode32(texture(uTexture,position ));
            float vx = decode32(texture(uTexture,position + movy * 2.));
            x = x + vx * uDeltaTime;
        }
        gl_FragDepth = encode32(x);
    } else if (row == 1) {
        float y = 0.;
        if (indexFirework == uIndexNewFirework && uIsTap != 0) {
            y = uCurrentPosition.y;
        } else {
            y = decode32(texture(uTexture,position  ));
            float vy = decode32(texture(uTexture,position + movy * 2.));
            y = y + vy * uDeltaTime;
        }
        gl_FragDepth = encode32(y);
    } else if (row == 2) {
        float vy = 0.;
        if (indexFirework == uIndexNewFirework && uIsTap != 0) {
            vec2 pos = vec2(gl_FragCoord.x,gl_FragCoord.y+1.);
            vy = (kStartSpeed + (randPos(gl_FragCoord.xy,768.) - 0.5)  * kDeltaStartSpeed ) *
            cos (randPos(pos,1293128.123) * k2PI) ;
        } else {
            vy = decode32(texture(uTexture,position));
            //vy = vy - (vy * kDelta) * uDeltaTime;
        }
        gl_FragDepth = encode32(vy);
    } else {
        float vy = 0.;
        if (indexFirework == uIndexNewFirework && uIsTap != 0) {
            vec2 pos = vec2(gl_FragCoord.x,gl_FragCoord.y-1.);
            vy = (kStartSpeed + (randPos(pos,768.) - 0.5)  * kDeltaStartSpeed ) *
            sin (randPos(gl_FragCoord.xy,1293128.123) * k2PI) ;
        } else {
            vy = decode32(texture(uTexture,position));
            vy = vy - (vy * kDelta + kG) * uDeltaTime;
        }
        gl_FragDepth = encode32(vy);
    }
}
