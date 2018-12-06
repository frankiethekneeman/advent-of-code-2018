#include <stdio.h>
#include <stdlib.h>
struct Unit {
    char name;
    struct Unit *prev;
    struct Unit *next;
};

struct Unit* push(struct Unit* curr, struct Unit* next) {
    curr->next = next;
    next->prev = curr;
    return next;
}

struct Unit* pop(struct Unit* curr) {
    struct Unit* prev = curr->prev;
    curr->prev = NULL;
    prev->next = NULL;
    free(curr);
    return prev;
}

int destructable(char lower, char upper) {
    if (lower < upper) {
        return destructable(upper, lower);
    }
    return (lower - upper) == 32; //lower and uppercase letters differ by 32 in ascii
}

struct Unit* mkUnit(char name) {
    struct Unit* toReturn = (struct Unit*) malloc(sizeof(struct Unit));
    toReturn->name = name;
    toReturn->next = toReturn->prev = NULL;
    return toReturn;
}
 
int main() {
    char c;
    struct Unit* curr = mkUnit(EOF);
    while ((c = getchar()) != EOF) {
        if (c < 'A' || (c > 'Z' && c < 'a') || c > 'z') continue;
        struct Unit* next = mkUnit(c);
        if (destructable(curr->name, next->name)) {
            curr = pop(curr);
        } else {
            curr = push(curr, next);
        }
    }
    int i = 0;
    while (curr->name != EOF) {
        curr = curr->prev;
        i++;
    }
    printf("%d\n", i);
    return 0;
}

