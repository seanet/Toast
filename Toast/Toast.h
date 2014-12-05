//
//  Toast.h
//  lingmiapp
//
//  Created by lmwl123 on 12/5/14.
//  Copyright (c) 2014 LingMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define TOAST_FONT_SIZE 15

#define TOAST_MARGIN_LEFT 5
#define TOAST_MARGIN_TOP 3

typedef enum{
    ToastDurationNormal, //1s
    ToastDurationLong, //3s
    ToastDurationShort //5s
}ToastDuration;

@interface Toast : NSObject

+(id)makeText:(NSString *)text;

//ToastDurationNormal && shown center
-(void)show;

//specify the duration && shown center
-(void)showWithDuration:(ToastDuration)duration;

//specify the loation,the region is (0,1] from top to bottom,if you assign it 0,it will be shown center
//ToastDurationNormal
-(void)showWithLocation:(CGFloat)location;

-(void)showWithLocation:(CGFloat)location duration:(ToastDuration)duration;

@end
