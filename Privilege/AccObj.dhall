let O = (../Object.dhall).ObjType

let O/show = (../Object.dhall).ObjType/show

let A = (../Object.dhall).AccObjType

let A/show = (../Object.dhall).AccObjType/show

let P = ./PrivText.dhall

let User =
      let This = { monitor : Bool }

      let default = { monitor = False }

      let toPrivList = λ(u : This) → P.toTextList [ P.new "MONITOR" u.monitor ]

      in  { Type = This, default, toPrivList }

let ResourceMonitor =
      let This = { modify : Bool, monitor : Bool }

      let default = { modify = False, monitor = False }

      let toPrivList =
            λ(x : This) →
              P.toTextList
                [ P.new "MODIFY" x.modify, P.new "MONITOR" x.monitor ]

      in  { Type = This, default, toPrivList }

let Warehouse =
      let This = { modify : Bool, monitor : Bool, usage : Bool, operate : Bool }

      let default =
            { modify = False, monitor = False, usage = False, operate = False }

      let toPrivList =
            λ(x : This) →
              P.toTextList
                [ P.new "MODIFY" x.modify
                , P.new "MONITOR" x.monitor
                , P.new "USAGE" x.usage
                , P.new "OPERATE" x.operate
                ]

      in  { Type = This, default, toPrivList }

let Database =
      let This =
            { modify : Bool
            , monitor : Bool
            , usage : Bool
            , create_schema : Bool
            , imported_privileges : Bool
            }

      let default =
            { modify = False
            , monitor = False
            , usage = False
            , create_schema = False
            , imported_privileges = False
            }

      let toPrivList =
            λ(x : This) →
              P.toTextList
                [ P.new "MODIFY" x.modify
                , P.new "MONITOR" x.monitor
                , P.new "USAGE" x.usage
                , P.new "CREATE SCHEMA" x.create_schema
                , P.new "IMPORTED PRIVILEGES" x.imported_privileges
                ]

      in  { Type = This, default, toPrivList }

let Integration =
      let This = { usage : Bool, use_any_role : Bool }

      let default = { usage = False, use_any_role = False }

      let toPrivList =
            λ(x : This) →
              P.toTextList
                [ P.new "USAGE" x.usage, P.new "USE_ANY_ROLE" x.use_any_role ]

      in  { Type = This, default, toPrivList }

let example =
        assert
      :   Database.toPrivList Database::{ modify = True, monitor = True }
        ≡ [ "MODIFY", "MONITOR" ]

in  { Type =
        { user : User.Type
        , resource_monitor : ResourceMonitor.Type
        , warehouse : Warehouse.Type
        , database : Database.Type
        , integration : Integration.Type
        }
    , default =
      { user = User.default
      , resource_monitor = ResourceMonitor.default
      , warehouse = Warehouse.default
      , database = Database.default
      , integration = Integration.default
      }
    , User
    , ResourceMonitor
    , Warehouse
    , Database
    , Integration
    }
