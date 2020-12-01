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

getHalves :: Integer -> Integer -> (Integer, Integer) 
getHalves x d = (l,r)
  where 
    r = get2ndHalf x (d `div` 2)
    l = get1stHalf x r

-- 2nd half  = right side half
get2ndHalf :: Integer -> Integer -> Integer
get2ndHalf x halfLength
    | x == 0 = 0 
    | toInteger (numberLength x) <= halfLength = x
    | otherwise = get2ndHalf (x `mod` 10 ^ (numberLength x - 1)) halfLength

-- 1st half = left side half    
get1stHalf :: Integer -> Integer -> Integer
get1stHalf x secondHalf = 
 --  (signum x) * ((abs x) - (abs secondHalf)) `div` 10 ^ numberLength secondHalf
 --   ((abs x) - (abs secondHalf)) `div` 10 ^ numberLength secondHalf
   (x - secondHalf) `div` 10 ^ numberLength secondHalf

num_digits :: Integer -> Integer
num_digits 1000 = 4
num_digits x = floor $ logBase 10 (fromInteger x) + 1

split_digits :: Integer -> Integer -> (Integer, Integer)
split_digits ab n = (a, b)
  where
    a = floor $ (fromInteger ab) / 10 ^ n
    b = ab - a * 10 ^ n


karatsuba :: Integer -> Integer -> Integer
karatsuba x y
    | (x <= 10) || (y <= 10) = x * y
    | otherwise = u * 10 ^ (n `div` 2 * 2) + (u + v - w) * 10 ^ (n `div` 2) + v
  where
      n = getNextPowerOf2 (getLargerTwoNumbers x y)
      (x1, x2) = getHalves x n
      (y1, y2) = getHalves y n
      u = karatsuba x2 y2
      w = karatsuba (x1 - x2) (y1 - y2)
      v = karatsuba x1 y1


someFunc :: IO ()
someFunc = putStrLn "someFunc"
