//
//  OrderStatusVC.m
//  DeviceTracking
//
//  Created by Punit on 22/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "OrderStatusVC.h"
#import "Base.h"
#import "OrderStatusTableViewCell.h"
@interface OrderStatusVC ()

@end

@implementation OrderStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _orderStatusArr=[[NSMutableArray alloc]init];
    
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [_tableview setSeparatorColor:[UIColor clearColor]];
    
    [self parsingOrderStatusData];
}

-(void)parsingOrderStatusData{
   
    NSString *username = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    NSDictionary *data = @{ @"username":username
                         };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:checkOrderStatus]]];
    
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
    
    NSArray *detailArr=[maindic objectForKey:@"listOfOrders"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no order status." preferredStyle:UIAlertControllerStyleAlert];
        
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
            NSString *str1=[[temp objectForKey:@"username"]description];
            NSString *str2=[[temp objectForKey:@"orderId"]description];
            NSString *str3=[[temp objectForKey:@"createdDate"]description];
            NSString *str4=[[temp objectForKey:@"txnAmount"]description];
            NSString *str5=[[temp objectForKey:@"numberOfDevices"]description];
            NSString *str6=[[temp objectForKey:@"orderStatus"]description];
            
            
            [self->_orderStatusArr addObject:temp];
            NSLog(@"gallery ListArr ARRAYY%@",self->_orderStatusArr);
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
    return _orderStatusArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderStatusTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
        NSMutableDictionary *ktemp=[_orderStatusArr objectAtIndex:indexPath.row];
        
        cell.createdDate.text=[[ktemp objectForKey:@"createdDate"]description];
        cell.numberOfDevices.text=[[ktemp objectForKey:@"numberOfDevices"]description];
        cell.amount.text=[[ktemp objectForKey:@"txnAmount"]description];
        cell.orderStatus.text=[[ktemp objectForKey:@"orderStatus"]description];
       cell.orderId.text=[[ktemp objectForKey:@"orderId"]description];
    

    
        return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderStatusTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary *ktemp=[_orderStatusArr objectAtIndex:indexPath.row];
    
    cell.orderId.text=[[ktemp objectForKey:@"orderId"]description];
    
    _orderIdStr=cell.orderId.text;
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSLog(@"in did select order id=%@",cell.orderId.text);
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.orderId.text forKey:@"orderId"];
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

@end
