public class LispNil extends LispObject {

    public static final LispNil INSTANCE = new LispNil();
    
    private LispNil() {}

    public override LispObject car() {
        return this;
    }

    public override LispObject cdr() {
        return this;
    }

    public override Boolean isNil() {
        return true;
    }

    public override Boolean isT() {
        return false;
    }

    public override String toString() {
        return 'nil';
    }

}
