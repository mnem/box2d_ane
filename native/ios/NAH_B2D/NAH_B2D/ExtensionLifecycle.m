// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

#import "ExtensionLifecycle.h"
#import "ExtensionContextLifecycle.h"

void ADBEExtInitializer(void** extDataToSet,
                        FREContextInitializer* ctxInitializerToSet, 
                        FREContextFinalizer* ctxFinalizerToSet)
{
    NSLog(@"Entering ADBEExtInitializer()");                    
    
	*extDataToSet = NULL;
	*ctxInitializerToSet = &NAH_B2D_ContextInitializer; 
	*ctxFinalizerToSet = &NAH_B2D_ContextFinalizer;
    
    NSLog(@"Exiting ADBEExtInitializer()"); 
}  



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. 
// However, it is not always called.

void ADBEExtFinalizer(void* extData)
{    
    NSLog(@"Entering ADBEExtFinalizer()");
}

