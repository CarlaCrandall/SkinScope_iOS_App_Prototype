//
//  Product.h
//  SkinScope
//
//  Created by Carla Crandall on 5/7/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *brand;  
@property (nonatomic,strong) NSString *rating;
@property (nonatomic,assign) int relevance;

@property (nonatomic,strong) NSMutableArray *ingredients;         //list of product ingredients - names ONLY (from query result)
@property (nonatomic,strong) NSMutableArray *ingredientObjs;      //list of product ingredient objects
@property (nonatomic,strong) NSMutableArray *ingredientInfo;      //information for 200+ common skincare ingredients (from plist)
@property (nonatomic,strong) NSMutableArray *irritants;           //list of potential irritants in product
@property (nonatomic,strong) NSMutableArray *comedogenics;        //list of potential comedogenics in product


- (id)initWithName:(NSString *)p_name brand:(NSString *)p_brand ingredients:(NSMutableArray *)p_ingredients ingredientInfo:(NSMutableArray *)p_ingredientInfo relevance:(int)p_relevance;

-(void)analyzeIngredients;     //figure out how many irritants and comedogenics are in the product
-(void)createRating;           //create a rating based on how irritating/comedogenic the product is
-(BOOL)addToShoppinglist;      //add the product to shopping list
-(void)removeFromShoppingList; //remove the product from the shopping list

@end
