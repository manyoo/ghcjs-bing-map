{-# LANGUAGE JavaScriptFFI #-}
module Bing.Event where

import GHCJS.Types
import GHCJS.Foreign.Callback
import Data.JSString

import Bing.Maps.Types
import Bing.Maps.Map

type BingEventHandler = JSVal

foreign import javascript unsafe "Microsoft['Maps']['Events']['addHandler']($1, $2, $3)"
    jsAddHandler :: Map -> JSString -> Callback (IO ()) -> IO BingEventHandler

addHandler :: Map -> JSString -> IO () -> IO BingEventHandler
addHandler m evtName cb = do
    jsCb <- syncCallback ThrowWouldBlock cb
    jsAddHandler m evtName jsCb

foreign import javascript unsafe "Microsoft['Maps']['Events']['removeHandler']($1)"
    removeHandler :: BingEventHandler -> IO ()
