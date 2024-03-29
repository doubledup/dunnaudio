module Main exposing (main)

import Animation
import Browser
import Browser.Dom as Dom
import Browser.Events as Events
import Browser.Navigation as Navigation
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
import Url.Builder as UrlBuilder
import Url.Parser as UrlParser
import ZipList exposing (ZipList, getNext, getPrevious, selectNext, selectPrevious)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = OnUrlChange
        , onUrlRequest = OnUrlRequest
        }



-- MODEL


type alias Model =
    { window : Window
    , device : Device
    , navKey : Navigation.Key
    , url : Url.Url
    , menuState : MenuState
    , bannerPictures : ZipList Picture
    , bannerNonce : Int
    , bannerAnimationCurrent : Animation.State
    , bannerAnimationPrevious : Animation.State
    , testimonials : ZipList Testimonial
    , testimonialNonce : Int
    , testimonialAnimation : Animation.State
    , testimonialTransition : TestimonialTransition
    }


type alias Flags =
    { window :
        { innerWidth : Int
        , innerHeight : Int
        }
    }


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( { window =
            { width = flags.window.innerWidth
            , height = flags.window.innerHeight
            }
      , device =
            classifyDevice
                { width = flags.window.innerWidth
                , height = flags.window.innerHeight
                }
      , navKey = navKey
      , url = url
      , menuState = Closed
      , bannerPictures =
            { beforeReversed = []
            , current =
                { src = "images/elephants.webp", description = "Sebastian recording elephants" }
            , after =
                [ { src = "images/cape-town-prep.webp", description = "Sebastian preparing to record ambisonic audio in the Cape Town city square" }
                , { src = "images/desert.webp", description = "" }
                , { src = "images/elephant-watering-hole.webp", description = "" }
                , { src = "images/lion-fence.webp", description = "" }
                , { src = "images/shark.webp", description = "" }
                , { src = "images/tribal-council.webp", description = "" }
                ]
            }
      , bannerNonce = 0
      , bannerAnimationCurrent = Animation.style [ Animation.opacity 1.0 ]
      , bannerAnimationPrevious = Animation.style [ Animation.opacity 0.0 ]
      , testimonials =
            { beforeReversed = []
            , current =
                { quote = [ "“Just so you know the Swedes were extremely impressed with your work, your attitude and everything else about you. Thanks for flying our flag high!”" ]
                , name = "Robin Matthews"
                , company = "Big Banana Productions - Haaj Med Doreen"
                }
            , after =
                [ { quote = [ "“Seb is always my first choice as a sound recordist in Southern Africa. He will always perform in the toughest of situations. He’s just as happy to work in the bush, in the desert or in the City. Seb is a great team player and presenters love him. I will be working with Seb again and again.”" ]
                  , name = "Dale Templar"
                  , company = "Series Producer, BBC and BBC Natural History Unit , Human Planet"
                  }
                , { quote = [ "“It was a delight to work with you. I felt totally confident that you were getting the best sound we could hope for (given the limitations of the shoot). You were calm and collected at all times – and your advice and suggestions were invaluable. On top of that, you were a great guy to hang out with.”" ]
                  , name = "Ashok Prasad"
                  , company = "Director- Danger Men - Firefly Productions"
                  }
                , { quote = [ "“Sebastian is a dedicated and enthusiastic soundman who is capable of handling any sound eventuality.”" ]
                  , name = "Andre Du Plessis"
                  , company = "Abacus Productions"
                  }
                , { quote = [ "“The best soundman, fellow traveller & all round good guy you could wish to meet! Thanks for fantastic work and terrific support.”" ]
                  , name = "Michael Palin"
                  , company = "Brazil with Michael Palin"
                  }
                , { quote = [ "“Sebastian is a huge asset on our shoots. He is such a pleasure to have around and knows a lot about a lot, was super valuable and willing to help in every way – above and beyond the call of duty. I will always REALLY hope for Seb’s availability on every location shoot I have as he was a real professional, a lot of fun and has a really big heart. Thank you Seb!”" ]
                  , name = "Rita Mbanga"
                  , company = "Producer at Sunrise Productions"
                  }
                , { quote =
                        [ "“… Despite the incredibly difficult working conditions in Mali and Egypt your sound recording was brilliant. We so appreciate having someone with your enthusiasm, energy and experience. Your stereo recordings of the big ceremonies have created a sound that makes the viewer feel so present…"
                        , "“Cosmic Africa“ has really benefited in a big way through your dedication to the sound…”"
                        ]
                  , name = "Craig Foster"
                  , company = "Earthrise Productions"
                  }
                ]
            }
      , testimonialNonce = 0
      , testimonialAnimation =
            Animation.style [ Animation.translate (Animation.px 0) (Animation.px 0) ]
      , testimonialTransition = None
      }
    , Cmd.batch
        [ Task.perform (\_ -> ChangeBanner 0) (Process.sleep bannerChangeInterval)
        , Task.perform (\_ -> NextTestimonial 0) (Process.sleep testimonialChangeInterval)
        ]
    )



