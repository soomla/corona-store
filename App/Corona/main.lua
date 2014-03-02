local library = require "plugin.soomla"

-- This event is dispatched to the global Runtime object
-- by `didLoadMain:` in MyCoronaDelegate.mm
local function delegateListener( event )
	native.showAlert(
		"Event dispatched from `didLoadMain:`",
		"of type: " .. tostring( event.name ),
		{ "OK" } )
end
Runtime:addEventListener( "delegate", delegateListener )

-- This event is dispatched to the following Lua function
-- by PluginLibrary::show() in PluginLibrary.mm
local function listener( event )
	native.showAlert( event.name, event.message, { "OK" } )
end

library.init( listener )

timer.performWithDelay( 1000, function()
	library.show( "corona" )
end )

