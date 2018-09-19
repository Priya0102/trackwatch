//
//  NicknameTableViewCell.m
//  DeviceTracking
//
//  Created by Punit on 23/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import "NicknameTableViewCell.h"
#import "Base.h"
@implementation NicknameTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
      _addNickNameView.hidden=YES;
    
    self.watchImg.layer.cornerRadius = self.watchImg.frame.size.width / 2;
    self.watchImg.clipsToBounds = YES;
    
    _saveBtn.clipsToBounds = YES;
    _saveBtn.layer.cornerRadius =10;
    
//    NSString *nickname = [[NSUserDefaults standardUserDefaults]
//                          stringForKey:@"nickname"];
//    NSLog(@"***nickname ==%@",nickname);
//
//    self.nickNameTxtFld.text=nickname;
//
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showAnimate
{
    self.contentView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.contentView.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.alpha = 1;
        self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    _addNickNameView.hidden=YES;
}
- (IBAction)dismissBtnClicked:(id)sender {
     [self removeAnimate];
}
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.contentView];
    if (animated) {
        [self showAnimate];
    }
}
- (IBAction)saveBtnClicked:(id)sender {
    [self nicknameDataParsing];
}

- (IBAction)nicknameEditBtnClicked:(id)sender {
    _addNickNameView.hidden=NO;
}
-(void)nicknameDataParsing{

    NSString *nickname = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"nickname"];
    NSLog(@"***cell in nickname ==%@",nickname);
    
    NSString *devicenumber = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"devicenumber"];
    NSLog(@"***cell in devicenumber ==%@",devicenumber);
    
    NSDictionary *data = @{ @"nickName":self.nickNameTxtFld.text,
                            @"deviceNumber":devicenumber
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[mainUrl stringByAppendingString:updateNickName]]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:nil timeoutInterval:60];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    
    NSString *retStr = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSLog(@"update nickname String%@",retStr);
    
    NSDictionary *maindic=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil] options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"response data:%@",maindic);
    
    self.status=[maindic objectForKey:@"status"];
    self.message=[maindic objectForKey:@"messages"];
    if ([self.status isEqual:@"1"]) {
        NSLog(@"Nickname updated Successfully");
    }
    else{
         NSLog(@"Something went wrong!");
    }
    
    
}

@end
