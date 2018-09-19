//
//  GetDeviceListController.h
//  DeviceTracking
//
//  Created by Punit on 29/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.

#import <UIKit/UIKit.h>

@interface GetDeviceListController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *mobileNum;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumber;
@property(nonatomic,retain)NSString *status,*message,*device;

@end
