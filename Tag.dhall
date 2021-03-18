let P = ./Prelude.dhall

let Tag = P.Map.Entry Text Text

let Tag/show = λ(x : Tag) → "${x.mapKey}='${x.mapValue}'"

let tagsToOpt =
      λ(xs : List Tag) →
        if    P.List.null Tag xs
        then  ""
        else  " TAG (" ++ P.Text.concatMapSep ", " Tag Tag/show xs ++ ")"

in  { Type = Tag, Tag/show, tagsToOpt }
