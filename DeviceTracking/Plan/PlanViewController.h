//
//  PlanViewController.h
//  DeviceTracking
//
//  Created by Punit on 20/08/18.
//  Copyright © 2018 Eshiksa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *planArr;
@property(nonatomic,retain)NSString *indxp,*planType,*planAmt,*discount,*offer,*message,*status,*planIdStr,*redirectUrl;


@end
