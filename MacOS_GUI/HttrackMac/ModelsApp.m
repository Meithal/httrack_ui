//
//  ModelsApp.m
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//

#import <Foundation/Foundation.h>

#import "htscore.h"

#import "ModelsApp.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MyDowloadableFile
+ (nonnull instancetype)createFromString:(nonnull NSString *)name atPath:(nonnull NSString *)path createdAt:(NSDate*)date{
    MyDowloadableFile * me =[[MyDowloadableFile alloc] init];
    me->_name = [name copy];
    me->_hd_path = [path copy];
    me->_dateCreated = [date retain];
    
    me->_downloadAdvancement = -1;
    return [me autorelease];
}
-(void) dealloc {
    [_name release];
    [_hd_path release];
    [_dateCreated release];
    
    [super dealloc];
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
- (NSString *)hd_path {
    return _hd_path;
}
- (NSString *)name {
    return _name;
}
- (NSDate *)dateCreated {
    return _dateCreated;
}
@end

@implementation MyDirectoryElements
+(instancetype) createFromString:(NSString *) name atDepth:(int)depth {
    MyDirectoryElements * me =[[MyDirectoryElements alloc] init];
    me->_name = [name copy];
    me->_directories = [[NSMutableArray alloc] init];
    me->_files = [[NSMutableArray alloc] init];
    me->_depth = depth;
    return me;
}
-(void)dealloc {
    [_name dealloc];
    [_files dealloc];
    [_directories dealloc];
    
    [super dealloc];
}
/// Helpers
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
/// Getters
-(const NSString*) name {
    return _name;
}
-(const NSMutableArray<MyDirectoryElements *> *) directories {
    return _directories;
}
-(const NSMutableArray<MyDowloadableFile *> *) files {
    return _files;
}
-(const int)depth {
    return _depth;
}
/// Utilities
- (int) numberOfChildren
{
    int count = 0;
    
    count += self.files.count;
    for(int i=0; i<self.directories.count; i++)
        count += [[self.directories objectAtIndex:i] numberOfChildren];
    
    return count;
}
- (int) numberOfCompleted
{
    int count = 0;
    
    for (int i = 0, ct = (int)self.files.count; i <ct; i++) {
        if([self.files objectAtIndex:i] .avancement >= 1)
            count ++;
    }
    for(int i=0; i<self.directories.count; i++)
        count += [[self.directories objectAtIndex:i] numberOfCompleted];
    
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
- (void)updateBacking:(nonnull lien_back *)liens total:(int)tot {
    if([_backing count] != tot) {
        [_backing removeAllObjects];
        for(int i=0; i<tot; i++) {
            MyBackingBridge * b = [[MyBackingBridge alloc] init];
            [_backing addObject:b];
            [b release];
        }
    }
    
    for(int i = 0; i<tot; i++) {
        MyBackingBridge* b = [_backing objectAtIndex:i];
        [b->remote release];
        [b->referer release];
        [b->local release];
        [b->status release];
        [b->progression release];
        b->remote = [[NSString stringWithFormat:@"%@%@", @(liens[i].url_adr), @(liens[i].url_fil)] copy];
        b->referer = [[NSString stringWithFormat:@"%s%s", liens[i].referer_adr, liens[i].referer_fil] copy];
        b->local = [[NSString stringWithFormat:@"%s", liens[i].url_sav] copy];
        b->status = [[NSNumber numberWithInt:liens[i].r.statuscode] copy];
        b->progression = [[NSNumber numberWithFloat: liens[i].r.totalsize ? (float)liens[i].r.size / liens[i].r.totalsize : 0] copy];
        b->totalsize = [[NSNumber numberWithLong: liens[i].r.totalsize] copy];
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
+ (nonnull MyDowloadableFile*)addFile:(nonnull NSString *)file toArborescence:(nonnull MyDirectoryElements *)arbo sittingAtCompletePath:(NSString*)path createdAt:(NSDate*)date{
    MyDowloadableFile*f =[MyDowloadableFile createFromString:file atPath:path createdAt:date];
    [arbo.files addObject:f];
    
    return f;
}
+ (nonnull MyDirectoryElements *)addDirectory:(nonnull NSString *)dirname toArborescene:(nonnull MyDirectoryElements *)arbo {
    MyDirectoryElements *n =[MyDirectoryElements createFromString:dirname atDepth:arbo.depth + 1];
    [arbo.directories addObject:n];
    return n;
}
+(MyDowloadableFile*)addPathComponents:(NSArray<NSString*>*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path createdAt:(NSDate*)date
{
    MyDirectoryElements * orig = arbo;
    for(int i = 0; i < comps.count - 1; i++) {
        NSString*s = [comps objectAtIndex:i];
        for(int j =0; j < arbo.directories.count; j++) {
            if([[arbo.directories objectAtIndex:j].name isEqualToString:s]) {
                arbo = [arbo.directories objectAtIndex:j];
                goto directory_found;
            }
        }
        /// directory not found, we must create it
        arbo = [ModelsApp addDirectory:s toArborescene:arbo];
        directory_found:;
    }
    MyDowloadableFile* f;
    for(int i = 0; i < arbo.files.count ; i++) {
        if([[arbo.files objectAtIndex:i].name isEqualToString:[comps objectAtIndex:comps.count - 1]]) {
            f = [arbo.files objectAtIndex:i];
            goto file_found;
        }
    }
    /// file not found, we must create it
    f = [ModelsApp addFile:[comps objectAtIndex:comps.count - 1] toArborescence:arbo sittingAtCompletePath:complete_path createdAt:date];
    
    file_found:;
    
    return f;
}
@end

NS_ASSUME_NONNULL_END
