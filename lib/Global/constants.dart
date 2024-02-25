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
    1: 'Phoenix Feather Fern',
    2: 'Ember Crystal',
    3: 'Shadowroot',
    4: 'Moonstone Nectar',
    5: 'Dragon\'s Tounge'
  };

  static const Map<int, String> idToPotions = {
    0: 'Default Potion',
    1: 'Elixir of Eternal Flames',
    2: 'Potion of The Shadowbound',
    3: 'Celestial Frost Potion',
    4: 'Potion of Venom',
    5: 'Dragonhearts Brew',
  };

  static const int msPotionShakeInterval = 2000;
  static const int potionShakeThreshold = 10;
  static const int maxMixLevel = 10;

  static const List<List> potions = [
    [
      1,
      [1, 2, 5]
    ],
    [
      2,
      [3, 4]
    ],
    [
      3,
      [2, 4]
    ],
    [
      4,
      [3, 4, 5]
    ],
    [
      5,
      [1, 5]
    ],
  ];

  static const Map<int, List> potionEffects = {
    0: [],
    1: [
      ['Damage', 10]
    ],
    2: [],
    3: [],
    4: [],
    5: [
      ['Heal', 10]
    ],
  };
}
