package entrega3;

public class BuferTypes {
	int �tem; // valor del �tem producido que podr� ser cualquier valor entero
	int tipo; // puede tomar valores 1 � 2 seg�n el tipo del que sea

	synchronized public void decrementar(int cantidad) {
		while (cantidad > compar) {
			try {
				wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		compar -= cantidad;
		System.out.println("variable=" + compar);
	}
}
