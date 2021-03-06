//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Shinsaku Uesugi on 8/26/14.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene {
    CCSprite *_green;
    CCSprite *_blue;
}

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
}

- (void)update:(CCTime)delta {
    int rngX = (arc4random() % 5 - 2) * 25;
    int rngY = (arc4random() % 5 - 2) * 25;
    int rngX2 = (arc4random() % 5 - 2) * 25;
    int rngY2 = (arc4random() % 5 - 2) * 25;
    [_green.physicsBody applyImpulse:ccp(rngX, rngY)];
    [_blue.physicsBody applyImpulse:ccp(rngX2, rngY2)];
}

@end
