module Main exposing (main)

import Animation
import Browser
import Browser.Events as Events
import Browser.Navigation exposing (Key)
import Ease
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
import Process
import Task
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
    , windowWidth : Int
    , bannerPictures : ZipList Picture
    , bannerChangeInterval : Float
    , bannerNonce : Int
    , bannerTransition : BannerTransition
    , testimonials : ZipList Testimonial
    , testimonialChangeInterval : Float
    , testimonialNonce : Int
    , testimonialAnimation : Animation.State
    , testimonialTransition : TestimonialTransition
    }


type MenuState
    = Closed
    | Open


type alias ZipList a =
    { beforeReversed : List a
    , current : a
    , after : List a
    }


selectNext : ZipList a -> ZipList a
selectNext { beforeReversed, current, after } =
    case ( beforeReversed, current, after ) of
        ( beforeList, selected, afterHead :: afterRest ) ->
            { beforeReversed = selected :: beforeList
            , current = afterHead
            , after = afterRest
            }

        ( beforeList, selected, [] ) ->
            let
                beforeListInOrder =
                    List.reverse beforeList
            in
            case beforeListInOrder of
                beforeFirst :: beforeRest ->
                    { beforeReversed = []
                    , current = beforeFirst
                    , after = beforeRest ++ [ selected ]
                    }

                [] ->
                    { beforeReversed = []
                    , current = selected
                    , after = []
                    }


selectPrevious : ZipList a -> ZipList a
selectPrevious { beforeReversed, current, after } =
    case ( beforeReversed, current, after ) of
        ( beforeHead :: beforeRest, selected, afterList ) ->
            { beforeReversed = beforeRest
            , current = beforeHead
            , after = selected :: afterList
            }

        ( [], selected, afterList ) ->
            let
                afterListReversed =
                    List.reverse afterList
            in
            case afterListReversed of
                lastItem :: afterRestReversed ->
                    { beforeReversed = afterRestReversed ++ [ selected ]
                    , current = lastItem
                    , after = []
                    }

                [] ->
                    { beforeReversed = []
                    , current = selected
                    , after = []
                    }


getPrevious : ZipList a -> a
getPrevious { beforeReversed, current, after } =
    case beforeReversed of
        beforeHead :: _ ->
            beforeHead

        [] ->
            let
                afterLast =
                    after |> List.reverse |> List.head
            in
            case afterLast of
                Just last ->
                    last

                Nothing ->
                    current


getNext : ZipList a -> a
getNext { beforeReversed, current, after } =
    case after of
        afterHead :: _ ->
            afterHead

        [] ->
            let
                beforeFirst =
                    beforeReversed |> List.reverse |> List.head
            in
            case beforeFirst of
                Just first ->
                    first

                Nothing ->
                    current


type alias Nonce =
    Int


type alias Picture =
    { src : String
    , description : String
    }


type BannerTransition
    = AtoB Animation.State Animation.State
    | BtoA Animation.State Animation.State


type alias Testimonial =
    { quote : List String
    , name : String
    , company : String
    }


type TestimonialTransition
    = None
    | Next
    | Previous


