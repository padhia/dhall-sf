let Authenticator = < Default | Browser | Okta | Jwt | Oauth >

let Auth =
      { account : Text
      , user : Text
      , authenticator : Authenticator
      , role : Optional Text
      , warehouse : Optional Text
      , database : Optional Text
      , schema : Optional Text
      , password : Optional Text
      , keyfile : Optional Text
      , okta_account : Optional Text
      }

let default =
      { account = "unknown"
      , user = "unknown"
      , authenticator = Authenticator.Default
      , role = None Text
      , warehouse = None Text
      , database = None Text
      , schema = None Text
      , password = None Text
      , keyfile = None Text
      , okta_account = None Text
      }

in  { Type = Auth, default, Authenticator }
