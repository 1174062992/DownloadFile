//
//  MainTableViewCell.h
//  下载断点续传
//
//  Created by xunli on 2018/3/20.
//  Copyright © 2018年 caoji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QKYDelayButton.h"

@class MainTableViewCell;
/**
 *设置maintbaleviewCell代理
 */
@protocol MainTableViewCellDelegate <NSObject>

- (void)cell:(MainTableViewCell *)cell didClickedBtn:(UIButton *)btn;

@end
/************************************************/
@interface MainTableViewCell : UITableViewCell
/**
 *目标文件的图片标题
 */
@property(nonatomic,strong)UIImageView* Imageview;
/**
 *下载进度条
 */
@property (strong, nonatomic)UIProgressView *progressView;
/**
 *下载目标的名称
 */
@property (strong, nonatomic)UILabel *nameLabel;
/**
 *下载，暂停，开始，按钮
 */
@property (strong, nonatomic)QKYDelayButton *button;
/**
 *已下载目标文件的大小和目标文件的总大小
 */
@property (strong, nonatomic)UILabel *bytesLable;
/**
 *时时下载速度
 */
@property (strong, nonatomic)UILabel *speedLable;
//设置cell的代理
@property (nonatomic, weak) id <MainTableViewCellDelegate> delegate;

//目标文件的连接
@property (nonatomic,copy)NSString *url;
@end
