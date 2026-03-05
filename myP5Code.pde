// SO MUCH BOOLEAN SO MUCH IF SO MUCH i WHAT IS HAPPENING IM IN PAIN RAHHHHHHHHHHHHH, INT'S VAR'S NONE OF IT MAKES SENSE. I found a similar game THIS ALL MAKES SENSE NOW, I SEE NOW. this went way to far
// Idk why i need the Voids im at a point i understand most of this but i dont get why the voids are needed.
// Ive been working on this for so long ive forgotten what i learned in class and what came from everything else.


// Player
var playerMaxHP = 45;
var playerHP = playerMaxHP;
var playerAC = 16;

// Enemy
var enemyName;
var enemyHP;
var enemyMaxHP;
var enemyAC;
var enemyAttackDie;
var enemyAttackBonus;
boolean bossFight = false;

// Turns
boolean playerTurn = true;
var enemyTurnTimer = 0;

// Fights to boss
var fightsWon = 0;

// Game Over
boolean gameOver = false;
var deathTimer = 0;

// Win State
boolean gameWon = false;

// Combat Log
var[] combatLog = new var[6];

void setup() {
  size(750, 500);
  frameRate(60);
  resetToStart();
}

void draw() {
  background(122, 0, 61);
  drawUI();

  // WIN SCREEN
  if (gameWon) return;

  // Reset On Death
  if (gameOver) {
    if (deathTimer > 0) deathTimer--;
    if (deathTimer == 0) resetToStart();
    return;
  }

  if (!playerTurn && enemyTurnTimer > 0) {
    enemyTurnTimer--;
    if (enemyTurnTimer == 0) {
      enemyAttack();
    }
  }
}

// UI
void drawUI() {
  if(mousePressed){fill(0)}
  
  textSize(16);
  text("Fights Won: " + fightsWon, 325, 30);

  // Player UI
  fill(50);
  rect(20, 60, 300, 120, 10);
  fill(255);
  text("PLAYER", 30, 85);
  drawHealthBar(30, 100, 260, 20, playerHP, playerMaxHP);
  text("HP: " + playerHP + "/" + playerMaxHP + "   AC: " + playerAC, 30, 140);

  // Enemy UI
  fill(bossFight ? color(120, 0, 0) : color(50));
  rect(420, 60, 300, 120, 10);
  fill(255);
  text(enemyName.toUpperCase(), 430, 85);
  drawHealthBar(430, 100, 260, 20, enemyHP, enemyMaxHP);
  text("HP: " + enemyHP + "/" + enemyMaxHP + "   AC: " + enemyAC, 430, 140);

  // Attacks
  fill(255);
  textSize(16);
  text("Choose Action:", 20, 210);
  text("1: Dagger (d4, +6 hit)", 20, 235);
  text("2: Longsword (d6, +5 hit)", 20, 260);
  text("3: Heal (d12 healing)", 20, 285);
  text("4: Firebolt (d10, +3 hit)", 20, 310);
  text("5: Warhammer (d12, +2 hit)", 20, 335);

  drawCombatLog();

  // Death screen
  if (gameOver) {
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(255, 0, 0);
    textSize(48);
    textAlign(CENTER, CENTER);
    text("YOU HAVE DIED", width/2, height/2 - 20);
    textSize(18);
    fill(255);
    text("Press R or wait 5 seconds...", width/2, height/2 + 30);
    textAlign(LEFT, BASELINE);
  }

  // WIN SCREEN
  if (gameWon) {
    fill(0, 0, 0, 220);
    rect(0, 0, width, height);
    fill(0, 255, 100);
    textSize(46);
    textAlign(CENTER, CENTER);
    text("CONGRATS!", width/2, height/2 - 40);
    textSize(28);
    text("I'll give you a fistbump 👊", width/2, height/2 + 10);
    textSize(16);
    text("Press R to play again", width/2, height/2 + 60);
    textAlign(LEFT, BASELINE);
  }
}

void drawHealthBar(int x, int y, int w, int h, int current, int maxHP) {
  float percent = constrain((float)current / maxHP, 0, 1);

  stroke(0);
  fill(30);
  rect(x, y, w, h);

  if (percent > 0.6) fill(0, 200, 0);
  else if (percent > 0.3) fill(255, 200, 0);
  else fill(200, 0, 0);

  rect(x, y, w * percent, h);
}

void drawCombatLog() {
  fill(20);
  rect(20, 380, 700, 100, 10);

  fill(255);
  textSize(14);
  text("Combat Log:", 30, 400);

  for (int i = 0; i < combatLog.length; i++) {
    if (combatLog[i] != null) {
      text(combatLog[i], 30, 420 + i * 15);
    }
  }
}

