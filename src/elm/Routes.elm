module Routes exposing (Route(..), parseUrl, toHref)

import Browser.Navigation as Nav
import Types exposing (..)
import Url exposing (Url)
import Url.Parser as Parser exposing (..)


type Route
    = Home
    | Error Loc
    | Sector RefPath
    | Route RefPath
    | Parking RefPath
    | Profile Slug


paths : Parser (List String -> a) a
paths =
    let
        l1 a =
            [ a ]

        l2 a b =
            [ a, b ]

        l3 a b c =
            [ a, b, c ]

        l4 a b c d =
            [ a, b, c, d ]

        l5 a b c d e =
            [ a, b, c, d, e ]

        l6 a b c d e f =
            [ a, b, c, d, e, f ]

        l7 a b c d e f g =
            [ a, b, c, d, e, f, g ]
    in
    Parser.oneOf
        [ map l7 (string </> string </> string </> string </> string </> string </> string)
        , map l6 (string </> string </> string </> string </> string </> string)
        , map l5 (string </> string </> string </> string </> string)
        , map l4 (string </> string </> string </> string)
        , map l3 (string </> string </> string)
        , map l2 (string </> string)
        , map l1 string
        ]


matchers : Parser (Route -> a) a
matchers =
    Parser.oneOf
        [ map Home top
        , map Sector (s "sectors" </> paths)
        , map Route (s "routes" </> paths)
        , map Parking (s "parking" </> paths)
        , map Profile (s "profiles" </> string)
        ]


parseUrl : Url -> Route
parseUrl url =
    case Parser.parse matchers url of
        Just route ->
            route

        Nothing ->
            Error (Url.toString url)


toHref : Route -> String
toHref route =
    let
        ref =
            String.join "/"
    in
    case route of
        Home ->
            "/"

        Sector pts ->
            "/sectors/" ++ ref pts

        Route pts ->
            "/routes/" ++ ref pts

        Parking pts ->
            "/parking/" ++ ref pts

        Profile slug ->
            "/profiles/" ++ slug

        Error st ->
            "/" ++ st
