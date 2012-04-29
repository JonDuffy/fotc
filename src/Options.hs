-----------------------------------------------------------------------------
-- |
-- Module      : Options
-- Copyright   : (c) Andrés Sicard-Ramírez 2009-2012
-- License     : See the file LICENSE.
--
-- Maintainer  : Andrés Sicard-Ramírez <andres.sicard.ramirez@gmail.com>
-- Stability   : experimental
--
-- Process the arguments.
-----------------------------------------------------------------------------

{-# LANGUAGE CPP #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE UnicodeSyntax #-}

module Options
  ( defaultATPs
  , defaultOptions
  , options
  , Options( optAgdaIncludePath
           , optATP
           , optHelp
           , optNonFOL
           , optNonFOLFormulaQuantification
           , optNonFOLPropositionalFunctionQuantification
           , optNonFOLTermQuantification
           , optOnlyFiles
           , optOutputDir
           , optSnapshotDir
           , optSnapshotTest
           , optTime
           , optUnprovedNoError
           , optVampireExec
           , optVerbose
           , optVersion
           )
  , printUsage
  ) where

------------------------------------------------------------------------------
-- Haskell imports

#if __GLASGOW_HASKELL__ == 612
import Control.Monad ( Monad((>>=), fail) )
#endif

#if __GLASGOW_HASKELL__ < 702
import Data.Char ( String )
#else
import Data.String ( String )
#endif

import Data.Bool     ( Bool(True, False) )
import Data.Char     ( isDigit )
import Data.Function ( ($) )
import Data.Int      ( Int )
import Data.List     ( (++), all, elem, init, last )

import System.Console.GetOpt
  ( ArgDescr(NoArg, ReqArg)
  , OptDescr(Option)
  , usageInfo
  )

#if __GLASGOW_HASKELL__ == 612
import GHC.Num ( Num(fromInteger) )
#endif
import GHC.Err ( error )

import System.Environment ( getProgName )
import System.IO          ( FilePath, IO, putStrLn )

import Text.Read ( read )
import Text.Show ( Show )

------------------------------------------------------------------------------
-- Agda library imports

import Agda.Interaction.Options ( Verbosity )
import Agda.Utils.List          ( wordsBy )

import qualified Agda.Utils.Trie as Trie ( insert, singleton )

-----------------------------------------------------------------------------

-- | Program command-line options.
data Options = MkOptions
  { optAgdaIncludePath                           ∷ [FilePath]
  , optATP                                       ∷ [String]
  , optHelp                                      ∷ Bool
  , optNonFOL                                    ∷ Bool
  , optNonFOLFormulaQuantification               ∷ Bool
  , optNonFOLPropositionalFunctionQuantification ∷ Bool
  , optNonFOLTermQuantification                  ∷ Bool
  , optOnlyFiles                                 ∷ Bool
  , optOutputDir                                 ∷ FilePath
  , optSnapshotDir                               ∷ FilePath
  , optSnapshotTest                              ∷ Bool
  , optTime                                      ∷ Int
  , optUnprovedNoError                           ∷ Bool
  , optVampireExec                               ∷ String
  , optVerbose                                   ∷ Verbosity
  , optVersion                                   ∷ Bool
  } deriving Show

-- | Default ATPs called by the program.
defaultATPs ∷ [String]
defaultATPs = ["e", "equinox", "vampire"]

-- | Default options use by the program.

-- N.B. The default ATPs are defined by @defaultATPs@ and they are handle
-- by @Options.Process.processOptions@.
defaultOptions ∷ Options
defaultOptions = MkOptions
  { optAgdaIncludePath                           = []
  , optATP                                       = []
  , optHelp                                      = False
  , optNonFOL                                    = False
  , optNonFOLFormulaQuantification               = False
  , optNonFOLPropositionalFunctionQuantification = False
  , optNonFOLTermQuantification                  = False
  , optOnlyFiles                                 = False
  , optOutputDir                                 = "/tmp"
  , optSnapshotDir                               = "snapshot"
  , optSnapshotTest                              = False
  , optTime                                      = 300
  , optUnprovedNoError                           = False
  , optVampireExec                               = "vampire_lin64"
  , optVerbose                                   = Trie.singleton [] 1
  , optVersion                                   = False
  }

agdaIncludePathOpt ∷ FilePath → Options → Options
agdaIncludePathOpt [] _ =
  error "Option --agda-include-path (or -i) requires an argument DIR"
agdaIncludePathOpt dir opts =
  opts { optAgdaIncludePath = optAgdaIncludePath opts ++ [dir] }

atpOpt ∷ String → Options → Options
atpOpt []   _    = error "Option --atp requires an argument NAME"
atpOpt name opts = opts { optATP = optATP opts ++ [name] }

helpOpt ∷ Options → Options
helpOpt opts = opts { optHelp = True }

nonFOLOpt ∷ Options → Options
nonFOLOpt opts = opts { optNonFOL                                    = True
                      , optNonFOLFormulaQuantification               = True
                      , optNonFOLPropositionalFunctionQuantification = True
                      , optNonFOLTermQuantification                  = True
                      }

nonFOLFormulaQuantificationOpt ∷ Options → Options
nonFOLFormulaQuantificationOpt opts =
  opts { optNonFOLFormulaQuantification = True }

nonFOLPropositionalFunctionQuantificationOpt ∷ Options → Options
nonFOLPropositionalFunctionQuantificationOpt opts =
  opts { optNonFOLPropositionalFunctionQuantification = True }

nonFOLTermQuantificationOpt ∷ Options → Options
nonFOLTermQuantificationOpt opts = opts { optNonFOLTermQuantification = True }

onlyFilesOpt ∷ Options → Options
onlyFilesOpt opts = opts { optOnlyFiles = True }

outputDirOpt ∷ FilePath → Options → Options
outputDirOpt []  _    = error "Option --output-dir requires an argument DIR"
outputDirOpt dir opts = opts { optOutputDir = dir }

snapshotDirOpt ∷ FilePath → Options → Options
snapshotDirOpt []  _    = error "Option --snapshot-dir requires an argument DIR"
snapshotDirOpt dir opts = opts { optSnapshotDir = dir }

snapshotTestOpt ∷ Options → Options
snapshotTestOpt opts = opts { optSnapshotTest = True
                            , optOnlyFiles = True
                            }

timeOpt ∷ String → Options → Options
timeOpt []   _    = error "Option --time requires an argument NUM"
timeOpt secs opts =
  if all isDigit secs
  then opts { optTime = read secs }
  else error "Option --time requires an non-negative integer argument"

unprovedNoErrorOpt ∷ Options → Options
unprovedNoErrorOpt opts = opts { optUnprovedNoError = True }

vampireExecOpt ∷ String → Options → Options
vampireExecOpt []   _    = error "Option --vampire-exec requires an argument COMMAND"
vampireExecOpt name opts = opts { optVampireExec = name }

-- Adapted from @Agda.Interaction.Options.verboseFlag@.
verboseOpt ∷ String → Options → Options
verboseOpt str opts = opts { optVerbose = Trie.insert k n $ optVerbose opts }
  where
  k ∷ [String]
  n ∷ Int
  (k, n) = parseVerbose str

  parseVerbose ∷ String → ([String], Int)
  parseVerbose s =
    case wordsBy (`elem` ":.") s of
      []  → error "Option --verbose requieres an argument the form x.y.z:N or N"
      ss  → let m ∷ Int
                m = read $ last ss
            in  (init ss, m)

versionOpt ∷ Options → Options
versionOpt opts = opts { optVersion = True }

options ∷ [OptDescr (Options → Options)]
options =
  [ Option "i" ["agda-include-path"] (ReqArg agdaIncludePathOpt "DIR")
               "look for imports in DIR"
  , Option []  ["atp"] (ReqArg atpOpt "NAME") $
               "set the ATP (e, equinox, metis, spass, vampire)\n"
               ++ "(default: e, equinox, and vampire)"
  , Option "?" ["help"] (NoArg helpOpt)
               "show this help"
  , Option []  ["non-fol"] (NoArg nonFOLOpt)
               "enable the non-FOL translations"
  , Option []  ["non-fol-formula-quantification"]
               (NoArg nonFOLFormulaQuantificationOpt)
               "translate FOL universal quantified formulae"
  , Option []  ["non-fol-propositional-function-quantification"]
               (NoArg nonFOLPropositionalFunctionQuantificationOpt)
               "translate FOL universal quantified propositional functions"
  , Option []  ["non-fol-term-quantification"]
               (NoArg nonFOLTermQuantificationOpt)
               "translate FOL universal quantified function terms"
  , Option []  ["only-files"] (NoArg onlyFilesOpt)
               "do not call the ATPs, only to create the TPTP files"
  , Option []  ["output-dir"] (ReqArg outputDirOpt "DIR")
               "directory in which TPTP files are placed (default: /tmp)"
  , Option []  ["snapshot-dir"] (ReqArg snapshotDirOpt "DIR") $
               "directory where is the snapshot of the TPTP files\n"
               ++ "(default: snapshot)"
  , Option []  ["snapshot-test"] (NoArg snapshotTestOpt) $
               "compare the generated TPTP files against a snapshot of them\n"
               ++ "(implies --only-files)"
  , Option []  ["time"] (ReqArg timeOpt "NUM")
               "set timeout for the ATPs in seconds (default: 300)"
  , Option []  ["unproved-conjecture-no-error"] (NoArg unprovedNoErrorOpt)
               "an unproved TPTP conjecture does not generate an error"
  , Option []  ["vampire-exec"] (ReqArg vampireExecOpt "COMMAND")
               "set the vampire executable (default: vampire_lin64)"
  , Option "v" ["verbose"] (ReqArg verboseOpt "N")
               "set verbosity level to N"
  , Option "V" ["version"] (NoArg versionOpt)
               "show version number"
  ]

usageHeader ∷ String → String
usageHeader prgName =
  "Usage: " ++ prgName ++ " [OPTIONS] FILE\n"

-- | Print usage information.
printUsage ∷ IO ()
printUsage = do
  progName ← getProgName
  putStrLn $ usageInfo (usageHeader progName) options
