module Lib where
-- in liquidHaskell extension --no-ghc-package-path
import Data.NumberLength
import Data.List
import GHC.Integer.Logarithms ()
import Math.NumberTheory.Logarithms
import GHC.TypeLits.Extra
import Debug.Trace
import qualified Control.Parallel as CP 
import Data.Time.Clock
import GHC.Conc.Sync

{-- sub-optimal first day code - now bigly deprecated 

getLargerTwoNumbers :: Integer -> Integer -> Integer
getLargerTwoNumbers x y = if abs x >= abs y then x else y

higherPower :: Integer -> Integer
higherPower x  = ceiling (logBase basetwo numberInterest)
                    where basetwo = 2 :: Float 
                          numberInterest = fromInteger (toInteger (numberLength x))

getNextPowerOf2 :: Integer -> Integer
getNextPowerOf2 x = 2 ^ higherPower (abs x)

smallestN_lazy :: Ord a => Int -> [a] -> [a]
smallestN_lazy n = take n . sort


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


karatsubamine :: Integer -> Integer -> Integer
--karatsuba x y = trace ("Entering ktsba with x y " ++ show x ++ "  " ++ show y) $  ksba (getNextPowerOf2 (getLargerTwoNumbers x y))
karatsubamine x y = ksba (max (numDigits x) (numDigits y))
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



--}

{- | Number of Digits in a given number.
@
1234 = 4
43 = 2
@
-}
numDigits :: Integer -> Integer
numDigits 1000 = 4
numDigits x = floor $ logBase 10 (fromInteger x) + 1

splitDigits :: Integer -> Integer -> (Integer, Integer)
splitDigits ab n = (a, b)
  where
    a = floor $ fromInteger ab / 10 ^ n
    b = ab - a * 10 ^ n


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
    digits = max (numDigits ab) (numDigits cd)
    (a, b) = splitDigits ab (digits `div` 2)
    (c, d) = splitDigits cd (digits `div` 2)


karatsubaPar :: Integer -> Integer -> Integer -> Integer
karatsubaPar ab cd cutoff
  | ab <= 10 = ab * cd
  | cd <= 10 = ab * cd
  | (cutoff >= ab) || (cutoff >= cd) = z0 `CP.pseq` z2 `CP.pseq` z1 `CP.pseq` put_together
  | otherwise = (z0 `CP.par` z2) `CP.par` z1 `CP.pseq` put_together
  where
    digits = max (numDigits ab) (numDigits cd)
    (a, b) = splitDigits ab (digits `div` 2)
    (c, d) = splitDigits cd (digits `div` 2)
    z0 = karatsubaPar b d cutoff
    z1 = karatsubaPar (a + b) (c + d) cutoff
    z2 = karatsubaPar a c cutoff
    put_together = z2 * 10 ^ (digits `div` 2 * 2) + (z1 - z2 - z0) * 10 ^ (digits `div` 2) + z0
    

-- time KPar for with the given cutoff
timeCutoff :: Integer -> Integer -> Integer -> IO NominalDiffTime
timeCutoff n1 n2 c = do
  st <- getCurrentTime
  let r = karatsubaPar n1 n2 c
  en <- st `CP.pseq` r `CP.pseq` getCurrentTime
  return $ diffUTCTime en st

-- yup x is not used
timePar :: Integer -> Integer -> Integer -> IO Float
timePar n1 n2 x = do
  cpus <- getNumProcessors
  setNumCapabilities cpus
  st <- getCurrentTime
  let r = karatsubaPar n1 n2 (toInteger cpus)
  en <- st `CP.pseq` r `CP.pseq` getCurrentTime
  return $ fromRational . toRational $ diffUTCTime en st

-- time all cutoffs
timeAll :: Integer -> Integer -> IO [Float]
timeAll n1 n2 = do
  times <- mapM (timeCutoff n1 n2) [max n1 n2 `div` 1, max n1 n2 `div` 2,max n1 n2 `div` 4, max n1 n2 `div` 8, max n1 n2 `div` 16]
  return $ map (fromRational . toRational) times

-- diff between Parallel and Serial for 'times' number of runs 
--sequence $ map replaced by mapM
comp :: Integer -> Integer -> Integer -> IO [Float]
comp n1 n2 times = do
  timesPar <- mapM (timePar n1 n2) $ map (\x -> x `div` x) [1..times]
  timesSer <- mapM (timeSer n1 n2) $ map (\x -> x `div` x) [1..times]
  return $ map (fromRational . toRational) (zipWith (-) timesPar timesSer)

-- time KSer for baseline; x is not used
timeSer :: Integer -> Integer -> Integer -> IO Float
timeSer n1 n2 x = do
  st <- getCurrentTime
  let r = karatsuba n1 n2
  en <- st `CP.pseq` r `CP.pseq` getCurrentTime
  return $ fromRational . toRational $ diffUTCTime en st

someFunc :: IO ()
someFunc = putStrLn "someFunc"