-- VIEW
-- attribute order: width, height, alignment, border, padding, spacing, events, background, font
-- order by relevance to:
--      siblings (width, height, alignment, border)
--      children (border, padding, spacing)
--      internal details (events, background, font)


view : Model -> Browser.Document Msg
view model =
    let
        content =
            case model.device.class of
                Phone ->
                    column
                        [ width fill
                        , height fill
                        , paddingXY 20 40
                        , spacingMedium
                        ]
                        sectionElements

                Tablet ->
                    column
                        [ width (fill |> maximum 1000)
                        , height fill
                        , centerX
                        , paddingXY 30 50
                        , spacingLarge
                        ]
                        sectionElements

                Desktop ->
                    column
                        [ width (px 1200)
                        , height fill
                        , centerX
                        , paddingXY 20 50
                        , spacingLarge
                        ]
                        sectionElements

                BigDesktop ->
                    column
                        [ width (px 1200)
                        , height fill
                        , centerX
                        , paddingXY 20 50
                        , spacingLarge
                        ]
                        sectionElements

        sectionElements =
            List.map (\section -> section model) sections
    in
    { title = "Dunn Audio"
    , body =
        [ layout [ inFront (navbar model), htmlAttribute (Html.Attributes.id (toID Home)) ]
            (column
                [ width fill
                , height fill
                , moveDown (toFloat navbarHeight)
                , Font.color black
                , Font.letterSpacing 0.5
                , fontNormal
                , fontRaleway
                ]
                [ banner model
                , content
                , footer model
                ]
            )
        ]
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateDevice window ->
            ( { model | window = window, device = classifyDevice window }, Cmd.none )

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
                    , bannerNonce = newNonce
                    , bannerAnimationCurrent =
                        Animation.interrupt
                            [ Animation.toWith bannerInterpolation [ Animation.opacity 1.0 ] ]
                            model.bannerAnimationPrevious
                    , bannerAnimationPrevious =
                        Animation.interrupt
                            [ Animation.toWith bannerInterpolation [ Animation.opacity 0.0 ] ]
                            model.bannerAnimationCurrent
                  }
                , Task.perform (\_ -> ChangeBanner newNonce) (Process.sleep bannerChangeInterval)
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
                                    (Animation.px (toFloat -(testimonialWidth model.window model.device)))
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
                , Task.perform
                    (\_ -> NextTestimonial newNonce)
                    (Process.sleep testimonialChangeInterval)
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
                                    (Animation.px (toFloat -(testimonialWidth model.window model.device)))
                                    (Animation.px 0)
                                ]
                            )
                    , testimonialTransition = Previous
                  }
                , Task.perform
                    (\_ -> NextTestimonial newNonce)
                    (Process.sleep testimonialChangeInterval)
                )

        Animate animationMsg ->
            ( { model
                | bannerAnimationCurrent =
                    Animation.update animationMsg model.bannerAnimationCurrent
                , bannerAnimationPrevious =
                    Animation.update animationMsg model.bannerAnimationPrevious
                , testimonialAnimation =
                    Animation.update animationMsg model.testimonialAnimation
              }
            , Cmd.none
            )

        OnUrlRequest urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , let
                        sectionFragmentParser =
                            UrlParser.fragment
                                (\maybeFragment ->
                                    maybeFragment |> Maybe.withDefault "" |> fromID
                                )

                        maybeSection =
                            UrlParser.parse
                                sectionFragmentParser
                                url
                                |> Maybe.withDefault Nothing

                        goToSection =
                            \section ->
                                Dom.getElement (toID section)
                                    |> Task.andThen
                                        (\element ->
                                            Dom.setViewport
                                                0
                                                (max 0 (element.element.y - toFloat navbarHeight))
                                        )
                                    |> Task.attempt (\_ -> Noop)

                        newUrl =
                            case maybeSection of
                                Just Home ->
                                    { url | fragment = Nothing }

                                Just _ ->
                                    url

                                Nothing ->
                                    url
                      in
                      Cmd.batch
                        [ Navigation.pushUrl model.navKey (Url.toString newUrl)
                        , maybeSection
                            |> Maybe.map goToSection
                            |> Maybe.withDefault Cmd.none
                        ]
                    )

                Browser.External href ->
                    ( model, Navigation.load href )

        OnUrlChange url ->
            ( { model | url = url }, Cmd.none )

        Noop ->
            ( model, Cmd.none )


