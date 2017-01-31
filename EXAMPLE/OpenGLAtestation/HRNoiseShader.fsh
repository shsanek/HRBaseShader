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
uniform float uTime;

//varying
in vec2 v_texcoord;

out vec4 outColor;

float rand(float p){
    return fract(sin(dot(v_texcoord.xy ,vec2(12.9898,78.233)) * p * (uTime + 1.0)) * 43758.5453);
}

void main(void) {
    outColor = vec4(rand(1.0), rand(2.0), rand(3.0), 1.);
}
