//
//  BookListTableViewController.m
//  ProlificProject
//
//  Created by Jose Alvarado on 11/23/14.
//  Copyright (c) 2014 JoseAlvarado. All rights reserved.
//

#import "BookListTableViewController.h"
#import "Settings.h"

@interface BookListTableViewController ()

@end

@implementation BookListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce/books"]
                                                           cachePolicy:0
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    if (requestError) {
        NSLog(@"requestError: %@", requestError);
    } else {
        NSMutableArray *books = [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
        
        NSLog(@"Count %lu", (unsigned long)[books count]);
        
        
        [Settings instance].books = books;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[Settings instance].books count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [[[Settings instance].books objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[[Settings instance].books objectAtIndex:indexPath.row] objectForKey:@"author"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *book = [[Settings instance].books objectAtIndex:indexPath.row];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:book options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary *returnDictionary = [[Settings instance] doCurl:jsonData url:[NSString stringWithFormat:@"http://prolific-interview.herokuapp.com/546109c17fdcff000718ffce%@", [book objectForKey:@"url"]] method:@"DELETE"];
        
        if ([returnDictionary objectForKey:@"parseError"] || [returnDictionary objectForKey:@"requestError"]) {
            UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle: @"Deletion Failed" message: @"Try again later" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [submitAlertView show];
        } else {
            
            [[Settings instance].books removeObjectAtIndex:indexPath.row];
            
            [tableView reloadData];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
        
        NSDictionary *book =[Settings instance].books[selectedIndexPath.row];
        
        [destination setValue:book forKey:@"selection"];
    }
}


@end
