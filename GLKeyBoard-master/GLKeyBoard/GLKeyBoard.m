//
//  GLKeyBoard.m
//  GLKeyBoard
//
//  Created by 高磊 on 2017/5/27.
//  Copyright © 2017年 高磊. All rights reserved.
//

#import "GLKeyBoard.h"

#import <Masonry.h>

static CGFloat const kKeyBoardWidth = 33;
static CGFloat const kKeyBoardHeight = 35;

static CGFloat const kKeyBoardBigWidth = 41;


static CGFloat const kKeyBoardTopPadding = 5;
static CGFloat const kKeyBoardMiddlePadding = 35/9.0;
static CGFloat const kKeyBoardBottomMiddlePadding = 17/5.0;

static NSInteger const kKeyBoardTag = 1200;
static NSInteger const kKeyBoardNumber = 26;//键数量

/**
 *  颜色16进制
 */
#define UICOLOR_FROM_RGB_OxFF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GLKeyBoard () {
    UIButton *  _lastButton;//布局时保存按钮
}
@property (nonatomic, strong) NSArray *normalKeyboardArray;
@property (nonatomic, strong) NSArray *changeKeyboardArray;
@property (nonatomic, strong) NSArray *numberKeyboardArray;

@property (nonatomic, strong) NSMutableArray *keyboardArray;
@property (nonatomic, assign) BOOL isChangeKeyboard;
@property (nonatomic, assign) BOOL isChangeNumber;

@end

@implementation GLKeyBoard

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isChangeKeyboard = NO;
        _isChangeNumber = NO;
        _changeKeyboardArray = @[@"ᠴ",@"ᠸ",@"ᡝ",@"ᡵ",@"ᡨ",@"ᠶ",@"ᡠ",@"ᡳ",@"ᠣ",@"ᡦ",
                                 @"ᠠ",@"ᠰ",@"ᡩ",@"ᡶ",@"ᡤ",@"ᡥ",@"ᠵ",@"ᡴ",@"ᠯ",
                                 @"⇧",@"ᡯ",@"ᡧ",@"ᡮ",@"ᡡ",@"ᠪ",@"ᠨ",@"ᠮ",@"⬅︎",
                                 @"123",@"空格",@"发送",];
        _numberKeyboardArray= @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",
                                @"“",@"‘",@"?",@"!",@"(",@")",@"《",@"》",@"：",
                                @"⇧",@"...",@"?!",@"-",@"[",@"]",@"{",@"}",@"⬅︎",
                                @"123",@"空格",@"发送",];
        _normalKeyboardArray= @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",
                                @"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",
                                @"⇧",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"⬅︎",
                                @"123",@"空格",@"发送",];
        
        _keyboardArray = [[NSMutableArray alloc] initWithArray:_normalKeyboardArray];
        [self initializeViewComponents];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
       
        [self initializeViewComponents];

    }
    return self;
}


