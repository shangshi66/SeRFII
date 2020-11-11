import java.io.UnsupportedEncodingException;
import java.math.BigInteger;

public class Main {
  public static void main(String[] args) {
    try {
      byte[] hmacSha256 = HMAC.calcHmacSha256("secret123".getBytes("UTF-8"), "hello world".getBytes("UTF-8"));
      System.out.println(String.format("Hex: %032x", new BigInteger(1, hmacSha256))); 
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    }
  }
}