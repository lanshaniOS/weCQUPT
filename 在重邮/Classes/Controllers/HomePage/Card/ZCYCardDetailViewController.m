//
//  ZCYCardDetailViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/31.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCardDetailViewController.h"
#import "ZCYCardHelper.h"
#import "ZCYBezierPath.h"

@interface ZCYCardDetailViewController ()

@property (strong, nonatomic) UIView *bottomView;  /**< 底部视图 */
@property (strong, nonatomic) UILabel *balanceLabel;  /**< 余额 */
@property (strong, nonatomic) UIButton *payDetailButton;  /**< 消费详情 */
@property (strong, nonatomic) UILabel *closeDayLabel;  /**< 截止日期 */
//@property (strong, nonatomic) UILabel *tipLabel;  /**< 提示 */
@property (strong, nonatomic) NSString *balanceString;  /**< 余额 */
@property (strong, nonatomic) UIButton *finishButton;  /**< 完成按钮 */
@property (strong, nonatomic) NSArray *cardArray;  /**< 消费 */
@property (strong, nonatomic) NSMutableArray *balanceArray;  /**< 消费数组 */
@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**< 背景滑动 */

@end

@implementation ZCYCardDetailViewController

- (NSString *)title
{
    return @"一卡通";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI
{

//    [self initTipLabel];
    [self initBezierView];
}

//- (void)initTipLabel
//{
//    self.tipLabel = [[UILabel alloc] init];
//    [self.tipLabel setFont:kFont(kStandardPx(50)) andText:@"获取数据中..." andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
//    [self.view addSubview:self.tipLabel];
//    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.and.centerX.equalTo(self.view);
//    }];
//}

- (void)initBezierView
{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height - 64 - 68);
    self.backgroundScrollView.bounces = NO;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.bottom.equalTo(self.view).with.offset(-68);
    }];
    [[ZCYProgressHUD sharedHUD] rotateWithText:@"数据加载中..." inView:self.view];
    [ZCYCardHelper getCardDetailWithCardID:[[NSUserDefaults standardUserDefaults] objectForKey:@"private_userNumber"] withCompletionBlock:^(NSError *error, NSArray *array) {
        [[ZCYProgressHUD sharedHUD] hideAfterDelay:0.0f];
        if (error)
        {
            [[ZCYProgressHUD sharedHUD] showWithText:[error localizedDescription] inView:self.view hideAfterDelay:1.0f];
//            self.tipLabel.text = @"网络开小差啦～～～";
        } else {
//            self.tipLabel.hidden = YES;
            self.balanceString = array[0][@"balance"];
            self.cardArray = array;
            [self initBottomView];
            NSMutableArray *balcanceArray = [NSMutableArray array];
            NSMutableArray <NSValue *> *pointArray = [NSMutableArray array];
            for (NSInteger index = 0; index<10; index++)
            {
                [balcanceArray addObject:self.cardArray[index][@"balance"]];
            }
            NSArray *sortArray = [self bubbleSortWithArray:balcanceArray];
            
            NSInteger max = 1;
//            NSInteger first = [sortArray[0] integerValue];
            NSInteger last = [sortArray[9] integerValue];
//            for (NSInteger index = 0; ; index++)
//            {
//                if (first / 10 == 0)
//                {
//                    min = first * min;
//                    break;
//                } else {
//                    
//                    first = first / 10;
//                    min = min *10;
//                }
//            }
            for (NSInteger index = 0; ; index++)
            {
                if (last / 10 == 0)
                {
                    max = max * last;
                    break;
                } else {
                    last = last / 10;
                    max = max*10;
                }
            }
            
            for (NSInteger index = 0; index<10; index++)
            {

                CGFloat y = [self.cardArray[9-index][@"balance"] floatValue];
                [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/4.5 * index, self.view.frame.size.height - 128 - 64 - ((self.view.frame.size.height - 128 - 64)/(max + 10)*y))]];
                UILabel *dayLabel = [[UILabel alloc] init];
                NSString *string = [self.cardArray[9-index][@"time"] substringWithRange:NSMakeRange(5, 5)];
                dayLabel.textAlignment = NSTextAlignmentCenter;
                [dayLabel setFont:kFont(kStandardPx(30)) andText:string andTextColor:kDeepGray_Color andBackgroundColor:kTransparentColor];
                [self.backgroundScrollView addSubview:dayLabel];
                [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.backgroundScrollView).with.offset(index * self.view.frame.size.width/4.5);
                    make.width.mas_equalTo(self.view.frame.size.width/4.5);
                    make.bottom.equalTo(self.view).with.offset(-68);
                    make.height.mas_equalTo(60);
                }];
                
            }
            
            ZCYBezierPath *path = [[ZCYBezierPath alloc] initWithPointArray:pointArray];
            CAShapeLayer *layer = [path drawThirdBezierPathWithWidth:self.view.frame.size.width andHeight:self.view.frame.size.height];
            path.backgroundColor = kCommonWhite_Color;
            
            [self.backgroundScrollView addSubview:path];
            [path mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundScrollView);
