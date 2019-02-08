module Main where

import Network.Wai.Middleware.RequestLogger
import Web.Scotty

main :: IO ()
main = do
  scotty 3000 $ do
    middleware logStdoutDev
