#import "DYBlurBackground.h"

#define DY_BLURRADIUS   1.0

@implementation DYBlurBackground

// 读取沙盒图片
+ (UIImageView *)DYBackgroundView
{
    UIImage *backimage = nil;
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    //backimage = [UIImage imageNamed:[NSString stringWithFormat:@"bg%ld",(long)week]];
    backimage = [UIImage imageNamed:[NSString stringWithFormat:@"bg",(long)week]];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:backimage];
    imgView.frame = [UIScreen mainScreen].bounds;
    //设置里可以设置是否启用模糊效果
    if (YES) {
        QBlurView *QB = [[QBlurView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        QB.blurRadius = 1.0 * 10;
        QB.synchronized = YES;
        [imgView addSubview:QB];
    }
    return imgView;
}
@end
