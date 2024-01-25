bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  final fixedX = player.scale.x < 0 ? playerX -  (hitbox.offsetX * 2) - playerWidth : playerX;

  //allows the bottom of player to be checked when jumping onto platforms, not the top
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  //checking for collisions
  //collisions occur when there are overlaps
  //is the avatar overlapping with the blocks?

  return (fixedY < blockY + blockHeight &&
      playerY + playerHeight > blockY &&
      fixedX < blockX + blockWidth &&
      fixedX + playerWidth > blockX);
}
