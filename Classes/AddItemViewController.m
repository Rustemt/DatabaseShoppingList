//
//  AddItemViewController.m
//  DatabaseShoppingList
//
//  Created by Steve Baker on 12/28/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import "AddItemViewController.h"
#include <sqlite3.h>
#import "DatabaseShoppingListAppDelegate.h"


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
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{
    return 2;
}


// optional delegate method
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (0 == row) 
        return @"Groceries";
    else 
        return @"Tech";
}

#pragma mark -
#pragma mark textField delegate methods.
// optional method.  Dismiss keyboard when user presses Return
// both textFields use this method
// Ref Dudney sec 4.6 pg 67
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// called when textField resigns its first responder status
// Ref Dudney sec 4.6 pg 67
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    // ????: do nothing?
}

#pragma mark -
- (IBAction) addShoppingListItem: (id) sender
{
	NSLog (@"addShoppingListItem");
	
	// sanity check - reject if either field empty price doesn't parse
    // open database for add
	if (([itemNameField.text length] == 0) ||
		([priceField.text length] == 0) ||
		([priceField.text doubleValue] == 0.0))
		return;
	
	sqlite3 *db;
	int dbrc; // database return code
	DatabaseShoppingListAppDelegate *appDelegate = (DatabaseShoppingListAppDelegate*)
    [UIApplication sharedApplication].delegate;
	const char* dbFilePathUTF8 = [appDelegate.dbFilePath UTF8String];
    
	dbrc = sqlite3_open (dbFilePathUTF8, &db);
	if (dbrc) {
		NSLog (@"couldn't open db:");
		return;
	}
	NSLog (@"opened db");
	
	// add stuff
	// insert into database
	sqlite3_stmt *dbps; // database prepared statement
	NSString *insertStatementNS = [NSString stringWithFormat:
                                   @"insert into \"shoppinglist\"\
                                   (item, price, groupid, dateadded)\
                                   values (\"%@\", %@, %d, DATETIME('NOW'))",
                                   itemNameField.text,
                                   priceField.text,
                                   [groupPicker selectedRowInComponent: 0]];
	const char *insertStatement = [insertStatementNS UTF8String];
    
	// sqlite3_prepare_v2 prepares the statement
    // NOTE: use sqlite3_prepare_v2 not sqlite3_prepare.  See comments in sqlite3.h and Dudney p 194
	dbrc = sqlite3_prepare_v2 (db, insertStatement, -1, &dbps, NULL);
    if (dbrc)
		NSLog (@"possible error preparing db for insert");
    
	// sqlite3_step executes the statement
    dbrc = sqlite3_step (dbps);
    if (dbrc)
		NSLog (@"inserted in db.  dbrc != 0, possible error?");
	//END:code.DatabaseShoppingList.insertIntoDatabase
	//START:code.DatabaseShoppingList.insertIntoDatabaseCleanup
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
	
	// clear fields and indicate success on status line
	statusLabel.text = [[NSString alloc] initWithFormat: @"Added %@", itemNameField.text];
	statusLabel.hidden = NO;
	itemNameField.text = @"";
	priceField.text = @"";    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
