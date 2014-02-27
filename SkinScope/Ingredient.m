//
//  Ingredient.m
//  SkinScope
//
//  Created by Carla Crandall on 4/28/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import "Ingredient.h"

@implementation Ingredient

@synthesize name, com, irr, cat, desc;

-(id)init{
    return [self initWithName:@"TBD" com:0 irr:0 cat:@"TBD" desc:@"TBD"];
}

-(id)initWithName:(NSString *)i_name com:(NSNumber *)i_com irr:(NSNumber *)i_irr cat:(NSString *)i_cat desc:(NSString *)i_desc{
    self = [super init];
    
    self.name = i_name;
    self.com = i_com;
    self.irr = i_irr;
    self.cat = i_cat;
    self.desc = i_desc;
    
    return self;
}

@end
