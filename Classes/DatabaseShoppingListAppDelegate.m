//
//  DatabaseShoppingListAppDelegate.m
//  DatabaseShoppingList
//
//  Created by Chris Adamson on 3/27/09.
//  Copyright Subsequently and Furthermore, Inc. 2009. All rights reserved.
//
//
//  Licensed with the Apache 2.0 License
//  http://apache.org/licenses/LICENSE-2.0
//

#import "DatabaseShoppingListAppDelegate.h"


@implementation DatabaseShoppingListAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize dbFilePath;

NSString *DATABASE_RESOURCE_NAME = @"shopping";
NSString *DATABASE_RESOURCE_TYPE = @"db";
NSString *DATABASE_FILE_NAME = @"shopping.db";

- (BOOL) initializeDb
{
	NSLog (@"initializeDB");
    
	// Find Documents directory
	// Use Apple's preferred way to find the Documents directory.  Ref Dudney Ch 10 p 193    
	NSArray *searchPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	dbFilePath = [documentFolderPath 
                  stringByAppendingPathComponent:DATABASE_FILE_NAME];
	NSLog (@"dbFilePath = %@", dbFilePath);
    
	[dbFilePath retain];
    
	//  Copy database file to documents directory
	if (! [[NSFileManager defaultManager] fileExistsAtPath:dbFilePath])
    {
		// didn't find db, need to copy
		NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:DATABASE_RESOURCE_NAME
                                  ofType:DATABASE_RESOURCE_TYPE];
		if (nil == backupDbPath)
        {
			// couldn't find backup db to copy, bail
			return NO;
		} else
        {
			BOOL copiedBackupDb = [[NSFileManager defaultManager]
                                   copyItemAtPath:backupDbPath
                                   toPath:dbFilePath
                                   error:nil];
			if (! copiedBackupDb)
            {
				// copying backup db failed, bail
				return NO;
			}
		}
	}
	return YES;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	// copy the database from the bundle if necessary
	if (! [self initializeDb])
    {
		// TODO: alert the user!
		NSLog (@"couldn't init db");
		return;
	}	
	
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


- (void)dealloc
{
    [tabBarController release], tabBarController = nil;
    [window release], window = nil;
    [super dealloc];
}

@end

