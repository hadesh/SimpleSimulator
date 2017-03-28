//
//  ViewController.m
//  SimpleSimulator
//
//  Created by hanxiaoming on 17/2/9.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import "ViewController.h"
#import "SSItemManager.h"

@interface ViewController ()<NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (nonatomic, strong) NSArray<SSSimulator *> *allSimulators;
@property (nonatomic, strong) SSSimulator *selectedSimulator;

@property (weak) IBOutlet NSOutlineView *deviceSourceView;
@property (weak) IBOutlet NSOutlineView *appSourceView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self.deviceSourceView reloadData];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSArray<SSSimulator *> *)allSimulators
{
    if (!_allSimulators) {
        _allSimulators = [[SSItemManager allSimulators] sortedArrayUsingComparator:^NSComparisonResult(SSSimulator *obj1, SSSimulator *obj2) {
            return [obj1.version compare:obj2.version];
        }];
        
        // sort
        _allSimulators = [_allSimulators sortedArrayUsingComparator:^NSComparisonResult(SSSimulator *obj1, SSSimulator *obj2) {
            if ([obj1.device compare:obj2.device] == NSOrderedAscending){
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
    }
    return _allSimulators;
}

#pragma mark - 

- (IBAction)actionRefresh:(id)sender
{
    self.allSimulators = nil;
    self.selectedSimulator = nil;
    [self.deviceSourceView reloadData];
    [self.appSourceView reloadData];
}

- (IBAction)actionOpen:(id)sender
{
    [self openCurrenApplication];
}

- (IBAction)actionAppDoubleClick:(id)sender
{
    [self openCurrenApplication];
}
- (IBAction)actionDeviceDoubleClick:(id)sender
{
    [self openCurrenDevice];
}

- (void)openCurrenApplication
{
    if (self.selectedSimulator == nil)
    {
        return;
    }
    
    NSInteger selectedAppIndex = self.appSourceView.selectedRow;
    
    NSString *path = self.selectedSimulator.devicePath;
    
    if (selectedAppIndex >= 0) {
        SSApplication *app = [self.selectedSimulator.applications objectAtIndex:selectedAppIndex];
        path = app.applicationDataPath ?: app.applicationBundlePath;
    }
    
    [SSItemManager openFileAtPath:path];
}

- (void)openCurrenDevice
{
    if (self.selectedSimulator == nil)
    {
        return;
    }
    [SSItemManager openFileAtPath:self.selectedSimulator.devicePath];
}

#pragma mark - OUTLINE VIEW DELEGATE & DATASOURCE

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (outlineView == self.deviceSourceView)
    {
        if(item == nil)
        {
            return self.allSimulators.count;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if(item == nil)
        {
            return self.selectedSimulator.applications.count;
        }
        else
        {
            return 0;
        }
    }
    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (outlineView == self.deviceSourceView)
    {
        if(item == nil)
        {
            return [self.allSimulators objectAtIndex:index];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if(item == nil)
        {
            return [self.selectedSimulator.applications objectAtIndex:index];
        }
        else
        {
            return nil;
        }
    }
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    if (outlineView == self.deviceSourceView)
    {
        SSSimulator *sim = (SSSimulator *)item;
        return sim.name;
    }
    else
    {
        SSApplication *app = (SSApplication *)item;
        return app.displayName;
    }

}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    // This method needs to be implemented if the SourceList is editable. e.g Changing the name of a Playlist in iTunes
    //[item setTitle:object];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    //Making the Source List Items Non Editable
    return NO;
}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSInteger row = [outlineView rowForItem:item];
    return [tableColumn dataCellForRow:row];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return NO;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{

    if (outlineView == self.deviceSourceView)
    {
        NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        SSSimulator *sim = (SSSimulator *)item;
        [[view textField] setStringValue:sim.name];
        return view;
    }
    else
    {
        NSTableCellView *view = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        SSApplication *app = (SSApplication *)item;
        [[view textField] setStringValue:app.displayName];
        
        return view;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return YES;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSOutlineView *outlienView = (NSOutlineView *)notification.object;
    
    if (outlienView == self.deviceSourceView) {
        self.selectedSimulator = [self.allSimulators objectAtIndex:self.deviceSourceView.selectedRow];
        [self.appSourceView reloadData];
    }
}



@end
