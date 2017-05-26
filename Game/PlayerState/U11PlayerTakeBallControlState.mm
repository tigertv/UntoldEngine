//
//  U11PlayerTakeBallControlState.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 2/19/17.
//  Copyright © 2017 Untold Game Studio. All rights reserved.
//

#include "U11PlayerTakeBallControlState.h"
#include "U11PlayerDribbleState.h"
#include "U11PlayerGroundPassState.h"
#include "U11PlayerGroundShotState.h"
#include "U11PlayerAirShotState.h"
#include "U11PlayerReverseKickState.h"
#include "U11PlayerRunPassState.h"
#include "U11BallGroundState.h"
#include "U11PlayerChaseBallState.h"
#include "U11AIAttackState.h"
#include "U11AIDefenseState.h"
#include "U11Ball.h"
#include "U11Team.h"
#include "U11AISystem.h"
#include "UserCommonProtocols.h"


U11PlayerTakeBallControlState* U11PlayerTakeBallControlState::instance=0;

U11PlayerTakeBallControlState::U11PlayerTakeBallControlState(){
    
}

U11PlayerTakeBallControlState::~U11PlayerTakeBallControlState(){
    
}

U11PlayerTakeBallControlState* U11PlayerTakeBallControlState::sharedInstance(){
    
    if (instance==0) {
        instance=new U11PlayerTakeBallControlState();
    }
    
    return instance;
    
}

void U11PlayerTakeBallControlState::enter(U11Player *uPlayer){
    
    //get team
    U11Team *team=uPlayer->getTeam();
    
    //set as the controlling player
    team->setControllingPlayer(uPlayer);
    
    //assign support player
    team->getAISystem()->getAttackAISystem().assignSupportPlayer();
    
    //change state to attacking
    team->changeState(U11AIAttackState::sharedInstance());
    
    //inform the opposite team to change to defending state
    team->getOppositeTeam()->changeState(U11AIDefenseState::sharedInstance());
    
    //determine the direction of the ball
    U4DEngine::U4DVector3n playerHeading=uPlayer->getPlayerHeading();
    playerHeading.normalize();
    
    U4DEngine::U4DVector3n ballHeading=uPlayer->getSoccerBall()->getVelocity();
    ballHeading.normalize();
    
    float relHeading=playerHeading.dot(ballHeading);
    
    if (relHeading<-0.90) {
        //if ball is coming towards player around 18 degrees
        
        //set the control ball animation
        if (uPlayer->isBallOnRightSidePlane()) {
            
            uPlayer->setNextAnimationToPlay(uPlayer->getBackHaltBallWithRightFootAnimation());
            uPlayer->setActiveExtremity(uPlayer->getRightFoot());
        }else{
            
            uPlayer->setNextAnimationToPlay(uPlayer->getBackHaltBallWithLeftFootAnimation());
            uPlayer->setActiveExtremity(uPlayer->getLeftFoot());
        }
        
    }else if(relHeading>0.90){
        //if ball is ahead of player around 18 degrees
        
        //set the control ball animation
        if (uPlayer->isBallOnRightSidePlane()) {
            
            uPlayer->setNextAnimationToPlay(uPlayer->getForwardHaltBallWithRightFootAnimation());
            uPlayer->setActiveExtremity(uPlayer->getRightFoot());
        }else{
            
            uPlayer->setNextAnimationToPlay(uPlayer->getForwardHaltBallWithLeftFootAnimation());
            uPlayer->setActiveExtremity(uPlayer->getLeftFoot());
        }
        
    }else{
        
        //set the control ball animation
        if (uPlayer->isBallComingFromRightSidePlane()) {
            
            uPlayer->setNextAnimationToPlay(uPlayer->getSideHaltBallWithLeftFootAnimation());
            uPlayer->setActiveExtremity(uPlayer->getLeftFoot());
            
        }else{
            
            uPlayer->setNextAnimationToPlay(uPlayer->getSideHaltBallWithRightFootAnimation());
            uPlayer->setActiveExtremity(uPlayer->getRightFoot());
        }
        
    }
    
    uPlayer->setPlayBlendedAnimation(true);
    uPlayer->setPlayNextAnimationContinuously(false);
    
   
}

void U11PlayerTakeBallControlState::execute(U11Player *uPlayer, double dt){
    
    U11Ball *ball=uPlayer->getSoccerBall();
    
    //stop ball motion if the feet collide with the ball and if it matches a keyframe
    if (uPlayer->getActiveExtremityCollidedWithBall()) {
        
        if (uPlayer->getCurrentPlayingAnimation()==uPlayer->getForwardHaltBallWithLeftFootAnimation() || uPlayer->getCurrentPlayingAnimation()==uPlayer->getForwardHaltBallWithRightFootAnimation()) {
            
            if (uPlayer->getAnimationCurrentKeyframe()==3) {
                
                ball->removeKineticForces();
                
                ball->removeAllVelocities();
                
                ball->changeState(U11BallGroundState::sharedInstance());
                
            }
            
        }else{
            
            ball->removeKineticForces();
            
            ball->removeAllVelocities();
            
            ball->changeState(U11BallGroundState::sharedInstance());
            
        }
        
    }else if(uPlayer->distanceToBall()>ballControlMaximumDistance){
        
        uPlayer->decelerateBall(ballDeceleration, dt);
        
        uPlayer->changeState(U11PlayerChaseBallState::sharedInstance());
    }
        
    if (ball->getVelocity().magnitude()>ballMaxSpeed) {
        uPlayer->decelerateBall(ballDeceleration, dt);
    }
    
}

void U11PlayerTakeBallControlState::exit(U11Player *uPlayer){
    
}

bool U11PlayerTakeBallControlState::isSafeToChangeState(U11Player *uPlayer){
    
    return true;
}

bool U11PlayerTakeBallControlState::handleMessage(U11Player *uPlayer, Message &uMsg){
    
    switch (uMsg.msg) {
            
        case msgButtonAPressed:
        {
            int passBallSpeed=*((int*)uMsg.extraInfo);
            
            uPlayer->setBallKickSpeed(passBallSpeed);
            
            uPlayer->changeState(U11PlayerRunPassState::sharedInstance());
        }
            break;
            
        case msgButtonBPressed:
        {
            int passBallSpeed=*((int*)uMsg.extraInfo);
            
            uPlayer->setBallKickSpeed(passBallSpeed);
            
            uPlayer->changeState(U11PlayerAirShotState::sharedInstance());
        }
            break;
            
        case msgJoystickActive:
        {
            JoystickMessageData joystickMessageData=*((JoystickMessageData*)uMsg.extraInfo);
            
            if (joystickMessageData.changedDirection) {
                
                uPlayer->changeState(U11PlayerReverseKickState::sharedInstance());
                
            }
            
            uPlayer->changeState(U11PlayerDribbleState::sharedInstance());
            
            
        }
            break;
            
        default:
            break;
    }
    
    return false;
}
