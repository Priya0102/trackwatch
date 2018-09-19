//
//  OrderStatusVC.h
//  DeviceTracking
//
//  Created by Punit on 22/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *orderStatusArr;

@property(nonatomic,retain)NSString *indxp,*planType,*planAmt,*discount,*offer,*message,*status,*orderIdStr;
@end
