module Main exposing (main)

import Browser
import Browser.Events as Events
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as ElementEvents
import Element.Font as Font
import FontAwesome as Icon
import FontAwesome.Brands as IconBrands
import FontAwesome.Solid as IconSolid
import Html
import Html.Attributes
import Url


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        }


type alias Flags =
    { window :
        { innerWidth : Int
        , innerHeight : Int
        }
    }


type alias Model =
    { device : Device
    , menuState : MenuState
    }


type MenuState
    = Closed
    | Open


init : Flags -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags _ _ =
    ( { device =
            classifyDevice
                { width = flags.window.innerWidth
                , height = flags.window.innerHeight
                }
      , menuState = Closed
      }
    , Cmd.none
    )


type Msg
    = UpdateDevice { width : Int, height : Int }
    | ToggleMenuState
    | Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateDevice window ->
            ( { model | device = classifyDevice window }, Cmd.none )

        ToggleMenuState ->
            ( { model
                | menuState =
                    case model.menuState of
                        Open ->
                            Closed

                        Closed ->
                            Open
              }
            , Cmd.none
            )

        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Events.onResize
        (\w h ->
            UpdateDevice
                { width = w
                , height = h
                }
        )


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest _ =
    Noop


onUrlChange : Url.Url -> Msg
onUrlChange _ =
    Noop



-- attributes are organised by width, height, alignment, padding, spacing, background, font


