//
//  SecurityZoneViewController.m
//  DeviceTracking
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.

#import "SecurityZoneViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Base.h"
#import <CoreLocation/CoreLocation.h>
@interface SecurityZoneViewController ()
{
    NSTimer *timer;
    NSString *latitudeStr,*longitudeStr;
}


@property(strong,nonatomic) GMSMapView *mapView;
@end

@implementation SecurityZoneViewController
@synthesize mapView;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    //self.definesPresentationContext = YES;
    
    _addZoneView.hidden=YES;

    //GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:[latittudestr doubleValue] longitude:[longitudestr doubleValue] zoom:14];
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:21.1450677 longitude:79.0889168 zoom:14];
  
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
                       //marker.position=CLLocationCoordinate2DMake([latittudestr doubleValue],[longitudestr doubleValue]);
                       marker.position=CLLocationCoordinate2DMake(21.1450677,79.0889168);
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
    
    
    if (timer==nil) {
        timer=[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
            
        }];
 }
}
-(void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
        [locationManager stopUpdatingLocation];
}

-(BOOL)prefersStatusBarHidden{
        return  YES;
    }
- (IBAction)addZoneBtnClicked:(id)sender {
     _addZoneView.hidden=NO;
}

- (IBAction)dismissBtnClicked:(id)sender {
      _addZoneView.hidden=YES;
}

- (IBAction)addZoneSaveBtnClicked:(id)sender {
   
    [self saveAddZone];
     _addZoneView.hidden=YES;
}

-(void)saveAddZone{
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSString *latitude = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"latitude"];
    NSLog(@"***latitude ==%@",latitude);
    
    NSString *longitude = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"longitude"];
    NSLog(@"***longitude ==%@",longitude);
    
    NSString *userid = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userId"];
    NSLog(@"***userid ==%@",userid);
    
    NSDictionary *data = @{
                            @"userId":userid,
                            @"deviceNumber":devicenumber,
                            @"latitude":latitude,
                            @"longitude":longitude,
                            @"distance":self.distanceSliderLbl.text,
                            @"username":username,
                            @"placeName":self.placeTxt.text,
                            @"alternatePlaceName":self.placeNameTxtFld.text
                            };
    NSLog(@"Data====%@",data);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[safeUrl stringByAppendingString:addSafeZone]]];
    
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
    //self.devicezones=[maindic objectForKey:@"devicezones"];
    
    if ([self.status isEqual:@"1"]) {
         NSLog(@"Zone Added Successfully");
       /* UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Safe Zone Added Successfully!!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];*/
    }
    else{
        NSLog(@"Something went wrong");
        /*UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Oops!" message:@"Something went wrong!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [self presentViewController:alertView animated:YES completion:nil];*/
    }

}

- (IBAction)onLaunchClicked:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    _placeTxt.text=place.name;
    
     NSLog(@"Place name %@", _placeTxt.text);
    
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:_placeTxt.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return; // Request failed, log error
        }
        if (placemarks && [placemarks count] > 0) {
            CLPlacemark *placemark = placemarks[0]; // Our placemark
            
            // Do something with the generated placemark
            NSLog(@"****Lat: %f, ****Long: %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            self->latitudeStr = [NSString stringWithFormat:
                                       @"%.8f",placemark.location.coordinate.latitude]; //.8 means 8 digits behind the decimal point
            self->longitudeStr = [NSString stringWithFormat:
                                        @"%.8f",placemark.location.coordinate.longitude];
        
            
            [[NSUserDefaults standardUserDefaults] setObject:self->latitudeStr forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:self->longitudeStr forKey:@"longitude"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
//    NSString *city =_placeTxt.text;
//    CLGeocoder *geocoder = [CLGeocoder new];
//    [geocoder geocodeAddressString:city completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", [error localizedDescription]);
//            return; // Bail!
//        }
//
//        if ([placemarks count] > 0) {
//            CLPlacemark *placemark = [placemarks lastObject]; // firstObject is iOS7 only.
//            NSLog(@"Location lat and long is: %@", placemark.location);
//
//        }
//    }];
    
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (IBAction)sliderValueChanged:(id)sender {
    self.distanceSliderLbl.text = [NSString stringWithFormat:@"%0.2f", self.distanceSlider.value];
}


@end
