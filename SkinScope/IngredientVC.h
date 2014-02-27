//
//  IngredientVC.h
//  SkinScope
//
//  Created by Carla Crandall on 5/7/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ingredient.h"

@interface IngredientVC : UIViewController

@property (nonatomic,strong) Ingredient *ingredient;
@property (nonatomic,strong) IBOutlet UILabel *name; //ingredient name
@property (nonatomic,strong) IBOutlet UILabel *cat;  //category
@property (nonatomic,strong) IBOutlet UILabel *irr;  //irritancy rating
@property (nonatomic,strong) IBOutlet UILabel *com;  //comedogenicity rating
@property (nonatomic,strong) IBOutlet UILabel *desc; //description

@end
