
#import <Cocoa/Cocoa.h>

#import "CoreLogic.h"
#import "AppProvidedServices.h"

extern NSString *preference_autocomplete_copied_sites;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet CoreLogic* _logic;
    IBOutlet AppProvidedServices* _aps;
}
-(CoreLogic*)logic;
@end
