import Html exposing (..)
import Date exposing (Date)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model = Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)



-- UPDATE


type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    date = Date.fromTime model
    secAngle = pi / 30
    hourAngle = pi / 6
    sec = toFloat (Date.second date)
    minutes = toFloat (Date.minute date) + sec / 60
    hours = toFloat (Date.hour date % 12) + minutes / 60
    angle = secAngle * sec - pi / 2
    angleMin = secAngle * minutes - pi / 2
    angleHour = hourAngle * hours - pi / 2

    secX = toString (50 + 40 * cos angle)
    secY = toString (50 + 40 * sin angle)

    minX = toString (50 + 40 * cos angleMin)
    minY = toString (50 + 40 * sin angleMin)

    hourX = toString (50 + 30 * cos angleHour)
    hourY = toString (50 + 30 * sin angleHour)
  in
    div []
    [ Html.p [] [Html.text (toString date)]
    --, Html.p [] [Html.text (toString angle)]
    , svg [ viewBox "0 0 100 100", width "300px" ]
      ([ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 secX, y2 secY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 minX, y2 minY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 hourX, y2 hourY, stroke "#02c963" ] []
      , circle [cx "50", cy "50", r "5", fill "#023963"] []
      ] ++ (dots 0 []))
    ]

dots : Int -> List (Html Msg) -> List (Html Msg)
dots i acc =
  let
    secAngle = pi / 30
    angle = (toFloat i) * secAngle - pi / 2
    x = toString (50 + 40 * cos angle)
    y = toString (50 + 40 * sin angle)
  in
    if i == 60 then
      acc
    else if i % 15 == 0 then
      dots (i + 1) (acc ++ [circle [cx x, cy y, r "1", fill "#000000" ] []])
    else if i % 5 == 0 then
      dots (i + 1) (acc ++ [circle [cx x, cy y, r "0.6", fill "#000000" ] []])
    else
      dots (i + 1) (acc ++ [circle [cx x, cy y, r "0.3", fill "#000000" ] []])
