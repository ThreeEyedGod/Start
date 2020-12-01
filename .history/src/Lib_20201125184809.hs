module Lib where
-- in liquidHaskell extension --no-ghc-package-path
import Data.NumberLength
import GHC.Integer.Logarithms ()
import Math.NumberTheory.Logarithms
import GHC.TypeLits.Extra
import Debug.Trace

getLargerTwoNumbers :: Integer -> Integer -> Integer
getLargerTwoNumbers x y = if (abs x >= abs y) then x else y

higherPower :: Integer -> Integer
higherPower x  = ceiling (logBase basetwo numberInterest)
                    where basetwo = 2 :: Float 
                          numberInterest = fromInteger (toInteger (numberLength x))

getNextPowerOf2 :: Integer -> Integer
getNextPowerOf2 x = 2 ^ higherPower (abs x)

padNumberBeforeWithZeroes :: Integer -> Integer
padNumberBeforeWithZeroes x = getNextPowerOf2 x  - toInteger (numberLength x)

get2ndHalf :: Integer -> Integer -> Integer
get2ndHalf x halfLength
    | x == 0 = 0 
    | toInteger (numberLength x) <= halfLength = x 
    | otherwise = get2ndHalf (x `mod` 10 ^ (numberLength x - 1)) halfLength
    
get1stHalf :: Integer -> Integer -> Integer
get1stHalf x secondHalf = 
    (x - secondHalf) `div` 10 ^ numberLength secondHalf

karatsuba :: Integer -> Integer -> Integer
--karatsuba x y = trace ("Entering k = " ++ show x ++ "  " ++ show y) $  ksba (getNextPowerOf2 (getLargerTwoNumbers x y))
karatsuba x y = ksba (getNextPowerOf2 (getLargerTwoNumbers x y))
    where ksba n
--            | n <= 1 = trace ("n <= 1 n x y " ++ show n ++ show " " ++ show x ++ " " ++ show y) $ x * y 
--            | otherwise = trace ( "n = " ++ show n ) $ 10 ^ n * u + 10 ^ (n `div` 2) * z + v
            | n <= 1 = x * y 
            | otherwise = 10 ^ n * u + 10 ^ (n `div` 2) * z + v
            where
                halfLength  = n `div` 2
                x2 = get2ndHalf x halfLength
                x1 = get1stHalf x x2
                y2 = get2ndHalf y halfLength
                y1 = get1stHalf y y2
                u = karatsuba x1 y1
                v = karatsuba x2 y2
                w = karatsuba (x1 - x2) (y1 - y2)
                z = u + v - w




someFunc :: IO ()
someFunc = putStrLn "someFunc"
