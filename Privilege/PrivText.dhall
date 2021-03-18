let P = ../Prelude.dhall

let new = λ(x : Text) → λ(y : Bool) → if y then Some x else None Text

let toTextList = P.List.unpackOptionals Text

in  { new, toTextList }
