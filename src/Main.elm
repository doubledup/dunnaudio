module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Url


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


type alias Model =
    {}


init : flags -> Url.Url -> Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( {}, Cmd.none )


type Msg
    = Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest _ =
    Noop


onUrlChange : Url.Url -> Msg
onUrlChange _ =
    Noop


view : Model -> Browser.Document Msg
view _ =
    { title = "Dunnaudio"
    , body =
        [ layout []
            (row [ height fill, width fill ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 4), height fill ]
                    [ row [ alignTop, paddingXY 0 50, width fill ]
                        [ el [ alignLeft ] (text "Dunn 🎙 Audio")
                        , row [ alignRight, spacing 40 ]
                            [ text "Home"
                            , text "About Me"
                            , text "Portfolio"
                            , text "Testimonials"
                            , text "Contact"
                            , text "Soundcloud"
                            , text "My CV"
                            ]
                        ]
                    ]
                , column [ width (fillPortion 1) ] []
                ]
            )
        ]
    }
