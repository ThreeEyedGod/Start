module Lib where
-- in liquidHaskell extension --no-ghc-package-path
import Data.NumberLength
import GHC.Integer.Logarithms ()
import Math.NumberTheory.Logarithms
import GHC.TypeLits.Extra

getLargerTwoNumbers :: Int -> Int -> Int
getLargerTwoNumbers x y = if (abs x >= abs y) then x else y

getNextPowerOf2 :: Int -> Int
-- getNextPowerOf2 x = 2 ^ integerLogBase 2 (toInteger (numberLength x))
getNextPowerOf2 x = 2 ^ toInteger (ceiling realToFrac (logBase 2 numberLength x))

padNumberBeforeWithZeroes :: Int -> Int
padNumberBeforeWithZeroes x = getNextPowerOf2 x  - numberLength x

halfNumberDigits :: Int -> Int
halfNumberDigits x =  (getNextPowerOf2 x) `div` 2

get2ndHalf :: Int -> Int -> Int
get2ndHalf x halfLength
    | numberLength x == halfLength = x 
    | otherwise = get2ndHalf (x `mod` 10 ^ (numberLength x - 1)) halfLength
    
get1stHalf :: Int -> Int -> Int
get1stHalf x y = 
    (x - y) `div` 10 ^ numberLength y

karatsuba :: Int -> Int -> Int
karatsuba x y = ksba (getNextPowerOf2 (getLargerTwoNumbers x y))
    where ksba n
            | n == 1 = x * y 
            | otherwise = 10^n * u + 10 ^ (n `div` 2) * z + v
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