init : Flags -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags _ _ =
    ( { device =
            classifyDevice
                { width = flags.window.innerWidth
                , height = flags.window.innerHeight
                }
      , menuState = Closed
      , windowWidth = flags.window.innerWidth
      , bannerPictures =
            { beforeReversed = []
            , current =
                { src = "images/elephants.webp"
                , description = "Sebastian recording elephants"
                }
            , after =
                [ { src = "images/cape-town-prep.webp"
                  , description = "Sebastian preparing to record ambisonic audio in the Cape Town city square"
                  }
                , { src = "images/desert.webp"
                  , description = ""
                  }
                , { src = "images/elephant-watering-hole.webp"
                  , description = ""
                  }
                , { src = "images/lion-fence.webp"
                  , description = ""
                  }
                , { src = "images/shark.webp"
                  , description = ""
                  }
                , { src = "images/tribal-council.webp"
                  , description = ""
                  }
                ]
            }
      , bannerChangeInterval = 2000.0
      , bannerNonce = 0
      , bannerTransition = AtoB (Animation.style [ Animation.opacity 0 ]) (Animation.style [ Animation.opacity 1 ])
      , testimonials =
            { beforeReversed = []
            , current =
                { quote =
                    [ "“Just so you know the Swedes were extremely impressed with your work, your attitude and everything else about you. Thanks for flying our flag high!”"
                    ]
                , name = "Robin Matthews"
                , company = "Big Banana Productions - Haaj Med Doreen"
                }
            , after =
                [ { quote =
                        [ "“Seb is always my first choice as a sound recordist in Southern Africa. He will always perform in the toughest of situations. He’s just as happy to work in the bush, in the desert or in the City. Seb is a great team player and presenters love him. I will be working with Seb again and again.”" ]
                  , name = "Dale Templar"
                  , company = "Series Producer, BBC and BBC Natural History Unit , Human Planet"
                  }
                , { quote =
                        [ "“It was a delight to work with you. I felt totally confident that you were getting the best sound we could hope for (given the limitations of the shoot). You were calm and collected at all times – and your advice and suggestions were invaluable. On top of that, you were a great guy to hang out with.”" ]
                  , name = "Ashok Prasad"
                  , company = "Director- Danger Men - Firefly Productions"
                  }
                , { quote =
                        [ "“Sebastian is a dedicated and enthusiastic soundman who is capable of handling any sound eventuality.”" ]
                  , name = "Andre Du Plessis"
                  , company = "Abacus Productions"
                  }
                , { quote =
                        [ "“The best soundman, fellow traveller & all round good guy you could wish to meet! Thanks for fantastic work and terrific support.”" ]
                  , name = "Michael Palin"
                  , company = "Brazil with Michael Palin"
                  }
                , { quote =
                        [ "“Sebastian is a huge asset on our shoots. He is such a pleasure to have around and knows a lot about a lot, was super valuable and willing to help in every way – above and beyond the call of duty. I will always REALLY hope for Seb’s availability on every location shoot I have as he was a real professional, a lot of fun and has a really big heart. Thank you Seb!”" ]
                  , name = "Rita Mbanga"
                  , company = "Producer at Sunrise Productions"
                  }
                , { quote =
                        [ "“… Despite the incredibly difficult working conditions in Mali and Egypt your sound recording was brilliant."
                        , "We so appreciate having someone with your enthusiasm, energy and experience."
                        , "Your stereo recordings of the big ceremonies have created a sound that makes the viewer feel so present…"
                        , "“Cosmic Africa“ has really benefited in a big way through your dedication to the sound…”"
                        ]
                  , name = "Craig Foster"
                  , company = "Earthrise Productions"
                  }
                ]
            }
      , testimonialChangeInterval = 8000.0
      , testimonialNonce = 0
      , testimonialAnimation =
            Animation.style [ Animation.translate (Animation.px 0) (Animation.px 0) ]
      , testimonialTransition = None
      }
    , Cmd.batch
        [ Task.perform (\_ -> ChangeBanner 0) (Process.sleep 2000.0)
        , Task.perform (\_ -> NextTestimonial 0) (Process.sleep 8000.0)
        ]
    )


