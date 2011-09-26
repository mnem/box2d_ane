#import "ExtensionFunctions.h"

FREObject NAH_B2D_hello(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
{
    NSLog(@"NAH_B2D_hello enter");
    
    FREObject result;
    uint8_t reply[] = "Why, hello there. I'm your platform native. How do you do?";
    
    FRENewObjectFromUTF8(sizeof(reply), reply, &result);

    NSLog(@"NAH_B2D_hello exit, result: %p", result);
    
    return result;
}
