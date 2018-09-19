//
//  GetDeviceListController.m
//  DeviceTracking

#import "GetDeviceListController.h"
#import "Base.h"
@interface GetDeviceListController ()

@end

@implementation GetDeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    [self parsingDeviceList];
}
-(void)parsingDeviceList{
    
    NSString *deviceNumber = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"devicenumber"];
    NSLog(@"***deviceNumber ==%@",deviceNumber);
    
    NSDictionary *data = @{ @"deviceNumber":deviceNumber
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:getDevice]]];
    
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
    self.message=[maindic objectForKey:@"messages"];
    self.device=[maindic objectForKey:@"device"];
    
     NSDictionary *dic=[maindic objectForKey:@"device"];
    
    self.username.text=[dic objectForKey:@"username"];
    self.nickname.text=[dic objectForKey:@"nickName"];
    self.mobileNum.text=[dic objectForKey:@"mobileNumber"];
    self.deviceNumber.text=[dic objectForKey:@"deviceNumber"];
    
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
