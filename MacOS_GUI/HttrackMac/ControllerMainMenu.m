#if defined(__clang__) /** we are using gcc only to check retrocomp, do not fill the error log with system headers incompatibilities */
#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#endif

#import "htscore.h"

#import "retro_comp.h"
#import "ModelsApp.h"
#import "CoreLogic.h"

#import "ControllerMainMenu.h"

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier IDENTIFIER_toolbar_main_separator = @"main_separator";
static NSToolbarItem* g_sep;

@implementation ControllerMainMenu
-(void) awakeFromNib {
    [_logic setDelegate:self];
    [_logic setLoopCallback:@selector(updateGlobalStats:) withObject:self];
    
    [self changeMainAppearance];
    
    /// On crée le NSDrawer programmatiquement vu qu'on ne peut pas le créer via interface builder
    CGSize size = _myParentWindow.contentView.frame.size;
    size.height /= 2;
    _drawerLiens = [[NSDrawer alloc] initWithContentSize:size preferredEdge:NSRectEdgeMinY];
    [_drawerLiens setParentWindow:_myParentWindow];
    //[self->_myParentWindow addChildWindow:_drawerLiens ordered:NSWindowBelow];
    [_drawerLiens setMinContentSize:size];
    size.height *= 2;
    [_drawerLiens setMaxContentSize:size];
    
    [self->_viewDrawerLiens setFrameSize:_drawerLiens.contentView.frame.size];
    [self->_viewDrawerLiens setAutoresizingMask:_drawerLiens.contentView.autoresizingMask];

    [self->_viewDrawerLiens setNeedsLayout:YES];
    [self->_viewDrawerLiens setNeedsDisplay:YES];
    [self->_viewDrawerLiens resizeSubviewsWithOldSize:_drawerLiens.contentView.frame.size];
    [_drawerLiens setContentView:self->_viewDrawerLiens];
    
    [_drawerLiens setDelegate:self];
}
-(void) dealloc {
    [_logic setDelegate:nil];
    [_logic setLoopCallback:nil withObject:nil];
    [_drawerLiens release];
    [_drawerProjets release];
    
    [_sidebarvc release];
    [_centervc release];
    [_mainSplitViewController release];
    
    [super dealloc];
}
#pragma mark getters de template
-(NSTextField *)httrSiteUrl {
    return _httrSiteUrl;
}
#pragma mark Apparence globale de l'App
-(void)changeMainAppearance {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    id style = [defaults valueForKey:PREFERENCE_app_style];
    enum APP_STYLE app_style = APP_STYLE_TIGER;
    if(style == nil) { /// premier demarrage
        if(@available(macOS 11.0, *)) {
            app_style = APP_STYLE_BIG_SUR;
        }
    } else {
        app_style = [style intValue];
        // securité en cas de retrogradation de machine
        if(@available(macOS 11.0, *)) {
            
        } else {
            app_style = APP_STYLE_TIGER;
        }
    }

    /// Instantie le projects outline dans un drawer
    if(app_style == APP_STYLE_TIGER) {

        CGSize pdsize = _projectsOutlineScrollView.frame.size;
        _drawerProjets = [[NSDrawer alloc] initWithContentSize:pdsize preferredEdge:NSRectEdgeMinX];
        [_drawerProjets setParentWindow:_myParentWindow];
        [_drawerProjets setMinContentSize:CGSizeMake(pdsize.width/2, pdsize.height)];
        [_drawerProjets setContentView:_projectsOutlineScrollView];
        [_drawerProjets open];
        if(_mainSplitViewController) {
//            [_sidebarvc release];
//            
//            [[[_contenuPreview window] contentView] addSubview:_contenuPreview];
//            [_centervc release];
            
            [_myParentWindow setContentViewController:nil];
//            [_mainSplitViewController release];
//            _mainSplitViewController = nil;
        }
    } else if (app_style == APP_STYLE_BIG_SUR) {
        /// Instantie un SplitViewController si on le supporte
        if(@available(macOS 11.0, *)) {
            [_drawerProjets open];
            
            if(_mainSplitViewController == nil) {
                _mainSplitViewController = [[NSSplitViewController alloc] init];
                
                _sidebarvc = [[NSViewController alloc] init];
                [_sidebarvc setView:_projectsOutlineScrollView];
                
                NSSplitViewItem* sidebarsvi = [NSSplitViewItem sidebarWithViewController:_sidebarvc];
                
                _centervc = [[NSViewController alloc] init];
                [_centervc setView:_contenuPreview];
                
                NSSplitViewItem* centervcsvi = [NSSplitViewItem contentListWithViewController:_centervc];
                
                [_mainSplitViewController addSplitViewItem:sidebarsvi];
                [_mainSplitViewController addSplitViewItem:centervcsvi];
                
                //[root addSubview:mainSplitViewController];
                
                g_sep = [[NSTrackingSeparatorToolbarItem trackingSeparatorToolbarItemWithIdentifier:@"main_separator" splitView:[_mainSplitViewController splitView] dividerIndex:0] retain];
                
                [_toolbar insertItemWithItemIdentifier:@"main_separator" atIndex:1];
            }
            
            [_myParentWindow setContentViewController:_mainSplitViewController];
        } else {
            assert(0 && "should never happen");
        }
    }
}
#pragma mark drawer des projets
-(IBAction)toggleDrawerProjects:(id)sender {
    if(_mainSplitViewController) {
        [_mainSplitViewController toggleSidebar:sender];
    } else {
        [_drawerProjets toggle:sender];
    }
}
#pragma mark section du drawer du bas
-(void)updateState {
    /// le cas où on utilise le drawer
    if(_drawerLiens.contentView.subviews.count > 0) {
        NSDrawerState state = [_drawerLiens state];
        if(state == NSDrawerClosedState || state == NSDrawerClosingState) {
            [_liensDrawerButton setState:NSControlStateValueOff];
            [_splitOrientationChanger setHidden:YES];
            [_detachButton setHidden:YES];
        } else {
            [_liensDrawerButton setState:NSControlStateValueOn];
            [_splitOrientationChanger setHidden:NO];
            [_detachButton setHidden:NO];
        }
    } else { /// le cas où on utilise le panel
        if(_isDownloadsStatsPanelClosing) {
            [_liensDrawerButton setState:NSControlStateValueOff];
            [_splitOrientationChanger setHidden:YES];
            [_detachButton setHidden:YES];
        } else {
            [_liensDrawerButton setState:NSControlStateValueOn];
            [_splitOrientationChanger setHidden:NO];
            [_detachButton setHidden:NO];
        }
    }
}
/// callbacks du delegate de nsdrawer quand celui ci se ferme ou s'ouvre
- (void)drawerDidOpen:(NSNotification *)notification {
    [self updateState];
}
- (void)drawerDidClose:(NSNotification *)notification {
    [self updateState];
}
/// delegate quand les stats sont dans une fenetre détachée
- (void)windowWillClose:(NSNotification *)notification {
    _isDownloadsStatsPanelClosing = YES;
    [self updateState];
}
-(void)windowDidBecomeKey:(NSNotification *)notification {
    _isDownloadsStatsPanelClosing = NO;
    [self updateState];
}
-(IBAction)toggleLinksDrawer:(id)sender {
    if(_drawerLiens.contentView.subviews.count > 0) {
        NSDrawerState state = [_drawerLiens state];
        if(state == NSDrawerClosedState || state == NSDrawerClosingState) {
            [_drawerLiens open];
        } else {
            [_drawerLiens close];
        }
    } else {
        if(_downloadStatsPanel.contentView.window.isVisible) {
            [_downloadStatsPanel.contentView.window close];
        } else {
            [_downloadStatsPanel.contentView.window makeKeyAndOrderFront:self];
        }
    }
}
-(IBAction)rotateSplitStats:(id)sender {
    [_splitLiens setVertical:![_splitLiens isVertical]];
}
#pragma mark fenetre des stats
-(IBAction)detachStats:(id)sender {
    if(_drawerLiens.contentView.subviews.count > 0) {
        [_downloadStatsPanel setContentView:_viewDrawerLiens];
        [_downloadStatsPanel makeKeyAndOrderFront:self];
        [_drawerLiens close];
    } else {
        [_drawerLiens setContentView:_viewDrawerLiens];
        [_downloadStatsPanel performClose:self];
        [_drawerLiens open];
    }
}
#pragma mark reste
-(ProjectsOutlineView*)projectsOutlineView {
    return _projectsOutlineView;
}
-(MonContenuPreview*) contenuPreview {
    return _contenuPreview;
}
-(void)changeWindowSubtitle:(NSString*)newSubtitle
{
    if(@available(macOS 11.0, *)) {
        [[[NSApplication sharedApplication] mainWindow] setSubtitle:newSubtitle];
    }
}
-(void)warnUser:(NSString*)description domain:(NSErrorDomain) domain code:(NSInteger) code
{
    NSError * underlyingError = [[NSError alloc] initWithDomain:domain code:code userInfo:nil];
    
    NSDictionary<NSErrorUserInfoKey, id> * errorDictionary = @{
        NSLocalizedDescriptionKey : description,
        NSUnderlyingErrorKey : underlyingError,
        NSLocalizedRecoverySuggestionErrorKey: @"Try a a different URL",
        //NSURLErrorKey : url
    };

    NSError * error= [[NSError alloc] initWithDomain:domain code:code userInfo:errorDictionary];
    [[NSAlert alertWithError:error] runModal];
}
- (IBAction)httrDowloadButton:(NSButton *)sender {
//    NSLog(@"Push %@", [self.httrSiteUrl stringValue]);
    
    [self changeWindowSubtitle:[[self httrSiteUrl] stringValue]];
    //[self.coreLogic indexOfDownloadedSites];
    [_logic
     dowloadSite:[[self httrSiteUrl] stringValue]
     onError:^(NSString *description, NSErrorDomain domain, NSInteger code) {
        [self warnUser:description domain:domain code:code];
    }];
}
-(IBAction)segmentedControl:(NSSegmentedControl*)sender {
    switch ([sender selectedTag]) {
        case HTR_CONTROL_PLAY:
            [_logic pauseMirror:0];
            break;
        case HTR_CONTROL_PAUSE:
            [_logic pauseMirror:1];
            break;
        case HTR_CONTROL_STOP:
            [_logic stopMirror];
            break;
        default:
            break;
    }
}
-(void)updateGlobalStats:(hts_stat_struct *) stats {
        
    /// partie qui gere la mise a jour des sdtatistiques globales de httrack
    if(stats == NULL)
        return;
    
    [_httrTotalRecvLabel setStringValue:[NSString stringWithFormat:@"%ld bytes", stats->HTS_TOTAL_RECV]];
    [_httrTotalBytesWrittenLabel setStringValue:[NSString stringWithFormat:@"%ld bytes", stats->stat_bytes]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    [formatter setLocale:[NSLocale currentLocale]];

    NSString *localized = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: stats->stat_timestart]];
    [_httrTimeStartLabel setStringValue:localized];
    
    [_httrTotalUnpackedReceivedLabel setStringValue:[NSString stringWithFormat:@"%ld", stats->total_unpacked]];
    [_httrTotalPackedReceivedLabel setStringValue:[NSString stringWithFormat:@"%ld", stats->total_packed]];
    [_httrTotalPackedFilesLabel setStringValue:[NSString stringWithFormat:@"%d", stats->total_packedfiles]];
    [_httrTotalWrittenFilesLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_files]];
    [_httrTotalUpdatedFilesLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_updated_files]];
    [_httrTotalBackgroundFilesLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_background]];
    [_httrTotalSockRequestsLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_nrequests]];
    [_httrTotalSocksAllocatedLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_sockid]];
    [_httrTotalSocksLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_nsocket]];
    [_httrTotalErrorsLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_errors]];
    [_httrTotalFrontErrorsLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_errors_front]];
    [_httrTotalWarningsLabel setStringValue:[NSString stringWithFormat:@"%d", stats->stat_warnings]];
    [_httrTotalInfosLabel setStringValue:[NSString stringWithFormat:@"%d bytes", stats->stat_infos]];
    [_httrTotalBackgroundAnticLabel setStringValue:[NSString stringWithFormat:@"%d", stats->nbk]];
    [_httrTotalTransferedLabel setStringValue:[NSString stringWithFormat:@"%ld bytes", stats->nb]];
    [_httrRateLabel setStringValue:[NSString stringWithFormat:@"%ld bytes/s", stats->rate]];
    [_httrLastConnectLabel setStringValue:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: stats->last_connect/1000]]];
    [_httrLastRequestLabel setStringValue:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: stats->last_request/1000]]];

    [formatter release];
}
-(void)coreLogicDownloadWillStart:(NSObject<CoreLogicDelegate> *)sender {
    
    [_downloadButton setEnabled:NO];
    [_playpausestopControl setSelectedSegment:HTR_CONTROL_PLAY];
    [_playpausestopControl setEnabled:YES forSegment:HTR_CONTROL_PAUSE];
    [_playpausestopControl setEnabled:YES forSegment:HTR_CONTROL_STOP];
    [_playpausestopControl setEnabled:NO forSegment:HTR_CONTROL_PLAY];
}
-(void)coreLogicDownloadDidStop:(CoreLogic*)sender {
    [_downloadButton setEnabled:YES];
    [_playpausestopControl setSelectedSegment:HTR_CONTROL_STOP];
    [_playpausestopControl setEnabled:NO forSegment:HTR_CONTROL_PAUSE];
    [_playpausestopControl setEnabled:NO forSegment:HTR_CONTROL_STOP];
    [_playpausestopControl setEnabled:NO forSegment:HTR_CONTROL_PLAY];
}
-(void)coreLogicDownloadDidPause:(CoreLogic*)sender {
    [_playpausestopControl setSelectedSegment:HTR_CONTROL_PAUSE];
    [_playpausestopControl setEnabled:NO forSegment:HTR_CONTROL_PAUSE];
    [_playpausestopControl setEnabled:YES forSegment:HTR_CONTROL_STOP];
    [_playpausestopControl setEnabled:YES forSegment:HTR_CONTROL_PLAY];
}
- (void)coreLogicPageAdded:(CoreLogic *)sender {
    [[self projectsOutlineView] reloadData];
}
- (void)coreLogicUpdateLinks:(CoreLogic *)sender links:(lien_back *)liens total:(int)tot { 
    
    [self->_tableBacking reloadData];
    [self->_tableLiens reloadData];
    [self->_stepperSockets setMaxValue:tot];
}
-(IBAction)generalStatsClick:(MyToolbarStatsButton*)sender {
    if(_httrackStatsPanel.isVisible) {
        [_httrackStatsPanel close];
    } else {
        [_myParentWindow addChildWindow:_httrackStatsPanel ordered:NSWindowAbove];
        [_httrackStatsPanel makeKeyAndOrderFront:sender];
    }
}
-(IBAction)nbSocketsStepper:(id)sender {
    
}
@end

