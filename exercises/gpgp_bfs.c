/***************************************************
 *     gpgp_bfs.c
 *
 * Author: Alan Blair, UNSW 2010
 * Supplied code for COMP3411 Artificial Intelligence
 * Solve the Graph Paper Grand Prix problem by
 * Breadth First Search, without checking for
 * repeated states
 *
 ***************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include "map.h"

#define MAX_STEP      1024

typedef struct state State;
typedef struct queue Queue;

/***************************************************
 *     state of the agent
 */
struct state {
  int r,c;
  int u,v;
  int f,g,h;
  State *parent; // preceding state in the trajectory
  State *next;   // next item in the queue
};

/***************************************************
 *     queue of states
 */
struct queue {
  State *head;
  State *tail;
};

State *new_state(int r,int c,int u,int v,State *parent)
{
  State *s = (State *)malloc(sizeof(State));
  if( s == NULL ) {
    printf("Error: failed to allocate memory.\n");
    exit(1);
  }

  s->r = r;  s->c = c;
  s->u = u;  s->v = v;

  s->parent = parent;
  s->next = NULL;

  return( s );
}

Queue *new_queue()
{
  Queue *q = (Queue *)malloc(sizeof(Queue));
  if( q == NULL ) {
    printf("Error: failed to allocate memory.\n");
    exit(1);
  }
  q->head = NULL;
  q->tail = NULL;

  return( q );
}

int is_empty( Queue *q )
{
  return(( q == NULL )||( q->head == NULL ));
}
  static int count1 = 0;
  static int max = 0;
void enqueue( State *s, Queue *q )
{

  count1++;
  if( q->head == NULL ) {
    q->head = q->tail = s;
  }
  else {
    q->tail->next = s;
    q->tail = s;
  }
}

State *dequeue( Queue *q )
{
  State *s;
  if (count1 > max){
    max = count1;
  }
  count1--;
  s = q->head;

  if( q->head != NULL ) {
    q->head = q->head->next;
    if( q->head == NULL ) {
      q->tail = NULL;
    }
  }

  return( s );
}

int main( void )
{
  State *s;
  State *s_new;
  Queue *queue_step[MAX_STEP] = {NULL};
  char *map[MAX_LINES];
  int line_length[MAX_LINES];
  int num_generated;
  int num_lines;
  int start_r,start_c;
  int goal_r, goal_c;
  int ch;
  int r,c,f,g,h,u,v;

  // scan map of the environment from standard input
  num_lines = scan_map( map, line_length, stdin );

  // find start and goal location
  for( r=0; r < num_lines; r++ ) {
    for( c=0; c < line_length[r]; c++ ) {
      ch = map[r][c];
      if( ch == 'o' ) {
        start_r = r;
        start_c = c;
      }
      else if( ch == 'x' ) {
        goal_r = r;
        goal_c = c;
      }
    }
  }

  // generate initial state
  s = new_state(start_r,start_c,0,0,NULL);
  s->g = 0;
  s->h = 0; // no heuristic for BFS
  s->f = s->g + s->h;
  queue_step[s->f] = new_queue();
  enqueue( s, queue_step[s->f] );
  num_generated = 1;

  f = s->f;

  // states are stored in an array of queues, indexed by f
  while( f < MAX_STEP ) {
    while(( f < MAX_STEP )&& is_empty(queue_step[f])) {
      f++;
    }
    if( f == MAX_STEP ) {
      printf("No Solution.\n");
      printf("Num nodes generated = %d\n", num_generated );
//printf("max nodes open at once = '%d'\n", max);
      return 0;
    }
    s = dequeue( queue_step[f] );
    if((s->r == goal_r)&&(s->c == goal_c)&&(s->u == 0)&&(s->v == 0)) {
      s = s->parent->parent;
      while( s->parent != NULL ) {
        map[s->r][s->c] = '0' + ( s->g % 10 );
        s = s->parent;
      }
      for( r=0; r < num_lines; r++ ) {
        for( c=0; c < line_length[r]; c++ ) {
          putchar( map[r][c] );
        }
        putchar('\n');
      }
      printf("Num nodes generated = %d\n", num_generated );
//printf("max nodes open at once = '%d'\n", max);
      return 0;
    }

    for( u = s->u-1; u <= s->u+1; u++ ) { 
      for( v = s->v-1; v <= s->v+1; v++ ) {
        r = s->r + u;
        c = s->c + v;
        if(  (r >= 0)&&(r < num_lines)&&(c >= 0)&&(c < line_length[r])
           && no_crash( s->r, s->c, r, c, map )) {
          g = s->g + 1;
          h = 0; // no heuristic for BFS
          if( g + h < MAX_STEP ) {
            s_new = new_state(r,c,u,v,s);
            s_new->g = g;
            s_new->h = h;
            s_new->f = g + h;
            if( queue_step[s_new->f] == NULL ) {
              queue_step[s_new->f] = new_queue();
            }
            enqueue( s_new, queue_step[s_new->f] );
            num_generated++;
          }
        }
      }
    }
  }
//printf("max nodes open at once = '%d'\n", max);
  return 0;
}





int huristic(){


   return 0;
}
