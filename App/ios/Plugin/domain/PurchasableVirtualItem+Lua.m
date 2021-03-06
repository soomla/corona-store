//
//  PurchasableVirtualItem+Lua.m
//  Plugin
//
//  Created by Bruno Barbosa Pinheiro on 3/13/14.
//
//

#import "PurchasableVirtualItem+Lua.h"
#import "VirtualItem+Lua.h"
#import "PurchaseType+Lua.h"

#define kPurchasableVirtualItem_Purchase        @"purchase"

@implementation PurchasableVirtualItem (Lua)

- (id) initFromLua:(NSDictionary *) luaData {
    
    self = [super initFromLua:luaData];
    if(self == nil) return nil;
    
    NSDictionary * purchaseData = [luaData objectForKey:kPurchasableVirtualItem_Purchase];
    PurchaseType * purchase = [PurchaseType purchaseTypeFromLua:purchaseData];
    if([purchase isKindOfClass:[NSNull class]] || purchase == nil) {
        NSLog(@"SOOMLA: The purchase isn't valid for PurchasableItem %@.",self.name);
        return nil;
    }
    self.purchaseType = purchase;
    self.purchaseType.associatedItem = self;
    return self;
}

- (NSDictionary *) toLuaDictionary {
    NSMutableDictionary * luaDictionary = [NSMutableDictionary dictionaryWithDictionary:[super toLuaDictionary]];
    [luaDictionary setValue:[self.purchaseType toLuaDictionary] forKey:kPurchasableVirtualItem_Purchase];
    return [NSDictionary dictionaryWithDictionary:luaDictionary];
}

@end
