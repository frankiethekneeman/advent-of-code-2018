#include <stdio.h>
#include <stdlib.h>
struct Unit {
    char name;
    struct Unit *prev;
    struct Unit *next;
};

struct Unit* push(struct Unit* curr, struct Unit* next) {
    if (curr == NULL) return next;
    curr->next = next;
    next->prev = curr;
    return next;
}

//obliterate and return pointer to next
struct Unit* obliterate(struct Unit* curr) {
    if (curr->prev != NULL) curr->prev->next = curr->next;
    if (curr->next != NULL) curr->next->prev = curr->prev;

    struct Unit* toReturn = curr->next;
    free(curr);
    return toReturn;
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

struct Unit* copyOne(struct Unit* subject) {
    if (subject == NULL) return NULL;
    return mkUnit(subject -> name);
}

struct Unit* copyDown(struct Unit* subject) {
    struct Unit *curr, *head;
    curr = head = copyOne(subject);
    subject = subject->next;
    while (subject != NULL) {
        curr = push(curr, copyOne(subject));
        subject = subject->next;
    }
    return head;
}

int length(struct Unit* curr) {
    if (curr == NULL) return 0;
    int l = 1;
    while ((curr = curr->next) != NULL) l++;
    return l;
}

struct Unit* react (struct Unit* curr) {
    int headSafe = 0;
    struct Unit* head = curr;
    while (curr != NULL && curr->next != NULL) {
        if (destructable(curr->name, curr->next->name)) {
            curr = obliterate(obliterate(curr));
            if (curr != NULL && curr->prev != NULL) curr = curr->prev;
            if (!headSafe) head = curr;
        } else {
            headSafe = 1;
            curr = curr->next;
        }
    }
    return head;
}

struct Unit* without(struct Unit* curr, char toEliminate) {
    int headSafe = 0;
    struct Unit* head = curr;
    while (curr != NULL) {
        if (curr->name == toEliminate) {
            curr = obliterate(curr);
            if (!headSafe) head = curr;
        } else {
            headSafe = 1;
            curr = curr->next;
        }
    }
    return head;
}

int main() {
    char c;
    struct Unit *head, *curr;
    head = curr = NULL;
    while ((c = getchar()) != EOF) {
        if (c < 'A' || (c > 'Z' && c < 'a') || c > 'z') continue;
        struct Unit* next = mkUnit(c);
        curr = push(curr, next);
        if (head == NULL) head = curr;
    }
    int best = length(head);
    for( char offender = 'A'; offender <= 'Z'; offender++) {
        struct Unit * pared = without(without(copyDown(head), offender), offender + 32);
        int candidate = length(react(pared));
        if (candidate < best) best = candidate;
    }
    printf("%d\n", best);
    return 0;
}

