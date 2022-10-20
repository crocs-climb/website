module Ui exposing
    ( appLayout
    , fab
    , icon
    , styleElements
    , youtubeIframe
    )

-- import Css exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Json.Encode
import Model exposing (..)
import Update exposing (Msg(..))



--- LAYOUT ELEMENTS ------------------------------------------------------------


appLayout : Url -> Bool -> Quote -> Html Msg -> Html Msg
appLayout url linkInit (Quote quote from) child =
    let
        quoteDiv =
            div [ class "Quote" ]
                [ blockquote (attrsFromQuote quote) [ span [] [ text quote ] ]
                , Html.cite [] [ text from ]
                ]

        contentDiv =
            div [ class "MainContent" ] [ child ]

        children =
            if linkInit then
                [ quoteDiv
                , contentDiv
                , div [ class "InitLink" ]
                    [ a
                        [ onClick Restart, href "#" ]
                        [ i [class "fas fa-chevron-left"] [], text " início" ]
                    ]
                ]

            else
                [ quoteDiv, contentDiv ]
    in
    div
        [ class "App", style "background-image" (asUrl url) ]
        children


asUrl st =
    "url(\"" ++ st ++ "\")"


attrsFromQuote : String -> List (Attribute msg)
attrsFromQuote st =
    let
        clean =
            String.join " " <| String.words st

        n =
            String.length clean
    in
    if n > 200 then
        [ style "font-size" "0.85em" ]

    else if n > 150 then
        [ style "font-size" "0.95em" ]

    else if n > 125 then
        [ style "font-size" "1.05em" ]

    else
        []



--- PAGE ITEMS -----------------------------------------------------------------

youtubeIframe : String -> Url -> Html msg
youtubeIframe cls url =
    iframe
        [ width 500
        , height 375
        , attribute "max-width" "100%"
        , class cls
        , src url
        , property "frameborder" (Json.Encode.string "0")
        , property "allowfullscreen" (Json.Encode.string "true")
        , property "allow" (Json.Encode.string "autoplay; encrypted-media")
        , attribute "allowfullscreen" "true"
        ]
        []



--- ATOMIC ELEMENTS ------------------------------------------------------------


highlight : List (Html msg) -> Html msg
highlight children =
    span [] children


icon : String -> Html msg
icon which =
    i [ class which ] []


fab : msg -> String -> Html msg
fab msg cls =
    button [ onClick msg, class "FabButton" ] [ icon cls ]



--- RESOURCES -----------------------------------------------------------------





styleElements : List (Html msg)
styleElements =
    let 
        styleSheet url =
            node "link" [ attribute "rel" "stylesheet", href url ] []
    in
        [ styleSheet "https://fonts.googleapis.com/css?family=Roboto+Slab|Roboto+Mono"
        , styleSheet "https://use.fontawesome.com/releases/v5.4.1/css/all.css"
        , styleSheet "https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.0/normalize.css"
        , styleSheet "/static/main.css"
        ]