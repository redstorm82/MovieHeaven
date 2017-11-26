//
//  AddCommentController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/24.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "AddCommentController.h"
#import "StarView.h"
#import <Masonry.h>
#import "UITools.h"
@interface AddCommentController ()
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) StarView *starView;
@end

@implementation AddCommentController
-(void)awakeFromNib {
    [super awakeFromNib];
    self.arrowType = noArrow;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.view.layer.cornerRadius = 30;
    self.navigationController.view.clipsToBounds = YES;
    self.navigationController.view.top = 100;
    self.navigationController.view.alpha = 0.98;
}
- (void)createUI {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = [NSString stringWithFormat:@"说说你对 %@ 的看法吧",self.videoName];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = K9BColor;
    [placeHolderLabel sizeToFit];
    [self.commentTextView addSubview:placeHolderLabel];
    [self.commentTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    self.commentTextView.font = [UIFont systemFontOfSize:14.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    
    self.starView = [[StarView alloc]initWithFrame:CGRectMake(0, 0, 0, 40) starTotalCount:5 lightStarCount:0 isEditable:YES WhenClickStar:^(NSInteger currentIndex) {
        
    }];
    [self.view addSubview:self.starView];
    TO_WEAK(self, weakSelf);
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        TO_STRONG(weakSelf, strongSelf);
        make.top.equalTo(strongSelf.commentTextView.mas_bottom).mas_offset(15);
        make.centerX.equalTo(strongSelf.view);
        make.size.mas_equalTo(strongSelf.starView.size);
    }];
    UILabel *tipLabel = [LabelTool createLableWithTextColor:UIColorFromRGB(0x0096ff) textFontOfSize:17];
    tipLabel.text = @"视频首次评论将至少获得5积分哦☆´∀｀☆\n多次评论每次最多加1积分或不加积分，积分将在未来版本兑换相应权益。";
    
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentTextView);
        make.top.equalTo(self.starView.mas_bottom).mas_offset(30);
    }];
    [tipLabel sizeToFit];
    [self setNavItemWithTitle:@"取消" isLeft:YES target:self action:@selector(goBack)];
    [self setNavItemWithTitle:@"发布" isLeft:NO target:self action:@selector(addCommentRequest)];
    
}

- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)addCommentRequest {
    if (self.commentTextView.text.length < 5) {
        [[ToastView sharedToastView]show:@"评论不得少于五个字哦╮(╯▽╰)╭" inView:nil];
        return;
    }
    if (self.starView.lightStarCount < 1) {
        [[ToastView sharedToastView]show:@"好歹给颗星吧 щ(ﾟДﾟщ)" inView:nil];
        return;
    }
    NSDictionary *data = @{
                           @"videoId": @(self.videoId),
                           @"videoName": self.videoName,
                           @"score": @(self.starView.lightStarCount),
                           @"content":self.commentTextView.text,
                           @"img": _img ? _img : @""
                           };
    
    [HttpHelper POSTWithWMH:WMH_COMMENT_ADD headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            if (self.commentCompletion) {
                self.commentCompletion();
            }
            dispatch_main_async_safe(^{
                [self goBack];
            })
        }else {
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
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
