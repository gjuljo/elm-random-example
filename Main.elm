module Main exposing (Model, Msg(..), initialCmd, initialModel, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Random


type alias Model =
    { currentValue : Int
    , maxRandom : Int
    , increment : Int
    , decrement : Int
    }


initialModel : Model
initialModel =
    { currentValue = 0
    , maxRandom = 20
    , increment = 1
    , decrement = 1
    }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Random test" ]
        , button [ onClick Increment ] [ text "+" ]
        , text ("   " ++ String.fromInt model.currentValue ++ "   ")
        , button [ onClick Decrement ] [ text "-" ]
        , br [] []
        , button [ onClick (DoRandomize model.maxRandom) ] [ text "Random" ]
        ]


type Msg
    = Increment
    | Decrement
    | RandomValue Int
    | DoRandomize Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | currentValue = model.currentValue + model.increment }, Cmd.none )

        Decrement ->
            ( { model | currentValue = model.currentValue - model.decrement }, Cmd.none )

        RandomValue value ->
            ( { model | currentValue = value }, Cmd.none )

        DoRandomize maxValue ->
            let
                randomGenerator : Random.Generator Int
                randomGenerator =
                    Random.int 0 maxValue

                randomGenerationCmd : Cmd Msg
                randomGenerationCmd =
                    Random.generate RandomValue randomGenerator
            in
            ( model, randomGenerationCmd )


initialCmd : Model -> Cmd Msg
initialCmd model =
    Random.generate RandomValue (Random.int 0 model.maxRandom)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , update = update
        , view = view
        }
