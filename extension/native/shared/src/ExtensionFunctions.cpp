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

#include <stdlib.h>
#include <string.h>
#include <limits>

#include "ExtensionFunctions.h"
#include "SessionContext.h"
#include "Box2DExtensionHelper.h"

/**
 * Useful shortand for declaring a function that will be exposed to ANE
 */
#define DEFINE_ANE_FUNCTION(fn) static FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define ASSERT_ARGC_IS(fn_name, required)                                                                       \
    if(argc != (required))                                                                                      \
    {                                                                                                           \
        DISPATCH_INTERNAL_ERROR(context, #fn_name ": Wrong number of arguments. Expected exactly " #required);  \
        return NULL;                                                                                            \
    }

#define ASSERT_ARGC_AT_LEAST(fn_name, required)                                                                 \
    if(argc < (required))                                                                                       \
    {                                                                                                           \
        DISPATCH_INTERNAL_ERROR(context, #fn_name ": Wrong number of arguments. Expected at least " #required); \
        return NULL;                                                                                            \
    }

/**
 * Fetches the session context and checks it's vaguely valid
 */
#define GET_SESSION_CONTEXT(variable)                                                                   \
    SessionContext* (variable);                                                                         \
    if( FREGetContextNativeData(context, (void**)(&(variable))) != FRE_OK )                             \
    {                                                                                                   \
        DISPATCH_INTERNAL_ERROR(context, "Could not retrieve context in ANE function");                 \
    }                                                                                                   \
    if( (variable) == NULL )                                                                            \
    {                                                                                                   \
        DISPATCH_INTERNAL_ERROR(context, "Session context seems to be NULL. I'll probably die now");    \
    }                                                                                                   \

/***************************************************************************
 * Function entry points for the extension
 *
 * Don't forget to map the functions at the end of the file in
 * NAHB2D_createNamedFunctionsArray
 **************************************************************************/
DEFINE_ANE_FUNCTION(getNativeBuildStamp)
{
    FREObject result;
    const char* reply = "Noise & Heat Box2D Air Native Extension wrapper built on " __DATE__ " at " __TIME__ ". For more information, see http://noiseandheat.com/";
    
    FRENewObjectFromUTF8(strlen(reply) + 1, (const uint8_t*)reply, &result);
    
    return result;
}

DEFINE_ANE_FUNCTION(getBox2DVersion)
{
    FREObject result;
    FREObject major;
    FREObject minor;
    FREObject revision;
    
    if(FRENewObject((const uint8_t *)"Object", 0, NULL, &result, NULL) == FRE_OK
       && FRENewObjectFromInt32(b2_version.major, &major) == FRE_OK
       && FRENewObjectFromInt32(b2_version.minor, &minor) == FRE_OK
       && FRENewObjectFromInt32(b2_version.revision, &revision) == FRE_OK
       && FRESetObjectProperty(result, (const uint8_t *)"major", major, NULL) == FRE_OK
       && FRESetObjectProperty(result, (const uint8_t *)"minor", minor, NULL) == FRE_OK
       && FRESetObjectProperty(result, (const uint8_t *)"revision", revision, NULL) == FRE_OK)
    {
        return result;
    }
    
    return result;
}

DEFINE_ANE_FUNCTION(setWorldGravity)
{
    ASSERT_ARGC_IS(setWorldGravity, 1);

    FREObject returnValue = NULL;
    
    GET_SESSION_CONTEXT(sc);
    sc->world.SetGravity(ANE_b2Vec2(argv[0]));
    
    return returnValue;
}

DEFINE_ANE_FUNCTION(createBody)
{
    ASSERT_ARGC_IS(createBody, 1);
    
    FREObject returnValue = NULL;
    
    GET_SESSION_CONTEXT(sc);

    uintptr_t id = sc->ClaimNextFreeID();
    if (id > std::numeric_limits<uint32_t>::max()) 
    {
        DISPATCH_INTERNAL_ERROR(context, "createBody: Entity ID overflow. Can't create any more entities.");
        return returnValue;
    }

    ANE_b2BodyDef bodyDef(argv[0]);
    b2Body* body = sc->world.CreateBody(&bodyDef);
    
    body->SetUserData((void*)id);
    FRENewObjectFromUint32((uint32_t)id, &returnValue);
    
    return returnValue;
}

// id, width, height, density
DEFINE_ANE_FUNCTION(createBodyFixtureWithBoxShape)
{
    ASSERT_ARGC_AT_LEAST(createBodyFixtureWithBoxShape, 3);
    
    FREObject returnValue = NULL;

    uint32_t bodyID;
    if (FREGetObjectAsUint32(argv[0], &bodyID) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "createBodyFixtureWithBoxShape: bodyID was not numeric.");
        return NULL;
    }
    
    double width;
    if (FREGetObjectAsDouble(argv[1], &width) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "createBodyFixtureWithBoxShape: width was not numeric.");
        return NULL;
    }
    
    double height;
    if (FREGetObjectAsDouble(argv[2], &height) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "createBodyFixtureWithBoxShape: height was not numeric.");
        return NULL;
    }
    
    GET_SESSION_CONTEXT(sc);
    b2Body* body = sc->FindBody(bodyID);

    if (body == NULL)
    {
        DISPATCH_INTERNAL_ERROR(context, "createBodyFixtureWithBoxShape: No body matched the specified bodyID.");
        return NULL;
    }

    uintptr_t id = sc->ClaimNextFreeID();
    if (id > std::numeric_limits<uint32_t>::max()) 
    {
        DISPATCH_INTERNAL_ERROR(context, "createBodyFixtureWithBoxShape: Entity ID overflow. Can't create any more entities.");
        return returnValue;
    }
    
    b2PolygonShape shape;
    shape.SetAsBox(width, height);
    
    b2Fixture* fixture;
    
    if (argc > 4 ) 
    {
        ANE_b2FixtureDef fixtureDef(argv[3]);
        fixtureDef.shape = &shape;
        
        fixture = body->CreateFixture(&fixtureDef);
    }
    else
    {
        fixture = body->CreateFixture(&shape, 0.0f);
    }
    
    if (fixture != NULL)
    {
        fixture->SetUserData((void*)id);
        FRENewObjectFromUint32((uint32_t)id, &returnValue);
    }
    
    return returnValue;
}

