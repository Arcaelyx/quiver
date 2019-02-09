{-# LANGUAGE DeriveGeneric, OverloadedStrings, ScopedTypeVariables #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import Data.Text.Lazy
import Data.UUID (toString)
import Database.SQLite.Simple
import GHC.Generics
import Network.HTTP.Types
import Network.Wai.Middleware.RequestLogger
import System.Environment
import Web.Scotty
import Web.Scotty.Internal.Types (ActionT)

import qualified Data.UUID.V4 as UUIDV4

data Email = Email String deriving (Generic, Show)

instance FromJSON Email where
  parseJSON (Object v) =
    Email <$> v .: "email"

insertQuery :: Database.SQLite.Simple.Query
insertQuery = "INSERT INTO subscriber (id, email) VALUES (?, ?)"

fromEmail :: Email -> String
fromEmail (Email email) = email

createSubscriber :: Connection -> ActionT Text IO ()
createSubscriber connection = do
  (email :: Email) <- jsonData
  id <- liftIO $ UUIDV4.nextRandom
  liftIO $ execute connection insertQuery (toString id, fromEmail email)
  status status201

main :: IO ()
main = do
  port <- getEnv "PORT"
  scotty (read port) $ do
    middleware logStdoutDev
