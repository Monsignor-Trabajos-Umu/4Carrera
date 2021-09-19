/* Algoritmo de Jacobi */

#include <rsim_apps.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MIN(a,b) ((a) < (b) ? (a) : (b))

typedef volatile int Lock;
typedef int boolean;
#define FALSE 0
#define TRUE (!FALSE)

typedef struct
{
    int next_pid;
    double diff;
    boolean done;
    Lock lock;
    TreeBar barrier;
} GlobalMemory;

static GlobalMemory *global;

static int n = 40;
static double tolerance = 0.1;
static double **A;
static double **B;
static int fpb = 20;               
static int number_of_processes = 2;
static boolean verbose = FALSE;

static int num_iterations = 0;

static boolean parametros_usuario[8];

typedef struct
{
    double T0;
    double T1;
    double T2;
    double T3;
    double T4;
} InitialSetup;

static void
show (void)
{
    int i,j;

    for (i = 0; i < n + 2; ++i)
    {
        for (j = 0; j < n + 2; ++j)
        {
            printf ("%6.1f", A[i][j]);
        }
        printf ("\n");
    }
}

static void
solve (void)
{
    int pid;
    int block_index, row_offset, bpp;
    int i, j;
    double tmp_diff, mydiff, **tmp;

    newphase(1);                /* Fase correspondiente al cálculo paralelo */

    if (parametros_usuario[0]) { // LOCK_1
        GETLOCK (&global->lock);
    }

    /* Sección Crítica */
    pid = global->next_pid;
    global->next_pid++;


    if (parametros_usuario[0]) { // LOCK_1
        FREELOCK (&global->lock);
    }

    bpp = n/(fpb*number_of_processes);

    do
    {
      if (parametros_usuario[1]) { // TREEBAR_1
            TREEBAR (&global->barrier, pid);
        }

        ++num_iterations;
        mydiff = 0.0;

        if (parametros_usuario[2]) { // LOCK_2
            GETLOCK (&global->lock);
        }
        /* Sección Crítica */
        if (pid == 0) {
            global->diff = 0.0;
        }

        if (parametros_usuario[2]) { // LOCK_2
            FREELOCK (&global->lock);
        }

        if (parametros_usuario[3]) { // TREEBAR_2
            TREEBAR (&global->barrier, pid);
        }
                
        row_offset = 1 + pid*fpb;
        for (block_index = 0; block_index < bpp; block_index++)
        {
            for (i = 0; i < fpb; i++)
            {
                for (j = 1; j <= n; j++)
                {
                    B[i + row_offset][j] =
                        0.2 * (A[i + row_offset][j] + A[i + row_offset + 1][j] + A[i + row_offset][j + 1] + A[i + row_offset - 1][j] + A[i + row_offset][j-1]);
                    tmp_diff = fabs (B[i + row_offset][j] - A[i + row_offset][j]);
                    if (tmp_diff > mydiff) mydiff = tmp_diff;
                }
            }
            row_offset += number_of_processes*fpb;        
        }

        if (parametros_usuario[4]) { // LOCK_3
            GETLOCK (&global->lock);
        }
        /* Sección Crítica */
        if (mydiff > global->diff) 
            global->diff = mydiff;

        if (parametros_usuario[4]) { // LOCK_3
            FREELOCK (&global->lock);
        }

        if (parametros_usuario[5]) { // TREEBAR_3
            TREEBAR (&global->barrier, pid);
        }

        /* Las variables A, B y tmp son privadas (poque no han sido reservadas con shmalloc). */     
        /* Por tanto, tienen que ser intercambiadas por todos los hilos. */
        tmp = A;
        A = B;
        B = tmp;
        
        if (pid == 0) {
            if (global->diff < tolerance) 
                global->done = TRUE;

            if (verbose)
            {
                printf ("diff = %f\n", global->diff);
                fflush (stdout);
            }
        }

        if (parametros_usuario[6]) { // TREEBAR_4
            TREEBAR (&global->barrier, pid);
        }
    }
    while (!global->done);

    endphase();         /* Fin de la fase 1 */
    StatReportAll();  /* Muestra las estadísticas */
}

