let List/map = (./Prelude.dhall).List.map

let List/concat = (./Prelude.dhall).List.concat

let Role = ∀(T : Type) → ∀(Build : { name : Text, inherits : List T } → T) → T

let make
    : { name : Text, inherits : List Role } → Role
    = λ(x : { name : Text, inherits : List Role }) →
      λ(T : Type) →
      λ(Build : { name : Text, inherits : List T } → T) →
        let adapt
            : Role → T
            = λ(y : Role) → y T Build

        in  Build (x with inherits = List/map Role T adapt x.inherits)

let expand
    : Role → List Text
    = λ(x : Role) →
        x
          (List Text)
          ( λ(y : { name : Text, inherits : List (List Text) }) →
              [ y.name ] # List/concat Text y.inherits
          )

let sys_roles =
      let public = make { name = "PUBLIC", inherits = [] : List Role }

      let user_admin = make { name = "USERADMIN", inherits = [ public ] }

      let security_admin =
            make { name = "SECURITYADMIN", inherits = [ user_admin ] }

      let sys_admin = make { name = "SYSADMIN", inherits = [ public ] }

      let account_admin =
            make
              { name = "ACCOUNTADMIN"
              , inherits = [ security_admin, sys_admin ]
              }

      in  { public, user_admin, security_admin, sys_admin, account_admin }

let example0 =
        assert
      :   expand sys_roles.account_admin
        ≡ [ "ACCOUNTADMIN"
          , "SECURITYADMIN"
          , "USERADMIN"
          , "PUBLIC"
          , "SYSADMIN"
          , "PUBLIC"
          ]

in  { sys_roles, Role, make, expand }
