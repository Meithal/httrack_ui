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
    return [me autorelease];
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
+(instancetype) createFromString:(NSString *) name {
    MyDirectoryElements * me =[[MyDirectoryElements alloc] init];
    me.name = name;
    me.directories = [[NSMutableArray alloc] init];
    me.files = [[NSMutableArray alloc] init];
    return [me autorelease];
}


- (BOOL)updateAdvancement:(nonnull NSString *)path site:(NSString*)site ratio:(float)ratio {
    //NSLog(@"me: %@ path: %@ site: %@ ratio: %.2f\n", _name, path, site, ratio);
    for(int i=0; i<self.directories.count; i++) {
        if([self.directories[i].name isEqualToString:site]) {
            for(int j=0;j<self.directories[i].files.count; j++)
                if([self.directories[i].files[j].name isEqualToString:path])
                    self.directories[i].files[j].downloadAdvancement = @(ratio);            
            break;
        }
    }
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

+(MyDirectoryElements*)addPathComponents:(NSArray<NSString*>*)comps toArborescence:(MyDirectoryElements *)arbo atCompletePath:(NSString*)complete_path
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
    for(int i = 0; i < arbo.files.count ; i++) {
        if([arbo.files[i].name isEqualToString:comps[comps.count - 1]]) {
            goto file_found;
        }
    }
    [ModelsApp addFile:comps[comps.count - 1] toArborescence:arbo sittingAtCompletePath:complete_path];
    /// file not found, we must create it
    file_found:;
    
    return orig;
}

@end

NS_ASSUME_NONNULL_END
