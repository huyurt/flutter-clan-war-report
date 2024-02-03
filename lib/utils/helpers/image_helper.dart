class ImageHelper {
  static List<String> getHeroes() {
    return [
      "Barbarian King",
      "Archer Queen",
      "Grand Warden",
      "Royal Champion",
    ];
  }

  static List<String> getPets() {
    return [
      "L.A.S.S.I",
      "Electro Owl",
      "Mighty Yak",
      "Unicorn",
      "Frosty",
      "Diggy",
      "Poison Lizard",
      "Phoenix",
      "Spirit Fox",
    ];
  }

  static List<String> getTroops() {
    return [
      "Barbarian",
      "Archer",
      "Giant",
      "Goblin",
      "Wall Breaker",
      "Balloon",
      "Wizard",
      "Healer",
      "Dragon",
      "P.E.K.K.A",
      "Baby Dragon",
      "Miner",
      "Electro Dragon",
      "Yeti",
      "Dragon Rider",
      "Electro Titan",
      "Root Rider",
      "Minion",
      "Hog Rider",
      "Valkyrie",
      "Golem",
      "Witch",
      "Lava Hound",
      "Bowler",
      "Ice Golem",
      "Headhunter",
      "Apprentice Warden",
    ];
  }

  static List<String> getSpells() {
    return [
      "Lightning Spell",
      "Healing Spell",
      "Rage Spell",
      "Jump Spell",
      "Freeze Spell",
      "Clone Spell",
      "Invisibility Spell",
      "Recall Spell",
      "Poison Spell",
      "Earthquake Spell",
      "Haste Spell",
      "Skeleton Spell",
      "Bat Spell",
    ];
  }

  static List<String> getSiegeMachines() {
    return [
      "Wall Wrecker",
      "Battle Blimp",
      "Stone Slammer",
      "Siege Barracks",
      "Log Launcher",
      "Flame Flinger",
      "Battle Drill",
    ];
  }

  static List<String> getSuperTroops() {
    return [
      "Ice Hound",
      "Inferno Dragon",
      "Rocket Balloon",
      "Sneaky Goblin",
      "Super Archer",
      "Super Barbarian",
      "Super Bowler",
      "Super Dragon",
      "Super Giant",
      "Super Miner",
      "Super Minion",
      "Super Valkyrie",
      "Super Wall Breaker",
      "Super Witch",
      "Super Wizard",
      "Super Hog Rider",
    ];
  }

  static List<String> getVillageTroops() {
    return [
      "Baby Dragon",
      "Beta Minion",
      "Bomber",
      "Boxer Giant",
      "Cannon Cart",
      "Drop Ship",
      "Hog Glider",
      "Night Witch",
      "Raged Barbarian",
      "Sneaky Archer",
      "Super P.E.K.K.A",
    ];
  }

  static String getTownhallImage(int? townhallLevel, int? townHallWeaponLevel) {
    townhallLevel = townhallLevel ?? 1;
    if (townhallLevel > 11) {
      return '$townhallLevel.${townHallWeaponLevel ?? 5}';
    }
    return townhallLevel.toString();
  }
}
