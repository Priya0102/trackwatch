//
//  HistoricalRouteVC.m
//  DeviceTracking
//
//  Created by Punit on 21/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "HistoricalRouteVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Base.h"
@interface HistoricalRouteVC ()
{
    NSTimer *timer;
    NSString *time1,*time2;
}

@property (weak, nonatomic) IBOutlet UIView *mapbackView;
@property(strong,nonatomic) GMSMapView *mapView;
@end

@implementation HistoricalRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationArr=[[NSMutableArray alloc]init];
    self.dateView.layer.masksToBounds=YES;
    self.dateView.layer.cornerRadius=16;
    [dateTxtField setDelegate:self];
    [dateTxtField setDateField:YES];
    [timer1TxtField setDateTimeField:YES];
    [timer2TxtField setDateTimeField:YES];
    
    [timer1TxtField setDelegate:self];
    [timer2TxtField setDelegate:self];
    timer1TxtField.layer.masksToBounds=YES;
    timer1TxtField.layer.borderColor=[[UIColor grayColor]CGColor];

    timer1TxtField.layer.borderWidth=1.0f;
    
    timer2TxtField.layer.masksToBounds=YES;
    timer2TxtField.layer.borderColor=[[UIColor grayColor]CGColor];
    timer2TxtField.layer.borderWidth=1.0f;
    
    time1=timer1TxtField.text;
    time2=timer2TxtField.text;

   
  
    
    GMSCameraPosition *camera=[GMSCameraPosition cameraWithLatitude:21.1450677 longitude:79.0889168 zoom:14];

    self.mapView=[GMSMapView mapWithFrame:self.view.bounds camera:camera];

    self.mapView.mapType=kGMSTypeNormal;
    //self.mapView.myLocationEnabled=YES;//to find current location
    self.mapView.settings.compassButton=YES;
    self.mapView.settings.myLocationButton=YES;
    [self.mapView setMinZoom:10 maxZoom:18];
    
    [self.mapbackView addSubview:self.mapView];
    
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
                       //marker.icon=[UIImage imageNamed:@"map_car_running.png"];
                       
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
-(void)ShowPicker {
    
    CGFloat Height = self.view.frame.size.height;
    CGFloat Width = self.view.frame.size.width;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, Width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(PressDone)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [numberToolbar sizeToFit];
    // txtFiled.inputView = numberToolbar;
    
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, Height-200, Width, 200)];
    picker.backgroundColor = [UIColor greenColor];
    
    [picker addSubview:numberToolbar];
    [self.view addSubview:picker];
}

-(void)PressDone {
    
    NSLog(@"SELECTED DATE IS===");
    
}
-(void)historicalDataParsing{
    

    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***devicenumber ==%@",devicenumber);
    
    NSString *username = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"username"];
    NSLog(@"***username ==%@",username);
    
    
    NSDictionary *data = @{ @"userName":username,
                            @"deviceNumber":devicenumber,
                            @"fromDate":timer1TxtField.text,
                            @"toDate":timer2TxtField.text
                            };
    NSLog(@"data====%@",data);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[location stringByAppendingString:locationHistory]]];
    
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
    
    NSArray *detailArr=[maindic objectForKey:@"listOfLocation"];
    
    if(detailArr.count==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Sorry!" message:@"Currently there is no list of location." preferredStyle:UIAlertControllerStyleAlert];
        
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
        NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
        for(temp in detailArr)
        {
            NSString *str1=[[temp objectForKey:@"id"]description];
            NSString *str2=[[temp objectForKey:@"deviceNumber"]description];
            NSString *str3=[[temp objectForKey:@"longitude"]description];
            NSString *str4=[[temp objectForKey:@"lattitude"]description];
            NSString *str5=[[temp objectForKey:@"addressId"]description];
            NSString *str6=[[temp objectForKey:@"userName"]description];
            NSString *str7=[[temp objectForKey:@"createdDate"]description];
            
            [self->_locationArr addObject:temp];
            NSLog(@"gallery ListArr ARRAYY%@",self->_locationArr);
        }
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
        CLLocationCoordinate2D location;
        for (temp in _locationArr)
        {
            location.latitude = [temp[@"lattitude"] floatValue];
            location.longitude = [temp[@"longitude"] floatValue];
            // Creates a marker in the center of the map.
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.icon=[GMSMarker markerImageWithColor:[UIColor redColor]];
           // marker.icon = [UIImage imageNamed:(@"marker.png")];
            marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
            bounds = [bounds includingCoordinate:marker.position];
            marker.title = temp[@"type"];
            marker.map = _mapView;
        }
        [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    
    });
}

- (IBAction)historicalBtnClicked:(id)sender {
    
    if(timer1TxtField.text.length==0 && timer2TxtField.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Enter starttime and endtime" preferredStyle:UIAlertControllerStyleAlert];
        
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
    if(timer1TxtField.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First enter startime" preferredStyle:UIAlertControllerStyleAlert];
        
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
    if(timer2TxtField.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First enter endtime" preferredStyle:UIAlertControllerStyleAlert];
        
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
    
    if(timer1TxtField.text.length>0 && timer2TxtField.text.length>0)
    {
        NSLog(@"*****historical api called");
        
        [self historicalDataParsing];
    }

}

@end
