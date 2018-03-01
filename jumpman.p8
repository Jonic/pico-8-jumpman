pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- jumpman
-- by jonic
-- v1.0.0

--[[
  full code is on github here:

  https://github.com/jonic/pico-8-jumpman
]]

-->8
-- global vars

actors  = {}
gravity = 5

-->8
-- helpers

function rndint(min, max)
  return flr(rnd(max)) + min
end

-->8
-- actor

function actor()
  return {
    -- acceleration
    ay = 10,
    ax = 0,
    -- size
    h  = 16,
    w  = 16,
    -- velocity
    vx = 3,
    vy = 5,
    -- position
    x  = 0,
    y  = 0,

    -- props
    can_jump   = false,
    is_jumping = false,
    jump_max   = 6,
    spawned    = false,
    sprite     = 0,

    -- methods
    apply_gravity = function(a)
      if (a.is_jumping) then
        a.y  -= a.vy
        a.vy -= gravity / 10

        if (a.vy <= 0) then
          a.is_jumping = false
        end
      else
        a.y += gravity
      end
    end,

    detect_floor = function(a)
      if (a.y > 128 - a.h) then
        a.can_jump = true
        a.y        = 128 - a.h
      end
    end,

    jump = function(a)
      if (not a.can_jump) return
      printh(time() .. ': JUMP!')
      a.can_jump   = false
      a.is_jumping = true
      a.vy         = a.jump_max
    end,

    spawn = function(a)
      a.spawned = true
    end,

    spawn_at = function(a, x, y)
      a.x = x
      a.y = y
      a:spawn()
    end,

    -- lifecycle
    _init = function(a)
      return
    end,

    _update = function(a)
      if (btn(0)) a.x -= a.vx
      if (btn(1)) a.x += a.vx
      if (btn(2)) a:jump()

      a:apply_gravity()
      a:detect_floor()
    end,

    _draw = function(a)
      color = rndint(1, 15)
      rectfill(a.x, a.y, a.x + a.w, a.y + a.h, color)
      return
    end,
  }
end

-->8
-- game loop

function _init()
  jumpman = actor()
  jumpman:spawn_at(64, 64)
  add(actors, jumpman)
  return
end

function _update()
  for a in all(actors) do
    if (a.spawned) a:_update()
  end
end

function _draw()
  cls()
  rectfill(0, 0, 128, 128, 1)

  for a in all(actors) do
    if (a.spawned) a:_draw()
  end
end
