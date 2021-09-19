package enetrega2;

import java.util.LinkedList;
import java.util.Random;
import java.util.concurrent.Semaphore;
import java.util.stream.Collectors;

public class GenerarPalabra implements Runnable {

	Random random = new Random();
	Semaphore semInput,dumyLock;

	public GenerarPalabra(Semaphore semInput, Semaphore dumyLock) {
		this.semInput= semInput;
		this.dumyLock = dumyLock;
	}

	@Override
	public void run(){
		int targetStringLength = random.nextInt(10) + 1;
		// Primero generamos las palabras
		
		String diccionario = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		diccionario = diccionario.toLowerCase()+diccionario+"0123456789";
		int length = diccionario.length();
		char buf[] = new char[targetStringLength];
		for (int i = 0; i < targetStringLength; i++) {
			try {
				Thread.sleep(random.nextInt(1000));
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			buf[i] = diccionario.charAt(random.nextInt(length));
		}
		
		
		String generatedString = new String(buf);

		// Ahora tenemos que a�adir la palabra a la lista de palabras
		// Usamos un semaforo como un lock y otro como un contador
			try {
				dumyLock.acquire();
			} catch (InterruptedException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			Entrega2Main.listaPalabras.add(generatedString);
			dumyLock.release();
			semInput.release();
	
		//Aqui tenemos dos opciones, deberia de usar otro semaforo para bloquear el print pero me tomo
		//La libertad de usar un solo print ya que el propio print es thread safe.
		/*
		 * public void println(String x) {
		    synchronized (this) {
		        print(x);
		        newLine();
		    	}
			}
		 */
		Thread t = Thread.currentThread();
		//En vez de poner un wait until listaPalabras.lenght() = 30
		// Intento adquirir 30 permisos 
		try {
			semInput.acquire(30);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		LinkedList<String> allwords = (LinkedList<String>) Entrega2Main.listaPalabras.clone();
		//Ya puedo trabajar asincronamente
		semInput.release(30);
		String firstChar = Character.toString(generatedString.charAt(0));
		StringBuilder stringSalida = new StringBuilder();
		stringSalida.append("Hilo "+t.getId()+"\n");
		stringSalida.append("Todas las palabras "+ allwords.size()+" = " +allwords.toString()+"\n");
		stringSalida.append("Palabra hilo id = "+ generatedString+"\n");
		stringSalida.append("Palabras  que  empiezan  con  mi  letra = " +allwords.stream().filter(palabra->palabra.startsWith(firstChar)).collect(Collectors.toList()).toString()+"\n");
		stringSalida.append("Terminando Hilo "+t.getId()+"\n");
		
		System.out.println(stringSalida.toString());
		/*
		 * Hilo id
		 * Todas las palabras =(las 30 palabras generadas) 
		 * Palabra hiloid =(la palabra generada por el hilo)
		 * Palabras  que  empiezan  con  mi  letra=(las  palabras  que  empiezan  por  la  misma letra del hilo id)
		 * Terminando Hilo id
		 */
		
		
		
		
		
		

	}

}
