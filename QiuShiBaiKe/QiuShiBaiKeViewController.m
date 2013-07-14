//
//  QiuShiBaiKeViewController.m
//  QiuShiBaiKe
//
//  Created by panda zheng on 13-7-14.
//  Copyright (c) 2013年 panda zheng. All rights reserved.
//

#import "QiuShiBaiKeViewController.h"
#import "CommentsViewController.h"
#import "JSON.h"
#import "QiuShi.h"
#import "ContentCell.h"



@interface QiuShiBaiKeViewController ()

@end

@implementation QiuShiBaiKeViewController
@synthesize headlogoView;
@synthesize MainQiuTime;
@synthesize list;
@synthesize tableView;
@synthesize refreshing;
@synthesize page;
@synthesize QiuTime;
@synthesize asiRequest;

- (void)dealloc
{
    [list release];
    [tableView release];
    [asiRequest release];
    [super dealloc];
}
- (void)loadView
{
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
    [super loadView];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // self.title = @"粉丝列表";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //设置背景颜色
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
    //    //添加headbar
    UIImage *headimage = [UIImage imageNamed:@"head_background.png"];
    UIImageView *headView=[[UIImageView alloc] initWithImage:headimage];
    [headView setFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:headView];
    //  [headimage release];
    [headView release];
    //糗事百科logo
    UIImage *loginimage=[UIImage imageNamed:@"head_logo.png"];
    headlogoView =[[UIImageView alloc] initWithImage:loginimage];
    [headlogoView setFrame:CGRectMake(103, 5, 113, 32)];
    [self.view addSubview:headlogoView];
    [headlogoView release];
    list=[[NSMutableArray alloc]init];
    
    self.tableView=[[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, kDeviceWidth, KDeviceHeight-44*2) pullingDelegate:self];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
    self.QiuTime=MainQiuTime;
    if (self.page==0) {
        [self.tableView launchRefreshing];
    }
    
}


- (void)viewDidUnload
{
    
    self.list=nil;
    self.tableView =nil;
    self.asiRequest=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void) LoadPageOfQiushiType:(QiuShiTime) time
{
    
    self.QiuTime = time;
    self.page =0;
    [self.tableView launchRefreshing];
}

