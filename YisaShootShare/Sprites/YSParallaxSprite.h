//
//  YSBasicSprite.h
//  yisaShoot
//
//  Created by wangcheng on 14-7-10.
//  Copyright (c) 2014年 W.C. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface YSParallaxSprite : SKSpriteNode

@property (nonatomic) BOOL usesParallaxEffect;
@property (nonatomic) CGFloat virtualZRotation;

/**
 *  以该方法初始化的精灵将具有视差效果
 *
 *  @param sprites <#sprites description#>
 *  @param offset  <#offset description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithSprites:(NSArray *)sprites usingOffset:(CGFloat)offset;

- (void)updateOffset;

@end