type Msg
    = UpdateDevice { width : Int, height : Int }
    | ToggleMenuState
    | ChangeBanner Nonce
    | NextTestimonial Nonce
    | PreviousTestimonial Nonce
    | Animate Animation.Msg
    | Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateDevice window ->
            ( { model | device = classifyDevice window, windowWidth = window.width }, Cmd.none )

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

        ChangeBanner nonce ->
            if nonce < model.bannerNonce then
                ( model, Cmd.none )

            else
                let
                    newNonce =
                        nonce + 1
                in
                ( { model
                    | bannerPictures = selectNext model.bannerPictures
                    , bannerTransition =
                        case model.bannerTransition of
                            AtoB astate bstate ->
                                BtoA
                                    (Animation.interrupt
                                        [ Animation.toWith bannerInterpolation [ Animation.opacity 1.0 ] ]
                                        astate
                                    )
                                    (Animation.interrupt
                                        [ Animation.toWith bannerInterpolation [ Animation.opacity 0.0 ] ]
                                        bstate
                                    )

                            BtoA astate bstate ->
                                AtoB
                                    (Animation.interrupt
                                        [ Animation.toWith bannerInterpolation [ Animation.opacity 0.0 ] ]
                                        astate
                                    )
                                    (Animation.interrupt
                                        [ Animation.toWith bannerInterpolation [ Animation.opacity 1.0 ] ]
                                        bstate
                                    )
                    , bannerNonce = newNonce
                  }
                , Task.perform (\_ -> ChangeBanner newNonce) (Process.sleep model.bannerChangeInterval)
                )

        NextTestimonial nonce ->
            if nonce < model.testimonialNonce then
                ( model, Cmd.none )

            else
                let
                    newNonce =
                        nonce + 1
                in
                ( { model
                    | testimonials = selectNext model.testimonials
                    , testimonialNonce = newNonce
                    , testimonialAnimation =
                        Animation.queue
                            [ Animation.toWith testimonialInterpolation
                                [ Animation.translate
                                    (Animation.px (toFloat -testimonialWidth))
                                    (Animation.px 0)
                                ]
                            ]
                            (Animation.style
                                [ Animation.translate
                                    (Animation.px 0)
                                    (Animation.px 0)
                                ]
                            )
                    , testimonialTransition = Next
                  }
                , Task.perform (\_ -> NextTestimonial newNonce) (Process.sleep model.testimonialChangeInterval)
                )

        PreviousTestimonial nonce ->
            if nonce < model.testimonialNonce then
                ( model, Cmd.none )

            else
                let
                    newNonce =
                        nonce + 1
                in
                ( { model
                    | testimonials = selectPrevious model.testimonials
                    , testimonialNonce = newNonce
                    , testimonialAnimation =
                        Animation.queue
                            [ Animation.toWith testimonialInterpolation
                                [ Animation.translate
                                    (Animation.px 0)
                                    (Animation.px 0)
                                ]
                            ]
                            (Animation.style
                                [ Animation.translate
                                    (Animation.px (toFloat -testimonialWidth))
                                    (Animation.px 0)
                                ]
                            )
                    , testimonialTransition = Previous
                  }
                , Task.perform (\_ -> NextTestimonial newNonce) (Process.sleep model.testimonialChangeInterval)
                )

        Animate animationMsg ->
            let
                updateAnimation =
                    Animation.update animationMsg
            in
            ( { model
                | bannerTransition =
                    case model.bannerTransition of
                        AtoB astate bstate ->
                            AtoB (updateAnimation astate) (updateAnimation bstate)

                        BtoA astate bstate ->
                            BtoA (updateAnimation astate) (updateAnimation bstate)
                , testimonialAnimation = updateAnimation model.testimonialAnimation
              }
            , Cmd.none
            )

        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions { bannerTransition, testimonialAnimation } =
    let
        ( astate, bstate ) =
            case bannerTransition of
                AtoB a b ->
                    ( a, b )

                BtoA a b ->
                    ( a, b )
    in
    Sub.batch
        [ Events.onResize
            (\w h ->
                UpdateDevice
                    { width = w
                    , height = h
                    }
            )
        , Animation.subscription Animate
            [ astate
            , bstate
            , testimonialAnimation
            ]
        ]


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest _ =
    Noop


onUrlChange : Url.Url -> Msg
onUrlChange _ =
    Noop



-- attribute order: width, height, alignment, padding, spacing, background, font


