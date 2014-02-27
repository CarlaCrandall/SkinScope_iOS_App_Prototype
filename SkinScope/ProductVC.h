//
//  ProductVC.h
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>
#import "Product.h"

@interface ProductVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) Product *product;
@property (nonatomic,strong) IBOutlet UILabel *productName;
@property (nonatomic,strong) IBOutlet UILabel *brandName;
@property (nonatomic,strong) IBOutlet UILabel *rating;
@property (nonatomic,strong) IBOutlet UITableView *tableView;

- (IBAction)addToShoppingList:(id)sender;

@end
