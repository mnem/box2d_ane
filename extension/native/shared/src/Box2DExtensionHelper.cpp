//
//  Box2DExtensionHelper.cpp
//  NaHBox2D
//
//  Created by David Wagner on 01/10/2011.
//  Copyright (c) 2011 Noise & Heat. All rights reserved.
//

#include "Box2DExtensionHelper.h"

/**
 * Lazy helper macros
 */

#define SET_PROPERTY_FROM_AS_OBJECT(property, as_object)                                            \
    FREObject as_value_##property;                                                                  \
    if(FREGetObjectProperty((as_object), AS_PROP##property, &as_value_##property, NULL) == FRE_OK) \
    {                                                                                               \
        set##property(as_value_##property);                                                        \
    }


/***************************************************************************
 * Helper methods
 **************************************************************************/
int32_t GetPropertyAsInt32( FREObject source, const uint8_t* propertyName )
{
    FREObject property;
    
    if(FREGetObjectProperty(source, propertyName, &property, NULL) == FRE_OK)
    {
        int32_t value;
        if (FREGetObjectAsInt32(property, &value) == FRE_OK)
        {
            return value;
        }
    }
    
    return 0;
}

uint32_t GetPropertyAsUint32( FREObject source,const uint8_t* propertyName )
{
    FREObject property;
    
    if(FREGetObjectProperty(source, propertyName, &property, NULL) == FRE_OK)
    {
        uint32_t value;
        if (FREGetObjectAsUint32(property, &value) == FRE_OK)
        {
            return value;
        }
    }
    
    return 0U;
}

double GetPropertyAsDouble( FREObject source, const uint8_t* propertyName )
{
    FREObject property;
    
    if(FREGetObjectProperty(source, propertyName, &property, NULL) == FRE_OK)
    {
        double value;
        if (FREGetObjectAsDouble(property, &value) == FRE_OK)
        {
            return value;
        }
    }
    
    return 0.0;
}

uint32_t GetPropertyAsBool( FREObject source, const uint8_t* propertyName )
{
    FREObject property;
    
    if(FREGetObjectProperty(source, propertyName, &property, NULL) == FRE_OK)
    {
        uint32_t value;
        if (FREGetObjectAsBool(property, &value) == FRE_OK)
        {
            return value;
        }
    }
    
    return false;
}

/***************************************************************************
 * ANE_b2Vec2
 **************************************************************************/
const uint8 ANE_b2BodyDef::AS_PROP_angle[] = "angle";
const uint8 ANE_b2BodyDef::AS_PROP_angularVelocity[] = "angularVelocity";
const uint8 ANE_b2BodyDef::AS_PROP_linearDamping[] = "linearDamping";
const uint8 ANE_b2BodyDef::AS_PROP_angularDamping[] = "angularDamping";
const uint8 ANE_b2BodyDef::AS_PROP_allowSleep[] = "allowSleep";
const uint8 ANE_b2BodyDef::AS_PROP_awake[] = "awake";
const uint8 ANE_b2BodyDef::AS_PROP_fixedRotation[] = "fixedRotation";
const uint8 ANE_b2BodyDef::AS_PROP_bullet[] = "bullet";
const uint8 ANE_b2BodyDef::AS_PROP_type[] = "type";
const uint8 ANE_b2BodyDef::AS_PROP_active[] = "active";
const uint8 ANE_b2BodyDef::AS_PROP_gravityScale[] = "gravityScale";
const uint8 ANE_b2BodyDef::AS_PROP_linearVelocity[] = "linearVelocity";
const uint8 ANE_b2BodyDef::AS_PROP_position[] = "position";

ANE_b2BodyDef::ANE_b2BodyDef(FREObject source) : b2BodyDef()
{
    FREObjectType type;
    if (FREGetObjectType(source, &type) == FRE_OK 
        && type == FRE_TYPE_OBJECT)
    {
        SET_PROPERTY_FROM_AS_OBJECT(_angle, source);
        SET_PROPERTY_FROM_AS_OBJECT(_angularVelocity, source);
        SET_PROPERTY_FROM_AS_OBJECT(_linearDamping, source);
        SET_PROPERTY_FROM_AS_OBJECT(_angularDamping, source);
        SET_PROPERTY_FROM_AS_OBJECT(_allowSleep, source);
        SET_PROPERTY_FROM_AS_OBJECT(_awake, source);
        SET_PROPERTY_FROM_AS_OBJECT(_fixedRotation, source);
        SET_PROPERTY_FROM_AS_OBJECT(_bullet, source);
        SET_PROPERTY_FROM_AS_OBJECT(_type, source);
        SET_PROPERTY_FROM_AS_OBJECT(_active, source);
        SET_PROPERTY_FROM_AS_OBJECT(_gravityScale, source);
        SET_PROPERTY_FROM_AS_OBJECT(_linearVelocity, source);
        SET_PROPERTY_FROM_AS_OBJECT(_position, source);
    }
}

void ANE_b2BodyDef::set_angle(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        angle = value;
    }
}

void ANE_b2BodyDef::set_angularVelocity(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        angularVelocity = value;
    }
}

void ANE_b2BodyDef::set_linearDamping(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        linearDamping = value;
    }
}

void ANE_b2BodyDef::set_angularDamping(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        angularDamping = value;
    }    
}

