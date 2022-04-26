module Web.View.Searches.Show where
import Web.View.Prelude

data ShowView = ShowView { keyword :: Text, entries :: [Entry] }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <ol>{forEach entries renderEntry}</ol>
    |]
        where
            renderEntry entry = [hsx|
                <li>{get #title entry}</li>
            |]