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

#include "SessionContext.h"

const uint32_t SessionContext::INVALID_ENTITY_ID = 0;

SessionContext::SessionContext(float32 gX, float32 gY, bool allowSleeping) 
    : world(b2Vec2(gX, gY))
{  
    world.SetAllowSleeping(allowSleeping);
    nextFreeID = INVALID_ENTITY_ID + 1;
}

b2Body* SessionContext::FindBody(uint32_t bodyID)
{
    for (b2Body* b = world.GetBodyList(); b; b = b->GetNext())
    {
        ANE_b2BodyContainer *container = (ANE_b2BodyContainer *)(b->GetUserData());
        if (container && container->itemID == bodyID)
        {
            return b;
        }
    }
    
    return NULL;
}

void SessionContext::WriteBodyListToActionScriptData(FREContext context)
{
    FREObjectType type;
    FREObject asd;
    FREObject asd_bodies;
    
    if (!(FREGetContextActionScriptData(context, &asd) == FRE_OK
        && FREGetObjectType(asd, &type) == FRE_OK
        && type == FRE_TYPE_OBJECT))
    {
        DISPATCH_INTERNAL_ERROR(context, "Could not find the ActionScriptData object");
        return;
    }

    if (!(FREGetObjectProperty(asd, (const uint8_t*)"bodies", &asd_bodies, NULL) == FRE_OK
        && FREGetObjectType(asd_bodies, &type) == FRE_OK
        && type == FRE_TYPE_VECTOR))
    {
        DISPATCH_INTERNAL_ERROR(context, "Could not find the ActionScriptData::bodies vector");
        return;
    }

    uint32_t numBodies = world.GetBodyCount();
    if (FRESetArrayLength(asd_bodies, numBodies) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "Could not set the length of ActionScriptData::bodies vector");
        return;
    }

    uint32_t index = 0;
    FREObject item;
    for (b2Body* b = world.GetBodyList(); b; b = b->GetNext())
    {
        ANE_b2BodyContainer *container = (ANE_b2BodyContainer *)(b->GetUserData());
        if (container == NULL) continue;

        // Get the current item in the vector
        if(!(FREGetArrayElementAt(asd_bodies, index, &item) == FRE_OK
             && FREGetObjectType(item, &type) == FRE_OK
             && type == FRE_TYPE_OBJECT))
        {
            // Doesn't seem to be an object we can use, create a new one and
            // insert it
            if (!(FRENewObject((const uint8_t*)"Object", 0, NULL, &item, NULL) == FRE_OK
                && FRESetArrayElementAt(asd_bodies, index, item) == FRE_OK))
            {
                DISPATCH_INTERNAL_ERROR(context, "Could not update body in ActionScriptData::bodies");
                continue;
            }
        }
        
        container->Serialize(context, item);
        index++;
    }
}


void ANE_b2BodyContainer::Serialize(FREContext context, FREObject store)
{
    FREResult result;
    FREObjectType type;
    FREObject position;
    FREObject angle;
    FREObject AS_itemID;
    
    if (!(FREGetObjectProperty(store, ANE_b2BodyDef::AS_PROP_position, &position, NULL) == FRE_OK
          && FREGetObjectType(position, &type) == FRE_OK
          && type == FRE_TYPE_OBJECT))
    {
        if(FRENewObject((const uint8_t *)"Object", 0, NULL, &position, NULL) != FRE_OK)
        {
            DISPATCH_INTERNAL_ERROR(context, "Could not create a position object to serialise a body too.");
            return;
        }
    }
    
    ANE_b2Vec2::write(&(body->GetPosition()), position);
    
    if(FRENewObjectFromDouble(body->GetAngle(), &angle) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "Serialize Body: could not create angle");
    }
    if(FRENewObjectFromUint32(itemID, &AS_itemID) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "Serialize Body: could not create id");
    }
    
    
    if (!((result = FREGetObjectType(store, &type)) == FRE_OK
          && type == FRE_TYPE_OBJECT))
    {
        char buffer[256];
        sprintf(buffer, "Store not object, %d, %d", result, type);
        DISPATCH_INTERNAL_ERROR(context, buffer);
    }
    
    if((result = FRESetObjectProperty(store, (const uint8_t *)"id", AS_itemID, NULL)) != FRE_OK)
    {
        char buffer[256];
        sprintf(buffer, "Serialize Body: could not set id, %d", result);
        DISPATCH_INTERNAL_ERROR(context, buffer);
    }
    if(FRESetObjectProperty(store, ANE_b2BodyDef::AS_PROP_position, position, NULL) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "Serialize Body: could not set position");
    }
    if(FRESetObjectProperty(store, ANE_b2BodyDef::AS_PROP_angle, angle, NULL) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "Serialize Body: could not set angle");
    }
}
