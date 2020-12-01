module Lib where

-- in liquidHaskell extension --no-ghc-package-path

getLargerTwoNumbers :: Nat -> Nat
getLargerTwoNumbers X Y = if (X >= Y) then X else Y

someFunc :: IO ()
someFunc = putStrLn "someFunc"
