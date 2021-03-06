port module MessageModule exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Aliases exposing (..)


init : ( Message, Cmd Msg )
init =
    ( initMessage, Cmd.none )


type Msg
    = Show Message
    | Hide


update : Msg -> Message -> ( Message, Cmd Msg )
update msg model =
    case msg of
        Show message ->
            ( { model | messageClass = message.messageClass, header = message.header, text = message.text, active = True }
            , Cmd.none
            )

        Hide ->
            ( { model | active = False }
            , Cmd.none
            )


view : Message -> Html Msg
view model =
    let
        class_ =
            "ui message " ++ model.messageClass

        render =
            if model.active == False then
                div [] []
            else
                div [ class class_ ]
                    [ i [ class "close icon", onClick Hide ] []
                    , div [ class "header" ] [ text model.header ]
                    , p [] [ text model.text ]
                    ]
    in
        render


port portMessage : (Message -> msg) -> Sub msg


subscriptions : Message -> Sub Msg
subscriptions model =
    Sub.batch
        [ portMessage Show
        ]
