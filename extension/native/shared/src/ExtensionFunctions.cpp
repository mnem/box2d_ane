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

#include "ExtensionFunctions.h"
#include "SessionContext.h"
#include "Box2DExtensionHelper.h"

/**
 * Useful shortand for declaring a function that will be exposed to ANE
 */
#define DEFINE_ANE_FUNCTION(fn) static FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

/**
 * Fetches the session context and checks it's vaguely valid
 */
#define GET_session_context(variable)                                                                   \
    SessionContext* (variable);                                                                         \
    if( FREGetContextNativeData(context, (void**)(&(variable))) != FRE_OK )                             \
    {                                                                                                   \
        DISPATCH_INTERNAL_ERROR(context, "Could not retrieve context in ANE function");                 \
    }                                                                                                   \
    if( (variable) == NULL )                                                                            \
    {                                                                                                   \
        DISPATCH_INTERNAL_ERROR(context, "Session context seems to be NULL. I'll probably die now");    \
    }                                                                                                   \

/**
 * Helper macros for the lazy
 */
#define GET_parameter_as_object(variable, position) \
    FREObject (variable) = NULL;                    \
    if((position) >= 0 && (position) < argc)        \
    {                                               \
        (variable) = argv[(position)];              \
    }                                               \

#define GET_parameter_as_float32(variable, position)                                \
    float32 (variable) = 0.0f;                                                      \
    double _double_##variable = 0.0f;                                               \
    if((position) >= 0 && (position) < argc                                         \
       && FREGetObjectAsDouble(argv[(position)], &_double_##variable) == FRE_OK)    \
    {                                                                               \
        (variable) = _double_##variable;                                            \
    }                                                                               \



/***************************************************************************
 * Function entry points for the extension
 *
 * Don't forget to map the functions at the end of the file in
 * NAHB2D_createNamedFunctionsArray
 **************************************************************************/
DEFINE_ANE_FUNCTION(getBuildStamp)
{
    FREObject result;
    const char* reply = "I was built on " __DATE__ " at " __TIME__;
    
    FRENewObjectFromUTF8(strlen(reply) + 1, (const uint8_t*)reply, &result);
    
    return result;
}

DEFINE_ANE_FUNCTION(setWorldGravity)
{
    GET_parameter_as_float32(xComponent, 0);
    GET_parameter_as_float32(yComponent, 1);
    GET_session_context(sc);
    sc->world.SetGravity(b2Vec2(xComponent, yComponent));
    
    return NULL;
}

DEFINE_ANE_FUNCTION(createWorldBody)
{
    GET_parameter_as_object(bodyDefinition, 0);
    if (bodyDefinition != NULL)
    {
        GET_session_context(sc);
        
        ANE_b2BodyDef groundBodyDef(bodyDefinition);
        b2Body* groundBody = sc->world.CreateBody(&groundBodyDef);
        
//        session_context->world.SetGravity(b2Vec2(xComponent, yComponent));
    }
    
    return NULL;
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
        MAP_FUNCTION(getBuildStamp, NULL),
        MAP_FUNCTION(setWorldGravity, NULL),
        MAP_FUNCTION(createWorldBody, NULL),
    };
    
    // Set the map pointer
    *functions = function_map;
    
    // Work out how many elements the array has
    return sizeof(function_map) / sizeof(FRENamedFunction);
}
