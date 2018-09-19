//
//  SignInViewController.m
//  DeviceTracking
//
//  Created by Punit on 09/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "SignInViewController.h"
#import "Base.h"
#import "HomeViewController.h"
@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameView.clipsToBounds = YES;
    _usernameView.layer.cornerRadius = 22;
    
    _passwordView.clipsToBounds = YES;
    _passwordView.layer.cornerRadius = 22;
    
    _signInBtn.clipsToBounds = YES;
    _signInBtn.layer.cornerRadius = 20;
    
    [_textFieldUsername becomeFirstResponder];
    
    _textFieldUsername.delegate=self;
    _textFieldPassword.delegate=self;
   
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:160.0/255.0 green:175.0/255.0 blue:170.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textFieldUsername resignFirstResponder];
    return true;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFieldUsername resignFirstResponder];
    [_textFieldPassword resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:(BOOL)animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (IBAction)loginclicked:(id)sender {
    
    
    UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame=CGRectMake(self.view.window.center.x,self.view.window.center.y, 40.0, 40.0);
    indicator.center=self.view.center;
    [self.view addSubview:indicator];
    
    
    indicator.tintColor=[UIColor redColor];
    indicator.backgroundColor=[UIColor lightGrayColor];
    [indicator bringSubviewToFront:self.view];
   
    [indicator startAnimating];
    if(self.textFieldUsername.text.length==0 && self.textFieldPassword.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Enter username and password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
    if(self.textFieldUsername.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First enter your username" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];

        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    if(self.textFieldPassword.text.length==0)
    {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"First enter your password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alertView dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alertView addAction:ok];
        [indicator stopAnimating];
        
        [self presentViewController:alertView animated:YES completion:nil];
    }
    
    if(self.textFieldUsername.text.length>0 && self.textFieldPassword.text.length>0)
    {
        NSLog(@"login api called");
        
        [self loginParsing];
    }
}

-(void)loginParsing{
    
    NSDictionary *data = @{ @"username":self.textFieldUsername.text ,
                            @"password": self.textFieldPassword.text
                          };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:login]]];
    NSLog(@"LOGIN URLLLLLL====%@",url);
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"message"];
    self.username=[maindic objectForKey:@"username"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"status==%@& message=%@ username==%@",self.status,self.message,self.username);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
    }];
    if ([self.status isEqual:@"0"]) {
        
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"Entered credential is incorrect" preferredStyle:UIAlertControllerStyleAlert];
        
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
        [self navigatingFromLogin];
        NSLog(@"login successful.....");
    }
}
-(void)navigatingFromLogin{
    
    HomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"toHome"];
    
    [self.navigationController pushViewController:home animated:YES];
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
