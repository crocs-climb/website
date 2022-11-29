module Main exposing (main)

import Browser
import Browser.Navigation as Nav exposing (Key)
import Config as Cfg
import Dict
import Html exposing (Html, div, text)
import Http
import Json.Decode as D
import Json.Encode exposing (Value)
import Pages.Boulder as Boulder
import Pages.Home as Home
import Pages.Parking as Parking
import Pages.Route as Route
import Pages.Sector as Sector
import Routes exposing (Route(..), parseUrl, toHref)
import Url exposing (Url)
import Util exposing (dbg, dbg1)


type alias Slug =
    String


type alias Loc =
    String


type alias RefPath =
    List String


type Page
    = HomePage Home.Model
    | SectorPage Sector.Model
    | RoutePage Route.Model
    | BoulderPage Boulder.Model
    | ParkingPage Parking.Model
    | ErrorPage Loc
    | ProfilePage Slug


type alias Model =
    { page : Page
    , cfg : Cfg.Model
    }


type Msg
    = OnPushUrl String
    | OnUrlChange Url
    | OnUrlRequest Browser.UrlRequest
    | OnConfigMsg Cfg.Msg
    | OnHomeMsg Home.Msg
    | OnRouteMsg Route.Msg
    | OnSectorMsg Sector.Msg
    | OnBoulderMsg Boulder.Msg
    | OnParkingMsg Parking.Msg
    | NoOp


pageFromRoute : Route -> Cfg.Model -> (Model, Cmd Msg)
pageFromRoute r cfg =
    let
        join =
            String.join "/"

        page wrap msg (m, cmd) = 
            ( { page = wrap m, cfg = cfg }, Cmd.map msg cmd ) 


    in
    case r of
        -- Home ->
        --     HomePage (Home.init cfg)

        -- Error url ->
        --     ErrorPage url

        -- Route ref ->
        --     RoutePage (Route.init cfg (join ref))

        Sector ref ->
            page SectorPage OnSectorMsg (Sector.init (join ref))

        _ ->
            ({ page = ErrorPage "not implemented", cfg =cfg }, Cmd.none)


init : Cfg.Model -> Model
init cfg =
    { page = HomePage (Home.init cfg), cfg = cfg }


view : Model -> Html Msg
view model =
    case model.page of
        HomePage m ->
            Html.map OnHomeMsg (Home.view m)

        RoutePage m ->
            Html.map OnRouteMsg (Route.view m)

        SectorPage m ->
            Html.map OnSectorMsg (Sector.view model.cfg m)

        BoulderPage m ->
            Html.map OnBoulderMsg (Boulder.view m)

        ParkingPage m ->
            Html.map OnParkingMsg (Parking.view m)

        ErrorPage st ->
            div [] [ text ("error :" ++ st) ]

        _ ->
            div [] [ text "NOT IMPLEMENTED" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg_ m_ =
    let
        aux =
            dbg "msg" msg_

        cfg =
            m_.cfg

        page m1 p m2 cmd =
            ( { m_ | page = m1 p }, Cmd.map m2 cmd )
    in
    case ( msg_, m_.page ) of
        -- Routing and generic navigation
        ( OnPushUrl st, _ ) ->
            ( m_, Cfg.pushUrl st cfg )

        ( OnUrlRequest (Browser.Internal url), _ ) ->
            update (OnPushUrl (Url.toString url)) m_

        ( OnUrlRequest (Browser.External url), _ ) ->
            ( m_, Nav.load url )

        ( OnUrlChange url, _ ) ->
            pageFromRoute (parseUrl url) cfg

        -- Redirect to appropriate sub-model
        ( OnHomeMsg msg, HomePage m ) ->
            let
                ( new, cmd ) =
                    Home.update msg m
            in
            page HomePage new OnHomeMsg cmd

        ( OnRouteMsg msg, RoutePage m ) ->
            let
                ( new, cmd ) =
                    Route.update msg m
            in
            page RoutePage new OnRouteMsg cmd

        ( OnBoulderMsg msg, BoulderPage m ) ->
            let
                ( new, cmd ) =
                    Boulder.update msg m
            in
            page BoulderPage new OnBoulderMsg cmd

        ( OnSectorMsg msg, SectorPage m ) ->
            let
                ( new, cmd ) =
                    Sector.update msg cfg m
            in
            page SectorPage new OnSectorMsg cmd

        -- Internal state and other global tasks
        ( OnConfigMsg msg, _ ) ->
            let
                ( cfg_, cmd ) =
                    Cfg.update msg cfg
            in
            ( { m_ | cfg = cfg_ }, Cmd.map OnConfigMsg cmd )

        _ ->
            ( m_, Cmd.none )


main : Program Value Model Msg
main =
    let
        -- fetchStories =
        --     Http.get
        --         { url = "./static/data.json"
        --         , expect = Http.expectJson OnFetchStories (D.list storyDecoder)
        --         }
        initFn flags url key =
            let
                ( m, cmd ) =
                    init (Cfg.init key)
                        |> update (OnUrlChange url)
            in
            ( m, Cmd.batch [ cmd ] )
    in
    Browser.application
        { init = initFn
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChange
        , view = \m -> Browser.Document "CROCS" [ view m ]
        }
