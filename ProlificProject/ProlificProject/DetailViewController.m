//
//  DetailViewController.m
//  ProlificProject
//
//  Created by Jose Alvarado on 12/13/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import "DetailViewController.h"

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
        self.labelBookLastCheckedOut.text = @"Last Checked Out: ";
    } else {
        self.labelBookLastCheckedOut.text = [NSString stringWithFormat:@"Last Checked Out: %@ @ %@", lastCheckedOutBy, lastCheckedOut];
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
    
    NSLog(@"%@", text);
    
    if (text.length > 0) {
        NSLog(@"Do someting");
        
        NSLog(@"d %@", [self.selection objectForKey:@"url"]);
        
        NSData *jsonData = [self jsonTrackDataForUploadingToCloud:text];  // Method shown below.
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);  // To verify the jsonString.
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce%@", [self.selection objectForKey:@"url"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        
        [postRequest setHTTPMethod:@"PUT"];
        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [postRequest setHTTPBody:jsonData];
        
        NSURLResponse *response = nil;
        NSError *requestError = nil;
        NSData *returnData = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&requestError];
        
        if (requestError == nil) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode != 200) {
                    NSLog(@"Warning, status code of response was not 200, it was %ld", (long)statusCode);
                }
            }
            
            NSError *error;
            NSDictionary *returnDictionary = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:&error];
            if (returnDictionary) {
                NSLog(@"returnDictionary=%@", returnDictionary);
                
                UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Checkout Completed" message: @"Enjoy the book" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                [submitAlertView show];
                
            } else {
                NSLog(@"error parsing JSON response: %@", error);
                
                NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
                NSLog(@"returnString: %@", returnString);
            }
        } else {
            NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
            
            UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Checkout Failed" message: @"Try again later" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
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
    // NSDictionary for testing.
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