view : Model -> Browser.Document Msg
view model =
    { title = "Dunn Audio"
    , body =
        case model.device of
            { class } ->
                case class of
                    Phone ->
                        [ layout []
                            (column [ width fill, height fill, fontNormal, Font.color black, Font.letterSpacing 0.5 ]
                                [ row
                                    ([ width fill
                                     , padding 30
                                     ]
                                        ++ (if model.menuState == Closed then
                                                []

                                            else
                                                [ below
                                                    (row [ width fill, Background.color (rgb255 255 255 255) ]
                                                        [ el [ width (fillPortion 1) ] none
                                                        , column [ width (fillPortion 8), padding 20, spacingSmall, fontRaleway, fontNormal, Font.light ]
                                                            [ el [ width fill, Font.center ] (text "Home")
                                                            , row [ width fill ] [ el [ width fill, height (px 0), Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }, Border.color orange ] none ]
                                                            , el [ width fill, Font.center ] (text "About Me")
                                                            , row [ width fill ] [ el [ width fill, height (px 0), Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }, Border.color orange ] none ]
                                                            , el [ width fill, Font.center ] (text "Portfolio")
                                                            , row [ width fill ] [ el [ width fill, height (px 0), Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }, Border.color orange ] none ]
                                                            , el [ width fill, Font.center ] (text "Testimonials")
                                                            , row [ width fill ] [ el [ width fill, height (px 0), Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }, Border.color orange ] none ]
                                                            , el [ width fill, Font.center ] (text "Contact")
                                                            , row [ width fill ] [ el [ width fill, height (px 0), Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }, Border.color orange ] none ]
                                                            , el [ width fill, Font.center ] (text "My CV")
                                                            ]
                                                        , el [ width (fillPortion 1) ] none
                                                        ]
                                                    )
                                                ]
                                           )
                                    )
                                    [ image [ width (px 200), centerY, alignLeft, paddingEach { bottom = 20, top = 0, left = 0, right = 0 } ] { src = "images/logo.webp", description = "Dunn 🎙 Audio" }
                                    , el [ width (px 30), centerY, alignRight, ElementEvents.onClick ToggleMenuState ] (html (Icon.view IconSolid.bars))
                                    ]
                                , el [ width fill ]
                                    (image [ width fill, height (px 250) ]
                                        { src =
                                            "images/elephants.webp"
                                        , description = "Sebastian recording elephants"
                                        }
                                    )
                                , column [ width fill, height fill, paddingXY 20 40, spacingMedium, fontRaleway ]
                                    [ column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "About Me")
                                        , paragraph [ spacingParagraph ] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]
                                        , el [ width fill ]
                                            (image
                                                [ width fill, height fill ]
                                                { src = "images/cheetah.webp"
                                                , description = "Sebastian wearing sound equipment and standing next to a cheetah"
                                                }
                                            )
                                        , paragraph [ spacingParagraph ] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]
                                        , paragraph [ spacingParagraph ] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]
                                        , el [ width fill ]
                                            (image
                                                [ width fill, height fill ]
                                                { src = "images/hadza.webp"
                                                , description = "Sebastian recording members of the Hadza community in Tanzania"
                                                }
                                            )
                                        , paragraph [ spacingParagraph ] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
                                        ]
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "What I Do Now")
                                        , paragraph [ spacingParagraph ] [ text "I spend a lot of my time on documentary productions, although I still work in other arenas. This has taken me all over the world, working for the major broadcasting channels in over 30 countries and exploring a diverse range of subjects." ]
                                        , paragraph [ spacingParagraph ] [ text "I also now specialise in recording ‘The sounds of Africa’ having been commissioned by several top international production companies to record animals and general ambiences of Africa." ]
                                        , el [ width fill ]
                                            (image
                                                [ width fill, height fill ]
                                                { src = "images/ambisonic-gorongosa.webp"
                                                , description = "Sebastian recording ambisonic sound on top of a car in Gorongosa National Park in Mozambique"
                                                }
                                            )
                                        , el [ width fill ]
                                            (image
                                                [ width fill, height fill ]
                                                { src = "images/wauja-palin.webp"
                                                , description = "Sebastian standing with a member of the Wauja community in the Amazon"
                                                }
                                            )
                                        , paragraph [ spacingParagraph ] [ text "My favourite ‘go-to’ is an Ambisonic Microphone that captures immersive surround sounds of the environments I’m recording in - an important tool in the sound design process of most productions." ]
                                        , el [ width fill ]
                                            (image
                                                [ width fill, height fill ]
                                                { src = "images/cape-town.webp"
                                                , description = "Sebastian recording sound in front of Cape Town city hall during lockdown"
                                                }
                                            )
                                        ]
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "Nominations & Awards")
                                        , column [ centerX, spacingSmall ]
                                            [ column (awardStyle ++ [ fontNormal ])
                                                [ paragraph [] [ text "BAFTA Craft Awards nominee" ]
                                                , paragraph [] [ text "2013" ]
                                                , paragraph [] [ text "Best Sound for 'Brazil with Michael Palin'" ]
                                                ]
                                            , column (awardStyle ++ [ fontNormal ])
                                                [ paragraph [] [ text "Jackson Wild Media Awards nominee" ]
                                                , paragraph [] [ text "2015" ]
                                                , paragraph [] [ text "Best Sound for 'Gorongosa Park: Rebirth of Paradise'" ]
                                                ]
                                            , column (awardStyle ++ [ fontNormal ])
                                                [ paragraph [] [ text "News and Documentary Emmy Awards nominee" ]
                                                , paragraph [] [ text "2023" ]
                                                , paragraph [] [ text "Outstanding Sound for 'Our Universe'" ]
                                                ]
                                            ]
                                        ]
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "Extra Documents & Notes")
                                        , column [ centerX, alignTop, spacingSmall, width fill ]
                                            [ el
                                                [ centerX
                                                , width (px 100)
                                                , height (px 100)
                                                , Border.color orange
                                                , Border.rounded 50
                                                , Border.width 3
                                                , Font.color orange
                                                ]
                                                (el [ centerX, centerY, width (fill |> maximum 50), height (px 50) ]
                                                    (html (Icon.view IconSolid.passport))
                                                )
                                            , paragraph [ Font.center, Font.bold, fontNormal ] [ text "British & South African Passport" ]
                                            ]
                                        , column [ centerX, alignTop, spacingSmall, width fill ]
                                            [ el
                                                [ centerX
                                                , width (px 100)
                                                , height (px 100)
                                                , Border.color orange
                                                , Border.rounded 50
                                                , Border.width 3
                                                , Font.color orange
                                                ]
                                                (el [ centerX, centerY, width (fill |> maximum 70), height (px 50) ]
                                                    (html (Icon.view IconSolid.chalkboardTeacher))
                                                )
                                            , paragraph [ Font.center, Font.bold, fontNormal ] [ text "Teaching Experience" ]
                                            ]
                                        , column [ centerX, alignTop, spacingSmall, width fill ]
                                            [ el
                                                [ centerX
                                                , width (px 100)
                                                , height (px 100)
                                                , Border.color orange
                                                , Border.rounded 50
                                                , Border.width 3
                                                , Font.color orange
                                                ]
                                                (el [ centerX, centerY, width (fill |> maximum 50), height (px 50) ]
                                                    (html (Icon.view IconSolid.syringe))
                                                )
                                            , paragraph [ Font.center, Font.bold, fontNormal ] [ text "Updated Immunisations for Foreign Travel" ]
                                            ]
                                        , row [ width fill ]
                                            [ el
                                                [ centerX
                                                , paddingXY 30 20
                                                , Border.color orange
                                                , Border.rounded 10
                                                , Background.color orange
                                                , Font.color white
                                                ]
                                                (text "View my CV for more")
                                            ]
                                        ]
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "Portfolio")
                                        , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/Q33TkQKlIMg?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=1" }
                                        , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/q1UcC7BsI1M?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=3" }
                                        , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/Vg93ijoQeJ8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=5" }
                                        , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/vTA6EX-0Xr8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=7" }
                                        , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/X1_Y12auEgk?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=9" }
                                        , vimeoVideo { width = 320, height = 180, src = "https://player.vimeo.com/video/168173513?color&autopause=0&loop=0&muted=0&title=1&portrait=1&byline=1#t=" }
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "Survivor", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-45.png", logoWidth = 120 }
                                            , clientLogo { description = "HBO", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-22.jpg", logoWidth = 120 }
                                            ]
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "Netflix", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-32.jpg", logoWidth = 120 }
                                            , clientLogo { description = "Apple TV", src = "https://dunnaudio.com/wp-content/uploads/2023/06/apple-tv__e7aqjl2rqzau_og.png", logoWidth = 120 }
                                            ]
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "BBC", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-12.jpg", logoWidth = 120 }
                                            , clientLogo { description = "National Geographic", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-31.jpg", logoWidth = 120 }
                                            ]
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "Animal Planet", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-4.jpg", logoWidth = 120 }
                                            , clientLogo { description = "Discovery Channel", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-19.jpg", logoWidth = 120 }
                                            ]
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "PBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-34.jpg", logoWidth = 120 }
                                            , clientLogo { description = "History", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-25.jpg", logoWidth = 120 }
                                            ]
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "CBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-14.jpg", logoWidth = 120 }
                                            , clientLogo { description = "abc primetime", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-2.jpg", logoWidth = 120 }
                                            ]
                                        , row [ width fill, spacingSmall ]
                                            [ clientLogo { description = "Sky 1", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-41.gif", logoWidth = 120 }
                                            ]
                                        ]
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "Testimonials")
                                        , row [ width fill ]
                                            [ el [ width (fillPortion 1), height fill ]
                                                (el [ centerX, centerY, width (px 20), height (px 20), Font.color orange ]
                                                    (html (Icon.view IconSolid.angleLeft))
                                                )
                                            , column [ width (fillPortion 10), height fill, Font.center, fontNormal, Font.light, Font.letterSpacing 0.3 ]
                                                [ column [ centerX, spacing 10 ]
                                                    [ paragraph [] [ text "“… Despite the incredibly difficult working conditions in Mali and Egypt your sound recording was brilliant." ]
                                                    , paragraph [] [ text "We so appreciate having someone with your enthusiasm, energy and experience." ]
                                                    , paragraph [] [ text "Your stereo recordings of the big ceremonies have created a sound that makes the viewer feel so present…" ]
                                                    , paragraph [] [ text "“Cosmic Africa“ has really benefited in a big way through your dedication to the sound…”" ]
                                                    ]
                                                , paragraph [ paddingEach { top = 30, left = 0, right = 0, bottom = 0 }, Font.bold ] [ text "Craig Foster" ]
                                                , paragraph [ paddingEach { top = 15, left = 0, right = 0, bottom = 0 } ] [ text "Earthrise Productions" ]
                                                ]
                                            , el [ width (fillPortion 1), height fill ]
                                                (el [ centerX, centerY, width (px 20), height (px 20), Font.color orange ]
                                                    (html (Icon.view IconSolid.angleRight))
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
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX, Font.bold, fontLarge ] (text "Let's Chat!")
                                        , paragraph [ Font.center ]
                                            [ text "Email: "
                                            , link []
                                                { url = "mailto:seb@dunnaudio.com"
                                                , label = el [ Font.underline ] (text "seb@dunnaudio.com")
                                                }
                                            ]
                                        ]
                                    , column [ width fill, spacingSmall, Font.center ]
                                        [ el [ centerX ]
                                            (text "Follow me on my socials!")
                                        , wrappedRow [ width fill, paddingXY 30 0, spacing 30 ]
                                            [ link [ width fill ]
                                                { url =
                                                    "https://www.facebook.com/dunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.facebook))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://www.instagram.com/sebdunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.instagram))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://twitter.com/sebdunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.twitter))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://www.linkedin.com/in/dunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.linkedin))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://www.imdb.com/name/nm2271521"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.imdb))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://soundcloud.com/user-716251106"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.soundcloud))
                                                }
                                            ]
                                        ]
                                    ]
                                , column [ width fill, padding 30, spacing 10, Background.color black, Font.center, fontSmall, Font.light, Font.color white ]
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

                    Tablet ->
                        [ Html.text "tablet" ]

                    BigDesktop ->
                        [ Html.text "big desktop" ]

                    Desktop ->
                        [ layout []
                            (column [ width fill, height fill, fontNormal, Font.color black, Font.letterSpacing 0.5 ]
                                [ row [ width fill, paddingXY 0 30 ]
                                    [ el [ width (fillPortion 1) ] none
                                    , row [ width (fillPortion 4) ]
                                        [ image [ width (px 200), height (px 88), alignLeft ] { src = "images/logo.webp", description = "Dunn 🎙 Audio" }
                                        , row [ alignRight, spacingMedium, fontRaleway, fontNormal, Font.light ]
                                            [ text "Home"
                                            , text "About Me"
                                            , text "Portfolio"
                                            , text "Testimonials"
                                            , text "Contact"
                                            , text "My CV"
                                            ]
                                        ]
                                    , el [ width (fillPortion 1) ] none
                                    ]
                                , el [ width fill ]
                                    (image [ width fill, height (px 800) ]
                                        { src =
                                            "images/elephants.webp"
                                        , description = "Sebastian recording elephants"
                                        }
                                    )
                                , column [ width (px 1200), height fill, centerX, paddingXY 0 50, spacingLarge, fontRaleway ]
                                    [ row [ width fill, spacingSmall ]
                                        [ column [ spacingMedium, width (fillPortion 1), alignTop, Font.center ]
                                            [ el [ centerX, Font.bold, fontHeading ] (text "About Me")
                                            , paragraph [ spacingParagraph ] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]
                                            , paragraph [ spacingParagraph ] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]
                                            , paragraph [ spacingParagraph ] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]
                                            , paragraph [ spacingParagraph ] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
                                            ]
                                        , column [ alignTop, spacingSmall, width (fillPortion 1) ]
                                            [ el [ width (px 590), height (px 350), clip ]
                                                (image
                                                    [ width fill, height fill ]
                                                    { src = "images/cheetah.webp"
                                                    , description = "Sebastian wearing sound equipment and standing next to a cheetah"
                                                    }
                                                )
                                            , el [ width (px 590), height (px 350), clip ]
                                                (image
                                                    [ width fill, height fill ]
                                                    { src = "images/hadza.webp"
                                                    , description = "Sebastian recording members of the Hadza community in Tanzania"
                                                    }
                                                )
                                            ]
                                        ]
                                    , column [ spacingMedium, width fill ]
                                        [ row [ spacingSmall, width fill ]
                                            [ el [ width (fillPortion 2), height fill, clip ]
                                                (image
                                                    [ width fill, height fill ]
                                                    { src = "images/ambisonic-gorongosa.webp"
                                                    , description = "Sebastian recording ambisonic sound on top of a car in Gorongosa National Park in Mozambique"
                                                    }
                                                )
                                            , column [ spacingMedium, width (fillPortion 5), Font.center ]
                                                [ el [ centerX, Font.bold, fontHeading ] (text "What I Do Now")
                                                , paragraph [ spacingParagraph ] [ text "I spend a lot of my time on documentary productions, although I still work in other arenas. This has taken me all over the world, working for the major broadcasting channels in over 30 countries and exploring a diverse range of subjects." ]
                                                , paragraph [ spacingParagraph ] [ text "I also now specialise in recording ‘The sounds of Africa’ having been commissioned by several top international production companies to record animals and general ambiences of Africa." ]
                                                , paragraph [ spacingParagraph ] [ text "My favourite ‘go-to’ is an Ambisonic Microphone that captures immersive surround sounds of the environments I’m recording in - an important tool in the sound design process of most productions." ]
                                                ]
                                            ]
                                        , row [ spacingSmall, width fill ]
                                            [ el [ alignTop, width (fillPortion 1), height (px 340), clip ]
                                                (image
                                                    [ width fill, height fill ]
                                                    { src = "images/wauja-palin.webp"
                                                    , description = "Sebastian standing with a member of the Wauja community in the Amazon"
                                                    }
                                                )
                                            , el [ alignTop, width (fillPortion 1), height (px 340), clip ]
                                                (image
                                                    [ width fill, height fill ]
                                                    { src = "images/cape-town.webp"
                                                    , description = "Sebastian recording sound in front of Cape Town city hall during lockdown"
                                                    }
                                                )
                                            ]
                                        ]
                                    , column [ spacingMedium, width fill ]
                                        [ el [ centerX, Font.bold, fontHeading ] (text "Nominations & Awards")
                                        , row [ centerX, spacingMedium ]
                                            [ column awardStyle
                                                [ paragraph [] [ text "BAFTA Craft Awards nominee" ]
                                                , paragraph [] [ text "2013" ]
                                                , paragraph [] [ text "Best Sound for 'Brazil with Michael Palin'" ]
                                                ]
                                            , column awardStyle
                                                [ paragraph [] [ text "Jackson Wild Media Awards nominee" ]
                                                , paragraph [] [ text "2015" ]
                                                , paragraph [] [ text "Best Sound for 'Gorongosa Park: Rebirth of Paradise'" ]
                                                ]
                                            , column awardStyle
                                                [ paragraph [] [ text "News and Documentary Emmy Awards nominee" ]
                                                , paragraph [] [ text "2023" ]
                                                , paragraph [] [ text "Outstanding Sound for 'Our Universe'" ]
                                                ]
                                            ]
                                        ]
                                    , column [ spacingMedium, width fill ]
                                        [ el [ centerX, Font.bold, fontHeading ] (text "Extra Documents & Notes")
                                        , row [ spacingSmall, width fill ]
                                            [ column [ centerX, alignTop, spacingSmall, width (px 380) ]
                                                [ el
                                                    [ centerX
                                                    , width (px 100)
                                                    , height (px 100)
                                                    , Border.color orange
                                                    , Border.rounded 50
                                                    , Border.width 3
                                                    , Font.color orange
                                                    ]
                                                    (el [ centerX, centerY, width (fill |> maximum 50), height (px 50) ]
                                                        (html (Icon.view IconSolid.passport))
                                                    )
                                                , paragraph [ Font.center, Font.bold, fontLarge ] [ text "British & South African Passport" ]
                                                ]
                                            , column [ centerX, alignTop, spacingSmall, width (px 380) ]
                                                [ el
                                                    [ centerX
                                                    , width (px 100)
                                                    , height (px 100)
                                                    , Border.color orange
                                                    , Border.rounded 50
                                                    , Border.width 3
                                                    , Font.color orange
                                                    ]
                                                    (el [ centerX, centerY, width (fill |> maximum 70), height (px 50) ]
                                                        (html (Icon.view IconSolid.chalkboardTeacher))
                                                    )
                                                , paragraph [ Font.center, Font.bold, fontLarge ] [ text "Teaching Experience" ]
                                                ]
                                            , column [ centerX, alignTop, spacingSmall, width (px 380) ]
                                                [ el
                                                    [ centerX
                                                    , width (px 100)
                                                    , height (px 100)
                                                    , Border.color orange
                                                    , Border.rounded 50
                                                    , Border.width 3
                                                    , Font.color orange
                                                    ]
                                                    (el [ centerX, centerY, width (fill |> maximum 50), height (px 50) ]
                                                        (html (Icon.view IconSolid.syringe))
                                                    )
                                                , paragraph [ Font.center, Font.bold, fontLarge ] [ text "Updated Immunisations for Foreign Travel" ]
                                                ]
                                            ]
                                        , row [ width fill ]
                                            [ el
                                                [ centerX
                                                , paddingXY 30 20
                                                , Border.color orange
                                                , Border.rounded 10
                                                , Background.color orange
                                                , Font.color white
                                                ]
                                                (text "View my CV for more")
                                            ]
                                        ]
                                    , column [ spacingMedium, width fill ]
                                        [ el [ centerX, Font.bold, fontHeading ] (text "Portfolio")
                                        , column [ spacingSmall, width fill ]
                                            [ row [ centerX, spacingSmall ]
                                                [ youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/Q33TkQKlIMg?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=1" }
                                                , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/q1UcC7BsI1M?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=3" }
                                                , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/Vg93ijoQeJ8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=5" }
                                                ]
                                            , row [ centerX, spacingSmall ]
                                                [ youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/vTA6EX-0Xr8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=7" }
                                                , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/X1_Y12auEgk?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=9" }
                                                , vimeoVideo { width = 320, height = 180, src = "https://player.vimeo.com/video/168173513?color&autopause=0&loop=0&muted=0&title=1&portrait=1&byline=1#t=" }
                                                ]
                                            ]
                                        , row [ spacingSmall, width fill ]
                                            [ clientLogo { description = "Survivor", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-45.png", logoWidth = 180 }
                                            , clientLogo { description = "HBO", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-22.jpg", logoWidth = 180 }
                                            , clientLogo { description = "Netflix", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-32.jpg", logoWidth = 180 }
                                            , clientLogo { description = "Apple TV", src = "https://dunnaudio.com/wp-content/uploads/2023/06/apple-tv__e7aqjl2rqzau_og.png", logoWidth = 180 }
                                            ]
                                        , row [ spacingSmall, width fill ]
                                            [ clientLogo { description = "BBC", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-12.jpg", logoWidth = 180 }
                                            , clientLogo { description = "National Geographic", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-31.jpg", logoWidth = 180 }
                                            , clientLogo { description = "Animal Planet", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-4.jpg", logoWidth = 180 }
                                            , clientLogo { description = "Discovery Channel", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-19.jpg", logoWidth = 180 }
                                            ]
                                        , row [ spacingSmall, width fill ]
                                            [ clientLogo { description = "PBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-34.jpg", logoWidth = 180 }
                                            , clientLogo { description = "History", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-25.jpg", logoWidth = 180 }
                                            , clientLogo { description = "CBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-14.jpg", logoWidth = 180 }
                                            , clientLogo { description = "abc primetime", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-2.jpg", logoWidth = 180 }
                                            , clientLogo { description = "Sky 1", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-41.gif", logoWidth = 180 }
                                            ]
                                        ]
                                    , column [ spacingSmall, width fill ]
                                        [ el [ centerX, Font.bold, fontHeading ] (text "Testimonials")
                                        , row [ width fill ]
                                            [ el [ width (fillPortion 1), height fill ]
                                                (el [ centerX, centerY, width (px 20), height (px 20), Font.color orange ]
                                                    (html (Icon.view IconSolid.angleLeft))
                                                )
                                            , column [ width (fillPortion 10), height fill, Font.center, fontNormal, Font.light, Font.letterSpacing 0.3 ]
                                                [ column [ centerX, spacing 10 ]
                                                    [ paragraph [] [ text "“… Despite the incredibly difficult working conditions in Mali and Egypt your sound recording was brilliant." ]
                                                    , paragraph [] [ text "We so appreciate having someone with your enthusiasm, energy and experience." ]
                                                    , paragraph [] [ text "Your stereo recordings of the big ceremonies have created a sound that makes the viewer feel so present…" ]
                                                    , paragraph [] [ text "“Cosmic Africa“ has really benefited in a big way through your dedication to the sound…”" ]
                                                    ]
                                                , paragraph [ paddingEach { top = 30, left = 0, right = 0, bottom = 0 }, Font.bold ] [ text "Craig Foster" ]
                                                , paragraph [ paddingEach { top = 15, left = 0, right = 0, bottom = 0 } ] [ text "Earthrise Productions" ]
                                                ]
                                            , el [ width (fillPortion 1), height fill ]
                                                (el [ centerX, centerY, width (px 20), height (px 20), Font.color orange ]
                                                    (html (Icon.view IconSolid.angleRight))
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
                                    , column [ spacingSmall, width fill ]
                                        [ el [ centerX, Font.bold, fontHeading ] (text "Let's Chat!")
                                        , paragraph [ Font.center ]
                                            [ text "Email: "
                                            , link []
                                                { url = "mailto:seb@dunnaudio.com"
                                                , label = el [ Font.underline ] (text "seb@dunnaudio.com")
                                                }
                                            ]
                                        ]
                                    , column [ spacingMedium, width fill ]
                                        [ el [ centerX ]
                                            (text "Follow me on my socials!")
                                        , row [ width fill, paddingXY 50 0, spacing 150 ]
                                            [ link [ width fill ]
                                                { url =
                                                    "https://www.facebook.com/dunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.facebook))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://www.instagram.com/sebdunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.instagram))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://twitter.com/sebdunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.twitter))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://www.linkedin.com/in/dunnaudio"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.linkedin))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://www.imdb.com/name/nm2271521"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.imdb))
                                                }
                                            , link [ width fill ]
                                                { url =
                                                    "https://soundcloud.com/user-716251106"
                                                , label = el [ width (px 45), height (px 45), centerX ] (html (Icon.view IconBrands.soundcloud))
                                                }
                                            ]
                                        ]
                                    ]
                                , column [ width fill, padding 30, spacing 10, Background.color black, Font.center, fontNormal, Font.light, Font.color white ]
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


fontRaleway : Attribute msg
fontRaleway =
    Font.family
        [ Font.external
            { name = "Raleway"
            , url =
                "https://fonts.googleapis.com/css2?family=Raleway:wght@300;500;700&display=swap"
            }
        , Font.sansSerif
        ]


clientLogo : { src : String, description : String, logoWidth : Int } -> Element msg
clientLogo logoParams =
    el
        [ centerX
        , width (px logoParams.logoWidth)
        , Border.color (rgb 1 1 1)
        , Border.rounded 5
        , Border.width 1
        , clip
        ]
        (image
            [ width (px logoParams.logoWidth)
            ]
            { src = logoParams.src, description = logoParams.description }
        )


youtubeVideo : { a | width : Int, height : Int, src : String } -> Element msg
youtubeVideo { width, height, src } =
    el []
        (html
            (Html.iframe
                [ Html.Attributes.width width
                , Html.Attributes.height height
                , Html.Attributes.src src
                , Html.Attributes.attribute "allow" "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                , Html.Attributes.attribute "allowfullscreen" "1"
                , Html.Attributes.attribute "frameborder" "0"
                ]
                []
            )
        )


vimeoVideo : { a | width : Int, height : Int, src : String } -> Element msg
vimeoVideo { width, height, src } =
    el [ Background.color black ]
        (html
            (Html.iframe
                [ Html.Attributes.width width
                , Html.Attributes.height height
                , Html.Attributes.src src
                , Html.Attributes.attribute "frameBorder" "0"
                , Html.Attributes.attribute "allowfullscreen" ""
                ]
                []
            )
        )


spacingParagraph : Attribute Msg
spacingParagraph =
    spacing 10


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
    rgb255 255 132 52


grey : Color
grey =
    rgb255 204 204 204


black : Color
black =
    rgb255 10 10 10


white : Color
white =
    rgb255 240 240 240


fontSmall : Attr decorative msg
fontSmall =
    Font.size 16


fontNormal : Attr decorative msg
fontNormal =
    Font.size 20


fontLarge : Attr decorative msg
fontLarge =
    Font.size 28


fontHeading : Attr decorative msg
fontHeading =
    Font.size 56


awardStyle : List (Attribute msg)
awardStyle =
    [ padding 20
    , width (px 330)
    , Border.color orange
    , Border.rounded 10
    , Border.width 1
    , fontLarge
    , Font.bold
    , Font.center
    ]


dot : Color -> Element msg
dot color =
    el [ width (px 16), height (px 16), Border.rounded 8, Background.color color ] none
