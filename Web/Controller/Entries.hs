module Web.Controller.Entries where

import Web.Controller.Prelude
import Web.View.Entries.Show
import Web.View.Entries.New
import qualified Data.Text as T
import qualified Network.URI as URI
import qualified Data.Text.Read as Read

instance Controller EntriesController where
    action CreateEntryAction = do
        let entry = newRecord @Entry
        let maybeExample = do
            uri <- param @Text "url"
                |> T.unpack
                |> URI.parseURI
            let youtubeId = URI.uriPath uri
                            |> T.pack
                            |> T.tail
            start <- case URI.uriQuery uri
                        |> T.pack
                        |> T.drop 3
                        |> Read.decimal of
                        Right (start, _) -> Just start
                        Left _ -> Nothing
            newRecord @Example
                |> set #userId currentUserId
                |> set #youtubeId youtubeId
                |> set #start start
                |> pure
        entry
            |> fill @'["title"]
            |> ifValid \case
                Left entry -> render NewView { .. } 
                Right entry -> do
                    entry <- entry |> createRecord
                    setSuccessMessage "Entry created"
                    let entryId = get #id entry
                    redirectTo ShowEntryAction { .. }

    action NewEntryAction { title }  = do
        let entry = newRecord |> set #title title
        render NewView { .. }

    action ShowEntryAction { entryId } = do
        entry <- fetch entryId
        render ShowView { .. }
