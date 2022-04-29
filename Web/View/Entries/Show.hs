module Web.View.Entries.Show where
import Web.View.Prelude

data ShowView = ShowView { entry :: Include "examples" Entry }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <h1>{get #title entry}</h1>
        <p>{forEach (get #examples entry) renderExample}</p>

    |]

renderExample example = [hsx|
    <iframe allowfullscreen="" frameborder="0" height="315" src={"https://www.youtube.com/embed/" <> (get #youtubeId example) <> "?start=" <> (show $ get #start example)} width="420"></iframe>
|]