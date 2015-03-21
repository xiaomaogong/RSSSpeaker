#import <Foundation/Foundation.h>

@interface DYGetFetchedRecordsModel : NSObject

@property(nonatomic,strong)NSString *entityName;
@property(nonatomic,strong)NSString *sortName;

@property(nonatomic)NSUInteger limit;
@property(nonatomic)NSUInteger offset;

@property(nonatomic,strong)NSPredicate *predicate;

@end
