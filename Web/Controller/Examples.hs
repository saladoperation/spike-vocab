module Web.Controller.Examples where

import Web.Controller.Prelude
import Web.Controller.Entries ()
import Web.View.Entries.Show
import Web.View.Entries.New
import Web.View.Examples.Edit

instance Controller ExamplesController where
    action UpdateExampleAction { exampleId } = do
        example <- fetch exampleId
        let entryId = get #entryId example
        example
            |> buildExample
            |> ifValid \case
                Left example -> render EditView { .. }
                Right example -> do
                    example <- example |> updateRecord
                    setSuccessMessage "Example updated"
                    redirectTo ShowEntryAction { .. }

    action EditExampleAction { exampleId } = do
        example <- fetch exampleId
        setModal EditView { .. }
        let entryId = get #entryId example

        jumpToAction ShowEntryAction { .. }

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

buildExample example = example
    |> fill @["youtubeId", "start"]
