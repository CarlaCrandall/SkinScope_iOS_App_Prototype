//
//  ShoppingListVC.h
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *ingredientInfo; // ingredient information from plist
@property (nonatomic,strong) NSMutableArray *products;       // store product objects created from query results

-(void)updateList;

@end