void ANE_b2BodyDef::set_allowSleep(FREObject o)
{
    uint32_t value;
    if (FREGetObjectAsBool(o, &value) == FRE_OK)
    {
        allowSleep = value;
    }
}

void ANE_b2BodyDef::set_awake(FREObject o)
{
    uint32_t value;
    if (FREGetObjectAsBool(o, &value) == FRE_OK)
    {
        awake = value;
    }
}

void ANE_b2BodyDef::set_fixedRotation(FREObject o)
{
    uint32_t value;
    if (FREGetObjectAsBool(o, &value) == FRE_OK)
    {
        fixedRotation = value;
    }    
}

void ANE_b2BodyDef::set_bullet(FREObject o)
{
    uint32_t value;
    if (FREGetObjectAsBool(o, &value) == FRE_OK)
    {
        bullet = value;
    }
}

void ANE_b2BodyDef::set_type(FREObject o)
{
    int32_t value;
    if (FREGetObjectAsInt32(o, &value) == FRE_OK)
    {
        switch (value)
        {
            case 0:
                type = b2_staticBody;
                break;
                
            case 1:
                type = b2_kinematicBody;
                break;
                
            case 2:
                type = b2_dynamicBody;
                break;
                
            default:
                type = b2_staticBody;
                break;
        }
    }
}

void ANE_b2BodyDef::set_active(FREObject o)
{
    uint32_t value;
    if (FREGetObjectAsBool(o, &value) == FRE_OK)
    {
        active = value;
    }
}

void ANE_b2BodyDef::set_gravityScale(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        gravityScale = value;
    }
}

void ANE_b2BodyDef::set_linearVelocity(FREObject o)
{
    linearVelocity.Set(ANE_b2Vec2::read_x(o), ANE_b2Vec2::read_y(o));
}

void ANE_b2BodyDef::set_position(FREObject o)
{
    position.Set(ANE_b2Vec2::read_x(o), ANE_b2Vec2::read_y(o));
}

/***************************************************************************
 * ANE_b2Vec2
 **************************************************************************/
const uint8 ANE_b2Vec2::AS_PROP_x[] = "x";
const uint8 ANE_b2Vec2::AS_PROP_y[] = "y";

ANE_b2Vec2::ANE_b2Vec2(FREObject source) : b2Vec2()
{
    FREObjectType type;
    if (FREGetObjectType(source, &type) == FRE_OK 
        && type == FRE_TYPE_OBJECT)
    {
        SET_PROPERTY_FROM_AS_OBJECT(_x, source);
        SET_PROPERTY_FROM_AS_OBJECT(_y, source);
    }
}

void ANE_b2Vec2::set_x(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        x = value;
    }
}

void ANE_b2Vec2::set_y(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        y = value;
    }
}

float32 ANE_b2Vec2::read_x(FREObject o)
{
    return GetPropertyAsDouble(o, AS_PROP_x);
}

float32 ANE_b2Vec2::read_y(FREObject o)
{
    return GetPropertyAsDouble(o, AS_PROP_y);
}

void ANE_b2Vec2::write(const b2Vec2 *source, FREObject target)
{
    if (target == NULL) return;
    
    double x = 0.0;
    double y = 0.0;
    
    if (source != NULL)
    {
        x = source->x;
        y = source->y;
    }
    
    FREObject as_x;
    FREObject as_y;
    
    FRENewObjectFromDouble(x, &as_x);
    FRENewObjectFromDouble(y, &as_y);
    
    FRESetObjectProperty(target, AS_PROP_x, as_x, NULL);
    FRESetObjectProperty(target, AS_PROP_y, as_y, NULL);
}


/***************************************************************************
 * ANE_b2FixtureDef
 **************************************************************************/
const uint8 ANE_b2FixtureDef::AS_PROP_friction[] = "friction";
const uint8 ANE_b2FixtureDef::AS_PROP_restitution[] = "restitution";
const uint8 ANE_b2FixtureDef::AS_PROP_density[] = "density";
const uint8 ANE_b2FixtureDef::AS_PROP_isSensor[] = "isSensor";

ANE_b2FixtureDef::ANE_b2FixtureDef(FREObject source) : b2FixtureDef()
{
    FREObjectType type;
    if (FREGetObjectType(source, &type) == FRE_OK 
        && type == FRE_TYPE_OBJECT)
    {
        SET_PROPERTY_FROM_AS_OBJECT(_friction, source);
        SET_PROPERTY_FROM_AS_OBJECT(_restitution, source);
        SET_PROPERTY_FROM_AS_OBJECT(_density, source);
        SET_PROPERTY_FROM_AS_OBJECT(_isSensor, source);
    }
}

void ANE_b2FixtureDef::set_friction(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        friction = value;
    }
}

void ANE_b2FixtureDef::set_restitution(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        restitution = value;
    }
}

void ANE_b2FixtureDef::set_density(FREObject o)
{
    double value;
    if (FREGetObjectAsDouble(o, &value) == FRE_OK)
    {
        density = value;
    }
}

void ANE_b2FixtureDef::set_isSensor(FREObject o)
{
    uint32_t value;
    if (FREGetObjectAsBool(o, &value) == FRE_OK)
    {
        isSensor = value;
    }
}
