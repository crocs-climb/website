module Ui.App exposing (header, footer, appShell)

import Config as Cfg
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Ev
import Svg as S
import Svg.Attributes as SA
import Ui.Components as Ui


appShell : Html msg -> Html msg
appShell content =
    div 
        [ class "bg-base w-100"
        , attribute "data-theme" "lemonade" 
        ] 
        [ header
        , main_ [style "margin-bottom" "4rem"] [ content ]
        , footer 
        ]


header : Html msg
header =
    let
        svgMenu =
            S.svg
                [ SA.fill "none"
                , SA.viewBox "0 0 24 24"
                , SA.class "inline-block w-5 h-5 stroke-current"
                ]
                [ S.path
                    [ SA.strokeLinecap "round"
                    , SA.strokeLinejoin "round"
                    , SA.strokeWidth "2"
                    , SA.d "M4 6h16M4 12h16M4 18h16"
                    ]
                    []
                ]

        svgDots =
            S.svg
                [ SA.fill "none"
                , SA.viewBox "0 0 24 24"
                , SA.class "inline-block w-5 h-5 stroke-current"
                ]
                [ S.path
                    [ SA.strokeLinecap "round"
                    , SA.strokeLinejoin "round"
                    , SA.strokeWidth "2"
                    , SA.d "M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"
                    ]
                    []
                ]
    in
    div
        [ class "navbar shadow-lg"
        ]
        [ div
            [ class "flex-none"
            ]
            [ button
                [ class "btn btn-square btn-ghost"
                ]
                [ svgMenu
                ]
            ]
        , div
            [ class "flex-1"
            ]
            [ a
                [ class "btn btn-ghost normal-case text-xl"
                ]
                [ text "CROCS" ]
            ]
        , div
            [ class "flex-none"
            ]
            [ button
                [ class "btn btn-square btn-ghost"
                ]
                [ svgDots
                ]
            ]
        ]


footer : Html msg
footer =
    let
        btn icon txt =
            button [ class "btn m-1" ] [ text txt ]

        svgHome =
            S.svg
                [ SA.class "h-5 w-5"
                , SA.fill "none"
                , SA.viewBox "0 0 24 24"
                , SA.stroke "currentColor"
                ]
                [ S.path
                    [ SA.strokeLinecap "round"
                    , SA.strokeLinejoin "round"
                    , SA.strokeWidth "2"
                    , SA.d "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
                    ]
                    []
                ]

        svgInfo =
            S.svg
                [ SA.class "h-5 w-5"
                , SA.fill "none"
                , SA.viewBox "0 0 24 24"
                , SA.stroke "currentColor"
                ]
                [ S.path
                    [ SA.strokeLinecap "round"
                    , SA.strokeLinejoin "round"
                    , SA.strokeWidth "2"
                    , SA.d "M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                    ]
                    []
                ]

        svgStats =
            S.svg
                [ SA.class "h-5 w-5"
                , SA.fill "none"
                , SA.viewBox "0 0 24 24"
                , SA.stroke "currentColor"
                ]
                [ S.path
                    [ SA.strokeLinecap "round"
                    , SA.strokeLinejoin "round"
                    , SA.strokeWidth "2"
                    , SA.d "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                    ]
                    []
                ]
    in
    div
        [ class "btm-nav shadow-lg"
        ]
        [ button [] [ svgHome ]
        , button [ class "active" ]
            [ svgInfo
            ]
        , button []
            [ svgStats
            ]
        ]