@implementation MonContenuPreview
-(void)awakeFromNib {
    NSImage* back = [NSImage imageNamed:@"TexturedFullScreen"];
    if(back) {
        _fond = [[NSColor colorWithPatternImage:back] retain];
    }
}
-(void)dealloc {
    [_fond release];
    
    [super dealloc];
}
-(void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if(_fond) {
        NSRectClip(self.bounds);
        
        [_fond setFill];
        
        NSRectFill(dirtyRect);
    }
}
-(void)mainChangePreview:(NSString*)chemin {
    if(0) { /// a garder en tete pour comment envoyer des notifications plus tard
        //NSBeginCriticalAlertSheet(@"hello", @"ok?", @"nvm", @"what", [NSApp mainWindow], nil, nil, nil, NULL, @"Un truc s'est mal passé");
        NSAlert * na = [[NSAlert alloc] init];
        //NSDottedFrameRect(NSMakeRect(10, 10, 400, 300));
        //NSDrawButton(<#NSRect rect#>, <#NSRect clipRect#>)

        NSString* s = @("foo");
        [NSColor underPageBackgroundColor];
    }

    for (NSView* v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    if([chemin.pathExtension.lowercaseString isEqualTo:@"html"]) {
        WKWebViewConfiguration* wvc = [[WKWebViewConfiguration alloc] init];
        WKWebView* wv;
        if(@available(macOS 11.0, *)) {
            wv = [[WKWebView alloc] initWithFrame:self.safeAreaRect];
        } else {
            wv = [[WKWebView alloc] initWithFrame:self.bounds];
        }
        
        [wv setUIDelegate:self];
        [wv setAllowsBackForwardNavigationGestures:YES];
        [wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:chemin]]];
        
        [wvc autorelease];
        [wv autorelease];
        [wv setAutoresizingMask:self.autoresizingMask];
        
        [self addSubview:wv];
    }
    
    NSImage* im = [[NSImage alloc] initByReferencingFile:chemin];
    if([im isValid]) {
        NSImageView* iv = [NSImageView imageViewWithImage:im];
        [iv setFrame:NSMakeRect(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        [im autorelease];
        [iv setAutoresizingMask:self.autoresizingMask];
        
        [self addSubview:iv];
    }
    
}
@end

#pragma mark Notre barre de recherche
@interface MySearchInputField: NSSearchField<NSToolbarDelegate, NSTextViewDelegate> {
    BOOL _completePosting;
    IBOutlet CoreLogic* _logic;
}
@end

@implementation MySearchInputField
- (BOOL)becomeFirstResponder {
    //[self complete:nil];
    BOOL res = [super becomeFirstResponder];
    if(res)
        // FIXME: peut lancer NSXPCSpellServerTimeoutException "Spell server connection timeout sending suggestCompletionsForPartialWordRange"
        // utiliser requestCheckingOfString:range:types:options:inSpellDocumentWithTag:completionHandler:
        [[self currentEditor] complete:self];
    
    return res;
}
- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextView *textView = [notification.userInfo objectForKey:@"NSFieldEditor"];
    
    // prevent calling "complete" too often
    if(!_completePosting) {
        _completePosting = YES;
        [textView complete:textView];
        _completePosting = NO;
    }
}
-(void)awakeFromNib
{
    //[self setDelegate:self]; // cause autocompletion incontrolable
    NSSearchFieldCell * cell = [self cell];
    if(@available(macOS 11.0, *)) {
        [[cell searchButtonCell] setImage: [NSImage imageWithSystemSymbolName:@"tray.and.arrow.down" accessibilityDescription:@"The URL to download"]];
    }
    if(@available(macOS 14.0, *)) { // autocompletion de type URL disponible a partir de Sonoma
        [self setContentType:NSTextContentTypeURL];
    }
    //[self complete:self];
}
- (TYPED_CONTAINER(NSArray,NSString *) *)textView:(NSTextView *)textView completions:(TYPED_CONTAINER(NSArray,NSString *) *)words forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(nullable NSInteger *)index
{
    if([[textView string] isEqualToString: @""]) /// autocompletion uniquement quand on vient de cliquer sur le champ
        return [[NSUserDefaults standardUserDefaults] valueForKey:PREFERENCE_autocomplete_copied_sites];
    return nil;
}
- (TYPED_CONTAINER(NSArray,NSString *) *)recentSearches {
    return [_logic.sitesOnHardDrive copy];
}
@end

