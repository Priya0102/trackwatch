//
//  DeviceOrderViewController.m
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "DeviceOrderViewController.h"
#import "Base.h"

@interface DeviceOrderViewController ()

@end

@implementation DeviceOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstnameView.clipsToBounds = YES;
    _firstnameView.layer.cornerRadius = 22;
    
    _lastnameView.clipsToBounds = YES;
    _lastnameView.layer.cornerRadius = 22;
    
    _emailView.clipsToBounds = YES;
    _emailView.layer.cornerRadius = 22;
    
    _contactView.clipsToBounds = YES;
    _contactView.layer.cornerRadius = 22;
    
    _address1View.clipsToBounds = YES;
    _address1View.layer.cornerRadius = 22;
    
    _address2View.clipsToBounds = YES;
    _address2View.layer.cornerRadius = 22;
    
    _cityView.clipsToBounds = YES;
    _cityView.layer.cornerRadius = 22;
    
    _stateView.clipsToBounds = YES;
    _stateView.layer.cornerRadius = 22;
    
    _countryView.clipsToBounds = YES;
    _countryView.layer.cornerRadius = 22;
    
    _pincodeView.clipsToBounds = YES;
    _pincodeView.layer.cornerRadius = 22;
    
    _numOfDeviceView.clipsToBounds = YES;
    _numOfDeviceView.layer.cornerRadius = 22;
    
    _usernameView.clipsToBounds=YES;
    _usernameView.layer.cornerRadius=22;
    
    _placeOrderBtn.clipsToBounds = YES;
    _placeOrderBtn.layer.cornerRadius = 20;
    
  
}

- (IBAction)deviceOrderBtnClicked:(id)sender {
    
    [self deviceOrderParsing];
    
}

-(void)deviceOrderParsing{
    
    NSDictionary *data = @{
                           @"firstName":self.firstnameTxtFld.text ,
                           @"lastName":self.lastnameTxtFld.text ,
                           @"email":self.emailTxtFld.text ,
                           @"contactNumber":self.phoneNumberTxtFld.text ,
                           @"address1": self.address1TxtFld.text,
                           @"address2":self.address2TxtFld.text ,
                           @"city":self.cityTxtFld.text ,
                           @"state":self.stateTxtFld.text ,
                           @"country":self.countryTxtFld.text ,
                           @"pinCode": self.pinCodeTxtFld.text,
                           @"numberOfDevices":self.numberOfDevicesTxtFld.text ,
                           @"username": self.usernameTxtFld.text
                           };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:saveOrder]]];
    
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
    self.orderId=[maindic objectForKey:@"orderId"];
    
   
    
    NSLog(@"status==%@& message=%@ orderId==%@",self.status,self.message,self.orderId);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
    }];
    if ([self.status isEqual:@"1"]) {
        
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
    else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Alert" message:self.message preferredStyle:UIAlertControllerStyleAlert];
        
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
