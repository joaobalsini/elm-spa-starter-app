port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation exposing (Location)
import RouteModule exposing (..)
import MessageModule exposing (..)
import IndexModule
import LoginModule
import Aliases exposing (..)


main : Program Never Model Msg
main =
    Navigation.program locationToMsg
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- model


type alias Model =
    { route : Route
    , lastRoute : Route
    , loginModuleModel : LoginModule.Model
    , indexModuleModel : IndexModule.Model
    , messageModuleMessage : Message
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            locationToRoute location

        ( indexModuleInitModel, indexModuleCmd ) =
            IndexModule.init

        ( loginModuleInitModel, loginModuleCmd ) =
            LoginModule.init

        ( messageModuleInitMessage, messageModuleCmd ) =
            MessageModule.init

        initModel =
            { route = route
            , lastRoute = IndexModuleRoute
            , indexModuleModel = indexModuleInitModel
            , loginModuleModel = loginModuleInitModel
            , messageModuleMessage = messageModuleInitMessage
            }

        cmds =
            Cmd.batch
                [ Cmd.map LoginModuleMsg loginModuleCmd
                , Cmd.map IndexModuleMsg indexModuleCmd
                , Cmd.map MessageModuleMsg messageModuleCmd
                ]
    in
        ( initModel, cmds )



-- this function is triggered whenever the user changes the url


locationToMsg : Navigation.Location -> Msg
locationToMsg location =
    location
        |> locationToRoute
        |> ChangePage



-- update


type Msg
    = Navigate Route
    | ChangePage Route
    | IndexModuleMsg IndexModule.Msg
    | LoginModuleMsg LoginModule.Msg
    | MessageModuleMsg MessageModule.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Navigate is used once a user clicks in a link
        Navigate route ->
            let
                ( model_, msg_ ) =
                    update (ChangePage route) model
            in
                ( model_, Navigation.newUrl <| routeToHash route )

        -- ChangePage is used once a user changes the URL manually
        ChangePage route ->
            let
                lastRoute =
                    model.route
            in
                ( { model | route = route, lastRoute = lastRoute }, Cmd.none )

        IndexModuleMsg msg ->
            let
                ( indexModuleModel, cmd ) =
                    IndexModule.update msg model.indexModuleModel
            in
                ( { model | indexModuleModel = indexModuleModel }
                , Cmd.map IndexModuleMsg cmd
                )

        LoginModuleMsg msg ->
            let
                ( loginModuleModel, cmd, message ) =
                    LoginModule.update msg model.loginModuleModel
            in
                ( { model | loginModuleModel = loginModuleModel, messageModuleMessage = message }
                , Cmd.map LoginModuleMsg cmd
                )

        MessageModuleMsg msg ->
            let
                ( messageModuleMessage, cmd ) =
                    MessageModule.update msg model.messageModuleMessage
            in
                ( { model | messageModuleMessage = messageModuleMessage }
                , Cmd.map MessageModuleMsg cmd
                )


view : Model -> Html Msg
view model =
    let
        -- get the page through the view method of each Module passing the parameters needed and render that page
        page =
            case model.route of
                IndexModuleRoute ->
                    Html.map IndexModuleMsg
                        (IndexModule.view model.indexModuleModel)

                LoginModuleRoute ->
                    Html.map LoginModuleMsg
                        (LoginModule.view model.loginModuleModel)

                NotFoundRoute ->
                    div [ class "main" ]
                        [ h1 []
                            [ text "Page Not Found!" ]
                        ]
    in
        div []
            [ div [ class "ui fixed inverted menu" ] [ pageHeader model ]
            , Html.map MessageModuleMsg (MessageModule.view model.messageModuleMessage)
            , div [ class "ui main text container" ] [ page ]
            ]


pageHeader : Model -> Html Msg
pageHeader model =
    div [ class "ui container" ]
        [ a [ class "item", onClick (Navigate IndexModuleRoute) ] [ text "Index" ]
        , a [ class "item right", onClick (Navigate LoginModuleRoute) ] [ text "Login" ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        loginModuleSub =
            LoginModule.subscriptions model.loginModuleModel

        indexModuleSub =
            IndexModule.subscriptions model.indexModuleModel

        messageModuleSub =
            MessageModule.subscriptions model.messageModuleMessage
    in
        Sub.batch
            [ Sub.map IndexModuleMsg indexModuleSub
            , Sub.map LoginModuleMsg loginModuleSub
            , Sub.map MessageModuleMsg messageModuleSub
            ]
