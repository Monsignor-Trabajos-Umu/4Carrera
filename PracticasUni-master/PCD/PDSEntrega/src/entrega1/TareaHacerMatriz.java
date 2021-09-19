package entrega1;

import java.util.Random;
import java.util.concurrent.locks.ReentrantLock;

public class TareaHacerMatriz implements Runnable {
	static final int MAXARRAY = 10;
	ReentrantLock syncLock;

	public TareaHacerMatriz() {
		syncLock = new ReentrantLock();
	}

	@Override
	public void run() {
		Thread t = Thread.currentThread();
		for (int a = 0; a < 10; a++) {

			Random random = new Random();
			StringBuilder sbuilder = new StringBuilder();
			sbuilder.append("Array generado\r\n");
			int[][] myArray = new int[MAXARRAY][MAXARRAY];
			int[] contador = new int[MAXARRAY];
			for (int i = 0; i < MAXARRAY; i++) {
				for (int j = 0; j < MAXARRAY; j++) {
					int numero = random.nextInt(10);
					contador[numero]++;
					myArray[i][j] = numero;
					sbuilder.append(numero);
					sbuilder.append(" ");
				}
				sbuilder.append("\r\n");
			}

			syncLock.lock();
			try {
				System.out.println("Hilo " + t.getId());
				System.out.println(sbuilder.toString());
				for (int i = 0; i < MAXARRAY; i++) {
					Entrega1Main.contadorGlobal[i] += contador[i];
					String salidaContador = "Contador de " + i + " = " + Entrega1Main.contadorGlobal[i];
					System.out.println(salidaContador);
					
				}
				System.out.println("Terminando Hilo " + t.getId());
			} finally {
				syncLock.unlock();
			}

		}
		

	}

}
