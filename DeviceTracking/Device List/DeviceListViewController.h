//
//  DeviceListViewController.h
//  DeviceTracking
//
//  Created by Punit on 20/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DeviceListViewController : UIViewController <UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (weak, nonatomic) IBOutlet UIView *addDeviceView;
@property (weak, nonatomic) IBOutlet UIButton *addDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyNicknameBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,weak ) IBOutlet UITextView *watchId;


- (IBAction)modifyNicknameBtnClicked:(id)sender;
- (IBAction)addDeviceBtnClicked:(id)sender;
- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)dismissBtnClicked:(id)sender;
- (IBAction)barcodeBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *mobileNum;

@property(nonatomic,retain)NSString *status,*message,*stage,*indxp,*deviceNumber,*nickname,*deviceId;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *deviceListArr;

@end
