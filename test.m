#include <objc/objc.h>
#include <objc/runtime.h>
// #include <stdio.h>
#include <Foundation/Foundation.h>
// #include <AppKit/AppKit.h>

@interface chien: NSObject
-(void)aboye;
@end
@implementation chien
-(void)aboye {
    printf("ouaf (chien)");
}
@end

@interface loup: NSObject
-(void)aboye;
@end
@implementation loup
-(void)aboye {
    printf("ouaf (loup)");
} 
@end

@interface chat: NSObject
@end
@implementation chat
@end

void miaule(void)
{
    printf("miaou");
}

int main()
{
    id t = [chien alloc];
    printf("%s \n", object_getClassName(t));

    NSLog(@"version class %ld\n", [chien version]);

    id chi = class_createInstance([chien class], 0);
    chi = [chi init];
    [t aboye];
    [chi aboye];

    SEL sel = sel_registerName("aboye");
    printf("%s \n", sel_getName(sel));
    loup * lo = [loup alloc];
    chat * ch = [chat alloc];
    NSArray* arr = @[chi, lo, ch];
    for(int i = 0; i < [arr count]; i++) {
        printf("%s: ", object_getClassName(arr[i]));
        if([arr[i] respondsToSelector:sel]) {
            [arr[i] performSelector:sel];
        }
        puts("");
    }
    class_addMethod([chat class], sel, miaule, "vv");

    puts("take2");
    for(int i = 0; i < [arr count]; i++) {
        printf("%s: ", object_getClassName(arr[i]));
        if([arr[i] respondsToSelector:sel]) {
            [arr[i] performSelector:sel];
        }
        puts("");
    }

    NSLog(@"%@\n%lu\n%lu\n", [arr description], [arr retainCount], [ch retainCount]);
    [arr release];
    NSLog(@"retain %lu\n", [ch retainCount]);
}
