
module Parser (
    parseInstruction,
    Instruction,
    Switch (..),
    getSwitch,
    rowAffected,
    columnAffected,
    testInstructions)
    where

import Data.Char (isDigit, isAlpha, isSpace, digitToInt)

import Control.Applicative

newtype Parser a = P (String -> (Maybe a, String))


parse :: Parser a -> String -> (Maybe a, String)
parse (P f) string = f string


instance Functor Parser where
    fmap f p = 
        P (\s -> 
            let (x, rem) = parse p s in
            (fmap f x, rem)
           )


instance Applicative Parser where
    pure x = P (\s -> (Just x, s))
    f <*> x = 
        P (\s -> 
            let (mf, rem1) = parse f s
                (mx, rem2) = parse x rem1
            in
            case mf of 
                Just f  -> (fmap f mx, rem2)
                Nothing -> (Nothing, rem2)
           )


instance Alternative Parser where
    empty   = P (\s -> (Nothing, s))
    f <|> g = 
        P (\s ->
            case parse f s of 
            (Nothing, _) -> parse g s
            _            -> parse f s
          )


instance Monad Parser where
    return = pure
    mx >>= f = 
        P (\s -> 
            case parse mx s of
                (Just x, rem) -> parse (f x) rem
                (Nothing, rem) -> (Nothing, rem)
          )


char :: Char -> Parser Char
char c =
    P (\s -> 
        case s of 
            (x:xs) -> 
                if x == c then 
                    (Just c, xs)
                else
                    (Nothing, xs)
            []     -> (Nothing, [])
      )


string :: String -> Parser String
string []     = pure ""
string (x:xs) = (:) <$> char x <*> string xs
    

bool :: (Char -> Bool) -> Parser Char
bool p = 
    P (\s -> 
        case s of 
            []     -> (Nothing, "")
            (x:xs) -> if p x then (Just x, xs) else (Nothing, xs)
      )


space :: Parser Char
space = 
    do s <- bool isSpace
       return s


spaces :: Parser String
spaces = many space


digit :: Parser Int
digit = 
    do d <- bool isDigit
       return (digitToInt d)


listToInt :: [Int] -> Int
listToInt = foldl (\n m -> 10 * n + m) 0


int :: Parser Int
int = fmap listToInt (some digit)


data Switch = Toggle | SwitchOn | SwitchOff
    deriving Show
    
data Point = Point Int Int
    deriving Show
    
data Instruction = Instruction Switch Point Point
    deriving Show


rowAffected :: Int -> Instruction -> Bool
rowAffected row (Instruction _ (Point _ y1) (Point _ y2)) =
    y1 <= row && row <= y2


columnAffected :: Int -> Instruction -> Bool
columnAffected col (Instruction _ (Point x1 _) (Point x2 _)) = 
    x1 <= col && col <= x2


getSwitch :: Instruction -> Switch
getSwitch (Instruction switch _ _) = switch


parseType :: String -> a -> Parser a
parseType searchString x = 
    fmap (\_ -> x) (string searchString)


parseSwitch :: Parser Switch
parseSwitch = parseType "toggle" Toggle <|> parseType "turn on" SwitchOn <|> parseType "turn off" SwitchOff 

parsePoint :: Parser Point
parsePoint = 
    do xCoordinate <- int
       char ','
       yCoordinate <- int
       return (Point xCoordinate yCoordinate)


instructionParser :: Parser Instruction
instructionParser = 
    do switch <- parseSwitch
       spaces
       point1 <- parsePoint
       spaces
       string "through"
       spaces
       point2 <- parsePoint 
       return (Instruction switch point1 point2)


parseInstruction :: String -> Maybe Instruction
parseInstruction string = fst (parse instructionParser string)

