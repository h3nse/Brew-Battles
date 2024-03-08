import 'package:brew_battles/Global/potions.dart';

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

  static Map<int, Potion> idToPotions = {
    0: DefaultPotion(),
    1: PotionOfHealing(),
    2: ExplodingPotion(),
    3: PotionOfStoneskin(),
  };

  static const int msPotionShakeInterval = 2500;
  static const int potionShakeThreshold = 15;
  static const int maxMixLevel = 1;

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
      [4]
    ]
  ];

  static const Map<int, Map<String, dynamic>> potionEffectValues = {
    0: {},
    1: {'Heal': 10.0},
    2: {'Damage': -10.0},
  };

  static const Map<String, Map<String, dynamic>> effectValues = {
    'Stoneskin': {'DamageReduction': 0.5},
    'Burning': {'TickSpeed': 1, 'TickDamage': -1.0}
  };

  static const int endDurationSec = 5;
}
