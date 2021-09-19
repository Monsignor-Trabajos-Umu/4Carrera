package enetrega2;

import java.util.LinkedList;
import java.util.concurrent.Semaphore;


public class Entrega2Main {
	
	
	public static volatile LinkedList<String> listaPalabras = new LinkedList<String>();
	
	public static void main(String[] args) {
		Semaphore dumyLock = new Semaphore(1);
		Semaphore semInput = new Semaphore(30);
		GenerarPalabra tareaGenerarPalabra = new GenerarPalabra(semInput,dumyLock);
		Thread threadtareaGenerarPalabra = null;
		for (int i = 0; i < 30; i++) {
			threadtareaGenerarPalabra = new Thread(tareaGenerarPalabra);
			//Adquiero un permit
			semInput.acquireUninterruptibly();
			threadtareaGenerarPalabra.start();
		}
		try {
			threadtareaGenerarPalabra.join();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
