//
//  ModelsApp.h
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//

#if defined(__GNUC__) && ((__GNUC__ >= 4) || ((__GNUC__ == 3) && (__GNUC_MINOR__ >= 1))) && !defined(RETRO_CHECK)
# define HAS_UNAVAILABLE_ATTRIBUTE
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol YTPavancement
-(float)avancement; /// a ratio between 0 and 1 on how much it is completed
@end

@interface MyDowloadableFile : NSObject <YTPavancement> {
    NSString * _name; // without path component
    NSDate * _dateCreated;
    NSString * _hd_path; // complete absolute path
    
    int _tailleComplete;
    float _downloadAdvancement; /** 0.0 - 1.0 */
}
+(instancetype) createFromString:(NSString *)name atPath:(NSString*)path createdAt:(NSDate*)date;
/// Getters
-(NSString *) name; // without path component
-(NSDate *) dateCreated;
-(NSString *) hd_path; // complete absolute path
- (BOOL)updateAdvancement:(float)ratio;
@end

@interface MyDirectoryElements : NSObject <YTPavancement> {
    const NSString* _name;
    const TYPED_CONTAINER(NSMutableArray,MyDirectoryElements *) * _directories;
    const TYPED_CONTAINER(NSMutableArray,MyDowloadableFile *) * _files;
    int _depth;
}
#if defined(HAS_UNAVAILABLE_ATTRIBUTE)
+(instancetype)alloc UNAVAILABLE_ATTRIBUTE;
#endif
+(instancetype) createFromString:(NSString*)name atDepth:(int)depth;
/// getters
-(const NSString*) name;
-(const TYPED_CONTAINER(NSMutableArray,MyDirectoryElements *) *) directories;
-(const TYPED_CONTAINER(NSMutableArray,MyDowloadableFile *) *) files;
-(int) depth;
/// utils
- (NSString *) debugDescription;
- (int) numberOfChildren;
- (float) completionAdvancement;
@end

@interface MyLinkBidge: NSObject {
    @public
    NSString* remoteUrl;
    NSString* status;
    NSNumber* previous;
    NSNumber* passe;
    NSNumber* depth;
    NSNumber* retires;
};
@end

@interface MyLiens : NSObject {
    TYPED_CONTAINER(NSMutableArray,MyLinkBidge*)* _liensBridge;
}
-(void)updateLiens:(lien_url*)liens total:(int)tot;  /// TODO: on ne devrait pas avoir a connaitre les details de la couche inferieure ici
-(int)count;
//-(TYPED_CONTAINER(NSArray, MyLinkBidge*)*)liens;
-(MyLinkBidge*)lienAt:(NSUInteger)at;
@end

@interface MyBackingBridge: NSObject {
    @public
    NSString* remote;
    NSString* referer;
    NSString* local;
    int status;
    float progression;
    float totalsize;
}
@end

@interface MyBacking : NSObject {
    TYPED_CONTAINER(NSMutableArray, MyBackingBridge*)* _backing;
}
-(int)updateOneBacking:(lien_back*)lien;
-(void)updateBacking:(lien_back*)backing total:(int)tot;
-(NSUInteger)count;
-(MyBackingBridge*)backAt:(NSUInteger)idx;
@end

@interface ModelsApp : NSObject
+(MyDirectoryElements *)addDirectory:(NSString *)dirname toArborescene:(MyDirectoryElements *)arbo;
+(MyDowloadableFile *)addFile:(NSString*) file toArborescence:(MyDirectoryElements *)arbo sittingAtCompletePath:(NSString*) path createdAt:(NSDate*)date;
/// ajoute une hierarchie de dossiers+fichier, en creant les dossiers intermediaires, cree le fichier ou le retourne
+(MyDowloadableFile *)addPathComponents:(TYPED_CONTAINER(NSArray,NSString*)*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path createdAt:(NSDate*)date;;
@end

NS_ASSUME_NONNULL_END
