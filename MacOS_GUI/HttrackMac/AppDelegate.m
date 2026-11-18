//#import <Availability.h>
#if defined(__clang__) /** vérifie XCode 8 */
#define HAS_XCODE8
#else
#define ON_GCC
#endif

#if defined(HAS_XCODE8)
#import <os/log.h>
#endif

#if !defined(ON_GCC)
#import <AppKit/AppKit.h>
#else
#error ???
#endif

#import "AppDelegate.h"

@interface AppDelegate () {
    IBOutlet NSView *_AppIcon;
    IBOutlet NSWindow *_window;
}

@end

@implementation AppDelegate
-(NSView *)AppIcon {
    return _AppIcon;
}
-(NSWindow *)window {
    return _window;
}
// MARK: - Overrides
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //[NSApp setPresentationOptions:NSApplicationPresentationDisableAppleMenu];
    //NSLog(@"%@", [NSConnection allConnections]);
    //NSLog(@"%@", [NSConnection defaultConnection]);
    // NSLog(@"tile size= %@", NSStringFromSize( _window.dockTile.size));
    NSView* w = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 128, 128)];
    self.AppIcon.wantsLayer = YES;
    self.AppIcon.layer.backgroundColor = NSColor.greenColor.CGColor;
    self.window.dockTile.contentView = _AppIcon;
    [self.window.dockTile.contentView addSubview:w];
    self.window.dockTile.badgeLabel = @"toto";
    [self.window.dockTile setShowsApplicationBadge:YES];
    [self.window.dockTile display];
    //_window.toolbarStyle = NSWindowToolbarStyleUnified;//
    
    
    if(0) {
#if defined(HAS_XCODE8)
        os_log_t log = os_log_create("com.meithal.httpack", "service");
        
        os_log(log, "here toto delegate\n");
        os_log_info(log, "here toto info delegate\n");
        os_log_debug(log, "here toto debug delegate\n");
#endif
    }
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}
@end
