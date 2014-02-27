//
//  Product.m
//  SkinScope
//
//  Created by Carla Crandall on 5/7/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "Product.h"
#import "Ingredient.h"

@implementation Product

@synthesize name, brand, rating, relevance, ingredients, ingredientObjs, irritants, comedogenics, ingredientInfo;


- (id)initWithName:(NSString *)p_name brand:(NSString *)p_brand ingredients:(NSMutableArray *)p_ingredients ingredientInfo:(NSMutableArray *)p_ingredientInfo relevance:(int)p_relevance{
    
    self = [super init];
    
    // set properties
    if(self){
        name = p_name;
        brand = p_brand;
        ingredients = p_ingredients;
        ingredientInfo = p_ingredientInfo;
        relevance = p_relevance;
    }
    
    // find out how many irritants and comedogenics are in the product
    [self analyzeIngredients];
    
    return self;
}


// loop through all ingredients and figure out how many possible irritants/comedogenics they are
// save possible irritants and comedogenics to arrays
-(void)analyzeIngredients{
    
    //init arrays
    ingredientObjs = [NSMutableArray array];
    irritants = [NSMutableArray array];
    comedogenics = [NSMutableArray array];
    
    //loop through product ingredients
    for(int i = 0; i<[ingredients count]; i++)
    {        
        //loop through the ingredients in the plist
        for(int j= 0; j<[ingredientInfo count]; j++)
        {
            
            //do the ingredient names match?
            if([ [ingredients objectAtIndex:i] isEqualToString:[[ingredientInfo objectAtIndex:j] name] ])
            {
                
                //names match - add ingredient object to array
                [ingredientObjs addObject:[ingredientInfo objectAtIndex:j]];
                
                //check irritancy rating
                if([[[ingredientInfo objectAtIndex:j] valueForKey:@"irr"] intValue] > 0){
                    
                    //if ingredient is a potential irritant, add the object to the irritants array
                    [irritants addObject:[ingredientInfo objectAtIndex:j]];
                }
                
                //check comedogenic rating
                if([[[ingredientInfo objectAtIndex:j] valueForKey:@"com"] intValue] > 0){
                    
                    //if ingredient is a potential comedogenic, add the object to the comedogenics array
                    [comedogenics addObject:[ingredientInfo objectAtIndex:j]];
                }
                
                break;
            }
            else{
                if(j == [ingredientInfo count]-1){
                    //ingredient is not in plist, create a new object and add it to the array
                    Ingredient *ingredient = [[Ingredient alloc] initWithName:[ingredients objectAtIndex:i] com:[NSNumber numberWithInt:-1] irr:[NSNumber numberWithInt:-1] cat:@"Unknown" desc:@"Not Available"];
                    [ingredientObjs addObject:ingredient];
                }
            }
            
        }//end inner for loop
        
    }//end outer for loop
    
    //create product rating based on irritancy and comedogenicty ratings of the ingredients
    [self createRating];
}

// give the product a rating based on irritating/comedogenic it is
-(void)createRating{
    
    int irr = 0; // store total irritancy of product
    int com = 0; // store total comedogenicity of product
    
    // loop through all irritants and add up the ratings to get total
    for(int i = 0; i < [irritants count]; i++){
        irr += [[[irritants objectAtIndex:i] irr] intValue];
    }
    
    // loop through all comedogenics and add up the ratings to get total
    for(int i = 0; i < [comedogenics count]; i++){
        com += [[[comedogenics objectAtIndex:i] com] intValue];
    }
    
    // get total by adding the irritancy and comedogenicty together
    int numRating = irr + com;
    
    
    //if total is less than 5, product receives a good rating
    if(numRating <= 5){
        rating = @"Good";
    }
    //if total is between 5 and 10, product receives an average rating
    else if(numRating <= 10){
        rating = @"Average";
    }
    //if total is more than 10, product receives a poor rating
    else{
        rating = @"Poor";
    }
    
    // NOTE: This is an overly simplistic way of rating products, 
    //       but I don't know enough of the science behind skincare to create a more complex rating system
}


//add product to shopping list - called when user clicks button
-(BOOL)addToShoppinglist{
    
    BOOL added = NO;
    
    //get user defaults
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"shoppinglist"]];
    
    NSArray *productArray;
    
    //check to see if ingredients array is empty
    if([ingredients count] == 0){
        
        //if no ingredients are listed, create an empty array
        //this prevents an exception that kept occurring when trying to load a product in the shopping list that has no ingredient information
        productArray = [NSArray arrayWithObjects:name,brand,[NSArray array], nil];
    }
    else{
        productArray = [NSArray arrayWithObjects:name,brand,ingredients, nil];
    }
    
    
    //check to see if product is already on the shopping list
    if(![array containsObject:productArray]){
        
        //if not already on shopping list, add to array
        [array addObject:productArray];
        added = YES;
    }
    
    //set user defaults
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"shoppinglist"];

    return added;
}


//remove product from shopping list
-(void)removeFromShoppingList{
        
    //get user defaults
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"shoppinglist"]];
    
    NSArray *productArray;
    
    productArray = [NSArray arrayWithObjects:name,brand,ingredients, nil];
    
    //look for and remove product from array
    [array removeObject:productArray];
        
    //set user defaults
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"shoppinglist"];
}

@end
