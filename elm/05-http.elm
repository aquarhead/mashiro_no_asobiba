import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  }

init : String -> (Model, Cmd Msg)
init topic =
  (Model topic "waiting.gif"
  , getRandomGif topic
  )

-- UPDATE

type Msg
  = MorePlease
  | NewGif (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    NewGif (Ok newUrl) ->
      (Model model.topic newUrl, Cmd.none)
    NewGif (Err _) ->
      (model, Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text model.topic ]
    , img [ src model.gifUrl] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- HTTP

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    request = Http.get url decodeGifUrl
  in
    Http.send NewGif request

decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at [ "data", "image_url" ] Decode.string
