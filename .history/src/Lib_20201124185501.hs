module Lib where

-- in liquidHaskell extension --no-ghc-package-path

getLargerTwoNumbers :: Int -> Int -> Int
getLargerTwoNumbers x y = if (x >= y) then x else y

someFunc :: IO ()
someFunc = putStrLn "someFunc"
