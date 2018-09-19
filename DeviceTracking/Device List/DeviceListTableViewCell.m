//
//  DeviceListTableViewCell.m
//  DeviceTracking
//
//  Created by Punit on 23/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "DeviceListTableViewCell.h"

@implementation DeviceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _switchBtn.clipsToBounds = YES;
    _switchBtn.layer.cornerRadius =5;
    
    self.watchImg.layer.cornerRadius = self.watchImg.frame.size.width / 2;
    self.watchImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
