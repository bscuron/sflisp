public class LispNumber extends LispObject {

    private Decimal value;

    public LispNumber(Decimal value) {
        this.value = value;
    }

    public Decimal unwrap() {
        return value;
    }

    public override String toString() {
        return value.toString();
    }

}
