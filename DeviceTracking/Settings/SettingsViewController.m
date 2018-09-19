//
//  SettingsViewController.m
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "SettingsViewController.h"
#import "Base.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkNotification];
}
- (IBAction)notificationSwitchClicked:(id)sender {
    [self updateNotification];
   
}
-(void)updateNotification{
 
        NSString *username = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"username"];
        NSLog(@"***username ==%@",username);
    
        
//        NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
//                                  stringForKey:@"devicenumber"];
//        NSLog(@"***devicenumber ==%@",devicenumber);
    
        NSDictionary *data = @{ @"username":username
                                };
        NSLog(@"***data ==%@",data);
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[fireBase stringByAppendingString:updateNotification]]];
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:jsonData];
        
        NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
        
        NSLog(@"Return resistration String%@",retStr);
        
        NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"response data:%@",maindic);
        
        self.status=[maindic objectForKey:@"status"];
        self.message=[maindic objectForKey:@"message"];
        if ([self.status isEqual:@"true"]) {
            
            NSLog(@"successfully disabled...");
           /* UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Successfully Disabled" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alertView dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alertView addAction:ok];
            [self presentViewController:alertView animated:YES completion:nil];*/
        }
        else{
             NSLog(@"Something went wrong...");
         /*   UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong!!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok2 = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [alertView dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
            
            [alertView addAction:ok2];
            [self presentViewController:alertView animated:YES completion:nil];*/
        }
    
}
-(void)checkNotification{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    
//    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
//                              stringForKey:@"devicenumber"];
//    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSDictionary *data = @{ @"username":username
                            };
    NSLog(@"***data ==%@",data);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[fireBase stringByAppendingString:checkNotification]]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return resistration String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    self.isEnabled=[maindic objectForKey:@"isEnabled"];
    
    if ([self.status isEqual:@"true"]) {
        
    /*    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"The Enabled Status is false" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];*/
    }
    else{
        
   /*     UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok2 = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [alertView dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
        
        [alertView addAction:ok2];
        [self presentViewController:alertView animated:YES completion:nil];*/
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

@end
