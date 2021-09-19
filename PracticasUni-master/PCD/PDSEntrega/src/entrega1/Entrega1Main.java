package entrega1;

public class Entrega1Main {

	static final int MAXARRAY = 10;
	
	public volatile static int[] contadorGlobal = new int[MAXARRAY];
	
	public static void main(String[] args) {
		TareaHacerMatriz tareaHacerMatriz = new TareaHacerMatriz();
		Thread threadTareaHacerMatriz1 = new Thread(tareaHacerMatriz);
		Thread threadTareaHacerMatriz2 = new Thread(tareaHacerMatriz);
		Thread threadTareaHacerMatriz3 = new Thread(tareaHacerMatriz);
		threadTareaHacerMatriz1.start();
		threadTareaHacerMatriz2.start();
		threadTareaHacerMatriz3.start();
		
		
		try {
			threadTareaHacerMatriz1.join();
			threadTareaHacerMatriz2.join();
			threadTareaHacerMatriz3.join();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		
		
		
		
	}

}
