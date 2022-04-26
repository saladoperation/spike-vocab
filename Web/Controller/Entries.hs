module Web.Controller.Entries where

import Web.Controller.Prelude
import Web.View.Entries.Show
import Web.View.Entries.New

instance Controller EntriesController where
    action CreateEntryAction = do
        let entry = newRecord @Entry
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
