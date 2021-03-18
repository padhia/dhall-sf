let P = ./Prelude.dhall

let Opt = { name : Text, val : Optional Text }

let Opt/toOptionalText =
      λ(o : Opt) →
        merge
          { None = None Text, Some = λ(v : Text) → Some " ${o.name}=${v}" }
          o.val

let optsToText =
      λ(xs : List Opt) →
        P.List.unpackOptionals
          Text
          (P.List.map Opt (Optional Text) Opt/toOptionalText xs)

let b2t = λ(x : Bool) → Some (if x then "TRUE" else "FALSE")

let n2t = λ(x : Natural) → Some (Natural/show x)

let makeT = λ(n : Text) → λ(v : Text) → { name = n, val = Some v }

let makeN = λ(n : Text) → λ(v : Natural) → { name = n, val = n2t v }

let makeB = λ(n : Text) → λ(v : Bool) → { name = n, val = b2t v }

let makeOT = λ(n : Text) → λ(v : Optional Text) → { name = n, val = v }

let makeON =
      λ(n : Text) →
      λ(v : Optional Natural) →
        { name = n, val = merge { None = None Text, Some = n2t } v }

let makeOB =
      λ(n : Text) →
      λ(v : Optional Bool) →
        { name = n, val = merge { None = None Text, Some = b2t } v }

in  { Type = Opt, optsToText, makeT, makeN, makeB, makeOT, makeON, makeOB }
