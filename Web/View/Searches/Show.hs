module Web.View.Searches.Show where
import Web.View.Prelude

data ShowView = ShowView { keyword :: Text }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>Show Search</h1>
    |]