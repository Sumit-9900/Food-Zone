String capitalizeName(String name) {
  return name.isEmpty
      ? ''
      : name
          .trim()
          .split(' ')
          .map(
            (word) => word[0].toUpperCase() + word.substring(1).toLowerCase(),
          )
          .join(' ');
}
