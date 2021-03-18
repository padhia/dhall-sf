let showSome =
      λ(pfx : Text) →
      λ(T : Type) →
      λ(f : T → Text) →
      λ(x : Optional T) →
        pfx ++ merge { None = "", Some = f } x

let asLen = λ(x : Natural) → "(${Natural/show x})"

let TZType = < Ntz | Ltz | Tz >

let TZType/show =
      λ(x : TZType) → merge { Ntz = "_NTZ", Ltz = "_LTZ", Tz = "TZ" } x

let TSType = { frac : Optional Natural, tz : Optional TZType }

let TSType/show =
      λ(x : TSType) →
        showSome "" TZType TZType/show x.tz ++ showSome "" Natural asLen x.frac

let Precision = { prec : Natural, scale : Optional Natural }

let Precision/show =
      λ(x : Precision) →
            "(${Natural/show x.prec}"
        ++  merge
              { None = "", Some = λ(n : Natural) → ",${Natural/show n}" }
              x.scale
        ++  ")"

let DataType =
      < Array
      | Binary : Optional Natural
      | Boolean
      | Varchar : Optional Natural
      | Date
      | Float
      | Geo
      | Number : Optional Precision
      | Object
      | Time : Optional Natural
      | Timestamp : Optional TSType
      | Variant
      >

let show =
      λ(x : DataType) →
        merge
          { Array = "ARRAY"
          , Binary = showSome "BINARY" Natural asLen
          , Boolean = "BOOLEAN"
          , Varchar = showSome "VARCHAR" Natural asLen
          , Date = "DATE"
          , Float = "FLOAT"
          , Geo = "GEOGRAPHY"
          , Number = showSome "NUMBER" Precision Precision/show
          , Object = "OBJECT"
          , Time = showSome "TIME" Natural asLen
          , Timestamp = showSome "TIMESTAMP" TSType TSType/show
          , Variant = "VARIANT"
          }
          x

let example0 = assert : show (DataType.Number (None Precision)) ≡ "NUMBER"

let example1 =
        assert
      :   show (DataType.Number (Some { prec = 10, scale = None Natural }))
        ≡ "NUMBER(10)"

let example2 =
        assert
      :   show (DataType.Number (Some { prec = 10, scale = Some 2 }))
        ≡ "NUMBER(10,2)"

let example3 =
        assert
      :   show
            ( DataType.Timestamp
                (Some { frac = None Natural, tz = Some TZType.Ltz })
            )
        ≡ "TIMESTAMP_LTZ"

let example4 =
        assert
      :   show (DataType.Timestamp (Some { frac = Some 6, tz = None TZType }))
        ≡ "TIMESTAMP(6)"

let example5 =
        assert
      :   show
            (DataType.Timestamp (Some { frac = Some 9, tz = Some TZType.Ntz }))
        ≡ "TIMESTAMP_NTZ(9)"

in  { Type = DataType, Modifiers = { Precision, TZType, TSType }, show }
