module Web.Controller.Searches where

import Web.Controller.Prelude
import Web.View.Searches.Show
import Database.PostgreSQL.Simple.Types

maxOutputLength :: Int
maxOutputLength = 4

instance Controller SearchesController where
    action ShowSearchAction { keyword } = do
        entry <- query @Entry |> findMaybeBy #title keyword
        let match = isJust entry
        entries :: [Entry] <- sqlQuery "SELECT * FROM entries ORDER BY SIMILARITY(METAPHONE(title, ?), METAPHONE(?, ?)) DESC" (maxOutputLength, keyword, maxOutputLength)
        render ShowView { .. }
