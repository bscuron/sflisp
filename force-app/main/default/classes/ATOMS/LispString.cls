public class LispString extends LispObject {
    private String value;

    public LispString(String value) {
        this.value = value;
    }

    public override LispObject eval(LispEnvironment env) {
        return this;
    }

    public override String toString() {
        return value;
    }
}