void addLog(int message) {
  for (int i = combatLog.length - 1; i > 0; i--) {
    combatLog[i] = combatLog[i - 1];
  }
  combatLog[0] = message;
}

// Keypress
void keyPressed() {

  // Restart on win
  if (gameWon && (key == 'r' || key == 'R')) {
    resetToStart();
    return;
  }

  if (gameOver && (key == 'r' || key == 'R')) {
    resetToStart();
    return;
  }

  if (gameOver || gameWon) return;
  if (!playerTurn) return;

  if (key == '1') playerAttack("Dagger", 4, 6);
  if (key == '2') playerAttack("Sword", 6, 5);
  if (key == '3') healPlayer();
  if (key == '4') playerAttack("Firebolt", 10, 3);
  if (key == '5') playerAttack("Warhammer", 12, 2);

  // KILL
  if (key == '0') {
    enemyHP -= 100;
    addLog("KILL BUTTON");
    endPlayerTurn();
  }
}

// Combat
void playerAttack(int name, int die, int bonus) {

  int d20 = int(random(8, 21));
  int total = d20 + bonus;

  if (d20 == 20 || total >= enemyAC) {
    int damage = int(random(1, die + 1));
    if (d20 == 20) {
      damage *= 2;
      addLog("CRITICAL HIT!");
    }
    enemyHP -= damage;
    addLog(name + " hits! Damage=" + damage);
  } else {
    addLog(name + " misses!");
  }

  endPlayerTurn();
}

void healPlayer() {
  int healRoll = int(random(1, 13));
  int healAmount = healRoll;
  if (healRoll == 12) {
    healAmount *= 2;
    addLog("CRITICAL HEAL! +" + healAmount);
  } else {
    addLog("Heal restores +" + healAmount);
  }

  playerHP += healAmount;
  if (playerHP > playerMaxHP) playerHP = playerMaxHP;

  endPlayerTurn();
}

void endPlayerTurn() {

  if (enemyHP <= 0) {
    fightsWon++;
    addLog(enemyName + " defeated!");

    if (bossFight) {
      gameWon = true;
      return;
    }

    pickEnemy();
    addLog("A new " + enemyName + " appears!");
    return;
  }

  playerTurn = false;
  enemyTurnTimer = 60;
}

void enemyAttack() {

  int d20 = int(random(1, 21));
  int total = d20 + enemyAttackBonus;

  if (d20 == 20 || total >= playerAC) {
    int damage = int(random(1, enemyAttackDie + 1));
    if (d20 == 20) damage *= 2;
    playerHP -= damage;
    addLog(enemyName + " hits! Damage=" + damage);
  } else {
    addLog(enemyName + " misses!");
  }

  if (playerHP <= 0) {
    playerHP = 0;
    gameOver = true;
    deathTimer = 300;
    return;
  }

  playerTurn = true;
}

// Enemy spawn
void pickEnemy() {

  if (fightsWon >= 3 && !bossFight) {
    spawnDragon();
    return;
  }

  bossFight = false;

  int choice = int(random(4));

  if (choice == 0) {
    enemyName = "Goblin";
    enemyMaxHP = 20;
    enemyAC = 11;
    enemyAttackDie = 6;
    enemyAttackBonus = 3;
  } else if (choice == 1) {
    enemyName = "Orc";
    enemyMaxHP = 28;
    enemyAC = 13;
    enemyAttackDie = 8;
    enemyAttackBonus = 4;
  } else if (choice == 2) {
    enemyName = "Troll";
    enemyMaxHP = 36;
    enemyAC = 14;
    enemyAttackDie = 10;
    enemyAttackBonus = 5;
  } else {
    enemyName = "Knight";
    enemyMaxHP = 30;
    enemyAC = 15;
    enemyAttackDie = 8;
    enemyAttackBonus = 6;
  }

  enemyHP = enemyMaxHP;
  playerTurn = true;
}

void spawnDragon() {
  bossFight = true;
  enemyName = "Dragon";
  enemyMaxHP = 60;
  enemyAC = 15;
  enemyAttackDie = 12;
  enemyAttackBonus = 4;
  enemyHP = enemyMaxHP;
  addLog("🔥 THE DRAGON AWAKENS 🔥");
}

// Reset
void resetToStart() {
  playerHP = playerMaxHP;
  playerTurn = true;
  enemyTurnTimer = 0;
  fightsWon = 0;
  bossFight = false;
  gameOver = false;
  gameWon = false;
  deathTimer = 0;

  for (int i = 0; i < combatLog.length; i++)
    combatLog[i] = null;

  pickEnemy();
  addLog("Game started. A wild " + enemyName + " appears!");
}