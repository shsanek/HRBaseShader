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
uniform int uIsTap;
uniform int uIsPan;
uniform vec2 uStartPanPosition;
uniform vec2 uCurrentPosition;

uniform float uDeltaTime;
uniform vec2 uNewIndexRange;
uniform vec2 uGravitaion;
uniform int uNumberOfItems;

// CONSTANT
//const float kG = 10.;

const float kSize = 2.;
const float kM = 2.;
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
    vec2 pos = vec2((index.x) / uResolution.x,
                    (index.y) / uResolution.y);
    return texture(tex, pos);
}

float randPos(vec2 pos,float p){
    return fract(sin(dot(pos.xy ,vec2(12.9898,78.233))) * 43758.5453 * uTime * p);
}


float rand(float p){
    return fract(sin(dot(gl_FragCoord.xy ,vec2(12.9898,78.233))) * 43758.5453 * uTime * p);
}


highp float encode32(highp float value) {
    return (value + 4096.) / 8192.;
}

highp float decode32(highp vec4 value) {
    return value.x  * 8192. - 4096.;
}




float xSpeed(int index) {
    vec2 movy = vec2(0.,1./uTextureSize.y);
    vec2 _pos = vec2(mod(index,uResolution.y),
                     floor(index / uResolution.x) * kNumberOfItemForPartical)
    / uResolution;
    vec2 currentItemPosition = vec2(encode32(texture(uTexture,_pos))
                                    encode32(texture(uTexture,_pos) + movy));
    
    vec2 currentItemSpeed = vec2(encode32(texture(uTexture,_pos) + movy * 2.)
                                 encode32(texture(uTexture,_pos) + movy * 3.));
    float sum = 0.;
    for (int i = index; i < uNumberOfItems; i++) {
        vec2 pos = vec2(mod(index,uResolution.y),
                        floor(index / uResolution.x) * kNumberOfItemForPartical)
        / uResolution;
        vec2 positionItem = vec2(encode32(texture(uTexture,pos))
                                 encode32(texture(uTexture,pos) + movy));
        vec2 vector = positionItem - currentItemPosition;
        if (length(positionItem - currentItemPosition) < 1.) {
            vec2 speedItem = vec2(encode32(texture(uTexture,pos) + movy * 2.)
                                         encode32(texture(uTexture,pos) + movy * 3.));
            
        }
    }
    
    for (int i = 0; i < index; i++) {
        vec2 pos = vec2(mod(index,uResolution.y),
                        floor(index / uResolution.x) * kNumberOfItemForPartical)
        / uResolution;
        vec2 positionItem = vec2(encode32(texture(uTexture,pos))
                                 encode32(texture(uTexture,pos) + movy));
        if (length(positionItem - currentItemPosition) < 1.) {
            
        }
        
    }
}

void main(void) {
    vec2 delta = 1. / uResolution;

    vec2 position = (gl_FragCoord.xy) / uResolution;
    int row = int((gl_FragCoord.y )/kNumberOfItemForPartical);

    vec2 movx = vec2(delta.x,0.);
    vec2 movy = vec2(0.,delta.y);
    
    float index = (gl_FragCoord.x )  + float(row) * floor(uResolution.x);
    
    int indexFirework = int(floor(mod(index,float(uNumberOfFireworks))));
    vec2 realPosition = vec2(gl_FragCoord.x,float(row) + gl_FragCoord.x );
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
        float vx = 0.;
        if (indexFirework == uIndexNewFirework && uIsTap != 0) {
            vx = (kStartSpeed + (randPos(realPosition,1.) - 0.5) * kDeltaStartSpeed ) *
            cos (randPos(realPosition,123.123) * k2PI) ;
        } else {
            vx = decode32(texture(uTexture,position));
            vx = vx - vx * kDelta * uDeltaTime;
        }
        gl_FragDepth = encode32(vx);
    } else if (row == 3){
        float vy = 0.;
        if (indexFirework == uIndexNewFirework && uIsTap != 0) {
            vy = (kStartSpeed + (randPos(realPosition,1.) - 0.5)  * kDeltaStartSpeed ) *
            sin (randPos(realPosition,123.123) * k2PI) ;
        } else {
            vy = decode32(texture(uTexture,position));
            vy = vy - (vy * kDelta + kG) * uDeltaTime;
        }
        gl_FragDepth = encode32(vy);
    } 
}