view : Model -> Browser.Document Msg
view model =
    { title = "Dunn Audio"
    , body =
        let
            modelDevice =
                model.device

            phoneModel =
                { model | device = { modelDevice | class = Phone } }

            phoneLayout =
                [ navbar phoneModel
                , banner model
                , column [ width fill, height fill, paddingXY 20 40, spacingMedium ]
                    (List.map (\section -> section phoneModel) sections)
                , footer phoneModel
                ]

            desktopModel =
                { model | device = { modelDevice | class = Desktop } }

            desktopLayout =
                [ navbar desktopModel
                , banner model
                , column [ width (px 1200), height fill, centerX, paddingXY 20 50, spacingLarge ]
                    (List.map (\section -> section desktopModel) sections)
                , footer desktopModel
                ]
        in
        [ layout []
            (column [ width fill, height fill, fontRaleway, fontNormal, Font.color black, Font.letterSpacing 0.5 ]
                (case model.device.class of
                    Phone ->
                        phoneLayout

                    Tablet ->
                        [ navbar model
                        , banner model
                        , column [ width (px 600), height fill, centerX, paddingXY 20 50, spacingLarge ]
                            -- TODO: rework each section for tablets
                            (List.map (\section -> section desktopModel) sections)
                        , footer desktopModel
                        ]

                    Desktop ->
                        desktopLayout

                    BigDesktop ->
                        desktopLayout
                )
            )
        ]
    }



-- ELEMENTS


sections :
    List
        ({ b
            | device : Device
            , testimonials : ZipList Testimonial
            , testimonialNonce : Int
            , testimonialAnimation : Animation.State
            , testimonialTransition : TestimonialTransition
         }
         -> Element Msg
        )
sections =
    [ aboutMe
    , whatIDo
    , achievements
    , portfolio
    , viewTestimonials
    , letschat
    , socials
    ]


navbar : { a | menuState : MenuState, device : Device } -> Element Msg
navbar { menuState, device } =
    let
        menuButton =
            el
                [ width (px 30)
                , centerY
                , alignRight
                , ElementEvents.onClick ToggleMenuState
                ]
                (html (Icon.view IconSolid.bars))

        mobile =
            row ([ width fill, height (px 150), padding 20, spacing 10 ] ++ dropdown menuState)
                [ logo
                , menuButton
                ]

        desktop =
            row [ width fill, paddingXY 0 30, spacingMedium ]
                [ row [ width (px 1200), paddingXY 20 0, centerX ]
                    [ logo
                    , row [ alignRight, spacingMedium, fontNormal, Font.light ]
                        [ text "Home"
                        , text "About Me"
                        , text "Portfolio"
                        , text "Testimonials"
                        , text "Contact"
                        , text "My CV"
                        ]
                    ]
                ]
    in
    case device.class of
        Phone ->
            mobile

        Tablet ->
            mobile

        Desktop ->
            desktop

        BigDesktop ->
            desktop


banner :
    { a
        | windowWidth : Int
        , bannerPictures : ZipList Picture
        , bannerTransition : BannerTransition
    }
    -> Element msg
banner { windowWidth, bannerPictures, bannerTransition } =
    let
        bannerHeightPx =
            windowWidth
                |> bannerHeight
                |> round
                |> px
    in
    column [ width fill, height bannerHeightPx ]
        (case bannerTransition of
            AtoB astate bstate ->
                -- [ el [ width fill, height bannerHeightPx ] none ]
                [ image
                    ([ width fill
                     , height bannerHeightPx
                     ]
                        ++ List.map htmlAttribute (Animation.render bstate)
                    )
                    bannerPictures.current
                , image
                    ([ width fill
                     , height bannerHeightPx
                     , moveUp (bannerHeight windowWidth)
                     ]
                        ++ List.map htmlAttribute (Animation.render astate)
                    )
                    (getPrevious bannerPictures)
                ]

            BtoA astate bstate ->
                -- [ el [ width fill, height bannerHeightPx ] none ]
                [ image
                    ([ width fill
                     , height bannerHeightPx
                     ]
                        ++ List.map htmlAttribute (Animation.render astate)
                    )
                    bannerPictures.current
                , image
                    ([ width fill
                     , height bannerHeightPx
                     , moveUp (bannerHeight windowWidth)
                     ]
                        ++ List.map htmlAttribute (Animation.render bstate)
                    )
                    (getPrevious bannerPictures)
                ]
        )


