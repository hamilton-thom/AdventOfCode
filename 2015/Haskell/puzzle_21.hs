
import Data.List (sort)
import GHC.Float (int2Double)

newtype Cost = Cost Int
    deriving (Eq, Ord, Show)
newtype Damage = Damage Int
    deriving (Eq, Ord, Show)
newtype Armour = Armour Int
    deriving (Eq, Ord, Show)

type Info = (Cost, Damage, Armour)
data Stats = Stats Int Damage Armour
    deriving (Eq, Ord, Show)
data Character = Player Stats | Boss Stats
    deriving (Eq, Ord, Show)


getStats :: Character -> Stats
getStats (Player stats) = stats
getStats (Boss stats) = stats


updateHP :: Int -> Character -> Character
updateHP hpChange (Player (Stats hp d a)) = Player (Stats (hp + hpChange) d a)
updateHP hpChange (Boss (Stats hp d a)) = Boss (Stats (hp + hpChange) d a)


hpDecrease :: Character -> Character -> Int
hpDecrease attacker defender = 
    max 1 (damageAttacker - armourDefender)
    where        
        Stats _ (Damage damageAttacker) _ = getStats attacker
        Stats hpDefender _ (Armour armourDefender) = getStats defender


toInfo :: (Int, Int, Int) -> Info
toInfo (cost, damage, armour) = (Cost cost, Damage damage, Armour armour)


weapons :: [Info]
weapons = map toInfo [(8, 4, 0), (10, 5, 0), (25, 6, 0), (40, 7, 0), (74, 8, 0)]


armour :: [Info]
armour = map toInfo [(0, 0, 0), (13, 0, 1), (31, 0, 2), (53, 0, 3), (75, 0, 4), (102, 0, 5)]


rings :: [Info]
rings = map toInfo [(0, 0, 0), (25, 1, 0), (50, 2, 0), (100, 3, 0), (20, 0, 1), (40, 0, 1), (80, 0, 3)]


ringCombinations = (Cost 0, Damage 0, Armour 0) : (map collapsePair $ filter (\(a,b) -> a < b) ((,) <$> rings <*> rings ))


collapsePair :: (Info, Info) -> Info
collapsePair
    ((Cost c1, Damage d1, Armour a1)
    ,(Cost c2, Damage d2, Armour a2)    
    ) = 
    (Cost (c1 + c2), Damage (d1 + d2), Armour (a1 + a2))


collapseTriple :: (Info, Info, Info) -> Info
collapseTriple 
    ((Cost c1, Damage d1, Armour a1)
    ,(Cost c2, Damage d2, Armour a2)
    ,(Cost c3, Damage d3, Armour a3)
    ) = 
    (Cost (c1 + c2 + c3), Damage (d1 + d2 + d3), Armour (a1 + a2 + a3))


allCombos :: [Info]
allCombos = sort $ map collapseTriple $ (,,) <$> weapons <*> armour <*> ringCombinations


playerWin :: Character -> Character -> Bool
playerWin boss player = playerSurvivalTurns >= bossSurvivalTurns 
    where
        playerAttack = hpDecrease player boss
        bossAttack = hpDecrease boss player
        Stats playerHP _ _ = getStats player
        Stats bossHP _ _ = getStats boss
        turnsSurvival hp attack = ceiling $ (int2Double hp) / (int2Double attack)
        playerSurvivalTurns = turnsSurvival playerHP bossAttack
        bossSurvivalTurns = turnsSurvival bossHP playerAttack


thisBoss = Boss (Stats 103 (Damage 9) (Armour 2))


cheapestWin :: [Info] -> Character -> (Character, Info)
cheapestWin combos boss = 
    head $ dropWhile (not . (playerWin boss) . fst) playerCombos
    where
        buildPlayer (_, damage, armour) = Player (Stats 100 damage armour)
        playerCombos = zip (map buildPlayer combos) combos
        
mostExpensiveLoss :: [Info] -> Character -> (Character, Info)
mostExpensiveLoss combos boss = 
    head $ dropWhile ((playerWin boss) . fst) playerCombos
    where
        reversedCombos = reverse combos
        buildPlayer (_, damage, armour) = Player (Stats 100 damage armour)
        playerCombos = zip (map buildPlayer reversedCombos) reversedCombos