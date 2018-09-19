//
//  NicknameViewController.h
//  DeviceTracking
//
//  Created by Punit on 23/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NicknameViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *deviceListArr;
@property(nonatomic,retain)NSString *status,*message,*deviceNumStr,*nickNameStr,*indxp;
@property (strong, nonatomic) IBOutlet UIView *mainUpdateView;
@property (weak, nonatomic) IBOutlet UITextField *updateTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *saveUpdateBtn;

@end
