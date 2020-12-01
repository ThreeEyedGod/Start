{-# LANGUAGE TemplateHaskell #-}
-- above is what allows the checking of all properties starting with prop_

module Spec where
import Data.Monoid (mempty)
import Test.Framework (defaultMain, testGroup)
import Test.Framework.Options (TestOptions, TestOptions' (..))
import Test.Framework.Runners.Options (RunnerOptions, RunnerOptions' (..))
import Test.Framework.Providers.QuickCheck2 (testProperty)
import Test.Hspec (Spec, describe, it, shouldBe)
import Test.Hspec.Core.QuickCheck (modifyMaxSuccess)

import qualified Hedgehog.Range as Range (linear)
import qualified Hedgehog.Gen as Gen (int)

import Test.Hspec.Hedgehog (hedgehog, (===), forAll)


import Test.QuickCheck

import Lib

lib :: Spec
lib = describe "Lib" $ do
    libhelper
    libadvanced
    libProperty
  

libhelper :: Spec
libhelper = describe "LibHelper" $ do
    describe "getLargerTwoNumbers : " $ do
        it "returns getLargerTwoNumbers Int Int for 2531 1467" $ getLargerTwoNumbers 2531 1467 `shouldBe` 2531
    describe "higherPower : " $ do
        it "returns higher power of 2 for 2531" $ higherPower 2531 `shouldBe` 2
    describe "higherPower : " $ do
      it "returns higher power of 2 for 123" $ higherPower 123 `shouldBe` 2
    describe "higherPower : " $ do
        it "returns higher power of 2 for 5" $ higherPower 5 `shouldBe` 0
    describe "higherPower : " $ do
      it "returns higher power of 2 for 42531" $ higherPower 42531 `shouldBe` 3
    describe "getNextPowerOf2 : " $ do
        it "returns next power of 2 for 2531" $ getNextPowerOf2 2531 `shouldBe` 4
    describe "getNextPowerOf2 : " $ do
        it "returns next power of 2 for 1232531" $ getNextPowerOf2 1232531 `shouldBe` 8
    
    describe "get2ndHalf : " $ do
        it "returns 2nd half for karatsuba 32421" $  get2ndHalf 32421 4 `shouldBe` 2421
    describe "get1stHalf : " $ do
        it "returns 1st half for karatsuba 742421" $  get1stHalf 742421 2421 `shouldBe` 74

    describe "get2ndHalf : " $ do   
        it "returns 2nd half for karatsuba -51" $ get2ndHalf (-51) 2 `shouldBe` (-51)
    describe "get1stHalf : " $ do
        it "returns 1st half for karatsuba -51" $ get1stHalf (-51) (-51) `shouldBe` 0

    describe "get2ndHalf : " $ do
        it "returns 2nd half for karatsuba 1232531" $ get2ndHalf 1232531 4 `shouldBe` 2531
    describe "get1stHalf : " $ do
        it "returns 1st half for karatsuba 1232531" $ get1stHalf 1232531 2531 `shouldBe` 123
    describe "get2ndHalf : " $ do
        it "returns 2nd half for karatsuba 51467" $ get2ndHalf 51467 4 `shouldBe` 1467
    describe "get1stHalf : " $ do
        it "returns 1st half for karatsuba 51467" $ get1stHalf 51467 1467 `shouldBe` 5
        
    describe "karatsuba : 2531 * 1467 " $ do
        it "returns karatsuba 2531 x 1467 " $  karatsuba 2531 1467 `shouldBe` 3712977
    describe "karatsuba : 12351 * 1467 " $ do
        it "returns karatsuba 12531 x 1467 " $ karatsuba 12531 1467 `shouldBe` (12531 * 1467)
    describe "karatsuba : 123 * 5 " $ do
        it "returns karatsuba 123 x 5 " $ karatsuba 123 5 `shouldBe` (123 * 5)
    describe "karatsuba : 1232531 * 51467 " $ do
        it "returns karatsuba 1232531 x 51467 " $ karatsuba 1232531 51467 `shouldBe` (1232531 * 51467)
    describe "karatsuba : 123456789 * 987654321 " $ do
        it "returns karatsuba 123456789 * 987654321 " $ karatsuba 123456789 987654321 `shouldBe` (123456789 * 987654321)
    describe "karatsuba : 234567890124464673737771818 * 1836535353547474646282828282 " $ do
        it "returns karatsuba 234567890124464673737771818 * 1836535353547474646282828282  " $ karatsuba 234567890124464673737771818 1836535353547474646282828282  `shouldBe` (234567890124464673737771818 * 1836535353547474646282828282 )



libadvanced :: Spec
libadvanced = describe "Libdvanced" $
    describe "Function2: f2" $ do
        it "f2 0" $ id 0 `shouldBe` 0

libProperty :: Spec
libProperty = describe "LibProperty" $
    describe "prop_3  " $ do
        modifyMaxSuccess (const 10000000) $ it "karatsuba x y " $ property $
           prop_3

my_test_opts :: TestOptions
my_test_opts = mempty { topt_maximum_generated_tests = Just 20 }

my_runner_opts :: RunnerOptions
my_runner_opts = mempty {ropt_test_options = Just my_test_opts}

tests = [
        testGroup "Sorting Group 1" [
                testProperty "prop1" prop1,
                testProperty "prop2" prop2,
                testProperty "prop3" prop_3
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


prop_3 :: Integer -> Integer -> Property 
prop_3 f s = f > 100000000000000000000000 ==> s > 100000000000000000000000 ==> collect (num_digits f) $ (karatsuba f s == (f * s))

return []
runTests = $forAllProperties (quickCheckWithResult rigorousArgs)