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

//varying

out vec4 outColor;

float rand(float p){
    return fract(sin(dot(gl_FragCoord.xy ,vec2(12.9898,78.233))) * 43758.5453 * uTime * p);
}


void main(void) {
    vec2 position = (gl_FragCoord.xy) / uResolution;
    vec2 delta = 1. / uResolution;
    vec2 movx = vec2(delta.x,0);
    vec2 movy = vec2(0,delta.y);
    float len = 7.;
    if ((uIsTap != 0 || uIsPan != 0) && length(uCurrentPosition - gl_FragCoord.xy) <= len) {
        if (rand(1.) > 0.5) {
            outColor = vec4(1.,1.,1.,1.);
        } else {
            outColor = vec4(0.,0.,0.,1.);
        }
    } else {
        float sum =
            texture(uTexture,position + movx).g +
            texture(uTexture,position - movx).g +
            texture(uTexture,position + movy).g +
            texture(uTexture,position - movy).g;
        if (sum == 3.0 ) {
            outColor = vec4(1.,1.,1.,1.);
        } else if (sum == 2.0 && texture(uTexture,position).g > 0.5) {
            outColor = vec4(0.,1.,0.,1.);
        } else {
            outColor = vec4(0.,0.,0.,1.);
        }
    }
}