bannerHeight : Int -> Float
bannerHeight windowWidth =
    windowWidth
        |> toFloat
        |> (\x -> x * 8 / 16)


orangeRule : Element msg
orangeRule =
    row [ width fill ]
        [ el
            [ width fill
            , height (px 0)
            , Border.widthEach
                { top = 1
                , bottom = 0
                , left = 0
                , right = 0
                }
            , Border.color orange
            ]
            none
        ]


logo : Element msg
logo =
    image [ width (px 240), alignLeft ]
        { src = "images/logo2.webp", description = "Dunn Audio" }


dropdown : MenuState -> List (Attribute msg)
dropdown menuState =
    if menuState == Closed then
        []

    else
        [ below
            (row [ width fill, Background.color white ]
                [ el [ width (fillPortion 1) ] none
                , column [ width (fillPortion 8), padding 20, spacingSmall, Font.light ]
                    (List.intersperse orangeRule
                        (List.map renderPage allPages
                            ++ [ el [ width fill, Font.center ] (text "My CV") ]
                        )
                    )
                , el [ width (fillPortion 1) ] none
                ]
            )
        ]


type Page
    = Home
    | AboutMe
    | Portfolio
    | Testimonials
    | Contact


allPages : List Page
allPages =
    nextPage [] |> List.reverse


nextPage : List Page -> List Page
nextPage lst =
    case lst of
        [] ->
            nextPage (Home :: lst)

        Home :: _ ->
            nextPage (AboutMe :: lst)

        AboutMe :: _ ->
            nextPage (Portfolio :: lst)

        Portfolio :: _ ->
            nextPage (Testimonials :: lst)

        Testimonials :: _ ->
            nextPage (Contact :: lst)

        Contact :: _ ->
            lst


renderPage : Page -> Element msg
renderPage page =
    el [ width fill, Font.center ] (text (toString page))


toString : Page -> String
toString page =
    case page of
        Home ->
            "Home"

        AboutMe ->
            "About Me"

        Portfolio ->
            "Portfolio"

        Testimonials ->
            "Testimonials"

        Contact ->
            "Contact"


