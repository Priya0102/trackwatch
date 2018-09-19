//
//  HistoricalRouteVC.h
//  DeviceTracking
//
//  Created by Punit on 21/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RzTextField.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HistoricalRouteVC : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate>
{
      CLLocationManager *locationManager;
      IBOutlet RzTextField *dateTxtField;
      IBOutlet RzTextField *timer1TxtField;
      IBOutlet RzTextField *timer2TxtField;
}
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property(nonatomic,retain)NSString *message,*status;
@property (nonatomic,strong) NSMutableArray *locationArr;

@end
