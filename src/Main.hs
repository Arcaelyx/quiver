{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}

module Main where

import Data.Aeson
import Database.SQLite.Simple
import GHC.Generics
import Network.Wai.Middleware.RequestLogger
import System.Environment
import Web.Scotty

data Email = Email String deriving (Generic, Show)

instance FromJSON Email where
  parseJSON (Object v) =
    Email <$> v .: "email"

insertQuery :: Database.SQLite.Simple.Query
insertQuery = "INSERT INTO subscriber (id, email) VALUES (?, ?)"

fromEmail :: Email -> String
fromEmail (Email email) = email

main :: IO ()
main = do
  port <- getEnv "PORT"
  scotty (read port) $ do
    middleware logStdoutDev
