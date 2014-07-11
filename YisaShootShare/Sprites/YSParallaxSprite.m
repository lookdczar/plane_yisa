//
//  YSBasicSprite.m
//  yisaShoot
//
//  Created by wangcheng on 14-7-10.
//  Copyright (c) 2014年 W.C. All rights reserved.
//

#import "YSParallaxSprite.h"

@interface YSParallaxSprite ()
@property (nonatomic) CGFloat parallaxOffset;
@end

@implementation YSParallaxSprite

#pragma mark - 初始化
- (id)initWithSprites:(NSArray *)sprites usingOffset:(CGFloat)offset {
    self = [super init];
    
    if (self) {
        _usesParallaxEffect = YES;
        
        // 确保数组中的精灵每个都自己一个层。该系数用于确定每个精灵位于的zPosition
        CGFloat zOffset = 1.0f / (CGFloat)[sprites count];
        
        // All nodes in the stack are direct children, with ordered zPosition.
        CGFloat ourZPosition = self.zPosition;
        NSUInteger childNumber = 0;
        for (SKNode *node in sprites) {
            node.zPosition = ourZPosition + (zOffset + (zOffset * childNumber));
            [self addChild:node];
            childNumber++;
        }
        
        _parallaxOffset = offset;
    }
    
    return self;
}

#pragma mark - Copying
- (id)copyWithZone:(NSZone *)zone {
    YSParallaxSprite *sprite = [super copyWithZone:zone];
    if (sprite) {
        sprite->_parallaxOffset = self.parallaxOffset;
        sprite->_usesParallaxEffect = self.usesParallaxEffect;
    }
    return sprite;
}

#pragma mark - Rotation and Offsets
- (void)setZRotation:(CGFloat)rotation {
    // Override to apply the zRotation just to the stack nodes, but only if the parallax effect is enabled.
    if (!self.usesParallaxEffect) {
        [super setZRotation:rotation];
        return;
    }
    
    if (rotation > 0.0f) {
        self.zRotation = 0.0f; // never rotate the group node
        
        // 不改变节点的角度，只改变子节点的角度
        for (SKNode *child in self.children) {
            child.zRotation = rotation;
        }
        
        self.virtualZRotation = rotation;
    }
}

- (void)updateOffset {
    SKScene *scene = self.scene;
    SKNode *parent = self.parent;
    
    if (!self.usesParallaxEffect || parent == nil) {
        return;
    }
    //确定自己在场景中的坐标
    CGPoint scenePos = [scene convertPoint:self.position fromNode:parent];
    
    // 位移的放线和本节点相对于场景中心的方向一致
    CGFloat offsetX =  (-1.0f + (2.0 * (scenePos.x / scene.size.width)));
    CGFloat offsetY =  (-1.0f + (2.0 * (scenePos.y / scene.size.height)));
    //parallaxOffset是整个节点所有子节点的位移（或者理解为最上层的子节点的位移），除以子节点的数量则是每个子节点的位移
    //效果就是 最上层的节点位移最大，下层的位移小。形成视差效果
    CGFloat delta = self.parallaxOffset / (CGFloat)self.children.count;
    
    int childNumber = 0;
    for (SKNode *node in self.children) {
        node.position = CGPointMake(offsetX*delta*childNumber, offsetY*delta*childNumber);
        childNumber++;
    }
}
@end
