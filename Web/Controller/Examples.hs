module Web.Controller.Examples where

import Web.Controller.Prelude
import Web.View.Entries.Show
import Web.View.Entries.New

instance Controller ExamplesController where
    action DeleteExampleAction { exampleId } = do
        example <- fetch exampleId
        let entryId = get #entryId example
        count <- query @Example
            |> filterWhere (#entryId, entryId)
            |> fetchCount
        if count == 1
            then do 
                entry <- fetch entryId
                deleteRecord entry
                setSuccessMessage "Entry deleted"
                render NewView { .. }
            else do
                entry <- fetch entryId
                    >>= fetchRelated #examples
                deleteRecord example
                setSuccessMessage "Example deleted"
                render ShowView { .. }
