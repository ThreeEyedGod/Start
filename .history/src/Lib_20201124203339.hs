module Lib where

-- in liquidHaskell extension --no-ghc-package-path

getLargerTwoNumbers :: Int -> Int -> Int
getLargerTwoNumbers x y = if (abs x >= abs y) then x else y

{-@ type Nat' = { n : Int | n >= 1 } @-}
type Nat' = Int

getNumDigits :: Int -> Int
getNumDigits x  = numberLength x


someFunc :: IO ()
someFunc = putStrLn "someFunc"
