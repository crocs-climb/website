module Pages.Boulder exposing (Model, Msg, init, update, view)

import Config as Cfg
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Ev
import Ui.Components as Ui



type Model
    = NotImpl


type Msg
    = NoOp


view : Model -> Html msg
view m =
    div []
        [ h1 [] [ text "Pedra do Belchior" ]
        , dl []
            [ dt [] [ text "Cadastrada por:" ]
            , dd [] [ text "Matheus Martins, em 15-04-2019" ]
            , dt [] [ text "Descrição:" ]
            , dd [] [ text "Pedreira de calcário, predominantemente vertical, escalada técnica, aproximadamente 200 vias (Esportivas, mistas e móvel)" ]
            , dt [] [ text "Como chegar à base:" ]
            , dd [] [ text "O estacionamento é feito em uma casa, atravessar uma plantação, passar uma pinguela de madeira. Depois vai depender do setor que você deseja ir." ]
            , dt [] [ text "Coordenadas:" ]
            , dd [] [ text "15.130396887678653,-47.756660943702855" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    ( m, Cmd.none )


init : Cfg.Model -> String -> Model
init cfg ref =
    NotImpl
