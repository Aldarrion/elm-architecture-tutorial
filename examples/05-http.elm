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
  , loading : Bool
  , message : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic "" False ""
  , getRandomGif topic -- Cmd.none
  )



-- UPDATE


type Msg
  = MorePlease
  | NewGif (Result Http.Error String)
  | TopicChanged String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({ model | loading = True }, getRandomGif model.topic)

    NewGif (Ok newUrl) ->
      (Model model.topic newUrl False "Gif loaded", Cmd.none)

    NewGif (Err _) ->
      ({ model | loading = False, message = toString Err }, Cmd.none)

    TopicChanged topic ->
      ({ model | topic = topic }, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [type_ "text", placeholder "topic", onInput TopicChanged, value model.topic ] []
    , h2 [] [text model.topic]
    , moreBtn model
    , br [] []
    , if model.gifUrl /= "" then img [src model.gifUrl] [] else Html.p [] [text "gif"]
    , Html.p [] [text model.message]
    ]

moreBtn : Model -> Html Msg
moreBtn model =
  if (model.loading) then
    Html.p [] [text "loading"]
  else
    button [ onClick MorePlease ] [ text "More Please!" ]

-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Http.send NewGif (Http.get url decodeGifUrl)


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string
