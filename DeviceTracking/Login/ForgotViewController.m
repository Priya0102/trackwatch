//
//  ForgotViewController.m
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "ForgotViewController.h"
#import "Base.h"
@interface ForgotViewController ()

@end

@implementation ForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _emailView.clipsToBounds = YES;
    _emailView.layer.cornerRadius = 22;
    
    _forgotBtn.clipsToBounds = YES;
    _forgotBtn.layer.cornerRadius = 20;
}
- (IBAction)forgotBtnClicked:(id)sender {
    
    [self forgotdataParsing];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:(BOOL)animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)forgotdataParsing{
    
    NSDictionary *data = @{
                           @"email":self.emailIdTxtField.text
                        };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:forgotPassword]]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);

    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    
    NSLog(@"status==%@& message=%@",self.status,self.message);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
    }];
    if ([self.status isEqual:@"1"])
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Reset Url Link Send To Your Mail ID" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else
    {
        NSLog(@"Error when status is false...");
    }
 
}



@end
