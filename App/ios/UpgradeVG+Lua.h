//
//  UpgradeVG+Lua.h
//  Plugin
//
//  Created by Bruno Barbosa Pinheiro on 3/13/14.
//
//

#import "UpgradeVG.h"

@interface UpgradeVG (Lua)

- (id) initFromLua:(NSDictionary *) luaData;

@end
