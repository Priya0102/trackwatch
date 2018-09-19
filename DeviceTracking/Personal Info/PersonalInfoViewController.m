//
//  PersonalInfoViewController.m
//  DeviceTracking
//
//  Created by Punit on 20/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "Base.h"
@interface PersonalInfoViewController ()
{
    __weak IBOutlet UIButton *maleBtn;
    __weak IBOutlet UIButton *femaleBtn;
}
@end

@implementation PersonalInfoViewController
@synthesize maleBtn;
@synthesize femaleBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);

    
    NSString *email = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"email"];
    NSLog(@"***email ==%@",email);
    
    NSString *contactNumber = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"contactNumber"];
    NSLog(@"***contactNumber ==%@",contactNumber);
    
    
    
    self.username.text=username;
    self.contactNum.text=contactNumber;
    self.email.text=email;

    
    [maleBtn addTarget:self action:@selector(maleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [femaleBtn addTarget:self action:@selector(femaleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)maleButtonAction{
    
    _genderTypeStr=@"Male";
    
    [maleBtn setImage:[UIImage imageNamed:@"clicked64.png"] forState:UIControlStateNormal];
    [femaleBtn setImage:[UIImage imageNamed:@"unclicked64.png"] forState:UIControlStateNormal];
    
}
-(void)femaleButtonAction{
    
    _genderTypeStr=@"Female";
    
    [femaleBtn setImage:[UIImage imageNamed:@"clicked64.png"] forState:UIControlStateNormal];
    [maleBtn setImage:[UIImage imageNamed:@"unclicked64.png"] forState:UIControlStateNormal];
    
}

- (IBAction)saveBtnClicked:(id)sender {
    [self personalInfoUpdate];
}

-(void)personalInfoUpdate{
  
    NSString *userId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userId"];
    NSLog(@"***userId ==%@",userId);

    NSString *password = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"password"];
    NSLog(@"***password ==%@",password);
    
    NSString *address = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"address"];
    NSLog(@"***address ==%@",address);
    
    NSDictionary *data = @{
                           @"userId":userId,
                           @"username":self.username.text ,
                           @"password": password,
                           @"email":self.email.text,
                           @"contactNumber":self.contactNum.text,
                           @"address":address,
                           @"name":self.name.text,
                           @"gender":_genderTypeStr
                           };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[userReg stringByAppendingString:updatePersonalInfo]]];
    
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
    
    
    
    NSLog(@"status==%@& message=%@",self.status,self.message);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
    }];
    if ([self.status isEqual:@"1"]) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"User Updated Successfully" preferredStyle:UIAlertControllerStyleAlert];
        
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
    else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:self.message preferredStyle:UIAlertControllerStyleAlert];
        
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
}
@end
