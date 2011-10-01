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

/**
 * This file contains the main entry points for dealing with the life of
 * the native part of the extension.
 *
 * For full details, see:
 *
 *    http://www.adobe.com/content/dam/Adobe/en/devnet/devices/pdfs/DevelopingActionScriptExtensionsForAdobeAIR.pdf
 *
 * Or for a nice overview, see:
 *
 *    http://www.adobe.com/devnet/air/articles/extending-air.html
 */

#include <stdlib.h>

#include "ExtensionFunctions.h"
#include "SessionContext.h"

/***************************************************************************
 * Function protoypes so Xcode doesn't warn about the lack of them.
 **************************************************************************/
extern "C" void NAHB2DExtensionInitializer(void**, FREContextInitializer*, FREContextFinalizer*);
extern "C" void NAHB2DExtensionFinalizer(void*);

static void ContextInitializer(void*, const uint8_t*, FREContext, uint32_t*, const FRENamedFunction**);
static void ContextFinalizer(FREContext);

/***************************************************************************
 * Extension initialize/finalize functions
 *
 * Use a reasonable prefix for these function names in order to avoid
 * accidentally clashing with other function names. If you are creating and
 * using more than one extension, make sure you don't use the same
 * initializer and finalizer names in the other extension :)
 *
 * The names of these functions should map those in the extension.xml
 * descriptor in the platforms section. For example:
 *
 *
 * <platform name="iPhone-ARM">
 *   <applicationDeployment>
 *     <nativeLibrary>libNaHBox2D.a</nativeLibrary>
 *     <initializer>NAHB2DExtensionInitializer</initializer>
 *     <finalizer>NAHB2DExtensionFinalizer</finalizer>
 *   </applicationDeployment>
 * </platform>
 **************************************************************************/

/**
 * Called when the extension is created. Sets the extension context
 * initialize and finalize functions.
 */
extern "C" void NAHB2DExtensionInitializer(void** extensionDataOut,
                                           FREContextInitializer* contextInitializerFunctionOut,
                                           FREContextFinalizer* contextFinalizerFunctionOut)
{
    // You can use extensionDataOut to store data specifc to the extension.
    // This pointer will be passed to the extension finalizer, so if you
    // malloc some memory here, you should use the finalizer as an
    // opportunity to free it.
    //
    // Each time a new extension context is created, this pointer will
    // also be passed to it. Useful if you want to store extension global
    // data which each context has to be aware of.
	*extensionDataOut = NULL;

    // These lines set which functions are used to intialise new contexts
    // created by the ActionScript part of the extension.
	*contextInitializerFunctionOut = &ContextInitializer;
	*contextFinalizerFunctionOut = &ContextFinalizer;
}

/**
 * Called when the extension is being destroyed. NOTE: This may not always
 * be called.
 */
extern "C" void NAHB2DExtensionFinalizer(void* extData)
{
}

/***************************************************************************
 * Extension context initialize/finalize functions
 **************************************************************************/

/**
 * Called when the extension context object is created. This function is
 * responsible for setting up the function map for ActionScript method names
 * to native functions.
 *
 * See also: ExtensionFunctions.m
 */
static void ContextInitializer(void* extensionData,
                               const uint8_t* contextType,
                               FREContext context,
                               uint32_t* numberOfNamedFunctionsOut,
                               const FRENamedFunction** namedFunctionsArrayOut)
{
    *numberOfNamedFunctionsOut = NAHB2D_createNamedFunctionsArray(namedFunctionsArrayOut);
    FREResult result = FRESetContextNativeData(context, new SessionContext());
    if (result != FRE_OK) 
    {
        DISPATCH_INTERNAL_ERROR(context, "Could not set context native data");
    }
}


/**
 * Called when the context is about to be destroyed.
 */
static void ContextFinalizer(FREContext context)
{
    void* sc; 
    if( FREGetContextNativeData(context, &sc) == FRE_OK && sc != NULL )
    {
        delete (SessionContext*)sc;
    }
}