@interface MainSplitViewDelegate : NSObject<NSSplitViewDelegate>
{}
@end

#pragma mark MainSplitViewDelegate
@implementation MainSplitViewDelegate
- (void) splitView:(NSSplitView *) splitView
resizeSubviewsWithOldSize:(NSSize) oldSize
{
    NSView* left = [[splitView subviews] objectAtIndex:0];
    NSView* right = [[splitView subviews] objectAtIndex:1];
    
    CGFloat fixedWidth = left.frame.size.width;
    CGFloat dividerWidth = [splitView dividerThickness];
    
    [left setFrame:NSMakeRect(0, 0, fixedWidth, splitView.frame.size.height)];
    
    CGFloat remainder = splitView.frame.size.width - fixedWidth - dividerWidth;
    [right setFrame:NSMakeRect(fixedWidth + dividerWidth, 0, remainder, splitView.frame.size.height)];
}

- (CGFloat) splitView:(NSSplitView *) splitView
constrainMinCoordinate:(CGFloat) proposedMinimumPosition
          ofSubviewAt:(NSInteger) dividerIndex
{
    
    return 200;
}
- (CGFloat) splitView:(NSSplitView *) splitView
constrainMaxCoordinate:(CGFloat) proposedMinimumPosition
          ofSubviewAt:(NSInteger) dividerIndex
{
    return [splitView frame].size.width - 200;
}
@end

