module Main where

import Lib

n1 :: Integer
n1 = 100000000

n2 :: Integer
n2 = 123456789

main :: IO ()
main = do
  secs <- timeAll n1 n2
  ser <- timeSer n1 n2
  --putStrLn $ chartURL n ser secs

