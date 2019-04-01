# LineCalendar
支持时间连线的日历,支持CocoaPods

LineCalendar * view = [[LineCalendar alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 400)];
[view drawDaysWithData:@[@[@(4),@(5),@(6),@(7),@(8),@(9)]]];
[self.view addSubview:view];
