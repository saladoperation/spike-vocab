module Web.View.Examples.Edit where
import Web.View.Prelude

data EditView = EditView { example :: Example }

instance View EditView where
    html EditView { .. } = renderModal Modal
                { modalTitle = "Edit Example"
                , modalCloseUrl = get #entryId example 
                                    |> ShowEntryAction
                                    |> pathTo 
                , modalFooter = Nothing
                , modalContent = [hsx|
                        {renderForm example}
                    |]
                }

renderForm :: Example -> Html
renderForm example = formFor example [hsx|
    <div class="form-group">
        <input name="url" type="url" class="form-control" value={"https://youtu.be/" <> get #youtubeId example <> "?t=" <> get #start example |> show} required="required" autofocus="autofocus"/>
    </div>
    {submitButton}

|]