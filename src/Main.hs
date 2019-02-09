module Main where

import Network.Wai.Middleware.RequestLogger
import System.Environment
import Web.Scotty

main :: IO ()
main = do
  port <- getEnv "PORT"
  scotty (read port) $ do
    middleware logStdoutDev
