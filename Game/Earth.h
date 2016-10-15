//
//  Earth.h
//  UntoldEngine
//
//  Created by Harold Serrano on 5/26/13.
//  Copyright (c) 2013 Untold Story Studio. All rights reserved.
//

#ifndef __UntoldEngine__Earth__
#define __UntoldEngine__Earth__

#include <iostream>
#include "U4DWorld.h"
#include "U4DVector3n.h"

class MyCharacter;

class GameController;
class Rocket;
class Floor;

class Earth:public U4DEngine::U4DWorld{

private:
    
    MyCharacter *ninja;
    
    Floor *floor;
    
public:
   
    Earth(){
        
    };
    
    void init();
    void action();
    void update(double dt);

};

#endif /* defined(__UntoldEngine__Earth__) */
