#include <pthread/pthread.h>

#import <Cocoa/Cocoa.h>

#import <AppKit/NSApplication.h>

// detecteur de sigpipe qui evite de faire crasher l'application
// arrive quand le hote n'existe pas du tout
void sig_rec(int code) {
    return;
}

int main(int argc, const char * argv[]) {
    
    signal(SIGPIPE, sig_rec);
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }
    
    printf("api min %d, api max %d\n", __MAC_OS_X_VERSION_MAX_ALLOWED,
           __MAC_OS_X_VERSION_MIN_REQUIRED);
    printf("is mutithreaded %d\n", [NSThread isMultiThreaded]);
    
    //NSLog(@"GC %@\n", [NSGarbageCollector defaultCollector]);
    //NSLog(@"%@", NSAppKitVersionNumber);
    //[NSImage imageUnfilteredFileTypes];
    //NSBeep();

    return NSApplicationMain(argc, argv);
}