#pragma mark == private method
- (void)initializeViewComponents {
    self.backgroundColor =UICOLOR_FROM_RGB_OxFF(0xbfc5ca);
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
//    NSArray *array = @[@"ᠴ",@"ᠸ",@"ᡝ",@"ᡵ",@"ᡨ",@"ᠶ",@"ᡠ",@"ᡳ",@"ᠣ",@"ᡦ",
//                       @"ᠠ",@"ᠰ",@"ᡩ",@"ᡶ",@"ᡤ",@"ᡥ",@"ᠵ",@"ᡴ",@"ᠯ",
//                       @"⇧",@"ᡯ",@"ᡧ",@"ᡮ",@"ᡡ",@"ᠪ",@"ᠨ",@"ᠮ",@"⬅︎",
//                       @"123",@"空格",@"发送",];
//    NSArray *array = @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",
//                       @"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",
//                       @"⇧",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"⬅︎",
//                       @"123",@"空格",@"发送",];
    for (int i = 0; i < _keyboardArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.titleLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
//        button.titleLabel.backgroundColor = [UIColor redColor];
        button.tag = kKeyBoardTag + i;
        [button setBackgroundColor:UICOLOR_FROM_RGB_OxFF(0xfefefe)];
        [button setTitleColor:UICOLOR_FROM_RGB_OxFF(0x303030) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        button.layer.cornerRadius = 5;
        [button.layer setMasksToBounds:YES];
        
        [button setTitle:_keyboardArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(keyBoardClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == 0) {
            //@"q"
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding)));
                make.left.equalTo(self.mas_left).offset(GTReViewXFloat(5));
            }];
            _lastButton = button;
        }else if(i < 10){
            //@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding)));
                make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding));
            }];
            _lastButton = button;
        }
        
        if (i == 10) {
            //@"a"
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding +kKeyBoardHeight +10)));
                make.left.equalTo(self.mas_left).offset(GTReViewXFloat(25));
            }];
            _lastButton = button;
        }else if( i > 10 && i < 19){
            //@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding + kKeyBoardHeight +10)));
                make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding));
            }];
            _lastButton = button;
        }
        
        if (i == 19) {
            //箭头 @"⇧",
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding +kKeyBoardHeight*2 +20)));
                make.left.equalTo(self.mas_left).offset(GTReViewXFloat(5));
            }];
            button.backgroundColor = [UIColor grayColor];
            _lastButton = button;
        }else if( i > 19 && i < 28){
            //@"z",@"x",@"c",@"v",@"b",@"n",@"m",
            if (i == 20) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                    make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding + kKeyBoardHeight*2 +20)));
                    make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding +20));
                }];
            }else if (i == 27) {
                //@"⬅︎",
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                    make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding + kKeyBoardHeight*2 +20)));
                    make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding +20));
                }];
                button.backgroundColor = [UIColor grayColor];
            }else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(kKeyBoardWidth), GTReViewXFloat(kKeyBoardHeight)));
                    make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding + kKeyBoardHeight*2 +20)));
                    make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding));
                }];
            }
            
            _lastButton = button;
        }
        
        if (i == 28) {
            //@"123",
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(85), GTReViewXFloat(kKeyBoardHeight)));
                make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding +kKeyBoardHeight*3 +30)));
                make.left.equalTo(self.mas_left).offset(GTReViewXFloat(5));
            }];
            button.backgroundColor = [UIColor grayColor];
            _lastButton = button;
        }else if( i > 28 && i < 31){
            if (i == 29) {
                //@"空格",
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(180), GTReViewXFloat(kKeyBoardHeight)));
                    make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding + kKeyBoardHeight*3 +30)));
                    make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding));
                }];
            }else if (i == 30) {
                //@"发送",
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(GTReViewXFloat(85), GTReViewXFloat(kKeyBoardHeight)));
                    make.top.equalTo(@(GTReViewXFloat(kKeyBoardTopPadding + kKeyBoardHeight*3 +30)));
                    make.left.equalTo(_lastButton.mas_right).offset(GTReViewXFloat(kKeyBoardMiddlePadding));
                }];
                button.backgroundColor = [UIColor blueColor];

            }
            
            _lastButton = button;
        }
    }
    
    

}

- (void)keyBoardClick:(UIButton *)sender
{
    NSInteger tag = sender.tag - kKeyBoardTag;
    switch (tag) {
        case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:case 9:
        case 10:case 11:case 12:case 13:case 14:case 15:case 16:case 17:case 18:
        case 20:case 21:case 22:case 23:case 24:case 25:case 26:
        {
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardOther, sender.currentTitle);
            }
        }
            break;
        case 19:{//Shift 切换大小写
            
            if (!_isChangeNumber) {
                // 已经切换了数字键盘，大小写不让切换
                if (!_isChangeKeyboard) {
                    _keyboardArray = [[NSMutableArray alloc] initWithArray:_changeKeyboardArray];
                }else {
                    _keyboardArray = [[NSMutableArray alloc] initWithArray:_normalKeyboardArray];
                }
                _isChangeKeyboard = !_isChangeKeyboard;
                [self initializeViewComponents];
            }
            
        }
            break;
        case 27:{//退格键 也是删除键
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardDelete, sender.currentTitle);
            }
        }
            break;
        case 28:{//123 切换数字键
            if (!_isChangeNumber) {
                _keyboardArray = [[NSMutableArray alloc] initWithArray:_numberKeyboardArray];
            }else {
                _keyboardArray = [[NSMutableArray alloc] initWithArray:_normalKeyboardArray];
            }
            _isChangeNumber = !_isChangeNumber;
            [self initializeViewComponents];
            
        }
            break;
        case 29:{//空格键
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardOther, @" ");
            }
        }
            break;
        case 30:{//发送键
            if (self.keyBoardClickBlock) {
                self.keyBoardClickBlock(GLKeyBoardClearAll, sender.currentTitle);
            }
        }
            break;
        default:
            break;
    }
}
@end
