//
//  HomeViewController.h
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController : UIViewController<CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GMSMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property(nonatomic,retain)NSString *message,*status,*address,*longitude,*lattitude,*indxp;
@property (weak, nonatomic) IBOutlet UIButton *devicebtn;
@property (weak, nonatomic) IBOutlet UIView *deviceListView;
@property (weak, nonatomic) IBOutlet UIView *hiddenDeviceListView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *deviceListArr;

@end
