// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

#import "ExtensionLifecycle.h"
#import "ExtensionContextLifecycle.h"

void NAH_B2D_ExtensionInitializer(void** extensionDataOut,
                                  FREContextInitializer* contextInitializerFunctionOut, 
                                  FREContextFinalizer* contextFinalizerFunctionOut)
{
    NSLog(@"NAH_B2D_ExtensionInitializer enter");                    
    
	*extensionDataOut = NULL;
	*contextInitializerFunctionOut = &NAH_B2D_ContextInitializer; 
	*contextFinalizerFunctionOut = &NAH_B2D_ContextFinalizer;
    
    NSLog(@"NAH_B2D_ExtensionInitializer exit"); 
}  



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. 
// However, it is not always called.

void NAH_B2D_ExtensionFinalizer(void* extData)
{    
    NSLog(@"NAH_B2D_ExtensionFinalizer called");
}

