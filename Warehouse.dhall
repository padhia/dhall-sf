let P = ./Prelude.dhall

let R = ./Resource.dhall

let T = ./Tag.dhall

let O = ./Object.dhall

let Opt = ./Opt.dhall

let ScalingPolicy = < Standard | Economy >

let ScalingPolicy/show =
      λ(x : ScalingPolicy) →
        merge { Standard = "STANDARD", Economy = "ECONOMY" } x

let WHSize = < XS | S | M | L | XL | XXL | XXXL | X4L | X5L | X6L >

let WHSize/show =
      λ(x : WHSize) →
        merge
          { XS = "XSMALL"
          , S = "SMALL"
          , M = "MEDIUM"
          , L = "LARGE"
          , XL = "XLARGE"
          , XXL = "XXLARGE"
          , XXXL = "XXXLARGE"
          , X4L = "X4LARGE"
          , X5L = "X5LARGE"
          , X6L = "X6LARGE"
          }
          x

let WH =
      { name : Text
      , size : WHSize
      , init_susp : Bool
      , auto_susp : Optional Natural
      , auto_resume : Bool
      , min_cluster : Natural
      , max_cluster : Natural
      , scaling : ScalingPolicy
      , timeout : Natural
      , queueout : Natural
      , tags : List T.Type
      , comment : Optional Text
      }

let default =
      { name = "DEMO"
      , size = WHSize.L
      , init_susp = True
      , auto_susp = Some 600
      , auto_resume = True
      , min_cluster = 1
      , max_cluster = 1
      , scaling = ScalingPolicy.Standard
      , timeout = 7200
      , queueout = 600
      , tags = [] : List T.Type
      , comment = None Text
      }

let asResource =
      λ(w : WH) →
        let susp = merge { None = "NULL", Some = Natural/show } w.auto_susp

        let opts =
              [ Opt.makeT "WAREHOUSE_SIZE" (WHSize/show w.size)
              , Opt.makeN "MAX_CLUSTER_COUNT" w.min_cluster
              , Opt.makeN "MIN_CLUSTER_COUNT" w.min_cluster
              , Opt.makeT "SCALING_POLICY" (ScalingPolicy/show w.scaling)
              , Opt.makeT "AUTO_SUSPEND" susp
              , Opt.makeB "AUTO_RESUME" w.auto_resume
              , Opt.makeB "INITIALLY_SUSPENDED" w.init_susp
              ]

        in  R::{
            , name = w.name
            , type = O.AccObjType/show O.AccObjType.Warehouse
            , tags = w.tags
            , opts
            , comment = w.comment
            }

let toDDL = λ(w : WH) → R.toDDL (asResource w)

in  { Type = WH
    , default
    , toDDL
    , asResource
    , WHSize
    , WHSize/show
    , ScalingPolicy
    }
