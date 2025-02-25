#include <SDL2/SDL.h>

SDL_Window* window = NULL;
SDL_Renderer* renderer = NULL;

int init_window(int w, int h, const char* t) {
    SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO);
    window = SDL_CreateWindow(t, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, w, h, 0);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    return window && renderer ? 1 : 0;
}

void clear_screen() {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);
}

void draw_rect(int x, int y, int w, int h, int r, int g, int b) {
    SDL_SetRenderDrawColor(renderer, r, g, b, 255);
    SDL_Rect rect = {x, y, w, h};
    SDL_RenderFillRect(renderer, &rect);
}

void update_screen() {
    SDL_RenderPresent(renderer);
}

int is_key_pressed(const char* key) {
    const Uint8* state = SDL_GetKeyboardState(NULL);
    SDL_PumpEvents();
    return state[SDL_GetScancodeFromName(key)];
}

void get_mouse_pos(int* x, int* y) {
    SDL_GetMouseState(x, y);
}

int play_sound(const char* file) {
    SDL_AudioSpec spec;
    Uint32 len;
    Uint8* buf;
    if (!SDL_LoadWAV(file, &spec, &buf, &len)) return 0;
    SDL_AudioDeviceID dev = SDL_OpenAudioDevice(NULL, 0, &spec, NULL, 0);
    SDL_QueueAudio(dev, buf, len);
    SDL_PauseAudioDevice(dev, 0);
    return 1;
}

void cleanup() {
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
