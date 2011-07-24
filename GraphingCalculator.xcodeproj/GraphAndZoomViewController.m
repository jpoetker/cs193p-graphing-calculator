//
//  GraphAndZoomViewController.m
//  GraphingCalculator
//
//  Created by Jeff Poetker on 7/18/11.
//  Copyright 2011 Medplus, Inc. All rights reserved.
//

#import "GraphAndZoomViewController.h"
#import "CalculatorBrain.h"

@implementation GraphAndZoomViewController
@synthesize graphView;
@synthesize expression;
@synthesize scale;
@synthesize useLines;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scale = 14;
        self.useLines = YES;
    }
    return self;
}

-(void)loadView
{
    self.graphView = [[GraphView alloc] initWithFrame:CGRectZero];
    self.graphView.backgroundColor = [UIColor whiteColor];
    self.view = self.graphView;
}

- (void)dealloc
{
    [graphView release];
    [expression release];
    [super dealloc];
}

// I know this probably isn't "correct" - maybe there should 
// be a model....
-(CGPoint) origin
{
    return self.graphView.origin;
}
-(void) setOrigin:(CGPoint) point
{
    self.graphView.origin = point;
}

-(void)setExpression:(id)anExpression
{
    [expression release];
    expression = anExpression;
    [expression retain];
    [self.graphView setNeedsDisplay];
}

-(void)setScale:(CGFloat)newScale
{
    scale = newScale;
    self.graphView.scale = scale;
}

-(void)setUseLines:(BOOL)shouldUseLines
{
    useLines = shouldUseLines;
    self.graphView.useLines = useLines;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadDefaults
{
    CGFloat originX = [[NSUserDefaults standardUserDefaults] floatForKey:@"graphViewOriginX"];
    CGFloat originY = [[NSUserDefaults standardUserDefaults] floatForKey:@"graphViewOriginY"];
    self.origin = CGPointMake(originX, originY);
    
    self.scale = [[NSUserDefaults standardUserDefaults] floatForKey:@"graphViewScale"];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.graphView.delegate = self;

    [self loadDefaults];
    
    // Set up Pan Gesture
    UIGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self.graphView action:@selector(pan:)];
    [self.graphView addGestureRecognizer:panGesture];
    [panGesture release];
    
    UIGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)];
    [self.graphView addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.graphView addGestureRecognizer:doubleTap];
    [doubleTap release];
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    // TODO: figure out if phone functions exist and return not upside down if so
    return YES;
    
}

-(double) yValueGiven: (double) x for: (GraphView *)requestor {
    NSDictionary *values = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat: x] forKey:@"x"];
    return [CalculatorBrain evaluateExpression:self.expression usingVariables:values];
}

-(void)scaleChangedTo:(CGFloat)scaleValue for:(GraphView *)requestor
{
    self.scale = scaleValue;
    [[NSUserDefaults standardUserDefaults] setFloat: self.scale forKey:@"graphViewScale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)originMovedTo:(CGPoint)origin for:(GraphView *)requestor
{
    self.origin = origin;
    [[NSUserDefaults standardUserDefaults] setFloat: self.origin.x forKey: @"graphViewOriginX"];
    [[NSUserDefaults standardUserDefaults] setFloat: self.origin.y forKey:@"graphViewOriginY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)splitViewController:(UISplitViewController *)svc 
    willHideViewController:(UIViewController *)aViewController 
         withBarButtonItem:(UIBarButtonItem *)barButtonItem 
      forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)splitViewController:(UISplitViewController *)svc 
    willShowViewController:(UIViewController *)aViewController 
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.rightBarButtonItem = nil;
}

@end
