public class LispPrimitiveEqual extends LispPrimitive {

    public LispPrimitiveEqual() {
        super('(equal X Y)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        if (equal(args.car(), args.cdar())) {
            return LispT.INSTANCE;
        } else {
            return LispNil.INSTANCE;
        }
    }

    private Boolean equal(LispObject a, LispObject b) {
        if (a == b) {
            return true;
        } else if (a instanceof LispCons && b instanceof LispCons) {
            return equal(((LispCons)a).car(), ((LispCons)b).car()) && equal(((LispCons)a).cdr(), ((LispCons)b).cdr());
        } else if (a instanceof LispString && b instanceof LispString) {
            return ((LispString)a).toString().equals(((LispString)b).toString());
        } else if (a instanceof LispNumber && b instanceof LispNumber) {
            return ((LispNumber)a).unwrap() == ((LispNumber)b).unwrap();
        } else {
            return false;
        }
    }
}
