//
//  ViewController.h
//  update
//
//  Created by Matt Vaznaian on 9/28/12.
//  Copyright (c) 2012 StackMob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackMob.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) NSString *todoId;

- (IBAction)updateObject:(id)sender;

@end