bannerChangeInterval : Float
bannerChangeInterval =
    5000.0


testimonialChangeInterval : Float
testimonialChangeInterval =
    8000.0


type MenuState
    = Closed
    | Open


type alias Window =
    { width : Int, height : Int }


type alias Nonce =
    Int


type alias Picture =
    { src : String
    , description : String
    }


type alias Testimonial =
    { quote : List String
    , name : String
    , company : String
    }


type TestimonialTransition
    = None
    | Next
    | Previous


type Msg
    = UpdateDevice { width : Int, height : Int }
    | ToggleMenuState
    | ChangeBanner Nonce
    | NextTestimonial Nonce
    | PreviousTestimonial Nonce
    | Animate Animation.Msg
    | OnUrlRequest Browser.UrlRequest
    | OnUrlChange Url.Url
    | Noop


subscriptions : Model -> Sub Msg
subscriptions { bannerAnimationCurrent, bannerAnimationPrevious, testimonialAnimation } =
    Sub.batch
        [ Events.onResize
            (\w h ->
                UpdateDevice
                    { width = w
                    , height = h
                    }
            )
        , Animation.subscription Animate
            [ bannerAnimationCurrent
            , bannerAnimationPrevious
            , testimonialAnimation
            ]
        ]



-- SECTIONS


type Section
    = Home
    | AboutMe
    | Portfolio
    | Testimonials
    | Contact


allSections : List Section
allSections =
    nextSection [] |> List.reverse


nextSection : List Section -> List Section
nextSection lst =
    case lst of
        [] ->
            nextSection (Home :: lst)

        Home :: _ ->
            nextSection (AboutMe :: lst)

        AboutMe :: _ ->
            nextSection (Portfolio :: lst)

        Portfolio :: _ ->
            nextSection (Testimonials :: lst)

        Testimonials :: _ ->
            nextSection (Contact :: lst)

        Contact :: _ ->
            lst


renderSectionLink : List (Attribute msg) -> Section -> Element msg
renderSectionLink extraAttributes section =
    link (linkAttributes ++ extraAttributes)
        { url = UrlBuilder.custom UrlBuilder.Relative [] [] (Just (toID section))
        , label = text (toString section)
        }


linkAttributes : List (Attribute msg)
linkAttributes =
    [ width fill, Font.center ]


toString : Section -> String
toString section =
    case section of
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


toID : Section -> String
toID section =
    case section of
        Home ->
            "home"

        AboutMe ->
            "about-me"

        Portfolio ->
            "portfolio"

        Testimonials ->
            "testimonials"

        Contact ->
            "contact"


fromID : String -> Maybe Section
fromID str =
    allSections
        |> List.map (\section -> ( section, toID section ))
        |> List.filter (\( _, id ) -> id == str)
        |> List.head
        |> Maybe.map Tuple.first


