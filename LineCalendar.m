#import "LineCalendar.h"

@interface LineCalendar(){
    UIView * calendarView;
    NSMutableArray * dayLabels;
    NSDate * currentDate;
    UILabel * dateLabel;
    UILabel * todayLabel;
}
@property(nonatomic,strong)UIButton * lastBtn;
@property(nonatomic,strong)UIButton * nextBtn;
@end

@implementation LineCalendar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    if(!currentDate){
        currentDate =  [self getCurrentDate];
    }
    self.clipsToBounds = YES;
    dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 12)];
    dateLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, dateLabel.center.y);
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:dateLabel];
    
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastBtn.frame =CGRectMake(CGRectGetMinX(dateLabel.frame) - 10 - 10, 0, 10, 10);
    _lastBtn.center =  CGPointMake(_lastBtn.center.x, dateLabel.center.y);
    [_lastBtn setImage:[UIImage imageNamed:RKOTextViewSrcName(@"calendarNext.png")]?:[UIImage imageNamed:RKOTextViewFrameworkSrcName(@"calendarNext.png")] forState:UIControlStateNormal];
    _lastBtn.transform = CGAffineTransformMakeRotation(M_PI);
    [_lastBtn addTarget:self action:@selector(clickLastBtn:) forControlEvents:UIControlEventTouchUpInside];
    _lastBtn.alpha = 0;
    [self addSubview:_lastBtn];

    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame =CGRectMake(CGRectGetMaxX(dateLabel.frame) + 10, 0, 10, 10);
    _nextBtn.center =  CGPointMake(_nextBtn.center.x, dateLabel.center.y);
    [_nextBtn setImage:[UIImage imageNamed:RKOTextViewSrcName(@"calendarNext.png")]?:[UIImage imageNamed:RKOTextViewFrameworkSrcName(@"calendarNext.png")] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(clickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.alpha =  0;
    [self addSubview:_nextBtn];
    
    
    NSInteger sumWidth = CGRectGetWidth(self.frame) - 60;
    NSInteger labelWidth = 20;
    NSInteger spaceWidth = (sumWidth - 7 * labelWidth) / 6.0;
    NSArray * names = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < names.count; i ++){
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30 + (spaceWidth + labelWidth) * (CGFloat)i, 40 , labelWidth, labelWidth)];
        label.textAlignment =  NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = names[i];
        label.font = [UIFont systemFontOfSize:9];
        [self addSubview:label];
    }
    calendarView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) -  112)];
    [self addSubview:calendarView];
    dayLabels = [[NSMutableArray alloc] init];
    [self drawDay];
}
//绘制日历天数
- (void)drawDay{
    NSDate * todayDate = [self getCurrentDate];
    NSInteger sumWidth = CGRectGetWidth(self.frame) - 60;
    NSInteger labelWidth = 20;
    NSInteger spaceWidth = (sumWidth - 7 * labelWidth) / 6.0;
    NSInteger startIndex = [self getFirstDayWeek];
    NSInteger sumDays = [self getMonthDaysWithDate:currentDate];
    for (int i = 0, j = 1; i < sumDays + startIndex - 1; i ++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(30 + (spaceWidth + labelWidth) * (CGFloat)(i % 7),25 * (i / 7) , labelWidth, labelWidth)];
        label.textAlignment =  NSTextAlignmentCenter;
        label.textColor = self.normalTitleColor ?: [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:9];
        [calendarView addSubview:label];
        
        if(i >= startIndex - 1){
            label.text = [NSString stringWithFormat:@"%d",j];
            
            [dayLabels addObject:label];
            
            //判断是否是当天,获取到当天的label
            if([[self getStringFromeDate:currentDate] isEqualToString:[self getStringFromeDate:todayDate]]){
                NSInteger dayInt = [self getIntergerFromDate:currentDate];
                if(dayInt == j){
                    label.text = [NSString stringWithFormat:@"%d",j];
                    todayLabel = label;
                    self.isShowToday = _isShowToday ? YES : NO;
                }
            }
            j++;
        }
        
        
    }
    dateLabel.text = [self getYearMonthWithDate:currentDate];
}

- (void)clickLastBtn:(UIButton *)sender{
    currentDate = [self getPriousorLaterDateFromDate:currentDate  withMonth:-1];
    [self reloadCalendarWithDate];
}

- (void)clickNextBtn:(UIButton *)sender{
    currentDate = [self getPriousorLaterDateFromDate:currentDate  withMonth:1];
    [self reloadCalendarWithDate];
}

- (void)reloadCalendarWithDate{
    [dayLabels removeAllObjects];
    for(UIView * view in calendarView.subviews){
        [view removeFromSuperview];
    }
    [self drawDay];
}

- (void)setIsShowToday:(BOOL)isShowToday{
    _isShowToday = isShowToday;
    if(_isShowToday){
        todayLabel.layer.cornerRadius =  10;
        todayLabel.textColor = [UIColor whiteColor];
        todayLabel.backgroundColor =  [UIColor redColor];
        todayLabel.clipsToBounds = YES;
    }
}
- (void)setIsSelectMonth:(BOOL)isSelectMonth{
    _isSelectMonth = isSelectMonth;
    _nextBtn.alpha = isSelectMonth ? 1 : 0;
    _lastBtn.alpha = isSelectMonth ? 1 : 0;
}
//获取日期的天数然后转为整数返回
- (NSInteger)getIntergerFromDate:(NSDate *)date{
    NSString * str = [self getStringFromeDate:date];
    NSString * newStr = [str substringFromIndex:str.length - 2];
    NSInteger interger = [newStr integerValue];
    return interger;
}
//根据传进来的数字切换月份
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}
//获取年月
- (NSString *)getYearMonthWithDate:(NSDate *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:date];
}

