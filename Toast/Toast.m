//
//  Toast.m
//  lingmiapp
//
//  Created by lmwl123 on 12/5/14.
//  Copyright (c) 2014 LingMi. All rights reserved.
//

#import "Toast.h"

static NSMutableArray *toasts;

@implementation Toast{
    NSString *t;
    __weak UILabel *l;
    
    NSTimeInterval d;
    CGFloat loc;
}

-(id)initWithText:(NSString *)text{
    self=[super init];
    if(self){
        t=text;
        d=3;
    }
    
    return self;
}

-(id)init{
    @throw [NSException exceptionWithName:@"Toast Wrong initializer" reason:@"Use makeText instead" userInfo:nil];
    return nil;
}

+(id)makeText:(NSString *)text{
    return [[Toast alloc]initWithText:text];
}

-(void)show{
    NSArray *windows=[[UIApplication sharedApplication]windows];
    if(!windows.count) return;
        
    UIWindow *window=[windows objectAtIndex:0];

    for(id obj in window.subviews){
        if([obj isKindOfClass:[UILabel class]]){
            [UIView animateWithDuration:0.2 animations:^{
                [obj setAlpha:0];
            }completion:^(BOOL finished){
                [obj removeFromSuperview];
            }];
        }
    }
    
    UIFont *font=[UIFont systemFontOfSize:TOAST_FONT_SIZE];
    NSDictionary *attrDict=[[NSDictionary alloc]initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGRect wb=[window bounds];
    
    CGRect textRect=[t boundingRectWithSize:CGSizeMake(wb.size.width-20, wb.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrDict context:nil];
    
    CGFloat coordinateY=(wb.size.height-textRect.size.height)/2-TOAST_MARGIN_TOP;
    CGFloat height=textRect.size.height+2*TOAST_MARGIN_TOP;
    
    if(loc){
        CGFloat wholeHeight=wb.size.height-height;
        coordinateY=loc*wholeHeight;
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((wb.size.width-textRect.size.width)/2-TOAST_MARGIN_LEFT,coordinateY, textRect.size.width+2*TOAST_MARGIN_LEFT, height)];
    label.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    label.textColor=[UIColor whiteColor];
    label.font=font;
    label.text=t;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.shadowColor=[UIColor darkGrayColor];
    label.shadowOffset=CGSizeMake(1, 1);
    [label.layer setCornerRadius:4];
    [label setClipsToBounds:YES];
    
    label.alpha=0;
    [window addSubview:label];
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeToast)];
    [label addGestureRecognizer:tapGR];
    [label setUserInteractionEnabled:YES];
    
    l=label;
    
    if (!toasts)
        toasts=[[NSMutableArray alloc]init];
    
    [toasts removeAllObjects];
    [toasts addObject:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        label.alpha=1;
    }];
    
    NSMethodSignature *sig=[[self class]instanceMethodSignatureForSelector:@selector(removeToast)];
    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(removeToast)];
    
    [NSTimer scheduledTimerWithTimeInterval:d invocation:invocation repeats:NO];
}

-(void)showWithDuration:(ToastDuration)duration{
    switch (duration) {
        case ToastDurationNormal:
            d=3;
            break;
        case ToastDurationLong:
            d=5;
            break;
        case ToastDurationShort:
            d=1;
            break;
    }
    
    [self show];
}

-(void)showWithLocation:(CGFloat)location{
    if(location<0) loc=0;
    else if(location>1) loc=1;
    else loc=location;
    
    [self show];
}

-(void)showWithLocation:(CGFloat)location duration:(ToastDuration)duration{
    if(location<0) loc=0;
    else if(location>1) loc=1;
    else loc=location;
    
    [self showWithDuration:duration];
}

-(void)removeToast{
    [UIView animateWithDuration:0.5 animations:^{
        l.alpha=0;
    }completion:^(BOOL finished){
        [l removeFromSuperview];
        [toasts removeAllObjects];
    }];
}

@end