sections :
    List
        ({ b
            | device : Device
            , window : Window
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
    , testimonialsSection
    , contact
    , socials
    ]


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

        image1 =
            image
                [ width fill, height fill ]
                { src = "images/cheetah.webp"
                , description = "Sebastian wearing sound equipment and standing next to a cheetah"
                }

        image2 =
            image
                [ width fill, height fill ]
                { src = "images/hadza.webp"
                , description = "Sebastian recording members of the Hadza community in Tanzania"
                }

        desktop =
            row
                [ width fill
                , spacingSmall
                , htmlAttribute (Html.Attributes.id (toID AboutMe))
                ]
                [ column [ width (fillPortion 1), alignTop, spacingMedium, Font.center ]
                    [ el [ centerX, Font.bold, fontHeading ] (text (toString AboutMe))
                    , paragraph1
                    , paragraph2
                    , paragraph3
                    , paragraph4
                    ]
                , column [ width (fillPortion 1), height fill, alignTop, spacingSmall ]
                    [ el [ width fill, height (fillPortion 1), clip ] image1
                    , el [ width fill, height (fillPortion 1), clip ] image2
                    ]
                ]
    in
    case device.class of
        Phone ->
            column
                [ width fill
                , spacingSmall
                , Font.center
                , htmlAttribute (Html.Attributes.id (toID AboutMe))
                ]
                [ el [ centerX, Font.bold, fontLarge ] (text (toString AboutMe))
                , paragraph1
                , el [ width fill ] image1
                , paragraph2
                , paragraph3
                , el [ width fill ] image2
                , paragraph4
                ]

        Tablet ->
            column
                [ width fill
                , spacingSmall
                , Font.center
                , htmlAttribute (Html.Attributes.id (toID AboutMe))
                ]
                [ el [ centerX, Font.bold, fontHeading ] (text (toString AboutMe))
                , paragraph1
                , el [ width fill ] image1
                , paragraph2
                , paragraph3
                , el [ width fill ] image2
                , paragraph4
                ]

        Desktop ->
            desktop

        BigDesktop ->
            desktop


whatIDo : { model | device : Device } -> Element Msg
whatIDo { device } =
    let
        paragraph1 =
            paragraph [ spacingParagraph ] [ text "I spend a lot of my time on documentary productions, although I still work in other arenas. This has taken me all over the world, working for the major broadcasting channels in over 30 countries and exploring a diverse range of subjects." ]

        paragraph2 =
            paragraph [ spacingParagraph ] [ text "I also now specialise in recording ‘The sounds of Africa’ having been commissioned by several top international production companies to record animals and general ambiences of Africa." ]

        paragraph3 =
            paragraph [ spacingParagraph ] [ text "My favourite ‘go-to’ is an Ambisonic Microphone that captures immersive surround sounds of the environments I’m recording in - an important tool in the sound design process of most productions." ]

        image1 =
            image
                [ width fill, height fill ]
                { src = "images/ambisonic-gorongosa.webp"
                , description = "Sebastian recording ambisonic sound on top of a car in Gorongosa National Park in Mozambique"
                }

        image2 =
            image
                [ width fill, height fill ]
                { src = "images/wauja-palin.webp"
                , description = "Sebastian standing with a member of the Wauja community in the Amazon"
                }

        image3 =
            image
                [ width fill, height fill ]
                { src = "images/cape-town.webp"
                , description = "Sebastian recording sound in front of Cape Town city hall during lockdown"
                }

        desktop =
            column [ width fill, spacingMedium ]
                [ row [ width fill, spacingSmall ]
                    [ el [ width (fillPortion 2), clip ] image1
                    , column [ width (fillPortion 5), alignTop, spacingMedium, Font.center ]
                        [ el [ centerX, alignTop, Font.bold, fontHeading ] (text "What I Do Now")
                        , paragraph1
                        , paragraph2
                        , paragraph3
                        ]
                    ]
                , row [ width fill, height (px 360), spacingSmall ]
                    [ el [ width (fillPortion 1), height fill, alignTop, clip ] image2
                    , el [ width (fillPortion 1), height fill, alignTop, clip ] image3
                    ]
                ]
    in
    case device.class of
        Phone ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX, Font.bold, fontLarge ] (text "What I Do Now")
                , paragraph1
                , paragraph2
                , el [ width fill ] image1
                , el [ width fill ] image2
                , paragraph3
                , el [ width fill ] image3
                ]

        Tablet ->
            column [ width fill, spacingSmall, Font.center ]
                [ el [ centerX, Font.bold, fontHeading ] (text "What I Do Now")
                , paragraph1
                , paragraph2
                , el [ width fill ] image1
                , el [ width fill ] image2
                , paragraph3
                , el [ width fill ] image3
                ]

        Desktop ->
            desktop

        BigDesktop ->
            desktop


