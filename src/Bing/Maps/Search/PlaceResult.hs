{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module Bing.Maps.Search.PlaceResult where

import GHCJS.Types
import GHCJS.Marshal

import Bing.Maps.Location

newtype GeoLocation = GeoLocation JSVal
    deriving (ToJSVal, FromJSVal)

foreign import javascript unsafe "($1)['location']"
    location :: GeoLocation -> Location


newtype PlaceResult = PlaceResult JSVal
    deriving FromJSVal

foreign import javascript unsafe "($1)['location']"
    geoLocation :: PlaceResult -> GeoLocation

foreign import javascript unsafe "($1)['locations']"
    js_geoLocations :: PlaceResult -> JSVal

geoLocations :: PlaceResult -> IO (Maybe [GeoLocation])
geoLocations pr = fromJSVal $ js_geoLocations pr

