//
//  ICViewController.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICParseCMSViewController.h"
#import "IIViewDeckController.h"
#import "ICQueryTableViewController.h"
#import "ICObjectTableViewController.h"
#import "ICMenuViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "ICBundle.h"
@interface ICParseCMSViewController (){
    IBOutlet ICMenuViewController *_menuController;
    IBOutlet IIViewDeckController *_viewDeck;
    IBOutlet ICQueryTableViewController *_queryController;
    IBOutlet UINavigationController *_navigationController;
}

@end

@implementation ICParseCMSViewController

static ICParseCMSViewController * _cms;
+(ICParseCMSViewController *) viewController{
    if (nil != _cms) {
        return _cms;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        _cms = [[ICParseCMSViewController alloc] initWithNibName:@"ICParseCMSViewController" bundle:[ICBundle frameworkBundle]];
       // _cms = [[ICParseCMSViewController alloc] init];
    });
    
    return _cms;
}

-(id) init{
    self = [super init];
    if (self) {
        /*_menuController = [[ICMenuViewController alloc] init];
        [_menuController setValue:self forKey:@"_mainViewController"];
        _queryController = [[ICQueryTableViewController alloc] initWithStyle:UITableViewStylePlain className:@""];
        NSDictionary * info = [ICBundle parseInfoDictionary];
        if (!info[@"ParseClassNames"] || [info[@"ParseClassNames"] count] == 0) {
            @throw [NSException exceptionWithName:@"Empty ParseClassNames Array" reason:@"ParseClassNames key should be set in info dictionary" userInfo:nil];
        }
        _menuController.classNames = info[@"ParseClassNames"];
        _queryController.parseClassName = info[@"ParseClassNames"][0];
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_queryController];

        //_navigationController.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
        _viewDeck = [[IIViewDeckController alloc] initWithCenterViewController:_navigationController leftViewController:_menuController];
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view.layer setMasksToBounds:NO];
        _viewDeck.view.frame = [UIScreen mainScreen].bounds;
        _viewDeck.resizesCenterView = YES;
        [self.view addSubview:_viewDeck.view];
        //self.view.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //self.view.autoresizesSubviews = YES;
        //
        _viewDeck.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _viewDeck.view.autoresizesSubviews = YES;
        
        _queryController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _navigationController.view.autoresizesSubviews = YES;
        _navigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_menuController.tableView reloadData];
        
        _viewDeck.panningMode = IIViewDeckNoPanning;
        [self setupBarButtonItem];*/
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewDeck.panningMode = IIViewDeckNoPanning;
    _queryController.parseClassName = @"Project";
    NSDictionary * info = [ICBundle parseInfoDictionary];
    if (!info[@"ParseClassNames"] || [info[@"ParseClassNames"] count] == 0) {
        @throw [NSException exceptionWithName:@"Empty ParseClassNames Array" reason:@"ParseClassNames key should be set in info dictionary" userInfo:nil];
    }
    _menuController.classNames = info[@"ParseClassNames"];
    _queryController.parseClassName = info[@"ParseClassNames"][0];
    [self setupBarButtonItem];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayQueryControllerForClassName:(NSString *) className{
    _queryController.parseClassName = className;
    [_queryController loadObjects];
    [self setupBarButtonItem];
    [_viewDeck closeLeftView];
    
    //[self setViewDeckRootViewController:viewController wrapInNavigationController:YES];
}

-(UIViewController *) currentViewController{
    return [_navigationController topViewController];
}

-(BOOL) handleOpenURL:(NSURL *)url{
    NSDictionary * info = [ICBundle parseInfoDictionary];
    NSString * appId = info[@"ParseApplicationId"];
    if (![url.scheme isEqualToString:[NSString stringWithFormat:@"parse%@", appId]]) {
        return NO;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray * things= [[url description] componentsSeparatedByString:@"?"];
    if ([things count] > 1) {
        NSString * queryString = things[1];
        for (NSString *param in [queryString componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        NSString * key = params[@"key"];
        NSString * value = params[@"value"];
        NSString *decoded = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        value = decoded;
        if(key && value){
            UIViewController * current = [_navigationController topViewController];
            if ([current isKindOfClass:[ICObjectTableViewController class]]) {
                [(ICObjectTableViewController *)current updateKey:key value:value];
            }
        }
    }
    
    return YES;
}

-(BOOL) shouldAutorotate{
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void) setupBarButtonItem{
    _queryController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:_viewDeck action:@selector(toggleLeftView)];
}


@end
