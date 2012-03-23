//
//  TottepostSettingTableViewController.m
//  tottepost
//
//  Created by Kentaro ISHITOYA on 12/03/06.
//  Copyright (c) 2012 cocotomo. All rights reserved.
//

#import "TottepostSettingTableViewController.h"
#import "TTLang.h"
#import "PhotoSubmitterSettings.h"
#import "PhotoSubmitterSettingTableViewProtocol.h"
#import "MAConfirmButton.h"

#define SV_SECTION_GENERAL  0
static NSString *kTwitterPhotoSubmitterType = @"TwitterPhotoSubmitter";

//-----------------------------------------------------------------------------
//Private Implementations
//-----------------------------------------------------------------------------
@interface TottepostSettingTableViewController(PrivateImplementation)
- (void) handleProButtonTapped:(id)sender;
@end

#pragma mark -
#pragma mark Private Implementations
@implementation TottepostSettingTableViewController(PrivateImplementation)
#pragma mark -
#pragma mark tableview methods
/*!
 * open app store
 */
- (void) handleProButtonTapped:(id)sender{
    NSString *stringURL = [TTLang localized:@"AppStore_Url_Pro"];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url]; 
}
/*!
 * get row number
 */
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SV_SECTION_GENERAL: return SV_GENERAL_COUNT + 3;
        default:return [super tableView:table numberOfRowsInSection:section];
    }
    return 0;
}

/*!
 * title for section
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == SV_GENERAL_COUNT){
        return [TTLang localized:@"Settings_Section_About"];
    }else{
        return [super tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

/*!
 * on row selected
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == SV_SECTION_GENERAL){
        if(indexPath.row == SV_GENERAL_COUNT){
#ifndef LITE_VERSION
            presetSettingViewController_.type = AVFoundationPresetTypePhoto;
            presetSettingViewController_.title = [TTLang localized:@"Settings_Title_PhotoPreset"];
            [self.navigationController pushViewController:presetSettingViewController_ animated:YES];
#endif
        }else if(indexPath.row == SV_GENERAL_COUNT + 1){
#ifndef LITE_VERSION
            presetSettingViewController_.type = AVFoundationPresetTypeVideo;
            presetSettingViewController_.title = [TTLang localized:@"Settings_Title_VideoPreset"];
            [self.navigationController pushViewController:presetSettingViewController_ animated:YES];
#endif
        }else if(indexPath.row == SV_GENERAL_COUNT + 2){
            [self.navigationController pushViewController:aboutSettingViewController_ animated:YES];
        }
    }else{
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
}
@end

//-----------------------------------------------------------------------------
//Public Implementations
#pragma mark -
#pragma mark Public Implementations
//-----------------------------------------------------------------------------
@implementation TottepostSettingTableViewController
@synthesize delegate;
/*!
 * initialize with frame
 */
- (id) init{
    self = [super init];
    if(self){
        aboutSettingViewController_ = [[AboutSettingViewController alloc] init];
        aboutSettingViewController_.delegate = self;
        presetSettingViewController_ = [[AVFoundationPresetTableViewController alloc] init];
    }
    return self;
}

/*!
 * create general setting cell
 */
- (UITableViewCell *)createGeneralSettingCell:(int)tag{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if(tag == SV_GENERAL_COUNT){
        cell.textLabel.text = [TTLang localized:@"Settings_Row_PhotoPreset"];
#ifdef LITE_VERSION
        MAConfirmButton *proButton = [MAConfirmButton buttonWithTitle:@"PRO" confirm:[TTLang localized:@"AppStore_Open"]];
        [proButton setTintColor:[UIColor colorWithRed:0.176 green:0.569 blue:0.820 alpha:1]];
        [proButton addTarget:self action:@selector(handleProButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = proButton;
        cell.textLabel.textColor = [UIColor grayColor];
#else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#endif

    }else if(tag == SV_GENERAL_COUNT + 1){
        cell.textLabel.text = [TTLang localized:@"Settings_Row_VideoPreset"];
#ifdef LITE_VERSION
        MAConfirmButton *proButton = [MAConfirmButton buttonWithTitle:@"PRO" confirm:[TTLang localized:@"AppStore_Open"]];
        [proButton setTintColor:[UIColor colorWithRed:0.176 green:0.569 blue:0.820 alpha:1]];
        [proButton addTarget:self action:@selector(handleProButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = proButton;
        cell.textLabel.textColor = [UIColor grayColor];
#else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#endif
    }else if(tag == SV_GENERAL_COUNT + 2){
        cell.textLabel.text = [TTLang localized:@"Settings_Row_About"];
    }else{
        return [super createGeneralSettingCell:tag];
    }
    return cell;
}


#pragma mark -
#pragma mark AboutSettingViewController delegate
- (void)didUserVoiceFeedbackButtonPressed{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
    [(id<TottepostSettingTableViewControllerDelegate>)self.delegate didUserVoiceFeedbackButtonPressed];
}

- (void)didMailFeedbackButtonPressed{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
    [(id<TottepostSettingTableViewControllerDelegate>)self.delegate didMailFeedbackButtonPressed];
}

@end
