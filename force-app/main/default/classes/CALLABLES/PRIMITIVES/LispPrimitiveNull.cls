public class LispPrimitiveNull extends LispPrimitive {

    public LispPrimitiveNull() {
        super('(null OBJECT)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        return args.car().isNil() ? (LispObject)LispT.INSTANCE : (LispObject)LispNil.INSTANCE;
    }
}