testInstructions = [Instruction Toggle (Point 461 550) (Point 564 900),Instruction SwitchOff (Point 370 39) (Point 425 839),Instruction SwitchOff (Point 464 858) (Point 833 915),Instruction SwitchOff (Point 812 389) (Point 865 874),Instruction SwitchOn (Point 599 989) (Point 806 993),Instruction SwitchOn (Point 376 415) (Point 768 548),Instruction SwitchOn (Point 606 361) (Point 892 600),Instruction SwitchOff (Point 448 208) (Point 645 684),Instruction Toggle (Point 50 472) (Point 452 788),Instruction Toggle (Point 205 417) (Point 703 826),Instruction Toggle (Point 533 331) (Point 906 873),Instruction Toggle (Point 857 493) (Point 989 970),Instruction SwitchOff (Point 631 950) (Point 894 975),Instruction SwitchOff (Point 387 19) (Point 720 700),Instruction SwitchOff (Point 511 843) (Point 581 945),Instruction Toggle (Point 514 557) (Point 662 883),Instruction SwitchOff (Point 269 809) (Point 876 847),Instruction SwitchOff (Point 149 517) (Point 716 777),Instruction SwitchOff (Point 994 939) (Point 998 988),Instruction Toggle (Point 467 662) (Point 555 957),Instruction SwitchOn (Point 952 417) (Point 954 845),Instruction SwitchOn (Point 565 226) (Point 944 880),Instruction SwitchOn (Point 214 319) (Point 805 722),Instruction Toggle (Point 532 276) (Point 636 847),Instruction Toggle (Point 619 80) (Point 689 507),Instruction SwitchOn (Point 390 706) (Point 884 722),Instruction Toggle (Point 17 634) (Point 537 766),Instruction Toggle (Point 706 440) (Point 834 441),Instruction Toggle (Point 318 207) (Point 499 530),Instruction Toggle (Point 698 185) (Point 830 343),Instruction Toggle (Point 566 679) (Point 744 716),Instruction Toggle (Point 347 482) (Point 959 482),Instruction Toggle (Point 39 799) (Point 981 872),Instruction SwitchOn (Point 583 543) (Point 846 710),Instruction SwitchOff (Point 367 664) (Point 595 872),Instruction SwitchOn (Point 805 439) (Point 964 995),Instruction Toggle (Point 209 584) (Point 513 802),Instruction SwitchOff (Point 106 497) (Point 266 770),Instruction SwitchOn (Point 975 2) (Point 984 623),Instruction SwitchOff (Point 316 684) (Point 369 876),Instruction SwitchOff (Point 30 309) (Point 259 554),Instruction SwitchOff (Point 399 680) (Point 861 942),Instruction Toggle (Point 227 740) (Point 850 829),Instruction SwitchOn (Point 386 603) (Point 552 879),Instruction SwitchOff (Point 703 795) (Point 791 963),Instruction SwitchOff (Point 573 803) (Point 996 878),Instruction SwitchOff (Point 993 939) (Point 997 951),Instruction SwitchOn (Point 809 221) (Point 869 723),Instruction SwitchOff (Point 38 720) (Point 682 751),Instruction SwitchOff (Point 318 732) (Point 720 976),Instruction Toggle (Point 88 459) (Point 392 654),Instruction SwitchOff (Point 865 654) (Point 911 956),Instruction Toggle (Point 264 284) (Point 857 956),Instruction SwitchOff (Point 281 776) (Point 610 797),Instruction Toggle (Point 492 660) (Point 647 910),Instruction SwitchOff (Point 879 703) (Point 925 981),Instruction SwitchOff (Point 772 414) (Point 974 518),Instruction SwitchOn (Point 694 41) (Point 755 96),Instruction SwitchOn (Point 452 406) (Point 885 881),Instruction SwitchOff (Point 107 905) (Point 497 910),Instruction SwitchOff (Point 647 222) (Point 910 532),Instruction SwitchOn (Point 679 40) (Point 845 358),Instruction SwitchOff (Point 144 205) (Point 556 362),Instruction SwitchOn (Point 871 804) (Point 962 878),Instruction SwitchOn (Point 545 676) (Point 545 929),Instruction SwitchOff (Point 316 716) (Point 413 941),Instruction Toggle (Point 488 826) (Point 755 971),Instruction Toggle (Point 957 832) (Point 976 992),Instruction Toggle (Point 857 770) (Point 905 964),Instruction Toggle (Point 319 198) (Point 787 673),Instruction SwitchOn (Point 832 813) (Point 863 844),Instruction SwitchOn (Point 818 296) (Point 818 681),Instruction SwitchOn (Point 71 699) (Point 91 960),Instruction SwitchOff (Point 838 578) (Point 967 928),Instruction Toggle (Point 440 856) (Point 507 942),Instruction Toggle (Point 121 970) (Point 151 974),Instruction Toggle (Point 391 192) (Point 659 751),Instruction SwitchOn (Point 78 210) (Point 681 419),Instruction SwitchOn (Point 324 591) (Point 593 939),Instruction Toggle (Point 159 366) (Point 249 760),Instruction SwitchOff (Point 617 167) (Point 954 601),Instruction Toggle (Point 484 607) (Point 733 657),Instruction SwitchOn (Point 587 96) (Point 888 819),Instruction SwitchOff (Point 680 984) (Point 941 991),Instruction SwitchOn (Point 800 512) (Point 968 691),Instruction SwitchOff (Point 123 588) (Point 853 603),Instruction SwitchOn (Point 1 862) (Point 507 912),Instruction SwitchOn (Point 699 839) (Point 973 878),Instruction SwitchOff (Point 848 89) (Point 887 893),Instruction Toggle (Point 344 353) (Point 462 403),Instruction SwitchOn (Point 780 731) (Point 841 760),Instruction Toggle (Point 693 973) (Point 847 984),Instruction Toggle (Point 989 936) (Point 996 958),Instruction Toggle (Point 168 475) (Point 206 963),Instruction SwitchOn (Point 742 683) (Point 769 845),Instruction Toggle (Point 768 116) (Point 987 396),Instruction SwitchOn (Point 190 364) (Point 617 526),Instruction SwitchOff (Point 470 266) (Point 530 839),Instruction Toggle (Point 122 497) (Point 969 645),Instruction SwitchOff (Point 492 432) (Point 827 790),Instruction SwitchOn (Point 505 636) (Point 957 820),Instruction SwitchOn (Point 295 476) (Point 698 958),Instruction Toggle (Point 63 298) (Point 202 396),Instruction SwitchOn (Point 157 315) (Point 412 939),Instruction SwitchOff (Point 69 789) (Point 134 837),Instruction SwitchOff (Point 678 335) (Point 896 541),Instruction Toggle (Point 140 516) (Point 842 668),Instruction SwitchOff (Point 697 585) (Point 712 668),Instruction Toggle (Point 507 832) (Point 578 949),Instruction SwitchOn (Point 678 279) (Point 886 621),Instruction Toggle (Point 449 744) (Point 826 910),Instruction SwitchOff (Point 835 354) (Point 921 741),Instruction Toggle (Point 924 878) (Point 985 952),Instruction SwitchOn (Point 666 503) (Point 922 905),Instruction SwitchOn (Point 947 453) (Point 961 587),Instruction Toggle (Point 525 190) (Point 795 654),Instruction SwitchOff (Point 62 320) (Point 896 362),Instruction SwitchOn (Point 21 458) (Point 972 536),Instruction SwitchOn (Point 446 429) (Point 821 970),Instruction Toggle (Point 376 423) (Point 805 455),Instruction Toggle (Point 494 896) (Point 715 937),Instruction SwitchOn (Point 583 270) (Point 667 482),Instruction SwitchOff (Point 183 468) (Point 280 548),Instruction Toggle (Point 623 289) (Point 750 524),Instruction SwitchOn (Point 836 706) (Point 967 768),Instruction SwitchOn (Point 419 569) (Point 912 908),Instruction SwitchOn (Point 428 260) (Point 660 433),Instruction SwitchOff (Point 683 627) (Point 916 816),Instruction SwitchOn (Point 447 973) (Point 866 980),Instruction SwitchOn (Point 688 607) (Point 938 990),Instruction SwitchOn (Point 245 187) (Point 597 405),Instruction SwitchOff (Point 558 843) (Point 841 942),Instruction SwitchOff (Point 325 666) (Point 713 834),Instruction Toggle (Point 672 606) (Point 814 935),Instruction SwitchOff (Point 161 812) (Point 490 954),Instruction SwitchOn (Point 950 362) (Point 985 898),Instruction SwitchOn (Point 143 22) (Point 205 821),Instruction SwitchOn (Point 89 762) (Point 607 790),Instruction Toggle (Point 234 245) (Point 827 303),Instruction SwitchOn (Point 65 599) (Point 764 997),Instruction SwitchOn (Point 232 466) (Point 965 695),Instruction SwitchOn (Point 739 122) (Point 975 590),Instruction SwitchOff (Point 206 112) (Point 940 558),Instruction Toggle (Point 690 365) (Point 988 552),Instruction SwitchOn (Point 907 438) (Point 977 691),Instruction SwitchOff (Point 838 809) (Point 944 869),Instruction SwitchOn (Point 222 12) (Point 541 832),Instruction Toggle (Point 337 66) (Point 669 812),Instruction SwitchOn (Point 732 821) (Point 897 912),Instruction Toggle (Point 182 862) (Point 638 996),Instruction SwitchOn (Point 955 808) (Point 983 847),Instruction Toggle (Point 346 227) (Point 841 696),Instruction SwitchOn (Point 983 270) (Point 989 756),Instruction SwitchOff (Point 874 849) (Point 876 905),Instruction SwitchOff (Point 7 760) (Point 678 795),Instruction Toggle (Point 973 977) (Point 995 983),Instruction SwitchOff (Point 911 961) (Point 914 976),Instruction SwitchOn (Point 913 557) (Point 952 722),Instruction SwitchOff (Point 607 933) (Point 939 999),Instruction SwitchOn (Point 226 604) (Point 517 622),Instruction SwitchOff (Point 3 564) (Point 344 842),Instruction Toggle (Point 340 578) (Point 428 610),Instruction SwitchOn (Point 248 916) (Point 687 925),Instruction Toggle (Point 650 185) (Point 955 965),Instruction Toggle (Point 831 359) (Point 933 536),Instruction SwitchOff (Point 544 614) (Point 896 953),Instruction Toggle (Point 648 939) (Point 975 997),Instruction SwitchOn (Point 464 269) (Point 710 521),Instruction SwitchOff (Point 643 149) (Point 791 320),Instruction SwitchOff (Point 875 549) (Point 972 643),Instruction SwitchOff (Point 953 969) (Point 971 972),Instruction SwitchOff (Point 236 474) (Point 772 591),Instruction Toggle (Point 313 212) (Point 489 723),Instruction Toggle (Point 896 829) (Point 897 837),Instruction Toggle (Point 544 449) (Point 995 905),Instruction SwitchOff (Point 278 645) (Point 977 876),Instruction SwitchOff (Point 887 947) (Point 946 977),Instruction SwitchOn (Point 342 861) (Point 725 935),Instruction SwitchOn (Point 636 316) (Point 692 513),Instruction Toggle (Point 857 470) (Point 950 528),Instruction SwitchOff (Point 736 196) (Point 826 889),Instruction SwitchOn (Point 17 878) (Point 850 987),Instruction SwitchOn (Point 142 968) (Point 169 987),Instruction SwitchOn (Point 46 470) (Point 912 853),Instruction SwitchOn (Point 182 252) (Point 279 941),Instruction Toggle (Point 261 143) (Point 969 657),Instruction SwitchOff (Point 69 600) (Point 518 710),Instruction SwitchOn (Point 372 379) (Point 779 386),Instruction Toggle (Point 867 391) (Point 911 601),Instruction SwitchOff (Point 174 287) (Point 900 536),Instruction Toggle (Point 951 842) (Point 993 963),Instruction SwitchOff (Point 626 733) (Point 985 827),Instruction Toggle (Point 622 70) (Point 666 291),Instruction SwitchOff (Point 980 671) (Point 985 835),Instruction SwitchOff (Point 477 63) (Point 910 72),Instruction SwitchOff (Point 779 39) (Point 940 142),Instruction SwitchOn (Point 986 570) (Point 997 638),Instruction Toggle (Point 842 805) (Point 943 985),Instruction SwitchOff (Point 890 886) (Point 976 927),Instruction SwitchOff (Point 893 172) (Point 897 619),Instruction SwitchOff (Point 198 780) (Point 835 826),Instruction Toggle (Point 202 209) (Point 219 291),Instruction SwitchOff (Point 193 52) (Point 833 283),Instruction Toggle (Point 414 427) (Point 987 972),Instruction SwitchOn (Point 375 231) (Point 668 236),Instruction SwitchOff (Point 646 598) (Point 869 663),Instruction Toggle (Point 271 462) (Point 414 650),Instruction SwitchOff (Point 679 121) (Point 845 467),Instruction Toggle (Point 76 847) (Point 504 904),Instruction SwitchOff (Point 15 617) (Point 509 810),Instruction Toggle (Point 248 105) (Point 312 451),Instruction SwitchOff (Point 126 546) (Point 922 879),Instruction SwitchOn (Point 531 831) (Point 903 872),Instruction Toggle (Point 602 431) (Point 892 792),Instruction SwitchOff (Point 795 223) (Point 892 623),Instruction Toggle (Point 167 721) (Point 533 929),Instruction Toggle (Point 813 251) (Point 998 484),Instruction Toggle (Point 64 640) (Point 752 942),Instruction SwitchOn (Point 155 955) (Point 892 985),Instruction SwitchOn (Point 251 329) (Point 996 497),Instruction SwitchOff (Point 341 716) (Point 462 994),Instruction Toggle (Point 760 127) (Point 829 189),Instruction SwitchOn (Point 86 413) (Point 408 518),Instruction Toggle (Point 340 102) (Point 918 558),Instruction SwitchOff (Point 441 642) (Point 751 889),Instruction SwitchOn (Point 785 292) (Point 845 325),Instruction SwitchOff (Point 123 389) (Point 725 828),Instruction SwitchOn (Point 905 73) (Point 983 270),Instruction SwitchOff (Point 807 86) (Point 879 276),Instruction Toggle (Point 500 866) (Point 864 916),Instruction SwitchOn (Point 809 366) (Point 828 534),Instruction Toggle (Point 219 356) (Point 720 617),Instruction SwitchOff (Point 320 964) (Point 769 990),Instruction SwitchOff (Point 903 167) (Point 936 631),Instruction Toggle (Point 300 137) (Point 333 693),Instruction Toggle (Point 5 675) (Point 755 848),Instruction SwitchOff (Point 852 235) (Point 946 783),Instruction Toggle (Point 355 556) (Point 941 664),Instruction SwitchOn (Point 810 830) (Point 867 891),Instruction SwitchOff (Point 509 869) (Point 667 903),Instruction Toggle (Point 769 400) (Point 873 892),Instruction SwitchOn (Point 553 614) (Point 810 729),Instruction SwitchOn (Point 179 873) (Point 589 962),Instruction SwitchOff (Point 466 866) (Point 768 926),Instruction Toggle (Point 143 943) (Point 465 984),Instruction Toggle (Point 182 380) (Point 569 552),Instruction SwitchOff (Point 735 808) (Point 917 910),Instruction SwitchOn (Point 731 802) (Point 910 847),Instruction SwitchOff (Point 522 74) (Point 731 485),Instruction SwitchOn (Point 444 127) (Point 566 996),Instruction SwitchOff (Point 232 962) (Point 893 979),Instruction SwitchOff (Point 231 492) (Point 790 976),Instruction SwitchOn (Point 874 567) (Point 943 684),Instruction Toggle (Point 911 840) (Point 990 932),Instruction Toggle (Point 547 895) (Point 667 935),Instruction SwitchOff (Point 93 294) (Point 648 636),Instruction SwitchOff (Point 190 902) (Point 532 970),Instruction SwitchOff (Point 451 530) (Point 704 613),Instruction Toggle (Point 936 774) (Point 937 775),Instruction SwitchOff (Point 116 843) (Point 533 934),Instruction SwitchOn (Point 950 906) (Point 986 993),Instruction SwitchOn (Point 910 51) (Point 945 989),Instruction SwitchOn (Point 986 498) (Point 994 945),Instruction SwitchOff (Point 125 324) (Point 433 704),Instruction SwitchOff (Point 60 313) (Point 75 728),Instruction SwitchOn (Point 899 494) (Point 940 947),Instruction Toggle (Point 832 316) (Point 971 817),Instruction Toggle (Point 994 983) (Point 998 984),Instruction Toggle (Point 23 353) (Point 917 845),Instruction Toggle (Point 174 799) (Point 658 859),Instruction SwitchOff (Point 490 878) (Point 534 887),Instruction SwitchOff (Point 623 963) (Point 917 975),Instruction Toggle (Point 721 333) (Point 816 975),Instruction Toggle (Point 589 687) (Point 890 921),Instruction SwitchOn (Point 936 388) (Point 948 560),Instruction SwitchOff (Point 485 17) (Point 655 610),Instruction SwitchOn (Point 435 158) (Point 689 495),Instruction SwitchOn (Point 192 934) (Point 734 936),Instruction SwitchOff (Point 299 723) (Point 622 847),Instruction Toggle (Point 484 160) (Point 812 942),Instruction SwitchOff (Point 245 754) (Point 818 851),Instruction SwitchOn (Point 298 419) (Point 824 634),Instruction Toggle (Point 868 687) (Point 969 760),Instruction Toggle (Point 131 250) (Point 685 426),Instruction SwitchOff (Point 201 954) (Point 997 983),Instruction SwitchOn (Point 353 910) (Point 832 961),Instruction SwitchOff (Point 518 781) (Point 645 875),Instruction SwitchOff (Point 866 97) (Point 924 784),Instruction Toggle (Point 836 599) (Point 857 767),Instruction SwitchOn (Point 80 957) (Point 776 968),Instruction Toggle (Point 277 130) (Point 513 244),Instruction SwitchOff (Point 62 266) (Point 854 434),Instruction SwitchOn (Point 792 764) (Point 872 842),Instruction SwitchOff (Point 160 949) (Point 273 989),Instruction SwitchOff (Point 664 203) (Point 694 754),Instruction Toggle (Point 491 615) (Point 998 836),Instruction SwitchOff (Point 210 146) (Point 221 482),Instruction SwitchOff (Point 209 780) (Point 572 894),Instruction SwitchOn (Point 766 112) (Point 792 868),Instruction SwitchOn (Point 222 12) (Point 856 241)]
