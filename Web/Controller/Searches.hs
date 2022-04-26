module Web.Controller.Searches where

import Web.Controller.Prelude
import Web.View.Searches.Show

instance Controller SearchesController where
    action ShowSearchAction { keyword } = do
        entries :: [Entry] <- sqlQuery "SELECT * FROM entries ORDER BY SIMILARITY(METAPHONE(title, 4), METAPHONE(?, 4)) DESC" (Only keyword)
        render ShowView { .. }
