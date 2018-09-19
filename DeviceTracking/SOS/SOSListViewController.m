//  SOSListViewController.m
//  DeviceTracking


#import "SOSListViewController.h"
#import "Base.h"
#import "SOSTableViewCell.h"
#import "SOS.h"
@interface SOSListViewController ()
{
    NSMutableDictionary *sosDic,*sosDic1,*sosDic2;
    NSInteger selectedUpdateIndex;
    NSString *selectedSOSNum;
}
@end

@implementation SOSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview setSeparatorColor:[UIColor clearColor]];
     _hiddenView.hidden=YES;
    
    _sosArr=[[NSMutableArray alloc]init];
    _priorityArr=[[NSMutableArray alloc]init];
    _mobilenumArr=[[NSMutableArray alloc]init];
    _tableview.delegate=self;
    _tableview.dataSource=self;

    [self getSOSList];
    
}


- (IBAction)saveBtnClicked:(id)sender {
    
    sosDic=[[NSMutableDictionary alloc]init];
    sosDic1=[[NSMutableDictionary alloc]init];
    sosDic2=[[NSMutableDictionary alloc]init];
    
    [sosDic setObject:self.priorityTxtFld.text forKey:@"mobileNumber"];
    [sosDic setObject:self.priority1.text forKey:@"priority"];
    
    [sosDic1 setObject:self.priority2TxtFld.text forKey:@"mobileNumber"];
    [sosDic1 setObject:self.priority2.text  forKey:@"priority"];
    
    [sosDic2 setObject:self.priority3TxtFld.text  forKey:@"mobileNumber"];
    [sosDic2 setObject:self.priority3.text forKey:@"priority"];
    
    NSLog(@"SOS DIC===%@",sosDic);
    _sosArr1=[NSMutableArray arrayWithObjects:sosDic,sosDic1,sosDic2,nil];
    
    NSLog(@"SOS ARRAY===%@",_sosArr1);
    
    NSString *deviceNumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***deviceNumber ==%@",deviceNumber);
    
    
    NSDictionary *data = @{ @"deviceNumber":deviceNumber,
                            @"details":_sosArr1
                            };
    
    NSLog(@"DATA REGISTRATION===%@",data);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[sosRegistration stringByAppendingString:registration]]];
    
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
    self.deviceNum=[maindic objectForKey:@"deviceNo"];
   
    NSLog(@"STATUS==%@ & message=%@ & device Num=%@",self.status,self.message,self.deviceNum);
    

   
}
-(void)getSOSList{
    
    NSString *deviceNumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***deviceNumber ==%@",deviceNumber);
    
        NSDictionary *headers = @{ @"cache-control": @"no-cache",
                                   @"postman-token": @"f9742c5c-daaa-fb2d-cdc1-391082f24cad" };
    
    NSString *urlStr=[NSString stringWithFormat:@"%@",[sosRegistration stringByAppendingString:getRegisteredMobile]];
    NSLog(@"urlStr %@",urlStr);
    
    NSString *newUrlStr = [urlStr stringByAppendingString:@"?deviceNumber="];
    NSLog(@"NEW URLL  %@",newUrlStr);
    
    NSString *newUrlStr2 = [newUrlStr stringByAppendingString:deviceNumber];
    NSLog(@"NEW URLL  %@",newUrlStr2);
    
    NSURL *url = [NSURL URLWithString:newUrlStr2];
    NSLog(@"Final  URLL %@",url);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:10.0];
        [request setHTTPMethod:@"GET"];
        [request setAllHTTPHeaderFields:headers];
        
        NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
        
        NSLog(@"Return plan String%@",retStr);
        
        NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"response data:%@",maindic);
        
        self.status=[maindic objectForKey:@"status"];
        self.message=[maindic objectForKey:@"message"];
        self.deviceNum=[maindic objectForKey:@"deviceNumber"];
        NSArray *detailArr=[maindic objectForKey:@"details"];
        
        if(detailArr.count==0)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no SOS Call list." preferredStyle:UIAlertControllerStyleAlert];
            
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
                NSString *str1=[[temp objectForKey:@"mobileNumber"]description];
                NSString *str2=[[temp objectForKey:@"priority"]description];
        
                SOS *s=[[SOS alloc]init];
                s.mobileNumStr=str1;
                s.priorityStr=str2;
                
                [self.sosArr addObject:s];
                NSLog(@"gallery ListArr ARRAYY%@",self.sosArr);
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
    return _sosArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SOSTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    SOS *ktemp=[_sosArr objectAtIndex:indexPath.row];
    
    cell.priorityNum.text=ktemp.priorityStr;
    cell.sosNumber.text=ktemp.mobileNumStr;
    cell.updateBtn.tag=indexPath.row;
    cell.sosCallBtn.tag=indexPath.row;
    NSLog(@"CELL for btn clicked in update btn=%ld",cell.updateBtn.tag);
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    SOSTableViewCell *cell=[_tableview cellForRowAtIndexPath:indexPath];
    
    _priorityStr =cell.priorityNum.text;
    _sosNumStr=cell.sosNumber.text;
    cell.updateBtn.tag=indexPath.row;
    cell.sosCallBtn.tag=indexPath.row;
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
   
    NSLog(@"indexpath==%ld",(long)indexPath.row);
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.priorityNum.text forKey:@"priorityNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.sosNumber.text forKey:@"sosNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
- (IBAction)sosCallCellBtnClicked:(UIButton*)sender {
    selectedUpdateIndex=sender.tag;
    SOS *ktemp=[_sosArr objectAtIndex:sender.tag];
    selectedSOSNum=ktemp.mobileNumStr;
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:selectedSOSNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}
- (IBAction)updateCellBtnClicked:(UIButton*)sender {
   // UIButton *btn =(UIButton *)sender;
//    updateIndex=btn.tag;
//    NSLog(@"***Update cellbutton cliked indexpath***%ld",(long)updateIndex);

    selectedUpdateIndex=sender.tag;
    SOS *ktemp=[_sosArr objectAtIndex:sender.tag];
    
    self.updateTxtFld.text=ktemp.mobileNumStr;
    self.mainUpdateView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.mainUpdateView];
    
}
- (IBAction)dismissUpdateMainView:(id)sender {
    self.mainUpdateView.hidden=YES;
}

