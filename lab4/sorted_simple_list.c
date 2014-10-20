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
    if (HEAD == NULL)
        return;
    printf("%d ", HEAD->data);
    print_list(HEAD->next);
}

nodeL* insertElement(nodeL *head, int data) {
    if ( head == NULL) {
        init_list(&head, data);
        return head;
    }

    nodeL *sNode;

    if( data < head->data){
        sNode = (nodeL*)malloc(sizeof(nodeL));

        if( !mem_is_ok(sNode) ){
            perror("malloc failed");
            exit(-1);
        }

        sNode->data = data;
        sNode->next = head;
        return sNode;
    }

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
            printf("List:( ");
            print_list(head);
            printf(")\n");
        } else {
            head = insertElement(head, a);
        }
    } while( a!=0 );

    return 0;
}


