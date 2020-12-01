module Main where

import qualified Spec as MT
import System.Exit

main :: IO ()
main = hspec $ do
  lib
  -- add test runners into the array for each module
  good <- and <$> sequence [MT.runTests]
  if good
    then exitSuccess
    else exitFailure