module Web.View.Entries.Show where
import Web.View.Prelude

data ShowView = ShowView { entry :: Include "examples" Entry }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #title entry}</h1>
        <p>{forEach (get #examples entry) renderExample}</p>
        <div><a href={get #id entry |> NewExampleAction} class="mr-2">Create</a></div>
    |]

renderExample example = [hsx|
    <iframe allowfullscreen="" frameborder="0" height="315" src={"https://www.youtube.com/embed/" <> get #youtubeId example <> "?start=" <> get #start example |> show} width="420"></iframe>
    {renderButtons example}
|]

renderButtons example = 
    case do 
            user <- fromFrozenContext @(Maybe User)
            if get #id user == get #userId example
                then pure user
                else Nothing of 
        Nothing -> [hsx||]
        Just user -> [hsx|
        <div>
            <a href={EditExampleAction(get #id example)} class="mr-2">Edit</a>
            <a href={DeleteExampleAction (get #id example)} class="js-delete">Delete</a>
        </div>
        |] 
