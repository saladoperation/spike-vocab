module Web.Controller.Examples where

import Web.Controller.Prelude
import Web.Controller.Entries ()
import Web.View.Entries.Show
import qualified Web.View.Entries.New as NewEntryView
import Web.View.Examples.New
import Web.View.Examples.Edit
import qualified Data.Text as T
import qualified Network.URI as URI
import qualified Data.Text.Read as Read

instance Controller ExamplesController where
    action CreateExampleAction = do
        let example = newRecord @Example
                        |> buildExample
                        |> set #userId currentUserId
        let entryId = get #entryId example
        case maybeExample example of
            Nothing -> redirectTo ShowEntryAction { .. }
            Just example -> example |> ifValid \case
                Left example -> render NewView { .. } 
                Right example -> do
                    example <- example |> createRecord
                    setSuccessMessage "Example created"
                    redirectTo ShowEntryAction { .. }

    action NewExampleAction { entryId } = do
        let example = newRecord @Example
                        |> set #entryId entryId
        setModal NewView { .. }

        jumpToAction ShowEntryAction { .. }

    action UpdateExampleAction { exampleId } = do
        example <- fetch exampleId
        let entryId = get #entryId example
        case maybeExample example of
            Nothing -> render EditView { .. }
            Just example -> example |> ifValid \case
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
                render NewEntryView.NewView { .. }
            else do
                deleteRecord example
                setSuccessMessage "Example deleted"
                entry <- fetch entryId
                    >>= fetchRelated #examples
                render ShowView { .. }

buildExample example = example
                        |> fill @'["entryId"]
