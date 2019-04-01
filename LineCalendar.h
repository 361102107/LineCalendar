#import <UIKit/UIKit.h>



@interface LineCalendar : UIView
@property(nonatomic,assign)BOOL isShowToday;
@property(nonatomic,assign)BOOL isSelectMonth;
@property(nonatomic,assign)UIColor * normalTitleColor;
@property(nonatomic,assign)UIColor * lineTitleColor;
@property(nonatomic,assign)UIColor * lineColor;

//在日历上将连续天绘制成线
- (void)drawDaysWithData:(NSArray *)data;
//设置某一天的样式,title,size,color等
- (void)setDayWithIndex:(NSNumber*)index title:(NSString *)title size:(CGSize)size backgroudColor:(UIColor *)bColor;


@end


