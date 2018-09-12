//
//  ListDataCell.h
//  PerfectTableVIew
//
//  Created by Yang,Dongzheng on 2018/9/12.
//  Copyright © 2018年 Yang,Dongzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListDataCell : UITableViewCell

@property (nonatomic, assign) BOOL cellCanScroll;
@property (nonatomic, copy) void(^enableScrollCallback)(void);

@end
