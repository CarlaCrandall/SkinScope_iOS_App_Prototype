//
//  ProductSearchVC.h
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FactualSDK/FactualAPI.h>
#import <FactualSDK/FactualQuery.h>
#import "ZBarSDK.h"

@interface ProductSearchVC : UITableViewController <FactualAPIDelegate, UISearchBarDelegate, ZBarReaderDelegate>
{
    FactualAPIRequest *activeRequest;
    NSString *savedSearchTerm;
    int pageOffset;
    BOOL ranQuery;
}

@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSString *savedSearchTerm;
@property (nonatomic,strong) FactualQueryResult *queryResult;

@property (nonatomic,strong) NSMutableArray *ingredientInfo; // ingredient information from plist
@property (nonatomic,strong) NSMutableArray *products;       // store product objects created from query results

-(IBAction) doQuery:(id) sender;
-(IBAction) addScanner;
@end
