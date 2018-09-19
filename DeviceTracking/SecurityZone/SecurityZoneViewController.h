//
//  SecurityZoneViewController.h
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GooglePlaces/GooglePlaces.h>
@interface SecurityZoneViewController : UIViewController<CLLocationManagerDelegate,GMSAutocompleteViewControllerDelegate,UISearchControllerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *addZoneView;
@property (weak, nonatomic) IBOutlet UIButton *addZoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *safeZoneBtn;

@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *distanceSliderLbl;
@property (weak, nonatomic) IBOutlet UIButton *addZoneSaveBtn;
@property (weak, nonatomic) IBOutlet UITextField *placeNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *placeTxt;

- (IBAction)addZoneBtnClicked:(id)sender;
- (IBAction)dismissBtnClicked:(id)sender;
- (IBAction)addZoneSaveBtnClicked:(id)sender;

@property (nonatomic,strong) NSString *message,*status,*devicezones;
@property (weak, nonatomic) IBOutlet UIView *distanceView;
@end
