//
//  SOSTableViewCell.h
//  DeviceTracking
//
//  Created by Punit on 04/09/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sosNumber;
@property (weak, nonatomic) IBOutlet UILabel *priorityNum;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIButton *sosCallBtn;
@property (weak, nonatomic) IBOutlet UIView *updateView;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UITextField *updateTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *updateSaveBtn;
- (IBAction)dismissBtnClciked:(id)sender;
- (IBAction)updateSaveBtnClicked:(id)sender;
- (IBAction)updateBtnClicked:(id)sender;
@property(nonatomic,retain)NSString *status,*message,*deviceNum,*fromNum,*toNum,*priority;
@property (weak, nonatomic) IBOutlet UIImageView *watchImg;


@end
