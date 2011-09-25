// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

#import "ExtensionLifecycle.h"
#import "ExtensionContextLifecycle.h"

void NAHB2DExtensionInitializer(void** extensionDataOut,
                                FREContextInitializer* contextInitializerFunctionOut, 
                                FREContextFinalizer* contextFinalizerFunctionOut)
{
    NSLog(@"NAHB2DExtensionInitializer enter");                    
    
	*extensionDataOut = NULL;
	*contextInitializerFunctionOut = &NAH_B2D_ContextInitializer; 
	*contextFinalizerFunctionOut = &NAH_B2D_ContextFinalizer;
    
    NSLog(@"NAHB2DExtensionInitializer exit"); 
}  



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. 
// However, it is not always called.

void NAHB2DExtensionFinalizer(void* extData)
{    
    NSLog(@"NAHB2DExtensionFinalizer called");
}

