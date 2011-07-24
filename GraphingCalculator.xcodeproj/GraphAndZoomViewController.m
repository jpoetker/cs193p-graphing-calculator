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
@synthesize useLinesSwitch;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.scale = 14;
        self.useLines = YES;
    }
    return self;
}

- (void)dealloc
{
    [graphView release];
    [useLinesSwitch release];
    [expression release];
    [super dealloc];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.graphView.delegate = self;
    self.graphView.scale = self.scale;
    self.graphView.useLines = self.useLines;
    self.useLinesSwitch.on = self.useLines;
    
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
    [self setUseLinesSwitch:nil];
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


- (IBAction)useLinesChange:(UISwitch *)sender {
    self.useLines = sender.on;
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
