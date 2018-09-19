//
//  PlanViewController.m
//  DeviceTracking

#import "PlanViewController.h"
#import "Base.h"
#import "PlanCollectionViewCell.h"
#import "WebViewController.h"

@interface PlanViewController ()

@end

@implementation PlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _planArr=[[NSMutableArray alloc]init];

    _myCollectionView.delegate=self;
    _myCollectionView.dataSource=self;
    
    
    [self parsingData];
}
-(void)parsingData{
    
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"f9742c5c-daaa-fb2d-cdc1-391082f24cad" };
  
      NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:getDevicePlans]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return plan String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    
    NSArray *detailArr=[maindic objectForKey:@"devicePlansVOs"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no subscription plan." preferredStyle:UIAlertControllerStyleAlert];
        
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
            NSString *str1=[[temp objectForKey:@"planType"]description];
            NSString *str2=[[temp objectForKey:@"planAmount"]description];
            NSString *str3=[[temp objectForKey:@"discount"]description];
            NSString *str4=[[temp objectForKey:@"offer"]description];
            NSString *str5=[[temp objectForKey:@"numberOfDays"]description];
            NSString *str6=[[temp objectForKey:@"deviceNumber"]description];
            NSString *str7=[[temp objectForKey:@"id"]description];
            
            
            [self->_planArr addObject:temp];
            NSLog(@"gallery ListArr ARRAYY%@",self->_planArr);
        }
    }
    [self.myCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.myCollectionView reloadData];
    });
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    return _planArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlanCollectionViewCell *cell=[_myCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableDictionary *ktemp=[_planArr objectAtIndex:indexPath.row];
    cell.planType.text=[[ktemp objectForKey:@"planType"]description];
    cell.planAmount.text=[[ktemp objectForKey:@"planAmount"]description];
    cell.discount.text=[[ktemp objectForKey:@"discount"]description];
    cell.offer.text=[[ktemp objectForKey:@"offer"]description];
    cell.planId.text=[[ktemp objectForKey:@"id"]description];
    

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PlanCollectionViewCell *cell=[_myCollectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary *ktemp=[_planArr objectAtIndex:indexPath.row];
    
    cell.planId.text=[[ktemp objectForKey:@"id"]description];
    
    _planIdStr=cell.planId.text;
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
     NSLog(@"indexpath==%ld",(long)indexPath.row);
    NSLog(@"in did select plan id=%@",cell.planId.text);
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.planId.text forKey:@"planId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self purchaseDevicePlans];
    
    [self performSegueWithIdentifier:@"showPurchase" sender:self];
    
}

-(void)purchaseDevicePlans{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSString *orderId = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"orderId"];
    NSLog(@"***orderId ==%@",orderId);
    
    NSString *deviceNumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***deviceNumber ==%@",deviceNumber);
    
    NSString *planId = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"planId"];
    NSLog(@"***planId ==%@",planId);
    
    NSDictionary *data = @{
                           @"planId":planId,
                           @"userName":username,
                           @"orderId":orderId,
                           @"deviceNumber":deviceNumber
                           };
    NSLog(@"dATA*****==%@",data);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:purchaseDevicePlans]]];
    
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
    self.redirectUrl=[maindic objectForKey:@"redirectUrl"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.redirectUrl forKey:@"redirectUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"status==%@& message=%@ redirectUrl==%@",self.status,self.message,self.redirectUrl);
    
    if ([self.status isEqual:@"1"]) {
        NSLog(@"Device Plan Subscription PendinG....");
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
         NSLog(@"sOMETHING went wrong....");
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WebViewController *wvc=[segue destinationViewController];
    if ([segue.identifier isEqualToString:@"showPurchase"]) {
        
        NSString *redirectUrl = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"redirectUrl"];
        NSLog(@"***redirectUrl ==%@",redirectUrl);
        
        wvc.myURL=redirectUrl;
        
        NSLog(@"*******redirectUrl*******=%@",redirectUrl);
        
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
