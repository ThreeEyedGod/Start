module Main where
import Test.Hspec (hspec)
import qualified Spec as MT
import System.Exit

main :: IO ()
main = hspec $ do
 {
  MT.lib
  -- add test runners into the array for each module
  goodProps <- and <$> sequence [MT.runTests]
  if goodProps
    then exitSuccess
    else exitFailure
 }