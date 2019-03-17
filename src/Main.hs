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

data Email = Email { email :: String } deriving (Generic, Show)

instance FromJSON Email

insertQuery :: Database.SQLite.Simple.Query
insertQuery = "INSERT INTO subscriber (id, email) VALUES (?, ?)"

createSubscriber :: Connection -> ActionT Text IO ()
createSubscriber connection = do
  (e :: Email) <- jsonData
  id <- liftIO $ UUIDV4.nextRandom
  liftIO $ execute connection insertQuery (toString id, email e)
  status status201

main :: IO ()
main = do
  dbFile <- getEnv "DATABASE_FILE"
  port <- getEnv "PORT"
  connection <- open dbFile
  scotty (read port) $ do
    middleware logStdoutDev
    post "/" $ do createSubscriber connection
