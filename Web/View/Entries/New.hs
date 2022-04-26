module Web.View.Entries.New where
import Web.View.Prelude

data NewView = NewView { entry :: Entry }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>New Entry</h1>
        {renderForm entry}
    |]

renderForm :: Entry -> Html
renderForm entry = formFor entry [hsx|
    {(textField #title)}
    {submitButton}

|]