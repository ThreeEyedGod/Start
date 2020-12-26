module Main where
import Test.Hspec (hspec)
import qualified Spec as MT
import System.Exit
import Debug.Trace


main :: IO ()
main = do
  hspec $ do 
    trace " before goodProps " MT.lib 
  -- add test runners into the array for each module
  {--goodProps <- and <$> sequence [MT.runTests]
  if trace (" after goodProps ") $ goodProps
    then exitSuccess
    else exitFailure
  --}
