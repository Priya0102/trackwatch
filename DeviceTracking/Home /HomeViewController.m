//
//  HomeViewController.m
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//fHC7pJx87ds:APA91bFwOOSMEBHnkQhqfTjHs1MBy33uCl8PjaieYixg6e31y3Dbh4y_xQRRc-81YJSlpatSgMBwr6tHgV39tc9mRlAaHxJpgvFLi9ndN239mNVFRkq3aiQXjbMlMTpbuC1zSD70s0cL   //fcm token
// 9556574efd974a713420861e3167b5b7ab7b0d97d229af23f46db25256e45d7c //device token

#import "HomeViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Base.h"
#import "DeviceListCollectionViewCell.h"
#import <MapKit/MapKit.h>
@interface HomeViewController ()
{
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIView *mapbackView;
@property(strong,nonatomic) GMSMapView *mapView;
@end

@implementation HomeViewController
@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
 // [self firebaseRegistration];// uncomment when running in simulator

    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [self.devicebtn addSubview:self.mapView];
    
    _deviceListArr=[[NSMutableArray alloc]init];
    _hiddenDeviceListView.hidden=YES;
    
    self.devicebtn.layer.cornerRadius = self.devicebtn.frame.size.width / 2;
    self.devicebtn.clipsToBounds = YES;
    
   CLLocation *location = [locationManager location];
    
    
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
//    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
//
// GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:14];
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:21.1450677 longitude:79.0889168 zoom:14];
    
    
    self.mapView=[GMSMapView mapWithFrame:self.view.bounds camera:camera];
    
    self.mapView.mapType=kGMSTypeNormal;
   // self.mapView.myLocationEnabled=YES;//to find current location
    self.mapView.settings.compassButton=YES;
    self.mapView.settings.myLocationButton=YES;
    [self.mapView setMinZoom:10 maxZoom:18];
    
   [self.mapbackView addSubview:self.mapView];
    
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       GMSMarker *marker=[[GMSMarker alloc]init];
                    
                       //marker.position=CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
                      marker.position=CLLocationCoordinate2DMake(21.1450677,79.0889168);
                       
                       marker.map=self.mapView;
                       marker.title=@"Current Location";
                        //marker.snippet=stopname;
                       marker.appearAnimation=kGMSMarkerAnimationPop;
                       marker.icon=[GMSMarker markerImageWithColor:[UIColor redColor]];
                       //marker.icon=[UIImage imageNamed:@"map_car_running.png"];
                       
                   });
  

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate =self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
  

    if (timer==nil) {
        timer=[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
            
        }];
        
    }
    
    
}

/*- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (currentLocation != nil){
        NSLog(@"The latitude value is - %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
        NSLog(@"The logitude value is - %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
    }
    //Current
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude: currentLocation.coordinate.longitude zoom:13];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.mapType=kGMSTypeNormal;
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.compassButton=YES;
    self.mapView.settings.myLocationButton=YES;
    self.mapView.delegate=self;
    self.mapView.frame = _mapbackView.bounds;
    [self.mapView setMinZoom:10 maxZoom:18];
    [self.mapbackView addSubview:self.mapView];
    
    //    dispatch_async(dispatch_get_main_queue(),
    //                   ^{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    marker.title = @"Your Office Name";
    marker.snippet = @"Current Location";
    marker.appearAnimation=kGMSMarkerAnimationPop;
    marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
    
    marker.map = self.mapView;
    //   });
}*/
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    
    [super viewDidAppear:(BOOL)animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)firebaseRegistration{
    

NSString *username = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"username"];
NSLog(@"***username ==%@",username);

NSString *deviceToken = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"fcmToken"];
NSLog(@"***deviceToken ==%@",deviceToken);
    

    
NSDictionary *data = @{ @"username":username,
                        @"tokenNumber":deviceToken,
                        };
NSLog(@"***data ==%@",data);
NSError *error;
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];

NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[fireBase stringByAppendingString:fireBaseRegistration]]];

NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
[req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
[req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
[req setHTTPMethod:@"POST"];
[req setHTTPBody:jsonData];

NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];

NSLog(@"Return registration String%@",retStr);

NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
NSLog(@"response data:%@",maindic);

self.status=[maindic objectForKey:@"status"];
self.message=[maindic objectForKey:@"message"];
    if ([self.status isEqual:@"1"]) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Token updated Successfully" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else{
        
      /*  UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Something went wrong!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok2 = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [alertView dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
        
        [alertView addAction:ok2];
        [self presentViewController:alertView animated:YES completion:nil];*/
    }
}


