let concatSep = (./Prelude.dhall).Text.concatSep

let List/map = (./Prelude.dhall).List.map

let List/null = (./Prelude.dhall).List.null

let TC = ./Constraint.dhall

let Column = ./Column.dhall

let Obj = (./Object.dhall).ObjName

let TableType = < Permanent | Transient | Temporary >

let Table =
        Obj.Type
      ⩓ { columns : List Column.Type
        , constraints : List TC.Constraint
        , cluster_by : List Text
        , type : TableType
        , change_tracking : Optional Bool
        }

let default =
        Obj.default
      ∧ { columns = [ Column.default ]
        , constraints = [] : List TC.Constraint
        , cluster_by = [] : List Text
        , type = TableType.Permanent
        , change_tracking = None Bool
        }

let toSql =
      λ(replace : Bool) →
      λ(x : Table) →
        let repl = if replace then " OR REPLACE" else ""

        let cols = List/map Column.Type Text Column.show x.columns

        let const = List/map TC.Constraint Text TC.show x.constraints

        let dlm = "\n" ++ ", "

        let cluster_by =
              if    List/null Text x.cluster_by
              then  ""
              else  " CLUSTER BY (${concatSep ", " x.cluster_by})"

        let change_tracking =
              merge
                { None = ""
                , Some =
                    λ(x : Bool) →
                      " CHANGE_TRACKING = ${if x then "TRUE" else "FALSE"}"
                }
                x.change_tracking

        in  ''
            CREATE${repl} TABLE ${Obj.show x.(Obj.Type)}
            ( ${concatSep dlm (cols # const)}
            )${cluster_by}${change_tracking}
            ''

let example0 =
      let DT = ./DataType.dhall

      let C1 = Column::{ name = "C1", nulls = False }

      let C2 = Column::{ name = "C2", type = DT.Type.Date, nulls = False }

      let C3 =
            Column::{
            , name = "C3"
            , type = DT.Type.Number (None DT.Modifiers.Precision)
            }

      let t1 =
              default
            ⫽ { name = "MY_TABLE"
              , columns = [ C1, C2, C3 ]
              , constraints =
                [ { name = Some "PK"
                  , type = TC.ConstraintType.Primary
                  , columns = [ C1, C2 ]
                  }
                ]
              , cluster_by = [ "C1" ]
              , change_tracking = Some True
              }

      in    assert
          :   toSql True t1
            ≡ ''
              CREATE OR REPLACE TABLE MY_TABLE
              ( C1 VARCHAR(5) NOT NULL
              , C2 DATE NOT NULL
              , C3 NUMBER
              , CONSTRAINT PK PRIMARY KEY(C1, C2)
              ) CLUSTER BY (C1) CHANGE_TRACKING = TRUE
              ''

in  { Type = Table, default, TableType, toSql }
