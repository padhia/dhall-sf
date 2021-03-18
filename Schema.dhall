let Schema =
      { database : Text
      , name : Text
      , managed : Bool
      , transient : Bool
      , retention : Natural
      , comment : Optional Text
      }

let default =
      { managed = True, transient = False, retention = 10, comment = None Text }

in  { Type = Schema, default }