- (IBAction)deviceBtnClicked:(id)sender {
     _hiddenDeviceListView.hidden=NO;
      [self deviceListParsing];
    

}
-(void)deviceListParsing{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSDictionary *data = @{ @"username":username
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:getDeviceListByuserName]]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return resistration String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    
    NSArray *detailArr=[maindic objectForKey:@"deviceList"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no device list." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        
        [alertView addAction:ok];
        
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
    else {
        
        for(NSDictionary *temp in detailArr)
        {
            NSString *str1=[[temp objectForKey:@"id"]description];
            NSString *str2=[[temp objectForKey:@"deviceNumber"]description];
            NSString *str3=[[temp objectForKey:@"nickName"]description];
            NSString *str4=[[temp objectForKey:@"mobileNumber"]description];
            NSString *str5=[[temp objectForKey:@"username"]description];
            
            [_deviceListArr addObject:temp];
            NSLog(@"gallery ListArr ARRAYY%@",_deviceListArr);
        }
    }
    [_collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_collectionView reloadData];
    });
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _deviceListArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceListCollectionViewCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableDictionary *ktemp=[_deviceListArr objectAtIndex:indexPath.row];
    cell.deviceNumber.text=[[ktemp objectForKey:@"deviceNumber"]description];
    cell.nickname.text=[[ktemp objectForKey:@"nickName"]description];
    cell.deviceId.text=[[ktemp objectForKey:@"id"]description];
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DeviceListCollectionViewCell *cell=[_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary *ktemp=[_deviceListArr objectAtIndex:indexPath.row];

    
    cell.deviceNumber.text=[[ktemp objectForKey:@"deviceNumber"]description];
     cell.nickname.text=[[ktemp objectForKey:@"nickName"]description];
     cell.deviceId.text=[[ktemp objectForKey:@"id"]description];
   
    
    _indxp=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSLog(@"Selected Device Number====%@", cell.deviceNumber.text);
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.nickname.text forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:cell.deviceNumber.text forKey:@"deviceNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    [self currentLocation];
    _hiddenDeviceListView.hidden=YES;
    
}
-(void)currentLocation{
    
    NSString *nickname = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"nickname"];
    NSLog(@"***nickname ==%@",nickname);
    
    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"deviceNum"];
    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSDictionary *data = @{ @"nickname":nickname,
                            @"deviceNumber":devicenumber
                            };
    NSLog(@"***data ==%@",data);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[location stringByAppendingString:currentLocation]]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return resistration String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    self.longitude=[maindic objectForKey:@"longitude"];
    self.lattitude=[maindic objectForKey:@"lattitude"];
    self.address=[maindic objectForKey:@"address"];
    
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:[self.lattitude doubleValue] longitude:[self.longitude doubleValue] zoom:14];
    
    
    // GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:21.1450677 longitude:79.0889168 zoom:14];
    
    self.mapView=[GMSMapView mapWithFrame:self.view.bounds camera:camera];
    
    self.mapView.mapType=kGMSTypeNormal;
    //self.mapView.myLocationEnabled=YES;//to find current location
    self.mapView.settings.compassButton=YES;
    self.mapView.settings.myLocationButton=YES;
    [self.mapView setMinZoom:10 maxZoom:18];
    
    [self.backgroundView addSubview:self.mapView];
    
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       GMSMarker *marker=[[GMSMarker alloc]init];
                       marker.position=CLLocationCoordinate2DMake([self.lattitude doubleValue],[self.longitude doubleValue]);
                       //marker.position=CLLocationCoordinate2DMake(21.1450677,79.0889168);
                       marker.map=self.mapView;
                       //marker.title=@"Nagpur";
                       // marker.snippet=stopname;
                       marker.appearAnimation=kGMSMarkerAnimationPop;
                       marker.icon=[GMSMarker markerImageWithColor:[UIColor redColor]];
                   });
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate =self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [locationManager requestWhenInUseAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}
- (IBAction)dismissBtnClicked:(id)sender {
    
        _hiddenDeviceListView.hidden=YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
