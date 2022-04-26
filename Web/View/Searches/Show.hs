module Web.View.Searches.Show where
import Web.View.Prelude

data ShowView = ShowView { keyword :: Text, match :: Bool, entries :: [Entry] }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <ol>
            {renderKeyword keyword match}
            {forEach entries renderEntry}
        </ol>
    |]
        where
            renderEntry entry = [hsx|
                <li><a href={ShowEntryAction (get #id entry)}>{get #title entry}</a></li>
            |]

renderKeyword keyword match = if match
    then [hsx||]
    else [hsx|
    <li><a href={NewEntryAction}>{keyword}</a></li>
    |]