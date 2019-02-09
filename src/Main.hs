{-# LANGUAGE DeriveGeneric #-}

module Main where

import GHC.Generics
import Network.Wai.Middleware.RequestLogger
import System.Environment
import Web.Scotty

data Email = Email String deriving (Generic, Show)

main :: IO ()
main = do
  port <- getEnv "PORT"
  scotty (read port) $ do
    middleware logStdoutDev
