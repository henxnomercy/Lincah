#include "filelib.h"
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

// Fungsi dasar file
LincahFile* file_open(const char* filename, const char* mode) {
    LincahFile* lf = malloc(sizeof(LincahFile));
    lf->fp = fopen(filename, mode);
    lf->error = lf->fp ? 0 : 1; // 1 = gagal membuka file
    return lf;
}

int file_read(LincahFile* lf, char* buffer, size_t size) {
    if (!lf || !lf->fp) {
        lf->error = 2; // File tidak valid
        return -1;
    }
    size_t read = fread(buffer, 1, size, lf->fp);
    lf->error = read < size ? 3 : 0; // 3 = baca tidak lengkap
    return read;
}

int file_write(LincahFile* lf, const char* data, size_t size) {
    if (!lf || !lf->fp) {
        lf->error = 2;
        return -1;
    }
    size_t written = fwrite(data, 1, size, lf->fp);
    lf->error = written < size ? 4 : 0; // 4 = tulis tidak lengkap
    return written;
}

void file_close(LincahFile* lf) {
    if (lf && lf->fp) fclose(lf->fp);
    free(lf);
}

// Fungsi manipulasi direktori
int dir_create(const char* path) {
    return mkdir(path, 0755) == 0 ? 0 : 5; // 5 = gagal membuat direktori
}

int dir_delete(const char* path) {
    return rmdir(path) == 0 ? 0 : 6; // 6 = gagal menghapus direktori
}

DirList* dir_list(const char* path) {
    DIR* dir = opendir(path);
    if (!dir) return NULL;

    DirList* dl = malloc(sizeof(DirList));
    dl->count = 0;
    dl->entries = NULL;

    struct dirent* entry;
    while ((entry = readdir(dir)) != NULL) {
        dl->entries = realloc(dl->entries, (dl->count + 1) * sizeof(char*));
        dl->entries[dl->count] = strdup(entry->d_name);
        dl->count++;
    }
    closedir(dir);
    return dl;
}

void dir_list_free(DirList* dl) {
    if (!dl) return;
    for (int i = 0; i < dl->count; i++) free(dl->entries[i]);
    free(dl->entries);
    free(dl);
}

// Fungsi khusus untuk file .lich
char* lich_load(const char* filename) {
    LincahFile* lf = file_open(filename, "r");
    if (!lf->fp) return NULL;

    fseek(lf->fp, 0, SEEK_END);
    long size = ftell(lf->fp);
    fseek(lf->fp, 0, SEEK_SET);

    char* buffer = malloc(size + 1);
    file_read(lf, buffer, size);
    buffer[size] = '\0';
    file_close(lf);
    return buffer;
}

int lich_save(const char* filename, const char* data) {
    LincahFile* lf = file_open(filename, "w");
    if (!lf->fp) return 1;

    int result = file_write(lf, data, strlen(data));
    file_close(lf);
    return result < 0 ? 7 : 0; // 7 = gagal menyimpan
}

// Fungsi lanjutan
int file_rename(const char* old_name, const char* new_name) {
    return rename(old_name, new_name) == 0 ? 0 : 8; // 8 = gagal rename
}

int file_move(const char* src, const char* dest) {
    return file_rename(src, dest); // Dalam sistem POSIX, rename juga memindahkan
}

int file_copy(const char* src, const char* dest) {
    LincahFile* src_file = file_open(src, "rb");
    if (!src_file->fp) return 9; // 9 = gagal membuka sumber

    LincahFile* dest_file = file_open(dest, "wb");
    if (!dest_file->fp) {
        file_close(src_file);
        return 10; // 10 = gagal membuka tujuan
    }

    char buffer[1024];
    int bytes;
    while ((bytes = file_read(src_file, buffer, sizeof(buffer))) > 0) {
        file_write(dest_file, buffer, bytes);
    }

    int error = src_file->error || dest_file->error ? 11 : 0; // 11 = gagal copy
    file_close(src_file);
    file_close(dest_file);
    return error;
}

int file_exists(const char* filename) {
    return access(filename, F_OK) == 0 ? 1 : 0;
}

int file_delete(const char* filename) {
    return unlink(filename) == 0 ? 0 : 12; // 12 = gagal hapus
}

// Penanganan kesalahan
int file_error(LincahFile* lf) {
    return lf ? lf->error : 2; // Default ke "file tidak valid" jika lf NULL
}

const char* file_error_message(int code) {
    switch (code) {
        case 0: return "Sukses";
        case 1: return "Gagal membuka file";
        case 2: return "File tidak valid";
        case 3: return "Pembacaan tidak lengkap";
        case 4: return "Penulisan tidak lengkap";
        case 5: return "Gagal membuat direktori";
        case 6: return "Gagal menghapus direktori";
        case 7: return "Gagal menyimpan file .lich";
        case 8: return "Gagal mengubah nama file";
        case 9: return "Gagal membuka file sumber";
        case 10: return "Gagal membuka file tujuan";
        case 11: return "Gagal menyalin file";
        case 12: return "Gagal menghapus file";
        default: return "Kesalahan tidak diketahui";
    }
}
