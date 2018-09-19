//
//  SOSListViewController.h
//  DeviceTracking
//
//  Created by Punit on 05/09/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *priorityTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *priority2TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *priority3TxtFld;

@property (nonatomic,strong) NSMutableArray *sosArr,*mobilenumArr,*priorityArr,*sosArr1,*priorityArr1;
@property (weak, nonatomic) IBOutlet UILabel *priority1;
@property (weak, nonatomic) IBOutlet UILabel *priority2;
@property (weak, nonatomic) IBOutlet UILabel *priority3;

@property(nonatomic,retain)NSString *indxp,*sosNumStr,*priorityStr,*updateTxtStr;
@property(nonatomic,retain)NSString *status,*message,*deviceNum,*fromNum,*toNum,*priority;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (strong, nonatomic) IBOutlet UIView *mainUpdateView;
@property (weak, nonatomic) IBOutlet UITextField *updateTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *saveUpdateBtn;

@end
