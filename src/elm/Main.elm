module Main exposing (Model, Msg(..), init, main, update, view)

-- import CodeMirror exposing (..)

import Browser
import Html exposing (Attribute, Html, a, div, h2, li, text, textarea, ul)
import Html.Attributes exposing (attribute, id)
import Html.Events exposing (on, onClick, onInput, stopPropagationOn, targetValue)
import Json.Decode as Json
import Json.Encode exposing (string)
import Markdown exposing (toHtml)
import Port exposing (getFileContent, readFile, readFileList, setPreview)



---- MODEL ----


type AppState
    = Loading
    | Loaded LoadedModel
    | LoadingError Json.Error


type alias LoadedModel =
    { code : String
    , currentDoc : String
    , docList : List String
    }



---- VIEW ----


view : Model -> Html Msg
view model =
    case model of
        Loaded loadedModel ->
            div []
                [ toHtml [] <| .currentDoc loadedModel
                , div []
                    [ h2 [] [ text "Playground" ]
                    , div [ id "playground__preview", attribute "data-html" <| .code loadedModel ] []
                    , textarea [ id "playground", onInput UpdatePreview ] [ text <| .code loadedModel ]
                    ]
                , fileList <| .docList loadedModel
                ]

        Loading ->
            div [] [ text "loading..." ]

        LoadingError error ->
            div [] [ text <| Json.errorToString error ]


fileList : List String -> Html Msg
fileList docs =
    ul [] <| List.map (\x -> li [ onClick SelectFile ] [ text x ]) docs



---- UPDATE ----


subscriptions : Model -> Sub Msg
subscriptions _ =
    readFileList LoadFileList


type Msg
    = SelectFile String
    | LoadFile String
    | UpdatePreview String
    | LoadFileList (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectFile filename ->
            ( { model |  = filename },  )

        LoadFile data ->
            ( { model | currentDoc = .loadingDoc model }, Cmd.none )

        UpdatePreview data ->
            ( { model | code = data }, setPreview data )

        LoadFileList data ->
            ( { model | docList = data }, Cmd.none )



---- INIT ----


init : ( Model, Cmd Msg )
init =
    ( Loading, Cmd.none )



---- PROGRAM ----


main : Program {} Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
