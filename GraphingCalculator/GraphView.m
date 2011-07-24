//
//  GraphView.m
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"


@implementation GraphView

@synthesize delegate;


-(void) setup 
{
    self.useLines = YES;
    [super setContentMode: UIViewContentModeRedraw];
    
    self.origin = CGPointZero;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(CGPoint)origin
{
    return origin;
}
-(void)setOrigin:(CGPoint)newOriginPoint
{
    origin = newOriginPoint;
    [self setNeedsDisplay];
}

#define DEFAULT_SCALE 14;

-(void)setScale:(CGFloat) newScale {
    if (scale != newScale) {
        scale = newScale;
        [self setNeedsDisplay];
    }
}
-(CGFloat) scale
{
    return (scale) ? scale : DEFAULT_SCALE;
}

-(void)setUseLines:(BOOL) drawWithLines
{   
    useLines = drawWithLines;
    [self setNeedsDisplay];
}
-(BOOL)useLines
{
    return useLines;
}

- (CGPoint) midPoint
{
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2 + origin.x;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2 - origin.y;
    return midPoint;
}

- (double) convertXPixelToGraphValueX: (CGFloat) x originAtPoint: (CGPoint) midPoint scale: (CGFloat) s
{
    return ((x - midPoint.x) / s);
}

- (CGFloat) convertYValueToYPixel: (double) y originAtPoint: (CGPoint) midPoint scale: (CGFloat) s
{
    return (-1 * y * s) + midPoint.y;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat scaleFactor = self.contentScaleFactor;
    
    
    CGPoint midPoint = [self midPoint];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Drawing code
    NSLog(@"Drawing axis for scale %f", self.scale); 
    [AxesDrawer drawAxesInRect:rect originAtPoint:midPoint scale:self.scale];

    BOOL lineInitialized = NO;
    for(double x = 0;x<self.bounds.size.width;x=x+(1/scaleFactor)) {
        double xValue = [self convertXPixelToGraphValueX:x originAtPoint:midPoint scale:self.scale];
        double yValue = [delegate yValueGiven: xValue for: self];
        CGFloat y = [self convertYValueToYPixel:yValue originAtPoint:midPoint scale:self.scale];
//        NSLog(@"%f = %f", xValue, yValue);
//        NSLog(@"Pixels: (%d, %f)", x, y);
        
        CGPoint graphPoint;
        graphPoint.x = x;
        graphPoint.y = y;        
//        if (CGRectContainsPoint(self.bounds, graphPoint)) {
            if (self.useLines) {
                if (!lineInitialized) {
                    lineInitialized = YES;
                    CGContextMoveToPoint(context, graphPoint.x, graphPoint.y);
                } else {
                    CGContextAddLineToPoint(context, graphPoint.x, graphPoint.y);
                }

            } else {
                CGRect point = CGRectMake(graphPoint.x, graphPoint.y, .5, .5);
                CGContextAddRect(context, point);
                CGContextStrokePath(context);
            }
//        }
    }
    
    if (self.useLines) {
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

-(void)pan:(UIPanGestureRecognizer *)sender
{
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [sender translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, self.origin.y-translation.y);
        [sender setTranslation:CGPointZero inView:self];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)sender 
{
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) 
    {
        self.scale *= sender.scale;
        sender.scale = 1;
    }
}

-(void)tap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.origin = CGPointZero;
    }
}
- (void)dealloc
{
    [super dealloc];
}

@end