#pragma mark - Your actions
//SuggestURLString最新
- (void)loadData
{
    self.page++;
    NSURL *url;
    switch (QiuTime) {//随便逛逛、8小时最糗、7天内最糗、一个月最糗、真相
        case QiuShiTimeRandom:
            url = [NSURL URLWithString:LastestURLString(10,self.page)];
            break;
        case QiuShiTimeDay:
            url = [NSURL URLWithString:DayURLString(10,self.page)];
            break;
        case QiuShiTimeWeek:
            url = [NSURL URLWithString:WeakURlString(10,self.page)];
            break;
        case QiuShiTimeMonth:
            url = [NSURL URLWithString:MonthURLString(10,self.page)];
            break;
        case QiuShiTimePhoto:
            url = [NSURL URLWithString:ImageURLString(10,self.page)];
            break;
        default:
            break;
    }
    NSLog(@"接口url= %@",url);
    asiRequest = [ASIHTTPRequest requestWithURL:url];
    [asiRequest setDelegate:self];
    [asiRequest setDidFinishSelector:@selector(GetResult:)];
    [asiRequest setDidFailSelector:@selector(GetErr:)];
    [asiRequest startAsynchronous];
}
-(void) GetErr:(ASIHTTPRequest *)request
{
    self.refreshing = NO;
    [self.tableView tableViewDidFinishedLoading];
    NSLog(@"GetErr");
}
-(void) GetResult:(ASIHTTPRequest *)request
{
    if (self.refreshing) {
        self.page=1;
        self.refreshing=NO;
        [self.list removeAllObjects];
    }
    NSData *data=[request responseData];
    NSString *outString  = [[NSString alloc] initWithData:data encoding:  NSUTF8StringEncoding];
	//NSLog(@"接口返回数据  %@", outString);
    //返回的借口信息保存到字典中
    NSDictionary *backdict = [outString JSONValue];
    if ([backdict objectForKey:@"items"]) {
        NSArray *array=[NSArray arrayWithArray:[backdict objectForKey:@"items"]];
        for (NSDictionary *qiushi in array) {
            QiuShi *qs=[[[QiuShi alloc]initWithDictionary:qiushi] autorelease];
            [self.list addObject:qs];
        }
    }
    if (self.page >=20) {
        [self.tableView tableViewDidFinishedLoadingWithMessage:@"下面没有了.."];
        self.tableView.reachedTheEnd  = YES;
    } else {
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
    }
    
}
#pragma mark - TableView*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Contentidentifier = @"_ContentCELL";
    ContentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:Contentidentifier];
    if (cell==nil) {
        cell=[[ContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contentidentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
        [cell.txtContent setNumberOfLines:12];
    }
    QiuShi *qs=[self.list objectAtIndex:[indexPath row]];
    //设置内容
    cell.txtContent.text=qs.content;
    //设置图片
    if (qs.imageURL!=nil && qs.imageURL!=@"") {
        cell.imgUrl=qs.imageURL;
        cell.imgMidUrl=qs.imageMidURL;
    }else {
        cell.imgUrl = @"";
        cell.imgMidUrl = @"";
    }
    //设置用户名
    if (qs.anchor!=nil && qs.anchor!= @"")
    {
        cell.txtAnchor.text = qs.anchor;
    }else
    {
        cell.txtAnchor.text = @"匿名";
    }
    //设置标签
    if (qs.tag!=nil && qs.tag!= @"")
    {
        cell.txtTag.text = qs.tag;
    }else
    {
        cell.txtTag.text = @"";
    }
    //设置up ，down and commits
    [cell.goodbtn setTitle:[NSString stringWithFormat:@"%d",qs.upCount] forState:UIControlStateNormal];
    [cell.badbtn setTitle:[NSString stringWithFormat:@"%d",qs.downCount] forState:UIControlStateNormal];
    [cell.commentsbtn setTitle:[NSString stringWithFormat:@"%d",qs.commentsCount] forState:UIControlStateNormal];
    //自适应函数
    [cell resizeTheHeight];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsViewController *comment=[[CommentsViewController alloc]
                                     initWithNibName:@"CommentsViewController" bundle:nil];
    comment.qs=[self.list objectAtIndex:indexPath.row];
    comment.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:comment animated:YES];
    [comment release];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getTheHeight:indexPath.row];
}
-(CGFloat) getTheHeight:(NSInteger)row
{
    //    CGFloat contentWidth = 280;
    //    // 设置字体
    //    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    //    // 显示的内容
    //    NSString *content = qs.content;
    //    // 计算出长宽  3000是为了能更多的显示，220 文字内容会显示不全
    //    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 3000) lineBreakMode:UILineBreakModeTailTruncation];
    //    CGFloat height;
    //    if (qs.imageURL==nil) {
    //        height = size.height+214;
    //    }else
    //    {
    //        height = size.height+294;
    //    }
    
    // 列寬
    CGFloat contentWidth =280;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    
    QiuShi *qs =[self.list objectAtIndex:row];
    // 显示的内容
    NSString *content = qs.content;
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 3000) lineBreakMode:
                   UILineBreakModeTailTruncation];
    //    if (size.height>220) {
    //             size.height=size.height+100;
    //    }
    CGFloat height;
    if (qs.imageURL==nil) {
        height = size.height+150;
    }else
    {
        height = size.height+230;
    }
    // 返回需要的高度
    return height;
}

#pragma mark - Scroll
//会在视图滚动时收到通知。包括一个指向被滚动视图的指针，从中可以读取contentOffset属性以确定其滚动到的位置。
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}


//当用户抬起拖动的手指时得到通知。还会得到一个布尔值，知名报告滚动视图最后位置之前，是否需要减速。
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
