#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define UNAVAILABLE_ATTRIBUTE
#define instancetype id

//typedef void* id;
typedef float CGFloat;
typedef int NSInteger;
typedef unsigned NSUInteger;
typedef unsigned char BOOL;
#define YES 1
#define NO 0

#define nil 0


@class NSString;

extern NSString* NSFileCreationDate;
extern NSString* NSDocumentDirectory;
extern NSString* NSUserDomainMask;
extern NSString* NSImageNameFolder;
extern NSString* NSTextContentTypeURL;
typedef NSString* NSErrorDomain;

extern int NSControlStateValueOff;

typedef void IBAction;
#define IBOutlet

typedef struct NSRange{
    int x;
    int y;
} NSRange;

typedef struct NSRectPointer{
    int x;
    int y;
} NSRectPointer;

typedef struct NSPoint{
    int x;
    int y;
} NSPoint;

typedef struct NSSize NSSize;
typedef struct NSRect{
    struct NSSize {
        float width;
        float height;
    } size;
    NSPoint origin;
} NSRect;

NSRect NSMakeRect(int, int, int, int);

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
+(int)class;
-(int)class;
-(NSString*)debugDescription;
-(BOOL)isEqualTo:(id)other;
-(BOOL)isEqual:(id)other;
-(BOOL)respondsToSelector:(SEL)sel;
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

@class NSMutableArray;
@interface NSArray:NSObject {}
-(id)objectAtIndex:(int)idx;
-(int)count;
-(BOOL)isEqualToArray:(NSArray*)array;
-(void)addObject:(id)obj;
-(id)firstObject;
-(NSMutableArray*)mutableCopy;
@end

@class NSIndexSet;
@interface NSMutableArray:NSArray {}
-(void)removeAllObjects;
-(void)removeObjectsAtIndexes:(NSIndexSet*)indexes;
@end

@interface NSNumber:NSObject {}
+(id)numberWithInt:(int)num;
+(id)numberWithLong:(long)num;
+(id)numberWithFloat:(float)num;
@end


@interface NSDictionary : NSObject {}
-(id)valueForKey:(NSString*)key;
-(NSArray*)allKeys;
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
-(NSString*)relativePath;
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

@class NSIndexSet;
@interface NSUserDefaults : NSObject {}
+(id) standardUserDefaults;
-(void)setObject:(id)o forKey:(NSString*)key;
-(void)setURL:(NSURL*)url forKey:(NSString*)key;
-(NSArray*)arrayForKey:(NSString*)key;
-(NSURL*)URLForKey:(NSString*)key;
-(void)synchronize;
-(void)setValue:(id)val forKey:(NSString*)key;
-(id)valueForKey:(NSString*)key;
-(void)removeObjectForKey:(NSString*)key;
-(void)removeObjectsAtIndexes:(NSIndexSet*)idxes;
-(NSDictionary*)dictionaryRepresentation;
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

@class NSOpenPanel;
@interface NSOpenPanel :NSObject {}
+(NSOpenPanel*)openPanel;
-(void)setCanChooseFiles:(BOOL)q;
-(void)setCanChooseDirectories:(BOOL)q;
-(void)setAllowsMultipleSelection:(BOOL)q;
-(void)setAccessoryViewDisclosed:(BOOL)q;
-(void)beginWithCompletionHandler:(id)handler;
@end 


@interface NSIndexSet: NSObject {}
-(int)count;
-(int)firstIndex;
-(id)objectForKey:(NSString*)key;
@end

@interface NSNotification: NSObject {}
-(id)object;
-(id)userInfo;
@end

@protocol NSToolbarDelegate
@end

@protocol NSTextViewDelegate
@end

@interface NSResponder: NSObject {}
-(BOOL)becomeFirstResponder;
@end

typedef int NSAutoresizingMaskOptions;
@interface NSView: NSResponder {}
-(NSRect)frame;
-(void)setFrame:(NSRect)frame;
-(NSArray*)subviews;
-(void)addSubview:(NSView*)view;
-(void)setAutoresizingMask:(NSAutoresizingMaskOptions)mask;
@end

@interface NSTableView: NSView {}
-(NSIndexSet*)selectedRowIndexes;
-(void)reloadData;
-(id)itemAtRow:(int)row;
@end

@interface NSOutlineView: NSView {}
-(NSIndexSet*)selectedRowIndexes;
-(void)reloadData;
-(id)itemAtRow:(int)row;
@end

@protocol NSSplitViewDelegate
@end

@interface NSSplitView: NSView {}
-(float)dividerThickness;
@end

@interface NSImageView: NSView {}
@end

@interface NSText: NSView {}
-(NSString*)string;
-(void)complete:(id)sender;
@end

@interface NSTextView: NSText {}
@end

@interface NSTableColumn: NSObject {}
-(NSString*)identifier;
@end

@interface NSWindow: NSObject {}
-(BOOL)isVisible;
@end

@class NSCell, NSImage;
@interface NSControl: NSView {}
-(void)setEnabled:(BOOL)enabled;
-(void)setState:(int)state;
-(void)setHasDestructiveAction:(BOOL)destructive;
-(void)setStringValue:(NSString*)string;
-(NSCell*)cell;
@end

@interface NSButton: NSControl {}
@end

@interface NSTextField: NSControl {}
-(void)setContentType:(NSString*)type;
-(NSText*)currentEditor;
@end

@interface NSSearchField : NSTextField {}
@end


@class NSWorkspace;
@interface NSWorkspace: NSObject {}
+(NSWorkspace*)sharedWorkspace;
-(void)openURL:(NSURL*)url;
@end

@class NSImage;
@interface NSImage: NSObject {}
+(NSImage*)imageNamed:(NSString*)name;
+(NSImage*)imageWithSystemSymbolName:(NSString*)name accessibilityDescription:(NSString*)description;
-(NSImage*)initByReferencingFile:(NSString*)filename;
@end
 
@class NSURLRequest;
@interface NSURLRequest: NSObject {}
+(NSURLRequest*)requestWithURL:(NSURL*)url;
@end

@class NSToolbar;
@interface NSToolbarItem : NSObject {}
-(NSToolbar*)toolbar;
-(NSControl*)view;
@end

@interface NSToolbar: NSView {}
-(void)setSelectedItemIdentifier:(id)item;
@end
 
@protocol NSWindowDelegate
@end

@interface NSCell: NSObject {}
-(void)setImage:(NSImage*)image;
@end

@interface NSLevelIndicatorCell: NSCell {}
@end

@interface NSSearchFieldCell: NSCell {}
-(NSCell*)searchButtonCell;
@end

@interface NSApplication: NSObject {}
@end

@protocol NSApplicationDelegate
@end
