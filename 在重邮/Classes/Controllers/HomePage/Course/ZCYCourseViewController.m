//
//  ZCYCourseViewController.m
//  在重邮
//
//  Created by 周维康 on 16/10/29.
//  Copyright © 2016年 周维康. All rights reserved.
//

#import "ZCYCourseViewController.h"
#import "ZCYTimeTableModel.h"


@interface ZCYCourseViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIScrollView *backgroundScrollView;  /**<  滑动背景 */
@property (strong, nonatomic) UIView *leftTimeView;  /**< 左部上课节数 */
@property (strong, nonatomic) UIView *headerView;  /**< 顶部周次条 */
@property (strong, nonatomic) UICollectionView *courseCollectionView;  /**< 课表 */
@property (strong, nonatomic) UIView *bottomView;  /**< 底部 */
@property (strong, nonatomic) UIPickerView *weekPicker;  /**< 周数选择 */
@end

@implementation ZCYCourseViewController
{
    CGFloat _courseWidth;
    NSArray *_weekArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark - initUI
- (void)initUI
{
    _courseWidth = (self.view.frame.size.width-28)/5;
    self.view.backgroundColor = kCommonWhite_Color;
    self.title = @"课表";
    self.navigationController.navigationBar.alpha = 1.0f;
    [self initBackgroundView];
    [self initCourseCollectionView];
    [self initHeaderView];
    [self initLeftTimeView];
    [self initBottomView];
}

- (void)initHeaderView
{
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = kCommonLightGray_Color;
    [self.backgroundScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.left.equalTo(self.backgroundScrollView).with.offset(-200);
        make.width.mas_equalTo(1000);
        make.height.mas_equalTo(27);
    }];
    
    NSArray *numArray = @[@"", @"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    for (NSUInteger index = 1; index <= 7; index++)
    {
        UIView *numView = [[UIView alloc] init];
        if ([NSDate date].week == index)
        {
            [self setView:numView WithNum:numArray[index] andSegColor:kCourseGreen_Color shouldShowSeg:YES];
        } else {
             [self setView:numView WithNum:numArray[index] andSegColor:kCourseGreen_Color shouldShowSeg:NO];
        }
        
        [self.headerView addSubview:numView];
        [numView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_courseWidth + 0.5);
            make.left.equalTo(self.backgroundScrollView.mas_left).with.offset(28+(index-1)*(_courseWidth + 0.5));
            make.top.and.bottom.equalTo(self.headerView);
        }];
    }
}

- (void)initBackgroundView
{
    self.backgroundScrollView = [[UIScrollView alloc] init];
    self.backgroundScrollView.contentSize = CGSizeMake(_courseWidth*7 + 28 + 3, 27+_courseWidth*6*1.26 + 3);
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.scrollEnabled = YES;
    self.backgroundScrollView.directionalLockEnabled = YES;
    [self.view addSubview:self.backgroundScrollView];
    [self.backgroundScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-68);
    }];
}

- (void)initCourseCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(_courseWidth, _courseWidth*1.26 + 0.5);
    self.courseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.courseCollectionView.backgroundColor = kCommonGray_Color;
    [self.courseCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"courseCollctionViewCellID"];
    self.courseCollectionView.delegate = self;
    self.courseCollectionView.dataSource = self;
    self.courseCollectionView.scrollEnabled = NO;
    self.courseCollectionView.showsVerticalScrollIndicator = NO;
    self.courseCollectionView.showsHorizontalScrollIndicator = NO;
    [self.backgroundScrollView addSubview:self.courseCollectionView];
    [self.courseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundScrollView).with.offset(27);
        make.left.equalTo(self.backgroundScrollView).with.offset(28);
        make.height.mas_equalTo(6*1.26*_courseWidth + 3);
        make.width.mas_equalTo(7*_courseWidth+3);
    }];

}

- (void)initBottomView
{
    self.bottomView = [[UIView alloc] init];

    self.bottomView.backgroundColor = kCommonLightGray_Color;
    self.bottomView.alpha = 0.7f;
    self.bottomView.layer.shadowOpacity = 0.8f;
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
    
    UILabel *weekLabel = [[UILabel alloc] init];
    weekLabel.textColor = kCommonText_Color;
    weekLabel.text = [NSString stringWithFormat:@"第%@周", [NSDate date].schoolWeekString];
    [weekLabel sizeToFit];
    weekLabel.font = kFont(kStandardPx(40));
    [self.bottomView addSubview:weekLabel];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16);
        make.centerY.equalTo(self.bottomView);
        
        make.height.mas_offset(20);
    }];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    [dayLabel setFont:kFont(kStandardPx(30)) andText:[NSString stringWithFormat:@"星期%@", [NSDate date].weekString] andTextColor:kCommonText_Color andBackgroundColor:kTransparentColor];
    [dayLabel sizeToFit];
    [self.bottomView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weekLabel.mas_right).with.offset(10);
        make.bottom.equalTo(weekLabel);
        
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kCommonGray_Color;
    line.layer.cornerRadius = kStandardPx(5);
    [self.bottomView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView).with.offset(6);
        make.size.mas_equalTo(CGSizeMake(36, 5));
    }];
    
    UIButton *weekButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [weekButton setTitle:@"选择周次" forState:UIControlStateNormal];
    [weekButton setTitleColor:kDeepGreen_Color forState:UIControlStateNormal];
    weekButton.titleLabel.font = kFont(kStandardPx(34));
    [weekButton addTarget:self action:@selector(showWeekSelectedView) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:weekButton];
    [weekButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).with.offset(-16);
        make.bottom.equalTo(weekLabel);
        make.width.mas_equalTo(74);
        make.height.mas_equalTo(20);
    }];
}
- (void)initLeftTimeView
{
    CGFloat _timeLabelWidth = _courseWidth * 1.26 / 2;
    self.leftTimeView = [[UIView alloc] init];
    self.leftTimeView.backgroundColor = kCommonLightGray_Color;
    [self.backgroundScrollView addSubview:self.leftTimeView];
    [self.leftTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(28);
        make.top.equalTo(self.backgroundScrollView).with.offset(-500);
        make.bottom.equalTo(self.courseCollectionView).with.offset(500);
    }];
    for (NSUInteger index = 1; index <= 12; index++)
    {
        UILabel *indexLabel = [[UILabel alloc] init];
        indexLabel.text = [NSString stringWithFormat:@"%@", @(index)];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.textColor = kText_Color_Default;
        indexLabel.font = kFont(kStandardPx(26));
        [self.leftTimeView addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.leftTimeView);
            make.top.equalTo(self.backgroundScrollView).with.offset((index - 1)*_timeLabelWidth + 27);
            make.height.mas_equalTo(_timeLabelWidth);
        }];
    }
}

