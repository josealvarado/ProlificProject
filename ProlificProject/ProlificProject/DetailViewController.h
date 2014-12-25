//
//  DetailViewController.h
//  ProlificProject
//
//  Created by Jose Alvarado on 12/13/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIAlertViewDelegate>


- (IBAction)buttonSharePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelBookTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelBookAuthor;

@property (weak, nonatomic) IBOutlet UILabel *labelBookPublisher;

@property (weak, nonatomic) IBOutlet UILabel *labelBookTags;

@property (weak, nonatomic) IBOutlet UILabel *labelBookLastCheckedOut;

- (IBAction)buttonCheckoutPressed:(id)sender;

@property (copy, nonatomic) NSDictionary *selection;
@property (weak, nonatomic) id delegate;

@end