@implementation ProjectsDataSource
#pragma mark NSOutlineViewDataSource
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(MyDirectoryElements *)item {
    if(item.class == MyDowloadableFile.class) // ou != MyDirectoryElements.class
        return NO;
    NSLevelIndicatorCell * c;
    return item.directories.count || item.files.count;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(nullable MyDirectoryElements *)item {
    if(item == nil)
        return _logic.websites.directories.count;
    else if (item.class == MyDowloadableFile.class)
        return 0;
    else
        return item.directories.count + item.files.count;
}

- (nullable id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn byItem:(nullable MyDirectoryElements *)item {
    if(item == nil) return @"nil";
    
    if(item.class == MyDirectoryElements.class) {
        if([tableColumn.identifier isEqualToString:@"PageName"])
            return item.name;
        else if(([tableColumn.identifier isEqualToString:@"Avancement"]))
            return [NSNumber numberWithFloat:item.avancement];
        else if([tableColumn.identifier isEqualToString:@"Icone"]) {
            NSImage * im = [NSImage imageNamed:NSImageNameFolder];
            
            return im;
        }
        else raise(42);
    } else if (item.class == MyDowloadableFile.class) {
        MyDowloadableFile * item_cast = (MyDowloadableFile*)item;
        if([tableColumn.identifier isEqualToString:@"PageName"])
            return item_cast.name;
        else if([tableColumn.identifier isEqualToString:@"Avancement"])
            return  [NSNumber numberWithFloat:item_cast.avancement];
        else if([tableColumn.identifier isEqualToString:@"Icone"]) {
            NSImage * im = [[NSImage alloc] initByReferencingFile:item_cast.hd_path];
            NSLevelIndicatorCell*c;
            [im autorelease];
            return im;
        }
        else raise(42);
    }
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(nullable MyDirectoryElements*)item {
    if(item == nil)
        return [_logic.websites.directories objectAtIndex:index];
    else {
        if(index < [[item directories] count])
            return [[item directories] objectAtIndex:index];
        else
            return [[item files] objectAtIndex:index - [[item directories] count]];
    }
}

#pragma mark NSOutlineViewDelegate
- (BOOL) outlineView:(NSOutlineView *) outlineView
         isGroupItem:(MyDirectoryElements *) item
{
    if([item class] != [MyDirectoryElements class])
        return NO;
    return item.depth < 2;
}

- (void) outlineViewSelectionDidChange:(NSNotification *) notification
{
    if([[notification userInfo] objectForKey:@"NSTableViewCurrentRowSelectionUserInfoKey"] == nil)
        return;
    
    NSIndexSet* ids = (NSIndexSet*)[[notification userInfo] objectForKey: @"NSTableViewCurrentRowSelectionUserInfoKey"];
    if([ids count] < 1)
        return;
    
    NSUInteger idx =[ids firstIndex];
    
    MyDowloadableFile* orow = [((ProjectsOutlineView*)notification.object) itemAtRow:idx ];
    if([orow respondsToSelector:@selector(hd_path)]) { // fichier
        [((ProjectsOutlineView*)[notification object]).mainController.contenuPreview mainChangePreview:orow.hd_path];
    } else { // repertoire
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSURL * url = [defaults URLForKey:PREFERENCE_default_save_folder]; // TODO: it should become per-project, instead of global
        
        [[NSWorkspace sharedWorkspace] openURL:[url URLByAppendingPathComponent:orow.name]];
    }
}

- (NSString *)outlineView:(NSOutlineView *)outlineView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(nullable NSTableColumn *)tableColumn item:(id)item mouseLocation:(NSPoint)mouseLocation {
    return @"todo";
}

@end

#pragma mark ProjectsOutlineView
@implementation ProjectsOutlineView
-(void)awakeFromNib{
    [self reloadData];
    
}
-(ControllerMainMenu*)mainController {
    return _mainController;
}
@end

/// Gere le bouton de la toolbar qui allume ou eteint le panel de stats
@implementation MyToolbarStatsButton
- (void)windowWillClose:(NSNotification *)notification {
    [(NSButton*)[self view] setState:NSControlStateValueOff];
    [[self toolbar] setSelectedItemIdentifier:nil];
}
@end

@implementation LiensDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(self->core_logic == nil)
        return 0;
    
    return self->core_logic.myLiens.count;
}
/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView). Note that NSTableCellView does not actually display the objectValue, and its value is to be used for bindings. See NSTableCellView.h for more information.
 */
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableColumn == nil)
        return nil;

    if ([tableColumn.identifier isEqualTo:@"TCIurl"]) {
        return [self->core_logic.myLiens lienAt:row]->remoteUrl;
    } else if ([tableColumn.identifier isEqualTo:@"TCIredirection"]) {
        return [self->core_logic.myLiens lienAt:row]->status;
    } else if ([tableColumn.identifier isEqualTo:@"TCIprecedent"]) {
        return [self->core_logic.myLiens lienAt:row]->previous;
    } else if ([tableColumn.identifier isEqualTo:@"TCIprofondeur"]) {
        return [self->core_logic.myLiens lienAt:row]->depth;
    } else if ([tableColumn.identifier isEqualTo:@"TCIsecondepasse"]) {
        return [self->core_logic.myLiens lienAt:row]->passe;
    } else if ([tableColumn.identifier isEqualTo:@"TCIretries"]) {
        return [self->core_logic.myLiens lienAt:row]->retires;
    }

    return @"toto";
}
@end

