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
    [super dealloc];
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
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [self setUseLinesSwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.graphView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)updateGraphDisplay
{
    self.graphView.scale = self.scale;
    self.graphView.useLines = self.useLines;
    [self.graphView setNeedsDisplay];
}

-(double) yValueGiven: (double) x for: (GraphView *)requestor {
    NSDictionary *values = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat: x] forKey:@"x"];
    return [CalculatorBrain evaluateExpression:self.expression usingVariables:values];
}

- (IBAction)zoomButtonPressed:(UIButton *)sender {
    if ([@"Zoom In" isEqualToString: sender.titleLabel.text]) {
        self.scale = self.scale * 2;
    } else {
        self.scale = self.scale / 2;
    }
    [self updateGraphDisplay];
}

- (IBAction)useLinesChange:(UISwitch *)sender {
    self.useLines = sender.on;
    [self updateGraphDisplay];
}
@end
