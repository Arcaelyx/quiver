{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Main where

import Data.Aeson
import GHC.Generics
import Network.Wai.Middleware.RequestLogger
import System.Environment
import Web.Scotty

data Email = Email String deriving (Generic, Show)

instance FromJSON Email where
  parseJSON (Object v) =
    Email <$> v .: "email"

main :: IO ()
main = do
  port <- getEnv "PORT"
  scotty (read port) $ do
    middleware logStdoutDev
