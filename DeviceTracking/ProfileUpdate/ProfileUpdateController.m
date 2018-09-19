
//  ProfileUpdateController.m
//  DeviceTracking
//  Created by Punit on 30/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.

#import "ProfileUpdateController.h"
#import "Base.h"
@interface ProfileUpdateController ()

@end

@implementation ProfileUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self userUpdatedDetail];
}

-(void)userUpdatedDetail{
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSString *data = [NSString stringWithFormat:@"%@",username];
    NSData *updata = [data dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString *base64str = [NSString stringWithFormat:@"Basic %@", [updata base64Encoding]];
    NSDictionary *headers = @{ @"content-type": @"json/application",
                               @"authorization": base64str };
    
    NSString *urlStr=[NSString stringWithFormat:@"%@",[userReg stringByAppendingString:updateSignUp]];
    NSLog(@"urlStr %@",urlStr);
    
    NSString *newUrlStr = [urlStr stringByAppendingString:username];
    NSLog(@"NEW URLL  %@",newUrlStr);
    
    NSURL *url = [NSURL URLWithString:newUrlStr];
    NSLog(@" URLL %@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newUrlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            
            NSLog(@"Success: %@", data);
            
            NSError *err;
            NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
            
            NSLog(@"Return String%@",retStr);
//            NSArray *jsonArray  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
//            NSLog(@"JSON DATA%@",jsonArray);
            
            NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"response data:%@",maindic);
            
          
            self.status=[maindic objectForKey:@"status"];
            self.message=[maindic objectForKey:@"message"];
            self.userRegistrations=[maindic objectForKey:@"userRegistrations"];
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
            }];
            dispatch_sync(dispatch_get_main_queue(), ^{
        
            NSDictionary *dic=[maindic objectForKey:@"userRegistrations"];
            
            self.userId.text=[[dic objectForKey:@"userId"]description];
            self.username.text=[[dic objectForKey:@"username"]description];
            self.password.text=[[dic objectForKey:@"password"]description];
            self.email.text=[[dic objectForKey:@"email"]description];
            self.contactNum.text=[[dic objectForKey:@"contactNumber"]description];
            self.address.text=[[dic objectForKey:@"address"]description];
            
            NSLog(@"User Id===%@ & username==%@ status=%@",self.userId.text,self.username.text,self.status);
            
            [[NSUserDefaults standardUserDefaults] setObject:self.userId.text forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.email.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.contactNum.text forKey:@"contactNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.address.text forKey:@"address"];
            [[NSUserDefaults standardUserDefaults] synchronize];
                
            });
        }
    }];
   [dataTask resume];
}



@end
