module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.New

instance Controller UsersController where
    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action CreateUserAction = do
        let user = newRecord @User
        user
            |> buildUser
            |> ifValid \case
                Left user -> render NewView { .. } 
                Right user -> do
                    user <- user |> createRecord
                    setSuccessMessage "User created"
                    redirectToPath "/"

buildUser user = user
    |> fill @["email","passwordHash","failedLoginAttempts"]
