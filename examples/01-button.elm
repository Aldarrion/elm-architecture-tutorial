import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model = {i: Int}

defaultCount : Int
defaultCount = 10

model : Model
model =
  {i = defaultCount}



-- UPDATE


type Msg
  = Increment
  | Decrement
  | Reset


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      {model | i = model.i + 1}

    Decrement ->
      {model | i = model.i - 1}

    Reset ->
      {i = defaultCount}



-- VIEW



view : Model -> Html Msg
view model =
  div []
    [ Html.p [] [ button [ onClick Reset ] [ text "Reset" ] ]
    , Html.p [] [ button [ onClick Decrement ] [ text "-" ] ]
    , div [] [ text ("I: " ++ (toString model.i)) ]
    , Html.p [] [ button [ onClick Increment ] [ text "+" ] ]
    ]
