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
    {(textField #youtubeId)}
    {(textField #start)}
    {submitButton}

|]