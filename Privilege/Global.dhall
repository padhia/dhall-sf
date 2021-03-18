let O = (../Object.dhall).ObjType

let O/show = (../Object.dhall).ObjType/show

let A = (../Object.dhall).AccObjType

let A/show = (../Object.dhall).AccObjType/show

let P = ./PrivText.dhall

let Create =
      { Type =
          { account : Bool
          , dxList : Bool
          , role : Bool
          , user : Bool
          , warehouse : Bool
          , database : Bool
          , integration : Bool
          }
      , default =
        { account = False
        , dxList = False
        , role = False
        , user = False
        , warehouse = False
        , database = False
        , integration = False
        }
      }

let Apply =
      { Type =
          { masking_policy : Bool
          , row_access_policy : Bool
          , session_policy : Bool
          , tag : Bool
          }
      , default =
        { masking_policy = False
        , row_access_policy = False
        , session_policy = False
        , tag = False
        }
      }

let Attach = { Type = { policy : Bool }, default.policy = False }

let Execute = { Type = { task : Bool }, default.task = False }

let Manage = { Type = { grants : Bool }, default.grants = False }

let Import = { Type = { share : Bool }, default.share = False }

let Monitor =
      { Type = { execution : Bool, usage : Bool }
      , default = { execution = False, usage = False }
      }

let This =
      { create : Create.Type
      , apply : Apply.Type
      , attach : Attach.Type
      , import : Import.Type
      , execute : Execute.Type
      , manage : Manage.Type
      , monitor : Monitor.Type
      }

let default =
      { create = Create.default
      , apply = Apply.default
      , attach = Attach.default
      , import = Import.default
      , execute = Execute.default
      , manage = Manage.default
      , monitor = Monitor.default
      }

let toPrivList =
      let Integration =
            A/show (A.Integration (None (../Object.dhall).IntegrationType))

      in  λ(g : This) →
            P.toTextList
              [ P.new "CREATE ${A/show A.Account}" g.create.account
              , P.new "CREATE ${A/show A.DxList}" g.create.dxList
              , P.new "CREATE ${A/show A.Role}" g.create.role
              , P.new "CREATE ${A/show A.User}" g.create.user
              , P.new "CREATE ${A/show A.Warehouse}" g.create.warehouse
              , P.new "CREATE ${A/show A.Database}" g.create.database
              , P.new "CREATE ${Integration}" g.create.integration
              , P.new "APPLY ${O/show O.MaskingPolicy}" g.apply.masking_policy
              , P.new
                  "APPLY ${O/show O.RowAccessPolicy}"
                  g.apply.row_access_policy
              , P.new "APPLY ${O/show O.Tag}" g.apply.tag
              , P.new "ATTACH POLICY" g.attach.policy
              , P.new "IMPORT SHARE" g.import.share
              , P.new "EXECUTE ${O/show O.Task}" g.execute.task
              , P.new "MANAGE GRANTS" g.manage.grants
              , P.new "MONITOR EXECUTION" g.monitor.execution
              , P.new "MONITOR USAGE" g.monitor.usage
              ]

let example0 =
        assert
      : toPrivList (default with execute.task = True) ≡ [ "EXECUTE TASK" ]

let example1 =
      assert : toPrivList (default with create.role = True) ≡ [ "CREATE ROLE" ]

in  { Type = This
    , default
    , toPrivList
    , Create
    , Apply
    , Execute
    , Manage
    , Monitor
    }
