//
//  AddABookViewController.m
//  ProlificProject
//
//  Created by Jose Alvarado on 12/13/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import "AddABookViewController.h"
#import "Settings.h"

@interface AddABookViewController ()

@end

@implementation AddABookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonDonePressed:(id)sender {
    if (self.textFieldBookTitle.text.length > 0 || self.textFieldAuthor.text.length > 0 || self.textFieldCategories.text.length > 0 || self.textFieldPublisher.text.length > 0) {
        
        UIAlertView* alert_view = [[UIAlertView alloc]
                                   initWithTitle: @"Text Detected" message: @"Are sure you want to quit" delegate: self
                                   cancelButtonTitle: @"Cancel" otherButtonTitles: @"YES", nil];
        [alert_view show];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)buttonSubmitPressed:(id)sender {
    if (self.textFieldBookTitle.text.length > 0 && self.textFieldAuthor.text.length > 0) {
        NSDictionary *returnDictionary = [[Settings instance] doCurl:[self jsonTrackDataForUploadingToCloud] url:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce/books/" method:@"POST"];
        
        if ([returnDictionary objectForKey:@"parseError"] || [returnDictionary objectForKey:@"requestError"]) {
            UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Adding Failed" message: @"Try again later" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [submitAlertView show];
        } else {
            self.textFieldBookTitle.text = @"";
            self.textFieldAuthor.text = @"";
            self.textFieldPublisher.text = @"";
            self.textFieldCategories.text = @"";
            
            UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Adding Completed" message: @"Book was succesfully added" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [submitAlertView show];
        }
    } else {
        UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Missing Information" message: @"Book title and author required." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [submitAlertView show];
    }
}

-(NSData *)jsonTrackDataForUploadingToCloud
{
    NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.textFieldBookTitle.text , @"title", self.textFieldAuthor.text, @"author", self.textFieldPublisher.text, @"publisher", self.textFieldCategories.text, @"categories", @"", @"lastCheckedOutBy", nil];
    
    if ([NSJSONSerialization isValidJSONObject:trackDictionary]) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:trackDictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error == nil && jsonData != nil) {
            return jsonData;
        } else {
            NSLog(@"Error creating JSON data: %@", error);
            return nil;
        }
        
    } else {
        
        NSLog(@"trackDictionary is not a valid JSON object.");
        return nil;
    }
}

@end
