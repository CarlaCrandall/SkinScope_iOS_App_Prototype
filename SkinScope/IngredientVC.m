//
//  IngredientVC.m
//  SkinScope
//
//  Created by Carla Crandall on 5/7/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "IngredientVC.h"

@interface IngredientVC ()

@end

@implementation IngredientVC

@synthesize ingredient, name, cat, irr, com, desc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [ingredient name];
    
    name.text = [ingredient name];
    cat.text = [ingredient cat];
    irr.text = [NSString stringWithFormat:@"%@ / 5",[ingredient irr]];
    com.text = [NSString stringWithFormat:@"%@ / 5",[ingredient com]];
    desc.text = [ingredient desc];
    
    [desc sizeToFit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
