## SuperMemo2 Flashcards
iPhone flashcard app built with Swift 3 and Core Data which schedules card reviews based on the SuperMemo 2 algorithm. The application was built as part of a university project and is not mantained.

## How card reviews are scheduled
1. All new items have an Easiness factor (EF) equal to 2.5.
2. The items reviewed are assigned the following intervals:
  1. I(1):=1. 
  2. I(2):=6.
  3. for n>2: I(n):=I(n-1)*EF. Where i(n) is the interval after the n-th repetition.
3. After each repetition the user response is scored in 0-5 grade scale.
4. the new EF for the item is determined according to the formula: EF’:=EF+(0.1-(5-q)*(0.08+(5-q)*0.02)) (q = user score)
5. If the user score was lower than 3 then the EF won't change and the item will be considered as if it was being memorised for the first
time. 

For more information about how reviews are scheduled take a look at the SuperMemo2 algorithm: https://www.supermemo.com/english/ol/sm2.htm
