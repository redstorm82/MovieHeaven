//
//  SendVideoPushViewController.m
//  MovieHeaven
//
//  Created by 石文文 on 2017/11/26.
//  Copyright © 2017年 石文文. All rights reserved.
//

#import "SendVideoPushViewController.h"

@interface SendVideoPushViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SendVideoPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布视频推送";
    self.contentTextView.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendPush:(id)sender {
    
    NSDictionary *data = @{
                           @"videoId": @(self.videoId),
                           @"videoName": self.videoName,
                           @"content":self.contentTextView.text,
                           };

    [HttpHelper POSTWithWMH:WMH_SEND_VIDEO_PUSH headers:nil parameters:data HUDView:self.view progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        [[ToastView sharedToastView]show:data[@"txt"] inView:nil];
        if ([data[@"status"] isEqualToString:@"B0000"]) {
            
        }else {
            
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
    
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
