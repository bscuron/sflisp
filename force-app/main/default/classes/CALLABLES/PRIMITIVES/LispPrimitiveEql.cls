public class LispPrimitiveEql extends LispPrimitive {

    public LispPrimitiveEql() {
        super('(eql OBJ1 OBJ2)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject obj1 = args.car();
        LispObject obj2 = args.cdar();

        if (obj1 instanceof LispNumber && obj2 instanceof LispNumber) {
            if (((LispNumber)obj1).unwrap() == ((LispNumber)obj2).unwrap()) {
                return LispT.INSTANCE;
            } else {
                return LispNil.INSTANCE;
            }
        } else if (obj1 == obj2) {
            return LispT.INSTANCE;
        } else {
            return LispNil.INSTANCE;
        }
    }
}
