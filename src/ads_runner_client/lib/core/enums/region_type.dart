enum RegionType {
  // Provinces
  gauteng('Gauteng', 'province'),
  westernCape('Western Cape', 'province'),
  kwazuluNatal('KwaZulu-Natal', 'province'),
  easternCape('Eastern Cape', 'province'),
  freeState('Free State', 'province'),
  limpopo('Limpopo', 'province'),
  mpumalanga('Mpumalanga', 'province'),
  northWest('North West', 'province'),
  northernCape('Northern Cape', 'province'),
  // Metropolitan areas
  johannesburg('City of Johannesburg', 'metro'),
  capeTown('City of Cape Town', 'metro'),
  eThekwini('eThekwini (Durban)', 'metro'),
  tshwane('City of Tshwane (Pretoria)', 'metro'),
  ekurhuleni('Ekurhuleni', 'metro'),
  nelsonMandelaBay('Nelson Mandela Bay', 'metro'),
  mangaung('Mangaung (Bloemfontein)', 'metro'),
  buffaloCity('Buffalo City', 'metro');

  const RegionType(this.displayName, this.category);
  final String displayName;
  final String category;

  static List<RegionType> get provinces =>
      values.where((r) => r.category == 'province').toList();

  static List<RegionType> get metros =>
      values.where((r) => r.category == 'metro').toList();
}
