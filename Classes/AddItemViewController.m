//
//  AddItemViewController.m
//  DatabaseShoppingList
//
//  Created by Steve Baker on 12/28/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import "AddItemViewController.h"


@implementation AddItemViewController
#pragma mark -
#pragma mark properties

@synthesize itemNameField;
@synthesize priceField;
@synthesize groupPicker;
@synthesize statusLabel;

#pragma mark -
#pragma mark initializers / destructors
- (void)dealloc {
    [itemNameField release], itemNameField = nil;
    [priceField release], priceField = nil;
    [groupPicker release], groupPicker = nil;
    [statusLabel release], statusLabel = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark picker datasource and delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}


// optional delegate method
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if (0 == row) 
        return @"Groceries";
    else 
        return @"Tech";
}

#pragma mark -
#pragma mark textField delegate methods.
// optional method.  Dismiss keyboard when user presses Return
// Ref Dudney sec 4.6 pg 67
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

// called when textField resigns its first responder status
// Ref Dudney sec 4.6 pg 67
-(void)textFieldDidEndEditing:(UITextField *)textField {
    // ????: do nothing?
}

#pragma mark -
- (IBAction)addShoppingListItem:(id)sender {
    
}

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


@end
