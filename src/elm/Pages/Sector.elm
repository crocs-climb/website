module Pages.Sector exposing (Model, Msg, update, view, init)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Ev
import Http
import Ui.Components as Ui
import Ui.App
import Ui.Color
import Config as Cfg
import Json.Decode as D
import Json.Decode.Pipeline exposing (hardcoded, required)


type alias Sector = (String, String)


type alias Model = 
    { id: String
    , tab: Tab
    , selected: Int -- (-1) if no sector/attraction is selected
    , data: Maybe Data
    }


type alias Data = 
    { sectors: List Sector 
    , attractions: List Attraction
    }


type alias Attraction = 
    { title: String 
    , description: String
    } 


type Tab = Sectors | Attractions


type Msg
    = OnRequestData
    | OnDataReceived (Result Http.Error Data)
    | OnChangeSelected Int
    | OnChangeUrl String
    | OnChangeTab Tab


init : String -> (Model, Cmd Msg)
init url = 
    let
        m = { id = url, data = Nothing, selected = -1, tab = Sectors }
    in (m, httpDataRequest url) 


view : Cfg.Model -> Model -> Html Msg
view cfg m =
    let
        mapUrl = "/img/maps/" ++ m.id ++ ".svg"

        content = 
            case (m.data, m.tab) of
                (Nothing, _) -> div [ class "card m-4 p-4 bg-focus" ] [ text "Carregando..."]
                (Just data, Sectors) -> showSector data.sectors
                (Just data, Attractions) -> showAttractions data.attractions

        showSector sectors = 
            if sectors == [] then
                div [ class "card m-4 p-4 bg-focus" ] [ text "Nenhum setor cadastrado!"]
            else
                Ui.cardList Ui.Color.Primary (List.map (\(a, b) -> (a, OnChangeUrl <| "/todo/" ++ m.id ++ "/" ++ b)) sectors)

        showAttractions attractions = 
            if attractions == [] then
                div [ class "card m-4 p-4 bg-error" ] [ text "Nenhuma atração cadastrada!"]
            else
                Ui.cardList Ui.Color.Secondary (List.map (\a -> (a.title, OnChangeUrl "#")) attractions)

        tab opt other = "tab tab-bordered" ++ if opt == other then " tab-active" else ""                 

    in
    Ui.App.appShell <|
        div []
            [ h1 [ class "font-bold text-2xl m-4" ] [ text "Mapa dos setores" ]
            , img [ src mapUrl, class "block mx-0 object-cover" ] []
            , div [ class "tabs my-4 text-lg font-bold w-100 flex justify-center" ]
                [ a 
                    [ class <| tab Sectors m.tab
                    , Ev.onClick (OnChangeTab Sectors) 
                    , href "#"
                    ] [ text "Setores" ]
                , a 
                    [ class <| tab Attractions m.tab
                    , Ev.onClick (OnChangeTab Attractions) 
                    , href "#"
                    ] [ text "Atrações" ]
                ]
            , content
            ]


update : Msg -> Cfg.Model -> Model -> ( Model, Cmd Msg )
update msg cfg m =
    let
        noOp = Cmd.none
    in 
    case msg of
        OnRequestData -> 
            ( m, httpDataRequest m.id )

        OnDataReceived (Ok data) ->
            ( { m | data = Just data }, noOp )
        
        OnDataReceived (Err e) ->
            ( m, Cfg.pushErrorUrl e cfg )

        OnChangeSelected i -> 
            ( { m | selected = i }, noOp )

        OnChangeUrl url -> 
            ( m, Cfg.pushUrl url cfg )

        OnChangeTab tab -> 
            ( { m | tab = tab }, noOp )


dataDecoder : D.Decoder Data
dataDecoder =
    let 
        pair = D.list D.string 
            |> D.andThen toPair

        toPair lst = 
            case lst of
                [a, b] -> D.succeed (a, b)
                _ -> D.fail "list must have exactly 2 elements"
    in
    D.map2 Data
        (D.field "sectors" (D.list pair))
        (D.field "attractions" (D.list attractionDecoder))


attractionDecoder : D.Decoder Attraction
attractionDecoder = 
    D.map2 Attraction
        (D.field "title" D.string)
        (D.field "description" D.string)


httpDataRequest id = Http.get 
    { url = "/api/" ++ id ++ "/sector-list.json"
    , expect = Http.expectJson OnDataReceived dataDecoder 
    }