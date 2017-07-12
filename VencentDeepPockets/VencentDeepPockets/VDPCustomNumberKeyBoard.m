//
//  VDPCustomNumberKeyBoard.m
//  VencentDeepPockets
//
//  Created by hankai on 2017/6/15.
//  Copyright © 2017年 Vencent. All rights reserved.
//

#import "VDPCustomNumberKeyBoard.h"

@interface VDPCustomNumberKeyBoard ()
@property (nonatomic, strong) NSArray *numArray;
@property (nonatomic, strong) NSMutableArray *btnMutArr;

@end


@implementation VDPCustomNumberKeyBoard

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){

        self.backgroundColor = [UIColor clearColor];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        self.frame = CGRectMake(0, SCREEN_HEIGHT + 213, SCREEN_WIDTH, 213);
        [self p_createKeyBoardView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

+(instancetype)shareNumberKeyBoard{
    static VDPCustomNumberKeyBoard *tempNumberKeyBoard = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!tempNumberKeyBoard) {
            tempNumberKeyBoard = [[self alloc]initWithFrame:CGRectZero];
        }
    });
    return tempNumberKeyBoard;
}


- (void)p_createKeyBoardView{
    self.numArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableArray *tempMutNumArr = [NSMutableArray arrayWithArray:self.numArray];
    
    int row = 4;
    int column = 3;
    CGFloat keyWidth = self.frame.size.width / column;
    CGFloat keyHeight = self.frame.size.height / row;
    CGFloat lineW = self.frame.size.width;
    CGFloat lineH = self.frame.size.height;
    
    
    self.btnMutArr = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i %column * keyWidth, i / column *keyHeight, keyWidth, keyHeight)];
        button.tag = i;
        [button setBackgroundImage:[self p_imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        [self.btnMutArr addObject:button];
        
        
        
        if (i == 9 || i == 11) {
            button.backgroundColor = [UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1];
            [button setBackgroundImage:[self p_imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            if (i == 9) {
                [button setTitle:@"删除" forState:UIControlStateNormal];
            }else{
                [button setTitle:@"完成" forState:UIControlStateNormal];
                
            }
        }else{
            button.backgroundColor = [UIColor whiteColor];
            [button setBackgroundImage:[self p_imageWithColor:[UIColor colorWithRed:0.82 green:0.84 blue:0.85 alpha:1]] forState:UIControlStateHighlighted];
            int loc = arc4random_uniform((int)tempMutNumArr.count);
            [button setTitle:[tempMutNumArr objectAtIndex:loc]forState:UIControlStateNormal];
            [tempMutNumArr removeObjectAtIndex:loc];
        }
        
        
        for (int i = 0 ;i < row - 1; i++) {
            UIView *lineView = [UIView new];
            lineView.frame = CGRectMake(0, keyHeight *(i + 1), lineW, 0.5);
            lineView.backgroundColor = [UIColor blackColor];
            [self addSubview:lineView];
        }
        
        for (int i = 0; i < column - 1; i++) {
            UIView *lineView = [UIView new];
            lineView.frame = CGRectMake(keyWidth *(i + 1), 0, 0.5, lineH);
            lineView.backgroundColor = [UIColor blackColor];
            [self addSubview:lineView];
        }
        
    }
}

-(void)keyBoardWillShow:(NSNotification *)notification{
    NSMutableArray *tempMutNumArr = [NSMutableArray arrayWithArray:self.numArray];
    for (int i = 0; i<self.btnMutArr.count; i++) {
        if (i == 9 || i == 11) continue;
        
        UIButton *tempBtn = (UIButton *)self.btnMutArr[i];
        int loc = arc4random_uniform((int)tempMutNumArr.count);
        [tempBtn setTitle:[tempMutNumArr objectAtIndex:loc]forState:UIControlStateNormal];
        [tempMutNumArr removeObjectAtIndex:loc];
    }
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 11) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        return;
    }
    if (self.completeBlock) {
        self.completeBlock(btn.titleLabel.text,btn.tag);
    }
}

-(UIImage *)p_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
