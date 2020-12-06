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

bindir     = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/d93d48b24b077668d9bf23537153857474f7effd2ec19d4ae257992a0d33b1ea/8.10.2/bin"
libdir     = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/d93d48b24b077668d9bf23537153857474f7effd2ec19d4ae257992a0d33b1ea/8.10.2/lib/x86_64-osx-ghc-8.10.2/start-0.1.0.0-2loXNs1j8jODrAu8TNyU0i-start-exe"
dynlibdir  = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/d93d48b24b077668d9bf23537153857474f7effd2ec19d4ae257992a0d33b1ea/8.10.2/lib/x86_64-osx-ghc-8.10.2"
datadir    = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/d93d48b24b077668d9bf23537153857474f7effd2ec19d4ae257992a0d33b1ea/8.10.2/share/x86_64-osx-ghc-8.10.2/start-0.1.0.0"
libexecdir = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/d93d48b24b077668d9bf23537153857474f7effd2ec19d4ae257992a0d33b1ea/8.10.2/libexec/x86_64-osx-ghc-8.10.2/start-0.1.0.0"
sysconfdir = "/Users/bumrap/Documents/code/start/.stack-work/install/x86_64-osx/d93d48b24b077668d9bf23537153857474f7effd2ec19d4ae257992a0d33b1ea/8.10.2/etc"

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
