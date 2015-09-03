//
//  U4DCollisionEngine.cpp
//  UntoldEngine
//
//  Created by Harold Serrano on 7/14/13.
//  Copyright (c) 2013 Untold Story Studio. All rights reserved.
//

#include "U4DCollisionEngine.h"
#include "Constants.h"
#include "CommonProtocols.h"
#include "U4DCollisionAlgorithm.h"
#include "U4DGJKAlgorithm.h"

namespace U4DEngine {
    
    U4DCollisionEngine::U4DCollisionEngine(){

        //set collision detection algorithm
        collisionAlgorithm=new U4DGJKAlgorithm();
        setCollisionAlgorithm(collisionAlgorithm);
        
        // set Contact Points Algorithm
        
        // set Penetration and Normal Contact Vector algorithm
        
        
        
    };

    U4DCollisionEngine::~U4DCollisionEngine(){};

    void U4DCollisionEngine::setCollisionAlgorithm(U4DCollisionAlgorithm* uCollisionAlgorithm){
        
        collisionAlgorithm=uCollisionAlgorithm;
        
    }

    void U4DCollisionEngine::addToCollisionContainer(U4DStaticModel* uModel){
        
        modelCollection.push_back(uModel);
        
    }

    void U4DCollisionEngine::detectCollisions(float dt){
        
        if(collisionAlgorithm->collision(modelCollection.at(0),modelCollection.at(1),dt)){
            
            std::cout<<"Collision Occurred"<<std::endl;
            //if collision occurred then
            //1. find contact points
            
            //2. Find penetration depth
            
            //3. Find Normal contact Vector
              
        }
        

        //NEED TO REMOVE THIS
        modelCollection.clear();
    }
    
    

    /*
    void U4DCollisionEngine::collisionDetection(U4DDynamicModel* uModel,float dt){
        
        //create a plane
        U4DVector3n normal(0,1,0);
        float d=0.0;
        
        U4DPlane plane(normal,d);
        
        //did collision occurred with a plane
        if(collision(uModel,plane)==true)
        {
            //determine the contact point
            determineContactPoint(uModel,plane);
            
            //Get contact Resolution
            contactResolution(uModel,dt);
            
            //set body collided
            uModel->collisionProperties.collided=true;
            
        }else{
            uModel->collisionProperties.collided=false;
        }
        
    }

    void U4DCollisionEngine::collisionDetection(float dt){
        

        if (modelCollection.size()>=2) {
            
        if (collision(modelCollection.at(0), modelCollection.at(1))) {
            
            //detect collision of two objects
            
        }
        
        
        //clear all models
        modelCollection.clear();
        
        }
    }



    //Test if OBB intersects plane p
    bool U4DCollisionEngine::collision(U4DDynamicModel* uModel,U4DPlane& uPlane){
        
        bool collisionOccured=false;
        U4DOBB *obb=(U4DOBB*)uModel->obbBoundingVolume;
        
        collisionOccured=obb->testOBBPlane(uPlane);

        return collisionOccured;
    }

    bool U4DCollisionEngine::collision(U4DDynamicModel* uModel1, U4DDynamicModel* uModel2){
        
        bool collisionOccured=false;
        
        U4DOBB *obb1=(U4DOBB*)uModel1->obbBoundingVolume;
        U4DOBB *obb2=(U4DOBB*)uModel2->obbBoundingVolume;
        
        collisionOccured=obb1->testOBBOBB(obb2);
        
        return collisionOccured;
    }


    void U4DCollisionEngine::determineContactPoint(U4DDynamicModel* uModel, U4DPlane& uPlane){
     
        //clear any contact point and forces

        uModel->collisionProperties.contactForcePoints.contactPoints.clear();
        uModel->collisionProperties.contactForcePoints.forceOnContactPoint.clear();
        
        U4DOBB *obb=(U4DOBB*)uModel->obbBoundingVolume;
       
        uModel->collisionProperties.contactForcePoints.contactPoints=obb->computeVertexIntersectingPlane(uPlane);
        
        
        //We need to get the forces acted on each contact point
        //since the model is in contact with the plane, the resultant force is its weigh in opposite direction
        
        lineOfAction=uPlane.n;
        lineOfAction.normalize();
     
    }


    void U4DCollisionEngine::contactResolution(U4DDynamicModel* uModel,float dt){
        
      
        
    }
    */




    /*
    void U4DCollisionEngine::heapSorting(vector<U4DVector3n> &uVolumeVertices,int uVolumeVerticesIndex){
        
        int index; //index of boneDataContainer element
        
        int numValues=(int)uVolumeVertices.size();
        
        //convert the array of values into a heap
        
        for (index=numValues/2-1; index>=0; index--) {
            
            repheadDown(uVolumeVertices,uVolumeVerticesIndex,index,numValues-1);
        }
        
        //sort the array
        for (index=numValues-1; index>=1; index--) {
            
            swap(uVolumeVertices,0,index);
            repheadDown(uVolumeVertices,uVolumeVerticesIndex,0,index-1);
        }
        
    }

    void U4DCollisionEngine::repheadDown(vector<U4DVector3n> &uVolumeVertices,int uVolumeVerticesIndex,int root, int bottom){
        
        int maxChild;
        int rightChild;
        int leftChild;
        
        leftChild=root*2+1;
        rightChild=root*2+2;
        
        
        
        if (leftChild<=bottom) {
            
            if (leftChild==bottom) {
                
                maxChild=leftChild;
                
            }else{
                
                if ((uVolumeVertices.at(leftChild)).squareMagnitude() <= (uVolumeVertices.at(rightChild)).squareMagnitude()) {
                    
                    maxChild=rightChild;
                    
                }else{
                    maxChild=leftChild;
                }
            }
            
            if ((uVolumeVertices.at(root)).squareMagnitude()<(uVolumeVertices.at(maxChild)).squareMagnitude()) {
                
                swap(uVolumeVertices,root,maxChild);
                repheadDown(uVolumeVertices,uVolumeVerticesIndex,maxChild,bottom);
            }
        }
        
    }



    void U4DCollisionEngine::swap(vector<U4DVector3n> &uVolumeVertices,int uIndex1, int uIndex2){
        
        U4DVector3n vertex1=uVolumeVertices.at(uIndex1);
        U4DVector3n vertex2=uVolumeVertices.at(uIndex2);
        
        uVolumeVertices.at(uIndex1)=vertex2;
        uVolumeVertices.at(uIndex2)=vertex1;
        
    }
    */

}
