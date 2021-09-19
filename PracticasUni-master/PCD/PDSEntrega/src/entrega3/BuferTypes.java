package entrega3;

public class BuferTypes {
	int ítem; // valor del ítem producido que podrá ser cualquier valor entero
	int tipo; // puede tomar valores 1 ó 2 según el tipo del que sea

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
