#include <stdio.h>
#include <stdlib.h>

#define mem_is_ok(m) (m!=NULL)

typedef struct node {
    int data;
    struct node *next;
} nodeL;

void insert_after(nodeL *elem, int data) {
    /* elem must be != null */
    nodeL *new_node = (nodeL*)malloc(sizeof(nodeL));

    if( !mem_is_ok(new_node) ){
        perror("malloc failed");
        exit(-1);
    }

    new_node->data = data;
    new_node->next = elem->next;
    elem->next = new_node;
}

void init_list(nodeL **HEAD, int firstData) {
    nodeL *new_node = (nodeL*)malloc(sizeof(nodeL));

    if( !mem_is_ok(new_node) ){
        perror("malloc failed");
        exit(-1);
    }

    new_node->data = firstData;
    new_node->next = NULL;
    *HEAD = new_node;
}

void print_list(nodeL *HEAD) {
    nodeL* sNode;
    printf("List:( ");
    for (sNode = HEAD; sNode != NULL; sNode = sNode->next) {
        printf("%d ", sNode->data);
    }
    printf(")\n");
}

nodeL* insertElement(nodeL *head, int data) {
    if ( head == NULL) {
        init_list(&head, data);
        return head;
    }

    nodeL *sNode;
    for (sNode = head; sNode->next != NULL && sNode->next->data < data; sNode = sNode->next);

    insert_after(sNode, data);

    return head;
}


int main (int argc, char *argv[]){
    nodeL *head = NULL;

    int a;
    do {
        printf("Give me a number: ");
        scanf("%d", &a);
        if( a==0 ){
            print_list(head);
        } else {
            head = insertElement(head, a);
        }
    } while( a!=0 );

    return 0;
}


