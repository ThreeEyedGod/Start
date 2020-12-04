module Lib where
-- in liquidHaskell extension --no-ghc-package-path
import Data.NumberLength
import Data.List
import GHC.Integer.Logarithms ()
import Math.NumberTheory.Logarithms
import GHC.TypeLits.Extra
import Debug.Trace
import Control.Parallel
import Data.Time.Clock


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

myReverse :: Ord a => [a] -> [a]
myReverse [] = []
myReverse xs = sortBy (\x y -> flip compare (elemIndex x xs) (elemIndex y xs)) xs

cutoff :: Int
cutoff = 3

karatsuba :: Integer -> Integer -> Integer
karatsuba ab cd
  | ab <= 10 = ab * cd
  | cd <= 10 = ab * cd
  | otherwise =
    let z0 = karatsuba b d
        z1 = karatsuba (a + b) (c + d)
        z2 = karatsuba a c
     in z2 * 10 ^ (digits `div` 2 * 2) + (z1 - z2 - z0) * 10 ^ (digits `div` 2) + z0
  where
    digits = max (num_digits ab) (num_digits cd)
    (a, b) = split_digits ab (digits `div` 2)
    (c, d) = split_digits cd (digits `div` 2)

karatsubaPar :: Integer -> Integer -> Integer -> Integer
karatsubaPar ab cd cutoff
  | ab <= 10 = ab * cd
  | cd <= 10 = ab * cd
  | otherwise =
    let z0 = karatsuba b d
        z1 = karatsuba (a + b) (c + d)
        z2 = karatsuba a c
     in z2 * 10 ^ (digits `div` 2 * 2) + (z1 - z2 - z0) * 10 ^ (digits `div` 2) + z0
  where
    digits = max (num_digits ab) (num_digits cd)
    (a, b) = split_digits ab (digits `div` 2)
    (c, d) = split_digits cd (digits `div` 2)
    
karatsubamine :: Integer -> Integer -> Integer
--karatsuba x y = trace ("Entering ktsba with x y " ++ show x ++ "  " ++ show y) $  ksba (getNextPowerOf2 (getLargerTwoNumbers x y))
karatsubamine x y = ksba (max (num_digits x) (num_digits y))
    where ksba n
 --           | n <= 1 = trace ("n <= 1 n x y " ++ show n ++ show " " ++ show x ++ " " ++ show y) $ x * y 
 --           | otherwise = trace ( "n = " ++ show n ) $ 10 ^ n * u + 10 ^ (n `div` 2) * z + v
            | (x <= 10) || (y <= 10) = x * y 
            | otherwise = 10 ^ n * u + 10 ^ (n `div` 2) * z + v
            where
                halfLength  = n `div` 2
                (x1, x2) = split_digits x halfLength
                (y1, y2) = split_digits y halfLength
 --               x2 = (signum x) * get2ndHalf (abs x) halfLength
               -- x1 = (signum x) * get1stHalf (abs x) x2
 --               x1 = get1stHalf x x2
 --               y2 = (signum y) * get2ndHalf (abs y) halfLength
 --               y1 = get1stHalf y y2
                u = karatsubamine x1 y1
                v = karatsubamine x2 y2
                --diff1 = x1 - x2
                --diff2 = y1 - y2
                w = karatsubamine (x1 + x2) (y1 + y2) 
                --z = u + v - w
                z = w - u - v 



-- time KPar for with the given cutoff
timeCutoff :: Integer -> Integer -> Integer -> IO NominalDiffTime
timeCutoff n1 n2 c = do
  st <- getCurrentTime
  let r = KaratsubaPar n1 n2 c
  en <- st `pseq` r `pseq` getCurrentTime
  return $ diffUTCTime en st

-- time all cutoffs
timeAll :: Integer -> Integer -> IO [Float]
timeAll n1 n2 = do
  times <- sequence $ map (timeCutoff n1 n2) [0 .. 10]
  return $ map (fromRational . toRational) times

-- time KSer for comparison
timeSer :: Integer -> Integer -> IO Float
timeSer n1 n2 = do
  st <- getCurrentTime
  let r = karatsuba n1 n2
  en <- st `pseq` r `pseq` getCurrentTime
  return $ fromRational . toRational $ diffUTCTime en st


someFunc :: IO ()
someFunc = putStrLn "someFunc"
