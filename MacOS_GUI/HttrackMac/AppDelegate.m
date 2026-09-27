//#import <Availability.h>
#import <os/log.h>

#import "AppDelegate.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSView *AppIcon;
@property (strong) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

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
    
    sanitize_save_folder_user_settings();
    [[self logic] setDefaultAutocomplete];
    
    [NSApp setServicesProvider:_aps];
    NSUpdateDynamicServices();
    
    if(0) {
        os_log_t log = os_log_create("com.meithal.httpack", "service");
        
        os_log(log, "here toto delegate\n");
        os_log_info(log, "here toto info delegate\n");
        os_log_debug(log, "here toto debug delegate\n");
    }
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [_logic gracefulTerminate];
}
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}
// MARK: - Our functions
-(CoreLogic*)logic {
    return _logic;
}
@end
