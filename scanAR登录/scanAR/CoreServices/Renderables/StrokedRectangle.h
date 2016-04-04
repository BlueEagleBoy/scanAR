//
//  StrokedRectangle.h
//  Native Examples
//
//  Created by Andreas Schacherbauer on 29/07/15.
//  Copyright (c) 2015 Wikitude. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>


@interface StrokedRectangle : NSObject

@property (nonatomic, assign) CGFloat               scale;

- (void)setProjectionMatrix:(const float *)projectionMatrix;
- (void)setModelViewMatrix:(const float *)modelViewMatrix;

- (void)drawInContext:(EAGLContext *)context;

@end
