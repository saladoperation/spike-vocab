module Application.Helper.Controller where

import IHP.ControllerPrelude
import qualified Data.Text as T
import qualified Network.URI as URI
import qualified Data.Text.Read as Read

-- Here you can add functions which are available in all your controllers

maybeExample example = do
    uri <- param @Text "url"
        |> T.unpack
        |> URI.parseURI
    let youtubeId = URI.uriPath uri
                    |> T.pack
                    |> T.tail
    start <- case URI.uriQuery uri
                |> T.pack
                |> T.drop 3
                |> Read.decimal of
                Right (start, _) -> Just start
                Left _ -> Nothing
    example
        |> set #youtubeId youtubeId
        |> set #start start
        |> validateField #youtubeId nonEmpty
        |> pure
