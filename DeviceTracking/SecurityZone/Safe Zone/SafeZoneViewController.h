//
//  SafeZoneViewController.h
//  DeviceTracking
//
//  Created by Punit on 25/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafeZoneViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSMutableArray *safeZoneArr;

@property(nonatomic,retain)NSString *indxp,*message,*status,*safeZoneIdStr,*placeNameStr,*userIdStr;
@property (weak, nonatomic) IBOutlet UIView *upDateView;
@property (weak, nonatomic) IBOutlet UITextField *alternatePlace;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceSliderLabel;

@property (strong, nonatomic) IBOutlet UIView *mainUpdateView;
@property (weak, nonatomic) IBOutlet UIButton *saveUpdateBtn;


@end
