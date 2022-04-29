module Web.Controller.Examples where

import Web.Controller.Prelude

instance Controller ExamplesController where
    action DeleteExampleAction { exampleId } = do
        example <- fetch exampleId
        let entryId = get #entryId example
        deleteRecord example
        setSuccessMessage "Example deleted"
        redirectTo ShowEntryAction { .. }
