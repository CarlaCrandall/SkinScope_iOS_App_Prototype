//
//  Ingredient.h
//  SkinScope
//
//  Created by Carla Crandall on 4/28/13.
//  Copyright (c) 2013 Carla Crandall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ingredient : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *com;  //comedogenic rating
@property (nonatomic,strong) NSNumber *irr;  //irritancy rating
@property (nonatomic,strong) NSString *cat;  //category
@property (nonatomic,strong) NSString *desc; //description

-(id)initWithName:(NSString *)i_name com:(NSNumber *)i_com irr:(NSNumber *)i_irr cat:(NSString *)i_cat desc:(NSString *)i_desc;

@end
