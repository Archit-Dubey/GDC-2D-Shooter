I think one of the reasons the game lags is because the asteroids keeps rotating, I think we should only rotate the CollsionBody2D and Sprite2D, that way we can avoid rotating the navigation area.

# GDC-2D-Shooter TODO List

1. Create a start game page
2. Enforce an area as the playable region (Done)
3. Player (Done)
4. Joystick to move and rotate the player (Done)
5. Set Shooting Controls for Player (Done)
6. Insert enemies and make them spawn on random durations (Mostly Done because there might be new additions, right now 2 types of enemy are done)
7. Set shooting controls for enemies (Mostly Done)
8. Add player health bar (Done)
9. Add enemy health (Done)
10. Add Damage taken/given (Done, no visual indicator yet besides player health bar)
11. Enable player to have multiple lives (Done)
12. Set a High score and score counter (Done)
13. Insert different powerups (Life done, Health done, Armor done, Speed done)
14. Add multiple gun types
15. Implement complex pathing for enemies to avoid debris (Mostly Done, need to check for bugs)
16. Add debris/asteroids (Kind of done, asteroids should be adjusted with new sprites and accompanying collider shape)
17. Random asteroid generation at start of level (done, but need some time to before user can start game so asteroid can arrange themselves)
18. Stop powerups from spawning into asteroids (done)
19. implement world boundary (done)
20. Add arrows to point at off screen powerups (done)
