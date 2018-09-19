
//  SafeZoneViewController.m
//  DeviceTracking
//  Created by Punit on 25/08/18.
#import "Base.h"
#import "SafeZoneViewController.h"
#import "SafeZoneTableViewCell.h"
#import "SafeZone.h"

@interface SafeZoneViewController (){
 NSInteger anIndex;
 NSInteger updateIndex;
 NSInteger selectedUpdateIndex;
}

@end

@implementation SafeZoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _safeZoneArr=[[NSMutableArray alloc]init];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    
    [_tableview setSeparatorColor:[UIColor clearColor]];
   
}
-(void)viewWillAppear:(BOOL)animated{
 
    [super viewWillAppear:animated];
    [self parsingSafeZoneData];
    [self.tableview reloadData];

}

-(void)parsingSafeZoneData{
   
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSDictionary *data = @{ @"userName":username,
                            @"deviceNumber":devicenumber
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[safeUrl stringByAppendingString:SafeZoneBy]]];
    
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
    
    NSArray *detailArr=[maindic objectForKey:@"devicezones"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no safe zone." preferredStyle:UIAlertControllerStyleAlert];
        
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
            NSString *str2=[[temp objectForKey:@"userId"]description];
            NSString *str3=[[temp objectForKey:@"deviceNumber"]description];
            NSString *str4=[[temp objectForKey:@"latitude"]description];
            NSString *str5=[[temp objectForKey:@"longitude"]description];
            NSString *str6=[[temp objectForKey:@"distance"]description];
            NSString *str7=[[temp objectForKey:@"username"]description];
            NSString *str8=[[temp objectForKey:@"placeName"]description];
            NSString *str9=[[temp objectForKey:@"alternatePlaceName"]description];

            SafeZone *s=[[SafeZone alloc]init];
            s.idStr=str1;
            s.userIdStr=str2;
            s.devicenumStr=str3;
            s.latStr=str4;
            s.longStr=str5;
            s.distanceStr=str6;
            s.usernameStr=str7;
            s.placeNameStr=str8;
            s.alternatePlaceNameStr=str9;
            
            [self.safeZoneArr addObject:s];
            NSLog(@"safe zone ListArr ARRAYY%@",self.safeZoneArr);
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
    return _safeZoneArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SafeZoneTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SafeZone *ktemp=[_safeZoneArr objectAtIndex:indexPath.row];
   // NSMutableDictionary *ktemp=

    cell.userId.text=ktemp.userIdStr;
    cell.placeName.text=ktemp.placeNameStr;
    cell.alternatePlaceName.text=ktemp.alternatePlaceNameStr;
    cell.distance.text=ktemp.distanceStr;
    cell.safeZoneId.text=ktemp.idStr;
    
    cell.deleteBtn.tag=indexPath.row;
    cell.updateBtn.tag=indexPath.row;
    
    
    //[cell.updateBtn addTarget:self action:@selector(upDatebuttonclicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteBtn addTarget:self action:@selector(deletebuttonclicked:) forControlEvents:UIControlEventTouchUpInside];
   
    
    NSLog(@"Safe zone ID==%@",cell.safeZoneId.text);

    
    [[NSUserDefaults standardUserDefaults] setObject:cell.safeZoneId.text forKey:@"safeZoneId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.placeName.text forKey:@"placeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.userId.text forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults]setValue:cell.alternatePlaceName.text forKey:@"alternatePlaceName"];
    NSLog(@"alternatePlaceName= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"alternatePlaceName"]);
    
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SafeZoneTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   // NSMutableDictionary *ktemp=[_safeZoneArr objectAtIndex:indexPath.row];
     SafeZone *ktemp=[_safeZoneArr objectAtIndex:indexPath.row];
    cell.safeZoneId.text=ktemp.idStr;
    
    _safeZoneIdStr=cell.safeZoneId.text;
    _placeNameStr=cell.placeName.text;
    _userIdStr=cell.userId.text;
    cell.deleteBtn.tag=indexPath.row;
    cell.updateBtn.tag=indexPath.row;
    
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSLog(@"in did select safeZoneId id=%@",cell.safeZoneId.text);
    
  
    [[NSUserDefaults standardUserDefaults] setObject:cell.safeZoneId.text forKey:@"safeZoneId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.placeName.text forKey:@"placeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.userId.text forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults]setValue:cell.alternatePlaceName.text forKey:@"alternatePlaceName"];
    NSLog(@"alternatePlaceName= %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"alternatePlaceName"]);
    
    
    
}
- (IBAction)updateCellBtnClicked:(UIButton*)sender {
   
    selectedUpdateIndex=sender.tag;
    SafeZone *ktemp=[_safeZoneArr objectAtIndex:sender.tag];
    
    self.alternatePlace.text=ktemp.alternatePlaceNameStr;
    self.distanceSliderLabel.text=ktemp.distanceStr;
    self.mainUpdateView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.mainUpdateView];
    
}
- (IBAction)dismissUpdateMainView:(id)sender {
    self.mainUpdateView.hidden=YES;
}

