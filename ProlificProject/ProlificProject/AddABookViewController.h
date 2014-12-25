//
//  AddABookViewController.h
//  ProlificProject
//
//  Created by Jose Alvarado on 12/13/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddABookViewController : UIViewController<UIAlertViewDelegate>{
    NSMutableData *responseData;
}

- (IBAction)buttonDonePressed:(id)sender;

- (IBAction)buttonSubmitPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textFieldBookTitle;

@property (weak, nonatomic) IBOutlet UITextField *textFieldAuthor;

@property (weak, nonatomic) IBOutlet UITextField *textFieldPublisher;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCategories;



@end
