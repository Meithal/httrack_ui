//
//  ModelsApp.h
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YTPavancement
-(float)avancement; /// a ratio between 0 and 1 on how much it is completed
@end

@interface MyDowloadableFile : NSObject <YTPavancement> {
    @public
    float _downloadAdvancement; /** 0.0 - 1.0 */
}
@property (copy) NSString * name; // without path component
@property (assign) NSDate * dateCreated;
@property (copy) NSString * hd_path; // complete absolute path
+(instancetype) createFromString:(NSString *) name atPath:(NSString*) path;
@end

@interface MyDirectoryElements : NSObject <YTPavancement>
@property (copy) NSString* name;
@property (strong, atomic) NSMutableArray<MyDirectoryElements *> * directories;
@property (strong, atomic) NSMutableArray<MyDowloadableFile *> * files;
@property NSInteger depth;

- (NSString *) debugDescription;
+(instancetype) createFromString:(NSString*) name;
-(BOOL) updateAdvancement:(MyDowloadableFile*)file ratio:(float)ratio;
@end

@interface ModelsApp : NSObject
+(MyDirectoryElements *)allocArborescence;
+(MyDirectoryElements *)addDirectory:(NSString *)dirname toArborescene:(MyDirectoryElements *)arbo;
+(MyDowloadableFile *)addFile:(NSString*) file toArborescence:(MyDirectoryElements *)arbo sittingAtCompletePath:(NSString*) path;
/// ajoute une hierarchie de dossiers+fichier, en creant les dossiers intermediaires, cree le fichier ou le retourne
+(MyDowloadableFile *)addPathComponents:(NSArray<NSString*>*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path;
@end

NS_ASSUME_NONNULL_END
