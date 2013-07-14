//
//  QiuShiBaiKeViewController.h
//  QiuShiBaiKe
//
//  Created by panda zheng on 13-7-14.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "ASIHTTPRequest.h"

@interface QiuShiBaiKeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,ASIHTTPRequestDelegate>
{
    //未登陆显示
    UIImageView *headlogoView;      //糗事百科的logo
    
    //随机，8小时最糗，7天内最糗，一个月最糗，真相
    QiuShiTime MainQiuTime;
    
    NSMutableArray *list;
    PullingRefreshTableView *tableView;
    BOOL refreshing;
    NSInteger page;
    //随机,8小时最糗，7天内最糗，一个月最糗，真相
    QiuShiTime QiuTime;
    //http 请求
    ASIHTTPRequest *asiRequest;
}

@property (nonatomic,assign) QiuShiTime MainQiuTime;
@property (nonatomic,retain) UIImageView *headlogoView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic) BOOL refreshing;
@property (nonatomic,retain) PullingRefreshTableView *tableView;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,assign) QiuShiTime QiuTime;
@property (nonatomic,retain) ASIHTTPRequest *asiRequest;

-(void) LoadPageOfQiushiType: (QiuShiTime) time;
-(CGFloat) getTheHeight: (NSInteger) row;

@end
