//
//  PlanCollectionViewCell.h
//  DeviceTracking
//
//  Created by Punit on 20/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *planType;
@property (weak, nonatomic) IBOutlet UILabel *planAmount;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *offer;
@property (weak, nonatomic) IBOutlet UILabel *planId;


@end