static void
initialize (InitialSetup *setup)
{
    int i,j;

    global = (GlobalMemory *) shmalloc (sizeof (GlobalMemory));

    A = (double **) shmalloc ((n + 2) * sizeof (double *));
    for (i = 0; i <= n + 1; i++)
        A[i] = (double *) shmalloc ((n + 2) * sizeof (double));
    if (parametros_usuario[7]) // ASSOCIATEADDRNODE
        AssociateAddrNode (&(A[0][0]), &(A[n+1][n+1]), 0, "A");

    B = (double **) shmalloc ((n + 2) * sizeof (double *));
    for (i = 0; i <= n + 1; i++)
        B[i] = (double *) shmalloc ((n + 2) * sizeof (double));
    if (parametros_usuario[7]) // ASSOCIATEADDRNODE
        AssociateAddrNode (&(B[0][0]), &(B[n+1][n+1]), 0, "B");

    global->next_pid = 0;
    TreeBarInit (&global->barrier, number_of_processes);

    for (i = 1; i <= n; ++i)
    {
        for (j = 1; j <= n; ++j)
        {
            A[i][j] = setup->T4;
        }
    }

    for (j = 1; j <= n; ++j)
    {
        A[0][j] = setup->T0;
        A[n + 1][j] = setup->T2;
        B[0][j] = setup->T0;
        B[n + 1][j] = setup->T2;
    }

    for (i = 0; i <= n + 1; ++i)
    {
        A[i][0] = setup->T1;
        A[i][n + 1] = setup->T3;
        B[i][0] = setup->T1;
        B[i][n + 1] = setup->T3;
    }
}

int
main (int argc, char *argv[])
{
    int i;
    InitialSetup setup;
    char fichero_parametros[128];
    FILE *p2f;

    MEMSYS_OFF;

    if (argc > 1)
    {
        n = atoi (argv[1]);
    }

    if (argc > 2)
    {
        number_of_processes = atoi (argv[2]);
    }

    if (argc > 3)
    {
        tolerance = atof (argv[3]);
    }

    if (argc > 4)
    {
        fpb = atoi (argv[4]);
    }

    if (fpb > n)
    {
        fprintf (stderr, "FPB demasiado grande.\n");
        return 1;
    }

    if ((n % fpb) != 0)
    {
        fprintf (stderr, "FPB no divide al tamaño.\n");
        return 1;
    }

    if (argc > 5)
    {
        verbose = atoi (argv[5]);
    }

    for (i = 0; i < 8; i++)
        parametros_usuario[i] = TRUE;

    if (argc > 6)
    {
        strncpy(fichero_parametros,argv[6],sizeof(fichero_parametros));
        if ((p2f = fopen(fichero_parametros, "r")) == NULL) {
            fprintf(stderr, "No puedo abrir el fichero %s\n", fichero_parametros);
            return 1;
        }

        for (i = 0; i < 8; i++) {
            parametros_usuario[i] = (fgetc(p2f) != '0');
            fgetc(p2f); /* espacio en blanco */
        }

        fclose(p2f);
    }


    setup.T0 = 150;
    setup.T1 = 70;
    setup.T2 = 150;
    setup.T3 = 70;
    setup.T4 = 10;

    printf ("N = %d, Número de hilos = %d, Tolerancia = %f, FPB = %d\n", n, number_of_processes, tolerance, fpb);

    printf("Flags de usuario: ");
    for (i = 0; i < 8; i++)
        printf("%d ", parametros_usuario[i]);
    printf("\n");


    initialize (&setup);
    if (verbose)
    {
        printf ("Estado inicial:\n");
        show ();
    }

    MEMSYS_ON;    

    for (i = 1; i < number_of_processes; i++)
    {
        if (fork () == 0)
        {
            solve ();
            return 0;
        }
    }
    solve ();

    printf ("Número de iteraciones: %d\n", num_iterations);
    if (verbose)
    {
        printf ("Estado final:\n");
        show ();
    }

    return 0;
}
