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
 
    float sum = 0.;
    vec4 color = vec4(1.,1.,1.,1.);
    for (int i = 0; i < int(uNumberOfLight); i++) {
        vec2 pos = uLightParameters[i].xy;
        float len = uLightParameters[i].z;
        vec2 vec = gl_FragCoord.xy / uResolution * uTextureSize  - pos;
        float currentLen = length(vec);
        if (currentLen < len) {
            float alpha = (atan(vec.y, vec.x) + kPI) / k2PI;
            float realLength = texture(uTexture, vec2(alpha , float(i) / 16.)).x * 512.;
            if (realLength > currentLen) {
                float m = len * len;
                float w = 1. - currentLen * currentLen / m;
                sum = sum + w;
            }
        } 
    }
    if (sum > 1.) {
        sum = 1.;
    }
    outColor = vec4(sum,sum,sum,1.);
}
