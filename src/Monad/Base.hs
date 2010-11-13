------------------------------------------------------------------------------
-- The translation monad
------------------------------------------------------------------------------

{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE UnicodeSyntax #-}

module Monad.Base
    ( AllDefinitions
    , runT
    , T
    , TState(tAllDefs, tFile, tOpts, tVars)
    )
    where

-- Haskell imports
import Control.Monad.Error  ( ErrorT, MonadError, runErrorT )
import Control.Monad.State  ( evalStateT, MonadState, StateT )
import Control.Monad.Trans  ( MonadIO )

import qualified Data.Map as Map ( empty )

-- Agda library imports
import Agda.TypeChecking.Monad.Base ( Definitions )

-- Local imports
import Options ( defaultOptions, Options )

------------------------------------------------------------------------------

type AllDefinitions = Definitions

data TState = MkState { tAllDefs :: AllDefinitions
                      , tFile    :: FilePath
                      , tOpts    :: Options
                      , tVars    :: [String]
                        -- ^ Names of variables bounded in the Agda types.
                      }

-- The initial state.
initTState :: TState
initTState = MkState { tAllDefs = Map.empty
                     , tFile    = []
                     , tOpts    = defaultOptions
                     , tVars    = []
                     }

-- The translation monad.
-- Adapted from: Real World Haskell (Chapter 18. Monad transformers)
newtype T a = MkT { runA :: ErrorT String (StateT TState IO) a }
        -- Requires GeneralizedNewtypeDeriving
        deriving ( Functor
                 , Monad
                 , MonadIO
                 , MonadError String
                 , MonadState TState
                 )

runT :: T a → IO (Either String a)
runT ta = evalStateT (runErrorT (runA ta)) initTState
