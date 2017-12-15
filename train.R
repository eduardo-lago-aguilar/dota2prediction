heroes <- c("Alchemist", "Ancient Apparition", "Anti-Mage", "Axe", "Bane", "Batrider", "Beastmaster", "Bloodseeker", "Bounty Hunter", "Brewmaster", "Broodmother", "Centaur Warrunner", "Chaos Knight", "Chen", "Clinkz", "Clockwerk", "Crystal Maiden", "Dark Seer", "Dazzle", "Death Prophet", "Disruptor", "Doom", "Dragon Knight", "Drow Ranger", "Earthshaker", "Enchantress", "Enigma", "Faceless Void", "Gyrocopter", "Huskar", "Invoker", "Jakiro", "Juggernaut", "Keeper of the Light", "Kunkka", "Leshrac", "Lich", "Lifestealer", "Lina", "Lion", "Lone Druid", "Luna", "Lycanthrope", "Magnus", "Medusa", "Meepo", "Mirana", "Morphling", "Naga Siren", "Nature's Prophet", "Necrolyte", "Night Stalker", "Nyx Assassin", "Ogre Magi", "Omniknight", "Outworld Devourer", "Phantom Assassin", "Phantom Lancer", "Puck", "Pudge", "Pugna", "Queen of Pain", "Razor", "Riki", "Rubick", "Sand King", "Shadow Demon", "Shadow Fiend", "Shadow Shaman", "Silencer", "Skeleton King", "Slardar", "Slark", "Sniper", "Spectre", "Spirit Breaker", "Storm Spirit", "Sven", "Templar Assassin", "Tidehunter", "Timbersaw", "Tinker", "Tiny", "Treant Protector", "Troll Warlord", "Undying", "Ursa", "Vengeful Spirit", "Venomancer", "Viper", "Visage", "Warlock", "Weaver", "Windrunner", "Wisp", "Witch Doctor", "Zeus")
num_heroes = length(heroes)
search_hero <- function (hero) {
  i <- 1
  j <- num_heroes
  m <- (i + j) %/% 2
  while(i <= j && heroes[m] != hero) {
    if(hero < heroes[m]) {
      j = m - 1
    } else {
      i = m + 1
    }
    m <- (i + j) %/% 2
  }
  if(i <= j) {
    m
  } else {
    0
  }
}

games = as.matrix(read.csv2("trainingdata.txt",header = FALSE, sep = ","))
N = nrow(games)
make_draft <- function (i) {
  radiant_pick <- games[i, 1:5]
  dire_pick <- games[i, 6:10]
  d <- numeric(num_heroes)
  for (k in 1:5) {
    radiant_hero_index <- search_hero(radiant_pick[k])
    d[radiant_hero_index] = -1
    dire_hero_index <- search_hero(dire_pick[k])
    d[dire_hero_index] = 1
  }
  d
}
make_winner <- function(i) 2 * strtoi(games[i,11]) - 3

# start training
draft <- matrix(nrow = N, ncol = num_heroes)
winner <- numeric(N)
for (i in 1:N) {
  draft[i, ] <- make_draft(i)
  winner[i] <- make_winner(i)
}

m <- numeric(num_heroes)
b <- 0
learing_rate = 0.73

for (epoch in 1:100) {
  m_deriv <- 0
  b_deriv <- 0
  for (i in 1:N) {
    x <- draft[i, ]
    y <- winner[i]
    Y <- m %*% x + b
    m_deriv <- m_deriv - 2 * x * c(y - Y)
    b_deriv <- b_deriv - 2 * (y - Y)
  }
  m <- m - (m_deriv / N) * learing_rate
  b <- b - (b_deriv / N) * learing_rate
}

cat("\ntraining completed")
cat("\nm: (", paste(m, collapse = ","),")")
cat("\nb:", paste(b))

# eval
z <- function(Y) ifelse( Y < 0, -1, 1)

hits <- 0
for (i in 1:N) {
  x <- draft[i,]
  y <- winner[i]
  Y <- z(m %*% x + b)
  if(Y == y) {
    hits <- hits + 1
  }
}
miss <- N - hits
cat("\nevaluation completed")
cat("\nhits: ", paste(hits))
cat("\nmiss: ", paste(miss))
cat("\ntotal: ", paste(N))
cat("\nhit ratio: ", paste(100 * hits / N), "%")
cat("\nscore: ", paste(100 * (hits - miss) / N))