aboutMe : { a | device : Device } -> Element Msg
aboutMe { device } =
    let
        paragraph1 =
            paragraph [ spacingParagraph ] [ text "I’m a passionate and positive sound recordist with a sharp ear dedicated to getting the best possible sound with technical proficiency. I am calm, level-headed and have the technical ability and versatility to adapt quickly to changing environments." ]

        paragraph2 =
            paragraph [ spacingParagraph ] [ text "I started working as a sound recordist in 1993. My early work was on environmental documentaries, actuality and corporate production." ]

        paragraph3 =
            paragraph [ spacingParagraph ] [ text "Then, in 1994, I achieved a milestone in my career by covering the post-apartheid elections in South Africa for Sky News. Being involved in such a positive and peaceful moment in South African history further solidified my passion for this career." ]

        paragraph4 =
            paragraph [ spacingParagraph ] [ text "The elections opened many doors for me and in 1995, I set myself up as a full-time freelance sound recordist. I worked on several local and international productions in the film industry as a boom operator to broaden my experience." ]
    in
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX, Font.bold, fontLarge ] (text "About Me")
                , paragraph1
                , el [ width fill ]
                    (image
                        [ width fill, height fill ]
                        { src = "images/cheetah.webp"
                        , description = "Sebastian wearing sound equipment and standing next to a cheetah"
                        }
                    )
                , paragraph2
                , paragraph3
                , el [ width fill ]
                    (image
                        [ width fill, height fill ]
                        { src = "images/hadza.webp"
                        , description = "Sebastian recording members of the Hadza community in Tanzania"
                        }
                    )
                , paragraph4
                ]

        Desktop ->
            row [ width fill, spacingSmall ]
                [ column [ spacingMedium, width (fillPortion 1), alignTop, Font.center ]
                    [ el [ centerX, Font.bold, fontHeading ] (text "About Me")
                    , paragraph1
                    , paragraph2
                    , paragraph3
                    , paragraph4
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

        Tablet ->
            none

        BigDesktop ->
            none


whatIDo : { model | device : Device } -> Element Msg
whatIDo { device } =
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
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

        Desktop ->
            column [ spacingMedium, width fill ]
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

        Tablet ->
            none

        BigDesktop ->
            none


achievements : { a | device : Device } -> Element msg
achievements { device } =
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX, Font.bold, fontLarge ] (text "Achievements")
                , column [ centerX, spacingSmall ]
                    [ column (awardStyle ++ [ fontNormal ])
                        [ paragraph [] [ text "News and Documentary Emmy Awards nominee" ]
                        , paragraph [] [ text "2023" ]
                        , paragraph [] [ text "Outstanding Sound for 'Our Universe'" ]
                        ]
                    , column (awardStyle ++ [ fontNormal ])
                        [ paragraph [] [ text "Innovation in Business Award Winner" ]
                        , paragraph [] [ text "2023" ]
                        , paragraph [] [ text "Most Trusted Sound Recordist" ]
                        ]
                    , column (awardStyle ++ [ fontNormal ])
                        [ paragraph [] [ text "Jackson Wild Media Awards nominee" ]
                        , paragraph [] [ text "2015" ]
                        , paragraph [] [ text "Best Sound for 'Gorongosa Park: Rebirth of Paradise'" ]
                        ]
                    , column (awardStyle ++ [ fontNormal ])
                        [ paragraph [] [ text "BAFTA Craft Awards nominee" ]
                        , paragraph [] [ text "2013" ]
                        , paragraph [] [ text "Best Sound for 'Brazil with Michael Palin'" ]
                        ]
                    ]
                ]

        Desktop ->
            column [ spacingMedium, width fill ]
                [ el [ centerX, Font.bold, fontHeading ] (text "Achievements")
                , row [ centerX, spacingMedium ]
                    [ column awardStyle
                        [ paragraph [] [ text "News and Documentary Emmy Awards nominee" ]
                        , paragraph [] [ text "2023" ]
                        , paragraph [] [ text "Outstanding Sound for 'Our Universe'" ]
                        ]
                    , column awardStyle
                        [ paragraph [] [ text "Innovation in Business Award Winner" ]
                        , paragraph [] [ text "2023" ]
                        , paragraph [] [ text "Most Trusted Sound Recordist" ]
                        ]
                    ]
                , row [ centerX, spacingMedium ]
                    [ column awardStyle
                        [ paragraph [] [ text "Jackson Wild Media Awards nominee" ]
                        , paragraph [] [ text "2015" ]
                        , paragraph [] [ text "Best Sound for 'Gorongosa Park: Rebirth of Paradise'" ]
                        ]
                    , column awardStyle
                        [ paragraph [] [ text "BAFTA Craft Awards nominee" ]
                        , paragraph [] [ text "2013" ]
                        , paragraph [] [ text "Best Sound for 'Brazil with Michael Palin'" ]
                        ]
                    ]
                ]

        Tablet ->
            none

        BigDesktop ->
            none


