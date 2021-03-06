//
//  EquippableVG+Lua.m
//  Plugin
//
//  Created by Bruno Barbosa Pinheiro on 3/13/14.
//
//

#import "EquippableVG+Lua.h"
#import "PurchasableVirtualItem+Lua.h"

#define kEquippable_EquipModel  @"equipModel"
#define kEquipModel_Local       @"local"
#define kEquipModel_Category    @"category"
#define kEquipModel_Global      @"global"

@implementation EquippableVG (Lua)

- (id) initFromLua:(NSDictionary *)luaData {

    self = [super initFromLua:luaData];
    if(self == nil) return nil;
    
    NSString * equipModel = [luaData objectForKey:kEquippable_EquipModel];
    if([equipModel isKindOfClass:[NSNull class]] || equipModel == nil) {
        NSLog(@"SOOMLA: %@ can't be null for EquippableVG %@",kEquippable_EquipModel,self.itemId);
        return nil;
    }
    
    if([equipModel isEqualToString:kEquipModel_Category]) self.equippingModel = kCategory;
    else if([equipModel isEqualToString:kEquipModel_Global]) self.equippingModel = kGlobal;
    else if([equipModel isEqualToString:kEquipModel_Local]) self.equippingModel = kLocal;
    else {
        self.equippingModel = kLocal;
        NSLog(@"SOOMLA: %@ isn't a valid option for equipModel! The options are: %@ , %@ and %@",equipModel,kEquipModel_Local,kEquipModel_Category,kEquipModel_Global);
    }
    return self;
}

- (NSDictionary *) toLuaDictionary {
    NSMutableDictionary * luaDictionary = [NSMutableDictionary dictionaryWithDictionary:[super toLuaDictionary]];
    NSString * equipModel = kEquipModel_Category;
    switch(self.equippingModel) {
        case kCategory: equipModel = kEquipModel_Category; break;
        case kGlobal: equipModel = kEquipModel_Global; break;
        case kLocal: equipModel = kEquipModel_Local; break;
    }
    [luaDictionary setValue:equipModel forKey:kEquippable_EquipModel];
    return [NSDictionary dictionaryWithDictionary:luaDictionary];
}

@end