@implementation BackingDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if(self->core_logic == nil)
        return 0;
    
    return self->core_logic.myBacking.count;
}
/* This method is required for the "Cell Based" TableView, and is optional for the "View Based" TableView. If implemented in the latter case, the value will be set to the view at a given row/column if the view responds to -setObjectValue: (such as NSControl and NSTableCellView). Note that NSTableCellView does not actually display the objectValue, and its value is to be used for bindings. See NSTableCellView.h for more information.
 */
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    if(tableColumn == nil)
        return nil;
    assert(row>=0);
    if(row < 0)
        return nil;
    NSUInteger urow = row;
    
    if ([[tableColumn identifier] isEqualTo:@"TCIurl"]) {
        return [self->core_logic.myBacking backAt:urow]->remote;
    } else if ([[tableColumn identifier] isEqualTo:@"TCIlocal"]) {
        return [self->core_logic.myBacking backAt:urow]->local;
    } else if ([[tableColumn identifier] isEqualTo:@"Total size"]) {
        return [self->core_logic.myBacking backAt:urow]->totalsize;
    } else if ([[tableColumn identifier] isEqualTo:@"TCIreferer"]) {
        return [self->core_logic.myBacking backAt:urow]->referer;
    } else if ([[tableColumn identifier] isEqualTo:@"TCIstatus"]) {
        return [self->core_logic.myBacking backAt:urow]->status;
    } else if ([[tableColumn identifier] isEqualTo:@"Progression"]) {
        return [self->core_logic.myBacking backAt:urow]->progression;
    }
    return @"toto";
}
@end

