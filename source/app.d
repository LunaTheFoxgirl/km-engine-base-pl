module app;
import engine;
import game;

int main() {

    // Set the function pointers
    kmInit = &_init;
    kmUpdate = &_update;
    kmCleanup = &_cleanup;
    kmBorder = &_border;
    kmPostUpdate = &_postUpdate;
    kmFixedUpdate = &_fixedUpdate;

    // Init engine start the game and then close the engine once the game quits
    initEngine();
    startGame(vec2i(640, 360)); // <- Change this to change the base resolution of the game "canvas"
    closeEngine();
    return 0;
}