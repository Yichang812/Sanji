port module Port exposing (File, getFileContent, readFile, readFileList, setPreview)

import Dict exposing (Dict)
import Html exposing (Html, div, text)


type alias FileName =
    String


port readFile : String -> Cmd msg


type alias File =
    String


port getFileContent : (File -> msg) -> Sub msg


type alias FileList =
    List String


port readFileList : (FileList -> msg) -> Sub msg


type alias Preview =
    String


port setPreview : String -> Cmd msg
