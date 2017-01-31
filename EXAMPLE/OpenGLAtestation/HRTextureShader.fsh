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

//varying
in vec2 v_texcoord;

out vec4 outFragColor;


void main(void) {
    outFragColor = texture(uTexture, vec2(v_texcoord.x,1.0 - v_texcoord.y));
}
