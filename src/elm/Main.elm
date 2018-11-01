module Main exposing (Model, Msg(..), init, main, update, view)

-- import CodeMirror exposing (..)

import AppState exposing (AppState(..))
import Browser
import Html exposing (Attribute, Html, a, div, h1, li, text, textarea, ul)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (on, onClick, onInput, stopPropagationOn, targetValue)
import Http
import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Pipeline exposing (required, resolve)
import Json.Encode exposing (string)
import Markdown exposing (toHtml)
import Url.Builder as Builder



---- MODEL ----


type alias Model =
    { code : String
    , activeDoc : Maybe Doc
    , docList : List String
    , appState : AppState Http.Error
    }


type alias Doc =
    { name : String
    , content : String
    }



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        { appState } =
            model
    in
    case appState of
        InitLoading ->
            div [] [ text "init loading" ]

        Loaded maybeError ->
            div []
                [ case maybeError of
                    Just error ->
                        text <| "Error: " ++ Debug.toString error

                    Nothing ->
                        text ""
                , mainView model
                ]

        Loading ->
            div [] [ text "loading..." ]

        LoadingError error ->
            div [] [ text <| Debug.toString error ]


mainView : Model -> Html Msg
mainView model =
    div []
        [ navBar
        , fileList <| .docList model
        , case .activeDoc model of
            Just doc ->
                toHtml [] <| .content doc

            Nothing ->
                div [] []
        ]


navBar : Html msg
navBar =
    div [ class "navbar" ]
        [ h1 [] [ text "Zalora Styleguide 2.0" ] ]


fileList : List String -> Html Msg
fileList docs =
    ul [] <| List.map (\x -> li [ onClick (SelectFile x) ] [ text x ]) docs



---- UPDATE ----


type Msg
    = InitView (Result Http.Error (List String))
    | SelectFile String
    | FileLoaded (Result Http.Error Doc)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        { activeDoc, appState } =
            model
    in
    case msg of
        InitView data ->
            case data of
                Ok docList ->
                    ( { model | docList = docList, appState = AppState.toSuccess appState }, Cmd.none )

                Err error ->
                    ( { model | appState = AppState.toFailure error appState }, Cmd.none )

        FileLoaded data ->
            case data of
                Ok doc ->
                    ( { model | activeDoc = Just doc, appState = AppState.toSuccess appState }, Cmd.none )

                Err error ->
                    ( { model | appState = AppState.toFailure error appState }, Cmd.none )

        SelectFile filename ->
            ( { model | appState = AppState.toLoading appState }, loadFile filename )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



---- INIT ----


init : ( Model, Cmd Msg )
init =
    let
        cmd =
            Decode.list Decode.string
                |> Http.get "/docList"
                |> Http.send InitView
    in
    ( { code = ""
      , activeDoc = Nothing
      , docList = []
      , appState = AppState.init
      }
    , cmd
    )


loadFile : String -> Cmd Msg
loadFile filename =
    let
        url =
            Builder.absolute [ "file" ] [ Builder.string "name" filename ]

        docDecoder : Decoder Doc
        docDecoder =
            Decode.succeed Doc
                |> required "name" Decode.string
                |> required "content" Decode.string
    in
    docDecoder
        |> Http.get url
        |> Http.send FileLoaded



---- PROGRAM ----


main : Program {} Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
