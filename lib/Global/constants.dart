class Constants {
  static const Map<String, List> randomWords = {
    'first words': [
      'Big',
      'Small',
      'Mystic',
      'Magical',
      'Weird',
      'Awkward',
      'Enchanted',
      'Mutated',
      'Transmuted',
      'Enchanting',
      'Luminous',
      'Amazing',
      'Marvellous',
      'Powerful',
      'Special',
      'Charmed',
      'Mysterious',
      'Bewitched',
      'Supernatural',
      'Gigantic',
      'Wizardly',
      'Thaumaturgic',
      'Entranced',
      'Occult',
      'Spellbound',
      'Fairylike',
      'Miraculous',
      'Necromantic',
      'Perfect',
      'Possessed',
      'Wonder',
      'Uncanny',
      'Magnetic',
      'Fiendish',
      'Spiritualistic',
      'Otherworldly',
      'Ghostly',
      'Mythical',
      'Spectral',
      'Haunted',
      'Exquisite',
      'Telekinetic',
      'Tranced',
      'Cryptic',
      'Dark',
      'Good',
      'Bad',
      'Unearthly',
      'Extramundane',
      'Numinous',
      'Secret',
      'Transcendent',
      'Witching',
      'Clairvoyant',
      'Demonic',
      'Diabolic',
      'Eerie',
      'Runic',
      'Spooky',
      'Tranced',
      'Voodoo',
      'Phenomenal',
      'Hairy',
      'Long',
      'Short',
      'Arcane',
      'Ugly',
    ],
    'second words': [
      'Nose',
      'Legs',
      'Ears',
      'Feet',
      'Hands',
      'Eyes',
      'Hair',
      'Butt',
      'Broom',
      'Carpet',
      'Crystal',
      'Face',
      'Muscles',
      'Pecs',
      'Bones',
      'Ring',
      'Bracelet',
      'Necklace',
      'Spectacles',
      'Beard',
      'Wand',
      'Book',
      'Charm',
      'Mouth',
      'Fingers',
      'Head',
      'Forehead',
      'Toes',
      'Nails',
      'Smile',
      'Shoes',
      'Scarf',
      'Gloves',
      'Watch',
      'Wizard',
      'Sorcerer',
      'Bag',
      'Goggles',
      'Socks',
      'Boots',
      'Wallet',
      'Coat',
      'Underwear',
      'Tears',
      'Snot',
    ]
  };

  static const double initialHealth = 100;

  static const Map<int, String> idToIngredients = {
    1: 'Petrified Rose Petal',
    2: 'Boom Berries',
    3: 'Lingering Algae',
    4: 'Beetle Shell',
    5: 'Fire Bloom',
    6: 'Frost Flake',
    7: '4 Leaf clover',
    8: 'Serpents fang',
    9: 'Dragons eye',
    10: 'Lightning in a bottle'
  };

  static const Map<int, String> idToPotions = {
    0: 'Default Potion',
    1: 'Potion of healing',
    2: 'Exploding Potion',
    3: 'Potion of fire',
    4: 'Potion of blindness',
    5: 'Haste potion',
    6: 'Slowness potion',
    7: 'Freezing potion',
    8: 'Shied potion',
    9: 'Potion of vulnerability',
    10: 'Potion of toughness',
    11: 'Potion of clumsiness',
    12: 'Potion of purity'
  };

  static const int msPotionShakeInterval = 2500;
  static const int potionShakeThreshold = 15;
  static const int maxMixLevel = 10;

  static const List<List> potions = [
    [
      1,
      [1]
    ],
    [
      2,
      [2]
    ],
    [
      3,
      [3, 5]
    ],
    [
      4,
      [8, 9]
    ],
    [
      5,
      [5, 10]
    ],
    [
      6,
      [6, 10]
    ],
    [
      7,
      [3, 6]
    ],
    [
      8,
      [1, 4, 7]
    ],
    [
      9,
      [3, 8]
    ],
    [
      10,
      [3, 4]
    ],
    [
      11,
      [7, 8]
    ],
    [
      12,
      [1, 7]
    ]
  ];

  static const Map<int, Map<String, dynamic>> potionEffectValues = {
    0: {},
    1: {'Heal': 10.0},
    2: {'Damage': 100.0},
    3: {'TickSpeed': 2, 'TickAmount': 10, 'TickDamage': 2.0},
    4: {'Duration': 20},
    5: {'Multiplier': 2.0, 'Duration': 20},
    6: {'Multiplier': 0.5, 'Duration': 20},
    7: {'Duration': 15},
    9: {'Multiplier': 2.0, 'Duration': 20},
    10: {'Multiplier': 0.5, 'Duration': 20},
  };

  static const int endDurationSec = 5;
}
