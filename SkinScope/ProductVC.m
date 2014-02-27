//
//  ProductVC.m
//  SkinScope
//
//  Created by Carla Crandall on 4/25/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "ProductVC.h"
#import "IngredientsListVC.h"
#import "Ingredient.h"

#define INGREDIENTS 0
#define IRRITANTS 1
#define COMEDOGENICS 2

@interface ProductVC ()

@end

@implementation ProductVC

@synthesize product, productName, brandName, rating, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [product name];
    
    //set back button text for detail view controllers
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    // set text for labels
    productName.text = [product name];    
    brandName.text = [product brand];
    rating.text = [product rating];
    
    
    // change the color of the rating
    if([[product rating] isEqualToString:@"Average"]){
        
        //average rating is orange text
        rating.textColor = [UIColor colorWithRed:(243/255.0) green:(156/255.0) blue:(18/255.0) alpha:1.0];
    }
    else if([[product rating] isEqualToString:@"Poor"]){
       
        //poor rating is red text
        rating.textColor = [UIColor colorWithRed:(192/255.0) green:(57/255.0) blue:(43/255.0) alpha:1.0];
    }
    else{
        //good rating is green text
        rating.textColor = [UIColor colorWithRed:(0/255.0) green:(115/255.0) blue:(60/255.0) alpha:1.0];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 3 rows - 1 each for ingredients, irritants, comedogenics
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    
    // table cell should contain label for the list (ingredients, irritants, comedogenics) and how many are ingredients are in the list
    switch(indexPath.row){
        case INGREDIENTS:
            cell.textLabel.text = @"Ingredients";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)",[[product ingredientObjs] count]];
            
            //only display disclosure indicator if the list actually contains ingredients
            if([[product ingredients] count] > 0){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
            
        case IRRITANTS:
            cell.textLabel.text = @"Irritants";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)",[[product irritants] count]];
            
            //only display disclosure indicator if the list actually contains ingredients
            if([[product irritants] count] > 0){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
            
        case COMEDOGENICS:
            cell.textLabel.text = @"Comedogenics";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%d)",[[product comedogenics] count]];
            
            //only display disclosure indicator if the list actually contains ingredients
            if([[product comedogenics] count] > 0){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
            
        default:
            NSLog(@"SHOULD NOT BE HERE!");
            break;
    }
        
    return cell;
}


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //user shouldn't be able to select the row if the list contains no ingredients
    switch(indexPath.row){
            
        case INGREDIENTS:
            if([[product ingredients] count] == 0){
                return nil;
            }
            break;
            
        case IRRITANTS:
            if([[product irritants] count] == 0){
                return nil;
            }
            break;
            
        case COMEDOGENICS:
            if([[product comedogenics] count] == 0){
                return nil;
            }
            break;
            
        default:
            NSLog(@"SHOULD NOT BE HERE!");
            break;
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *listType = @"";   //title for detail view controller
    NSArray *ingredientsData;   //array (list of ingredients) for detail view controller
    
    //set appropriate title and array for each section
    switch(indexPath.row){
        case INGREDIENTS:
            listType = @"Ingredients";
            ingredientsData = [product ingredientObjs];
            break;
        case IRRITANTS:
            listType = @"Irritants";
            ingredientsData = [product irritants];
            break;
        case COMEDOGENICS:
            listType = @"Comedogenics";
            ingredientsData = [product comedogenics];
            break;
        default:
            NSLog(@"SHOULD NOT BE HERE!");
            break;
    }
    
    //create detail view controller, set title, set array
    IngredientsListVC *ingredientsListVC = [[IngredientsListVC alloc] initWithNibName:nil bundle:nil];
    ingredientsListVC.title = listType;
    ingredientsListVC.ingredients = ingredientsData;
    
    //push view controller
    [self.navigationController pushViewController:ingredientsListVC animated:YES];
}


#pragma mark - Custom Methods

//add product to shopping list when user clicks on button
- (IBAction)addToShoppingList:(id)sender{
    
    //if product was added, show success message
    if([product addToShoppinglist]){
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Product was successfully added to your shopping list" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [success show];
    }
    //if product was not added, show error
    else{
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Product was not added to your shopping list" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [error show];
    }
}




@end
