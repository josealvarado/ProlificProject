//
//  DetailViewController.m
//  ProlificProject
//
//  Created by Jose Alvarado on 12/13/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import "DetailViewController.h"
#import "Settings.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@", self.selection);

    self.labelBookTitle.text = [self.selection objectForKey:@"title"];
    self.labelBookAuthor.text = [self.selection objectForKey:@"author"];
    self.labelBookPublisher.text = [NSString stringWithFormat:@"Publisher: %@", [self.selection objectForKey:@"publisher"]];
    self.labelBookTags.text = [NSString stringWithFormat:@"Tags: %@", [self.selection objectForKey:@"categories"]];
    
    NSString *lastCheckedOut = [self.selection objectForKey:@"lastCheckedOut"];
    NSString *lastCheckedOutBy = [self.selection objectForKey:@"lastCheckedOutBy"];
    
    
    if (lastCheckedOut == (id)[NSNull null] || lastCheckedOut == nil || lastCheckedOut.length == 0 || [lastCheckedOut isEqualToString:@"null"] || [lastCheckedOut isEqualToString:@"<null>"] ){
        self.labelBookLastCheckedOut.text = @"";
    } else {
        self.labelBookLastCheckedOut.text = [NSString stringWithFormat:@"%@ @ %@", lastCheckedOutBy, [self parseLastCheckedOut:lastCheckedOut]];
    }
}

- (NSString *)parseLastCheckedOut:(NSString *) lastCheckedOut{
    NSArray *dateTime = [lastCheckedOut componentsSeparatedByString:@" "];
    NSArray *date = [[dateTime objectAtIndex:0] componentsSeparatedByString:@"-"];
    
    NSArray *time = [[dateTime objectAtIndex:1] componentsSeparatedByString:@":"];
    
    int hour = [[time objectAtIndex:0] intValue];
    NSString *ampm = @"";
    if (hour > 12) {
        ampm = @"pm";
    } else {
        ampm = @"am";
    }
    
    return [NSString stringWithFormat:@"%@ %@, %@ %@:%@%@", [self getMonth:[date objectAtIndex:1]], [date objectAtIndex:2], [date objectAtIndex:0], [time objectAtIndex:0], [time objectAtIndex:1], ampm];
}

- (NSString *)getMonth:(NSString *)month{
    if ([month isEqualToString:@"01"]) {
        return @"January";
    } else if ([month isEqualToString:@"02"]) {
        return @"February";
    } else if ([month isEqualToString:@"03"]) {
        return @"March";
    } else if ([month isEqualToString:@"04"]) {
        return @"April";
    } else if ([month isEqualToString:@"05"]) {
        return @"May";
    } else if ([month isEqualToString:@"06"]) {
        return @"June";
    } else if ([month isEqualToString:@"07"]) {
        return @"July";
    } else if ([month isEqualToString:@"08"]) {
        return @"August";
    } else if ([month isEqualToString:@"09"]) {
        return @"September";
    } else if ([month isEqualToString:@"10"]) {
        return @"October";
    } else if ([month isEqualToString:@"11"]) {
        return @"November";
    } else {
        return @"December";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonSharePressed:(id)sender {
    NSString *text = [NSString stringWithFormat:@"I just rented %@ using ProlificProject!!", self.labelBookTitle.text];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text] applicationActivities:nil];
    
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)buttonCheckoutPressed:(id)sender {
    NSLog(@"here");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Checkout"
                                                    message:@"Enter your name"
                                                   delegate:self
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *text = [alertView textFieldAtIndex:0].text;
    
    if (text.length > 0) {
        NSDictionary *returnDictionary = [[Settings instance] doCurl:[self jsonTrackDataForUploadingToCloud:text] url:[NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce%@", [self.selection objectForKey:@"url"]] method:@"PUT"];
        
        if ([returnDictionary objectForKey:@"parseError"] || [returnDictionary objectForKey:@"requestError"]) {
            UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Checkout Failed" message: @"Try again later" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [submitAlertView show];
        } else {
            self.labelBookLastCheckedOut.text = [NSString stringWithFormat:@"%@ @ %@", [returnDictionary objectForKey:@"lastCheckedOutBy"], [self parseLastCheckedOut:[returnDictionary objectForKey:@"lastCheckedOut"]]];
            
            UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Checkout Completed" message: @"Enjoy the book" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [submitAlertView show];
        }
    } else {
        NSLog(@"No text entered");
        UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Checkout Cancelled" message: @"Missing name" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [submitAlertView show];
    }
}

-(NSData *)jsonTrackDataForUploadingToCloud:(NSString *) name
{
    NSDictionary *trackDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, @"lastCheckedOutBy", nil];
    
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
