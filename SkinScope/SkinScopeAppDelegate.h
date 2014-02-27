//
//  SkinScopeAppDelegate.h
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>
#import "ProductSearchVC.h"
#import "ShoppingListVC.h"

@interface SkinScopeAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,strong) UIWindow *window;
@property (nonatomic,strong) UITabBarController *tabBarController;
@property (nonatomic,strong) ProductSearchVC *productSearchVC;
@property (nonatomic,strong) ShoppingListVC *shoppingListVC;
@property (nonatomic, readonly) FactualAPI *apiObject;
@property (nonatomic,strong) NSMutableArray *ingredientInfo;

+(FactualAPI *)getAPIObject;
- (void)loadData;

@end
