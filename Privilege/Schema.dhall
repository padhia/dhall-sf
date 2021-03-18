let O = (../Object.dhall).ObjType

let O/show = (../Object.dhall).ObjType/show

let P = ./PrivText.dhall

let Create =
      { Type =
          { external_table : Bool
          , file_format : Bool
          , function : Bool
          , masking_policy : Bool
          , materialized_view : Bool
          , pipe : Bool
          , procedure : Bool
          , row_access_policy : Bool
          , sequence : Bool
          , stage : Bool
          , stream : Bool
          , table : Bool
          , task : Bool
          , view : Bool
          }
      , default =
        { external_table = False
        , file_format = False
        , function = False
        , masking_policy = False
        , materialized_view = False
        , pipe = False
        , procedure = False
        , row_access_policy = False
        , sequence = False
        , stage = False
        , stream = False
        , table = False
        , task = False
        , view = False
        }
      }

let Schema =
      { modify : Bool, monitor : Bool, usage : Bool, create : Create.Type }

let default =
      { modify = False
      , monitor = False
      , usage = False
      , create = Create.default
      }

let toPrivList =
      let PC = λ(x : O) → P.new "CREATE ${O/show x}"

      in  λ(x : Schema) →
            P.toTextList
              [ P.new "MODIFY" x.modify
              , P.new "MONITOR" x.monitor
              , P.new "USAGE" x.usage
              , PC O.ExternalTable x.create.external_table
              , PC O.FileFormat x.create.file_format
              , PC O.Function x.create.function
              , PC O.MaskingPolicy x.create.masking_policy
              , PC O.MaterializedView x.create.materialized_view
              , PC O.Pipe x.create.pipe
              , PC O.Procedure x.create.procedure
              , PC O.RowAccessPolicy x.create.row_access_policy
              , PC O.Sequence x.create.sequence
              , PC O.Stage x.create.stage
              , PC O.Stream x.create.stream
              , PC O.Table x.create.table
              , PC O.Task x.create.task
              , PC O.View x.create.view
              ]

let example =
        assert
      :   toPrivList (default with modify = True with create.table = True)
        ≡ [ "MODIFY", "CREATE TABLE" ]

in  { Type = Schema, default, Create, toPrivList }
