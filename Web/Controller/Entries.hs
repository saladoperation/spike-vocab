module Web.Controller.Entries where

import Web.Controller.Prelude
import Web.View.Entries.Show
import Web.View.Entries.New

instance Controller EntriesController where
    action NewEntryAction { title }  = do
        let entry = newRecord |> set #title title
        render NewView { .. }

    action ShowEntryAction { entryId } = do
        entry <- fetch entryId
        render ShowView { .. }
