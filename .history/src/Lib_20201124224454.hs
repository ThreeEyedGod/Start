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
getNextPowerOf2 x = 2 ^ (1 + integerLogBase 2 (toInteger (numberLength x)))

padNumberBeforeWithZeroes :: Int -> Int
padNumberBeforeWithZeroes x = getNextPowerOf2 x  - numberLength x

halfNumberDigits :: Int -> Int
halfNumberDigits x =  (getNextPowerOf2 x) `div` 2

get2ndHalf :: Int -> Int -> Int
get2ndHalf x halfLength
    | numberLength x == halfLength = x 
    | otherwise = get2ndHalf (x `mod` 10 ^ (numberLength x - 1)) halfLength
    


someFunc :: IO ()
someFunc = putStrLn "someFunc"