- (IBAction)dismissBtnClicked:(id)sender {
    _hiddenView.hidden=YES;
}

- (IBAction)addSosBtnClicked:(id)sender {
    _hiddenView.hidden=NO;
}


- (IBAction)saveUpdateBtnClicked:(UIButton*)sender {
    
     SOS *ktemp=[_sosArr objectAtIndex:selectedUpdateIndex];
    NSString *priorityNum=ktemp.priorityStr;
    
    [self sosUpdateList:priorityNum];
    
}
-(void)sosUpdateList:(NSString *)priorityNum{
    
    SOS *ktemp=[_sosArr objectAtIndex:selectedUpdateIndex];
    
    NSString *deviceNumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***deviceNumber ==%@",deviceNumber);
    NSString *priorityNo=priorityNum;
    
    NSString *sosNum =ktemp.mobileNumStr;
    
    
    NSDictionary *data = @{ @"deviceNo":deviceNumber,
                            @"from":sosNum,
                            @"to":self.updateTxtFld.text,
                            @"priority":priorityNo
                            };
    NSLog(@"SOS DATA === %@",data);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[sosRegistration stringByAppendingString:update]]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return sos registration String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"messages"];
    self.deviceNum=[maindic objectForKey:@"deviceNo"];
    self.fromNum=[maindic objectForKey:@"from"];
    self.toNum=[maindic objectForKey:@"to"];
    self.priority=[maindic objectForKey:@"priority"];
    
    NSLog(@"STATUS==%@ & message=%@",self.status,self.message);
    
    if ([self.status isEqual:@"true"]) {
        NSLog(@"SOS updated Successfully");
        [self getSOSList];
    }
    else{
        
        NSLog(@"Something went wrong!");
    }
}

@end
