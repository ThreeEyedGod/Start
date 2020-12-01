{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_start (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/95a56931a19a5325dfd98916dc1b6a88b7e88068d137bd599009901ae57cb716/8.10.1/bin"
libdir     = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/95a56931a19a5325dfd98916dc1b6a88b7e88068d137bd599009901ae57cb716/8.10.1/lib/x86_64-osx-ghc-8.10.1/start-0.1.0.0-6zeiVOMq6rE8HWwFMkRPqd-start-test"
dynlibdir  = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/95a56931a19a5325dfd98916dc1b6a88b7e88068d137bd599009901ae57cb716/8.10.1/lib/x86_64-osx-ghc-8.10.1"
datadir    = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/95a56931a19a5325dfd98916dc1b6a88b7e88068d137bd599009901ae57cb716/8.10.1/share/x86_64-osx-ghc-8.10.1/start-0.1.0.0"
libexecdir = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/95a56931a19a5325dfd98916dc1b6a88b7e88068d137bd599009901ae57cb716/8.10.1/libexec/x86_64-osx-ghc-8.10.1/start-0.1.0.0"
sysconfdir = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/95a56931a19a5325dfd98916dc1b6a88b7e88068d137bd599009901ae57cb716/8.10.1/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "start_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "start_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "start_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "start_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "start_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "start_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