portfolio : { a | device : Device } -> Element msg
portfolio { device } =
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX, Font.bold, fontLarge ] (text "Portfolio")
                , column [ centerX, spacingSmall ]
                    [ youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/Q33TkQKlIMg?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=1" }
                    , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/q1UcC7BsI1M?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=3" }
                    , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/Vg93ijoQeJ8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=5" }
                    , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/vTA6EX-0Xr8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=7" }
                    , youtubeVideo { width = 320, height = 180, src = "https://www.youtube.com/embed/X1_Y12auEgk?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&origin=https%3A%2F%2Fdunnaudio.com&widgetid=9" }
                    , vimeoVideo { width = 320, height = 180, src = "https://player.vimeo.com/video/168173513?color&autopause=0&loop=0&muted=0&title=1&portrait=1&byline=1#t=" }
                    ]
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

        Desktop ->
            column [ spacingMedium, width fill ]
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

        Tablet ->
            none

        BigDesktop ->
            none


viewTestimonials :
    { b
        | device : Device
        , testimonials : ZipList Testimonial
        , testimonialNonce : Int
        , testimonialAnimation : Animation.State
        , testimonialTransition : TestimonialTransition
    }
    -> Element Msg
viewTestimonials { device, testimonials, testimonialNonce, testimonialAnimation, testimonialTransition } =
    let
        previous =
            testimonialContent testimonialAnimation (getPrevious testimonials)

        current =
            testimonialContent testimonialAnimation testimonials.current

        next =
            testimonialContent testimonialAnimation (getNext testimonials)
    in
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX, Font.bold, fontLarge ] (text "Testimonials")
                , row [ width fill ]
                    [ el [ width (fillPortion 1), height fill ]
                        (el
                            [ centerX
                            , centerY
                            , width (px 20)
                            , height (px 20)
                            , Font.color orange
                            , ElementEvents.onClick (PreviousTestimonial testimonialNonce)
                            ]
                            (html (Icon.view IconSolid.angleLeft))
                        )
                    , column
                        [ width (fillPortion 10)
                        , height fill
                        , Font.center
                        , fontNormal
                        , Font.light
                        , Font.letterSpacing 0.3
                        ]
                        [ column [ centerX, spacing 10 ]
                            (testimonials.current.quote
                                |> List.map (\q -> paragraph [] [ text q ])
                            )
                        , paragraph
                            [ paddingEach { top = 30, left = 0, right = 0, bottom = 0 }
                            , Font.bold
                            ]
                            [ text testimonials.current.name ]
                        , paragraph [ paddingEach { top = 15, left = 0, right = 0, bottom = 0 } ]
                            [ text testimonials.current.company ]
                        ]
                    , el [ width (fillPortion 1), height fill ]
                        (el
                            [ centerX
                            , centerY
                            , width (px 20)
                            , height (px 20)
                            , Font.color orange
                            , ElementEvents.onClick (NextTestimonial testimonialNonce)
                            ]
                            (html (Icon.view IconSolid.angleRight))
                        )
                    ]
                , row [ centerX, spacing 5 ]
                    (List.concat
                        [ testimonials.beforeReversed |> List.map (\_ -> dot grey)
                        , [ dot orange ]
                        , testimonials.after |> List.map (\_ -> dot grey)
                        ]
                    )
                ]

        Desktop ->
            column [ spacingSmall, width fill ]
                [ el [ centerX, Font.bold, fontHeading ] (text "Testimonials")
                , row [ width fill, height (px 300) ]
                    [ el [ width (px testimonialButtonWidth), height fill ]
                        (el
                            [ width (px 20)
                            , height (px 20)
                            , centerX
                            , centerY
                            , Font.color orange
                            , ElementEvents.onClick (PreviousTestimonial testimonialNonce)
                            ]
                            (html (Icon.view IconSolid.angleLeft))
                        )
                    , row [ width (px testimonialWidth), height fill, clip ]
                        (case testimonialTransition of
                            None ->
                                [ current ]

                            Next ->
                                [ previous, current ]

                            Previous ->
                                [ current, next ]
                        )
                    , el [ width (px testimonialButtonWidth), height fill ]
                        (el
                            [ width (px 20)
                            , height (px 20)
                            , centerX
                            , centerY
                            , Font.color orange
                            , ElementEvents.onClick (NextTestimonial testimonialNonce)
                            ]
                            (html (Icon.view IconSolid.angleRight))
                        )
                    ]
                , row [ centerX, spacing 5 ]
                    (List.concat
                        [ testimonials.beforeReversed |> List.map (\_ -> dot grey)
                        , [ dot orange ]
                        , testimonials.after |> List.map (\_ -> dot grey)
                        ]
                    )
                ]

        Tablet ->
            none

        BigDesktop ->
            none


