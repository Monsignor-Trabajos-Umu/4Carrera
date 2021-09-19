
#include <rsim_apps.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef int boolean;
#define FALSE 0
#define TRUE (!FALSE)

static int N = 80;
static double TOL = 0.1;
static boolean verbose = FALSE;

typedef double Configuracion[5];         /* Valores de temperatura por defecto */

double **A,**B,**aux;                /* Matrices */

void show(void)            /* Vuelca el contenido de la matriz por pantalla */
{
  int i,j;

  for (i = 0; i < N + 2; ++i)
  {
    for (j = 0; j < N + 2; ++j)
    {
      printf ("%6.1f ", A[i][j]);
    }
    printf ("\n");
  }
}

void initialize(Configuracion confAct)     /* inicializa las estructura del programa */
{
  int i,j;

  A = (double**) malloc (sizeof(double*)*(N+2));
  for (i=0;i<N+2;i++)
    A[i] = (double*) malloc(sizeof(double)*(N+2));
  B = (double**) malloc (sizeof(double*)*(N+2));
  for (i=0;i<N+2;i++)
    B[i] = (double*) malloc(sizeof(double)*(N+2));

  /* Anotamos la temperatura del cuerpo */
  for (i=0;i<=N+1;i++)
    for (j=0;j<=N+1;j++) {
      A[i][j] = confAct[4];
      B[i][j] = confAct[4];
    }

  /* Anotamos la temperatura de los bordes */
  for (j=1;j<=N;j++) {
    A[0][j] = confAct[0];
    B[0][j] = confAct[0];
  }

  for (j=1;j<=N;j++) {
    A[N+1][j] = confAct[2];
    B[N+1][j] = confAct[2];
  }

  for (i=0;i<N+2;i++) {
    A[i][0] = confAct[1];
    A[i][N+1] = confAct[3];
    B[i][0] = confAct[1];
    B[i][N+1] = confAct[3];
  }
}

void solve(void)           /* Procedimiento de resolución */
{
  int i,j;
  int numIterations;      /* Numero de iteraciones */
  double diff;            /* Diferencia más grande */
  double tmp_diff;
  char convergencia = 0;

  numIterations = 0;

  while (!convergencia) {
    numIterations++;
    diff = 0.0;
    /* Actualizamos los valores de temperatura */
    for (i = 1; i <= N; i++) {
      for (j = 1; j <= N; j++) {
        B[i][j] = 0.2*(A[i][j]+A[i-1][j]+A[i+1][j]+A[i][j-1]+A[i][j+1]);
        tmp_diff = fabs(B[i][j] - A[i][j]);
	if (tmp_diff > diff) diff = tmp_diff;
      }
    }
    convergencia = (diff < TOL);
    if (!convergencia) {
      /* Copiamos lo calculado en B en la matriz A para la siguiente iteración */
      /* por medio del puntero auxiliar */
      aux = A;
      A = B;
      B = aux;
    }
  }
  printf("Número de iteraciones en el procedimiento Solve: %d -- Diferencia: %4.4f\n",numIterations,diff);
}

int main(int argc, char** argv)
{
    int i;
    Configuracion confActual;

    MEMSYS_OFF;

    if (argc > 1)
    {
        N = atoi (argv[1]);
    }

    if (argc > 2)
    {
        TOL = atof (argv[2]);
    }
    if (argc > 3)

    {
        verbose = atoi (argv[3]);
    }



    confActual[0] = 150.0;
    confActual[1] = 70.0;
    confActual[2] = 150.0;
    confActual[3] = 70.0;
    confActual[4] = 10.0;

    initialize(confActual);
    if (verbose)
    {
	printf ("Initial state:\n");
	show ();
    }

    newphase(1);	/* Estadísticas para la Fase 1 */

    MEMSYS_ON;

    solve();
    endphase();
    StatReportAll();  /* Muestra las estadísticas */

    if (verbose)
    {
	printf ("Final state:\n");
	show ();
    }
	
    return 0;
}
