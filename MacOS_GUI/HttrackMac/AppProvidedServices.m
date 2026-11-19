//
//  AppProvidedServices.m
//  Httpack
//
//  Created by ivo on 24/09/2026.
//

#import <os/log.h>

#if defined(__clang__)
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#endif

#include "htscore.h"

#import "retro_comp.h"
#import "ModelsApp.h"
#import "CoreLogic.h"
#import "ControllerMainMenu.h"

#import "AppProvidedServices.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AppProvidedServices
-(void)awakeFromNib {
    /// Enregistre notre app comme service global dans le systeme
    [NSApp setServicesProvider:self];
    NSUpdateDynamicServices();
}
-(void)downloadWebsite:(NSPasteboard*)pb userData:(NSString*)userdata error:(NSString**)onError {
    
    [_cmm.httrSiteUrl setStringValue:[pb stringForType:NSStringPboardType]];
}
@end

NS_ASSUME_NONNULL_END
