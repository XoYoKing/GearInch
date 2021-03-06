//
//  FirstViewController.m
//  GearInch
//
//  Created by Erik Hope on 12/1/11.
//  Copyright (c) 2011 Erik Hope. All rights reserved.
//

#import "GearsToRatioViewController.h"
#import "GearInchSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation GearsToRatioViewController
@synthesize sizePicker, ratioLabel, 
settingsViewController, contextLabel, wheelSizeButton, pickerBackground;

const int kChainWheelComponent = 0;
const int kCogComponent = 1;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!settingsViewController){
        settingsViewController = [[GearInchSettingsViewController alloc] 
                                  initWithNibName:@"GearInchSettingsViewController" 
                                  bundle:nil];
    }
    NSLog(@"viewDidLoad");
    lastSelectedCogIndex = 6;
    lastSelectedChainwheelIndex = 15;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    [self.sizePicker selectRow:lastSelectedCogIndex 
                   inComponent:kCogComponent animated:NO];
    [self.sizePicker selectRow:lastSelectedChainwheelIndex
                   inComponent:kChainWheelComponent animated:NO];
    CGFloat cog = lastSelectedCogIndex + 11;
    CGFloat chainWheel = lastSelectedChainwheelIndex + 31;
    diameter = [preferences floatForKey:wheelDiameterKey];
    CGFloat ratio = (chainWheel/cog)*diameter;
    ratioLabel.text = [NSString stringWithFormat:@"%3.0f", ratio];
    contextLabel.text = [NSString stringWithFormat:@"The Gear-Inch Ratio for %2.0fx%2.0f is:", chainWheel, cog];
    wheelSizeButton.title = [preferences objectForKey:tireSizeTextKey];
    pickerBackground.clipsToBounds = YES;
    pickerBackground.layer.cornerRadius = 10.0;
    pickerBackground.layer.shadowRadius = 2.0;
    pickerBackground.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    pickerBackground.layer.shadowOpacity = 0.5;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (pickerView.frame.size.width-22)/2;
}

-(NSString*)pickerView:(UIPickerView *)pickerView 
           titleForRow:(NSInteger)row 
          forComponent:(NSInteger)component
{
    if (component == kChainWheelComponent){
        return [NSString stringWithFormat:@"%i-tooth", row+31];
    } else {
        return [NSString stringWithFormat:@"%i-tooth", row+11];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    lastSelectedCogIndex = [self.sizePicker selectedRowInComponent:kCogComponent];
    lastSelectedChainwheelIndex = [self.sizePicker selectedRowInComponent:kChainWheelComponent];
    CGFloat cog = lastSelectedCogIndex + 11;
    CGFloat chainWheel = lastSelectedChainwheelIndex + 31;
    CGFloat ratio = (chainWheel/cog)*diameter;
    contextLabel.text = [NSString stringWithFormat:@"The Gear-Inch Ratio for %2.0fx%2.0f is:", chainWheel, cog];
    ratioLabel.text = [NSString stringWithFormat:@"%3.0f", ratio];
}

#pragma mark UIPickerViewDataSource



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == kCogComponent){
        return 16;
    } else {
        return 31;
    }

}


-(void)infoButtonClicked:(UIButton *)infoButton
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GearInch\nCopyright (c) 2011 Erik Hope."
                                                    message:@"hi" delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
