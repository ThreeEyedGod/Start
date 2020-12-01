module Lib where
-- in liquidHaskell extension --no-ghc-package-path
import Data.NumberLength
import GHC.Integer.Logarithms ()
import Math.NumberTheory.Logarithms

getLargerTwoNumbers :: Int -> Int -> Int
getLargerTwoNumbers x y = if (abs x >= abs y) then x else y

{-@ type Nat' = { n : Int | n >= 1 } @-}
type Nat' = Int

getNextPowerOf2 :: Int -> Int
getNextPowerOf2 x = integerLogBase 2 (numberLength x) :: Integer



someFunc :: IO ()
someFunc = putStrLn "someFunc"
