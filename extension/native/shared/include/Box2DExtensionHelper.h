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

#ifndef NaHBox2D_Box2DExtensionHelper_h
#define NaHBox2D_Box2DExtensionHelper_h

#include "FlashRuntimeExtensions.h"
#include "Box2D/Box2D.h"

/**
 * Handy define to try and notify the extension host that a horrible error
 * has occured
 */
#define DISPATCH_INTERNAL_ERROR(extensionContext, message) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)"INTERNAL_ERROR", (uint8_t*)(message))

int32_t GetPropertyAsInt32( FREObject source, const uint8_t* propertyName );
uint32_t GetPropertyAsUint32( FREObject source,const uint8_t* propertyName );
double GetPropertyAsDouble( FREObject source, const uint8_t* propertyName );
uint32_t GetPropertyAsBool( FREObject source, const uint8_t* propertyName );

class ANE_b2BodyDef : public b2BodyDef
{
public:
    ANE_b2BodyDef(FREObject source);
    
    static const uint8 AS_PROP_angle[];
    void set_angle(FREObject);

    static const uint8 AS_PROP_angularVelocity[];
    void set_angularVelocity(FREObject);

    static const uint8 AS_PROP_linearDamping[];
    void set_linearDamping(FREObject);

    static const uint8 AS_PROP_angularDamping[];
    void set_angularDamping(FREObject);

    static const uint8 AS_PROP_allowSleep[];
    void set_allowSleep(FREObject);

    static const uint8 AS_PROP_awake[];
    void set_awake(FREObject);

    static const uint8 AS_PROP_fixedRotation[];
    void set_fixedRotation(FREObject);

    static const uint8 AS_PROP_bullet[];
    void set_bullet(FREObject);

    static const uint8 AS_PROP_type[];
    void set_type(FREObject);

    static const uint8 AS_PROP_active[];
    void set_active(FREObject);

    static const uint8 AS_PROP_gravityScale[];
    void set_gravityScale(FREObject);
    
    static const uint8 AS_PROP_linearVelocity[];
    void set_linearVelocity(FREObject);
    
    static const uint8 AS_PROP_position[];
    void set_position(FREObject);
};

class ANE_b2Vec2 : public b2Vec2
{
public:
    ANE_b2Vec2(FREObject source);
    
    static const uint8 AS_PROP_x[];
    void set_x(FREObject);
    
    static const uint8 AS_PROP_y[];
    void set_y(FREObject);
    
    static float32 read_x(FREObject source);
    static float32 read_y(FREObject source);
    
    static void write(const b2Vec2 *source, FREObject target);
};

class ANE_b2FixtureDef : public b2FixtureDef
{
public:
    ANE_b2FixtureDef(FREObject source);
    
    static const uint8 AS_PROP_friction[];
    void set_friction(FREObject);
    
    static const uint8 AS_PROP_restitution[];
    void set_restitution(FREObject);
    
    static const uint8 AS_PROP_density[];
    void set_density(FREObject);
    
    static const uint8 AS_PROP_isSensor[];
    void set_isSensor(FREObject);
};

#endif /* NaHBox2D_Box2DExtensionHelper_h */
