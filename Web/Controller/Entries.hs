module Web.Controller.Entries where

import Web.Controller.Prelude
import Web.View.Entries.Show

instance Controller EntriesController where
    action ShowEntryAction { entryId } = do
        entry <- fetch entryId
        render ShowView { .. }
