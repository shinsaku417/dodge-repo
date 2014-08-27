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
    
    BOOL _firstTop;
    BOOL _firstBot;
    
    CCLabelTTF *_moveGreen;
    CCLabelTTF *_moveBlue;
    
    CCNodeColor *_coverBot;
    
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    
    BOOL _doubleTop;
    
    BOOL _tutorial;
    BOOL _both;
    
    CCLabelTTF *_moveBoth;
}

- (void)onEnter {
    [super onEnter];
    
    self.userInteractionEnabled = true;
    _physicsNode.collisionDelegate = self;
    
    _score = 0;
    _tutorial = true;
    _both = false;
    _firstTop = true;
    _firstBot = true;
    _doubleTop = false;
    
    // Swipe Up
    _swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];
    
    // Swipe Down
    _swipeDown= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];
    
    // Swipe Right
    _swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // Swipe Left
    _swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
}

- (void)spawnShurikenTop {
    CCSprite *shuriken = (CCSprite *)[CCBReader load:@"Shuriken"];
    shuriken.positionType = CCPositionTypeNormalized;
    
    if (_firstTop) {
        shuriken.position = ccp(1, _green.position.y);
        _firstTop = false;
    } else {
        int rng = arc4random() % 6;
        if (0 <= rng <= 3) {
            shuriken.position = ccp(1, _green.position.y);
        }
        if (rng == 4) {
            if (_green.position.y + 0.1 >= 1.04) {
                shuriken.position = ccp(1, _green.position.y - 0.2);
            } else {
                shuriken.position = ccp(1, _green.position.y + 0.1);
            }
        }
        if (rng == 5) {
            if (_green.position.y - 0.1 <= 0.46) {
                shuriken.position = ccp(1, _green.position.y + 0.2);
            } else {
                shuriken.position = ccp(1, _green.position.y - 0.1);
            }
        }
    }
    
    if (_doubleTop) {
        CCSprite *shuriken2 = (CCSprite *)[CCBReader load:@"Shuriken"];
        shuriken2.positionType = CCPositionTypeNormalized;
        if (shuriken.position.y + 0.1 >= 1.04) {
            shuriken2.position = ccp(1, shuriken.position.y - 0.1);
        } else if (shuriken.position.y - 0.1 <= 0.46) {
            NSLog(@"Hi");
            shuriken2.position = ccp(1, shuriken.position.y + 0.1);
        } else {
            int rng2 = arc4random() % 2;
            if (rng2 == 0) {
                shuriken2.position = ccp(1, shuriken.position.y - 0.1);
            } else {
                shuriken2.position = ccp(1, shuriken.position.y + 0.1);
            }
        }
        [_physicsNode addChild:shuriken2];
        [shuriken2.physicsBody applyAngularImpulse:900];
        shuriken2.physicsBody.velocity = ccp(-150,0);
    }
    
    [_physicsNode addChild:shuriken];
    [shuriken.physicsBody applyAngularImpulse:900];
    shuriken.physicsBody.velocity = ccp(-225,0);
}

- (void)spawnShurikenBot {
    CCSprite *shuriken = (CCSprite *)[CCBReader load:@"Shuriken"];
    shuriken.positionType = CCPositionTypeNormalized;
    
    if (_firstBot) {
        shuriken.position = ccp(_blue.position.x, 0.475);
        _firstBot = false;
    } else {
        int rng = arc4random() % 6;
        if (0 <= rng <= 3) {
            shuriken.position = ccp(_blue.position.x, 0.475);
        }
        if (rng == 4) {
            if (_blue.position.x + 0.2 >= 1.09) {
                shuriken.position = ccp(_blue.position.x - 0.4, 0.475);
            } else {
                shuriken.position = ccp(_blue.position.x + 0.2, 0.475);
            }
        }
        if (rng == 5) {
            if (_blue.position.x - 0.2 <= -0.09) {
                shuriken.position = ccp(_blue.position.x + 0.4, 0.475);
            } else {
                shuriken.position = ccp(_blue.position.x - 0.2, 0.475);
            }
        }
    }
    
    [_physicsNode addChild:shuriken];
    [shuriken.physicsBody applyAngularImpulse:900];
    shuriken.physicsBody.velocity = ccp(0,-175);
}

- (void)swipeLeft {
    if (_tutorial) {
        [_moveBlue removeFromParent];
        [self schedule:@selector(spawnShurikenBot) interval:1.2f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    if (_both) {
        [self startBoth];
    }
    if (_blue.position.x - 0.2 >= 0.09) {
        _blue.position = ccp(_blue.position.x - 0.2, _blue.position.y);
    }
}
- (void)swipeRight {
    if (_tutorial) {
        [_moveBlue removeFromParent];
        [self schedule:@selector(spawnShurikenBot) interval:1.2f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    if (_both) {
        [self startBoth];
    }
    if (_blue.position.x + 0.2 <= 0.91) {
        _blue.position = ccp(_blue.position.x + 0.2, _blue.position.y);
    }
}
- (void)swipeDown {
    if (_tutorial) {
        [_moveGreen removeFromParent];
        [self schedule:@selector(spawnShurikenTop) interval:1.5f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    if (_both) {
        [self startBoth];
    }
    if (_green.position.y - 0.1 >= 0.54) {
        _green.position = ccp(_green.position.x, _green.position.y - 0.1);
    }
}
- (void)swipeUp {
    if (_tutorial) {
        [_moveGreen removeFromParent];
        [self schedule:@selector(spawnShurikenTop) interval:1.5f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    if (_both) {
        [self startBoth];
    }
    if (_green.position.y + 0.1 <= 0.96) {
        _green.position = ccp(_green.position.x, _green.position.y + 0.1);
    }
}

- (void)startBoth {
    [_moveBoth removeFromParent];
    [self schedule:@selector(spawnShurikenTop) interval:1.5f];
    [self schedule:@selector(spawnShurikenBot) interval:1.2f];
    [self schedule:@selector(timer) interval:1.f];
    _both = false;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair green:(CCSprite *)balloon shuriken:(CCSprite *)shuriken {
    [self explode:_green];
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair blue:(CCSprite *)balloon shuriken:(CCSprite *)shuriken {
    [self explode:_blue];
    
    return TRUE;
}

- (void)explode:(CCSprite *)balloon {
    CCSprite *explosion = (CCSprite *)[CCBReader load:@"Explosion"];
    explosion.positionType = CCPositionTypeNormalized;
    explosion.position = balloon.position;
    explosion.anchorPoint = balloon.anchorPoint;
    [self addChild:explosion];
    [balloon removeFromParent];
    
    [self performSelector:@selector(recap) withObject:self afterDelay:0.15f];
}

- (void)removeExplosion:(CCSprite *)explosion {
    [explosion removeFromParent];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shuriken:(CCSprite *)shuriken ground:(CCNode *)ground {
    [shuriken removeFromParent];
    
    return TRUE;
}

- (void)timer {
    _score++;
    _scoreLabel.string = [NSString stringWithFormat:@"%i", _score];
    
    if (_score == 18) {
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(timer)];
        _tutorial = true;
        
        _coverBot.position = ccp(0, 0.5);
        
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeft];
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
    } else if (_score == 36) {
        [self unschedule:@selector(spawnShurikenBot)];
        [self unschedule:@selector(timer)];
        [_coverBot removeFromParent];
        _moveBoth.visible = true;
        _both = true;
        
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];

    } else if (_score == 54) {
        _doubleTop = true;
    }
}

- (void)recap {
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:gameplayScene withTransition:transition];
}

@end
