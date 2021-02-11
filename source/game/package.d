module game;
import engine;

/**
    Last Mouse State
*/
MouseState* lmState;

/**
    Current Mouse State
*/
MouseState* mState;

/**
    Last Keyboard State
*/
KeyboardState* lkState;

/**
    Current Keyboard State
*/
KeyboardState* kState;

/**
    Make a comment like this for it to be a documentation comment,
    This will help you know what things are, in this case this is our texture for
    the example.
*/
Texture texture;

/**
    A Sound object is a sound effect.

    NOTE: These are all loaded uncompressed in to memory
    If you want to play long form music *use* Music

    Otherwise your game can use like, over 1 GB of ram.

    NOTE: If you want a sound to play in some 3D space it needs
    to be mono!

    NOTE: Only ogg files are supported currently, you can use
    VLC Media Player or other tools to convert audio to ogg.
    Ogg is also called Ogg Vorbis or Vorbis.
*/
Sound soundEffect;

/**
    A Music object is an object that streams music from
    the harddrive a bit at a time to avoid using too much memory

    There's an internal buffer, if it runs out the music in the game
    may stutter or cut out.

    NOTE: Only ogg files are supported currently, you can use
    VLC Media Player or other tools to convert audio to ogg.
    Ogg is also called Ogg Vorbis or Vorbis.
*/
Music music;

/**
    Initialize game

    This functions runs when the game first starts
    and allows you to preload things where applicable.
*/
void _init() {
    // You can set various settings for the game window
    // in GameWindow, such as VSync and window title.
    GameWindow.title = "My Game";

    // How to load a texture
    texture = new Texture("assets/texture.png");

    // NOTE: You can use the GameAtlas to efficiently atlas textures
    // This makes drawing faster and is highly recommended
    GameAtlas.add("texture", "assets/texture.png");

    // Loads a sound effect in to the "SFX" mixer channel
    soundEffect = new Sound("assets/sfx.ogg", "SFX");
    music = new Music("assets/music.ogg", "Music");

    // NOTE: It's a good idea to set these states
    // to empty states like this before using them
    // Otherwise the game will probably crash.
    kState = new KeyboardState;
    mState = new MouseState;

    // We want the music the play straight away and loop.
    music.setLooping(true);
    music.play();
}

/**
    Update game
*/
void _update() {



    //
    // Handling input states
    //

    // Make last state equal the the state of the last execution of update
    lkState = kState;
    kState = Keyboard.getState();

    // Ditto for mouse
    lmState = mState;
    mState = Mouse.getState();



    //
    // Drawing
    //

    // How to draw textures
    GameBatch.draw(texture, vec4(32, 32, texture.width, texture.height));

    // How to draw textures from atlas
    GameBatch.draw(GameAtlas["texture"], vec4(64, 64, texture.width, texture.height));
    GameBatch.flush();



    // How to draw text, Most roman based alphabets, Japanese and Chinese is supported.
    GameFont.draw("Hello, world!"d, vec2(16, 16));
    GameFont.flush();



    //
    // Getting mouse and keyboard input, logs and playing sound effects.
    //
    
    // To get keyboard input use the Keyboard class
    if (kState.isKeyDown(Key.KeyA)) {

        // Use applog to write to the games debug log
        AppLog.info("My Game", "A was pressed!");
    }
    

    // To check whether a key has been pressed once
    // You want to compare that in the last frame
    // the keyboard was NOT pressed but it is now
    // This will make sure it's only fired once.
    if (kState.isKeyDown(Key.KeyS) && lkState.isKeyUp(Key.KeyS)) {
        soundEffect.play();
    }

    

    // We make the font double size
    GameFont.setSize(kmGetDefaultFontSize()*2);
    vec2 size = GameFont.measure("A"d);

    // Checks if right mouse button is held
    if (mState.isButtonPressed(MouseButton.Right)) {
        GameFont.draw("Right Mouse button is held!", vec2(8, 128));
    }

    // Checks if the middle mouse button was held
    if (mState.isButtonPressed(MouseButton.Middle)) {
        GameFont.draw("Scroll wheel is held!", vec2(8, 128+size.y));
    }

    if (mState.isButtonPressed(MouseButton.Left) && lmState.isButtonReleased(MouseButton.Left)) {
        soundEffect.play();
    }

    // You can run multiple draw calls BEFORE having to flush
    // This counts for the sprite batch as well
    GameFont.flush();

    // Reset the font size after setting it to a bigger size.
    GameFont.setSize(kmGetDefaultFontSize());
}

/**
    Post-update
*/
void _postUpdate() {
    // Updates to happen after the main update, this can be useful for ordering
    // somethings more specifically.
}

/**
    For doing physics and particle system updates
    This update is run *every* 16 milliseconds
    if the game runs slow it will try to catch up
    
    If the game runs slower than 1 FPS then
    the game will give up on catching up.
*/
void _fixedUpdate() {
    
}

/**
    Game cleanup

    Clean up resources you don't need anymore here.
*/
void _cleanup() {

    // Remember to destroy things when you don't need them anymore.
    destroy(texture);
}

/**
    Render border around the game
*/
void _border() {
    // Feel free to draw a border around the game here
    // Basically first the border is drawn, then the game on top
    // So anything that'd just be black bars can be replaced with
    // some nice texture :)
}