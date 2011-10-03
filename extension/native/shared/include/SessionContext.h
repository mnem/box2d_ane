/**
 * (c) Copyright 2011 David Wagner.
 *
 * Complain/commend: http://noiseandheat.com/
 *
 *
 * Licensed under the MIT license:
 *
 *     http://www.opensource.org/licenses/mit-license.php
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// Protect against multiple includes
#ifndef NaHBox2D_SessionContext_h
#define NaHBox2D_SessionContext_h

#include "Box2D/Box2D.h"
#include "Box2DExtensionHelper.h"


class ANE_Container
{
public:
    ANE_Container(uint32_t ID) : itemID(ID) {};
    
    virtual void Serialize(FREContext context, FREObject store) = 0;
    
public:
    const uint32_t itemID;
};

class ANE_b2BodyContainer : public ANE_Container
{
public:
    ANE_b2BodyContainer(b2Body* body, uint32_t bodyID) : ANE_Container(bodyID), body(body)
    {
        body->SetUserData((void*)this);
    }
    
    void Serialize(FREContext context, FREObject store);
    
public:
    const b2Body* body;
};

class ANE_b2FixtureContainer : public ANE_Container
{
public:
    ANE_b2FixtureContainer(b2Fixture* fixture, uint32_t fixtureID) : ANE_Container(fixtureID), fixture(fixture)
    {
        fixture->SetUserData((void*)this);
    }
    
    void Serialize(FREContext context, FREObject store)
    {
        FREObject AS_itemID;
        FRENewObjectFromUint32(itemID, &AS_itemID);
        FRESetObjectProperty(store, (const uint8_t *)"id", AS_itemID, NULL);
    }
    
public:
    const b2Fixture* fixture;
};


class SessionContext : public b2DestructionListener
{
private:
    uint32_t ClaimNextFreeID() 
    {
        return nextFreeID++;
    };
    
    uint32_t nextFreeID;

public:
    static const uint32_t INVALID_ENTITY_ID;
    b2World world;

	SessionContext(float32 gX = 0.0, float32 gY = -10.0, bool allowSleeping = true);
    
    ANE_b2BodyContainer* RegisterBody(b2Body* body)
    {
        uint32_t bodyID = ClaimNextFreeID();
        return new ANE_b2BodyContainer(body, bodyID);
    }
    
    uint32_t RegisterFixture(b2Fixture* fixture)
    {
        uint32_t fixtureID = ClaimNextFreeID();
        new ANE_b2FixtureContainer(fixture, fixtureID);
        return fixtureID;
    }
    
    
    b2Body* FindBody(uint32_t bodyID);
    
    void WriteBodyListToActionScriptData(FREContext context);

    void GetBodyProxyFromASData(FREObject asd, uint32_t bodyID, FREObject *proxy);
    void GetBodyProxyFromContext(FREContext context, uint32_t bodyID, FREObject *proxy);

	
    // Destruction listeners
    void SayGoodbye(b2Joint* joint)
    {
        // Nothing yet
    }
    
	void SayGoodbye(b2Fixture* fixture)
    {
        ANE_b2FixtureContainer* fixtureContainer = (ANE_b2FixtureContainer*)(fixture->GetUserData());
        
        // Notify the world somehow? Might have to stick it on a stack
        
        delete fixtureContainer;
    }
};

#endif /* #ifndef NaHBox2D_SessionContext_h */
