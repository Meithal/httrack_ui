#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define UNAVAILABLE_ATTRIBUTE
#define instancetype id

//typedef void* id;
typedef unsigned NSUInteger;
typedef unsigned char BOOL;
#define YES 1
#define NO 0

#define nil 0


@class NSString;

extern NSString* NSFileCreationDate;
extern NSString* NSDocumentDirectory;
extern NSString* NSUserDomainMask;
typedef NSString* NSErrorDomain;

@protocol NSObject
@end

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

@class NSString, NSArray;
@interface NSString:NSObject {}
+(id)stringWithFormat:(NSString*)other, ...;
+(NSString*)stringWithUTF8String:(const char*)str;
-(int)length;
-(BOOL)isEqualToString:(id)other;
-(NSString*)stringByAppendingPathComponent:(NSString*)path;
-(NSString*)stringByAppendingString:(NSString*)string;
-(const char*)UTF8String;
-(NSArray*)pathComponents;
-(NSString*)substringFromIndex:(int)index;
@end

@interface NSDate:NSObject {}
@end

@interface NSArray:NSObject {}
-(id)objectAtIndex:(int)idx;
-(int)count;
-(void)addObject:(id)obj;
-(id)firstObject;
@end

@interface NSNumber:NSObject {}
+(id)numberWithInt:(int)num;
+(id)numberWithLong:(long)num;
+(id)numberWithFloat:(float)num;
@end

@interface NSMutableArray:NSArray {}
-(void)removeAllObjects;
@end

@interface NSDictionary : NSObject {}
-(id)valueForKey:(NSString*)key;
@end

@interface NSOrderedSet : NSObject {}
+(NSOrderedSet*)orderedSetWithArray:(NSArray*)arr;
-(NSArray*)array;
@end

@interface NSMutableOrderedSet: NSOrderedSet {}
+(NSMutableOrderedSet*)orderedSetWithArray:(NSArray*)arr;
-(void)addObjectsFromArray:(NSArray*)arr;
@end

@class NSURL;
@interface NSURL: NSObject {}
+(NSURL*)URLWithString:(NSString*)string relativeToURL:(NSURL*)url;
-(NSURL*)URLByAppendingPathComponent:(NSString*)path;
-(NSString*)path;
@end

@class NSError;
@class NSDirectoryEnumerator;
@interface NSFileManager: NSObject {}
+(NSFileManager*)defaultManager;
-(BOOL)fileExistsAtPath:(NSString*)path;
-(NSDirectoryEnumerator*)enumeratorAtPath:(NSString*)path;
-(BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL*)is_dir;
-(NSDictionary*)attributesOfItemAtPath:(NSString*)path error:(NSError**)error;
-(NSArray*)URLsForDirectory:(NSString*)dir inDomains:(NSString*)domain;
@end

@interface NSThread : NSObject {}
+(BOOL)isMultiThreaded;
@end

@interface NSUserDefaults : NSObject {}
+(id) standardUserDefaults;
-(void)setObject:(id)o forKey:(NSString*)key;
-(void)setURL:(NSURL*)url forKey:(NSString*)key;
-(NSArray*)arrayForKey:(NSString*)key;
-(NSURL*)URLForKey:(NSString*)key;
@end

//@class NSFastEnumerationState;
// @interface NSFastEnumerationState : NSObject {}
// @end
// struct __objcFastEnumerationState {int foo;};
// typedef struct __objcFastEnumerationState NSFastEnumerationState ;

@interface NSDirectoryEnumerator : NSObject{}
-(id)nextObject;
-(void)skipDescendants;
-(id)countByEnumeratingWithState:(struct __objcFastEnumerationState*)state objects:(id[])objects count:(int)ct;
@end

@interface NSError : NSObject {}
@end

@class NSBlockOperation, NSOperationQueue;
@interface NSOperationQueue: NSObject {}
+(NSOperationQueue*)mainQueue;
-(void)addOperation:(NSBlockOperation*)operation;
-(void)addOperationWithBlock:(id)block;
-(void)setName:(NSString*)name;
-(void)waitUntilAllOperationsAreFinished;
@end

@interface NSBlockOperation :NSObject {}
+(NSBlockOperation*)blockOperationWithBlock:(id)block;
-(void)setName:(NSString*)name;
@end
