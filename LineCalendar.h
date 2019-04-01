#import <UIKit/UIKit.h>

// 图片路径
// 为通过copy文件夹方式获取图片路径的宏
#define RKOTextViewSrcName(file) [@"LineCalendar.bundle" stringByAppendingPathComponent:file]
// 为通过cocoapods下载安装获取图片路径的宏
#define RKOTextViewFrameworkSrcName(file) [@"Frameworks/LineCalendar.framework/LineCalendar.bundle" stringByAppendingPathComponent:file]

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


