module Ui.Components exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events as Ev exposing (..)
import Html.Lazy exposing (lazy)
import Json.Encode

import Ui.Color exposing (Color, colorString, fullColor)

----------------------------------------------------------------
---                         TYPES                            ---
----------------------------------------------------------------

type alias CardListItem msg = (String, msg)



----------------------------------------------------------------
---                       COMPONENTS                         ---
----------------------------------------------------------------

{-| A simple button -}
btn attrs body =
    button (attrs ++ []) body



{-| A simple rounded counter with specific color -}
counter : Color -> Int -> Html msg
counter color i = 
    div 
        [ class "h-5 w-5 font-bold text-sm text-center rounded-full shadow-sm" 
        , fullColor color
        ] 
        [ text (String.fromInt i) ]  


{-|
    Renders a list of pairs of (title, msg) as cards.

    Each card triggers the corresponding message onClick events. 
-}
cardList : Color -> List (CardListItem msg) -> Html msg
cardList color items =
    let
        viewItem i (title, event) =
            let 
                cls = colorString color
            in
            button 
                [ Ev.onClick event
                , class "block flex items-center px-4 py-2 h-14 rounded-sm shadow-md"
                , class "text-left text-sm"
                , class ("focus:bg-slate-100 hover:outline-none hover:ring hover:ring-" ++ cls ++ "-focus")
                ] 
                [ counter color (i + 1)
                , span [ class "flex-1 mx-3"] [ text title ]
                ]
    in 
    div [class "grid grid-cols-2 gap-1 mx-4 my-2"] (List.indexedMap viewItem items)


