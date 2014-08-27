//
//  Recap.m
//  Dodge
//
//  Created by Shinsaku Uesugi on 8/27/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Recap.h"

@implementation Recap {
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_highscoreLabel;
    
    CCSprite *_green;
    CCSprite *_blue;
}

- (void)onEnter {
    [super onEnter];
    
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    
    _scoreLabel.string = [NSString stringWithFormat:@"%li", (long)[gameState integerForKey:@"score"]];
    _highscoreLabel.string = [NSString stringWithFormat:@"%li", (long)[gameState integerForKey:@"highscore"]];
}

- (void)again {
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
