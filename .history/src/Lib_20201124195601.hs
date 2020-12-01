module Lib where

-- in liquidHaskell extension --no-ghc-package-path

getLargerTwoNumbers :: Int -> Int -> Int
getLargerTwoNumbers x y = if (abs x >= abs y) then x else y

{-@ type Nat' = { n : Int | n >= 1 } @-}
type Nat' = Int
getNumDigits :: Int -> Nat'
getNumDigits x  
  | abs x `div` 10 == 0 = 1
  | otherwise = 1+ getNumDigits (abs x) `mod` 10

someFunc :: IO ()
someFunc = putStrLn "someFunc"
