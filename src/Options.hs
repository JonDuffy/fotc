-----------------------------------------------------------------------------
-- Process the arguments
-----------------------------------------------------------------------------

{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE UnicodeSyntax #-}

module Options
  ( defaultOptions
  , defaultOptATP
  , options
  , Options(..)
  , printUsage
  ) where

import System.Console.GetOpt
  ( ArgDescr(NoArg, ReqArg)
  , OptDescr(Option)
  , usageInfo
  )

-- Agda library imports
import Agda.Interaction.Options ( Verbosity )
import Agda.Utils.List          ( wordsBy )
-- import Agda.Utils.Trie ( Trie )
import qualified Agda.Utils.Trie as Trie ( insert, singleton )

-----------------------------------------------------------------------------

data Options = MkOptions
  { optAgdaIncludePath ∷ [FilePath]
  , optATP             ∷ [String]
  , optHelp            ∷ Bool
  , optOnlyFiles       ∷ Bool
  , optOutputDir       ∷ FilePath
  , optSnapshotDir     ∷ FilePath
  , optSnapshotTest    ∷ Bool
  , optTime            ∷ Int
  , optUnprovedError   ∷ Bool
  , optVerbose         ∷ Verbosity
  , optVersion         ∷ Bool
  } deriving ( Show )

defaultOptATP ∷ [String]
defaultOptATP = ["e", "equinox", "metis", "spass", "vampire"]

defaultOptions ∷ Options
defaultOptions = MkOptions
  { optAgdaIncludePath = []
  , optATP             = []  -- N.B. The default is defined by
                             -- defaultOptATP and it is handle by
                             -- Options.Process.processOptions.
  , optHelp            = False
  , optOnlyFiles       = False
  , optOutputDir       = "/tmp"
  , optSnapshotDir     = "snapshot"
  , optSnapshotTest    = False
  , optTime            = 300
  , optUnprovedError   = False
  , optVerbose         = Trie.singleton [] 1
  , optVersion         = False
  }

agdaIncludePathOpt ∷ FilePath → Options → Options
agdaIncludePathOpt dir opts =
  opts { optAgdaIncludePath = optAgdaIncludePath opts ++ [dir] }

atpOpt ∷ String → Options → Options
atpOpt name opts = opts { optATP = optATP opts ++ [name] }

helpOpt ∷ Options → Options
helpOpt opts = opts { optHelp = True }

snapshotDirOpt ∷ FilePath → Options → Options
snapshotDirOpt dir opts = opts { optSnapshotDir = dir }

snapshotTestOpt ∷ Options → Options
snapshotTestOpt opts = opts { optSnapshotTest = True
                            , optOnlyFiles = True
                            }

timeOpt ∷ String → Options → Options
timeOpt secs opts = opts { optTime = read secs }

onlyFilesOpt ∷ Options → Options
onlyFilesOpt opts = opts { optOnlyFiles = True }

outputDirOpt ∷ FilePath → Options → Options
outputDirOpt dir opts = opts { optOutputDir = dir }

unprovedErrorOpt ∷ Options → Options
unprovedErrorOpt opts = opts { optUnprovedError = True }

-- Adapted from: Agda.Interaction.Options.verboseFlag.
verboseOpt ∷ String → Options → Options
verboseOpt str opts = opts { optVerbose = Trie.insert k n $ optVerbose opts }
  where
    -- Requires ScopedTypeVariables.
    (k, n) ∷ ([String], Int) = parseVerbose str
    parseVerbose ∷ String → ([String], Int)
    parseVerbose s =
      case wordsBy (`elem` ":.") s of
        []  → error "Argument to verbose should be on the form x.y.z:N or N"
        ss  → let m ∷ Int
                  m = read $ last ss
              in  (init ss, m)

versionOpt ∷ Options → Options
versionOpt opts = opts { optVersion = True }

options ∷ [OptDescr (Options → Options)]
options =
  [ Option "i" ["agda-include-path"] (ReqArg agdaIncludePathOpt "DIR")
               "look for imports in DIR"
  , Option []  ["atp"] (ReqArg atpOpt "name")
               "set the ATP (default: e, equinox, metis, spass, and vampire)"
  , Option "?" ["help"] (NoArg helpOpt)
               "show this help"
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
  , Option []  ["time"] (ReqArg timeOpt "secs")
               "set timeout for the ATPs in seconds (default: 300)"
  , Option []  ["unproved-conjecture-error"] (NoArg unprovedErrorOpt)
               "an unproved TPTP conjecture generates an error"
  , Option "v" ["verbose"] (ReqArg verboseOpt "N")
               "set verbosity level to N"
  , Option "V" ["version"] (NoArg versionOpt)
               "show version number"
  ]

usageHeader ∷ String → String
usageHeader prgName =
  "Usage: " ++ prgName ++ " [OPTION...] file \n"

-- | Print usage information.
printUsage ∷ String → IO ()
printUsage prgName = putStrLn $ usageInfo (usageHeader prgName) options
