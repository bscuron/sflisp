public class LispPrimitiveEq extends LispPrimitive {

    public LispPrimitiveEq() {
        super('(eq OBJ1 OBJ2)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        if (args.car() == args.cdar()) {
            return LispT.INSTANCE;
        } else {
            return LispNil.INSTANCE;
        }
    }
}
