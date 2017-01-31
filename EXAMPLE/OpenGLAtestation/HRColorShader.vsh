//
//  HRBase
//  HRBase
//
//  Created by HRBase on 1/23/17.
//  Copyright (c) 2014 HRBase. All rights reserved.
//

#version 300 es
in vec2 aPosition;

void main(void) {
    gl_Position = vec4(aPosition, 0., 1.);
}
