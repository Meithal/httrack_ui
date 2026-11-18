//
//  ModelsApp.h
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//

NS_ASSUME_NONNULL_BEGIN

@protocol YTPavancement
-(float)avancement; /// a ratio between 0 and 1 on how much it is completed
@end

@interface MyDowloadableFile : NSObject <YTPavancement> {
    NSString * _name; // without path component
    NSDate * _dateCreated;
    NSString * _hd_path; // complete absolute path
    
    @public
    float _downloadAdvancement; /** 0.0 - 1.0 */
}
//@property (copy) NSString * name; // without path component
//@property (assign) NSDate * dateCreated;
//@property (copy) NSString * hd_path; // complete absolute path
+(instancetype) createFromString:(NSString *)name atPath:(NSString*)path createdAt:(NSDate*)date;
/// Getters
-(NSString *) name; // without path component
-(NSDate *) dateCreated;
-(NSString *) hd_path; // complete absolute path
@end

@interface MyDirectoryElements : NSObject <YTPavancement> {
    const NSString* _name;
    const NSMutableArray<MyDirectoryElements *> * _directories;
    const NSMutableArray<MyDowloadableFile *> * _files;
    int _depth;
}
//@property (copy) NSString* name;
//@property (strong, atomic) NSMutableArray<MyDirectoryElements *> * directories;
//@property (strong, atomic) NSMutableArray<MyDowloadableFile *> * files;
//@property NSInteger depth;
+(instancetype)alloc UNAVAILABLE_ATTRIBUTE;
+(instancetype) createFromString:(NSString*)name atDepth:(int)depth;
/// getters
-(const NSString*) name;
-(const NSMutableArray<MyDirectoryElements *> *) directories;
-(const NSMutableArray<MyDowloadableFile *> *) files;
-(int) depth;
/// utils
- (NSString *) debugDescription;
- (int) numberOfChildren;
- (int) numberOfCompleted;
-(BOOL) updateAdvancement:(MyDowloadableFile*)file ratio:(float)ratio;
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
    NSMutableArray<MyLinkBidge*>* _liensBridge;
}
-(void)updateLiens:(lien_url*)liens total:(int)tot;  /// TODO: on ne devrait pas avoir a connaitre les details de la couche inferieure ici
-(int)count;
-(NSArray<MyLinkBidge*>*)liens;
@end

@interface MyBackingBridge: NSObject {
    @public
    NSString* remote;
    NSString* referer;
    NSString* local;
    NSNumber* status;
    NSNumber* progression;
    NSNumber* totalsize;
}
@end

@interface MyBacking : NSObject {
    NSMutableArray<MyBackingBridge*>* _backing;
}
-(void)updateBacking:(lien_back*)backing total:(int)tot;
-(int)count;
-(NSArray<MyBackingBridge*>*)backing;
@end

@interface ModelsApp : NSObject
+(MyDirectoryElements *)addDirectory:(NSString *)dirname toArborescene:(MyDirectoryElements *)arbo;
+(MyDowloadableFile *)addFile:(NSString*) file toArborescence:(MyDirectoryElements *)arbo sittingAtCompletePath:(NSString*) path createdAt:(NSDate*)date;
/// ajoute une hierarchie de dossiers+fichier, en creant les dossiers intermediaires, cree le fichier ou le retourne
+(MyDowloadableFile *)addPathComponents:(NSArray<NSString*>*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path createdAt:(NSDate*)date;;
@end

NS_ASSUME_NONNULL_END
