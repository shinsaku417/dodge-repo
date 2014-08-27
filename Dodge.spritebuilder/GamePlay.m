//
//  GamePlay.m
//  Dodge
//
//  Created by Shinsaku Uesugi on 8/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay {
    // Physics Node: Where all physics things occur
    CCPhysicsNode *_physicsNode;
    
    // Green and Blue balloons
    CCSprite *_green;
    CCSprite *_blue;
    
    // Time = score
    CCLabelTTF *_scoreLabel;
    int _score;
    
    // First shots in both tutorial (top and bot) will aim the balloon
    BOOL _firstTop;
    BOOL _firstBot;
    
    // Covers bottom half then top half for tutorials on moving blue/green balloons
    CCNodeColor *_coverBot;
    
    // 4 Swipe recognizers
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeRight;
    
    // **Difficulty Modes**
    
    // Tutorial: Teaches how to move green and blue balloons
    BOOL _tutorial;
    CCLabelTTF *_moveGreen;
    CCLabelTTF *_moveBlue;
    
    // Shuriken on both sides
    BOOL _both;
    CCLabelTTF *_moveBoth;
    
    // 2 Shurikens on top side, 1 shuriken on bot side
    BOOL _doubleTop;
    BOOL _startDouble;
    CCLabelTTF *_doubleTopLabel;
    
    // 2 Shurikens on both sides
    BOOL _doubleBot;
    BOOL _startDoubleBoth;
    CCLabelTTF *_doubleBothLabel;
    
    // 1 fast shuriken on top side, 1 regular shuriken on bot side
    BOOL _fastTop;
    BOOL _startFastTop;
    CCLabelTTF *_fastTopLabel;
    
    // 3 Shurikens on top side, 1 shuriken on bot side
    BOOL _tripleBot;
    BOOL _startTripleBot;
    CCLabelTTF *_tripleBotLabel;
    
    // Max Difficulty: 3 Shurikens on both sides
    BOOL _tripleTop;
    BOOL _startTripleTop;
    CCLabelTTF *_tripleTopLabel;
    
    // *********************
}

