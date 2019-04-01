# LineCalendar
支持时间连线的日历,支持CocoaPods

集成:
pod 'LineCalendar'

bundle 中的图片暂时未能上传到pods,翻转图片暂时未能读取,可以手动下载拖入到项目中

使用:
LineCalendar * view = [[LineCalendar alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 400)];
[view drawDaysWithData:@[@[@(4),@(5),@(6),@(7),@(8),@(9)],@[@(15),@(16),@(17)]]];
view.isShowToday = YES;//将当天日期标红
view.isSelectMonth = YES;//是否可以选择月份
[self.view addSubview:view];
