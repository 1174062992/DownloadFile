//
//  MainTableViewCell.m
//  下载断点续传
//
//  Created by xunli on 2018/3/20.
//  Copyright © 2018年 caoji. All rights reserved.
//

#import "MainTableViewCell.h"
#import <Masonry.h>

#import "MCDownloader.h"
@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
        // cell页面布局
        [self setupView];
    }
    return self;
}
/**
 *cell页面布局
 */
-(void)setupView{
    self.Imageview =[[UIImageView alloc]init];
    [self addSubview:self.Imageview];
    [self.Imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    self.Imageview.backgroundColor =[UIColor redColor];
    self.Imageview.layer.cornerRadius =50;
    self.Imageview.layer.borderWidth =0.5;
    self.Imageview.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    /********************我是分割线************************/
    self.progressView =[[UIProgressView alloc]init];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(15, 15, 100, 15));
        make.left.mas_equalTo(self.Imageview.mas_right).offset(20);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(10);
    }];
    
    /********************我是分割线************************/
    self.nameLabel =[[UILabel alloc]init];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.Imageview.mas_bottom).offset(20);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(40);
    }];
    self.nameLabel.textColor =[UIColor blackColor];
    
    
    /********************我是分割线************************/
    self.speedLable =[[UILabel alloc]init];
    [self addSubview:self.speedLable];
    [self.speedLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(20);
        make.top.mas_equalTo(self.progressView.mas_bottom).offset(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    self.speedLable.textColor =[UIColor blackColor];
    self.speedLable.textAlignment =NSTextAlignmentCenter;
    /********************我是分割线************************/
    self.bytesLable =[[UILabel alloc]init];
    [self addSubview:self.bytesLable];
    [self.bytesLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(20);
        make.top.mas_equalTo(self.speedLable.mas_bottom).offset(0);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    self.bytesLable.textColor =[UIColor blackColor];
    self.bytesLable.textAlignment =NSTextAlignmentCenter;
    
    /********************我是分割线************************/
    self.button =[[QKYDelayButton alloc]init];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self.bytesLable.mas_top).offset(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    //[self.button setTitle:@"Start" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 10;
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}
- (void)buttonAction:(UIButton *)sender {
    
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
        
        [[MCDownloader sharedDownloader] cancel:receipt completed:^{
            [self.button setTitle:@"Start" forState:UIControlStateNormal];
        }];
    }else if (receipt.state == MCDownloadStateCompleted) {
        
        if ([self.delegate respondsToSelector:@selector(cell:didClickedBtn:)]) {
            [self.delegate cell:self didClickedBtn:sender];
        }
    }else {
        [self.button setTitle:@"Stop" forState:UIControlStateNormal];
        [self download];
    }
    
}
- (void)download {
    
    [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:self.url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        
    } completed:^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
        NSLog(@"==%@", error.description);
    }];
    
    
}
- (void)setUrl:(NSString *)url {
    _url = url;
    
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
    
    receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
        NSString *cacheFolderPath = [cacheDir stringByAppendingPathComponent:@"我自己写的"];
        return [cacheFolderPath stringByAppendingPathComponent:url.lastPathComponent];
    };
    
    //    NSLog(@"%@", receipt.filePath);
    self.nameLabel.text = receipt.truename;
    self.speedLable.text = nil;
    self.bytesLable.text = nil;
    self.progressView.progress = 0;
    self.progressView.progress = receipt.progress.fractionCompleted;
    
    //    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:receipt.filePath]];
    
    if (receipt.state == MCDownloadStateDownloading || receipt.state == MCDownloadStateWillResume) {
        [self.button setTitle:@"Stop" forState:UIControlStateNormal];
    }else if (receipt.state == MCDownloadStateCompleted) {
        [self.button setTitle:@"Play" forState:UIControlStateNormal];
        self.nameLabel.text = @"下载完成";
    }else {
        [self.button setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    __weak typeof(receipt) weakReceipt = receipt;
    receipt.downloaderProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        __strong typeof(weakReceipt) strongReceipt = weakReceipt;
        if ([targetURL.absoluteString isEqualToString:self.url]) {
            [self.button setTitle:@"Stop" forState:UIControlStateNormal];
            self.bytesLable.text = [NSString stringWithFormat:@"%0.1fm/%0.1fm", receivedSize/1024.0/1024,expectedSize/1024.0/1024];
            self.progressView.progress = (receivedSize/1024.0/1024) / (expectedSize/1024.0/1024);
            self.speedLable.text = [NSString stringWithFormat:@"%@/s", strongReceipt.speed ?: @"0"];
        }
        
    };
    
    receipt.downloaderCompletedBlock = ^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
        if (error) {
            [self.button setTitle:@"Start" forState:UIControlStateNormal];
            self.nameLabel.text = @"Download Failure";
        }else {
            [self.button setTitle:@"Play" forState:UIControlStateNormal];
            self.nameLabel.text = @"下载完成";
        }
        
    };
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
