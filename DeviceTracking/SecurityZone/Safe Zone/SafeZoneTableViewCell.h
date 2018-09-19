//
//  SafeZoneTableViewCell.h
//  DeviceTracking
//
//  Created by Punit on 25/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeZoneTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *alternatePlaceName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *safeZoneId;


@property (weak,nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak,nonatomic) IBOutlet UIButton *updateBtn;
- (IBAction)deleteBtnClicked:(id)sender;
- (IBAction)updateBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *deleteUpdateView;

@end
