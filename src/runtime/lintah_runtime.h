#ifndef LINCAH_RUNTIME_H
#define LINCAH_RUNTIME_H

extern int init_window(int w, int h, const char* t);
extern void clear_screen();
extern void draw_rect(int x, int y, int w, int h, int r, int g, int b);
extern void update_screen();
extern int is_key_pressed(const char* key);
extern void get_mouse_pos(int* x, int* y);
extern int play_sound(const char* file);
extern void cleanup();

#endif
