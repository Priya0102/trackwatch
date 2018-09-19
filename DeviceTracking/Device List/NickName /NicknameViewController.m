//
//  NicknameViewController.m
//  DeviceTracking
//
//  Created by Punit on 23/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "NicknameViewController.h"
#import "NicknameTableViewCell.h"

#import "Base.h"

#import "Nickname.h"
@interface NicknameViewController ()
{
       NSInteger selectedUpdateIndex;
}
@end

@implementation NicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _deviceListArr=[[NSMutableArray alloc]init];
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
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
            
            Nickname *n=[[Nickname alloc]init];
            n.nickIdStr=str1;
            n.deviceNumStr=str2;
            n.nickNameStr=str3;
            n.mobileNumStr=str4;
            n.usernameStr=str5;
            
    
            [self.deviceListArr addObject:n];
            NSLog(@"gallery ListArr ARRAYY%@",self.deviceListArr);
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
    NicknameTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Nickname *ktemp=[_deviceListArr objectAtIndex:indexPath.row];
    //NSMutableDictionary *ktemp=[_deviceListArr objectAtIndex:indexPath.row];
    
    cell.deviceNumber.text=ktemp.deviceNumStr;
    cell.nickname.text=ktemp.nickNameStr;
    cell.nickNameBtn.tag=indexPath.row;
    //[cell.saveBtn addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NicknameTableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
    
    _deviceNumStr =cell.deviceNumber.text;
    _nickNameStr=cell.nickname.text;
    cell.nickNameBtn.tag=indexPath.row;
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    
    NSLog(@"indexpath==%ld",(long)indexPath.row);
    

    
    
}
- (IBAction)updateCellBtnClicked:(UIButton*)sender {
    selectedUpdateIndex=sender.tag;
    Nickname *ktemp=[_deviceListArr objectAtIndex:sender.tag];
    
    self.updateTxtFld.text=ktemp.nickNameStr;
    self.mainUpdateView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.mainUpdateView];
}
- (IBAction)dismissUpdateMainView:(id)sender {
    self.mainUpdateView.hidden=YES;
}
- (IBAction)saveUpdateBtnClicked:(UIButton*)sender {
    
    Nickname *ktemp=[_deviceListArr objectAtIndex:selectedUpdateIndex];
    NSString *deviceNum=ktemp.deviceNumStr;
    
    [self nicknameUpdateList:deviceNum];
    
}
-(void)nicknameUpdateList:(NSString *)deviceNum{
    
      Nickname *ktemp=[_deviceListArr objectAtIndex:selectedUpdateIndex];
//    NSString *newnickname = [[NSUserDefaults standardUserDefaults]
//                          stringForKey:@"newnickname"];
//    NSLog(@"***newnickname ==%@",newnickname);
      NSString *devicenumber =ktemp.deviceNumStr;
    
//    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
//                              stringForKey:@"devicenumber"];
//    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSDictionary *data = @{ @"nickName":self.updateTxtFld.text,
                            @"deviceNumber":devicenumber
                            };
     NSLog(@"nickname DATA === %@",data);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:updateNickName]]];
    
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
    if ([self.status isEqual:@"true"]) {
        [self parsingDeviceList];
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Nickname updated Successfully" preferredStyle:UIAlertControllerStyleAlert];
        
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
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok2 = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok2];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
    
}


@end
