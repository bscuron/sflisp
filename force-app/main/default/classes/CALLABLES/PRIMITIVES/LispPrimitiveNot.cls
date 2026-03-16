public class LispPrimitiveNot extends LispPrimitive {

    public LispPrimitiveNot() {
        super('(not OBJECT)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        if (args.car().eval(env).isNil()) {
            return LispT.INSTANCE;
        } else {
            return LispNil.INSTANCE;            
        }
    }
}
