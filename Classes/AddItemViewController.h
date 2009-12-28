//
//  AddItemViewController.h
//  DatabaseShoppingList
//
//  Created by Steve Baker on 12/28/09.
//  Copyright Beepscore LLC 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddItemViewController : UIViewController <UIPickerViewDelegate,
UIPickerViewDataSource, UITextFieldDelegate> {

    UITextField *itemNameField;
    UITextField *priceField;
    UIPickerView *groupPicker;
    UILabel *statusLabel;
}
#pragma mark -
#pragma mark properties

@property(nonatomic,retain)IBOutlet UITextField *itemNameField;
@property(nonatomic,retain)IBOutlet UITextField *priceField;
@property(nonatomic,retain)IBOutlet UIPickerView *groupPicker;
@property(nonatomic,retain)IBOutlet UILabel *statusLabel;

- (IBAction)addShoppingListItem:(id)sender;

@end
