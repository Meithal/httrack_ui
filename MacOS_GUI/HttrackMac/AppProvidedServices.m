//
//  AppProvidedServices.m
//  Httpack
//
//  Created by ivo on 24/09/2026.
//

#import "AppProvidedServices.h"
#import <os/log.h>

NS_ASSUME_NONNULL_BEGIN

@implementation AppProvidedServices
-(void)downloadWebsite:(NSPasteboard*)pb userData:(NSString*)userdata error:(NSString**)onError {
    
    [_cmm.httrSiteUrl setStringValue:[pb stringForType:NSStringPboardType]];
}
@end

NS_ASSUME_NONNULL_END
