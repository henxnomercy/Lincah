#ifndef FILELIB_H
#define FILELIB_H

#include <stdio.h>
#include <stdlib.h>

// Struktur untuk merepresentasikan file
typedef struct {
    FILE* fp;   // File pointer
    int error;  // Kode kesalahan (0 = sukses, lainnya = gagal)
} LincahFile;

// Struktur untuk daftar direktori
typedef struct {
    char** entries;
    int count;
} DirList;

// Fungsi dasar file
LincahFile* file_open(const char* filename, const char* mode);
int file_read(LincahFile* lf, char* buffer, size_t size);
int file_write(LincahFile* lf, const char* data, size_t size);
void file_close(LincahFile* lf);

// Fungsi manipulasi direktori
int dir_create(const char* path);
int dir_delete(const char* path);
DirList* dir_list(const char* path);
void dir_list_free(DirList* dl);

// Fungsi khusus untuk file .lich
char* lich_load(const char* filename);
int lich_save(const char* filename, const char* data);

// Fungsi lanjutan
int file_rename(const char* old_name, const char* new_name);
int file_move(const char* src, const char* dest);
int file_copy(const char* src, const char* dest);
int file_exists(const char* filename);
int file_delete(const char* filename);

// Penanganan kesalahan
int file_error(LincahFile* lf);
const char* file_error_message(int code);

#endif
