
#import <Cocoa/Cocoa.h>

#import "CoreLogic.h"
#import "AppProvidedServices.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet CoreLogic* _logic;
    IBOutlet AppProvidedServices* _aps;
}
-(CoreLogic*)logic;
@end
