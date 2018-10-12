port module Port exposing (MarkDown, readMarkDown)

import Html exposing (Html, div, text)


type alias MarkDown =
    String


port readMarkDown : (MarkDown -> msg) -> Sub msg
