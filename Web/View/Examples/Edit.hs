module Web.View.Examples.Edit where
import Web.View.Prelude

data EditView = EditView { example :: Example }

instance View EditView where
    html EditView { .. } = [hsx|
        <h1>Edit Example</h1>
        {renderForm example}
    |]

renderForm :: Example -> Html
renderForm example = formFor example [hsx|
    {(textField #youtubeId)}
    {(textField #start)}
    {submitButton}

|]