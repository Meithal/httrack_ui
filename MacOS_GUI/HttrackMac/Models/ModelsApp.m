//
//  ModelsApp.m
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//

#import "ModelsApp.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MyDowloadableFile
+ (nonnull instancetype)createFromString:(nonnull NSString *)name
atPath:(nonnull NSString *)path {
    MyDowloadableFile * me =[[MyDowloadableFile alloc] init];
    me.name = name;
    me.hd_path = path;
    me->_downloadAdvancement = -1;
    return [me autorelease];
}
-(float)avancement {
    // si progression en direct
    if(_downloadAdvancement != -1)
        return _downloadAdvancement ;
    
    // si deja existant
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.hd_path])
        _downloadAdvancement = 1;
    
    return _downloadAdvancement;
}
@end

@implementation MyDirectoryElements
- (NSString *) debugDescription {
    return [
        NSString stringWithFormat:@"%@, %@ (%d elements)",
        [super debugDescription],
        [self name],
        (int)(self.directories.count + self.files.count)
    ];
}
- (NSString *) description {
    return [self debugDescription];
}
+(instancetype) createFromString:(NSString *) name {
    MyDirectoryElements * me =[[MyDirectoryElements alloc] init];
    me.name = name;
    me.directories = [[NSMutableArray alloc] init];
    me.files = [[NSMutableArray alloc] init];
    return [me autorelease];
}
- (int) numberOfChildren
{
    int count = 0;
    
    count += self.files.count;
    for(int i=0; i<self.directories.count; i++)
        count += [self.directories[i] numberOfChildren];
    
    return count;
}
- (int) numberOfCompleted
{
    int count = 0;
    
    for (int i = 0, ct = (int)self.files.count; i <ct; i++) {
        if(self.files[i].avancement >= 1)
            count ++;
    }
    for(int i=0; i<self.directories.count; i++)
        count += [self.directories[i] numberOfCompleted];
    
    return count;
}
-(float)avancement {
    int total = self.numberOfChildren;
    int completedFiles = self.numberOfCompleted;
    return (float)completedFiles / total;
}
- (BOOL)updateAdvancement:(nonnull MyDowloadableFile*)file ratio:(float)ratio {
    //NSLog(@"me: %@ path: %@ site: %@ ratio: %.2f\n", _name, path, site, ratio);
    float old = file->_downloadAdvancement;
    file->_downloadAdvancement = ratio;
    return old != ratio;
}
@end

@implementation MyLinkBidge
@end
@implementation MyLiens
- (instancetype)init
{
    self = [super init];
    if (self) {
        _liensBridge = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)dealloc {
    [_liensBridge dealloc];
    
    [super dealloc];
}
- (void)updateLiens:(lien_url*)liens total:(int)tot {
    int diff = tot - (int)[_liensBridge count];
    for(int i = 0; i < diff ; i++) {
        MyLinkBidge* mlb = [[MyLinkBidge alloc] init];
        mlb->remoteUrl = [[NSString stringWithFormat:@"%@%@", @(liens[_liensBridge.count].adr), @(liens[_liensBridge.count].fil)] copy];
        mlb->status = [[NSString stringWithFormat:@"%@%@", @(liens[_liensBridge.count].former_adr), @(liens[_liensBridge.count].former_fil)] copy];
        mlb->previous = [NSNumber numberWithInt:liens[_liensBridge.count].precedent];
        mlb->passe = [NSNumber numberWithInt:liens[_liensBridge.count].pass2];
        mlb->depth = [NSNumber numberWithInt:liens[_liensBridge.count].depth];
        mlb->retires = [NSNumber numberWithInt:liens[_liensBridge.count].retry];
        [_liensBridge addObject:mlb];
        [mlb release];
    }
    
}
-(int)count {
    return (int)[_liensBridge count];
}
-(NSArray<MyLinkBidge*>*)liens {
    return _liensBridge;
}
@end

@implementation MyBackingBridge
@end
@implementation MyBacking
- (instancetype)init
{
    self = [super init];
    if (self) {
        _backing = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)dealloc {
    [_backing release];
    
    [super dealloc];
}
- (void)updateBacking:(nonnull lien_back *)backing total:(int)tot {
    if([_backing count] != tot) {
        [_backing removeAllObjects];
        for(int i=0; i<tot; i++) {
            MyBackingBridge * b = [[MyBackingBridge alloc] init];
            [_backing addObject:b];
            [b release];
        }
    }
    for(int i = 0; i<tot; i++) {
        [_backing[i]->remote release];
        [_backing[i]->referer release];
        [_backing[i]->local release];
        [_backing[i]->status release];
        [_backing[i]->progression release];
        _backing[i]->remote = [[NSString stringWithFormat:@"%@%@", @(backing[i].url_adr), @(backing[i].url_fil)] copy];
        _backing[i]->referer = [[NSString stringWithFormat:@"%s%s", backing[i].referer_adr, backing[i].referer_fil] copy];
        _backing[i]->local = [[NSString stringWithFormat:@"%s", backing[i].url_sav] copy];
        _backing[i]->status = [[NSNumber numberWithInt:backing[i].r.statuscode] copy];
        _backing[i]->progression = [[NSNumber numberWithFloat: backing[i].r.totalsize ? (float)backing[i].r.size / backing[i].r.totalsize : 0] copy];
    }
}
-(int)count {
    return (int)[_backing count];
}
-(NSArray<MyBackingBridge*>*)backing {
    return _backing;
}
@end

@implementation ModelsApp
+(MyDirectoryElements *)allocArborescence
{
    MyDirectoryElements * dir = [[MyDirectoryElements alloc] init];
    dir.depth = 0;
    return dir;
}
+ (nonnull MyDowloadableFile*)addFile:(nonnull NSString *)file toArborescence:(nonnull MyDirectoryElements *)arbo sittingAtCompletePath:(NSString*) path {
    MyDowloadableFile*f =[MyDowloadableFile createFromString:file atPath:path];
    [arbo.files addObject:f];
    
    return f;
}
+ (nonnull MyDirectoryElements *)addDirectory:(nonnull NSString *)dirname toArborescene:(nonnull MyDirectoryElements *)arbo {
    MyDirectoryElements *n =[MyDirectoryElements createFromString:dirname];
    n.depth = arbo.depth + 1;
    [arbo.directories addObject:n];
    return n;
}
+(MyDowloadableFile*)addPathComponents:(NSArray<NSString*>*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path
{
    MyDirectoryElements * orig = arbo;
    for(int i = 0; i < comps.count - 1; i++) {
        NSString*s = comps[i];
        for(int i =0; i < arbo.directories.count; i++) {
            if([arbo.directories[i].name isEqualToString:s]) {
                arbo = arbo.directories[i];
                goto directory_found;
            }
        }
        /// directory not found, we must create it
        arbo = [ModelsApp addDirectory:s toArborescene:arbo];
        directory_found:;
    }
    MyDowloadableFile* f;
    for(int i = 0; i < arbo.files.count ; i++) {
        if([arbo.files[i].name isEqualToString:comps[comps.count - 1]]) {
            f = arbo.files[i];
            goto file_found;
        }
    }
    f = [ModelsApp addFile:comps[comps.count - 1] toArborescence:arbo sittingAtCompletePath:complete_path];
    /// file not found, we must create it
    file_found:;
    
    return f;
}
@end

NS_ASSUME_NONNULL_END