- (void)initWeekPickerView
{
    self.weekPicker = [[UIPickerView alloc] init];
    _weekArray = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"二十一 "];
    self.weekPicker.dataSource = self;
    self.weekPicker.delegate = self;
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _weekArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 80;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.view.frame.size.width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _weekArray[row];
}

#pragma mark - UICollectionViewDelegate&UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.courseCollectionView dequeueReusableCellWithReuseIdentifier:@"courseCollctionViewCellID" forIndexPath:indexPath];
    
    UIColor *cellColor;
    switch (indexPath.section) {
        case 0:
        case 1:
            cellColor = kCourseGreen_Color;
            break;
        case 2:
        case 3:
            cellColor = kCommonGolden_Color;
            break;
        case 4:
        case 5:
            cellColor = kDeepGray_Color;
        default:
            cellColor = kCommonRed_Color;
            break;
    }
    NSArray *courseArray = [ZCYUserMgr sharedMgr].courseArray[indexPath.row];
    NSArray *colArray = courseArray[indexPath.section];
    
    cell.backgroundColor = kCommonWhite_Color;
    [colArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZCYTimeTableModel *model  = obj;
        for (NSUInteger i=0; i<model.courseWeeks.count; i++)
        {
            if ([model.courseWeeks[i] integerValue] == [NSDate date].schoolWeek)
            {
                [self setCollectionViewCell:cell withColor:cellColor andCourseName:model.courseName andClassID:model.coursePlace];
                [cell setRadius:5.0f];
            }
        }
    }];
    return cell;
   
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.5f;
}

#pragma mark - 点击事件
- (void)showWeekSelectedView
{
    
}

#pragma mark - TOOL

- (void)setView:(UIView *)view WithNum:(NSString *)numString andSegColor:(UIColor *)color shouldShowSeg:(BOOL)showSeg
{
    view.backgroundColor = kCommonLightGray_Color;
    UILabel *label = [[UILabel alloc] init];
    label.text = numString;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kCommonText_Color;
    label.font = kFont(kStandardPx(26));
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_courseWidth - 40);
        make.height.and.bottom.equalTo(view);
        make.left.equalTo(view).with.offset(20);
    }];
    
    if (showSeg == YES)
    {
        UIView *segView = [[UIView alloc] init];
        segView.backgroundColor = kCourseGreen_Color;
        [view addSubview:segView];
        [segView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.width.equalTo(label);
            make.left.and.bottom.equalTo(label);
        }];
    }
}

- (void)setCollectionViewCell:(UICollectionViewCell *)cell withColor:(UIColor *)cellColor andCourseName:(NSString *)courseName andClassID:(NSString *)classID
{
    NSInteger idc = [classID integerValue];
    NSString *classPlaceString;
    if (idc != 0)
    {
        classPlaceString = [NSString stringWithFormat:@"%@",@(idc)];
    } else {
        classPlaceString = [classID substringWithRange:NSMakeRange(0, [classID
                                                                        length]-3)];
    }
    cell.backgroundColor = cellColor;
    
    UILabel *courseeLabel = [[UILabel alloc] init];
    courseeLabel.textAlignment = NSTextAlignmentCenter;
    courseeLabel.text = [NSString stringWithFormat:@"%@", courseName];
    courseeLabel.textColor = kCommonWhite_Color;
    courseeLabel.font = kFont(kStandardPx(24*self.view.frame.size.width/375));
    courseeLabel.numberOfLines = 0;
    [cell addSubview:courseeLabel];
    [courseeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(2.5);
        make.right.equalTo(cell).with.offset(-2.5);
        make.centerY.equalTo(cell).with.offset(-8);
    }];
    
    UILabel *classIDLabel = [[UILabel alloc] init];
    classIDLabel.text = [NSString stringWithFormat:@"%@", classPlaceString];
    classIDLabel.textColor = kCommonWhite_Color;
    classIDLabel.font = kFont(kStandardPx(24*self.view.frame.size.width/375));
    classIDLabel.textAlignment = NSTextAlignmentCenter;
    classIDLabel.numberOfLines = 0;
    [cell addSubview:classIDLabel];
    [classIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).with.offset(2.5);
        make.right.equalTo(cell).with.offset(-2.5);
        make.top.equalTo(courseeLabel.mas_bottom);
    }];
    
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = kCommonLightGray_Color;
    [cell addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell);
        make.left.and.right.equalTo(cell);
        make.height.mas_equalTo(0.5);
    }];
}
@end
