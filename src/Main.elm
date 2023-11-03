module Main exposing (main)

import Browser
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import FontAwesome as Icon
import FontAwesome.Attributes as IconAttributes
import FontAwesome.Brands as IconBrands
import FontAwesome.Solid as IconSolid
import Html
import Html.Attributes
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
    { title = "Dunn Audio"
    , body =
        [ layout []
            (column [ height fill, width fill, Font.color black ]
                [ row [ paddingXY 0 30, width fill ]
                    [ el [ width (fillPortion 1) ] none
                    , row [ width (fillPortion 4) ]
                        [ image [ alignLeft, width (px 200) ] { src = "https://dunnaudio.com/wp-content/uploads/2022/09/cropped-DunnAudio.jpg", description = "Dunn 🎙 Audio" }
                        , row [ alignRight, spacingMedium, fontRaleway, Font.size 16, Font.light ]
                            [ text "Home"
                            , text "About Me"
                            , text "Portfolio"
                            , text "Testimonials"
                            , text "Contact"
                            , text "Soundcloud"
                            , text "My CV"
                            ]
                        ]
                    , el [ width (fillPortion 1) ] none
                    ]
                , el [ width fill ]
                    (image [ width fill, height (px 800) ]
                        { src =
                            "https://dunnaudio.com/wp-content/uploads/slider/cache/8008af127f40c45b0e646af4f0f70aa2/E62D442A-A3B2-4883-BE5E-D995FAABE6FA.jpg"
                        , description = "Sebastian recording elephants"
                        }
                    )
                , row [ height fill, width fill, paddingEach { top = 80, left = 0, right = 0, bottom = 30 } ]
                    [ column [ spacingLarge, centerX, width (px 1200), height fill, fontRaleway ]
                        [ row [ spacingSmall, width fill ]
                            [ column [ spacingMedium, width (fillPortion 1), alignTop, Font.center ]
                                [ el [ centerX, Font.bold, Font.size 42 ] (text "About Me")
                                , paragraph [ spacingParagraph ] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]
                                , paragraph [ spacingParagraph ] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]
                                , paragraph [ spacingParagraph ] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]
                                , paragraph [ spacingParagraph ] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
                                ]
                            , column [ alignTop, spacingSmall, width (fillPortion 1) ]
                                [ el [ height (px 330), clip ]
                                    (image
                                        [ width fill, moveUp 50 ]
                                        { src = "https://dunnaudio.com/wp-content/uploads/2022/09/cheetah-2F363AA19-8B11-1EF2-8A0D-93A3D603CE68.jpeg"
                                        , description = "Sebastian wearing sound equipment and standing next to a cheetah"
                                        }
                                    )
                                , el [ width fill, height (px 330), clip ]
                                    (image
                                        [ width fill, moveUp 50 ]
                                        { src = "https://dunnaudio.com/wp-content/uploads/2022/09/img-1107B693DE77-E415-00E8-223D-D374E3ED3911-scaled.jpeg"
                                        , description = "Sebastian recording members of the Hadza community in Tanzania"
                                        }
                                    )
                                ]
                            ]
                        , column [ spacingMedium, width fill ]
                            [ row [ spacingSmall, width fill ]
                                [ el [ width (fillPortion 2), clip ]
                                    (image
                                        [ width fill, moveUp 50 ]
                                        { src = "https://dunnaudio.com/wp-content/uploads/2022/09/img-1515E7DB99D4-ADB2-5104-C6E1-CD9094CB9E9A-scaled.jpeg"
                                        , description = "Sebastian recording ambisonic sound on top of a car in Gorongosa National Park in Mozambique"
                                        }
                                    )
                                , column [ spacingMedium, width (fillPortion 5), Font.center ]
                                    [ el [ centerX, Font.bold, Font.size 42 ] (text "What I Do Now")
                                    , paragraph [ spacingParagraph ] [ text "I spend a lot of my time on documentary productions, although I still work in other arenas. This has taken me all over the world, working for the major broadcasting channels in over 30 countries and exploring a diverse range of subjects." ]
                                    , paragraph [ spacingParagraph ] [ text "I also now specialise in recording ‘The sounds of Africa’ having been commissioned by several top international production companies to record animals and general ambiences of Africa." ]
                                    , paragraph [ spacingParagraph ] [ text "My favourite ‘go-to’ is an Ambisonic Microphone that captures immersive surround sounds of the environments I’m recording in - an important tool in the sound design process of most productions." ]
                                    ]
                                ]
                            , row [ spacingSmall, width fill ]
                                [ el [ width (fillPortion 1), height (px 350), clip ]
                                    (image
                                        [ width fill, moveUp 30 ]
                                        { src = "https://dunnaudio.com/wp-content/uploads/2022/09/img-22916E6B3E7A-3173-1576-2EF7-9B1CFA553751-scaled.jpg"
                                        , description = "Sebastian standing with a member of the Wauja community in the Amazon"
                                        }
                                    )
                                , el [ width (fillPortion 1), height (px 350), clip ]
                                    (image
                                        [ width fill, moveUp 60 ]
                                        { src = "https://dunnaudio.com/wp-content/uploads/2022/09/img-2323B683801B-1B19-5CB3-AD7E-CBAE4EC97E04-scaled.jpeg"
                                        , description = "Sebastian recording sound in front of Cape Town city hall during lockdown"
                                        }
                                    )
                                ]
                            ]
                        , column [ spacingMedium, width fill ]
                            [ el [ centerX, Font.bold, Font.size 42 ] (text "Nominations & Awards")
                            , row [ centerX, spacingSmall ]
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
                            [ el [ centerX, Font.bold, Font.size 42 ] (text "Extra Documents & Notes")
                            , row [ spacingLarge, width fill ]
                                [ column [ centerX, spacingSmall, width (px 300) ]
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
                                    , paragraph [ Font.center, Font.bold, Font.size 24 ] [ text "British & South African Passport" ]
                                    ]
                                , column [ centerX, alignTop, spacingSmall, width (px 300) ]
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
                                    , paragraph [ Font.center, Font.bold, Font.size 24 ] [ text "Teaching Experience" ]
                                    ]
                                , column [ centerX, spacingSmall, width (px 300) ]
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
                                    , paragraph [ Font.center, Font.bold, Font.size 24 ] [ text "Updated Immunisations for Foreign Travel" ]
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
                            [ el [ centerX, Font.bold, Font.size 42 ] (text "Portfolio links")
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
                            ]
                        , column [ spacingSmall, width fill ]
                            [ el [ centerX, Font.bold, Font.size 42 ] (text "Clients")
                            , row [ spacingSmall, width fill ]
                                [ clientLogo { description = "National Geographic", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-31.jpg" }
                                , clientLogo { description = "Love4kNature", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-28.png" }
                                , clientLogo { description = "M-Net", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-29.jpg" }
                                , clientLogo { description = "NatGeo Wild", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-30.jpg" }
                                , clientLogo { description = "Netflix", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-32.jpg" }
                                , clientLogo { description = "NOVA", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-33.jpg" }
                                , clientLogo { description = "PBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-34.jpg" }
                                , clientLogo { description = "Apple TV", src = "https://dunnaudio.com/wp-content/uploads/2023/06/apple-tv__e7aqjl2rqzau_og.png" }
                                ]
                            , row [ spacingSmall, width fill ]
                                [ clientLogo { description = "SABC 2", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-38.jpg" }
                                , clientLogo { description = "SARU", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-39.jpg" }
                                , clientLogo { description = "Sky Sports", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-40-300x50.jpg" }
                                , clientLogo { description = "Sky 1", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-41.gif" }
                                , clientLogo { description = "raw TV", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-35.jpg" }
                                , clientLogo { description = "RTL", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-36.jpg" }
                                , clientLogo { description = "SABC 1", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-37.jpg" }
                                ]
                            , row [ spacingSmall, width fill ]
                                [ clientLogo { description = "Animal Planet", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-4.jpg" }
                                , clientLogo { description = "Al Rayyan", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-3.jpg" }
                                , clientLogo { description = "abc primetime", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-2.jpg" }
                                , clientLogo { description = "Survivor", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-45.png" }
                                , clientLogo { description = "BBC Two", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-7.jpg" }
                                , clientLogo { description = "arte", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-6.jpg" }
                                , clientLogo { description = "ARD", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-5.jpg" }
                                ]
                            , row [ spacingSmall, width fill ]
                                [ clientLogo { description = "BBC One", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-13.jpg" }
                                , clientLogo { description = "BBC", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-12.jpg" }
                                , clientLogo { description = "BBC World News", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-11.jpg" }
                                , clientLogo { description = "BBC Entertainment", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-10.jpg" }
                                , clientLogo { description = "BBC Lifestyle", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-9.jpg" }
                                , clientLogo { description = "BBC Four", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-8.jpg" }
                                , clientLogo { description = "CBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-14.jpg" }
                                ]
                            , row [ spacingSmall, width fill ]
                                [ clientLogo { description = "4", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-15.jpg" }
                                , clientLogo { description = "National Geographic Channel", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-21.jpg" }
                                , clientLogo { description = "food network", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-20.jpg" }
                                , clientLogo { description = "Discovery Channel", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-19.jpg" }
                                , clientLogo { description = "colors Viacom", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-18.jpg" }
                                , clientLogo { description = "Channel 5", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-17.jpg" }
                                , clientLogo { description = "Channel 5", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-16.jpg" }
                                ]
                            , row [ spacingSmall, width fill ]
                                [ clientLogo { description = "HBO", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-22.jpg" }
                                , clientLogo { description = "HDNet", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-23.jpg" }
                                , clientLogo { description = "HGTV", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-24.jpg" }
                                , clientLogo { description = "History", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-25.jpg" }
                                , clientLogo { description = "itv", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-26.jpg" }
                                , clientLogo { description = "kykNET", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-27.jpg" }
                                ]
                            ]
                        , column [ spacingSmall, width fill ]
                            [ el [ centerX, Font.bold, Font.size 42 ] (text "Testimonials")
                            , row [ width fill ]
                                [ el [ width (fillPortion 1), height fill ]
                                    (el [ centerX, centerY, width (px 20), height (px 20), Font.color orange ]
                                        (html (Icon.view IconSolid.angleLeft))
                                    )
                                , column [ width (fillPortion 8), height fill, Font.center, fontRaleway, Font.size 16, Font.light, Font.letterSpacing 0.3 ]
                                    [ column [ centerX, spacing 10 ]
                                        [ paragraph [] [ text "“… Despite the incredibly difficult working conditions in Mali and Egypt your sound recording was brilliant." ]
                                        , paragraph [] [ text "We so appreciate having someone with your enthusiasm, energy and experience." ]
                                        , paragraph [] [ text "Your stereo recordings of the big ceremonies have created a sound that makes the viewer feel so present…" ]
                                        , paragraph [] [ text "“Cosmic Africa“ has really benefited in a big way through your dedication to the sound…”" ]
                                        ]
                                    , paragraph [ paddingEach { top = 30, left = 0, right = 0, bottom = 0 }, fontRaleway, Font.bold ] [ text "Craig Foster" ]
                                    , paragraph
                                        [ paddingEach { top = 15, left = 0, right = 0, bottom = 0 } ]
                                        [ text "Earthrise Productions" ]
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
                            [ el [ centerX, Font.bold, Font.size 42 ] (text "Let's Chat!")
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
                            , row
                                [ spacing 200, width fill, paddingXY 50 0 ]
                                [ link [ width fill ]
                                    { url =
                                        "https://www.facebook.com/dunnaudio"
                                    , label = el [ centerX, width (px 45), height (px 45) ] (html (Icon.view IconBrands.facebook))
                                    }
                                , link [ width fill ]
                                    { url =
                                        "https://www.instagram.com/sebdunnaudio"
                                    , label = el [ centerX, width (px 45), height (px 45) ] (html (Icon.view IconBrands.instagram))
                                    }
                                , link [ width fill ]
                                    { url =
                                        "https://twitter.com/sebdunnaudio"
                                    , label = el [ centerX, width (px 45), height (px 45) ] (html (Icon.view IconBrands.twitter))
                                    }
                                , link [ width fill ]
                                    { url =
                                        "https://www.linkedin.com/in/dunnaudio"
                                    , label = el [ centerX, width (px 45), height (px 45) ] (html (Icon.view IconBrands.linkedin))
                                    }
                                , link [ width fill ]
                                    { url =
                                        "https://www.imdb.com/name/nm2271521"
                                    , label = el [ centerX, width (px 45), height (px 45) ] (html (Icon.view IconBrands.imdb))
                                    }
                                ]
                            ]
                        ]
                    ]
                , column [ width fill, padding 30, spacing 10, Background.color black, Font.center, Font.size 16, Font.light, Font.color white ]
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


clientLogo : { src : String, description : String } -> Element msg
clientLogo imageSrc =
    el
        [ centerX
        , width (px 120)
        , Border.color (rgb 1 1 1)
        , Border.rounded 5
        , Border.width 1
        , clip
        ]
        (image
            [ width (px 120)
            ]
            imageSrc
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


awardStyle : List (Attribute msg)
awardStyle =
    [ padding 10
    , width (px 280)
    , Border.color orange
    , Border.rounded 10
    , Border.width 1
    , Font.size 20
    , Font.bold
    , Font.center
    ]


dot : Color -> Element msg
dot color =
    el [ width (px 16), height (px 16), Border.rounded 8, Background.color color ] none
