//
//  MainViewController.m
//  下载断点续传
//
//  Created by xunli on 2018/3/20.
//  Copyright © 2018年 caoji. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"

#import <MediaPlayer/MediaPlayer.h>
#import "MCDownloader.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGTH [UIScreen mainScreen].bounds.size.height
@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,MainTableViewCellDelegate>
//MainTableView
@property(nonatomic,strong)UITableView* MainTableView;
//数据源
@property(nonatomic,strong)NSMutableArray* MainMutableArray;

@property (strong, nonatomic) NSMutableArray *urls;
@end

@implementation MainViewController
-(UITableView*)mainTableView{
    if (self.MainTableView==nil) {
        _MainTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGTH) style:UITableViewStylePlain];
        _MainTableView.delegate =self;
        _MainTableView.dataSource =self;
        [self.view addSubview:_MainTableView];
    }
    return _MainTableView;
}
-(NSMutableArray*)mainMutableArray{
    if (self.MainMutableArray==nil) {
        _MainMutableArray =[NSMutableArray arrayWithArray:@[@"minion_01",@"minion_02    ",@"minion_03",@"minion_04",@"minion_05",@"minion_06",@"minion_07",@"minion_08",@"minion_09",@"minion_10",]];
    }
    return _MainMutableArray;
}

- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        for (int i = 1; i<=10; i++) {
            [self.urls addObject:[NSString stringWithFormat:@"http://120.25.226.186:32812/resources/videos/minion_%02d.mp4", i]];
            
            //       [self.urls addObject:@"http://localhost/MJDownload-master.zip"];
        }
    }
    return _urls;
}

//添加导航栏右侧的2 个按钮
-(void)AddTwoButtonAboutUinavigationBar{
    UIButton* rightBun = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBun.frame = CGRectMake(0, 0, 25, 25);
    //[rightBun setBackgroundImage:[UIImage imageNamed:@"设备-菜单"] forState:normal];
    [rightBun setTitle:@"全部开始" forState:UIControlStateNormal];
    [rightBun setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [rightBun addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem =[[UIBarButtonItem alloc] initWithCustomView:rightBun];;
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"下载及断点续传";
    [[MCDownloader sharedDownloader] removeAndClearAll];
    [self AddTwoButtonAboutUinavigationBar];
    //创建MainTableView
    [self mainTableView];
    
    //创建数据源
    [self urls];
   
}
#pragma mark====main tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _urls.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer=@"MainTableViewCell";
    
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        
    }
    cell.url = [self urls][indexPath.row];
    cell.delegate = self;
   // cell.nameLabel.text =[NSString stringWithFormat:@"%@",_MainMutableArray[indexPath.row]];
    cell.Imageview.image =[UIImage imageNamed:@"小黄人"];
    //cell.speedLable.text =[NSString stringWithFormat:@"%@",@"1002kb/s"];
    //cell.bytesLable.text =[NSString stringWithFormat:@"%@",@"12.4M/50M"];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:[self urls][indexPath.row]];
        [[MCDownloader sharedDownloader] remove:receipt completed:^{
            [self.MainTableView reloadData];
        }];
        
    }
}

- (void)nextAction:(UIButton *)sender {
    
    
    
    NSArray *urls = [self urls];
    
    if ([sender.titleLabel.text isEqualToString:@"全部开始"]) {
        
        sender.enabled = NO;
        
        for (NSString *url in urls) {
            [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
                
            } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
                NSLog(@"==%@", error.description);
            }];
            
        }
        
        sender.enabled = YES;
       // sender.titleLabel.text = @"全部结束";
        [sender setTitle:@"全部结束" forState:UIControlStateNormal];
    } else {
        
        sender.enabled = NO;
        
        [[MCDownloader sharedDownloader] cancelAllDownloads];
        
        sender.enabled = YES;
        //sender.titleLabel.text = @"全部开始";
        [sender setTitle:@"全部开始" forState:UIControlStateNormal];
    }
    [self.MainTableView reloadData];
}


- (void)cell:( MainTableViewCell*)cell didClickedBtn:(UIButton *)btn {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:cell.url];
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    MPMoviePlayerViewController *mpc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:receipt.filePath]];
    [vc presentViewController:mpc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
