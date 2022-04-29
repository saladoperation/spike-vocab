module Web.View.Entries.New where
import Web.View.Prelude

data NewView = NewView { entry :: Entry }

instance View NewView where
    html NewView { .. } = [hsx|
        <h1>{get #title entry}</h1>
        {renderForm entry}
    |]

renderForm :: Entry -> Html
renderForm entry = formFor entry [hsx|
    {(hiddenField #title)}
    <div class="form-group">
        <input name="url" type="url" class="form-control" placeholder="URL" required="required" autofocus="autofocus"/>
    </div>
    {submitButton}

|]