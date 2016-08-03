{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module Bing.Maps.Location where

import GHCJS.Types
import GHCJS.Marshal

newtype Location = Location JSVal
    deriving ToJSVal

newtype Latitude  = Latitude {
    getLatNum :: Double
    }
newtype Longitude = Longitude {
    getLngNum :: Double
    }

foreign import javascript unsafe "new Microsoft['Maps']['Location']($1, $2)"
    mkLocation :: Latitude -> Longitude -> Location

foreign import javascript unsafe "($1)['latitude']"
    latitude :: Location -> Latitude

foreign import javascript unsafe "($1)['longitude']"
    longitude :: Location -> Longitude

foreign import javascript unsafe "Microsoft['Maps']['Location']['areEqual']($1, $2)"
    areEqual :: Location -> Location -> Bool

foreign import javascript unsafe "Microsoft['Maps']['Location']['normalizeLongitude']($1)"
    normalizeLongitude :: Longitude -> Longitude
