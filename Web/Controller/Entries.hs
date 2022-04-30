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
        let example = newRecord @Example
        let entry = newRecord @Entry
        entry
            |> fill @'["title"]
            |> validateField #title nonEmpty
            |> ifValid \case
                Left entry -> render NewView { .. } 
                Right entry -> do
                    case maybeExample example of
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
