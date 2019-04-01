# LineCalendar

<p align="center">
<a href=""><img src="https://img.shields.io/badge/pod-v1.1.1-brightgreen.svg"></a>
<a href=""><img src="https://img.shields.io/badge/ObjectiveC-compatible-orange.svg"></a>
<a href=""><img src="https://img.shields.io/badge/platform-iOS%205.0%2B-ff69b5152950834.svg"></a>
<a href="https://github.com/rakuyoMo/RKOTools/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat"></a>
</p>

支持时间连线的日历,支持CocoaPods

集成:
pod 'LineCalendar'

使用:
LineCalendar * view = [[LineCalendar alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 400)];

[view drawDaysWithData:@[@[@(4),@(5),@(6),@(7),@(8),@(9)],@[@(15),@(16),@(17)]]];

view.isShowToday = YES;//将当天日期标红

view.isSelectMonth = YES;//是否可以选择月份

[self.view addSubview:view];
