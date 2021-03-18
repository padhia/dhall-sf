let D = ./DataType.dhall

let Column =
      { name : Text, type : D.Type, nulls : Bool, default : Optional Text }

let default =
      { name = "unnamed"
      , type = D.Type.Varchar (Some 5)
      , nulls = True
      , default = None Text
      }

let show =
      λ(x : Column) →
            "${x.name} ${D.show x.type}"
        ++  (if x.nulls then "" else " NOT NULL")
        ++  merge { None = "", Some = λ(x : Text) → " DEFAULT ${x}" } x.default

let concatMapSep =
      λ(sep : Text) →
      λ(f : Column → Text) →
        (./Prelude.dhall).Text.concatMapSep sep Column f

let examples =
        assert
      :   (./Prelude.dhall).List.map
            Column
            Text
            show
            [ default ⫽ { name = "C1", type = D.Type.Date }
            , default ⫽ { name = "C2", type = D.Type.Date, nulls = False }
            ,   default
              ⫽ { name = "C3"
                , type = D.Type.Date
                , default = Some "CURRENT_DATE"
                }
            , { name = "C4"
              , type = D.Type.Date
              , nulls = False
              , default = Some "CURRENT_DATE"
              }
            ]
        ≡ [ "C1 DATE"
          , "C2 DATE NOT NULL"
          , "C3 DATE DEFAULT CURRENT_DATE"
          , "C4 DATE NOT NULL DEFAULT CURRENT_DATE"
          ]

in  { Type = Column, default, show, concatMapSep }
