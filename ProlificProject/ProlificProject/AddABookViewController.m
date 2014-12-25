//
//  AddABookViewController.m
//  ProlificProject
//
//  Created by Jose Alvarado on 12/13/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import "AddABookViewController.h"

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
        
        NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
        [postData setValue:self.textFieldBookTitle.text forKey:@"title"];
        [postData setValue:self.textFieldAuthor.text forKey:@"author"];
        [postData setValue:self.textFieldPublisher.text forKey:@"publisher"];
        [postData setValue:self.textFieldCategories.text forKey:@"categories"];
        [postData setValue:@"Jose" forKey:@"lastCheckedOutBy"];
        
        
        ////////////////////////////////////////////////
        
        
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURL *url = [NSURL URLWithString:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce/books"];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        NSData *requestData = [NSKeyedArchiver archivedDataWithRootObject:postData];
//
//        [request setHTTPBody: requestData];
//
//        [request setHTTPMethod: @"POST"];
//                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//                [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
//        
//        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            // The server answers with an error because it doesn't receive the params
//            
//            NSLog(@"error %@", error);
//            NSLog(@"response %@", response);
//            
//            NSMutableDictionary *response2 = [NSJSONSerialization JSONObjectWithData:data
//                                                                                                                 options:NSJSONReadingMutableContainers
//                                                                                                                   error:nil];
//            NSLog(@"haha %@", response2);
//            
//        }];
//        [postDataTask resume];
        
        /////////////////////////////////////////////////////////////////

//        NSData *requestData = [NSKeyedArchiver archivedDataWithRootObject:postData];
//        
////        NSData *jsonString = [NSJSONSerialization dataWithJSONObject:postData options:nil error:nil];
//
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce/books"]
//                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                           timeoutInterval:10];
//        
//        [request setHTTPMethod: @"POST"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
//        [request setHTTPBody: requestData];
//        
//        NSError *requestError;
//        NSURLResponse *urlResponse = nil;
//        
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
//        
//        if (requestError) {
//            NSLog(@"requestError: %@", requestError);
//        } else {
//            NSLog(@"%@", responseData);
//            
//            NSMutableDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
//                                                                    options:NSJSONReadingMutableContainers
//                                                                      error:nil];
//            NSLog(@"haha %@", response);
//            NSLog(@"Count haha %lu", (unsigned long)[response count]);
//    
//            [self dismissViewControllerAnimated:YES completion:nil];
//
//        }
        
        ////////////////////////////////////////////////////////////////////
        
        NSData *jsonData = [self jsonTrackDataForUploadingToCloud];  // Method shown below.
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);  // To verify the jsonString.
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce/books/"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
                                                                                [postRequest setHTTPMethod:@"POST"];
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
            } else {
                NSLog(@"error parsing JSON response: %@", error);
                
                NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
                NSLog(@"returnString: %@", returnString);
            }
        } else {
            NSLog(@"NSURLConnection sendSynchronousRequest error: %@", requestError);
        }
        
        
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    } else {
        UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Missing Information" message: @"Book title and author required." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [submitAlertView show];
    }
}




-(NSData *)jsonTrackDataForUploadingToCloud
{
    // NSDictionary for testing.
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




















- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

@end
