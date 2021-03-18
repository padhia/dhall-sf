let Column = ./Column.dhall

let Obj = (./Object.dhall).ObjName

let FKey = { refTable : Obj.Type, refColumns : Optional (List Column.Type) }

let ConstraintType = < Primary | Unique | Foreign : FKey >

let Constraint =
      { name : Optional Text
      , type : ConstraintType
      , columns : List Column.Type
      }

let optCols =
      λ(opt : Text) →
      λ(xs : List Column.Type) →
        (./Util.dhall).concatMapSep
          opt
          Column.Type
          (λ(x : Column.Type) → x.name)
          xs

let show =
      λ(x : Constraint) →
        let name =
              merge
                { None = "", Some = λ(y : Text) → "CONSTRAINT ${y} " }
                x.name

        let fkey =
              λ(y : FKey) →
                let fcols = optCols "" x.columns

                let rcols = merge { None = "", Some = optCols "" } y.refColumns

                in  "FOREIGN KEY${fcols} REFERENCES ${Obj.show
                                                        y.refTable}${rcols}"

        let const =
              merge
                { Primary = optCols "PRIMARY KEY" x.columns
                , Unique = optCols "UNIQUE" x.columns
                , Foreign = fkey
                }
                x.type

        in  "${name}${const}"

let examples =
      let cols1 = [ Column::{ name = "C1" }, Column::{ name = "C2" } ]

      let cols2 = [ Column::{ name = "D1" }, Column::{ name = "D2" } ]

      let example0 =
              assert
            :   show
                  { name = Some "PK"
                  , type = ConstraintType.Primary
                  , columns = cols1
                  }
              ≡ "CONSTRAINT PK PRIMARY KEY(C1, C2)"

      let example1 =
              assert
            :   show
                  { name = None Text
                  , type = ConstraintType.Unique
                  , columns = cols1
                  }
              ≡ "UNIQUE(C1, C2)"

      let example2 =
              assert
            :   show
                  { name = None Text
                  , type =
                      ConstraintType.Foreign
                        { refTable = Obj::{ name = "PARENT_TABLE" }
                        , refColumns = None (List Column.Type)
                        }
                  , columns = cols1
                  }
              ≡ "FOREIGN KEY(C1, C2) REFERENCES PARENT_TABLE"

      let example3 =
              assert
            :   show
                  { name = None Text
                  , type =
                      ConstraintType.Foreign
                        { refTable = Obj::{ name = "PARENT_TABLE" }
                        , refColumns = Some cols2
                        }
                  , columns = cols1
                  }
              ≡ "FOREIGN KEY(C1, C2) REFERENCES PARENT_TABLE(D1, D2)"

      in  { example0, example1, example2, example3 }

in  { Constraint, ConstraintType, show }
