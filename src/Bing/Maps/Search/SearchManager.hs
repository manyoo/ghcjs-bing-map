{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module Bing.Maps.Search.SearchManager where

import GHCJS.Types
import GHCJS.Marshal
import Data.JSString
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

foreign import javascript interruptible "Microsoft['Maps']['loadModule']('Microsoft.Maps.Search', { callback: function() {\
                                        \    var sm = new Microsoft['Maps']['Search']['SearchManager']($2);\
                                        \    sm.geocode({where: ($1), \
                                        \                count: 10,\
                                        \                callback: function(res) { \
                                        \                              var plcRes = res['results'][0];\
                                        \                              var l = plcRes['location'];\
                                        \                              var lat = l['latitude'];\
                                        \                              var lng = l['longitude'];\
                                        \                              $c(lat, lng);\
                                        \                          },\
                                        \                errorCallback: function () { return; }\
                                        \    });\
                                        \}});"
    js_geocodeAsync :: JSString -> Map -> IO (Double, Double)

geocodeAsync :: String -> Map -> IO (Double, Double)
geocodeAsync addr map = js_geocodeAsync (pack addr) map
