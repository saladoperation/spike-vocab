module Application.Helper.View where

import IHP.ViewPrelude

-- Here you can add functions which are available in all your views

youtubeUrl = [hsx|
    <div class="form-group">
        <input name="url" type="url" class="form-control" placeholder="URL" required="required" autofocus="autofocus"/>
    </div>
|]