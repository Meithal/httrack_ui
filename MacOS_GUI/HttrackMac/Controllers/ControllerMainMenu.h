#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "../CoreLogic.h"

NS_ASSUME_NONNULL_BEGIN

enum {
    HTR_CONTROL_PLAY = 0,
    HTR_CONTROL_PAUSE,
    HTR_CONTROL_STOP,
};
@class ProjectsOutlineView;
@class MonContenuPreview;
@class BackingDataSource;
/**
 Notre "controlleur" qui fait l'interface entre l'UI et la logique+données
 */
@interface ControllerMainMenu : NSViewController<CoreLogicDelegate, NSDrawerDelegate, NSWindowDelegate>
{
    //IBOutlet AppDelegate *_AppDelegate;
    IBOutlet CoreLogic* _logic;
    IBOutlet NSWindow* _myParentWindow;
        
    IBOutlet ProjectsOutlineView * _projectsOutlineView;
    IBOutlet NSButton* _downloadButton;
    IBOutlet NSSegmentedControl* _playpausestopControl;
    
    IBOutlet NSTextField* _httrTotalRecvLabel;
    IBOutlet NSTextField* _httrTotalBytesWrittenLabel;
    IBOutlet NSTextField* _httrTimeStartLabel;
    IBOutlet NSTextField* _httrTotalUnpackedReceivedLabel;
    IBOutlet NSTextField* _httrTotalPackedReceivedLabel;
    IBOutlet NSTextField* _httrTotalPackedFilesLabel;
    IBOutlet NSTextField* _httrTotalWrittenFilesLabel;
    IBOutlet NSTextField* _httrTotalUpdatedFilesLabel;
    IBOutlet NSTextField* _httrTotalBackgroundFilesLabel;
    IBOutlet NSTextField* _httrTotalSockRequestsLabel;
    IBOutlet NSTextField* _httrTotalSocksAllocatedLabel;
    IBOutlet NSTextField* _httrTotalSocksLabel;
    IBOutlet NSTextField* _httrTotalErrorsLabel;
    IBOutlet NSTextField* _httrTotalFrontErrorsLabel;
    IBOutlet NSTextField* _httrTotalWarningsLabel;
    IBOutlet NSTextField* _httrTotalInfosLabel;
    IBOutlet NSTextField* _httrTotalBackgroundAnticLabel;
    IBOutlet NSTextField* _httrTotalTransferedLabel;
    IBOutlet NSTextField* _httrRateLabel;
    IBOutlet NSTextField* _httrLastConnectLabel;
    IBOutlet NSTextField* _httrLastRequestLabel;
    
    IBOutlet MonContenuPreview* _contenuPreview;
    
    /// Section des drawers
    
    ///Le drawer qui affiche les stats de téléchargement
    NSDrawer * _drawerLiens;
    IBOutlet NSView * _drawerContentView;
    IBOutlet NSButton* _liensDrawerButton;
    IBOutlet NSTableView* _tableBacking;
    IBOutlet NSTableView* _tableLiens;
    IBOutlet NSSplitView* _splitLiens;
    IBOutlet NSButton* _splitOrientationChanger;
    IBOutlet NSButton* _detachButton;
    
    ///Le panel alternatif pour les stats de téléchargement
    IBOutlet NSPanel* _downloadStatsPanel;
    BOOL isDownloadsStatsPanelClosing;
    
    /// panel de statistiques generales
    IBOutlet NSPanel* _httrackStatsPanel;
}
@property (assign) IBOutlet NSTextField *httrSiteUrl;
-(void)updateGlobalStats:(hts_stat_struct *) stats;
-(void)updateState;
-(ProjectsOutlineView*)projectsOutlineView;
-(MonContenuPreview*) contenuPreview;
-(void)changeWindowSubtitle:(NSString*)newSubtitle;
@end


@interface ProjectsDataSource: NSObject<NSOutlineViewDataSource, NSOutlineViewDelegate>
{
    //IBOutlet AppDelegate *_delegate;
    IBOutlet CoreLogic* _logic;
}
@end

@interface ProjectsOutlineView: NSOutlineView
{
    IBOutlet ControllerMainMenu* _mainController;
}
-(ControllerMainMenu*)mainController;
@end

@interface MonContenuPreview: NSView<WKUIDelegate> {
}
-(void)mainChangePreview:(NSString*)chemin;
@end

@interface MyToolbarStatsButton: NSToolbarItem<NSWindowDelegate> {
}
@end

@interface BackingDataSource: NSObject<NSTableViewDataSource, NSTableViewDelegate>
{
    IBOutlet CoreLogic* core_logic;
}
@end

@interface LiensDataSource: NSObject<NSTableViewDataSource, NSTableViewDelegate>
{
    IBOutlet CoreLogic* core_logic;
}
@end

NS_ASSUME_NONNULL_END