DEFINE_ANE_FUNCTION(worldStep)
{
    ASSERT_ARGC_IS(worldStep, 3);
    
    FREObject returnValue = NULL;

    double timeStep;
    if (FREGetObjectAsDouble(argv[0], &timeStep) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "worldStep: timeStep was not numeric.");
        return NULL;
    }
    
    uint32_t velocityIterations;
    if (FREGetObjectAsUint32(argv[1], &velocityIterations) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "worldStep: velocityIterations was not numeric.");
        return NULL;
    }
    
    uint32_t positionIterations;
    if (FREGetObjectAsUint32(argv[2], &positionIterations) != FRE_OK)
    {
        DISPATCH_INTERNAL_ERROR(context, "worldStep: positionIterations was not numeric.");
        return NULL;
    }
    
    GET_SESSION_CONTEXT(sc);
    sc->world.Step(timeStep, velocityIterations, positionIterations);
    
    return returnValue;
}

/***************************************************************************
 * Function map to add to the extension context
 *
 * Unless you want to declare prototypes for the function entry points, you
 * should make sure this function is at the end of the file.
 **************************************************************************/

/**
 * Helper macro to make adding functions a little less error prone. It makes
 * the assumption that the C function names in this file map directly to
 * the same method names in the ActionScript part of the extension.
 */
// This one is C99 only. I hate C++. It's so backwards.
//#define MAP_FUNCTION(fn, data) { .name = (const uint8_t*)(#fn), .functionData = (data), .function = &(fn) }
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

extern "C" uint32_t NAHB2D_createNamedFunctionsArray(const FRENamedFunction** functions)
{
    static FRENamedFunction function_map[] = {
        MAP_FUNCTION(getNativeBuildStamp, NULL),
        MAP_FUNCTION(getBox2DVersion, NULL),
        MAP_FUNCTION(setWorldGravity, NULL),
        MAP_FUNCTION(createBody, NULL),
        MAP_FUNCTION(createBodyFixtureWithBoxShape, NULL),
        MAP_FUNCTION(worldStep, NULL),
    };
    
    // Set the map pointer
    *functions = function_map;
    
    // Work out how many elements the array has
    return sizeof(function_map) / sizeof(FRENamedFunction);
}
