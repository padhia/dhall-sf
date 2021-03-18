let Priv = ./Privilege/package.dhall

let Grantee = { role : Text, with_grant : Bool }

let GrantGlobal = { priv : < Only : Priv.Global.Type | All > } ⩓ Grantee

let GrantAccObj =
        { priv : < Only : Priv.AccObj.Type | All >
        , on : List (./Object.dhall).AccObjType
        }
      ⩓ Grantee

let GrantSchema =
        { priv : < Only : Priv.Schema.Type | All >
        , on : < Schema : Text | All >
        , future : Bool
        , parent : Optional Text
        }
      ⩓ Grantee

let GrantObj =
        { priv : < Only : Priv.Object.Type | All >
        , on : < Only : List (./Object.dhall).ObjType | All >
        , parent : Optional < Schema : Text | Database : Text >
        }
      ⩓ Grantee

let Grant =
      < Global : GrantGlobal
      | Account : GrantAccObj
      | Schema : GrantSchema
      | Object : GrantObj
      >

in  { GrantGlobal, GrantAccObj, GrantSchema, GrantObj, Grant }