@implementation SettingsController
-(void)awakeFromNib {

    _defaults = [[NSUserDefaults standardUserDefaults] retain];
    if(@available(macOS 11.0, *)) {
        [_deletaAllAutocompleteButton setHasDestructiveAction:YES];
    } else {
        [_radioBigSur setTitle:[NSString stringWithFormat:@"%@ - available from Big Sur", [_radioBigSur title]]];
        [_radioBigSur setEnabled:NO];
        [_radioBigSur sizeToFit];
    }
    [self updateState];
}
-(void)windowDidChangeOcclusionState:(NSNotification *)notification {
    if([((NSWindow*)[notification object]) isVisible] == NO)
        return;
    
    _autocompletions = [[_defaults valueForKey:PREFERENCE_autocomplete_copied_sites] copy];
    _changedAutocompletions = [_autocompletions mutableCopy];
    
    [self updateState];
}
-(void)dealloc {
    [_autocompletions release];
    [_changedAutocompletions release];
    [_defaults release];
    
    [super dealloc];
}
-(void)updateState {
    NSURL * url = [_defaults URLForKey:PREFERENCE_default_save_folder];
    [_defaultSavePathTextField setStringValue:[url relativePath]];
    
    [_saveAutocompleteButton setEnabled:![_autocompletions isEqualToArray:_changedAutocompletions]];
    [_deletaAllAutocompleteButton setEnabled:[_changedAutocompletions count] > 0];
    [_deleteRowAutocomplete setEnabled:[[_autocompleteTable selectedRowIndexes] count] > 0];
    [_undoAutocomplete setEnabled:![_autocompletions isEqualToArray:_changedAutocompletions]];
    
    [_autocompleteTable reloadData];
    
    /// Ici ce n'est pas trop grave si rien n'est defini pour cette preference can nil est converti vers 0
    enum APP_STYLE style = (int)[_defaults integerForKey:PREFERENCE_app_style];
    switch (style) {
        case APP_STYLE_TIGER:
            [_radioTiger setState:YES];
            [_radioBigSur setState:NO];
            break;
        case APP_STYLE_BIG_SUR:
            [_radioTiger setState:NO];
            [_radioBigSur setState:YES];
            break;
        default:
            break;
    }
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_changedAutocompletions count];
}
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    return [_changedAutocompletions objectAtIndex:row];
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self updateState];
}
-(IBAction)preferencesResetAppPreferences:(id)sender {
    NSArray* keys = [[_defaults dictionaryRepresentation] allKeys];
    int i, ct;
    for (i = 0, ct = (int)[keys count]; i < ct; i++) {
        if([[keys objectAtIndex:i] isEqualTo:PREFERENCE_autocomplete_copied_sites])
            continue;
        [_defaults setValue:nil forKey:[keys objectAtIndex:i]];
    }
    [_defaults synchronize];
    sanitize_save_folder_user_settings();
    [self updateState];
}
-(IBAction)preferencesDeleteAutocomplete:(id)sender {
    [_changedAutocompletions removeAllObjects];
    [self updateState];
}
-(IBAction)deleteRowAutocomplete:(id)sender {
    NSIndexSet* is = [_autocompleteTable selectedRowIndexes];
    [_changedAutocompletions removeObjectsAtIndexes:is];
    [self updateState];
}
-(IBAction)saveAutocomplete:(id)sender {
    [_defaults removeObjectForKey:PREFERENCE_autocomplete_copied_sites];
    
    [_autocompletions release];
    _autocompletions = [_changedAutocompletions copy];
    
    [_defaults setValue:[_autocompletions copy] forKey:PREFERENCE_autocomplete_copied_sites];
    [_defaults synchronize];
    
    [self updateState];
}
-(IBAction)undoAutocomplete:(id)sender {
    [_changedAutocompletions release];
    _changedAutocompletions = [_autocompletions mutableCopy];
    
    [self updateState];
}
-(IBAction)selectDefaultSaveFolder:(id)sender {
    NSOpenPanel* op = [NSOpenPanel openPanel];
    [op setCanChooseFiles:NO];
    [op setCanChooseDirectories:YES];
    [op setAllowsMultipleSelection:NO];
    [op setAccessoryViewDisclosed:YES];

    __block id weakself = self;
    [op beginWithCompletionHandler:^(NSModalResponse result) {
        if(result) {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setURL:[op URL] forKey:PREFERENCE_default_save_folder];
            [defaults synchronize];
            sanitize_save_folder_user_settings();
            [weakself updateState];
        }
    }];
}
-(IBAction)setTiger:(id)sender {
    [_defaults setInteger:APP_STYLE_TIGER forKey:PREFERENCE_app_style];
    [_defaults synchronize];
    [self updateState];
    //[_cmm changeMainAppearance]; buggué pour l'instant
}
-(IBAction)setBigsur:(id)sender {
    if(@available(macOS 11.0, *)) {
        [_defaults setInteger:APP_STYLE_BIG_SUR forKey:PREFERENCE_app_style];
        [_defaults synchronize];
    }
    [self updateState];
    //[_cmm changeMainAppearance];
}
@end

@implementation ProgressCell

//-(void)awakeFromNib {
    //self.controlView = [NSControl alloc]
//}

@end

@implementation MainToolbarDelegate
-(void)awakeFromNib {
    
}
- (nullable NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if([itemIdentifier isEqualTo:IDENTIFIER_toolbar_main_separator]) {
        if(g_sep)
            return g_sep;
    }
    
    return nil;
}

@end
NS_ASSUME_NONNULL_END
