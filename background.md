---
layout: opencs
title: Background with Object
description: Use JavaScript to have an in motion background.
sprite: /images/platformer/sprites/image.png
background: /images/platformer/backgrounds/alien_planet1.jpg
permalink: /background
---

<canvas id="world"></canvas>

<script>
(function(){
  // =============================
  // Canvas / Rendering Context
  // =============================
  // Grab the <canvas> element and its 2D drawing context. All visual rendering
  // for the scrolling background and the floating sprite happens here.
  const canvas = document.getElementById('world');
  const ctx = canvas.getContext('2d');

  // =============================
  // Image Assets (Background + Sprite)
  // =============================
  // We load two images: a large background (tiled/looped) and a sprite placed
  // in the center that gently bobs up and down. Only after BOTH are loaded do
  // we start the game world.
  const backgroundImg = new Image();
  const spriteImg = new Image();

  // Track number of loaded images; once it reaches 2 we call start().
  let loaded = 0;
  function onload(){ if(++loaded === 2) start(); }
  backgroundImg.onload = onload;
  spriteImg.onload = onload;
  // Basic error logging so a missing file is obvious in browser console.
  backgroundImg.onerror = () => console.error('Failed to load background:', backgroundImg.src);
  spriteImg.onerror = () => console.error('Failed to load sprite:', spriteImg.src);
  // Liquid relative_url ensures correct baseurl (/student) is prefixed during build.
  backgroundImg.src = "{{ page.background | relative_url }}";
  spriteImg.src = "{{ page.sprite | relative_url }}";

  // =============================
  // GameWorld: orchestrates sizing, objects, and main loop
  // =============================
  class GameWorld {
    // gameSpeed: higher = faster horizontal background scroll
    static gameSpeed = 100; // (pixels per frame for speedRatio=1; not delta‑time based)
    constructor(backgroundImg, spriteImg){
      this.canvas = canvas;
      this.ctx = ctx;
      this.dpr = window.devicePixelRatio || 1;
      // Set up initial logical (CSS) size and internal pixel resolution.
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

      // Instantiate game objects (background + player sprite)
      this.background = new Background(backgroundImg, this);
      this.player = new Player(spriteImg, this);
      this.gameObjects = [this.background, this.player];

      // Keep canvas + scaling responsive to window changes
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
      // Clear the previous frame; each object redraws itself.
      this.ctx.clearRect(0, 0, this.width, this.height);
      for (const obj of this.gameObjects){ obj.update(); obj.draw(this.ctx); }
      // Use requestAnimationFrame for ~60fps (or display refresh rate) smoothness.
      requestAnimationFrame(this.gameLoop.bind(this));
    }
    start(){ this.gameLoop(); }
  }

  // =============================
  // Base GameObject Class
  // =============================
  // Provides a uniform interface (update/draw) and shared properties for
  // all entities we might later add (e.g., additional parallax layers).
  class GameObject {
    constructor(image, width, height, x = 0, y = 0, speedRatio = 0){
      this.image = image;
      this.width = width;
      this.height = height;
      this.x = x;
      this.y = y;
      this.speedRatio = speedRatio;
    }
    update(){} // Default: stationary
    draw(ctx){ ctx.drawImage(this.image, this.x, this.y, this.width, this.height); } // Render image
  }

  // =============================
  // Background: scrolling / tiling layer
  // =============================
  class Background extends GameObject {
    constructor(image, gameWorld){
      super(image, gameWorld.width, gameWorld.height, 0, 0, 0.2);
      this.gameWorld = gameWorld;
      this.offset = 0;
      this.recompute();
    }
    recompute(){
      // Fit background to cover entire viewport while preserving aspect ratio.
      const iw = this.image.naturalWidth, ih = this.image.naturalHeight;
      const cw = this.gameWorld.width, ch = this.gameWorld.height;
      this.scale = Math.max(cw/iw, ch/ih);
      this.sw = iw * this.scale; // scaled width
      this.sh = ih * this.scale; // scaled height
      this.y = (ch - this.sh) / 2;
    }
    update(){
      const speed = GameWorld.gameSpeed * this.speedRatio;
      // Scroll horizontally and wrap using modulus for seamless loop.
      this.offset = (this.offset + speed) % this.sw;
    }
    draw(ctx){
      let x = -this.offset;
      ctx.drawImage(this.image, x, this.y, this.sw, this.sh);
      ctx.drawImage(this.image, x + this.sw, this.y, this.sw, this.sh);
      if (x > 0) ctx.drawImage(this.image, x - this.sw, this.y, this.sw, this.sh);
    }
  }

  // =============================
  // Player (center sprite) with bobbing motion
  // =============================
  class Player extends GameObject {
    constructor(image, gameWorld){
      const width = image.naturalWidth / 2;
      const height = image.naturalHeight / 2;
      const x = (gameWorld.width - width) / 2;
      const y = (gameWorld.height - height) / 2;
      super(image, width, height, x, y);
      this.baseY = y; this.frame = 0;
    }
    update(){
      // Use a sine wave to create gentle vertical floating.
      this.y = this.baseY + Math.sin(this.frame * 0.05) * 20;
      this.frame++;
    }
  }

  // =============================
  // Entry Point: invoked after both images load
  // =============================
  function start(){ const world = new GameWorld(backgroundImg, spriteImg); world.start(); }
})();
</script>
