{-# LANGUAGE TemplateHaskell #-}
-- above is what allows the checking of all properties starting with prop_

module Spec where
import Data.Monoid (mempty)
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Options (TestOptions, TestOptions' (..))
import Test.Framework.Runners.Options (RunnerOptions, RunnerOptions' (..))
import Test.Framework.Providers.QuickCheck2 (testProperty)


import Test.QuickCheck

import Lib ()

my_test_opts :: TestOptions
my_test_opts = mempty { topt_maximum_generated_tests = Just 20 }

my_runner_opts :: RunnerOptions
my_runner_opts = mempty {ropt_test_options = Just my_test_opts}

tests = [
        testGroup "Sorting Group 1" [
                testProperty "prop1" prop1,
                testProperty "prop2" prop2
           ]
      ]
-- Rigorous test arguments.
rigorousArgs :: Args
rigorousArgs =
  Args
    { replay = Nothing,
      maxSuccess = 10, -- tests to run
      maxDiscardRatio = 5, -- the number of tests that are thrown out and ignored b/c of "==>" conditions, before "giving up" and failing due to too many discarded tests
      maxSize    = 10, -- if a prop_ function uses a list ([]) type, maxSize is the max length of the randomly generated list
      chatty = True,
      maxShrinks = 5
    }

prop1 b = b == False
  where types = (b :: Bool)

prop2 i = i == 42
  where types = (i :: Int)

return []
runTests = $forAllProperties (quickCheckWithResult rigorousArgs)