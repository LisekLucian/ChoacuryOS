#pragma once

void shell_start();
void get_cpu_info(char* vendor, char* brand);
char *find_last_slash(char *str);
int starts_with(const char *str, const char *prefix);

#include "../drivers/filesystem/fat.h"

extern FAT_filesystem_t* s_fat_fs;
extern char currentDir[256];

// PSF1
#include "../drivers/vbe.h"
extern PSF1_FONT* font;
