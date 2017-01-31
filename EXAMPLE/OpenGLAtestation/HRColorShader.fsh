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

out vec4 outColor;


void main(void) {
    vec2 position = gl_FragCoord.xy/uResolution;
    float gradient = position.x;
    outColor = vec4(0., gradient, 0., 1.);
}
