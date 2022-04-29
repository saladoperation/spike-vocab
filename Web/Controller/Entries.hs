module Web.Controller.Entries where

import Web.Controller.Prelude
import Web.View.Entries.Show
import Web.View.Entries.New
import qualified Data.Text as T
import qualified Network.URI as URI
import qualified Data.Text.Read as Read

instance Controller EntriesController where
    action CreateEntryAction = do
        ensureIsUser
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
                |> validateField #youtubeId nonEmpty
                |> pure
        let entry = newRecord @Entry
        entry
            |> fill @'["title"]
            |> validateField #title nonEmpty
            |> ifValid \case
                Left entry -> render NewView { .. } 
                Right entry -> do
                    case maybeExample of
                        Nothing -> render NewView { .. } 
                        Just example -> example |> ifValid \case
                            Left example -> render NewView { .. }
                            Right example -> do
                                entry <- withTransaction do
                                    entry <- entry |> createRecord
                                    example 
                                        |> set #entryId (get #id entry)
                                        |> createRecord
                                    pure entry
                                let entryId = get #id entry
                                setSuccessMessage "Entry created"
                                redirectTo ShowEntryAction { .. }

    action NewEntryAction { title }  = do
        let entry = newRecord |> set #title title
        render NewView { .. }

    action ShowEntryAction { entryId } = do
        entry <- fetch entryId
            >>= fetchRelated #examples
        render ShowView { .. }
