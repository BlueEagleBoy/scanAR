//
//  ExternalEAGLView.m
//  DevApplication_ExternalRendering
//
//  Created by Andreas Schacherbauer on 17/06/15.
//  Copyright (c) 2015 Wikitude. All rights reserved.
//

#import "ExternalEAGLView.h"

#import <QuartzCore/QuartzCore.h>


@implementation ExternalEAGLView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initOpenGLES];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initOpenGLES];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initOpenGLES];
    }
    
    return self;
}

- (void)initOpenGLES
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
}

#pragma mark - Public Methods
- (CAEAGLLayer *)eaglLayer
{
    return (CAEAGLLayer *)self.layer;
}

@end
