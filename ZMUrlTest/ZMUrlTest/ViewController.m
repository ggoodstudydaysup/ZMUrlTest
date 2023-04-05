//
//  ViewController.m
//  ZMUrlTest
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import "ViewController.h"
#import "ZMHTTPManager.h"

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *dLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *currLabel;

@property (nonatomic, strong) UILabel *minTimeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSSet *set = [UIApplication sharedApplication].connectedScenes;
    UIWindowScene *wScene = [set anyObject];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, wScene.statusBarManager.statusBarFrame.size.height, UIScreen.mainScreen.bounds.size.width, 200)];
    textView.backgroundColor = [UIColor lightGrayColor];
    _textView = textView;
    _textView.delegate = self;
    [self.view addSubview:textView];
    
    UILabel *dLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(textView.frame) + 20.f, UIScreen.mainScreen.bounds.size.width - 40, 40)];
    dLabel.textAlignment = NSTextAlignmentCenter;
    _dLabel = dLabel;
    [self.view addSubview:dLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(dLabel.frame) + 20.f, UIScreen.mainScreen.bounds.size.width - 40, 40)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel = timeLabel;
    [self.view addSubview:timeLabel];
    
    UILabel *currLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_timeLabel.frame) + 20.f, UIScreen.mainScreen.bounds.size.width - 40, 40)];
    currLabel.textAlignment = NSTextAlignmentCenter;
    _currLabel = currLabel;
    [self.view addSubview:currLabel];
    
    UILabel *minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_currLabel.frame) + 20.f, UIScreen.mainScreen.bounds.size.width - 40, 40)];
    minTimeLabel.textAlignment = NSTextAlignmentCenter;
    _minTimeLabel = minTimeLabel;
    [self.view addSubview:minTimeLabel];
    
    UIButton *conn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_minTimeLabel.frame) + 20.f, UIScreen.mainScreen.bounds.size.width - 40, 50)];
    [conn setTitle:@"点击连接" forState:UIControlStateNormal];
    conn.titleLabel.font = [UIFont systemFontOfSize:20];
    conn.titleLabel.textColor = UIColor.blueColor;
    conn.backgroundColor = UIColor.blueColor;
    [conn addTarget:self action:@selector(connectionTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:conn];
}

- (void)connectionTap:(id)sender
{
    NSString *urlStr = _dLabel.text;
    
    __weak typeof (self) weakSelf = self;
    [[ZMHTTPManager sharedInstance]startLoadingURL:urlStr response:^(NSTimeInterval duration) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *result = [NSString stringWithFormat:@"当前响应时间：%f毫秒", duration];
            weakSelf.timeLabel.text = result;
            weakSelf.currLabel.text = [NSString stringWithFormat:@"最快URL：%@", [ZMHTTPManager sharedInstance].minUrl];
            weakSelf.minTimeLabel.text = [NSString stringWithFormat:@"最快响应时间：%f毫秒", [ZMHTTPManager sharedInstance].minDuration];
            NSLog(@"%@响应时间：%f毫秒", urlStr, duration);
        });
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    _dLabel.text = textView.text;
}

@end