- (IBAction)saveUpdateBtnClicked:(UIButton*)sender {
    
    SafeZone *ktemp=[_safeZoneArr objectAtIndex:selectedUpdateIndex];
    NSString *safeZoneId=ktemp.idStr;
    
    [self safeZoneUpdateList:safeZoneId];
    
    
}
-(void)safeZoneUpdateList:(NSString *)safeZoneId{
    
    SafeZone *ktemp=[_safeZoneArr objectAtIndex:selectedUpdateIndex];
    
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSString *placeName = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"placeName"];
    NSLog(@"***placeName ==%@",placeName);
    
    NSString *latitude = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"latitude"];
    NSLog(@"***latitude ==%@",latitude);
    
    NSString *longitude = [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"longitude"];
    NSLog(@"***longitude ==%@",longitude);
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userid"];
    NSLog(@"***userid ==%@",userid);

    NSString *safezoneIdStr =ktemp.idStr;
    //NSString *safeZoneId = [[NSUserDefaults standardUserDefaults] stringForKey:@"safeZoneId"];
    NSLog(@"***safeZoneId ==%@",safeZoneId);
    
    NSDictionary *data = @{ @"username":username,
                            @"deviceNumber":devicenumber,
                            @"latitude":latitude,
                            @"longitude":longitude,
                            @"distance":self.distanceSliderLabel.text,
                            @"placeName":placeName,
                            @"alternatePlaceName":self.alternatePlace.text,
                            @"safeZoneId":safezoneIdStr,
                            @"userId":userid
                            };
    NSLog(@"DATA====%@",data);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[safeUrl stringByAppendingString:updateSafeZone]]];
    
    NSLog(@"***url====%@",url);

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return updateSafe zone String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    
    NSArray *detailArr=[maindic objectForKey:@"devicezones"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no update safe zone." preferredStyle:UIAlertControllerStyleAlert];
        
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
            NSString *str2=[[temp objectForKey:@"userId"]description];
            NSString *str3=[[temp objectForKey:@"deviceNumber"]description];
            NSString *str4=[[temp objectForKey:@"latitude"]description];
            NSString *str5=[[temp objectForKey:@"longitude"]description];
            NSString *str6=[[temp objectForKey:@"distance"]description];
            NSString *str7=[[temp objectForKey:@"username"]description];
            NSString *str8=[[temp objectForKey:@"placeName"]description];
            NSString *str9=[[temp objectForKey:@"alternatePlaceName"]description];
            
            SafeZone *s=[[SafeZone alloc]init];
            s.idStr=str1;
            s.userIdStr=str2;
            s.devicenumStr=str3;
            s.latStr=str4;
            s.longStr=str5;
            s.distanceStr=str6;
            s.usernameStr=str7;
            s.placeNameStr=str8;
            s.alternatePlaceNameStr=str9;
            
            [self.safeZoneArr addObject:s];
            
            //[self.safeZoneArr addObject:temp];
            NSLog(@"updateSafeZone ARRAYY%@",self.safeZoneArr);
        }
    }
    [self.tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

-(void)deletebuttonclicked:(id)sender{
    
    UIButton *btn =(UIButton *)sender;
    anIndex=btn.tag;
    NSLog(@"***INDEX***%ld",(long)anIndex);
 
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure,you want to delete zone?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes,Delete"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self deleteSafeZoneParsing];
                             
                             [self.safeZoneArr removeObjectAtIndex:anIndex];
                             [self.tableview reloadData];
                             [alertView dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No,thanks"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   
                               NSLog(@"You pressed No,thanks button");
                                   
                               }];
    
    [alertView addAction:ok];
    [alertView addAction:noButton];
    [self presentViewController:alertView animated:YES completion:nil];
    
    
}
-(void)deleteSafeZoneParsing{
    
    NSString *safeZoneId = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"safeZoneId"];
    NSLog(@"***safeZoneId ==%@",safeZoneId);

    NSDictionary *data = @{ @"safeZoneId":safeZoneId
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[safeUrl stringByAppendingString:DeleteSafeZone]]];
    NSLog(@"urlllll%@",url);
    
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
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Safe Zone is deleted Successfully" preferredStyle:UIAlertControllerStyleAlert];
        
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
        
//        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong!!" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* ok2 = [UIAlertAction
//                              actionWithTitle:@"OK"
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  [alertView dismissViewControllerAnimated:YES completion:nil];
//
//                              }];
//
//        [alertView addAction:ok2];
//        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (IBAction)sliderValueChanged:(id)sender {
    self.distanceSliderLabel.text = [NSString stringWithFormat:@"%0.2f", self.distanceSlider.value];
}


@end