- (void)onEnter {
    [super onEnter];
    
    // Enable interaction and collision
    self.userInteractionEnabled = true;
    _physicsNode.collisionDelegate = self;
    
    _score = 0;
    
    // **Difficulty Modes Initial Values**
    _tutorial = true;
    _both = false;
    _firstTop = true;
    _firstBot = true;
    
    _doubleTop = false;
    _startDouble = false;
    
    _doubleBot = false;
    _startDoubleBoth = false;
    
    _fastTop = false;
    _startFastTop = false;
    
    _tripleBot = false;
    _startTripleBot = false;
    
    _tripleTop = false;
    _startTripleTop = false;
    // ************************
    
    
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

// Spawn shuriken on the top side
- (void)spawnShurikenTop {
    // New shuriken
    CCSprite *shuriken = (CCSprite *)[CCBReader load:@"Shuriken"];
    shuriken.positionType = CCPositionTypeNormalized;
    
    // First shot in the tutorial is aimed towards the balloon
    if (_firstTop) {
        shuriken.position = ccp(1, _green.position.y);
        _firstTop = false;
    } else {
        // Generate random shuriken
        // 66% to aim at balloon
        // 16% to aim one spot above or below balloon
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
    
    // Shoot 2 shurikens
    if (_doubleTop) {
        CCSprite *shuriken2 = (CCSprite *)[CCBReader load:@"Shuriken"];
        shuriken2.positionType = CCPositionTypeNormalized;
        if (shuriken.position.y + 0.1 >= 1.04) {
            shuriken2.position = ccp(1, shuriken.position.y - 0.1);
        } else if (shuriken.position.y - 0.1 <= 0.46) {
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
    
    // Shoot 3 shurikens
    if (_tripleTop) {
        CCSprite *shuriken2 = (CCSprite *)[CCBReader load:@"Shuriken"];
        CCSprite *shuriken3 = (CCSprite *)[CCBReader load:@"Shuriken"];
        shuriken2.positionType = CCPositionTypeNormalized;
        shuriken3.positionType = CCPositionTypeNormalized;
        int rng = arc4random() % 4;
        switch (rng) {
            case 0:
                shuriken.position = ccp(1, 0.55);
                shuriken2.position = ccp(1, 0.75);
                shuriken3.position = ccp(1, 0.95);
                break;
            case 1:
                shuriken.position = ccp(1, 0.65);
                shuriken2.position = ccp(1, 0.85);
                shuriken3.position = ccp(1, 0.95);
                break;
            case 2:
                shuriken.position = ccp(1, 0.65);
                shuriken2.position = ccp(1, 0.75);
                shuriken3.position = ccp(1, 0.85);
                break;
            case 3:
                shuriken.position = ccp(1, 0.55);
                shuriken2.position = ccp(1, 0.65);
                shuriken3.position = ccp(1, 0.95);
                break;
            default:
                shuriken.position = ccp(1, 0.55);
                shuriken2.position = ccp(1, 0.75);
                shuriken3.position = ccp(1, 0.85);
        }
        [_physicsNode addChild:shuriken2];
        [shuriken2.physicsBody applyAngularImpulse:1000];
        shuriken2.physicsBody.velocity = ccp(-200,0);
        
        [_physicsNode addChild:shuriken3];
        [shuriken3.physicsBody applyAngularImpulse:1000];
        shuriken3.physicsBody.velocity = ccp(-250,0);
    }

    
    [_physicsNode addChild:shuriken];
    [shuriken.physicsBody applyAngularImpulse:900];
    // Increase velocity when shooting fast shuriken
    if (_fastTop) {
        shuriken.physicsBody.velocity = ccp(-350,0);
    } else {
        shuriken.physicsBody.velocity = ccp(-225,0);
    }
}

// Spawn shuriken on the bot side => code similar to spawnShurikenTop
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
    
    if (_doubleBot) {
        CCSprite *shuriken2 = (CCSprite *)[CCBReader load:@"Shuriken"];
        shuriken2.positionType = CCPositionTypeNormalized;
        if (shuriken.position.x + 0.2 >= 1.09) {
            shuriken2.position = ccp(shuriken.position.x - 0.2, 0.475);
        } else if (shuriken.position.x - 0.2 <= -0.09) {
            shuriken2.position = ccp(shuriken.position.x + 0.2, 0.475);
        } else {
            int rng2 = arc4random() % 2;
            if (rng2 == 0) {
                shuriken2.position = ccp(shuriken.position.x + 0.2, 0.475);
            } else {
                shuriken2.position = ccp(shuriken.position.x - 0.2, 0.475);
            }
        }
        [_physicsNode addChild:shuriken2];
        [shuriken2.physicsBody applyAngularImpulse:1000];
        shuriken2.physicsBody.velocity = ccp(0,-200);
    }
    
    if (_tripleBot) {
        CCSprite *shuriken2 = (CCSprite *)[CCBReader load:@"Shuriken"];
        CCSprite *shuriken3 = (CCSprite *)[CCBReader load:@"Shuriken"];
        shuriken2.positionType = CCPositionTypeNormalized;
        shuriken3.positionType = CCPositionTypeNormalized;
        int rng = arc4random() % 4;
        switch (rng) {
            case 0:
                shuriken.position = ccp(0.1, 0.475);
                shuriken2.position = ccp(0.5, 0.475);
                shuriken3.position = ccp(0.9, 0.475);
                break;
            case 1:
                shuriken.position = ccp(0.1, 0.475);
                shuriken2.position = ccp(0.3, 0.475);
                shuriken3.position = ccp(0.7, 0.475);
                break;
            case 2:
                shuriken.position = ccp(0.3, 0.475);
                shuriken2.position = ccp(0.7, 0.475);
                shuriken3.position = ccp(0.9, 0.475);
                break;
            case 3:
                shuriken.position = ccp(0.1, 0.475);
                shuriken2.position = ccp(0.5, 0.475);
                shuriken3.position = ccp(0.7, 0.475);
                break;
            default:
                shuriken.position = ccp(0.3, 0.475);
                shuriken2.position = ccp(0.5, 0.475);
                shuriken3.position = ccp(0.9, 0.475);
        }
        [_physicsNode addChild:shuriken2];
        [shuriken2.physicsBody applyAngularImpulse:1000];
        shuriken2.physicsBody.velocity = ccp(0,-155);
        
        [_physicsNode addChild:shuriken3];
        [shuriken3.physicsBody applyAngularImpulse:1000];
        shuriken3.physicsBody.velocity = ccp(0,-165);
    }

    
    [_physicsNode addChild:shuriken];
    [shuriken.physicsBody applyAngularImpulse:900];
    shuriken.physicsBody.velocity = ccp(0,-175);
}

// Swipe Left = move blue balloon 1 spot to the left
- (void)swipeLeft {
    if (_tutorial) {
        [_moveBlue removeFromParent];
        [self schedule:@selector(spawnShurikenBot) interval:1.2f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }

    [self startMode];
    
    if (_blue.position.x - 0.2 >= 0.09) {
        _blue.position = ccp(_blue.position.x - 0.2, _blue.position.y);
    }
}

// Swipe Right = move blue balloon 1 spot to the right
- (void)swipeRight {
    if (_tutorial) {
        [_moveBlue removeFromParent];
        [self schedule:@selector(spawnShurikenBot) interval:1.2f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    
    [self startMode];
    
    if (_blue.position.x + 0.2 <= 0.91) {
        _blue.position = ccp(_blue.position.x + 0.2, _blue.position.y);
    }
}

// Swipe Down = move green balloon 1 spot down
- (void)swipeDown {
    if (_tutorial) {
        [_moveGreen removeFromParent];
        [self schedule:@selector(spawnShurikenTop) interval:1.5f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    
    [self startMode];
    
    if (_green.position.y - 0.1 >= 0.54) {
        _green.position = ccp(_green.position.x, _green.position.y - 0.1);
    }
}

// Swipe Up = move green balloon 1 spot up
- (void)swipeUp {
    if (_tutorial) {
        [_moveGreen removeFromParent];
        [self schedule:@selector(spawnShurikenTop) interval:1.5f];
        [self schedule:@selector(timer) interval:1.f];
        _tutorial = false;
    }
    
    [self startMode];
    
    if (_green.position.y + 0.1 <= 0.96) {
        _green.position = ccp(_green.position.x, _green.position.y + 0.1);
    }
}

// Start new difficulty mode at specific time (Look at timer method)
- (void)startMode {
    if (_both) {
        [self startBoth];
    } else if (_startDouble) {
        [self startDoubleTop];
    } else if (_startDoubleBoth) {
        [self startDoubleBoth];
    } else if (_startFastTop) {
        [self startFastTop];
    } else if (_startTripleBot) {
        [self startTripleBot];
    } else if (_startTripleTop) {
        [self startTripleTop];
    }
}

// *******************Difficulty Modes************************

- (void)startBoth {
    [_moveBoth removeFromParent];
    [self startSchedule];
    _both = false;
}

- (void)startDoubleTop {
    [_doubleTopLabel removeFromParent];
    [self startSchedule];
    _doubleTop = true;
    _startDouble = false;
}

- (void)startDoubleBoth {
    [_doubleBothLabel removeFromParent];
    [self startSchedule];
    _doubleBot = true;
    _startDoubleBoth = false;
}

- (void)startFastTop {
    [_fastTopLabel removeFromParent];
    _fastTop = true;
    [self startSchedule];
    _doubleTop = false;
    _doubleBot = false;
    _startFastTop = false;
}

- (void)startTripleBot {
    [_tripleBotLabel removeFromParent];
    _tripleBot = true;
    [self startSchedule];
    _fastTop = false;
    _startTripleBot = false;
}

- (void)startTripleTop {
    [_tripleTopLabel removeFromParent];
    _tripleTop = true;
    [self startSchedule];
    _startTripleTop = false;
}

// ***************************************************************

// Schedule to spawn shurikens
- (void)startSchedule {
    if (_fastTop) {
        [self schedule:@selector(spawnShurikenTop) interval:0.75f];
        [self schedule:@selector(spawnShurikenBot) interval:1.2f];
        [self schedule:@selector(timer) interval:1.f];
    } else {
        [self schedule:@selector(spawnShurikenTop) interval:1.5f];
        [self schedule:@selector(spawnShurikenBot) interval:1.2f];
        [self schedule:@selector(timer) interval:1.f];
    }
}

// Collision between green balloon and shuriken
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair green:(CCSprite *)balloon shuriken:(CCSprite *)shuriken {
    [self setScore];
    [self explode:_green];
    
    return TRUE;
}

// Collision between blue balloon and shuriken
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair blue:(CCSprite *)balloon shuriken:(CCSprite *)shuriken {
    [self setScore];
    [self explode:_blue];
    
    return TRUE;
}

// Set the score
- (void)setScore {
    NSUserDefaults *gameState = [NSUserDefaults standardUserDefaults];
    [gameState setInteger:_score forKey:@"score"];
    if ([gameState integerForKey:@"score"] > [gameState integerForKey:@"highscore"]) {
        [gameState setInteger:_score forKey:@"highscore"];
    }
}

// Add explosion when shuriken hits a balloon
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

// Collision between wall and shuriken
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair shuriken:(CCSprite *)shuriken ground:(CCNode *)ground {
    [shuriken removeFromParent];
    
    return TRUE;
}

// Timer system
- (void)timer {
    // Add score
    _score++;
    _scoreLabel.string = [NSString stringWithFormat:@"%i", _score];
    
    // Difficulty Lv 2: Tutorial on bottom side
    if (_score == 18) {
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(timer)];
        _tutorial = true;
        
        _coverBot.position = ccp(0, 0.5);
        
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeft];
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
        
    } else if (_score == 35) {
        [self unschedule:@selector(spawnShurikenBot)];
    }
    
    // Difficulty Lv 3: Both sides
    else if (_score == 36) {
        [self unschedule:@selector(timer)];
        [_coverBot removeFromParent];
        _moveBoth.visible = true;
        _both = true;
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];
        [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];
    }
    
    else if (_score == 53) {
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(spawnShurikenBot)];
    }
    
    // Difficulty Lv 4: Double shuriken on the top side
    else if (_score == 54) {
        [self unschedule:@selector(timer)];
        _startDouble = true;
        _doubleTopLabel.visible = true;
    }
    
    else if (_score == 71) {
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(spawnShurikenBot)];
    }
    
    // Difficulty Lv 5: Double shuriken on both sides
    else if (_score == 72) {
        [self unschedule:@selector(timer)];
        _startDoubleBoth = true;
        _doubleBothLabel.visible = true;
    }
    
    else if (_score == 89) {
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(spawnShurikenBot)];
    }
    
    // Difficulty Lv 6: Fast single shuriken on the top side, 1 regular shuriken on the bot side
    else if (_score == 90) {
        [self unschedule:@selector(timer)];
        _startFastTop = true;
        _fastTopLabel.visible = true;
    }
    
    else if (_score == 125) {
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(spawnShurikenBot)];
    }
    
    // Difficulty Lv 7: Triple shuriken on the bot side, 1 regular shuriken on the top side
    else if (_score == 126) {
        [self unschedule:@selector(timer)];
        _startTripleBot = true;
        _tripleBotLabel.visible = true;
        
    }
    
    else if (_score == 161) {
        [self unschedule:@selector(spawnShurikenTop)];
        [self unschedule:@selector(spawnShurikenBot)];
    }
    
    // Difficulty Lv 8: Triple shuriken on the both sides
    else if (_score == 162) {
        [self unschedule:@selector(timer)];
        _startTripleTop = true;
        _tripleTopLabel.visible = true;
    }
}

// Present recap scene once the player loses
- (void)recap {
    // No longer listening to the gesture recognizer
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
    
    CCScene *recap = [CCBReader loadAsScene:@"Recap"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:recap withTransition:transition];
}

@end
