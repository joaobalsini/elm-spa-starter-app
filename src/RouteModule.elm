module RouteModule exposing (..)

import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), (<?>), top)


type Route
    = IndexModuleRoute
    | LoginModuleRoute
    | NotFoundRoute


routeToHash : Route -> String
routeToHash route =
    case route of
        IndexModuleRoute ->
            "#/"

        LoginModuleRoute ->
            "#/login"

        NotFoundRoute ->
            "#notfound"


matchers : Url.Parser (Route -> a) a
matchers =
    Url.oneOf
        [ Url.map IndexModuleRoute top
        , Url.map LoginModuleRoute (Url.s "login")
        ]


locationToRoute : Location -> Route
locationToRoute location =
    case (Url.parseHash matchers location) of
        Nothing ->
            NotFoundRoute

        Just route ->
            route
