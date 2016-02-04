//
//  ViewController.m
//  SearchTextView
//
//  Created by Haripal on 2/4/16.
//  Copyright © 2016 Haripal Wagh. All rights reserved.
//

#import "ViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)


#define DEVICE_SIZE [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size

@interface ViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UITableView *tblProbableEntries;
    
    NSArray *originalEntriesArray;
    
    NSMutableArray *entriesArray;
    UIView *viewEntriesList;
    UIView *viewBackgroundEntriesList;
}
@end

@implementation ViewController

@synthesize txtSearchField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    txtSearchField.delegate = self;
    
    originalEntriesArray = @[@"ABCDE",
                             @"BDSAD",
                             @"DFHGDFG",
                             @"TTDFHG",
                             @"HNFDS",
                             @"SDFXCV",
                             @"NHTY",
                             @"EEEGDS",
                             @"BGSSDF",
                             @"NHJKLH",
                             @"IUIOP",
                             @"TYUI",
                             @"ERYT",
                             @"NHYN",
                             @"QWER",
                             @"ASDF",
                             @"FASD",
                             @"DECSA",
                             @"456RT",
                             @"JU78WER",
                             @"1212DEA",
                             @"kjhsdf",
                             @"drtwe",
                             @"fsdx",
                             @"gvraxcvb",
                             @"cvbrt",
                             @"ewrt43",
                             @"mkiu9",
                             @"95674ert",
                             @"adsre",
                             @"grrr"];
    
    entriesArray = [[NSMutableArray alloc] initWithArray:originalEntriesArray];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self updateFrameForList];
}

- (void)showEntriesList
{
    viewBackgroundEntriesList = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height)];
    viewBackgroundEntriesList.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    viewEntriesList = [[UIView alloc] init];
    
    [self updateFrameForList];
    
    viewEntriesList.backgroundColor = [UIColor clearColor];
    viewEntriesList.tag = 1909;
    [viewEntriesList.layer setCornerRadius:8.0f];
    [viewEntriesList.layer setMasksToBounds:YES];
    
    tblProbableEntries = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewEntriesList.frame.size.width, viewEntriesList.frame.size.height)];
    tblProbableEntries.dataSource = self;
    tblProbableEntries.delegate = self;
    tblProbableEntries.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblProbableEntries.backgroundColor = [UIColor clearColor];
    [viewEntriesList bringSubviewToFront:tblProbableEntries];
    [viewEntriesList addSubview:tblProbableEntries];
    
    [viewBackgroundEntriesList addSubview:viewEntriesList];
    [self.view addSubview:viewBackgroundEntriesList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - TableView Delegate and Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [entriesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strEntriesIdentifier = @"Entries"; 
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strEntriesIdentifier];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewEntriesList.frame.size.width, 1)];
    separatorView.backgroundColor = [UIColor grayColor];
    [cell addSubview:separatorView];
    
    cell.textLabel.text = [entriesArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblProbableEntries)
    {
        txtSearchField.text = [entriesArray objectAtIndex:indexPath.row];
        
        [txtSearchField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *strSearchText = [textField.text stringByReplacingCharactersInRange:range withString:string];;
    
    [self updateSearchFieldForText:strSearchText];
    
    return YES;
}

- (void)updateSearchFieldForText:(NSString *)strSearchText
{
    NSMutableSet * matches = [NSMutableSet setWithArray:originalEntriesArray];
    if ([strSearchText length] > 0)
    {
        [matches filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[c] %@", strSearchText]];
    }
    entriesArray = (NSMutableArray *)[matches sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"" ascending:YES]]];
    
    [self updateFrameForList];
    
    [tblProbableEntries reloadData];
}

- (void)updateFrameForList
{
    if (IS_IPHONE_4)
    {
        if ([entriesArray count] <= 10)
        {
            viewEntriesList.frame = CGRectMake(txtSearchField.frame.origin.x,
                                               txtSearchField.frame.origin.y + txtSearchField.frame.size.height + 1,
                                               txtSearchField.frame.size.width,
                                               [entriesArray count] * 30 + 70);
        }
        else
        {
            viewEntriesList.frame = CGRectMake(txtSearchField.frame.origin.x,
                                               txtSearchField.frame.origin.y + txtSearchField.frame.size.height + 1,
                                               txtSearchField.frame.size.width,
                                               DEVICE_SIZE.height / 2 + 60);
        }
    }
    else
    {
        if ([entriesArray count] <= 12)
        {
            viewEntriesList.frame = CGRectMake(txtSearchField.frame.origin.x,
                                               txtSearchField.frame.origin.y + txtSearchField.frame.size.height + 1,
                                               txtSearchField.frame.size.width,
                                               [entriesArray count] * 30 + 70);
        }
        else
        {
            
            viewEntriesList.frame = CGRectMake(txtSearchField.frame.origin.x,
                                               txtSearchField.frame.origin.y + txtSearchField.frame.size.height + 1,
                                               txtSearchField.frame.size.width,
                                               DEVICE_SIZE.height / 2);
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtSearchField)
    {
        if ([entriesArray count] > 0)
        {
            [self showEntriesList];
            [self updateSearchFieldForText:txtSearchField.text];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [viewBackgroundEntriesList removeFromSuperview];
}


@end
