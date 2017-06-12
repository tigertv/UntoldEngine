//
//  U11AttackSystem.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 6/3/17.
//  Copyright © 2017 Untold Game Studio. All rights reserved.
//

#include "U11AttackSystem.h"
#include "U11MessageDispatcher.h"
#include "U11SpaceAnalyzer.h"
#include "U11Player.h"
#include "U11Team.h"
#include "U11FormationInterface.h"


U11AttackSystem::U11AttackSystem(){
    
    scheduler=new U4DEngine::U4DCallback<U11AttackSystem>;
    supportAnalysisTimer=new U4DEngine::U4DTimer(scheduler);
    
}

U11AttackSystem::~U11AttackSystem(){
    
    delete scheduler;
    delete supportAnalysisTimer;
}

void U11AttackSystem::setTeam(U11Team *uTeam){
    
    team=uTeam;
    
}


void U11AttackSystem::assignSupportPlayer(){
    
    U11MessageDispatcher *messageDispatcher=U11MessageDispatcher::sharedInstance();
    
    U11SpaceAnalyzer  spaceAnalyzer;
    
    //send message to new support player to support
    team->setSupportPlayer1(spaceAnalyzer.analyzeSupportPlayers(team).at(0));
    
    messageDispatcher->sendMessage(0.0, NULL, team->getSupportPlayer1(), msgSupportPlayer);
    
    team->setSupportPlayer2(spaceAnalyzer.analyzeSupportPlayers(team).at(1));
    
    messageDispatcher->sendMessage(0.0, NULL, team->getSupportPlayer2(), msgSupportPlayer);
    
}

void U11AttackSystem::computeSupportSpace(){
    
    analyzePlay();
    
    U11SpaceAnalyzer spaceAnalyzer;
    
    //assign support player
    assignSupportPlayer();
    
    //translate the formation
    U11Player *controllingPlayer=team->getControllingPlayer();
    
    U4DEngine::U4DVector3n formationSupportSpace=(spaceAnalyzer.computeMovementRelToFieldGoal(team, controllingPlayer,formationDefenseSpace)).toVector();
    
    team->getTeamFormation()->translateFormation(formationSupportSpace);
    
    //change the home position for each player
    
    team->updateTeamFormationPosition();
    
    //assign the support players
    std::vector<U4DEngine::U4DPoint3n> supportSpace=spaceAnalyzer.computeOptimalSupportSpace(team);
    
    U4DEngine::U4DPoint3n supportSpace1=supportSpace.at(0);
    U4DEngine::U4DPoint3n supportSpace2=supportSpace.at(1);
    
    //compute closest support point to support player
    
    U11Player *supportPlayer1=team->getSupportPlayer1();
    U11Player *supportPlayer2=team->getSupportPlayer2();
    
    U4DEngine::U4DVector3n supportPlayer1Position=supportPlayer1->getAbsolutePosition();
    U4DEngine::U4DVector3n supportPlayer2Position=supportPlayer2->getAbsolutePosition();
    
    if ((supportPlayer1Position-supportSpace1.toVector()).magnitudeSquare()<(supportPlayer1Position-supportSpace2.toVector()).magnitudeSquare()) {
        
        supportPlayer1->setSupportPosition(supportSpace1);
        supportPlayer2->setSupportPosition(supportSpace2);
        
    }else{
        
        supportPlayer1->setSupportPosition(supportSpace2);
        supportPlayer2->setSupportPosition(supportSpace1);
        
    }
    
    //send message to player to run to position
    U11MessageDispatcher *messageDispatcher=U11MessageDispatcher::sharedInstance();
    messageDispatcher->sendMessage(0.0, NULL, supportPlayer1, msgRunToSupport);
    messageDispatcher->sendMessage(0.0, NULL, supportPlayer2, msgRunToSupport);
    
    //message all the players to get to their home position
    
    for(auto n:team->getTeammates()){
        
        if (n!=controllingPlayer && n!=supportPlayer1 && n!=supportPlayer2) {
            messageDispatcher->sendMessage(0.0, NULL, n, msgRunToAttackFormation);
        }
        
    }
    
}

void U11AttackSystem::startComputeSupportSpaceTimer(){
    
    scheduler->scheduleClassWithMethodAndDelay(this, &U11AttackSystem::computeSupportSpace, supportAnalysisTimer, 0.3, true);
    
}

void U11AttackSystem::removeComputeSupportSpaceTimer(){
    
    scheduler->unScheduleTimer(supportAnalysisTimer);
    
}
