//
//  DeviceListCollectionViewCell.h
//  DeviceTracking
//
//  Created by Punit on 14/09/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumber;
@property (weak, nonatomic) IBOutlet UIImageView *watchImg;
@property (weak, nonatomic) IBOutlet UILabel *deviceId;
@end
