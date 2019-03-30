#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineCalendar : UIView
@property(nonatomic,assign)BOOL isShowToday;
@property(nonatomic,assign)BOOL isSelectMonth;
//在日历上将连续天绘制成线
- (void)drawDaysWithData:(NSArray *)data;
//设置某一天的样式,title,size,color等
- (void)setDayWithIndex:(NSNumber*)index title:(NSString *)title size:(CGSize)size backgroudColor:(UIColor *)bColor;


@end

NS_ASSUME_NONNULL_END
