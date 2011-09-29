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

/***************************************************************************
 * Function entry points for the extension
 *
 * Don't forget to map the functions at the end of the file in
 * NAHB2D_createNamedFunctionsArray
 **************************************************************************/
static FREObject hello(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    const char* reply = "Why, hello there. I'm your platform native. How do you do?";
    
    FRENewObjectFromUTF8(strlen(reply) + 1, (const uint8_t*)reply, &result);
    
    return result;
}

static FREObject hello2(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    FREObject result;
    const char* reply = "I'm number 2 and I was built on " __DATE__ " at " __TIME__;
    
    FRENewObjectFromUTF8(strlen(reply) + 1, (const uint8_t*)reply, &result);
    
    return result;
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
#define MAP_FUNCTION(fn, data) { .name = (const uint8_t*)(#fn), .functionData = (data), .function = &(fn) }

uint32_t NAHB2D_createNamedFunctionsArray(const FRENamedFunction** functions)
{
    static FRENamedFunction function_map[] = {
        MAP_FUNCTION(hello, NULL),
        MAP_FUNCTION(hello2, NULL),
    };
    
    // Set the map pointer
    *functions = function_map;
    
    // Work out how many elements the array has
    return sizeof(function_map) / sizeof(FRENamedFunction);
}
