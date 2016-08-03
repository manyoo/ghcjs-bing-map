{-# LANGUAGE JavaScriptFFI #-}
module Bing.Maps.Types where

import GHCJS.Types
import GHCJS.Marshal
import JavaScript.Object

type BingMapType = JSString

foreign import javascript unsafe "Microsoft['Maps']['MapTypeId']['aerial']"
    bingMapTypeAerial :: BingMapType

foreign import javascript unsafe "Microsoft['Maps']['MapTypeId']['birdseye']"
    bingMapTypeBirdsEye :: BingMapType

foreign import javascript unsafe "Microsoft['Maps']['MapTypeId']['road']"
    bingMapTypeRoad :: BingMapType


type LabelOverlayState = JSString

foreign import javascript unsafe "Microsoft['Maps']['LabelOverlay']['hidden']"
    bingMapLabelHidden :: LabelOverlayState

foreign import javascript unsafe "Microsoft['Maps']['LabelOverlay']['visible']"
    bingMapLabelVisible :: LabelOverlayState

type Heading = Int

type JSMapOptions = Object

-- | helper function to construct option values
c ~: v = c v

-- | a helper function used in this library for building JS objects easier
toJSValsHelper :: (ToJSVal v) => k -> v -> IO (k, JSVal)
toJSValsHelper k v = toJSVal v >>= return . (,) k

