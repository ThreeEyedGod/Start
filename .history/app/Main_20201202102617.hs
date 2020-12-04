module Main where

import Lib

joinstr :: String -> [String] -> String
joinstr _ [] = ""
joinstr _ (w : []) = w
joinstr sep (w : ws) = w ++ sep ++ joinstr sep ws

-- produce the URL for the Google Chart
chartURL :: Integer -> Integer -> Float -> [Float] -> String
chartURL n1 n2 ser pars =
  let largest = maximum pars
   in -- Google needs values scaled to out-of-100
      let scale = 100 / largest
       in "https://chart.googleapis.com/chart?cht=lc&chs=500x250&chxt=x,x,y,y&chxl=1:|serial%20cutoff|3:|seconds&chco=FF0000,0000FF&chdl=kSer|kPar&chxp=1,50|3,50&chxr=0,0,"
            ++ (show $ n2 + 1)
            ++ "|2,0,"
            ++ (show largest)
            ++ "&chg="
            ++ (show $ 100.0 / (fromIntegral n2 + 1) * 5.0)
            ++ ",25&chd=t:"
            ++ (show $ scale * ser)
            ++ ","
            ++ (show $ scale * ser)
            ++ "|"
            ++ (joinstr "," $ map (show . (* scale)) pars)


n1 :: Integer
n1 = 100000000

n2 :: Integer
n2 = 123456789

main :: IO ()
main = do
  secs <- timeAll n1 n2
  ser <- timeSer n1 n2
  putStrLn $ chartURL n1 n2 ser secs

