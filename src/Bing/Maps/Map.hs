{-# LANGUAGE JavaScriptFFI, OverloadedStrings #-}
module Bing.Maps.Map where

import GHCJS.Types
import GHCJS.Marshal
import GHCJS.DOM.Node

import JavaScript.Object
import Data.JSString

import Control.Monad

import Bing.Maps.Types
import Bing.Maps.Location

newtype Map = Map JSVal

foreign import javascript unsafe "new Microsoft['Maps']['Map']($1, $2)"
    jsMKMap :: Node -> JSMapOptions -> IO Map

mkMap :: Node -> MapOption -> IO Map
mkMap n opt = toJSOption opt >>= jsMKMap n

-- | removes focus from the map control so that it does not respond to keyboard events
foreign import javascript unsafe "($1)['blur']()"
    blur :: Map -> IO ()

-- | applies focus to the map control so that it responds to keyboard events
foreign import javascript unsafe "($1)['focus']()"
    focus :: Map -> IO ()

-- | deletes the Map object and releases any associated resources
foreign import javascript unsafe "($1)['dispose']()"
    dispose :: Map -> IO ()

-- | returns the location of the center of the current map view
foreign import javascript unsafe "($1)['getCneter']()"
    getCenter :: Map -> IO Location

-- | gets the Session ID
foreign import javascript interruptible "($1)['getCredentials'](function(cred) { $c(cred);});"
    getCredentials :: Map -> IO JSString

-- | get Heading of the current map view
foreign import javascript unsafe "($1)['getHeading']()"
    getHeading :: Map -> IO Heading

-- | get the height of the map control
foreign import javascript unsafe "($1)['getHeight']()"
    getHeight :: Map -> IO Double

-- | get the width of the map control
foreign import javascript unsafe "($1)['getWidth']()"
    getWidth :: Map -> IO Double

-- | returns the current scale in meters per pixel of the center of the map
foreign import javascript unsafe "($1)['getMetersPerPixel']()"
    getMetersPerPixel :: Map -> IO Double

-- | returns the zoom level of the current map view
foreign import javascript unsafe "($1)['getZoom']()"
    getZoom :: Map -> IO Int

-- | returns a boolean indicating whether map imagery tiles are currently being downloaded
foreign import javascript unsafe "($1)['isDownloadingTiles']()"
    isDownloadingTiles :: Map -> IO Bool

-- | set the map type
foreign import javascript unsafe "($2)['setMapType']($1)"
    setMapType :: BingMapType -> Map -> IO ()

-- | set map options
foreign import javascript unsafe "($2)['setOptions']($1)"
    jsSetOptions :: JSMapOptions -> Map -> IO ()

-- | set map view options
foreign import javascript unsafe "($2)['setView']($1)"
    jsSetView :: JSMapOptions -> Map -> IO ()

setOptions :: MapOption -> Map -> IO ()
setOptions op m = toJSOption op >>= flip jsSetOptions m

setView :: MapOption -> Map -> IO ()
setView op m = toJSOption op >>= flip jsSetView m

data MapOptionItem = OptCredentials JSString
                   | OptCustomizeOverlays Bool
                   | OptDisableBirdsEye Bool
                   | OptDisableKeyboardInput Bool
                   | OptDisableMouseInput Bool
                   | OptDisablePanning Bool
                   | OptDisableTouchInput Bool
                   | OptDisableUserInput Bool
                   | OptDisableZooming Bool
                   | OptEnableClickableLogo Bool
                   | OptEnableHighDPI Bool
                   | OptEnableSearchLogo Bool
                   | OptFixedMapPosition Bool
                   | OptWidth Int
                   | OptHeight Int
                   | OptInertiaIntensity Double
                   | OptShowBreadcrumb Bool
                   | OptShowCopyright Bool
                   | OptShowDashboard Bool
                   | OptShowMapTypeSelector Bool
                   | OptShowScaleBar Bool
                   | OptTileBuffer Int
                   | OptUseInertia Bool
                   | OptAnimate Bool
                   | OptCenter Location
                   | OptHeading Heading
                   | OptLabelOverlay LabelOverlayState
                   | OptMapType BingMapType
                   | OptZoom Int

type MapOption = [MapOptionItem]

toJSVals :: MapOptionItem -> IO (JSString, JSVal)
toJSVals (OptCredentials c)          = toJSValsHelper "credentials" c
toJSVals (OptCustomizeOverlays c)    = toJSValsHelper "customizeOverlays" c
toJSVals (OptDisableBirdsEye d)      = toJSValsHelper "disableBirdseye" d
toJSVals (OptDisableKeyboardInput d) = toJSValsHelper "disableKeyboardInput" d
toJSVals (OptDisableMouseInput d)    = toJSValsHelper "disableMouseInput" d
toJSVals (OptDisablePanning d)       = toJSValsHelper "disablePanning" d
toJSVals (OptDisableTouchInput d)    = toJSValsHelper "disableTouchInput" d
toJSVals (OptDisableUserInput d)     = toJSValsHelper "disableUserInput" d
toJSVals (OptDisableZooming d)       = toJSValsHelper "disableZooming" d
toJSVals (OptEnableClickableLogo e)  = toJSValsHelper "enableClickableLogo" e
toJSVals (OptEnableHighDPI e)        = toJSValsHelper "enableHighDpi" e
toJSVals (OptEnableSearchLogo e)     = toJSValsHelper "enableSearchLogo" e
toJSVals (OptFixedMapPosition f)     = toJSValsHelper "fixedMapPosition" f
toJSVals (OptWidth w)                = toJSValsHelper "width" w
toJSVals (OptHeight h)               = toJSValsHelper "height" h
toJSVals (OptInertiaIntensity i)     = toJSValsHelper "inertiaIntensity" i
toJSVals (OptShowBreadcrumb s)       = toJSValsHelper "showBreadcrumb" s
toJSVals (OptShowCopyright s)        = toJSValsHelper "showCopyright" s
toJSVals (OptShowDashboard s)        = toJSValsHelper "showDashboard" s
toJSVals (OptShowMapTypeSelector s)  = toJSValsHelper "showMapTypeSelector" s
toJSVals (OptShowScaleBar s)         = toJSValsHelper "showScalebar" s
toJSVals (OptTileBuffer t)           = toJSValsHelper "tileBuffer" t
toJSVals (OptUseInertia u)           = toJSValsHelper "useInertia" u
toJSVals (OptAnimate a)              = toJSValsHelper "animate" a
toJSVals (OptCenter c)               = toJSValsHelper "center" c
toJSVals (OptLabelOverlay l)         = toJSValsHelper "labelOverlay" l
toJSVals (OptHeading h)              = toJSValsHelper "heading" h
toJSVals (OptMapType t)              = toJSValsHelper "mapTypeId" t
toJSVals (OptZoom z)                 = toJSValsHelper "zoom" z


toJSOption :: MapOption -> IO JSMapOptions
toJSOption opts = do
    obj <- create
    forM_ opts (\item -> do
                       (k, v) <- toJSVals item
                       setProp k v obj)
    return obj
