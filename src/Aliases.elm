module Aliases exposing (..)


type alias Message =
    { messageClass : String
    , header : String
    , text : String
    , active : Bool
    }


initMessage : Message
initMessage =
    { messageClass = ""
    , header = ""
    , text = ""
    , active = False
    }


errorMessage : String -> Message
errorMessage text =
    { initMessage
        | messageClass = "negative"
        , header = "Error"
        , text = text
        , active = True
    }


successMessage : String -> Message
successMessage text =
    { initMessage
        | messageClass = "positive"
        , header = "Success"
        , text = text
        , active = True
    }


warningMessage : String -> Message
warningMessage text =
    { initMessage
        | messageClass = "warning"
        , header = "Warning"
        , text = text
        , active = True
    }


infoMessage : String -> Message
infoMessage text =
    { initMessage
        | messageClass = "info"
        , header = "Info"
        , text = text
        , active = True
    }
