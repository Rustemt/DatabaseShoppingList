//
//  ListByPriceViewController.m
//  DatabaseShoppingList
//
//  Created by Steve Baker on 12/28/09.
//  Copyright 2009 Beepscore LLC. All rights reserved.
//

#import "ListByPriceViewController.h"
#import "DatabaseShoppingListAppDelegate.h"
#include <sqlite3.h>

@implementation ListByPriceViewController
@synthesize nibLoadedTableCell;

// keys for key-value pair NSDicts in the shoppingListItems
NSString *PRIMARY_ID_KEY = @"primaryid";
NSString *ITEM_KEY = @"item";
NSString *PRICE_KEY = @"price";
NSString *GROUP_ID_KEY = @"groupid";
NSString *DATE_ADDED_KEY = @"dateadded";

// group names
NSString *GROUP_NAMES[] = {@"Groceries", @"Tech"};

// contents loaded from db: each cell is an NSDictionary of key-val pairs
NSMutableArray *shoppingListItems;

NSNumberFormatter *priceFormatter;
NSDateFormatter *dateFormatter;


- (void)viewDidLoad {
	[super viewDidLoad];
	// set up price formatter
	if (!priceFormatter)
    {
		priceFormatter = [[NSNumberFormatter alloc] init];
		[priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	}
	// set up date formatter to parse dates from db strings
	if (! dateFormatter)
    {
		// [NSDateFormatter setDefaultFormatterBehavior:  NSDateFormatterBehavior10_4]; // unneccessary - osx 10.4 behavior is the only supported behavior on iPhoneOS
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
		[dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
	}
}

// Load all rows from database into array shoppingListItems
- (void) loadDataFromDb
{
	NSLog (@"loadDataFromDb");
    
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
	
	// select stuff
	sqlite3_stmt *dbps; // database prepared statement

    // Fields will be returned in the order specified by the query statement.
    // This order may be different from the database table column order.
	NSString *queryStatementNS =
	@"select key, item, price, groupid, dateadded\
	from shoppinglist order by price";
	const char *queryStatement = [queryStatementNS UTF8String];

    // NOTE: use sqlite3_prepare_v2 not sqlite3_prepare.  See comments in sqlite3.h and Dudney p 194
	dbrc = sqlite3_prepare_v2 (db, queryStatement, -1, &dbps, NULL);
    if (dbrc)
    {
		NSLog (@"possible error preparing db for read");
		return;
	}    
	NSLog (@"prepared statement");
	
	// clear out any existing table model array and prepare new one
	[shoppingListItems release];
	shoppingListItems = [[NSMutableArray alloc] initWithCapacity: 100]; // arbitrary capacity
	
	// repeatedly execute the prepared statement until we're out of results
	while ((dbrc = sqlite3_step (dbps)) == SQLITE_ROW)
    {
		
        // column index must match order used in the query statement used to select the row.
        int primaryKeyValueI = sqlite3_column_int(dbps, 0);
		NSNumber *primaryKeyValue = [[NSNumber alloc]
                                     initWithInt: primaryKeyValueI];
		NSString *itemValue = [[NSString alloc]
                               initWithUTF8String: (char*) sqlite3_column_text (dbps, 1)];
		double priceValueD = sqlite3_column_double (dbps, 2);
		NSNumber *priceValue = [[NSNumber alloc]
                                initWithDouble: priceValueD];
		int groupValueI = sqlite3_column_int(dbps, 3);
		NSNumber *groupValue = [[NSNumber alloc]
                                initWithInt: groupValueI];
		NSString *dateValueS = [[NSString alloc] 
                                initWithUTF8String: (char*) sqlite3_column_text (dbps, 4)];
		NSDate *dateValue = [dateFormatter dateFromString: dateValueS];
		
		NSMutableDictionary *rowDict =
        [[NSMutableDictionary alloc] initWithCapacity: 5];
		[rowDict setObject: primaryKeyValue forKey: PRIMARY_ID_KEY];
		[rowDict setObject: itemValue forKey: ITEM_KEY];
		[rowDict setObject: priceValue forKey: PRICE_KEY];
		[rowDict setObject: groupValue forKey: GROUP_ID_KEY];
		[rowDict setObject: dateValue forKey: DATE_ADDED_KEY];
		[shoppingListItems addObject: rowDict];
        
		// release our interest in all the value items
		[dateValueS release];
		[primaryKeyValue release];
		[itemValue release];
		[priceValue release];
		[groupValue release];
		[rowDict release];
	}
    
	// done with the db.  finalize the statement and close
	sqlite3_finalize (dbps);
	sqlite3_close(db);
}

- (void)viewWillAppear:(BOOL)animated
{
	[self loadDataFromDb];
	[super viewWillAppear:animated];
	[self.tableView reloadData]; 
}


#pragma mark -
#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableViewParam cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	UITableViewCell *myCell = (UITableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:@"listByPriceTableCell"];
	if (myCell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"ShoppingListTableViewCell" owner:self options:NULL];
		myCell = nibLoadedTableCell;
	} 
    // set cell contents
	UILabel *itemLabel = (UILabel*) [myCell viewWithTag:1];
	UILabel *groupLabel = (UILabel*) [myCell viewWithTag:2];
	UILabel *priceLabel = (UILabel*) [myCell viewWithTag:3];
	NSDictionary *rowVals =
    (NSDictionary*) [shoppingListItems objectAtIndex: indexPath.row];
	NSString *itemName = (NSString*) [rowVals objectForKey: ITEM_KEY];
	itemLabel.text = itemName;
	int groupid = [(NSNumber*) [rowVals objectForKey: GROUP_ID_KEY] intValue];
	groupLabel.text =  GROUP_NAMES [groupid];
	NSNumber *price = (NSNumber*) [rowVals objectForKey: PRICE_KEY];
	priceLabel.text =  [priceFormatter stringFromNumber: price];
	
	return myCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [shoppingListItems count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


#pragma mark -
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview
	[super didReceiveMemoryWarning]; 
}


- (void)dealloc
{
    [super dealloc];
}

@end
