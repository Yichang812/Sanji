module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, div, text)
import Markdown exposing (toHtml)
import Port exposing (MarkDown, readMarkDown)



---- MODEL ----


type alias Model =
    String



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ toHtml [] model ]



---- UPDATE ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    readMarkDown ReceivedDataFromJS


type Msg
    = ReceivedDataFromJS Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReceivedDataFromJS data ->
            ( data, Cmd.none )



---- INIT ----


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )



---- PROGRAM ----


main : Program {} Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
