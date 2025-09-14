---
layout: opencs
title: Background with Object
description: Use JavaScript to have an in motion background.
sprite: /images/platformer/sprites/flying-ufo.png
background: /images/platformer/backgrounds/alien_planet1.jpg
permalink: /background
---

<canvas id="world"></canvas>

<script>
(function(){
  const canvas = document.getElementById('world');
  const ctx = canvas.getContext('2d');

  const backgroundImg = new Image();
  const spriteImg = new Image();

  let loaded = 0;
  function onload(){ if(++loaded === 2) start(); }
  backgroundImg.onload = onload;
  spriteImg.onload = onload;
  backgroundImg.onerror = () => console.error('Failed to load background:', backgroundImg.src);
  spriteImg.onerror = () => console.error('Failed to load sprite:', spriteImg.src);
  backgroundImg.src = "{{ page.background | relative_url }}";
  spriteImg.src = "{{ page.sprite | relative_url }}";

  class GameWorld {
    static gameSpeed = 100;
    constructor(backgroundImg, spriteImg){
      this.canvas = canvas;
      this.ctx = ctx;
      this.dpr = window.devicePixelRatio || 1;
      this.width = Math.floor(window.innerWidth);
      this.height = Math.floor(window.innerHeight);
      this.canvas.width = Math.floor(this.width * this.dpr);
      this.canvas.height = Math.floor(this.height * this.dpr);
      this.canvas.style.width = this.width + 'px';
      this.canvas.style.height = this.height + 'px';
      this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
      this.canvas.style.position = 'fixed';
      this.canvas.style.left = '0px';
      this.canvas.style.top = '0px';

      this.background = new Background(backgroundImg, this);
      this.player = new Player(spriteImg, this);
      this.gameObjects = [this.background, this.player];

      window.addEventListener('resize', () => this.resize());
    }
    resize(){
      this.dpr = window.devicePixelRatio || 1;
      this.width = Math.floor(window.innerWidth);
      this.height = Math.floor(window.innerHeight);
      this.canvas.width = Math.floor(this.width * this.dpr);
      this.canvas.height = Math.floor(this.height * this.dpr);
      this.canvas.style.width = this.width + 'px';
      this.canvas.style.height = this.height + 'px';
      this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);
      this.background.recompute();
    }
    gameLoop(){
      this.ctx.clearRect(0, 0, this.width, this.height);
      for (const obj of this.gameObjects){ obj.update(); obj.draw(this.ctx); }
      requestAnimationFrame(this.gameLoop.bind(this));
    }
    start(){ this.gameLoop(); }
  }

  class GameObject {
    constructor(image, width, height, x = 0, y = 0, speedRatio = 0){
      this.image = image;
      this.width = width;
      this.height = height;
      this.x = x;
      this.y = y;
      this.speedRatio = speedRatio;
    }
    update(){}
    draw(ctx){ ctx.drawImage(this.image, this.x, this.y, this.width, this.height); }
  }

  class Background extends GameObject {
    constructor(image, gameWorld){
      super(image, gameWorld.width, gameWorld.height, 0, 0, 0.2);
      this.gameWorld = gameWorld;
      this.offset = 0;
      this.recompute();
    }
    recompute(){
      const iw = this.image.naturalWidth, ih = this.image.naturalHeight;
      const cw = this.gameWorld.width, ch = this.gameWorld.height;
      this.scale = Math.max(cw/iw, ch/ih);
      this.sw = iw * this.scale; // scaled width
      this.sh = ih * this.scale; // scaled height
      this.y = (ch - this.sh) / 2;
    }
    update(){
      const speed = GameWorld.gameSpeed * this.speedRatio;
      this.offset = (this.offset + speed) % this.sw;
    }
    draw(ctx){
      let x = -this.offset;
      ctx.drawImage(this.image, x, this.y, this.sw, this.sh);
      ctx.drawImage(this.image, x + this.sw, this.y, this.sw, this.sh);
      if (x > 0) ctx.drawImage(this.image, x - this.sw, this.y, this.sw, this.sh);
    }
  }

  class Player extends GameObject {
    constructor(image, gameWorld){
      const width = image.naturalWidth / 2;
      const height = image.naturalHeight / 2;
      const x = (gameWorld.width - width) / 2;
      const y = (gameWorld.height - height) / 2;
      super(image, width, height, x, y);
      this.baseY = y; this.frame = 0;
    }
    update(){ this.y = this.baseY + Math.sin(this.frame * 0.05) * 20; this.frame++; }
  }

  function start(){ const world = new GameWorld(backgroundImg, spriteImg); world.start(); }
})();
</script>
