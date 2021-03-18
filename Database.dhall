let R = ./Resource.dhall

let Opt = ./Opt.dhall

let O = ./Object.dhall

let Database =
      { name : Text
      , transient : Bool
      , retention : Natural
      , comment : Optional Text
      }

let default = { transient = False, retention = 1, comment = None Text }

let asResource =
      λ(x : Database) →
        let type =
                  (if x.transient then "TRANSIENT " else "")
              ++  O.AccObjType/show O.AccObjType.Database

        in  R::{
            , name = x.name
            , type
            , opts = [ Opt.makeN "DATA_RETENTION_TIME_IN_DAYS" x.retention ]
            , comment = x.comment
            }

let toDDL = λ(x : Database) → R.toDDL (asResource x)

in  { Type = Database, default, asResource, toDDL }
