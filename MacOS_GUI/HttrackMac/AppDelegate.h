@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet CoreLogic* _logic;
    IBOutlet AppProvidedServices* _aps;
}
-(CoreLogic*)logic;
@end
