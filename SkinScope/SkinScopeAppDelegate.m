//
//  SkinScopeAppDelegate.m
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "SkinScopeAppDelegate.h"
#import "Ingredient.h"

@implementation SkinScopeAppDelegate

@synthesize window, tabBarController, productSearchVC, shoppingListVC, apiObject;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Load in ingredient info from plist
    [self loadData];
    
    
    // Initialize the factual api object ...
    
    // ADD FACTUAL API KEY HERE
    apiObject = [[FactualAPI alloc] initWithAPIKey:@"FACTUAL-API-KEY-GOES-HERE"];
    
    
    // Create product search view controller
    productSearchVC = [[ProductSearchVC alloc] initWithStyle:UITableViewStylePlain];
    productSearchVC.title = @"Product Search";
    productSearchVC.ingredientInfo = self.ingredientInfo;
    
    // Create navigation controller for product search
    UINavigationController *productSearchNav = [[UINavigationController alloc] initWithRootViewController:productSearchVC];

    
    // Create shopping list view controller
    shoppingListVC = [[ShoppingListVC alloc] initWithStyle:UITableViewStylePlain];
    shoppingListVC.title = @"Shopping List";
    shoppingListVC.ingredientInfo = self.ingredientInfo;
    
    // Create navigation controller for shopping list
    UINavigationController *shoppingListNav = [[UINavigationController alloc] initWithRootViewController:shoppingListVC];
    
    
    // Create Tab Bar
    self.tabBarController = [[UITabBarController alloc] init];
    
    // Create tab bar items with titles and icons
    UITabBarItem *productSearch = [[UITabBarItem alloc] initWithTitle:@"Product Search" image:[UIImage imageNamed:@"productSearch.png"] tag:0];
    UITabBarItem *shoppingList = [[UITabBarItem alloc] initWithTitle:@"Shopping List" image:[UIImage imageNamed:@"shoppingList.png"] tag:0];
    
    // Link tab bar items with view controllers
    productSearchVC.tabBarItem = productSearch;
    shoppingListVC.tabBarItem = shoppingList;
    
    // Add view controllers to tab bar
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:productSearchNav, shoppingListNav, nil];
    self.window.rootViewController = self.tabBarController;
    

    [self.window makeKeyAndVisible];
    return YES;
}


+(FactualAPI *)getAPIObject{
    UIApplication *app = [UIApplication sharedApplication];
    return ((SkinScopeAppDelegate *)app.delegate).apiObject;
}


//load in ingredient information 
-(void)loadData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IngredientInfo" ofType:@"plist"];
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *tempArray = [tempDictionary objectForKey:@"ingredients"];
    
    self.ingredientInfo = [NSMutableArray array];

    for(id dict in tempArray){
        NSString *name = [dict objectForKey:@"name"];
        NSNumber *com = [dict objectForKey:@"com"];
        NSNumber *irr = [dict objectForKey:@"irr"];
        NSString *cat = [dict objectForKey:@"cat"];
        NSString *desc = [dict objectForKey:@"desc"];
        
        Ingredient *i = [[Ingredient alloc] initWithName:name com:com irr:irr cat:cat desc:desc];
        [self.ingredientInfo addObject:i];
    }
}







- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
