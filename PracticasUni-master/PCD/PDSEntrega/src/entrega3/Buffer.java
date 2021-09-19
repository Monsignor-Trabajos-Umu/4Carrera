package entrega3;

import java.util.LinkedList;

public class Buffer {

	private LinkedList<BuferTypes> lista = null;

	private Buffer unicaInstancia = null;

	public Buffer getBuffer() {
		if (unicaInstancia == null) {
			unicaInstancia = new Buffer();
		}
		return this.unicaInstancia;
	}

	private Buffer() {
		this.lista = new LinkedList<BuferTypes>();
	}

	synchronized public void add(BuferTypes a) {
		this.lista.addFirst(a);
	}

	synchronized public BuferTypes getLast() {
		return this.lista.getLast();
	}

}