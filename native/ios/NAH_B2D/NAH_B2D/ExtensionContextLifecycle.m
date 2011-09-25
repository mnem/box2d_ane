//
//  NAH_B2D.m
//  NAH_B2D
//
//  Created by David Wagner on 25/09/2011.
//  Copyright 2011 Noise & Heat. All rights reserved.
//

#import "ExtensionContextLifecycle.h"
#import "ExtensionFunctions.h"

void NAH_B2D_ContextInitializer(void* extensionData, 
                                const uint8_t* contextType,
                                FREContext context,
                                uint32_t* numberOfNamedFunctions, 
                                const FRENamedFunction** namedFunctionsArray)
{
    NSLog(@"NAH_B2D_ContextInitializer called.");
    
	*numberOfNamedFunctions = 1;
	FRENamedFunction* functions = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * (*numberOfNamedFunctions));
    
	functions[0].name = (const uint8_t*)"hello";
	functions[0].functionData = NULL;
	functions[0].function = &NAH_B2D_hello;
    
    *namedFunctionsArray = functions;
}

void NAH_B2D_ContextFinalizer(FREContext context)
{
    NSLog(@"NAH_B2D_ContextFinalizer called.");
}
