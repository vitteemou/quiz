module Main exposing (init, main, subscriptions, update)

import Browser
import Http
import Json.Decode as Json
import Messages as Msg
import Model
import View


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = View.view
        }


init : { quizAddr : String } -> ( Model.Model, Cmd Msg.Msg )
init flags =
    ( Model.emptyModel
    , getQuestions flags.quizAddr
    )


getQuestions : String -> Cmd Msg.Msg
getQuestions address =
    Http.get
        { url = address
        , expect =
            Http.expectJson Msg.GotModel Model.settingsDecoder
        }


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.StartQuiz ->
            ( Model.startQuiz model
            , Cmd.none
            )

        Msg.Reset ->
            ( Model.emptyModel
            , Cmd.none
            )

        Msg.Quiz quiz ->
            case quiz of
                Msg.Next ->
                    ( Model.nextQuestion model, Cmd.none )

                Msg.Answer answer ->
                    ( Model.answerQuestion answer model, Cmd.none )

        Msg.GotModel settings ->
            let
                settings_ =
                    Result.withDefault
                        { questions = []
                        , startPage = ""
                        , finishPage = ""
                        , scores = []
                        }
                        settings
            in
            ( { model
                | remainingQuestions = settings_.questions
                , startPage = settings_.startPage
                , finishPage = settings_.finishPage
                , scores = settings_.scores
                , state = Model.Start
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Msg.Msg
subscriptions model =
    Sub.none
