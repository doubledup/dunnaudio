module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
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
                , column [ width (fillPortion 4), height fill, Border.width 1 ]
                    [ row [ paddingXY 0 50, width fill, Border.width 1 ]
                        [ el [ alignLeft, Border.width 1 ] (text "Dunn 🎙 Audio")
                        , row [ alignRight, spacingMedium, Border.width 1 ]
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
                        [ row [ width fill, height (px 700), Border.width 1 ] [ el [ centerX ] (text "Picture Reel") ]
                        , row [ spacingSmall, width fill, Border.width 1 ]
                            [ column [ spacingMedium, width (fillPortion 1), alignTop, Border.width 1 ]
                                [ el [ centerX, Font.bold ] (text "About Me")
                                , paragraph [ Font.center ] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]
                                , paragraph [ Font.center ] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]
                                , paragraph [ Font.center ] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]
                                , paragraph [ Font.center ] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
                                ]
                            , column [ spacingSmall, width (fillPortion 1), Border.width 1 ]
                                [ el [ width fill, height (px 300), Border.width 1 ] (text "Pic with cheetah")
                                , el [ width fill, height (px 300), Border.width 1 ] (text "Pic with Hadza")
                                ]
                            ]
                        , column [ spacingMedium, width fill, Border.width 1 ]
                            [ row [ spacingSmall, width fill ]
                                [ el [ width (px 350), height (px 250), Border.width 1 ] (text "Pic with Ambisonic")
                                , column [ spacingMedium, width fill, Font.center ]
                                    [ el [ Font.bold ] (text "What I Do Now")
                                    , paragraph [] [ text "I spend a lot of my time on documentary productions, although I still work in other arenas. This has taken me all over the world, working for the major broadcasting channels in over 30 countries and exploring a diverse range of subjects." ]
                                    , paragraph [] [ text "I also now specialise in recording ‘The sounds of Africa’ having been commissioned by several top international production companies to record animals and general ambiences of Africa." ]
                                    , paragraph [] [ text "My favourite ‘go-to’ is an Ambisonic Microphone that captures immersive surround sounds of the environments I’m recording in - an important tool in the sound design process of most productions." ]
                                    ]
                                ]
                            , row [ spacingSmall, width fill ]
                                [ el [ width (fillPortion 1), height (px 400), Border.width 1 ] (text "Pic with Wauja")
                                , el [ width (fillPortion 1), height (px 400), Border.width 1 ] (text "Pic with CPT")
                                ]
                            ]
                        , column [ spacingMedium, width fill, Border.width 1 ]
                            [ el [ centerX, Font.bold ] (text "Nominations & Awards")
                            , row [ spacingSmall ]
                                [ column [ width (fillPortion 1) ] []
                                , paragraph awardStyle [ text "BAFTA Craft Awards nominee 2013 Best Sound for 'Brazil with Michael Palin'" ]
                                , paragraph awardStyle [ text "Jackson Wild Media Awards nominee 2015 Best Sound for 'Gorongosa Park: Rebirth of Paradise'" ]
                                , paragraph awardStyle [ text "News and Documentary Emmy Awards nominee 2023 Outstanding Sound for 'Our Universe'" ]
                                , column [ width (fillPortion 1) ] []
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
spacingSmall =
    spacing 20


spacingMedium : Attribute msg
spacingMedium =
    spacing 40


spacingLarge : Attribute msg
spacingLarge =
    spacing 80


orange : Color
orange =
    rgb255 254 102 3


awardStyle : List (Attribute msg)
awardStyle =
    [ padding 10
    , width (fillPortion 2)
    , Border.color orange
    , Border.rounded 10
    , Border.width 1
    , Font.bold
    , Font.center
    ]
