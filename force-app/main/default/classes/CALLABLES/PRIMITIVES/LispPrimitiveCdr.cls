public class LispPrimitiveCdr extends LispPrimitive {

    public LispPrimitiveCdr() {
        super('(cdr LIST)');
    }

    public override LispObject apply(LispObject args, LispEnvironment env) {
        LispObject cons = args.car().eval(env);

        if (!(cons instanceof LispCons)) {
            throw new IllegalArgumentException('cdr expects a cons cell');
        }

        return ((LispCons)cons).cdr();
    }
}
