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
#ifndef NaHBox2D_ExtensionFunctions_h
#define NaHBox2D_ExtensionFunctions_h

#include "FlashRuntimeExtensions.h"

// Begin avoiding unwanted name mangling
#ifdef __cplusplus
extern "C" {
#endif

/**
 * This function is called by the extension initialiser in order to map the
 * native functions to their counterparts which can be called by the 
 * extension's ActionScript wrapper.
 *
 * See: ExtensionLifecyle.m
 */
uint32_t NAHB2D_createNamedFunctionsArray(const FRENamedFunction** functions);

// End avoiding unwanted name mangling
#ifdef __cplusplus
}
#endif

#endif /* #ifndef NaHBox2D_ExtensionFunctions_h */