testimonialContent : Animation.State -> Testimonial -> Element msg
testimonialContent animation testimonial =
    column
        ([ width (px testimonialWidth)
         , height fill
         , centerY
         , Font.center
         , fontNormal
         , Font.light
         , Font.letterSpacing 0.3
         ]
            ++ List.map Element.htmlAttribute (Animation.render animation)
        )
        [ column [ centerX, centerY, spacing 10 ]
            (testimonial.quote |> List.map (\q -> paragraph [] [ text q ]))
        , paragraph
            [ centerY
            , paddingEach { top = 30, left = 0, right = 0, bottom = 0 }
            , Font.bold
            ]
            [ text testimonial.name ]
        , paragraph [ centerY, paddingEach { top = 15, left = 0, right = 0, bottom = 0 } ]
            [ text testimonial.company ]
        ]


testimonialWidth : Int
testimonialWidth =
    968


testimonialButtonWidth : Int
testimonialButtonWidth =
    96


letschat : { a | device : Device } -> Element msg
letschat { device } =
    let
        emailContact =
            paragraph [ Font.center ]
                [ text "Email: "
                , link []
                    { url = "mailto:seb@dunnaudio.com"
                    , label = el [ Font.underline ] (text "seb@dunnaudio.com")
                    }
                ]
    in
    case device.class of
        Phone ->
            column [ width fill, spacingSmall ]
                [ el [ centerX, Font.bold, fontLarge ] (text "Let's Chat!")
                , emailContact
                ]

        Desktop ->
            column [ width fill, spacingSmall ]
                [ el [ centerX, Font.bold, fontHeading ] (text "Let's Chat!")
                , emailContact
                ]

        Tablet ->
            none

        BigDesktop ->
            none


socials : { a | device : Device } -> Element msg
socials { device } =
    let
        socialLinks =
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
    in
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX ]
                    (text "Follow me on my socials!")
                , wrappedRow [ width fill, paddingXY 30 0, spacing 30 ] socialLinks
                ]

        Desktop ->
            column [ spacingMedium, width fill ]
                [ el [ centerX ]
                    (text "Follow me on my socials!")
                , row [ width fill, paddingXY 50 0, spacing 150 ] socialLinks
                ]

        Tablet ->
            none

        BigDesktop ->
            none


footer : { a | device : Device } -> Element msg
footer { device } =
    case device.class of
        Phone ->
            column [ width fill, padding 30, spacing 10, Background.color black, Font.center, fontSmall, Font.light, Font.color white ]
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

        Desktop ->
            column [ width fill, padding 30, spacing 10, Background.color black, Font.center, fontNormal, Font.light, Font.color white ]
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

        Tablet ->
            none

        BigDesktop ->
            none


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


dot : Color -> Element msg
dot color =
    el [ width (px 16), height (px 16), Border.rounded 8, Background.color color ] none



-- STYLE


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


bannerInterpolation : Animation.Interpolation
bannerInterpolation =
    Animation.easing
        { duration = 1000.0
        , ease = Ease.inOutQuart
        }


testimonialInterpolation : Animation.Interpolation
testimonialInterpolation =
    Animation.spring { stiffness = 250.0, damping = 18.0 }



-- SPACING


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



-- FONT


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



-- COLORS


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
    rgb255 250 250 250