achievements : { a | device : Device } -> Element msg
achievements { device } =
    let
        emmy attributes =
            column (awardStyle ++ attributes)
                [ paragraph [] [ text "News and Documentary Emmy Awards nominee" ]
                , paragraph [] [ text "2023" ]
                , paragraph [] [ text "Outstanding Sound for 'Our Universe'" ]
                ]

        innovation attributes =
            column (awardStyle ++ attributes)
                [ paragraph [] [ text "Innovation in Business Award Winner" ]
                , paragraph [] [ text "2023" ]
                , paragraph [] [ text "Most Trusted Sound Recordist" ]
                ]

        jackson attributes =
            column (awardStyle ++ attributes)
                [ paragraph [] [ text "Jackson Wild Media Awards nominee" ]
                , paragraph [] [ text "2015" ]
                , paragraph [] [ text "Best Sound for 'Gorongosa Park: Rebirth of Paradise'" ]
                ]

        bafta attributes =
            column (awardStyle ++ attributes)
                [ paragraph [] [ text "BAFTA Craft Awards nominee" ]
                , paragraph [] [ text "2013" ]
                , paragraph [] [ text "Best Sound for 'Brazil with Michael Palin'" ]
                ]

        awardStyle =
            [ padding 20
            , centerX
            , Border.color orange
            , Border.rounded 10
            , Border.width 1
            , Font.bold
            , Font.center
            ]

        desktop =
            column [ width fill, spacingMedium ]
                [ el [ centerX, Font.bold, fontHeading ] (text "Achievements")
                , row [ width fill, spacingMedium ]
                    [ emmy [ width (px 450), fontLarge ]
                    , innovation [ width (px 450), fontLarge ]
                    ]
                , row [ width fill, spacingMedium ]
                    [ jackson [ width (px 450), fontLarge ]
                    , bafta [ width (px 450), fontLarge ]
                    ]
                ]
    in
    case device.class of
        Phone ->
            column [ width fill, spacingSmall ]
                [ el [ centerX, Font.bold, fontLarge ] (text "Achievements")
                , column [ width fill, spacingSmall ]
                    [ emmy [ width (fill |> maximum 380), fontNormal ]
                    , innovation [ width (fill |> maximum 380), fontNormal ]
                    , jackson [ width (fill |> maximum 380), fontNormal ]
                    , bafta [ width (fill |> maximum 380), fontNormal ]
                    ]
                ]

        Tablet ->
            column [ width fill, spacingSmall ]
                [ el [ centerX, Font.bold, fontHeading ] (text "Achievements")
                , wrappedRow [ spacingSmall ]
                    [ el [ width fill ] (emmy [ width (px 380), fontNormal ])
                    , el [ width fill ] (innovation [ width (px 380), fontNormal ])
                    , el [ width fill ] (jackson [ width (px 380), fontNormal ])
                    , el [ width fill ] (bafta [ width (px 380), fontNormal ])
                    ]
                ]

        Desktop ->
            desktop

        BigDesktop ->
            desktop


