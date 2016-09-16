{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module Bing.Maps.Search.GeocodeResult where

import GHCJS.Types
import GHCJS.Marshal

import Bing.Maps.Search.PlaceResult

newtype GeocodeResult = GecodeResult JSVal
    deriving FromJSVal

foreign import javascript unsafe "($1)['results']"
    js_results :: GeocodeResult -> JSVal

geoResults :: GeocodeResult -> IO (Maybe [PlaceResult])
geoResults = fromJSVal . js_results
