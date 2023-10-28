module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import List exposing (repeat)
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
            (column [ height fill, width fill ]
                [ row [ height fill, width fill, paddingEach { top = 0, left = 0, right = 0, bottom = 30 } ]
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
                            [ el [ width fill, height (px 700), Border.width 1 ] (el [ centerX, centerY ] (text "Picture Reel"))
                            , row [ spacingSmall, width fill, Border.width 1 ]
                                [ column [ spacingMedium, width (fillPortion 1), alignTop, Border.width 1, Font.center ]
                                    [ el [ centerX, Font.bold ] (text "About Me")
                                    , paragraph [] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]
                                    , paragraph [] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]
                                    , paragraph [] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]
                                    , paragraph [] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
                                    ]
                                , column [ spacingSmall, width (fillPortion 1), Border.width 1 ]
                                    [ el [ width fill, height (px 300), Border.width 1 ] (el [ centerX, centerY ] (text "Pic with cheetah"))
                                    , el [ width fill, height (px 300), Border.width 1 ] (el [ centerX, centerY ] (text "Pic with Hadza"))
                                    ]
                                ]
                            , column [ spacingMedium, width fill, Border.width 1 ]
                                [ row [ spacingSmall, width fill ]
                                    [ el [ width (px 350), height (px 250), Border.width 1 ] (el [ centerX, centerY ] (text "Pic with Ambisonic"))
                                    , column [ spacingMedium, width fill, Font.center ]
                                        [ el [ centerX, Font.bold ] (text "What I Do Now")
                                        , paragraph [] [ text "I spend a lot of my time on documentary productions, although I still work in other arenas. This has taken me all over the world, working for the major broadcasting channels in over 30 countries and exploring a diverse range of subjects." ]
                                        , paragraph [] [ text "I also now specialise in recording ‘The sounds of Africa’ having been commissioned by several top international production companies to record animals and general ambiences of Africa." ]
                                        , paragraph [] [ text "My favourite ‘go-to’ is an Ambisonic Microphone that captures immersive surround sounds of the environments I’m recording in - an important tool in the sound design process of most productions." ]
                                        ]
                                    ]
                                , row [ spacingSmall, width fill ]
                                    [ el [ width (fillPortion 1), height (px 400), Border.width 1 ] (el [ centerX, centerY ] (text "Pic with Wauja"))
                                    , el [ width (fillPortion 1), height (px 400), Border.width 1 ] (el [ centerX, centerY ] (text "Pic with CPT"))
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
                            , column [ spacingMedium, width fill, Border.width 1 ]
                                [ el [ centerX, Font.bold ] (text "Extra Documents & Notes")
                                , row [ paddingXY 100 0, spaceEvenly, width fill ]
                                    [ column [ spacingSmall, width (px 300) ]
                                        [ el [ centerX, width (px 100), height (px 100), Border.width 1 ] (paragraph [] [ text "Passport icon" ])
                                        , paragraph [ Font.center, Font.bold ] [ text "British & South African Passport" ]
                                        ]
                                    , column [ spacingSmall, width (px 300) ]
                                        [ el [ centerX, width (px 100), height (px 100), Border.width 1 ] (paragraph [] [ text "Teaching icon" ])
                                        , paragraph [ Font.center, Font.bold ] [ text "Teaching Experience" ]
                                        ]
                                    , column [ spacingSmall, width (px 300) ]
                                        [ el [ centerX, width (px 100), height (px 100), Border.width 1 ] (paragraph [] [ text "Passport icon" ])
                                        , paragraph [ Font.center, Font.bold ] [ text "Updated Immunisations for Foreign Travel" ]
                                        ]
                                    ]
                                , row [ width fill ]
                                    [ el
                                        [ centerX
                                        , paddingXY 30 20
                                        , Border.color orange
                                        , Border.rounded 10
                                        , Background.color orange
                                        , Font.color (rgb 1 1 1)
                                        ]
                                        (text "View my CV for more")
                                    ]
                                ]
                            , column [ spacingMedium, width fill, Border.width 1 ]
                                [ el [ centerX, Font.bold ] (text "Portfolio links")
                                , column [ spacingSmall, width fill ]
                                    [ row [ centerX, spacingSmall ]
                                        [ el [ width (px 320), height (px 180), Border.width 1 ] (el [ centerX, centerY ] (text "Our universe"))
                                        , el [ width (px 320), height (px 180), Border.width 1 ] (el [ centerX, centerY ] (text "Survivor"))
                                        , el [ width (px 320), height (px 180), Border.width 1 ] (el [ centerX, centerY ] (text "Elephants"))
                                        ]
                                    , row [ centerX, spacingSmall ]
                                        [ el [ width (px 320), height (px 180), Border.width 1 ] (el [ centerX, centerY ] (text "Malawi"))
                                        , el [ width (px 320), height (px 180), Border.width 1 ] (el [ centerX, centerY ] (text "Monkeys"))
                                        , el [ width (px 320), height (px 180), Border.width 1 ] (el [ centerX, centerY ] (text "Lions"))
                                        ]
                                    ]
                                ]
                            , column [ spacingSmall, width fill, Border.width 1 ]
                                [ el [ centerX, Font.bold ] (text "Clients")
                                , row [ spacingSmall, width fill, height (px 80), Border.width 1 ] (repeat 8 (el [ centerX, width (px 120), height fill, Border.width 1 ] none))
                                , row [ spacingSmall, width fill, height (px 80), Border.width 1 ] (repeat 7 (el [ centerX, width (px 120), height fill, Border.width 1 ] none))
                                , row [ spacingSmall, width fill, height (px 80), Border.width 1 ] (repeat 7 (el [ centerX, width (px 120), height fill, Border.width 1 ] none))
                                , row [ spacingSmall, width fill, height (px 80), Border.width 1 ] (repeat 7 (el [ centerX, width (px 120), height fill, Border.width 1 ] none))
                                , row [ spacingSmall, width fill, height (px 80), Border.width 1 ] (repeat 7 (el [ centerX, width (px 120), height fill, Border.width 1 ] none))
                                , row [ spacingSmall, width fill, height (px 80), Border.width 1 ] (repeat 7 (el [ centerX, width (px 120), height fill, Border.width 1 ] none))
                                ]
                            , column [ spacingSmall, width fill, Border.width 1 ]
                                [ el [ centerX, Font.bold ] (text "Testimonials")
                                , row [ width fill ]
                                    [ el [ width (fillPortion 1), height fill, Border.width 1 ]
                                        (el
                                            [ centerX
                                            , centerY
                                            , width (px 40)
                                            , height (px 40)
                                            , Border.rounded 20
                                            , Font.color orange
                                            , Font.extraBold
                                            ]
                                            (el [ centerX, centerY ] (text "<"))
                                        )
                                    , column [ spacingSmall, width (fillPortion 8), height fill, Border.width 1 ]
                                        [ column [ centerX, spacing 5, Font.center, Border.width 1 ]
                                            [ paragraph [] [ text "“… Despite the incredibly difficult working conditions in Mali and Egypt your sound recording was brilliant." ]
                                            , paragraph [] [ text "We so appreciate having someone with your enthusiasm, energy and experience." ]
                                            , paragraph [] [ text "Your stereo recordings of the big ceremonies have created a sound that makes the viewer feel so present…" ]
                                            , paragraph [] [ text "“Cosmic Africa“ has really benefited in a big way through your dedication to the sound…”" ]
                                            ]
                                        , paragraph [ Font.center, Font.bold ] [ text "Craig Foster" ]
                                        , paragraph [ Font.center ] [ text "Earthrise Productions" ]
                                        ]
                                    , el [ width (fillPortion 1), height fill, Border.width 1 ]
                                        (el
                                            [ centerX
                                            , centerY
                                            , width (px 40)
                                            , height (px 40)
                                            , Border.rounded 20
                                            , Font.color orange
                                            , Font.extraBold
                                            ]
                                            (el [ centerX, centerY ] (text ">"))
                                        )
                                    ]
                                , row [ centerX, spacing 5 ]
                                    [ dot orange
                                    , dot grey
                                    , dot grey
                                    , dot grey
                                    , dot grey
                                    , dot grey
                                    , dot grey
                                    ]
                                ]
                            , column [ spacingSmall, width fill, Border.width 1 ]
                                [ el [ centerX, Font.bold ] (text "Let's Chat!")
                                , paragraph [ Font.center ]
                                    [ text "Email: "
                                    , link []
                                        { url = "mailto:seb@dunnaudio.com"
                                        , label = text "seb@dunnaudio.com"
                                        }
                                    ]
                                ]
                            , column [ spacingSmall, width fill, Border.width 1 ]
                                [ el [ centerX ]
                                    (text "Follow me on my socials!")
                                , row
                                    [ spaceEvenly, width fill, paddingXY 50 0 ]
                                    [ el [ width (px 40), height (px 40), Background.color black, Border.rounded 20 ] none
                                    , el [ width (px 40), height (px 40), Background.color black, Border.rounded 20 ] none
                                    , el [ width (px 40), height (px 40), Background.color black, Border.rounded 20 ] none
                                    , el [ width (px 40), height (px 40), Background.color black, Border.rounded 20 ] none
                                    , el [ width (px 40), height (px 40), Background.color black, Border.rounded 20 ] none
                                    ]
                                ]
                            ]
                        ]
                    , column [ width (fillPortion 1) ] []
                    ]
                , column [ width fill, padding 30, spacing 10, Background.color black, Font.center, Font.color white ]
                    [ paragraph []
                        [ text "Copyright © 2023 Dunn Audio" ]
                    , paragraph []
                        [ text "Powered by ❤️  and "
                        , link []
                            { url =
                                "https://elm-lang.org"
                            , label = el [ Font.underline ] (text "Elm")
                            }
                        ]
                    ]
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


grey : Color
grey =
    rgb255 204 204 204


black : Color
black =
    rgb255 20 20 20


white : Color
white =
    rgb255 230 230 230


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


dot : Color -> Element msg
dot color =
    el [ width (px 16), height (px 16), Border.rounded 8, Background.color color ] none
