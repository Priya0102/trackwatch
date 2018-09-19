//
//  SOSTableViewCell.m
//  DeviceTracking
//
//  Created by Punit on 04/09/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "SOSTableViewCell.h"
#import "Base.h"
#import "SOS.h"
@implementation SOSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _updateView.hidden=YES;
    
    self.watchImg.layer.cornerRadius = self.watchImg.frame.size.width / 2;
    self.watchImg.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)showAnimate
{
    self.contentView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.contentView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.contentView];
    if (animated) {
        [self showAnimate];
    }
}
- (void)removeAnimate
{
    _updateView.hidden=YES;
}
- (IBAction)dismissBtnClciked:(id)sender {
     [self removeAnimate];
}

- (IBAction)updateSaveBtnClicked:(id)sender {

}

- (IBAction)updateBtnClicked:(id)sender {
    _updateView.hidden=NO;
}


@end
