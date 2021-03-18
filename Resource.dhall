let P = ./Prelude.dhall

let Opt = ./Opt.dhall

let Tag = ./Tag.dhall

let Resource =
      { name : Text
      , type : Text
      , opts : List Opt.Type
      , tags : List Tag.Type
      , comment : Optional Text
      }

let default =
      { opts = [] : List Opt.Type
      , tags = [] : List Tag.Type
      , comment = None Text
      }

let toDDL =
      λ(x : Resource) →
      λ(replace : Bool) →
        let type =
              if    replace
              then  "OR REPLACE ${x.type}"
              else  "${x.type} IF NOT EXISTS"

        let opts = P.Text.concat (Opt.optsToText x.opts)

        let comm =
              merge
                { None = "", Some = λ(t : Text) → " COMMENT='${t}'" }
                x.comment

        in  ''
            CREATE ${type} ${x.name}${opts}${Tag.tagsToOpt x.tags}${comm}
            ''

in  { Type = Resource, default, toDDL }
