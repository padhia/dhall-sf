let P = ./Prelude.dhall

let concatSep =
      λ(pfx : Text) →
      λ(xs : List Text) →
        if    P.List.null Text xs
        then  ""
        else  "${pfx}(${P.Text.concatSep ", " xs})"

let concatMapSep =
      λ(pfx : Text) →
      λ(a : Type) →
      λ(f : a → Text) →
      λ(xs : List a) →
        concatSep pfx (P.List.map a Text f xs)

let example0 = assert : concatSep "PFX" [ "A", "B" ] ≡ "PFX(A, B)"

let example1 = assert : concatSep "" [ "A", "B" ] ≡ "(A, B)"

let example2 = assert : concatSep "PFX" ([] : List Text) ≡ ""

in  { concatSep, concatMapSep }
