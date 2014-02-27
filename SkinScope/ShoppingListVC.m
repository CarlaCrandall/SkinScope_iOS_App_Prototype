//
//  ShoppingListVC.m
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "ShoppingListVC.h"
#import "Product.h"
#import "ProductVC.h"

@interface ShoppingListVC ()

@end

@implementation ShoppingListVC

@synthesize products, ingredientInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set back button text for detail view controllers
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    //add edit/done button to top right of navigation bar
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
    
    //get list of saved products to display
    [self updateList];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // num rows = num products
    return [products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    
    //get product - title = product name, subtitle = product brand
    Product *product = [products objectAtIndex:indexPath.row];
    cell.textLabel.text = [product name];
    cell.detailTextLabel.text = [product brand];
    
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //get product
        Product *product = [products objectAtIndex:indexPath.row];
        
        //remove product from shopping list
        [product removeFromShoppingList];
        
    }
    
    // update the list and reload table view ..
    [self updateList];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (products != nil) {
        
        // get product
        Product *product = [products objectAtIndex:indexPath.row];
        
        // create detail view controller
        ProductVC *productVC = [[ProductVC alloc] initWithNibName:nil bundle:nil];
        productVC.product = product;
        
        // push view controller
        [self.navigationController pushViewController:productVC animated:YES];
    }
    
}


#pragma mark - Custom Methods


// update list of saved products
-(void)updateList{
    
    // init array
    products = [NSMutableArray array];
    
    // get user defaults
    NSMutableArray *shoppingList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"shoppinglist"]];
    
    // loop through the products in the shoppingList
    for(id item in shoppingList){
        
        // get product data
        NSString *name = [item objectAtIndex:0];
        NSString *brand = [item objectAtIndex:1];
        NSMutableArray *ingredients = [item objectAtIndex:2];
        
        // create product
        Product *product = [[Product alloc] initWithName:name brand:brand ingredients:ingredients ingredientInfo:self.ingredientInfo relevance:-1];
        
        //add to array
        [products addObject:product];
    }
    
    [self.tableView reloadData];
}

@end
