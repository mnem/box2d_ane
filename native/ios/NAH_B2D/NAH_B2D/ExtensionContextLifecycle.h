//
//  ExtesionContextLifecycle.h
//  NAH_B2D
//
//  Created by David Wagner on 25/09/2011.
//  Copyright 2011 Noise & Heat. All rights reserved.
//

/**
 * Called when the extension context object is created.
 */
void NAH_B2D_ContextInitializer(void* extensionData, 
                                const uint8_t* contextType,
                                FREContext context,
                                uint32_t* numberOfNamedFunctions, 
                                const FRENamedFunction** namedFunctionsArray);

/**
 * Called when the extension context will be destroyed.
 */
void NAH_B2D_ContextFinalizer(FREContext context);
