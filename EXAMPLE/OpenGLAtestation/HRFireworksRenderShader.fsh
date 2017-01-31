//
//  HRBase
//  HRBase
//
//  Created by HRBase on 1/23/17.
//  Copyright (c) 2014 HRBase. All rights reserved.
//

#version 300 es

precision highp float;

uniform float uTime;

out vec4 outColor;

float rand(float p){
    return fract(sin(dot(gl_FragCoord.xy ,vec2(12.9898,78.233))) * 43758.5453 * uTime * p) * 0.5 + 0.5;
}

void main(void) {
    outColor = vec4(0.,
                    gl_FragCoord.z ,
                    0.1,
                    1.);
}
