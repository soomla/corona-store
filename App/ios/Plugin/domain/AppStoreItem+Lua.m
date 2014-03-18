//
//  AppStoreItem+Lua.m
//  Plugin
//
//  Created by Bruno Barbosa Pinheiro on 3/11/14.
//
//

#import "AppStoreItem+Lua.h"

#define kAppStoreItem_ProductId         @"id"
#define kAppStoreItem_Consumption       @"consumption"
#define kAppStoreItem_Price             @"price"
#define kConsumable_Consumable          @"consumable"
#define kConsumable_NonConsumable       @"nonConsumable"
#define kConsumable_AutoRenewable       @"autoRenewableSubscription"
#define kConsumable_NonRenewable        @"nonRenewableSubscription"
#define kConsumable_FreeSubscription    @"freeSubscription"

@implementation AppStoreItem (Lua)

+ (AppStoreItem *) appStoreItemFromLua:(NSDictionary *) luaData {
    
    NSString * productId = [luaData objectForKey:kAppStoreItem_ProductId];
    if([productId isEqualToString:@""] || [productId isKindOfClass:[NSNull class]] || productId == nil) {
        NSLog(@"SOOMLA: %@ can't be null for a Market Product",kAppStoreItem_ProductId);
        return nil;
    }
    NSNumber * price = [luaData objectForKey:kAppStoreItem_Price];
    
    NSString * consumption = [luaData objectForKey:kAppStoreItem_Consumption];
    NSLog(@"Consumption %@",consumption);
    Consumable consumptionType = kFreeSubscription;
    if([consumption isEqualToString:kConsumable_Consumable])             consumptionType = kConsumable;
    else if([consumption isEqualToString:kConsumable_NonConsumable])     consumptionType = kNonConsumable;
    else if([consumption isEqualToString:kConsumable_AutoRenewable])     consumptionType = kAutoRenewableSubscription;
    else if([consumption isEqualToString:kConsumable_NonRenewable])      consumptionType = kNonRenewableSubscription;
    else if([consumption isEqualToString:kConsumable_FreeSubscription])  consumptionType = kFreeSubscription;

    NSLog(@"consumption type %d",consumptionType);
    AppStoreItem * storeItem = [[AppStoreItem alloc] initWithProductId:productId
                                                         andConsumable:consumptionType
                                                              andPrice:[price doubleValue]];
    
    return storeItem;
}

@end
