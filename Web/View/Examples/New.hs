module Web.View.Examples.New where
import Web.View.Prelude

data NewView = NewView { example :: Example }

instance View NewView where
    html NewView { .. } = renderModal Modal
                { modalTitle = "Create Example"
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
    {youtubeUrl}
    {submitButton}

|]
