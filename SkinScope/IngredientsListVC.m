//
//  IngredientsListVC.m
//  SkinScope
//
//  Created by Carla Crandall on 4/27/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "IngredientsListVC.h"
#import "IngredientVC.h"

@interface IngredientsListVC ()

@end

@implementation IngredientsListVC

@synthesize ingredients;

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

    //self.title = @"Ingredients";
    
    //set back button text for detail view controllers
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ingredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *noDataIdentifier = @"NoDataCell";
    
    // check the irritancy rating -  if irritancy rating = -1, no data is known for the ingredient
    // only display cell accessory for ingredients with data
    if([[[ingredients objectAtIndex:indexPath.row] irr] intValue] != -1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [[ingredients objectAtIndex:indexPath.row] name];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noDataIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:noDataIdentifier];
        }
        
        cell.textLabel.text = [[ingredients objectAtIndex:indexPath.row] name];
        return cell;
    }
    
    return nil;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // check the irritancy rating -  if irritancy rating = -1, no data is known for the ingredient
    if([[[ingredients objectAtIndex:indexPath.row] irr] intValue] == -1){
        
        //no data available, display alert
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"" message:@"There is currently no information available for this ingredient" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [success show];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES]; // deselect the cell
        
    }
    // only display detailVC for ingredients with data
    else{
        IngredientVC *ingredientVC = [[IngredientVC alloc] initWithNibName:nil bundle:nil];
        ingredientVC.ingredient = [ingredients objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:ingredientVC animated:YES];
    }
}

@end
