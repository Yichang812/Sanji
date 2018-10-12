module Main exposing (Model, Msg(..), init, main, update, view)

-- import CodeMirror exposing (..)

import Browser
import Html exposing (Html, div, h2, text, textarea)
import Html.Attributes exposing (id, property)
import Json.Encode exposing (string)
import Markdown exposing (toHtml)
import Port exposing (MarkDown, readMarkDown)



---- MODEL ----


type alias Model =
    { code : String
    , docs : String
    }



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ toHtml [] model.docs
        , div []
            [ h2 [] [ text "Playground" ]
            , textarea [ id "playground" ] [ text model.code ]
            ]
        ]


{-| TODO: preview
<https://github.com/elm/html/issues/172#issuecomment-416975608>
-}



---- UPDATE ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    readMarkDown ReceivedDataFromJS


type Msg
    = ReceivedDataFromJS String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedDataFromJS data ->
            ( { model | docs = data }, Cmd.none )



---- INIT ----


init : ( Model, Cmd Msg )
init =
    let
        model =
            { code = "<div>test</div>"
            , docs = ""
            }
    in
    ( model, Cmd.none )



---- PROGRAM ----


main : Program {} Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
