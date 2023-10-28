module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Border
import Element.Font
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
                , column [ width (fillPortion 4), height fill, Element.Border.width 1 ]
                    [ row [ paddingXY 0 50, width fill, Element.Border.width 1 ]
                        [ el [ alignLeft, Element.Border.width 1 ] (text "Dunn 🎙 Audio")
                        , row [ alignRight, spacingMedium, Element.Border.width 1 ]
                            [ text "Home"
                            , text "About Me"
                            , text "Portfolio"
                            , text "Testimonials"
                            , text "Contact"
                            , text "Soundcloud"
                            , text "My CV"
                            ]
                        ]
                    , column [ spacingLarge, width fill ]
                        [ row [ width fill, height (px 700), Element.Border.width 1 ] [ el [ centerX ] (text "Picture Reel") ]
                        , row [ spacingSmall, width fill, Element.Border.width 1 ]
                            [ column [ spacingMedium, width (fillPortion 1), height fill, Element.Border.width 1 ]
                                [ el [ centerX, Element.Font.bold ] (text "About Me")
                                , paragraph [ Element.Font.center ] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]
                                , paragraph [ Element.Font.center ] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]
                                , paragraph [ Element.Font.center ] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]
                                , paragraph [ Element.Font.center ] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
                                ]
                            , column [ spacingSmall, width (fillPortion 1), Element.Border.width 1 ]
                                [ el [ width fill, height (px 300), Element.Border.width 1 ] (text "Pic1")
                                , el [ width fill, height (px 300), Element.Border.width 1 ] (text "Pic2")
                                ]
                            ]
                        ]
                    ]
                , column [ width (fillPortion 1) ] []
                ]
            )
        ]
    }

spacingSmall : Attribute msg
spacingSmall = spacing 20

spacingMedium : Attribute msg
spacingMedium = spacing 40

spacingLarge : Attribute msg
spacingLarge = spacing 80
