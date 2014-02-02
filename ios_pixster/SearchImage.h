//
//  SearchImage.h
//  pixster
//
//  Created by Dinesh Joshi on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchImage : NSObject

@property (nonatomic, strong) NSURL *imgUrl;
@property (nonatomic) NSUInteger width;
@property (nonatomic) NSUInteger height;

+(id) initWithJSONArray:(NSArray *)initArray;
+(id) addImagesFromJSONArray: (NSMutableArray *) imgArray addArray: (NSArray *) addArray;
@end