//                make.bottom.equalTo(self.backgroundScrollView.mas_bottom).with.offset(-60);
                make.width.mas_equalTo(self.view.frame.size.width*2);
                make.height.mas_equalTo(self.view.frame.size.height - 128 - 64);
                make.top.equalTo(self.view).with.offset(64);
            }];
            
            for (NSInteger index = 0; index < 10; index++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = kCommonGray_Color;
                [button setTag:10000+index];
                [button addTarget:self action:@selector(clickLine:) forControlEvents:UIControlEventTouchUpInside];
                [self.backgroundScrollView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.backgroundScrollView).with.offset(self.view.frame.size.width/4.5*index);
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(self.view.frame.size.height - 68 - 64);
                    make.top.equalTo(self.view).with.offset(64);
                }];
                
            }
            
//            UIView *topLine = [[UIView alloc] init];
//            topLine.
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"渐变图"]];
//            imageView.backgroundColor = kCommonRed_Color;
            imageView.layer.mask = layer;
            [self.backgroundScrollView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundScrollView);
                make.width.mas_equalTo(self.view.frame.size.width*2);
                make.top.equalTo(self.view).with.offset(64);
                make.bottom.equalTo(self.view).with.offset(-128);
            }];
            
            
        }
    }];
    
}

- (void)initBottomView
{
    self.bottomView = [[UIView alloc] init];
    
    self.bottomView.backgroundColor = kCommonLightGray_Color;
    self.bottomView.alpha = 0.95f;
    self.bottomView.layer.shadowOpacity = 0.95f;
    self.bottomView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.bottomView.layer.shadowRadius = 3;
    self.bottomView.layer.shadowOffset= CGSizeMake(0, -0.5);
    self.bottomView.layer.cornerRadius = kStandardPx(18);
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(kStandardPx(18)/2);
        make.height.mas_equalTo(68+kStandardPx(18)/2);
        make.left.and.right.equalTo(self.view);
    }];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.bottomView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.and.left.equalTo(self.bottomView);
    }];
    
    self.balanceLabel = [[UILabel alloc] init];
    NSString *balcanc = [NSString stringWithFormat:@"余额%@元",self.balanceString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:balcanc];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kDeepGreen_Color range:NSMakeRange(2, balcanc.length - 3)];
    [self.balanceLabel setFont:kFont(kStandardPx(40)) andText:@"" andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    self.balanceLabel.attributedText = attributedString;
    [self.bottomView addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16);
        make.top.equalTo(self.bottomView).with.offset(10);
    }];
    
    self.closeDayLabel = [[UILabel alloc] init];
    [self.closeDayLabel setFont:kFont(kStandardPx(30)) andText:[NSString stringWithFormat:@"截止昨日00:00"] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [self.bottomView addSubview:self.closeDayLabel];
    [self.closeDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).with.offset(2);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kDeepGray_Color;
    line.layer.cornerRadius = kStandardPx(5);
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(36, 5));
    }];
    
    self.payDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payDetailButton setTitle:@"消费详情" forState:UIControlStateNormal];
    [self.payDetailButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    self.payDetailButton.titleLabel.font = kFont(kStandardPx(34));
    [self.payDetailButton addTarget:self action:@selector(showPayDetailedView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.payDetailButton];
    [self.payDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(hidePayDetailedView) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton.titleLabel.font = kFont(kStandardPx(34));
    self.finishButton.hidden = YES;
    [self.bottomView addSubview:self.finishButton];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.centerY.equalTo(self.bottomView);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
    
    
//    UISwipeGestureRecognizer *upGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showWeekSelectedView)];
//    upGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.bottomView addGestureRecognizer:upGestureRecognizer];
//    
//    UISwipeGestureRecognizer *downGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideWeekSelectedView)];
//    downGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.bottomView addGestureRecognizer:downGestureRecognizer];
//    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleWeekSelectedView:)];
//    [self.bottomView addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - 点击事件
- (void)showPayDetailedView
{
    
}

- (void)hidePayDetailedView
{
    
}

- (void)clickLine:(UIButton *)button
{
    if (button.tag == 10001)
    {
        NSLog(@"aaaà");
    }
}

#pragma mark - TOOLS
- (NSArray *)bubbleSortWithArray:(NSMutableArray *)mutableArray
{
    float bubble[10] = {[mutableArray[0] floatValue], [mutableArray[1] floatValue], [mutableArray[2] floatValue], [mutableArray[3] floatValue], [mutableArray[4] floatValue], [mutableArray[5] floatValue], [mutableArray[6] floatValue], [mutableArray[7] floatValue], [mutableArray[8] floatValue], [mutableArray[9] floatValue]};
    
    for (int i = 0; i<10; i++)
    {
        for (int j = 0; j<10-i - 1; j++)
        {
            
            if (bubble[j] > bubble[j+1])
            {
                float temp = 0;
                temp = bubble[j];
                bubble[j] = bubble[j+1];
                bubble[j+1] = temp;
            }
        }
    }
    return @[[NSNumber numberWithFloat:bubble[0]], @(bubble[1]), @(bubble[2]), @(bubble[3]), @(bubble[4]), @(bubble[5]), @(bubble[6]), @(bubble[7]), @(bubble[8]), @(bubble[9])];
}
@end
