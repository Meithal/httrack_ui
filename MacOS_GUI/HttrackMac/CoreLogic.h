//
//  CoreLogic.h
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//


NS_ASSUME_NONNULL_BEGIN

extern NSString *PREFERENCE_autocomplete_copied_sites;
extern NSString *PREFERENCE_default_save_folder;
extern NSString *PREFERENCE_app_style;

void sanitize_save_folder_user_settings(void);

@interface NSString (NSStringEndsWith)
-(BOOL)endsWithString:(NSString*)string;
@end

@class CoreLogic;

@protocol CoreLogicDelegate<NSObject>
-(void)coreLogicDownloadWillStart:(CoreLogic*)sender;
-(void)coreLogicDownloadDidStop:(CoreLogic*)sender;
-(void)coreLogicDownloadDidPause:(CoreLogic*)sender;
-(void)coreLogicPageAdded:(CoreLogic*)sender;
-(void)coreLogicUpdateLinks:(CoreLogic *)sender links:(lien_back*)liens total:(int)tot;
@end

/** The core business logic of the app */
@interface CoreLogic : NSObject {
    httrackp *_httrack_opt;
    NSObject<CoreLogicDelegate> * _delegate;
    id _objCallback;
    SEL _loopCallback;
    enum CoreLogicState {CORELOGIC_STATE_STOPPED,CORELOGIC_STATE_RUNNING, CORELOGIC_STATE_PAUSED} _state;
    MyDirectoryElements * _websites;
    enum CoreLogicLogLevel{CORELOGIC_LOG_NONE, CORELOGIC_LOG_ERROR, CORELOGIC_LOC_DEBUG} _log_level;
    MyLiens* _my_liens;
    MyBacking* _my_backing;
}
-(MyDirectoryElements *) websites;
-(void)dowloadSite:(NSString*) url onError:(void (^)(NSString *, NSErrorDomain, NSInteger)) onError;
-(TYPED_CONTAINER(NSArray,NSString*)*)sitesOnHardDrive;
-(void)indexOfDownloadedSites:(MyDirectoryElements *) arbo;
-(void)setDelegate:(nullable NSObject<CoreLogicDelegate>*)newDelegate;
-(NSObject<CoreLogicDelegate>*)delegate;
-(void)setLoopCallback:(nullable SEL) callback withObject: (nullable id) obj;
-(SEL)loopCallback;
-(id)objCallback;
-(nullable httrackp*)httrack_opt;
-(void)pauseMirror:(int)p;
-(void)stopMirror;
-(enum CoreLogicState) state;
-(void)setState:(enum CoreLogicState)state;
-(enum CoreLogicLogLevel) logLevel;
-(void)setLogLevel:(enum CoreLogicLogLevel)logLevel;
-(MyLiens*)myLiens;
-(MyBacking*)myBacking;
-(void)setDefaultAutocomplete;
@end



NS_ASSUME_NONNULL_END
