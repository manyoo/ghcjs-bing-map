{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module Bing.Maps.Search.SearchManager where

import GHCJS.Types
import GHCJS.Marshal

import JavaScript.Object

import Bing.Maps.Map
import Bing.Maps.Search.GeocodeRequestOptions

newtype SearchManager = SearchManager JSVal

foreign import javascript unsafe "new Microsoft['Maps']['Search']['SearchManager']($1)"
    mkSearchManager :: Map -> IO SearchManager

foreign import javascript unsafe "($2)['geocode']($1)"
    js_geocode :: JSVal -> SearchManager -> IO ()

geocode :: GeocodeRequestOptions -> SearchManager -> IO ()
geocode opt mngr = toJSGeoReqOption opt >>= (flip js_geocode mngr . jsval)
