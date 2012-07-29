------------------------------------------------------------------------------
-- |
-- Module      : Utils.IO
-- Copyright   : (c) Andrés Sicard-Ramírez 2009-2012
-- License     : See the file LICENSE.
--
-- Maintainer  : Andrés Sicard-Ramírez <andres.sicard.ramirez@gmail.com>
-- Stability   : experimental
--
-- IO utilities
------------------------------------------------------------------------------

{-# LANGUAGE UnicodeSyntax #-}

module Utils.IO
  ( die
  , failureMsg
  )
where

------------------------------------------------------------------------------
-- Haskell imports

import System.Environment ( getProgName )
import System.Exit        ( exitFailure )
import System.IO          ( hPutStrLn, stderr )

------------------------------------------------------------------------------
-- | Failure message.
failureMsg ∷ String → IO ()
failureMsg err = do
  progName ← getProgName
  hPutStrLn stderr $ progName ++ ": " ++ err

-- | Exit with an error message.
die ∷ String → IO a
die err = failureMsg err >> exitFailure
