let IntegrationType = < Notification | Security | Storage >

let AccObjType =
      < Account
      | DxList
      | Database
      | Integration : Optional IntegrationType
      | NetworkPolicy
      | ResourceMonitor
      | Role
      | Share
      | User
      | Warehouse
      >

let AccObjType/show =
      λ(x : AccObjType) →
        let IShow =
              λ(x : IntegrationType) →
                merge
                  { Notification = "NOTIFICATION "
                  , Security = "SECURITY "
                  , Storage = "STORAGE "
                  }
                  x

        in  merge
              { Account = "ACCOUNT"
              , DxList = "DATA EXCHANGE LISTING"
              , Database = "DATABASE"
              , Integration =
                  λ(x : Optional IntegrationType) →
                    merge { None = "", Some = IShow } x ++ "INTEGRATION"
              , NetworkPolicy = "NETWORK POLICY"
              , ResourceMonitor = "RESOURCE MONITOR"
              , Role = "ROLE"
              , Share = "SHARE"
              , User = "USER"
              , Warehouse = "WAREHOUSE"
              }
              x

let ObjType =
      < ExternalTable
      | FileFormat
      | Function
      | MaskingPolicy
      | MaterializedView
      | Pipe
      | Procedure
      | RowAccessPolicy
      | Sequence
      | Stage
      | Stream
      | Table
      | Tag
      | Task
      | View
      >

let ObjType/show =
      λ(x : ObjType) →
        merge
          { ExternalTable = "EXTERNAL TABLE"
          , FileFormat = "FILE FORMAT"
          , Function = "FUNCTION"
          , MaskingPolicy = "MASKING POLICY"
          , MaterializedView = "MATERIALIZED VIEW"
          , Pipe = "PIPE"
          , Procedure = "PROCEDURE"
          , RowAccessPolicy = "ROW ACCESS POLICY"
          , Sequence = "SEQUENCE"
          , Stage = "STAGE"
          , Stream = "STREAM"
          , Table = "TABLE"
          , Tag = "TAG"
          , Task = "TASK"
          , View = "VIEW"
          }
          x

let qualifier =
      λ(pfx : Optional Text) →
      λ(x : Optional Text) →
        merge
          { None =
              merge { None = None Text, Some = λ(p : Text) → Some "${p}." } pfx
          , Some =
              λ(y : Text) →
                merge
                  { None = Some "${y}.", Some = λ(p : Text) → Some "${p}${y}." }
                  pfx
          }
          x

let ObjName =
      { Type = { name : Text, schema : Optional Text, database : Optional Text }
      , default = { name = "Unknown", schema = None Text, database = None Text }
      , show =
          λ ( x
            : { name : Text, schema : Optional Text, database : Optional Text }
            ) →
                merge
                  { None = "", Some = λ(y : Text) → y }
                  (qualifier (qualifier (None Text) x.database) x.schema)
            ++  x.name
      }

let examples =
        assert
      :   (./Prelude.dhall).List.map
            ObjName.Type
            Text
            ObjName.show
            [ ObjName::{ name = "MY_TABLE" }
            , ObjName::{ schema = Some "PUBLIC", name = "MY_TABLE" }
            , { database = Some "MYDB"
              , schema = Some "PUBLIC"
              , name = "MY_TABLE"
              }
            , ObjName::{ database = Some "MYDB", name = "MY_TABLE" }
            ]
        ≡ [ "MY_TABLE"
          , "PUBLIC.MY_TABLE"
          , "MYDB.PUBLIC.MY_TABLE"
          , "MYDB..MY_TABLE"
          ]

in  { ObjName
    , ObjType
    , ObjType/show
    , AccObjType
    , AccObjType/show
    , IntegrationType
    }
