//
//  DeviceListViewController.m
//  DeviceTracking
//
//  Created by Punit on 20/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "DeviceListViewController.h"
#import "Base.h"
#import "DeviceListTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
@interface DeviceListViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;
@end

@implementation DeviceListViewController
@synthesize imgPicker;
@synthesize watchId;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    _addDeviceView.hidden=YES;
    
    _deviceListArr=[[NSMutableArray alloc]init];
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    [self.tableview setSeparatorColor:[UIColor clearColor]];
    [self parsingDeviceList];
    
}
-(void)parsingDeviceList{
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSDictionary *data = @{ @"username":username
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:getDeviceListByuserName]]];
    
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
    
    NSArray *detailArr=[maindic objectForKey:@"deviceList"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no device list." preferredStyle:UIAlertControllerStyleAlert];
        
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
    else {
        
        for(NSDictionary *temp in detailArr)
        {
            NSString *str1=[[temp objectForKey:@"id"]description];
            NSString *str2=[[temp objectForKey:@"deviceNumber"]description];
            NSString *str3=[[temp objectForKey:@"nickName"]description];
            NSString *str4=[[temp objectForKey:@"mobileNumber"]description];
            NSString *str5=[[temp objectForKey:@"username"]description];
            
            [self->_deviceListArr addObject:temp];
            NSLog(@"gallery ListArr ARRAYY%@",self->_deviceListArr);
        }
    }
    [self.tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceListArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceListTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableDictionary *ktemp=[_deviceListArr objectAtIndex:indexPath.row];
    
    cell.deviceNumber.text=[[ktemp objectForKey:@"deviceNumber"]description];
    cell.nickname.text=[[ktemp objectForKey:@"nickName"]description];
    cell.deviceId.text=[[ktemp objectForKey:@"id"]description];
    
   
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceListTableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
    
    _deviceNumber=cell.deviceNumber.text;
    _nickname=cell.nickname.text;
    _deviceId=cell.deviceId.text;
    
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSLog(@"indexpath==%ld & nickname==%@",(long)indexPath.row,_nickname);
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.nickname.text forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.deviceNumber.text forKey:@"devicenumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)modifyNicknameBtnClicked:(id)sender {
}

- (IBAction)addDeviceBtnClicked:(id)sender {
    _addDeviceView.hidden=NO;
}

- (IBAction)saveBtnClicked:(id)sender {
    [self addDeviceDataParsing];
}
-(void)addDeviceDataParsing{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
   
    NSDictionary *data = @{ @"username":username,
                            @"deviceNumber":self.watchId.text,
                            @"mobileNumber":self.mobileNum.text,
                            @"nickName":self.nickName.text
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:AddDevice]]];
    
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
    
    self.stage=[maindic objectForKey:@"stage"];
    self.message=[maindic objectForKey:@"message"];
    
    if ([self.stage isEqual:@"SUCCESS"]) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Device added successfully!!" preferredStyle:UIAlertControllerStyleAlert];
        
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
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Something went wrong!" preferredStyle:UIAlertControllerStyleAlert];
        
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
- (IBAction)dismissBtnClicked:(id)sender {
    _addDeviceView.hidden=YES;
}

- (IBAction)barcodeBtnClicked:(id)sender {
     NSLog(@"Barcode btn clicked...");
    // checking if we have at least one camera device
  /*  NSArray *allTypes = @[AVCaptureDeviceTypeBuiltInDualCamera, AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInTelephotoCamera ];
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:allTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    NSArray *devices = discoverySession.devices;
    
    BOOL hasCamera = [devices count] > 0;
    
    if (hasCamera){
        [self setupScanner];
        NSLog(@"Camera available");
    } else {
        NSLog(@"No Camera available");
    }*/
    
//        NSLog(@"Scanning..");
//        watchId.text = @"Scanning..";
//
//        ZBarReaderViewController *codeReader = [ZBarReaderViewController new];
//        codeReader.readerDelegate=self;
//        codeReader.supportedOrientationsMask = ZBarOrientationMaskAll;
//
//        ZBarImageScanner *scanner = codeReader.scanner;
//        [scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
//
//        [self presentViewController:codeReader animated:YES completion:nil];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Reading the barcode (if any) from the clipboard and setting the text.
    self.watchId.text = [UIPasteboard generalPasteboard].string;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [watchId resignFirstResponder];
    [_nickName resignFirstResponder];
    [_mobileNum resignFirstResponder];
}

@end
