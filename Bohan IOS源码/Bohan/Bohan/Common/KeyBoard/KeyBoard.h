//
//  KeyBoard.h
//  Bohan
//
//  Created by summer on 2018/12/17.
//  Copyright © 2018 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    ZPKBTypeNumberPad = 1 << 0,
    ZPKBTypeDecimalPad = 1 << 1,
    ZPKBTypeASCIICapable = 1 << 2
} ZPKBType;
/*!
 *  @brief Dependency:Masonry framework
 */

@interface KeyBoard : UIView
/*!
 *  @brief create safe keyboard
 *
 *  @param type kb's type
 *
 *  @return the kb's instance
 */
+ (nonnull instancetype)keyboardWithType:(ZPKBType)type;

/*!
 *  @brief kb's icon logo to show user
 */
@property (nullable, nonatomic, copy) NSString *icon;

/*!
 *  @brief kb's title to show user
 */
@property (nonatomic, nullable, copy) NSString *enterprise;

/*!
 *  @brief such as UITextField,UITextView,UISearchBar
 */
@property (nonatomic, nullable, strong) UIView *inputSource;


@end

NS_ASSUME_NONNULL_END
