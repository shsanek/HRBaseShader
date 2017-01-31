//
//  HRBase
//  HRBase
//
//  Created by HRBase on 1/23/17.
//  Copyright (c) 2014 HRBase. All rights reserved.
//

// Attributes

#version 300 es

in float aIndexes;

uniform float uTime;
uniform sampler2D uTexture;
uniform vec2 uTextureSize;
uniform vec2 uResalution;

const float kNumberOfItemForPartical = 4.;

highp float decode32(highp vec4 value) {
    return value.x  * 4000. - 2000.;
}

void main(void) {
    vec2 pos = vec2(mod(aIndexes,uTextureSize.y),
                    floor(aIndexes / uTextureSize.x) * kNumberOfItemForPartical)
                / uTextureSize;
    vec2 movy = vec2(0.,1./uTextureSize.y);
    
    gl_PointSize = 2.;
    gl_Position = vec4((decode32(texture(uTexture,pos)) / uResalution.x) * 2. - 1.,
                       (decode32(texture(uTexture,pos + movy)) / uResalution.y) * 2. - 1.,
                       0.,
                       1.);
}
