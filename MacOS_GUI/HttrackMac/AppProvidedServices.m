//
//  AppProvidedServices.m
//  Httpack
//
//  Created by ivo on 24/09/2026.
//

#import <os/log.h>

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

#include "htscore.h"

#import "ModelsApp.h"
#import "CoreLogic.h"
#import "ControllerMainMenu.h"

#import "AppProvidedServices.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AppProvidedServices
-(void)downloadWebsite:(NSPasteboard*)pb userData:(NSString*)userdata error:(NSString**)onError {
    
    [_cmm.httrSiteUrl setStringValue:[pb stringForType:NSStringPboardType]];
}
@end

NS_ASSUME_NONNULL_END
