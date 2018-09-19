//
//  SettingsViewController.h
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property(nonatomic,retain)NSString *message,*status,*isEnabled;
@end
