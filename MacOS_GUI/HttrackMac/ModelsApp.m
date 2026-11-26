//
//  ModelsApp.m
//  HttrackMac
//
//  Created by ivo on 13/02/2026.
//
#if defined(__clang__) /** we are using gcc only to check retrocomp, do not fill the error log with system headers incompatibilities */
#include <Foundation/Foundation.h>

#endif

#include "htscore.h"

#import "retro_comp.h"
#include "ModelsApp.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MyDowloadableFile
+ (instancetype)createFromString:(NSString *)name atPath:(NSString *)path createdAt:(NSDate*)date{
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
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self hd_path]])
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
- (BOOL)updateAdvancement:(float)ratio {
    //NSLog(@"me: %@ path: %@ site: %@ ratio: %.2f\n", _name, path, site, ratio);
    float old = _downloadAdvancement;
    _downloadAdvancement = ratio;
    return old != ratio;
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
        (int)([self.directories count] + [self.files count])
    ];
}
- (NSString *) description {
    return [self debugDescription];
}
/// Getters
-(const NSString*) name {
    return _name;
}
-(const TYPED_CONTAINER(NSMutableArray, MyDirectoryElements *) *) directories {
    return _directories;
}
-(const TYPED_CONTAINER(NSMutableArray, MyDowloadableFile *) *) files {
    return _files;
}
-(const int)depth {
    return _depth;
}
/// Utilities
- (int) numberOfChildren
{
    int count = 0, i;
    
    count += [[self files] count];
    for(i = 0; i<[[self directories] count]; i++)
        count += [[[self directories] objectAtIndex:i] numberOfChildren];
    
    return count;
}
- (float) completionAdvancement
{
    float completion = 0;
    NSUInteger i, ct;
    
    for (i = 0, ct = [[self files] count]; i < ct; i++) {
        completion += [[[self files] objectAtIndex:i] avancement];
    }
    for(i = 0; i<[[self directories] count]; i++)
        completion += [[[self directories] objectAtIndex:i] completionAdvancement];
    
    return completion;
}
-(float)avancement {
    float completedFiles = [self completionAdvancement];
    int total = [self numberOfChildren];
    if(total <= 0)
        return 1.0;
    return (float)completedFiles / total;
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
    int i;
    for(i = 0; i < diff ; i++) {
        MyLinkBidge* mlb = [[MyLinkBidge alloc] init];
        NSUInteger last = [_liensBridge count];
        
        mlb->remoteUrl = [[NSString stringWithFormat:@"%s%s", liens[last].adr, liens[last].fil] copy];
        mlb->status = [[NSString stringWithFormat:@"%s%s", liens[last].former_adr, liens[last].former_fil] copy];
        mlb->previous = [NSNumber numberWithInt:liens[last].precedent];
        mlb->passe = [NSNumber numberWithInt:liens[last].pass2];
        mlb->depth = [NSNumber numberWithInt:liens[last].depth];
        mlb->retires = [NSNumber numberWithInt:liens[last].retry];
        
        [_liensBridge addObject:mlb];

        [mlb release];
    }
    
}
-(int)count {
    return (int)[_liensBridge count];
}
//-(TYPED_CONTAINER(NSArray,MyLinkBidge*)*)liens {
//    return _liensBridge;
//}
-(MyLinkBidge*)lienAt:(NSUInteger)at {
    return [_liensBridge objectAtIndex:at];
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

-(int)updateOneBacking:(lien_back*)lien {
    NSString*local = [NSString stringWithFormat:@"%s", lien->url_sav];
    BOOL found;
    //todo: make it a hash
    for(NSUInteger i, ct = [_backing count]; i < ct; i++) {
        if([_backing[i]->local isEqualToString:local]) {
            _backing[i]->status = lien->r.statuscode;
            _backing[i]->progression = lien->r.totalsize ? (float)lien->r.size / lien->r.totalsize : 0;
            _backing[i]->totalsize = lien->r.totalsize;
            return (int)i;
        }
    }
    return -1;
}

- (void)updateBacking:(lien_back *)liens total:(int)tot {
    int i;
    if([_backing count] != tot) {
        [_backing removeAllObjects];
        for(i = 0; i < tot; i++) {
            MyBackingBridge * b = [[MyBackingBridge alloc] init];
            [_backing addObject:b];
            [b release];
        }
    }
    
    for(i = 0; i < tot; i++) {
        MyBackingBridge* b = [_backing objectAtIndex:i];
        [b->remote release];
        [b->referer release];
        [b->local release];
        b->remote = [[NSString stringWithFormat:@"%s%s", liens[i].url_adr, liens[i].url_fil] copy];
        b->referer = [[NSString stringWithFormat:@"%s%s", liens[i].referer_adr, liens[i].referer_fil] copy];
        b->local = [[NSString stringWithFormat:@"%s", liens[i].url_sav] copy];
        b->status = liens[i].r.statuscode;
        b->progression = liens[i].r.totalsize ? (float)liens[i].r.size / liens[i].r.totalsize : 0;
        b->totalsize = liens[i].r.totalsize;
    }
}
-(NSUInteger)count {
    return [_backing count];
}
//-(TYPED_CONTAINER(NSArray,MyBackingBridge*)*)backing {
//    return _backing;
//}
-(MyBackingBridge*)backAt:(NSUInteger)idx {
    return [_backing objectAtIndex:idx];
}
@end

@implementation ModelsApp
+ (MyDowloadableFile*)addFile:(NSString *)file toArborescence:(MyDirectoryElements *)arbo sittingAtCompletePath:(NSString*)path createdAt:(NSDate*)date{
    MyDowloadableFile*f =[MyDowloadableFile createFromString:file atPath:path createdAt:date];
    [[arbo files] addObject:f];
    
    return f;
}
+ (MyDirectoryElements *)addDirectory:(NSString *)dirname toArborescene:(MyDirectoryElements *)arbo {
    MyDirectoryElements *n =[MyDirectoryElements createFromString:dirname atDepth:[arbo depth] + 1];
    [[arbo directories] addObject:n];
    return n;
}
+(MyDowloadableFile*)addPathComponents:(TYPED_CONTAINER(NSArray,NSString*)*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path createdAt:(NSDate*)date
{
    MyDirectoryElements * orig = arbo;
    int i;
    for(i = 0; i < [comps count] - 1; i++) {
        NSString*s = [comps objectAtIndex:i];
        int j;
        for(j =0; j < [[arbo directories] count]; j++) {
            if([[[[arbo directories] objectAtIndex:j] name] isEqualToString:s]) {
                arbo = [[arbo directories] objectAtIndex:j];
                goto directory_found;
            }
        }
        /// directory not found, we must create it
        arbo = [ModelsApp addDirectory:s toArborescene:arbo];
        directory_found:;
    }
    MyDowloadableFile* f;
    for(i = 0; i < [[arbo files] count] ; i++) {
        if([[[[arbo files] objectAtIndex:i] name] isEqualToString:[comps objectAtIndex:[comps count] - 1]]) {
            f = [[arbo files] objectAtIndex:i];
            goto file_found;
        }
    }
    /// file not found, we must create it
    f = [ModelsApp addFile:[comps objectAtIndex:[comps count] - 1] toArborescence:arbo sittingAtCompletePath:complete_path createdAt:date];
    
    file_found:;
    
    return f;
}
@end

NS_ASSUME_NONNULL_END
