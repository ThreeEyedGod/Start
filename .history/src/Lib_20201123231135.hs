module Lib where

-- in liquidHaskell extension --no-ghc-package-path
{-@ type Nat' = { n : Int | n >= 1 } @-}
type Nat' = Int
{-@ atGo :: [a] -> Nat' -> Maybe a @-}
-- {-@ lazy atGo @-} 

atGo :: [a] -> Nat' -> Maybe a
l `atGo` n 
   | (n < 0)      = Nothing
   |  otherwise   = go 0 l
                     where 
                      go :: Int -> [a] -> Maybe a
                      go _ [] = Nothing
                      go i (x : xs) = if i == n then Just x else go (i + 1) xs 


someFunc :: IO ()
someFunc = putStrLn "someFunc"