portfolio : { a | device : Device } -> Element msg
portfolio { device } =
    let
        videos =
            [ youtubeVideo { src = "https://www.youtube.com/embed/Q33TkQKlIMg?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&widgetid=1" }
            , youtubeVideo { src = "https://www.youtube.com/embed/q1UcC7BsI1M?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&widgetid=3" }
            , youtubeVideo { src = "https://www.youtube.com/embed/Vg93ijoQeJ8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&widgetid=5" }
            , youtubeVideo { src = "https://www.youtube.com/embed/vTA6EX-0Xr8?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&widgetid=7" }
            , youtubeVideo { src = "https://www.youtube.com/embed/X1_Y12auEgk?controls=1&rel=0&playsinline=0&modestbranding=0&autoplay=0&enablejsapi=1&widgetid=9" }
            , vimeoVideo { src = "https://player.vimeo.com/video/168173513?color&autopause=0&loop=0&muted=0&title=1&portrait=1&byline=1#t=" }
            ]

        logos logoWidth =
            [ clientLogo { description = "Survivor", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-45.png", logoWidth = logoWidth }
            , clientLogo { description = "HBO", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-22.jpg", logoWidth = logoWidth }
            , clientLogo { description = "Netflix", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-32.jpg", logoWidth = logoWidth }
            , clientLogo { description = "Apple TV", src = "https://dunnaudio.com/wp-content/uploads/2023/06/apple-tv__e7aqjl2rqzau_og.png", logoWidth = logoWidth }
            , clientLogo { description = "BBC", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-12.jpg", logoWidth = logoWidth }
            , clientLogo { description = "National Geographic", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-31.jpg", logoWidth = logoWidth }
            , clientLogo { description = "Animal Planet", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-4.jpg", logoWidth = logoWidth }
            , clientLogo { description = "Discovery Channel", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-19.jpg", logoWidth = logoWidth }
            , clientLogo { description = "PBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-34.jpg", logoWidth = logoWidth }
            , clientLogo { description = "History", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-25.jpg", logoWidth = logoWidth }
            , clientLogo { description = "CBS", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-14.jpg", logoWidth = logoWidth }
            , clientLogo { description = "abc primetime", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-2.jpg", logoWidth = logoWidth }
            , clientLogo { description = "Sky 1", src = "https://dunnaudio.com/wp-content/uploads/2022/09/broadcast-41.gif", logoWidth = logoWidth }
            ]

        desktop =
            column
                [ width fill
                , spacingMedium
                , htmlAttribute (Html.Attributes.id (toID Portfolio))
                ]
                ([ el [ centerX, Font.bold, fontHeading ] (text (toString Portfolio))
                 , column [ width fill, spacingSmall ]
                    (List.map (\sublist -> row [ centerX, spacingSmall ] sublist)
                        (sublistsOf 3 videos)
                    )
                 ]
                    ++ List.map (\sublist -> row [ width fill, spacingSmall ] sublist)
                        (sublistsOf 4 (logos 180))
                )
    in
    case device.class of
        Phone ->
            column
                [ width fill
                , spacingSmall
                , Font.center
                , htmlAttribute (Html.Attributes.id (toID Portfolio))
                ]
                [ el [ centerX, Font.bold, fontLarge ] (text (toString Portfolio))
                , column [ width fill, centerX, spacingSmall ] videos
                , wrappedRow [ width fill, spacingSmall ] (logos 120)
                ]

        Tablet ->
            column
                [ width fill
                , spacingSmall
                , Font.center
                , htmlAttribute (Html.Attributes.id (toID Portfolio))
                ]
                [ el [ centerX, Font.bold, fontHeading ] (text (toString Portfolio))
                , wrappedRow [ width fill, spacingSmall ] videos
                , wrappedRow [ width fill, spacingSmall ] (logos 120)
                ]

        Desktop ->
            desktop

        BigDesktop ->
            desktop


sublistsOf : Int -> List a -> List (List a)
sublistsOf n lst =
    sublistsOfInner n [] lst


sublistsOfInner : Int -> List (List a) -> List a -> List (List a)
sublistsOfInner n acc lst =
    if List.length lst == 0 then
        List.reverse acc

    else
        sublistsOfInner n (List.take n lst :: acc) (List.drop n lst)


youtubeVideo : { src : String } -> Element msg
youtubeVideo { src } =
    el [ width fill ]
        (el [ width (fill |> maximum 300), centerX, Background.color black ]
            (html
                (Html.iframe
                    [ Html.Attributes.src src
                    , Html.Attributes.attribute "allow" "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                    , Html.Attributes.attribute "allowfullscreen" "1"
                    , Html.Attributes.attribute "frameborder" "0"
                    ]
                    []
                )
            )
        )


vimeoVideo : { src : String } -> Element msg
vimeoVideo { src } =
    el [ width fill ]
        (el [ width (fill |> maximum 300), centerX, Background.color black ]
            (html
                (Html.iframe
                    [ Html.Attributes.src src
                    , Html.Attributes.attribute "frameBorder" "0"
                    , Html.Attributes.attribute "allowfullscreen" ""
                    ]
                    []
                )
            )
        )


clientLogo : { src : String, description : String, logoWidth : Int } -> Element msg
clientLogo { src, description, logoWidth } =
    el [ width fill ]
        (el
            [ width (px logoWidth)
            , centerX
            , Border.color (rgba 1 1 1 0)
            , Border.rounded 5
            , Border.width 0
            , clip
            ]
            (image
                [ width (px logoWidth)
                ]
                { src = src, description = description }
            )
        )


testimonialsSection :
    { a
        | device : Device
        , window : Window
        , testimonials : ZipList Testimonial
        , testimonialNonce : Int
        , testimonialAnimation : Animation.State
        , testimonialTransition : TestimonialTransition
    }
    -> Element Msg
testimonialsSection { device, window, testimonials, testimonialNonce, testimonialAnimation, testimonialTransition } =
    let
        testimonialContent =
            case testimonialTransition of
                None ->
                    [ current ]

                Next ->
                    [ previous, current ]

                Previous ->
                    [ current, next ]

        previousButton =
            el
                [ width (px 20)
                , height (px 20)
                , centerX
                , centerY
                , ElementEvents.onClick (PreviousTestimonial testimonialNonce)
                , Font.color orange
                ]
                (html (Icon.view IconSolid.angleLeft))

        nextButton =
            el
                [ width (px 20)
                , height (px 20)
                , centerX
                , centerY
                , ElementEvents.onClick (NextTestimonial testimonialNonce)
                , Font.color orange
                ]
                (html (Icon.view IconSolid.angleRight))

        contentWidth =
            testimonialWidth window device

        ( headingSize, buttonWidth, carouselHeight ) =
            case device.class of
                Phone ->
                    ( fontLarge, 32, px (310 * 496 // contentWidth) )

                Tablet ->
                    ( fontHeading, 64, px (240 * 812 // contentWidth) )

                Desktop ->
                    ( fontHeading, 96, px 300 )

                BigDesktop ->
                    ( fontHeading, 96, px 300 )

        dots =
            row [ centerX, spacing 5 ]
                (List.concat
                    [ testimonials.beforeReversed |> List.map (\_ -> dot grey)
                    , [ dot orange ]
                    , testimonials.after |> List.map (\_ -> dot grey)
                    ]
                )

        previous =
            contentTemplate (getPrevious testimonials)

        current =
            contentTemplate testimonials.current

        next =
            contentTemplate (getNext testimonials)

        contentTemplate testimonial =
            column
                ([ width (px contentWidth)
                 , height fill
                 , centerY
                 , Font.center
                 , Font.letterSpacing 0.3
                 , Font.light
                 , fontNormal
                 ]
                    ++ List.map Element.htmlAttribute (Animation.render testimonialAnimation)
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
    in
    column
        [ width fill
        , spacingSmall
        , htmlAttribute (Html.Attributes.id (toID Testimonials))
        ]
        [ el [ centerX, Font.bold, headingSize ] (text (toString Testimonials))
        , row [ width fill, height carouselHeight ]
            [ el [ width (px buttonWidth), height fill ] previousButton
            , row [ width (px contentWidth), height fill, clip ] testimonialContent
            , el [ width (px buttonWidth), height fill ] nextButton
            ]
        , dots
        ]


testimonialWidth : Window -> Device -> Int
testimonialWidth { width } { class } =
    case class of
        Phone ->
            -- less 20 for padding and 32 for scroll buttons each side = (20+32)*2 = 104
            width - 104

        Tablet ->
            -- less 30 for padding and 64 for scroll buttons each side = (30+64)*2 = 188
            (width - 188) |> min (1000 - 188)

        Desktop ->
            968

        BigDesktop ->
            968


dot : Color -> Element msg
dot color =
    el [ width (px 16), height (px 16), Border.rounded 8, Background.color color ] none


contact : { a | device : Device } -> Element msg
contact { device } =
    let
        contactWithFont font =
            column
                [ width fill
                , spacingSmall
                , Font.center
                , htmlAttribute (Html.Attributes.id (toID Contact))
                ]
                [ el [ centerX, Font.bold, font ] (text "Let's Chat!")
                , emailContact
                ]

        emailContact =
            paragraph []
                [ text "Email: "
                , link []
                    { url = "mailto:seb@dunnaudio.com"
                    , label = el [ Font.underline ] (text "seb@dunnaudio.com")
                    }
                ]
    in
    case device.class of
        Phone ->
            contactWithFont fontLarge

        Tablet ->
            contactWithFont fontHeading

        Desktop ->
            contactWithFont fontHeading

        BigDesktop ->
            contactWithFont fontHeading


socials : { a | device : Device } -> Element msg
socials { device } =
    let
        socialsWithAttributes spacing rowPadding rowSpacing =
            column [ width fill, spacing, Font.center ]
                [ paragraph [] [ text "Follow me on my socials!" ]
                , wrappedRow [ width fill, rowPadding, rowSpacing ] socialLinks
                ]

        socialLinks =
            [ socialLink "https://www.facebook.com/dunnaudio" IconBrands.facebook
            , socialLink "https://www.instagram.com/sebdunnaudio" IconBrands.instagram
            , socialLink "https://twitter.com/sebdunnaudio" IconBrands.twitter
            , socialLink "https://www.linkedin.com/in/dunnaudio" IconBrands.linkedin
            , socialLink "https://www.imdb.com/name/nm2271521" IconBrands.imdb
            , socialLink "https://soundcloud.com/user-716251106" IconBrands.soundcloud
            ]

        socialLink url icon =
            newTabLink [ width fill ]
                { url = url
                , label = el [ width (px 45), height (px 45) ] (html (Icon.view icon))
                }
    in
    case device.class of
        Phone ->
            socialsWithAttributes spacingSmall (paddingXY 30 0) (spacing 30)

        Tablet ->
            socialsWithAttributes spacingSmall (paddingXY 30 0) (spacing 30)

        Desktop ->
            socialsWithAttributes spacingMedium (paddingXY 50 0) (spacing 150)

        BigDesktop ->
            socialsWithAttributes spacingMedium (paddingXY 50 0) (spacing 150)



-- ELEMENTS
-- NAVBAR


navbar : { a | menuState : MenuState, device : Device } -> Element Msg
navbar { menuState, device } =
    let
        menuButton =
            el
                [ width (px 30)
                , alignRight
                , centerY
                , ElementEvents.onClick ToggleMenuState
                ]
                (html (Icon.view IconSolid.bars))

        desktop =
            row
                [ width fill
                , Background.color white
                ]
                [ row [ width (px 1200), height (px navbarHeight), centerX, paddingXY 20 30 ]
                    [ logo
                    , row [ alignRight, spacingMedium, fontNormal, Font.light ]
                        [ renderSectionLink [] Home
                        , renderSectionLink [] AboutMe
                        , renderSectionLink [] Portfolio
                        , renderSectionLink [] Testimonials
                        , renderSectionLink [] Contact
                        , newTabLink linkAttributes
                            { url = "https://drive.google.com/file/d/1D1gBuv_USqMETY4iYZa9QUp_OW1QwVM3/view"
                            , label = text "My CV"
                            }
                        ]
                    ]
                ]
    in
    case device.class of
        Phone ->
            row
                ([ width fill
                 , height (px navbarHeight)
                 , padding 20
                 , Background.color white
                 ]
                    ++ dropdown menuState
                )
                [ logo
                , menuButton
                ]

        Tablet ->
            row
                ([ width fill
                 , height (px navbarHeight)
                 , padding 30
                 , Background.color white
                 ]
                    ++ dropdown menuState
                )
                [ logo
                , menuButton
                ]

        Desktop ->
            desktop

        BigDesktop ->
            desktop


navbarHeight : Int
navbarHeight =
    133


logo : Element msg
logo =
    image [ width (px 240), alignLeft ]
        { src = "images/logo2.webp", description = "Dunn Audio" }


dropdown : MenuState -> List (Attribute Msg)
dropdown menuState =
    if menuState == Closed then
        []

    else
        [ below
            (row [ width fill, Background.color white ]
                [ el [ width (fillPortion 1) ] none
                , column [ width (fillPortion 8), padding 20, spacingSmall, Font.light ]
                    (List.intersperse dropdownSeparator
                        (List.map (renderSectionLink [ ElementEvents.onClick ToggleMenuState ]) allSections
                            ++ [ el [ width fill, ElementEvents.onClick ToggleMenuState, Font.center ] (text "My CV") ]
                        )
                    )
                , el [ width (fillPortion 1) ] none
                ]
            )
        ]


dropdownSeparator : Element msg
dropdownSeparator =
    el
        [ width (px 200)
        , height (px 0)
        , centerX
        , Border.widthEach
            { top = 1
            , bottom = 0
            , left = 0
            , right = 0
            }
        , Border.color orange
        ]
        none



-- BANNER


banner :
    { a
        | window : Window
        , bannerPictures : ZipList Picture
        , bannerAnimationCurrent :
            Animation.State
        , bannerAnimationPrevious :
            Animation.State
    }
    -> Element msg
banner { window, bannerPictures, bannerAnimationCurrent, bannerAnimationPrevious } =
    let
        bannerHeight =
            window.width
                |> toFloat
                |> (\x -> x * 8 / 16)

        bannerHeightPx =
            bannerHeight
                |> round
                |> px

        previousImage =
            image
                ([ width fill
                 , height bannerHeightPx
                 , moveUp bannerHeight
                 ]
                    ++ List.map htmlAttribute (Animation.render bannerAnimationPrevious)
                )
                (getPrevious bannerPictures)
    in
    column [ width fill, height bannerHeightPx ]
        [ image
            ([ width fill
             , height bannerHeightPx
             ]
                ++ List.map htmlAttribute (Animation.render bannerAnimationCurrent)
            )
            bannerPictures.current
        , previousImage
        ]



-- FOOTER


footer : { a | device : Device } -> Element msg
footer { device } =
    let
        footerWithAttributes padding spacing fontSize =
            column
                [ width fill
                , padding
                , spacing
                , Background.color black
                , Font.center
                , Font.color white
                , Font.light
                , fontSize
                ]
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
    in
    case device.class of
        Phone ->
            footerWithAttributes (padding 20) (spacing 10) fontSmall

        Tablet ->
            footerWithAttributes (padding 30) (spacing 10) fontSmall

        Desktop ->
            footerWithAttributes (padding 30) (spacing 10) fontNormal

        BigDesktop ->
            footerWithAttributes (padding 30) (spacing 10) fontNormal



-- STYLE


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
    rgb255 255 255 255
