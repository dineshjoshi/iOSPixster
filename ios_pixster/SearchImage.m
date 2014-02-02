//
//  SearchImage.m
//  pixster
//
//  Created by Dinesh Joshi on 2/2/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "SearchImage.h"

@implementation SearchImage

+(id)initWithJSONArray:(NSArray *)initArray
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:initArray.count];
    
//    for(int i=0; i < initArray.count; i++) {
//        SearchImage *tmpImg = [[SearchImage alloc] init];
//        tmpImg.imgUrl = [NSURL URLWithString:[[initArray objectAtIndex:i] objectForKey:@"tbUrl"]];
//        tmpImg.width = [[[initArray objectAtIndex:i] objectForKey:@"tbWidth"] integerValue];
//        tmpImg.height = [[[initArray objectAtIndex:i] objectForKey:@"tbHeight"] integerValue];
//        [arr addObject:tmpImg];
//    }
//
    
    arr = [SearchImage addImagesFromJSONArray:arr addArray:initArray];
    return arr;
}

+(id) addImagesFromJSONArray: (NSMutableArray *) imgArray addArray: (NSArray *) addArray
{
    
    for(int i=0; i < addArray.count; i++) {
        SearchImage *tmpImg = [[SearchImage alloc] init];
        tmpImg.imgUrl = [NSURL URLWithString:[[addArray objectAtIndex:i] objectForKey:@"tbUrl"]];
        tmpImg.width = [[[addArray objectAtIndex:i] objectForKey:@"tbWidth"] integerValue];
        tmpImg.height = [[[addArray objectAtIndex:i] objectForKey:@"tbHeight"] integerValue];
        NSLog(@"tbUrl: %@ w: %d h: %d ", tmpImg.imgUrl, tmpImg.width, tmpImg.height);
        [imgArray addObject:tmpImg];
    }
    
    return imgArray;
}

@end
