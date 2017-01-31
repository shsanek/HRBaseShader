//
//  HRBase
//  HRBase
//
//  Created by HRBase on 1/23/17.
//  Copyright (c) 2014 HRBase. All rights reserved.
//

// Attributes
#version 300 es
in vec2 aPosition;
in vec2 aTextureCoord;


void main(void) {
    gl_Position = vec4(aPosition, 0., 1.);
}
