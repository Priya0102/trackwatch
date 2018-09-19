//
//  NicknameTableViewCell.h
//  DeviceTracking
//
//  Created by Punit on 23/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NicknameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *watchImg;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumber;
@property (weak, nonatomic) IBOutlet UIButton *nickNameBtn;
@property (weak, nonatomic) IBOutlet UIView *addNickNameView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTxtFld;
- (IBAction)dismissBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)nicknameEditBtnClicked:(id)sender;
@property(nonatomic,retain)NSString *status,*message;
@end
