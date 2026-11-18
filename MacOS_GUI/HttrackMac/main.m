#include <pthread/pthread.h>

#import <Cocoa/Cocoa.h>

#import <AppKit/NSApplication.h>

// detecteur de sigpipe qui evite de faire crasher l'application
// arrive quand le hote n'existe pas du tout
void sig_rec(int code) {
    switch (code) {
        case SIGPIPE:
            fprintf(stderr, "httrmac: ecriture sur socket fermé, enqueter... (%d)\n", code);
            break;
            
        default:
            break;
    }
    return;
}

int main(int argc, const char * argv[]) {
    void (*s)(int);
    s = signal(SIGPIPE, sig_rec), assert(s!=SIG_ERR);
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
    }
    
    printf("api min %d, api max %d\n", __MAC_OS_X_VERSION_MIN_REQUIRED, __MAC_OS_X_VERSION_MAX_ALLOWED);
    printf("is mutithreaded %d\n", [NSThread isMultiThreaded]);
    //printf("has secure extesions %d\n", __STDC_LIB_EXT1__);
    
    //NSLog(@"GC %@\n", [NSGarbageCollector defaultCollector]);
    //NSLog(@"%@", NSAppKitVersionNumber);
    //[NSImage imageUnfilteredFileTypes];
    //NSBeep();

    return NSApplicationMain(argc, argv);
}
