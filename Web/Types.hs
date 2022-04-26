module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data SessionsController
    = NewSessionAction
    | CreateSessionAction
    | DeleteSessionAction
    deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
    newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User
data UsersController
    = NewUserAction
    | CreateUserAction
    deriving (Eq, Show, Data)

data SearchesController
    = ShowSearchAction { keyword :: Text }
    deriving (Eq, Show, Data)

data EntriesController
    = ShowEntryAction { entryId :: !(Id Entry) }
    | NewEntryAction
    deriving (Eq, Show, Data)
