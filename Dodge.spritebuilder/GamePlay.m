//
//  GamePlay.m
//  Dodge
//
//  Created by Shinsaku Uesugi on 8/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay {
    CCPhysicsNode *_physicsNode;
    
    CCSprite *_green;
    CCSprite *_blue;
    
    CCLabelTTF *_scoreLabel;
    int _score;
    
    CCLabelTTF *_moveGreen;
    CClabelTTf *_moveBlue;
}

- (void)onEnter {
    [super onEnter];
    
    self.userInteractionEnabled = true;
    _physicsNode.collisionDelegate = self;
    
    _score = 0;
    
    // listen for swipes to the left
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    // listen for swipes to the right
    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    // listen for swipes up
    UISwipeGestureRecognizer * swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
    // listen for swipes down
    UISwipeGestureRecognizer * swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeDown];
    
    [self schedule:@selector(spawnShurikenTop) interval:1.5f];
    //[self schedule:@selector(spawnShurikenBot) interval:1.5f];
    
    [self schedule:@selector(timer) interval:1.f];
}

- (void)spawnShurikenTop {
    CCSprite *shuriken = (CCSprite *)[CCBReader load:@"Shuriken"];
    shuriken.positionType = CCPositionTypeNormalized;
    int rng = arc4random() % 4;

    switch (rng) {
        case 0:
            shuriken.position = ccp(1, _green.position.y);
            break;
        case 1:
            if (_green.position.y == 0.05) {
                shuriken.position = ccp(1, _green.position.y + 0.2);
            } else {
                shuriken.position = ccp(1, _green.position.y - 0.1);
            }
            break;
        case 2:
            if (_green.position.y == 0.45) {
                shuriken.position = ccp(1, _green.position.y - 0.2);
            } else {
                shuriken.position = ccp(1, _green.position.y + 0.1);
            }
            break;
        default:
            shuriken.position = ccp(1, _green.position.y);
    }
    
    [_physicsNode addChild:shuriken];
    [shuriken.physicsBody applyAngularImpulse:900];
    shuriken.physicsBody.velocity = ccp(-200,0);
}

- (void)spawnShurikenBot {
    CCSprite *shuriken = (CCSprite *)[CCBReader load:@"Shuriken"];
    shuriken.positionType = CCPositionTypeNormalized;
    int rng = arc4random() % 4;
    
    switch (rng) {
        case 0:
            shuriken.position = ccp(_blue.position.x, 0.475);
            break;
        case 1:
            if (_blue.position.x == 0.9) {
                shuriken.position = ccp(_blue.position.x - 0.4, 0.475);
            } else {
                shuriken.position = ccp(_blue.position.x + 0.2, 0.475);
            }
            break;
        case 2:
            if (_blue.position.x == 0.1) {
                shuriken.position = ccp(_blue.position.x + 0.4, 0.475);
            } else {
                shuriken.position = ccp(_blue.position.x - 0.2, 0.475);
            }
            break;
        default:
           shuriken.position = ccp(_blue.position.x, 0.475);
    }
    [_physicsNode addChild:shuriken];
    [shuriken.physicsBody applyAngularImpulse:900];
    shuriken.physicsBody.velocity = ccp(0,-100);
}

- (void)swipeLeft {
    if (_blue.position.x - 0.2 > 0.1) {
        _blue.position = ccp(_blue.position.x - 0.2, _blue.position.y);
    }
}
- (void)swipeRight {
    if (_blue.position.x + 0.2 < 0.9) {
        _blue.position = ccp(_blue.position.x + 0.2, _blue.position.y);
    }
}
- (void)swipeDown {
    if (_green.position.y - 0.1 > 0.55) {
        _green.position = ccp(_green.position.x, _green.position.y - 0.1);
    }
}
- (void)swipeUp {
    if (_green.position.y + 0.1 < 0.95) {
        _green.position = ccp(_green.position.x, _green.position.y + 0.1);
    }
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair green:(CCSprite *)balloon shuriken:(CCSprite *)shuriken {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair blue:(CCSprite *)balloon shuriken:(CCSprite *)shuriken {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shuriken:(CCSprite *)shuriken ground:(CCNode *)ground {
    [shuriken removeFromParent];
    
    return TRUE;
}

- (void)timer {
    _score++;
    _scoreLabel.string = [NSString stringWithFormat:@"%i", _score];
}

@end