- (NSDate *)getCurrentDate{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];

    return localeDate;
}

//获取当月天数
- (NSInteger)getMonthDaysWithDate:(NSDate *)date{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return  range.length;
}

//获取当月第一天返回date
- (NSDate *)getMonthFirstDayWithDate:(NSDate *)date{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * firstDayStr = [[formatter stringFromDate:date] stringByAppendingString:@"-01"];
    NSDateFormatter * returnFormatter = [[NSDateFormatter alloc] init];
    [returnFormatter setDateFormat:@"yyyy-MM-dd"];
    return [returnFormatter dateFromString:firstDayStr];
}

//获取当月第一天星期几
- (NSInteger)getFirstDayWeek{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents * comps = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekOfMonth fromDate:[self getMonthFirstDayWithDate:currentDate]];
    return [comps weekday];
}

- (NSString *)getStringFromeDate:(NSDate *)date{
    NSDateFormatter * returnFormatter = [[NSDateFormatter alloc] init];
    [returnFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

    [returnFormatter setDateFormat:@"yyyy-MM-dd"];
    return [returnFormatter stringFromDate:date];
}


#pragma 日历画图算法
//获取当月周六的数组
- (NSMutableArray  *)getSaturdays{
    NSMutableArray * data = [[NSMutableArray alloc] init];
    NSInteger firstIndex = [self getFirstDayWeek];
    NSInteger dayCount = [self getMonthDaysWithDate:currentDate];
    NSInteger satIndex = 7 -  firstIndex + 1;
    
    while (satIndex <= dayCount) {
        [data addObject:@(satIndex)];
        satIndex = satIndex + 7;
    }
    return data;
}

//获取包含了几个周六的个数
- (NSArray *)getContainSatCountWithDays:(NSArray *)days{
    NSMutableArray * returnData = [[NSMutableArray alloc] init];
    for(NSNumber * number in [self getSaturdays]){
        if([days containsObject:number]){
            [returnData addObject:number];
        }
    }
    return [returnData copy];
}

//根据传进来的数据构造draw数组
- (NSMutableArray *)getDrawDatasWithOriData:(NSArray *)data{
    NSArray * containSatData = [self getContainSatCountWithDays:data];
    NSMutableArray * drawData = [[NSMutableArray alloc] init];
    NSInteger startIndex = 0;
    for(int i = 0; i < containSatData.count; i ++){
        NSNumber * satValue = containSatData[i];
        NSInteger endIndex = [data indexOfObject:satValue];
        NSDictionary * resultsDic = @{@"startIndex":data[startIndex],@"endIndex":data[endIndex]};
        [drawData addObject:resultsDic];
        startIndex = endIndex + 1;
    }
    if(startIndex < data.count){
        NSDictionary * resultsDic = @{@"startIndex":data[startIndex],@"endIndex":data.lastObject};
        [drawData addObject:resultsDic];
    }
    return drawData;
}
//在日历上将连续天绘制成线
- (void)drawLineWithData:(NSArray *)myData{
    NSMutableArray * drawData = [self getDrawDatasWithOriData:myData];
    for(int i = 0; i < drawData.count; i ++){
        NSDictionary * drawDic = drawData[i];
        NSInteger  startIndex = [(NSNumber *)drawDic[@"startIndex"] integerValue];
        NSInteger  endIndex = [(NSNumber *)drawDic[@"endIndex"] integerValue];
        UILabel * startLabel = dayLabels[startIndex - 1];
        UILabel * endLabel = dayLabels[endIndex - 1];
        UIView * drawView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(startLabel.frame), 0, CGRectGetMaxX(endLabel.frame) - CGRectGetMinX(startLabel.frame), 20)];
        drawView.center = CGPointMake(drawView.center.x , startLabel.center.y + CGRectGetMinY(calendarView.frame));
        drawView.backgroundColor = self.lineColor ?: [UIColor orangeColor];
        drawView.layer.cornerRadius = 10;
        drawView.clipsToBounds = YES;
        [self addSubview:drawView];
        [self bringSubviewToFront:calendarView];
    }
    
    //将选中的label的textcolor设置为白色
    for(NSNumber * number in myData){
        UILabel * label = dayLabels[[number integerValue] - 1];
        label.textColor = self.lineTitleColor ?: [UIColor whiteColor];
    }
    
}

- (void)drawDaysWithData:(NSArray *)data{
    for(NSArray * array in data){
        [self drawLineWithData:array];
    }
}

- (void)setDayWithIndex:(NSNumber *)index title:(NSString *)title size:(CGSize)size backgroudColor:(UIColor *)bColor{
    if([index integerValue] > dayLabels.count){return;};
    
    UILabel * label = dayLabels[[index integerValue] - 1];
    CGPoint center = label.center;
    CGRect  newFrame = CGRectMake(0, 0, size.width, size.height);
    label.frame = newFrame;
    label.center = center;
    label.textColor = self.lineTitleColor ?: [UIColor whiteColor];
    label.text = title;
    label.backgroundColor = bColor;
    
}
@end
