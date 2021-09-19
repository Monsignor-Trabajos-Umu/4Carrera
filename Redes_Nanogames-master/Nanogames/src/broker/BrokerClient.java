package broker;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

/**
 * Cliente SNMP sin dependencias con otras clases y con funciones de consulta
 * específicas. En la actual versión sólo soporta una función de consulta sobre
 * el UPTIME del host.
 */
//Prueba
public class BrokerClient {
	private static final int PACKET_MAX_SIZE = 484;
	private static final int DEFAULT_PORT = 161;
	private static final String OID_UPTIME = "1.3.6.1.2.1.1.3.0";

	private DatagramSocket socket; // socket UDP
	private InetSocketAddress agentAddress; // direcciï¿½n del agente SNMP

	/**
	 * Constructor usando parámetros por defecto
	 */
	public BrokerClient(String agentAddress) {
		try {
			this.agentAddress = new InetSocketAddress(InetAddress.getByName(agentAddress), DEFAULT_PORT);
		} catch (UnknownHostException e1) {
			// TODO Auto-generated catch block
			System.err.println("Nombre de host desconocido\n" + e1);
		}

		try {
			this.socket = new DatagramSocket();
		} catch (SocketException e) {
			System.err.println("Erro en el socket\n" + e);
		}

		// Registrar dirección del servidor
		// Crear socket de cliente
	}

	private byte[] buildRequest() throws IOException {
		// mensaje GetRequest
		ByteArrayOutputStream request = new ByteArrayOutputStream();
		request.write(new byte[] { 0x30, 0x26 }); // Message (SEQUENCE)
		request.write(new byte[] { 0x02, 0x01, 0x00 }); // Version
		request.write(new byte[] { 0x04, 0x06 }); // Community
		request.write("public".getBytes());
		request.write(new byte[] { (byte) 0xa0, 0x19 }); // GetRequest
		request.write(new byte[] { (byte) 0x02, 0x01, 0x00 }); // RequestId
		request.write(new byte[] { (byte) 0x02, 0x01, 0x00 }); // ErrorStatus
		request.write(new byte[] { (byte) 0x02, 0x01, 0x00 }); // ErrorIndex
		request.write(new byte[] { (byte) 0x30, 0x0e }); // Bindings (SEQUENCE)
		request.write(new byte[] { (byte) 0x30, 0x0c }); // Bindings Child (SEQUENCE)
		request.write(new byte[] { (byte) 0x06 }); // OID
		byte[] oidArray = encodeOID(OID_UPTIME);
		request.write((byte) oidArray.length);
		request.write(oidArray);
		request.write(new byte[] { (byte) 0x05, 0x00 }); // Value (NULL)

		return request.toByteArray();

	}
	
	private long getTimeTicks(byte[] data) {
		ByteArrayInputStream response = new ByteArrayInputStream(data);

		// recuperamos timeTicks a partir de la respuesta
		int ch;
		while ((ch = response.read()) != -1) {
			if (ch == 0x43) { // TimeTicks
				int len = response.read();
				byte[] value = new byte[len];
				response.read(value, 0, len);
				return new BigInteger(value).longValue();
			}
		}
		return 0;
	}

	/**
	 * Envía un solicitud GET al agente para el objeto UPTIME
	 * 
	 * @return long
	 * @throws IOException
	 */
	public long getToken() throws IOException {

		// Construir solicitud
		
				byte[] Solicitud;
				try {
					Solicitud = buildRequest();
					DatagramPacket packet = new DatagramPacket(Solicitud, Solicitud.length, this.agentAddress);
					// Enviar solicitud
					try {
						socket.send(packet);
					} catch (IOException e1) {
						System.err.println("Tipo de direccion no soportada " + e1);
					}
					// Recibir respuesta
					byte[] response = new byte[PACKET_MAX_SIZE];
					packet = new DatagramPacket(response, response.length);
					boolean nerror = true;
					while (nerror) {
						try {
							socket.setSoTimeout(1000);
							socket.receive(packet);
							nerror = false;
						} catch (SocketTimeoutException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					// Extraer TimeTicks (Token)
					// Devolver token
					return getTimeTicks(response);
				} catch (IOException e2) {
					// TODO Auto-generated catch block
					System.err.println("Error en buildRequests " + e2);
					return 0;
				}
	}

	/**
	 * Codifica un OID según la especifación SNMP Nota: sólo soporta OIDs con
	 * números de uno o dos dígitos
	 * 
	 * @param oid
	 * @return
	 */
	private byte[] encodeOID(String oid) {
		// parsea OID
		String digits[] = oid.split("\\.");
		byte[] value = new byte[digits.length];
		for (int i = 0; i < digits.length; i++)
			value[i] = (byte) Byte.parseByte(digits[i]);

		// codifica OID
		byte[] ret = new byte[value.length - 1];
		byte x = value[0];
		byte y = value.length <= 1 ? 0 : value[1];
		for (int i = 1; i < value.length; i++) {
			ret[i - 1] = (byte) ((i != 1) ? value[i] : x * 40 + y);
		}
		return ret;
	}

	public void close() {
		socket.close();
	}
}
