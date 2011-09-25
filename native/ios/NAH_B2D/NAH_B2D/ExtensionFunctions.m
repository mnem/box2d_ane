#import "ExtensionFunctions.h"

FREObject NAH_B2D_hello(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"Entering NAH_B2D_hello");
    
    FREObject result;
    uint8_t reply[] = "Why, hello there. I'm your platform native. How do you do?";
    
    FRENewObjectFromUTF8(sizeof(reply), reply, &result);
    
    return result;
}
