#include "kmalloc.h"
#include <drivers/utils.h>
#include <kernel/panic.h>

#define KMALLOC_STATIC_SIZE (1024 * 1024)

static u8 s_kmalloc_static[KMALLOC_STATIC_SIZE];

struct kmalloc_node {
    u32 data_size;
    bool free;
    _Alignas(16) u8 data[0];
};

static inline struct kmalloc_node* next_node(struct kmalloc_node* node) {
    u8* next_addr = (u8*)node + sizeof(struct kmalloc_node) + node->data_size;

    if (next_addr >= s_kmalloc_static + KMALLOC_STATIC_SIZE)
        return NULL;

    return (struct kmalloc_node*)next_addr;
}

void kmalloc_init() {
    struct kmalloc_node* node = (struct kmalloc_node*)s_kmalloc_static;
    node->free = true;
    node->data_size = KMALLOC_STATIC_SIZE - sizeof(struct kmalloc_node);
}

void* kmalloc(size_t size) {
    if (size == 0 || size >= KMALLOC_STATIC_SIZE)
        return NULL;

    if (size % 16 != 0)
        size += 16 - (size % 16);

    struct kmalloc_node* node = (struct kmalloc_node*)s_kmalloc_static;

    while (node && (!node->free || node->data_size < size)) {
        struct kmalloc_node* next = next_node(node);
        if (!next)
            return NULL;

        if (node->free && next->free) {
            node->data_size += sizeof(struct kmalloc_node) + next->data_size;
        } else {
            node = next;
        }
    }

    if (!node)
        return NULL;

    if (node->data_size > size + sizeof(struct kmalloc_node)) {
        u8* new_addr = (u8*)node + sizeof(struct kmalloc_node) + size;
        struct kmalloc_node* new_node = (struct kmalloc_node*)new_addr;

        new_node->free = true;
        new_node->data_size = node->data_size - size - sizeof(struct kmalloc_node);

        node->data_size = size;
    }

    node->free = false;
    return node->data;
}

void kfree(void* ptr) {
    if (!ptr)
        return;

    if ((u8*)ptr < s_kmalloc_static ||
        (u8*)ptr >= s_kmalloc_static + KMALLOC_STATIC_SIZE)
        panic("kfree called with pointer outside kmalloc memory");

    struct kmalloc_node* node =
        (struct kmalloc_node*)((u8*)ptr - sizeof(struct kmalloc_node));

    if (node->free)
        panic("kfree called on already-free pointer");

    node->free = true;
}
