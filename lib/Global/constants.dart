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

  static const int initialHealth = 100;

  static const Map<int, String> idToIngredients = {
    1: 'Petrified Rose Petal',
    2: 'Boom Berries',
    3: 'Lingering Algae',
    4: 'Beetle Shell',
    5: 'Fire Bloom'
  };

  static const Map<int, String> idToPotions = {
    0: 'Default Potion',
    1: 'Potion of healing',
    2: 'Exploding Potion',
    3: 'Potion of fire',
  };

  static const int msPotionShakeInterval = 1500;
  static const int potionShakeThreshold = 10;
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
  ];

  static const Map<int, Map<String, int>> potionEffectValues = {
    0: {},
    1: {'Heal': 10},
    2: {'Damage': 100},
    3: {'TickSpeed': 2, 'TickAmount': 10, 'TickDamage': 2}
  };

  static const int endDurationSec = 5;
}
