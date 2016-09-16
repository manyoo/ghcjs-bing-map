{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving, OverloadedStrings #-}
module Bing.Maps.Search.GeocodeRequestOptions where

import GHCJS.Types
import GHCJS.Marshal
import GHCJS.Foreign.Callback
import GHCJS.Concurrent
import JavaScript.Object

import Bing.Maps.Types
import Bing.Maps.Search.GeocodeResult

data GeocodeRequestOptions = GeocodeRequestOptions {
    geoReqWhere       :: String,
    geoReqCount       :: Int,
    geoReqCallback    :: GeocodeResult -> IO (),
    geoReqErrCallback :: JSVal -> IO ()
    }


toJSGeoReqOption :: GeocodeRequestOptions -> IO Object
toJSGeoReqOption opt = do
    obj <- create
    (kw, vw) <- toJSValsHelper "where" (geoReqWhere opt)
    setProp kw vw obj

    (kc, vc) <- toJSValsHelper "count" (geoReqCount opt)
    setProp kc vc obj

    cb <- syncCallback2 ThrowWouldBlock (\v1 _ -> do
                                                res1 <- fromJSVal v1
                                                mapM_ (geoReqCallback opt) res1)
    (kcb, vcb) <- toJSValsHelper "callback" $ jsval cb
    setProp kcb vcb obj

    ecb <- syncCallback1 ThrowWouldBlock (geoReqErrCallback opt)
    (kecb, vecb) <- toJSValsHelper "errorCallback" $ jsval ecb
    setProp kecb vecb obj
    
    return obj
