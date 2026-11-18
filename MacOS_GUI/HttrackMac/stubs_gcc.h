#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define UNAVAILABLE_ATTRIBUTE
#define instancetype id

typedef unsigned NSUInteger;
typedef unsigned char BOOL;

@class NSString;

@interface NSObject {}
+(id)alloc;
-(id)init;
-(id)retain;
-(void)release;
-(id)autorelease;
-(id)copy;
-(void)dealloc;
-(NSString*)debugDescription;
@end

@interface NSString:NSObject {}
+(id)stringWithFormat:(NSString*)other, ...;
-(BOOL)isEqualToString:(id)other;
@end

@interface NSDate:NSObject {}
@end

@interface NSArray:NSObject {}
-(id)objectAtIndex:(int)idx;
-(int)count;
-(void)addObject:(id)obj;
@end

@interface NSNumber:NSObject {}
+(id)numberWithInt:(int)num;
+(id)numberWithLong:(long)num;
+(id)numberWithFloat:(float)num;
@end

@interface NSMutableArray:NSArray {}
-(void)removeAllObjects;
@end

@interface NSOrderedSet : NSObject {}
@end

@interface NSMutableOrderedSet: NSOrderedSet {}
@end

@interface NSURL: NSObject {}
@end

@interface NSFileManager: NSObject {}
+(NSFileManager*)defaultManager;
-(BOOL)fileExistsAtPath:(NSString*)path;
@end

@interface NSThread : NSObject {}
+(BOOL)isMultiThreaded;
@end

@interface NSUserDefaults : NSObject {}
-(id) standardUserDefaults;
@end