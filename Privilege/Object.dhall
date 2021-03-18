let O = (../Object.dhall).ObjType

let O/show = (../Object.dhall).ObjType/show

let A/show = (../Object.dhall).AccObjType/show

let P = ./PrivText.dhall

let L = (../Prelude.dhall).List

let Usage =
      { Type = { usage : Bool }
      , default.usage = False
      , toPrivText =
          λ(x : { usage : Bool }) → P.toTextList [ P.new "USAGE" x.usage ]
      }

let Apply =
      { Type = { apply : Bool }
      , default.apply = False
      , toPrivText =
          λ(x : { apply : Bool }) → P.toTextList [ P.new "APPLY" x.apply ]
      }

let Select =
      { Type = { select : Bool }
      , default.select = False
      , toPrivText =
          λ(x : { select : Bool }) → P.toTextList [ P.new "SELECT" x.select ]
      }

let OM =
      { Type = { monitor : Bool, operate : Bool }
      , default = { monitor = False, operate = False }
      , toPrivText =
          λ(x : { monitor : Bool, operate : Bool }) →
            P.toTextList
              [ P.new "MONITOR" x.monitor, P.new "OPERATE" x.operate ]
      }

let View =
      { Type = { select : Bool, references : Bool }
      , default = { select = False, references = False }
      , toPrivText =
          λ(x : { select : Bool, references : Bool }) →
            P.toTextList
              [ P.new "SELECT" x.select, P.new "REFERENCES" x.references ]
      }

let TableType =
        View.Type
      ⩓ { insert : Bool, update : Bool, delete : Bool, truncate : Bool }

let Table =
      { Type = TableType
      , default =
            { insert = False, update = False, delete = False, truncate = False }
          ∧ View.default
      , toPrivText =
          λ(x : TableType) →
              View.toPrivText x.(View.Type)
            # P.toTextList
                [ P.new "INSERT" x.insert
                , P.new "UPDATE" x.update
                , P.new "DELETE" x.delete
                , P.new "TRUNCATE" x.truncate
                ]
      }

let Stage =
      { Type = { usage : Bool, read : Bool, write : Bool }
      , default = { usage = False, read = False, write = False }
      , toPrivText =
          λ(x : { usage : Bool, read : Bool, write : Bool }) →
            P.toTextList
              [ P.new "USAGE" x.usage
              , P.new "READ" x.read
              , P.new "WRITE" x.write
              ]
      }

let Object =
      { file_format : Usage.Type
      , function : Usage.Type
      , masking_policy : Apply.Type
      , materialized_view : Select.Type
      , pipe : OM.Type
      , procedure : Usage.Type
      , row_access_policy : Apply.Type
      , sequence : Usage.Type
      , stage : Stage.Type
      , stream : Select.Type
      , table : Table.Type
      , tag : Apply.Type
      , task : OM.Type
      , view : View.Type
      }

let default =
      { file_format = Usage.default
      , function = Usage.default
      , masking_policy = Apply.default
      , materialized_view = Select.default
      , pipe = OM.default
      , procedure = Usage.default
      , row_access_policy = Apply.default
      , sequence = Usage.default
      , stage = Stage.default
      , stream = Select.default
      , table = Table.default
      , tag = Apply.default
      , task = OM.default
      , view = View.default
      }

let Pair = { type : O, privs : List Text }

let toPrivList =
      λ(x : Object) →
        L.filter
          Pair
          (λ(p : Pair) → L.null Text p.privs == False)
          [ { type = O.FileFormat, privs = Usage.toPrivText x.file_format }
          , { type = O.Function, privs = Usage.toPrivText x.function }
          , { type = O.MaskingPolicy
            , privs = Apply.toPrivText x.masking_policy
            }
          , { type = O.MaterializedView
            , privs = Select.toPrivText x.materialized_view
            }
          , { type = O.Pipe, privs = OM.toPrivText x.pipe }
          , { type = O.Procedure, privs = Usage.toPrivText x.procedure }
          , { type = O.RowAccessPolicy
            , privs = Apply.toPrivText x.row_access_policy
            }
          , { type = O.Sequence, privs = Usage.toPrivText x.sequence }
          , { type = O.Stage, privs = Stage.toPrivText x.stage }
          , { type = O.Stream, privs = Select.toPrivText x.stream }
          , { type = O.Table, privs = Table.toPrivText x.table }
          , { type = O.Tag, privs = Apply.toPrivText x.tag }
          , { type = O.Task, privs = OM.toPrivText x.task }
          , { type = O.View, privs = View.toPrivText x.view }
          ]

in  { Type = Object
    , default
    , toPrivList
    , FileFormat = Usage
    , Function = Usage
    , MaskingPolicy = Apply
    , MaterializedView = Select
    , Pipe = OM
    , Procedure = Usage
    , RowAccessPolicy = Apply
    , Sequence = Usage
    , Stage
    , Stream = Select
    , Table
    , Tag = Apply
    , Task = OM
    , View
    }
