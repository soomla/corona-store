//
//  PluginSoomla.mm
//  Soomla for Corona
//
//  Copyright (c) 2014 Soomla. All rights reserved.

#import "PluginSoomla.h"
#import <UIKit/UIKit.h>
#import "SoomlaStore.h"

#import "NSDictionary+CreateFromLua.h"
#import "SoomlaStore.h"
#import "VirtualCurrency.h"
#import "VirtualCurrencyPack+Lua.h"
#import "SingleUseVG+Lua.h"

PluginSoomla::PluginSoomla() {}

PluginSoomla * PluginSoomla::GetLibrary(lua_State * L) {
    PluginSoomla * soomla = (PluginSoomla *) CoronaLuaToUserdata(L,lua_upvalueindex(1));
    return soomla;
}

int PluginSoomla::createCurrency(lua_State * L) {
    NSDictionary * currencyData = [NSDictionary dictionaryFromLua:L tableIndex:lua_gettop(L)];
    VirtualCurrency * currency = [[VirtualCurrency alloc] initWithDictionary:currencyData];
    if(currency.itemId == nil) NSLog(@"SOOMLA: itemId shouldn't be empty! The currency %@ won't be added to the Store",currency.name);
    else [[SoomlaStore sharedInstance] addVirtualItem:currency];
    lua_pushstring(L,[currency.itemId cStringUsingEncoding:NSUTF8StringEncoding]);
    return 1;
}

int PluginSoomla::createCurrencyPack(lua_State * L) {
    NSDictionary * currencyPackData = [NSDictionary dictionaryFromLua:L tableIndex:lua_gettop(L)];
    VirtualCurrencyPack * currencyPack = [VirtualCurrencyPack currencyPackFromLua:currencyPackData];
    if(currencyPack.itemId == nil) NSLog(@"SOOMLA: itemId shouldn't be empty! The currency pack %@ won't be added to the Store",currencyPack.name);
    else [[SoomlaStore sharedInstance] addVirtualItem:currencyPack];
    lua_pushstring(L,[currencyPack.itemId cStringUsingEncoding:NSUTF8StringEncoding]);
    return 1;
}

int PluginSoomla::createSingleUseVG(lua_State * L) {
    NSDictionary * singleUseVGData = [NSDictionary dictionaryFromLua:L tableIndex:lua_gettop(L)];
    SingleUseVG * singleUseVG = [SingleUseVG singleUseVGFromLua:singleUseVGData];
    if(singleUseVG.itemId == nil) NSLog(@"SOOMLA: itemId shouldn't be empty! The single use VG %@ won't be added to the Store",singleUseVG.name);
    else [[SoomlaStore sharedInstance] addVirtualItem:singleUseVG];
    lua_pushstring(L,[singleUseVG.itemId cStringUsingEncoding:NSUTF8StringEncoding]);
    return 1;
}

//CORONA EXPORT
const char PluginSoomla::kName[] = "plugin.soomla";

int PluginSoomla::Finalizer(lua_State * L) {
    PluginSoomla * soomla = (PluginSoomla *) CoronaLuaToUserdata(L,1);
    
    //TODO: Delete all the Lua References right here!
    
    delete soomla;
    return 0;
}

int PluginSoomla::Export(lua_State * L) {
    const char kMetatableName[] = __FILE__;
    CoronaLuaInitializeGCMetatable(L,kMetatableName,Finalizer);
    
    const luaL_Reg exportTable[] = {
        { "createCurrency", createCurrency },
        { "createCurrencyPack", createCurrencyPack },
        { "createSingleUseVG", createSingleUseVG },
        { NULL, NULL }
    };
    
    PluginSoomla * soomla = new PluginSoomla();
    CoronaLuaPushUserdata(L,soomla,kMetatableName);
    
    luaL_openlib(L,kName,exportTable,1);
    return 1;
}

CORONA_EXPORT int luaopen_plugin_soomla(lua_State * L) {
    return PluginSoomla::Export(L);
}